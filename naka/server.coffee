# #SERVER

#
http = require 'http'
# The `app` module sets up the appropriate HTTP routes for the application
app = require './app'


# Start the server with the given URL routes
http.createServer(app.urls).listen(8080, "127.0.0.1")
console.log 'Server running at http://127.0.0.1:8080/'
