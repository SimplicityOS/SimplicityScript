# process.ss

class Process {
    # Exit the process
    static function exit(code) {
        # Implement process exit
        print("Process exited with code " + code)
    }
}

# Export the Process class
export Process
