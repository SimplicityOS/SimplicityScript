# database.ss

# Import necessary modules for MySQL connectivity
import "mysql"

# Define a Database class to handle connections and queries
class Database {
    var connection

    # Initialize the database connection
    function init(db_url) {
        self.connection = mysql.connect(db_url)
    }

    # Execute a query with parameters
    function query(query_str, params) {
        let stmt = self.connection.prepare(query_str)
        let result = stmt.execute(params)
        return result
    }
}

# Export the Database class
export Database
