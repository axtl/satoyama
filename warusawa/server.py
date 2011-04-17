#!/usr/bin/env python
from gevent import monkey
monkey.patch_all()
from gevent.wsgi import WSGIServer
import gevent
from mimerender import mimerender
import redis
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

# redis setup
r = redis.Redis(host='localhost', port=6379, db=0)


def _post(post_id, segm):
    # used to quickly compute the proper Redis key based on id and segment
    return 'posts:%s:%s' % (post_id, segm)


def _comm(post_id, comm_id):
    # compute the Redis key for the post/comment
    return 'posts:%s:comm:%s' % (post_id, comm_id)


def inredis(f):
    # determines if a post exists in redis before running the decorated func
    def wrap(*args, **kwargs):
        if len(args) > 1 and not r.exists(_post(args[1], 'post_id')):
            return web.notfound()
        else:
            return f(*args, **kwargs)
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
        num = r.get('next.post.id')
        post_idxs = r.lrange('post.list', 0, -1) # get all posts
        posts = []
        for pid in post_idxs:
            posts.append({'title': r[_post(pid, 'title')], 'url': pid})
        ctx = {'num_posts': num, 'posts': posts}
        return {'ctx': ctx}


class post:

    @inredis
    @mimerender(default = 'html',
                html=html_post,
                json=render_json,
                txt=render_txt)
    def GET(self, post_id):
        title = r[_post(post_id, 'title')]
        body = r[_post(post_id, 'body')]
        numc = r[_post(post_id, 'next.comm.id')]
        ctx = {'post_id': post_id, 'title': title, 'body': body, 'numc': numc}
        return {'ctx': ctx}


class comments:

    @inredis
    @mimerender(default = 'html',
                html=html_comments,
                json=render_json,
                txt=render_txt)
    def GET(self, post_id):
        comm_idxs = r.lrange(_post(post_id, 'comm.list'), 0, -1)
        comments = []
        for cid in comm_idxs:
            body = r[_comm(post_id, cid)]
            date = r[_comm(post_id, cid) + ':date']
            comments.append({'url': cid, 'body': body, 'date': date})
        ctx = {'post_id': post_id, 'comments': comments}
        return {'ctx': ctx}


class comment:

    @inredis
    @mimerender(default = 'html',
                html=html_comment,
                json=render_json,
                txt=render_txt)
    def GET(self, for_post_id, comm_id):
        ctx = {'for_post_id': for_post_id, 'comm_id': comm_id}
        return {'ctx': ctx}

# Run the application
if __name__ == "__main__":
    application = web.application(urls, globals()).wsgifunc()
    try:
        sys.stdout.write('Serving on 8088...\n')
        sys.stdout.flush()
        WSGIServer(('', 8080), application).serve_forever()
    except KeyboardInterrupt:
        sys.stdout.write("Exiting...\n")
