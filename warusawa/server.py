#!/usr/bin/env python
"""A web.py application powered by gevent"""
# https://bitbucket.org/denis/gevent/src/960ab8d1352f/examples/webpy.py

from gevent import monkey
monkey.patch_all()
from gevent.wsgi import WSGIServer
import gevent
import sys
import web

# Setup the appropriate routes for the server
urls = ("/", "index")


class index:

    # GET /
    def GET(self):
        return 'Hello, world!'


# Run the application
if __name__ == "__main__":
    application = web.application(urls, globals()).wsgifunc()
    try:
        sys.stdout.write('Serving on 8088...\n')
        sys.stdout.flush()
        WSGIServer(('', 8088), application).serve_forever()
    except KeyboardInterrupt:
        sys.stdout.write("Exiting...\n")
