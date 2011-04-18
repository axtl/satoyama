#!/usr/bin/env python
from gevent import monkey
monkey.patch_all()
from gevent.wsgi import WSGIServer
import gevent
from mimerender import mimerender
import red as r
import simplejson as json
import stache
import sys
import web

# mimerenders
render_json = lambda **args: json.dumps(args['ctx'])
render_txt = lambda **args: args['ctx']
html_index = lambda ctx: stache.Index().render()
html_posts = lambda ctx: stache.Posts(context=ctx).render()
html_post = lambda ctx: stache.Post(context=ctx).render()
html_comments = lambda ctx: stache.Comments(context=ctx).render()
html_comment = lambda ctx: stache.Comment(context=ctx).render()


def inredis(f):
    # determines if a post exists in redis before running the decorated func
    def wrap(*args, **kwargs):
        if len(args) < 1 or r.has(r.post_key(args[1], 'post_date', raw=True)):
            return f(*args, **kwargs)
        else:
            return web.notfound()
    return wrap


# Setup the appropriate routes for the server
urls = ('/posts/(\d+)/comments/(\d+)/?', 'comment',
        '/posts/(\d+)/comments/?', 'comments',
        '/posts/(\d+)/?', 'post',
        '/posts/?', 'posts',
        '/', 'index')


class index:

    @mimerender(default = 'html',
                html=html_index,
                json=render_json,
                txt=render_txt)
    def GET(self):
        return {'ctx': ''}


class posts:

    @mimerender(default = 'html',
                html=html_posts,
                json=render_json,
                txt=render_txt)
    def GET(self):
        num = r.len('post.list')
        post_idxs = r.get_list('post.list')
        posts = []
        for pid in post_idxs:
            title = r.post_key(pid, 'post_title')
            date = r.post_key(pid, 'post_date')
            posts.append({'post_title': title, 'post_date': date, 'url': pid})
        ctx = {'num_posts': num, 'posts': posts}
        return {'ctx': ctx}

    def POST(self):
        try:
            data = json.loads(web.data())
        except ValueError:
            data = web.input()
        r.post_add(data['post_title'], data['post_body'])
        raise web.seeother('.')

    def DELETE(self):
        r.posts_del()
        raise web.seeother('/')


class post:

    @inredis
    @mimerender(default = 'html',
                html=html_post,
                json=render_json,
                txt=render_txt)
    def GET(self, post_id):
        title = r.post_key(post_id, 'post_title')
        body = r.post_key(post_id, 'post_body')
        date = r.post_key(post_id, 'post_date')
        numc = r.len(r.post_key(post_id, 'comm.list', raw=True))
        ctx = {
            'post_id': post_id,
            'post_title': title,
            'post_body': body,
            'post_date': date,
            'numc': numc}
        return {'ctx': ctx}

    def POST(self, post_id):
        try:
            data = json.loads(web.data())
        except ValueError:
            data = web.input()
        r.post_update(post_id, data['post_title'], data['post_body'])
        raise web.seeother('.')

    def DELETE(self, post_id):
        r.post_del(post_id)
        raise web.seeother('..')


class comments:

    @r.inredis
    @mimerender(default = 'html',
                html=html_comments,
                json=render_json,
                txt=render_txt)
    def GET(self, post_id):
        comm_idxs = r.get_list(r.post_key(post_id, 'comm.list', raw=True))
        comments = []
        for cid in comm_idxs:
            body = r.comm(post_id, cid)
            date = r.comm_key(post_id, cid, 'date')
            comments.append({'url': cid, 'comm_body': body, 'comm_date': date})
        ctx = {'post_id': post_id, 'comments': comments}
        return {'ctx': ctx}

    def POST(self, post_id):
        try:
            data = json.loads(web.data())
        except ValueError:
            data = web.input()
        r.comm_add(post_id, data['comm_body'])
        raise web.seeother('.')

    def DELETE(self, post_id):
        r.comms_del(post_id)
        raise web.seeother('..')


class comment:

    @r.inredis
    @mimerender(default = 'html',
                html=html_comment,
                json=render_json,
                txt=render_txt)
    def GET(self, post_id, comm_id):
        body = r.comm(post_id, comm_id)
        date = r.comm_key(post_id, comm_id, 'comm_date')
        ctx = {
            'post_id': post_id,
            'comm_id': comm_id,
            'comm_body': body,
            'comm_date': date}
        return {'ctx': ctx}

    def POST(self, post_id, comm_id):
        try:
            data = json.loads(web.data())
        except ValueError:
            data = web.input()
        r.comm_update(post_id, comm_id, data['comm_body'])
        raise web.seeother('.')

    def DELETE(self, post_id, comm_id):
        r.comm_del(post_id, comm_id)
        raise web.seeother('..')

# Run the application
if __name__ == "__main__":
    application = web.application(urls, globals()).wsgifunc()
    try:
        sys.stdout.write('Serving on 8088...\n')
        sys.stdout.flush()
        WSGIServer(('', 8080), application).serve_forever()
    except KeyboardInterrupt:
        sys.stdout.write("Exiting...\n")
