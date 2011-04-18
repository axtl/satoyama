clutch = require 'clutch'
posts = require './posts'
post = require './post'
comms = require './comms'
comm = require './comm'

index = (req, res) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('Satoyama\n')

posts_routes = clutch.route404([['GET /$', posts.get_posts],
                                ['POST /$', posts.post_posts],
                                ['DELETE /$', posts.del_posts]])

post_routes = clutch.route404([['GET /$', post.get_post],
                               ['POST /$', post.post_post],
                               ['DELETE /$', post.del_post]])

comms_routes = clutch.route404([['GET /$', comms.get_comms],
                                ['POST /$', comms.post_comms],
                                ['DELETE /$', comms.del_comms]])

comm_routes = clutch.route404([['GET /$', comm.get_comm],
                               ['POST /$', comm.post_comm],
                               ['DELETE /$', comm.del_comm]])


exports.urls = clutch.route404([['GET /$', index],
                                ['* /posts/?$', posts_routes],
                                ['* /posts/(\\d)/?$', post_routes],
                                ['* /posts/(\\d)/comments/?$', comms_routes],
                                ['* /posts/(\\d)/comments/(\\d)/?$', comm_routes]])

# # Setup the appropriate routes for the server
# urls = ('/posts/(\d+)/comments/(\d+)/?', 'comment',
#         '/posts/(\d+)/comments/?', 'comments',
#         '/posts/(\d+)/?', 'post',
#         '/posts/?', 'posts',
#         '/', 'index')

                                