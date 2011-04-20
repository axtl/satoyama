# #HTTP Utilities
# ####This module provides simple utility functions that simplify HTTP
# ####responses.

# Respond with a 200 HTTP status code, and the JSON rendering of the answer

exports.ok = (res, answer) ->
    retval = JSON.stringify answer
    res.writeHead 200, headers(retval.length)
    res.end(retval)

# Respond with a 404 HTTP status code, resourcenot found
exports.notfound = (res, answer) ->
    res.writeHead 404, headers
    res.end()

# Respond with a 500 HTTP status code, indicating a server error has occurred
exports.error = (res) ->
    res.writeHead 500, headers
    res.end()

headers = (len=0) ->
    'Content-Type': 'application/json'
    'Server': 'nodejs/0.4.6'
    'Content-Length': len
    'Date': new Date().toUTCString()