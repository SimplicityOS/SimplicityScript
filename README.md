# SimplicityScript

SimplicityScript is a new programming language designed to be simple and intuitive. It includes features like easy syntax, dynamic typing, and a comprehensive standard library.

### 1. Basic Syntax and Semantics
#### Keywords and Operators
- **Control Flow:** `if`, `else`, `while`, `for`, `break`, `continue`, `return`
- **Data Types:** `int`, `float`, `string`, `bool`, `list`, `dict`, `null`
- **Functions:** `def`, `return`
- **Other Keywords:** `import`, `from`, `as`, `class`
#### Example Syntax
```simplicity
# Define a function
def add(a: int, b: int) -> int {
 return a + b
}
# Control flow
if (x > 0) {
 print("Positive")
} else {
 print("Non-positive")
}
# List and Dictionary
my_list = [1, 2, 3, 4, 5]
my_dict = {"key1": "value1", "key2": "value2"}
```
### 2. Implementation Outline
#### Lexer and Parser
- **Lexer:** Tokenizes the input code into meaningful symbols.
- **Parser:** Analyzes tokenized input to ensure correct syntax and builds an Abstract Syntax Tree
(AST).

#### Comments
# This is a single-line comment

/*
This is a 
multi-line comment
*/

#### Variables and Data Types
let name = "SimplicityScript"  # String
let version = 1.0  # Float
let year = 2024  # Integer
let isReleased = true  # Boolean

#### Functions
function greet(name) {
    print("Hello, " + name + "!")
}

greet("World")  # Output: Hello, World!

### Control Structures
#### If-Else Statements:
let age = 18

if (age >= 18) {
    print("You are an adult.")
} else {
    print("You are a minor.")
}


#### Loops:
# For Loop
for i in range(1, 5) {
    print(i)
}

# While Loop
let count = 0
while (count < 5) {
    print(count)
    count = count + 1
}


#### Lists:
let fruits = ["apple", "banana", "cherry"]
print(fruits[1])  # Output: banana


#### Dictionaries:
let person = {
    "name": "John",
    "age": 30
}
print(person["name"])  # Output: John

### 3. Sample Program
#### Sample.ss Program
# Function to calculate factorial
function factorial(n) {
    if (n == 0) {
        return 1
    } else {
        return n * factorial(n - 1)
    }
}

## Main Program
let number = 5
print("Factorial of " + number + " is " + factorial(number))


## Installation

To install SimplicityScript, clone the repository and build the source:

```bash
git clone https://github.com/iam-theunknown/SimplicityScript.git
cd SimplicityScript
make

