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
    r.c.exists r.post_key(pid)
    # Retrieve the list of comment ids
    r.c.lrange r.post_key(pid, 'comm.list'), 0, -1, (err, comm_list) ->
        u.error res, err if err
        loaded_comms = []
        if comm_list.length == 0
            answer =
                post_id: pid
                comments: []
            u.ok res, answer
        else
            done = 0
            # Retrieve information on all stored posts
            for cid in comm_list
                done++
                do (cid, done) ->
                    # Query the store for the comment subkeys
                    r.c.get r.comm_key(pid, cid, 'comm_date'), (err, date) ->
                        u.error res, err if err
                        r.c.get r.comm(pid, cid), (err, body) ->
                            u.error res, err if err
                            # Store into the local list of retrieved posts
                            Comm =
                                url: cid
                                comm_date: date
                                comm_body: body
                            loaded_comms.push(Comm)
                            # Last item in our async queue? Send answer
                            if done == comm_list.length
                                answer =
                                    post_id: pid
                                    comments: loaded_comms
                                u.ok res, answer


# ###HTTP POST
post = (req, res, pid) ->
    content = ''
    # Register event handler to receive all mesage chunks
    req.addListener 'data', (chunk) ->
        content += chunk

    # End of transmission, parse content and create a new comment
    req.addListener 'end', ->
        new_comm = JSON.parse(content)
        comm_mod.comm_add pid, new_comm.comm_body
        u.ok res


# ###HTTP DELETE
del = (req, res, pid) ->
    # Return to caller immediately
    u.ok res
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