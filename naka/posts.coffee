# #_posts_ Resource
# ####This module handles all HTTP actions on the _posts_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'

# ###HTTP GET
get = (req, res) ->
    loaded_posts = []
    # Retrieve the list of post ids
    r.c.lrange 'post.list', 0, -1, (err, post_list) ->
        u.error(res) if err
        done = 0
        # Retrieve information on all stored posts
        for pid in post_list
            done++
            do (pid, done) ->
                # Query the store for the post title and date
                r.c.get r.post_key(pid, 'post_title'), (err, title) ->
                    u.error(res) if err
                    r.c.get r.post_key(pid, 'post_date'), (err, date) ->
                        u.error(res) if err
                        # Store into the local list of retrieved posts
                        Post =
                            post_title: title
                            post_date: date
                            url: pid
                        loaded_posts.push(Post)
                        # If this was the last item in our async queue, answer
                        if done == post_list.length
                            answer =
                                posts: loaded_posts
                                num_posts: post_list.length
                            u.ok(res, answer)

# ###HTTP POST
post = (req, res) ->
    u.ok(res, 'POST posts')

# ###HTTP DELETE
del = (req, res) ->
    u.ok(res, 'DELETE Posts')

# Export to importing modules
exports.get_posts = get
exports.post_posts = post
exports.del_posts = del
