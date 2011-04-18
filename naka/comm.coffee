root = exports ? this

get = (req, res, pid, cid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('GET Comment ' + cid + ' for post ' + pid + '\n')

post = (req, res, pid, cid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('POST Comment\n')

del = (req, res, pid, cid) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end('DELETE Comment\n')

root.get_comm = get
root.post_comm = post
root.del_comm = del