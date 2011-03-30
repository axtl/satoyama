http = require 'http'

# The main server loop serves simple requests
serverLoop = (req, res) =>
  res.writeHead(200, {'Content-Type': 'text/plain'})
  res.end('Hello World\n')

# Construct the server and begin listening
http.createServer(serverLoop).listen(8808, "127.0.0.1");
console.log('Server running at http://127.0.0.1:8808/');
