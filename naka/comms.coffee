# #_posts_ Resource
# ####This module handles all HTTP actions on the _posts_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'
# Helpers for handling a single comment
comm_mod = require './comm'

# ###HTTP GET
get = (req, res, pid) ->
    loaded_comms = []
    # Retrieve the list of post ids
    r.c.lrange r.post_key(pid, 'comm.list'), 0, -1, (err, comm_list) ->
        u.error res if err
        done = 0
        # Retrieve information on all stored posts
        for cid in comm_list
            done++
            do (cid, done) ->
                # Query the store for the comment subkeys
                r.c.get r.comm_key(pid, cid, 'comm_date'), (err, date) ->
                    u.error res if err
                    r.c.get r.comm(pid, cid), (err, body) ->
                        u.error res if err
                        # Store into the local list of retrieved posts
                        Comm =
                            url: cid
                            comm_date: date
                            comm_body: body
                        loaded_comms.push(Comm)
                        # If this was the last item in our async queue, answer
                        if done == comm_list.length
                            answer =
                                post_id: pid
                                comments: loaded_comms
                            u.ok res, answer

# ###HTTP POST
post = (req, res, pid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('POST Comments\n')

# ###HTTP DELETEu.error(res) if err
del = (req, res, pid) ->
    # Return to caller immediately
    u.ok res, 'OK'
    # Async delete
    comms_delete pid

comms_delete = (pid) ->
    r.c.lrange r.post_key(pid, 'comm.list'), 0, -1, (err, comm_list) ->
        done = 0
        for cid in comm_list
            done++
            do (cid) ->
                comm_mod.comm_delete(pid, cid)
                if done == comm_list.length
                    r.c.del r.post_key(pid, 'comm.list')

exports.get_comms = get
exports.post_comms = post
exports.del_comms = del
exports.comms_delete = comms_delete