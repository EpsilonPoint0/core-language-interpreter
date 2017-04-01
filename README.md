# Core Language Interpeter

## Interpreter 
The Interpreter takes two files as input : the file contaning the Core program to be executed, and the input for the program. 
It parses the program, prints the program to the screen, and then prints the results of executing the program. 

## How it works
The Interpreter is built using the object oriented approach. Each non terminal symbol of the Core BNF has been defined as a class, 
and its instance variables are the possible expansions of the symbol according to the Core BNF. 
The parser works by recurive descent, calls the tokenizer to fetch tokens and parse the program. 
Undeclared variables are caught during parsing. The program is then printed in correct format, and executed. 
Variables are also checked to ensure they are initialized during execution.
The results of the write statements are printed to the console.

## Running the Program
To use the Interpreter, provide a file containing a Core program as input, as well as an input data file. 
The filenames can be entered in student Linux or C command prompt (if Ruby is installed on the machine) in the format 
“ruby Interpreter.rb (filename) (inputdata)” or entered as input by typing “ruby Interpreter.rb” and providing the file names at the prompt. 
The program will be printed to the console, as will the results of executing the program.

## Test Cases
The Interpreter was tested using the test cases as well as some error cases to ensure it terminated when encountering an invalid or incorrect program. 
It gave correct results for all cases and there are no bugs to report.

## Change Log
1. First pass(and what was submitted for assigment) can be found at archive/Interpreter.rb
1. Second pass to make it fully OO and not rely on a global variable can be found at archive/Interpreter2.rb
1. Third (and current) pass extracted each OO class to it's own file for clarity and readability.
