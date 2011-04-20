# # HTTP Utilities
# #### Utility functions for simpler HTTP responses.

# ### 200 OK
exports.ok = (res, answer=null) ->
    if answer
        retval = JSON.stringify answer
        res.writeHead 200, headers(len=retval.length)
        res.end(retval)
    else
        res.writeHead 200, headers
        res.end()


# ### 303 Moved Temporarily
exports.seeother = (res, loc_part) ->
    res.writeHead 303, headers(loc=nextloc)
    res.end()


# ### 404 Not Found
exports.notfound = (res, answer) ->
    res.writeHead 404, headers
    res.end()


# ### 500 Server Error
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
