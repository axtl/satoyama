# # Redis Helpers
# #### Facilities for interacting with the Redis datastore.

#
redis = require 'redis-node'

# Create a client to the local Redis store, and connect to the first database
client = redis.createClient()
client.select(0)

# Make the client object available to importing modules
exports.c = client


# Compute a post subkey
exports.post_key = (pid, segm) ->
    return "posts:#{pid}:#{segm}"


# Compute a post subkey to retrieve a comment
exports.comm = (pid, cid) ->
    return "posts:#{pid}:comm:#{cid}"


# Compute a comment subkey
exports.comm_key = (pid, cid, segm) ->
    return "#{exports.comm(pid, cid)}:#{segm}"
