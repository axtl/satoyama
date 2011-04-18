root = exports ? this

get = (req, res, pid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('GET Comments for post ' + pid + '\n')

post = (req, res, pid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('POST Comments\n')

del = (req, res, pid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('DELETE Comments\n')

root.get_comms = get
root.post_comms = post
root.del_comms = del