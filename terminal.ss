# Import necessary modules
import "filesystem.ss"
import "process.ss"
import "network.ss"
import "system.ss"

# Terminal class
class Terminal {
    var currentPath = "/"

    # Start the terminal
    function start() {
        print("Welcome to SimplicityOS Terminal")
        while (true) {
            self.showPrompt()
            let command = self.readCommand()
            self.executeCommand(command)
        }
    }

    # Display the prompt
    function showPrompt() {
        print(self.currentPath + " $ ", false)
    }

    # Read the command from the user
    function readCommand() {
        let command = readline()
        return command.split(" ")
    }

    # Execute the command
    function executeCommand(commandParts) {
        let command = commandParts[0]
        let args = commandParts.slice(1)

        if (command == "ls") {
            self.listDirectory(args)
        } else if (command == "cd") {
            self.changeDirectory(args)
        } else if (command == "cat") {
            self.displayFile(args)
        } else if (command == "echo") {
            self.echo(args)
        } else if (command == "mkdir") {
            self.makeDirectory(args)
        } else if (command == "rm") {
            self.removeFile(args)
        } else if (command == "mv") {
            self.moveFile(args)
        } else if (command == "cp") {
            self.copyFile(args)
        } else if (command == "ping") {
            self.ping(args)
        } else if (command == "sysinfo") {
            self.systemInfo()
        } else if (command == "exit") {
            self.exit()
        } else {
            print("Command not found: " + command)
        }
    }

    # List directory contents
    function listDirectory(args) {
        let path = self.resolvePath(args.length > 0 ? args[0] : self.currentPath)
        let files = FileSystem.readdir(path)
        files.forEach((file) => {
            print(file)
        })
    }

    # Change directory
    function changeDirectory(args) {
        if (args.length == 0) {
            print("No directory specified")
            return
        }

        let path = self.resolvePath(args[0])
        if (FileSystem.isDirectory(path)) {
            self.currentPath = path
        } else {
            print("Directory not found: " + args[0])
        }
    }

    # Display file contents
    function displayFile(args) {
        if (args.length == 0) {
            print("No file specified")
            return
        }

        let path = self.resolvePath(args[0])
        if (FileSystem.isFile(path)) {
            let content = FileSystem.readFile(path)
            print(content)
        } else {
            print("File not found: " + args[0])
        }
    }

    # Echo command
    function echo(args) {
        print(args.join(" "))
    }

    # Make directory
    function makeDirectory(args) {
        if (args.length == 0) {
            print("No directory name specified")
            return
        }

        let path = self.resolvePath(args[0])
        if (FileSystem.makeDirectory(path)) {
            print("Directory created: " + path)
        } else {
            print("Failed to create directory: " + path)
        }
    }

    # Remove file or directory
    function removeFile(args) {
        if (args.length == 0) {
            print("No file or directory specified")
            return
        }

        let path = self.resolvePath(args[0])
        if (FileSystem.remove(path)) {
            print("Removed: " + path)
        } else {
            print("Failed to remove: " + path)
        }
    }

    # Move file or directory
    function moveFile(args) {
        if (args.length < 2) {
            print("Source and destination paths required")
            return
        }

        let source = self.resolvePath(args[0])
        let destination = self.resolvePath(args[1])
        if (FileSystem.move(source, destination)) {
            print("Moved: " + source + " to " + destination)
        } else {
            print("Failed to move: " + source)
        }
    }

    # Copy file or directory
    function copyFile(args) {
        if (args.length < 2) {
            print("Source and destination paths required")
            return
        }

        let source = self.resolvePath(args[0])
        let destination = self.resolvePath(args[1])
        if (FileSystem.copy(source, destination)) {
            print("Copied: " + source + " to " + destination)
        } else {
            print("Failed to copy: " + source)
        }
    }

    # Ping command
    function ping(args) {
        if (args.length == 0) {
            print("No hostname or IP specified")
            return
        }

        let hostname = args[0]
        Network.ping(hostname, (success) => {
            if (success) {
                print("Ping successful to " + hostname)
            } else {
                print("Ping failed to " + hostname)
            }
        })
    }

    # System info command
    function systemInfo() {
        let info = System.getInfo()
        print("System Information:")
        print("OS: " + info.os)
        print("CPU: " + info.cpu)
        print("Memory: " + info.memory + " MB")
        print("Disk: " + info.disk + " GB")
    }

    # Exit the terminal
    function exit() {
        print("Exiting terminal...")
        Process.exit(0)
    }

    # Resolve the given path to an absolute path
    function resolvePath(path) {
        if (path.startsWith("/")) {
            return path
        } else {
            return self.currentPath + "/" + path
        }
    }
}

# Start the terminal
var terminal = Terminal()
terminal.start()
