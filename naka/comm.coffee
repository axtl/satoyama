# #_post_ Resource
# ####This module handles all HTTP actions on the _post_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'

# ###HTTP GET
get = (req, res, pid, cid) ->
    r.c.get r.comm(pid, cid), (err, body) ->
        u.error res if err
        # Query the store for the post title...
        r.c.get r.comm_key(pid, cid, 'comm_date'), (err, date) ->
            u.error res if err
            Comm =
                post_id: pid
                comm_date: date
                comm_body: body
                comm_id: cid
            u.ok res, Comm

# ###HTTP POST
post = (req, res, pid, cid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('POST Comment\n')

# ###HTTP DELETE
del = (req, res, pid, cid) ->
    # Respond to caller immediately
    u.ok res, 'OK'
    # Async delete
    comm_delete pid, cid

comm_delete = (pid, cid) ->
    # Remove list entry first, comment should no longer be retrievable
    r.c.lrem r.post_key(pid, 'comm.list'), 0, cid
    r.c.del r.comm_key(pid, cid, 'comm_date')
    r.c.del r.comm(pid, cid)

exports.get_comm = get
exports.post_comm = post
exports.del_comm = del
exports.comm_delete = comm_delete