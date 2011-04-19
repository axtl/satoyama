# #_post_ Resource
# ####This module handles all HTTP actions on the _post_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'

# ###HTTP GET
get = (req, res, post_id) ->
    r.c.get(r.post_key(post_id), (err, post) ->
        Post =
            post_id: post_id
            post_title: null
            post_date: null
            post_body: null
            numc: 0

        # Query the store for the post title...
        r.c.get(r.post_key(post_id, 'post_title'), (err, title) ->
            u.error(res) if err
            Post.post_title = title
            # ... and the post date
            r.c.get(r.post_key(post_id, 'post_date'), (err, date) ->
                u.error(res) if err
                Post.post_date = date
                r.c.get(r.post_key(post_id, 'post_body'), (err, body) ->
                    u.error(res) if err
                    Post.post_body = body
                    r.c.llen(r.post_key(post_id, 'comm.list'), (err, numc) ->
                        u.error(res) if err
                        Post.numc = numc
                        u.ok(res, Post)
                    )
                )
            )
        )
    )

# ##HTTP POST
post = (req, res, pid) ->
    u.ok(res, 'POST post')

# ##HTTP DELETE
del = (req, res, pid) ->
    u.ok(res, 'DELETE post')

exports.get_post = get
exports.post_post = post
exports.del_post = del