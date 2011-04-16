#!/usr/bin/env python
"""A web.py application powered by gevent"""
# https://bitbucket.org/denis/gevent/src/960ab8d1352f/examples/webpy.py
from gevent import monkey
monkey.patch_all()
from gevent.wsgi import WSGIServer
import gevent
import stache
import sys
import web

# turn on GEVENT?

WITH_GEVENT = True

# Setup the appropriate routes for the server
urls = ('/posts/(\d+)/comments/(\d+)/?', 'comment',
        '/posts/(\d+)/comments/?', 'comments',
        '/posts/(\d+)/?', 'post',
        '/posts/?', 'posts',
        '/', 'index')


class index:

    def GET(self):
        return stache.Index().render()


class posts:

    def GET(self):
        return stache.Posts().render()


class post:

    def GET(self, post_id):
        ctx = {'post_id': post_id}
        return stache.Post(context=ctx).render()


class comments:

    def GET(self, for_post_id):
        ctx = {'for_post_id': for_post_id}
        return stache.Comments(context=ctx).render()


class comment:

    def GET(self, for_post_id, comm_id):
        ctx = {'for_post_id': for_post_id, 'comm_id': comm_id}
        return stache.Comment(context=ctx).render()

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
