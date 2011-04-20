# #_posts_ Resource
# ####This module handles all HTTP actions on the _posts_ resource.

# Helpers for Redis interaction
r = require './red'
# Helpers for general response handling
u = require './util'
# Helpers for handling single posts
post_mod = require './post'

# ###HTTP GET
get = (req, res) ->
    # Retrieve the list of post ids
    r.c.lrange 'post.list', 0, -1, (err, post_list) ->
        u.error res if err
        loaded_posts = []
        if post_list.length == 0
            answer = 
                posts: []
                num_posts: 0
            u.ok res, answer
        else
            done = 0
            # Retrieve information on all stored posts
            for pid in post_list
                done++
                do (pid, done) ->
                    # Query the store for the post title and date
                    r.c.get r.post_key(pid, 'post_title'), (err, title) ->
                        u.error res if err
                        r.c.get r.post_key(pid, 'post_date'), (err, date) ->
                            u.error res if err
                            # Store into the local list of retrieved posts
                            Post =
                                post_title: title
                                post_date: date
                                url: pid
                            loaded_posts.push Post
                            # Last item in our async queue? Send answer
                            if done == post_list.length
                                answer =
                                    posts: loaded_posts
                                    num_posts: post_list.length
                                u.ok res, answer


# ###HTTP POST
post = (req, res) ->
    content = ''
    req.addListener 'data', (chunk) ->
        content += chunk

    req.addListener 'end', -> 
        new_post = JSON.parse(content)
        post_mod.post_add new_post.post_title, new_post.post_body
        u.ok res

# ###HTTP DELETE
del = (req, res) ->
    # Return to caller immediately
    u.ok res, 'OK'
    # Delete async
    r.c.lrange 'post.list', 0, -1, (err, post_list) ->
        console.log err if err
        done = 0
        for pid in post_list
            done++
            do (pid, done) ->
                post_mod.post_delete pid
                if done == post_list.length
                    r.c.del 'post.list'

# Export to importing modules
exports.get_posts = get
exports.post_posts = post
exports.del_posts = del
