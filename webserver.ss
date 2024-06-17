# webserver.ss

# Import necessary modules for HTTP server
import "http"
import "json"

# Define a WebServer class to handle routes and requests
class WebServer {
    var server
    var routes

    # Initialize the server and routes
    function init() {
        self.server = http.createServer(self.handleRequest)
        self.routes = {}
    }

    # Register a POST route
    function post(path, handler) {
        self.routes["POST:" + path] = handler
    }

    # Handle incoming requests
    function handleRequest(request, response) {
        let route = request.method + ":" + request.url
        if (self.routes[route]) {
            let body = ""
            request.on("data", (chunk) => {
                body += chunk
            })
            request.on("end", () => {
                let parsedBody = json.parse(body)
                request.body = parsedBody
                self.routes[route](request, response)
            })
        } else {
            response.writeHead(404, { "Content-Type": "application/json" })
            response.end(json.stringify({ success: false, message: "Not Found" }))
        }
    }

    # Start the server
    function listen(port, callback) {
        self.server.listen(port, callback)
    }
}

# Export the WebServer class
export WebServer
