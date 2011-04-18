root = exports ? this

get = (req, res, pid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('GET Post ' + pid + '\n')

post = (req, res, pid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('POST Post\n')

del = (req, res, pid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('DELETE Post\n')

root.get_post = get
root.post_post = post
root.del_post = del