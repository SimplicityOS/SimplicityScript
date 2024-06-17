# system.ss

class System {
    # Get system information
    static function getInfo() {
        # Implement getting system information
        return {
            os: "SimplicityOS",
            cpu: "SimCPU 2.0",
            memory: 8192,
            disk: 256
        }
    }
}

# Export the System class
export System
