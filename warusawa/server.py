#!/usr/bin/env python
"""A web.py application powered by gevent"""
# https://bitbucket.org/denis/gevent/src/960ab8d1352f/examples/webpy.py
from gevent import monkey
monkey.patch_all()
from gevent.wsgi import WSGIServer
import gevent
from mimerender import mimerender
import simplejson as json
import stache
import sys
import web

# turn on GEVENT?
WITH_GEVENT = True

render_json = lambda **args: json.dumps(args['ctx'])
render_txt = lambda **args: args['ctx']
html_index = lambda ctx: stache.Index().render()
html_posts = lambda ctx: stache.Posts().render()
html_post = lambda ctx: stache.Post(context=ctx).render()
html_comments = lambda ctx: stache.Comments(context=ctx).render()
html_comment = lambda ctx: stache.Comment(context=ctx).render()


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
        return {'ctx':''}


class posts:

    @mimerender(default = 'html',
                html=html_posts,
                json=render_json,
                txt=render_txt)
    def GET(self):
        return {'ctx':''}


class post:

    @mimerender(default = 'html',
                html=html_post,
                json=render_json,
                txt=render_txt)
    def GET(self, post_id):
        ctx = {'post_id': post_id}
        return {'ctx': ctx}


class comments:

    @mimerender(default = 'html',
                html=html_comments,
                json=render_json,
                txt=render_txt)
    def GET(self, for_post_id):
        ctx = {'for_post_id': for_post_id}
        return {'ctx': ctx}


class comment:

    @mimerender(default = 'html',
                html=html_comment,
                json=render_json,
                txt=render_txt)
    def GET(self, for_post_id, comm_id):
        ctx = {'for_post_id': for_post_id, 'comm_id': comm_id}
        return {'ctx': ctx}

# Run the application
if __name__ == "__main__":
    if not WITH_GEVENT:
        application = web.application(urls, globals())
        application.run()
    else:
        application = web.application(urls, globals()).wsgifunc()
        try:
            sys.stdout.write('Serving on 8088...\n')
            sys.stdout.flush()
            WSGIServer(('', 8080), application).serve_forever()
        except KeyboardInterrupt:
            sys.stdout.write("Exiting...\n")
