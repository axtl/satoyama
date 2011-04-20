# #HTTP Utilities
# ####This module provides simple utility functions that simplify HTTP
# ####responses.

# Respond with a 200 HTTP status code, and the JSON rendering of the answer
exports.ok = (res, answer=null) ->
    if answer
        retval = JSON.stringify answer
        res.writeHead 200, headers(len=retval.length)
        res.end(retval)
    else
        res.writeHead 200, headers
        res.end()

# Respond with a 303 HTTP status code, tell client to go to a different page
exports.seeother = (res, loc_part) ->
    res.writeHead 303, headers(loc=nextloc)
    res.end()

# Respond with a 404 HTTP status code, resource not found
exports.notfound = (res, answer) ->
    res.writeHead 404, headers
    res.end()

# Respond with a 500 HTTP status code, indicating a server error has occurred
exports.error = (res, err) ->
    res.writeHead 500, headers
    res.end()
    console.log err

# Helper function to set the proper headers on the response
headers = (len=0, loc=null) ->
    'Content-Type': 'application/json'
    'Server': 'nodejs/0.4.6'
    'Content-Length': len
    'Date': new Date().toUTCString()
