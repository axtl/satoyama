# # Application Routes#
# #### This module sets up all the appropriate HTTP route mappings.

# Routing capabilities
clutch = require 'clutch'
# Utilities
u = require './util'
# Specific handlers for each API resource
posts = require './posts'
post = require './post'
comms = require './comms'
comm = require './comm'


# /
index = (req, res) ->
    u.ok res, {Satoyama: "Kon'nichiwa"}


# ### HTTP methods for _posts_
posts_routes = clutch.route404([['GET $', posts.get_posts],
                                ['POST $', posts.post_posts],
                                ['DELETE $', posts.del_posts]])


# ### HTTP methods for each _post_
post_routes = clutch.route404([['GET $', post.get_post],
                               ['POST $', post.post_post],
                               ['DELETE $', post.del_post]])


# ### HTTP methods for _comments_
comms_routes = clutch.route404([['GET $', comms.get_comms],
                                ['POST $', comms.post_comms],
                                ['DELETE $', comms.del_comms]])


# ### HTTP methods for each _comment_
comm_routes = clutch.route404([['GET $', comm.get_comm],
                               ['POST $', comm.post_comm],
                               ['DELETE $', comm.del_comm]])


# ### HTTP Routes
# Delegate specific URL paths to route handlers. Any regex matches are passed
# as arguments to the handler function.
urls = clutch.route404([['GET /$', index],
                        ['* /posts/?$', posts_routes],
                        ['* /posts/(\\d+)/?$', post_routes],
                        ['* /posts/(\\d+)/comments/?$', comms_routes],
                        ['* /posts/(\\d+)/comments/(\\d+)/?$', comm_routes]])


# Make the URL routes available to importing modules
exports.urls = urls
