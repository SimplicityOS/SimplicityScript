# server.ss

# Import necessary modules
import "database.ss"
import "webserver.ss"
import "bcrypt"
import "nodemailer"

# Configure the MySQL database connection
var db = Database("mysql://username:password@localhost/messaging_system")

# Initialize the web server
var app = WebServer()

# User registration endpoint
app.post("/register", (request, response) => {
    let { username, password, email } = request.body
    let hashedPassword = bcrypt.hashSync(password, 10)
    let result = db.query("INSERT INTO users (username, password, email) VALUES (?, ?, ?)", [username, hashedPassword, email])
    
    if (result.success) {
        response.writeHead(200, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: true }))
    } else {
        response.writeHead(400, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: false, message: "Registration failed. Username or email might already be taken." }))
    }
})

# User login endpoint
app.post("/login", (request, response) => {
    let { username, password } = request.body
    let result = db.query("SELECT id, password FROM users WHERE username = ?", [username])
    
    if (result.success && result.rows.length > 0) {
        let user = result.rows[0]
        if (bcrypt.compareSync(password, user.password)) {
            response.writeHead(200, { "Content-Type": "application/json" })
            response.end(json.stringify({ success: true, user: { id: user.id, username } }))
        } else {
            response.writeHead(401, { "Content-Type": "application/json" })
            response.end(json.stringify({ success: false, message: "Incorrect password." }))
        }
    } else {
        response.writeHead(404, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: false, message: "User not found." }))
    }
})

# Password recovery endpoint
app.post("/recover", (request, response) => {
    let { email } = request.body
    let recoveryCode = generateRecoveryCode()
    let result = db.query("UPDATE users SET recovery_code = ? WHERE email = ?", [recoveryCode, email])
    
    if (result.success) {
        sendRecoveryEmail(email, recoveryCode)
        response.writeHead(200, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: true, message: "Recovery email sent." }))
    } else {
        response.writeHead(404, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: false, message: "Email not found." }))
    }
})

# Send message endpoint
app.post("/send_message", (request, response) => {
    let { sender, content } = request.body
    let result = db.query("INSERT INTO messages (sender_id, content) VALUES (?, ?)", [sender, content])
    
    if (result.success) {
        response.writeHead(200, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: true }))
    } else {
        response.writeHead(400, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: false, message: "Message sending failed." }))
    }
})

# Get friends endpoint
app.post("/friends", (request, response) => {
    let { user_id } = request.body
    let result = db.query("SELECT friend_id FROM friends WHERE user_id = ?", [user_id])
    
    if (result.success) {
        let friends = result.rows.map(row => db.query("SELECT username FROM users WHERE id = ?", [row.friend_id]).rows[0])
        response.writeHead(200, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: true, friends }))
    } else {
        response.writeHead(400, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: false, message: "Failed to load friends." }))
    }
})

# Get messages endpoint
app.post("/messages", (request, response) => {
    let { user_id } = request.body
    let result = db.query("SELECT sender_id, content FROM messages WHERE receiver_id = ? OR sender_id = ?", [user_id, user_id])
    
    if (result.success) {
        let messages = result.rows.map(row => ({
            sender: db.query("SELECT username FROM users WHERE id = ?", [row.sender_id]).rows[0].username,
            content: row.content
        }))
        response.writeHead(200, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: true, messages }))
    } else {
        response.writeHead(400, { "Content-Type": "application/json" })
        response.end(json.stringify({ success: false, message: "Failed to load messages." }))
    }
})

# Helper functions
function generateRecoveryCode() {
    # Implement recovery code generation
    return Math.random().toString(36).substring(2, 10)
}

function sendRecoveryEmail(email, recoveryCode) {
    let transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'your-email@gmail.com',
            pass: 'your-email-password'
        }
    })

    let mailOptions = {
        from: 'your-email@gmail.com',
        to: email,
        subject: 'Password Recovery',
        text: `Your recovery code is: ${recoveryCode}`
    }

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.log(error)
        } else {
            console.log('Email sent: ' + info.response)
        }
    })
}

# Start the web server
app.listen(8080, () => {
    print("Server is running on port 8080")
})
