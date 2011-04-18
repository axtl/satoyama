root = exports ? this

get = (req, res) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('GET Posts\n')

post = (req, res) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('POST Posts\n')

del = (req, res) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('DELETE Posts\n')

root.get_posts = get
root.post_posts = post
root.del_posts = del