# #_post_ Resource
# ####This module handles all HTTP actions on the _post_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'
# Helpers for handling comments
comms_mod = require './comms'

# ###HTTP GET
get = (req, res, pid) ->
    r.c.exists r.post_key(pid, 'post_date'), (err, exists) ->
        u.error res if err
        u.notfound res if not exists
        # Query the store for the post subkeys
        r.c.get r.post_key(pid, 'post_title'), (err, title) ->
            u.error res if err
            r.c.get r.post_key(pid, 'post_date'), (err, date) ->
                u.error res if err
                r.c.get r.post_key(pid, 'post_body'), (err, body) ->
                    u.error res if err
                    r.c.llen r.post_key(pid, 'comm.list'), (err, numc) ->
                        u.error res if err
                        # Return the requested post object
                        Post =
                            post_id: pid
                            post_title: title
                            post_date: date
                            post_body: body
                            numc: numc
                        u.ok res, Post

# ##HTTP POST
post = (req, res, pid) ->
    u.ok res, 'POST post'

# ##HTTP DELETE
del = (req, res, pid) ->
    # Return to caller immediately
    u.ok res, 'OK'
    # Async delete
    post_delete pid

post_delete = (pid) ->
    # Remove list entry first, post should no longer be retrievable
    r.c.lrem 'post.list', 0, pid
    r.c.del r.post_key(pid, 'post_title')
    r.c.del r.post_key(pid, 'post_date')
    r.c.del r.post_key(pid, 'post_body')
    r.c.del r.post_key(pid, 'next.comm.id')
    comms_mod.comms_delete pid

exports.get_post = get
exports.post_post = post
exports.del_post = del
exports.post_delete = post_delete