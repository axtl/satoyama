# #Redis Helpers
# ####This module provides a number of facilities for interacting with the 
# ####Redis datastore. Primarily, it is used to map post and comments IDs to 
# ####the proper store keys.

# 
redis = require 'redis-node'

# Create a client to the local Redis store, and connect to the first database
client = redis.createClient()
client.select(0)

# Make the client object available to importing modules
exports.c = client

exports.post_key = (pid, segm) ->
    return "posts:#{pid}:#{segm}"

exports.comm = (pid, cid) ->
    return "posts:#{pid}:comm:#{cid}"

exports.comm_key = (pid, cid, segm) ->
    return "#{root.comm(pid, cid)}:#{segm}"
