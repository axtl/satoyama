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
urls = ('/post-(\d+)/comment-(\d+)/?', 'comment',
        '/post-(\d+)/comments/?', 'comments',
        '/post-(\d+)/?', 'post',
        '/posts/?', 'posts',
        '/', 'index')


class index:

    def GET(self):
        return stache.Index().render()


class posts:

    def GET(self):
        return "posts? what posts?"
        return stache.Index


class post:

    def GET(self, post_id):
        return "post_id: " + str(post_id)


class comments:

    def GET(self, for_post_id):
        return "comments for_post_id: " + str(for_post_id)


class comment:

    def GET(self, for_post_id, comm_id):
        return "for_post_id: " + str(for_post_id) + " comm_id: " + str(comm_id)

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
