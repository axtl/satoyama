# #HTTP Utilities
# ####This module provides simple utility functions that simplify HTTP 
# ####responses.

# Default and only content type for all API methods.
ctype = {'Content-Type': 'application/json'}

# Respond with a 200 HTTP status code, and the JSON rendering of the answer
exports.ok = (res, answer) ->
    res.writeHead(200, {'Content-Type': 'application/json'})
    res.end(JSON.stringify(answer))

# Respond with a 404 HTTP status code, resourcenot found
exports.notfound = (res, answer) ->
    res.writeHead(404)
    res.end()

# Respond with a 500 HTTP status code, indicating a server error has occurred
exports.error = (res) ->
    res.writeHead(500)
    res.end()
