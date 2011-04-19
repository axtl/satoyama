# #_post_ Resource
# ####This module handles all HTTP actions on the _post_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'

# ###HTTP GET
get = (req, res, pid) ->
    r.c.get r.post_key(pid), (err, post) ->
        # Query the store for the post subkeys
        r.c.get r.post_key(pid, 'post_title'), (err, title) ->
            u.error(res) if err
            r.c.get r.post_key(pid, 'post_date'), (err, date) ->
                u.error(res) if err
                r.c.get r.post_key(pid, 'post_body'), (err, body) ->
                    u.error(res) if err
                    r.c.llen r.post_key(pid, 'comm.list'), (err, numc) ->
                        u.error(res) if err
                        # Return the requested post object
                        Post =
                            post_id: pid
                            post_title: title
                            post_date: date
                            post_body: body
                            numc: numc
                        u.ok(res, Post)

# ##HTTP POST
post = (req, res, pid) ->
    u.ok(res, 'POST post')

# ##HTTP DELETE
del = (req, res, pid) ->
    u.ok(res, 'DELETE post')

exports.get_post = get
exports.post_post = post
exports.del_post = del