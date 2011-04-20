# #_post_ Resource
# ####This module handles all HTTP actions on the _post_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'


# ###HTTP GET
get = (req, res, pid, cid) ->
    r.c.exists r.comm(pid, cid), (err, exists) ->
        u.error res, err if err
        u.notfound res if not exists
        r.c.get r.comm(pid, cid), (err, body) ->
            u.error res, err if err
            # Query the store for the post title...
            r.c.get r.comm_key(pid, cid, 'comm_date'), (err, date) ->
                u.error res, err if err
                Comm =
                    post_id: pid
                    comm_date: date
                    comm_body: body
                    comm_id: cid
                u.ok res, Comm


# ###HTTP POST
post = (req, res, pid, cid) ->
    content = ''
    # Register event handler to receive all mesage chunks
    req.addListener 'data', (chunk) ->
        content += chunk

    # End of transmission, parse content and update the post
    req.addListener 'end', ->
        up_comm = JSON.parse(content)
        comm_update pid, cid, up_comm.comm_body
        u.ok res


# ###HTTP DELETE
del = (req, res, pid, cid) ->
    # Respond to caller immediately
    u.ok res
    # Async delete
    comm_delete pid, cid


comm_add = (pid, comm_body) ->
    r.c.incr r.post_key(pid, 'next.comm.id'), (err, ncid) ->
        u.error res, err if err
        r.c.lpush r.post_key(pid, 'comm.list'), ncid
        comm_update(pid, ncid, comm_body)


comm_update = (pid, cid, comm_body) ->
    r.c.set r.comm(pid, cid), comm_body
    r.c.set r.comm_key(pid, cid, 'comm_date'), new Date().toUTCString()


post_update = (pid, post_title, post_body) ->
    r.c.set r.post_key(pid, 'post_title'), post_title
    r.c.set r.post_key(pid, 'post_body'), post_body
    r.c.set r.post_key(pid, 'post_date'), new Date().toUTCString()


comm_delete = (pid, cid) ->
    # Remove list entry first, comment should no longer be retrievable
    r.c.lrem r.post_key(pid, 'comm.list'), 0, cid
    r.c.del r.comm_key(pid, cid, 'comm_date')
    r.c.del r.comm(pid, cid)


exports.get_comm = get
exports.post_comm = post
exports.del_comm = del
exports.comm_add = comm_add
exports.comm_delete = comm_delete