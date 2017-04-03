=begin
-------------------------------------------------------------------------------
Obinna U Ngini, 10/10/2013 
This is an interpreter for the Core language written for CSE 3341 in Ruby
Using the Object Oriented Approach, each non terminal has a class that contains methods to parse, print and execute. 
A tokenizer is implemented to gather valid tokens for Core and parse any Core program effectively 
=end
#---------------------------------------------------------------------------------------------------------------------------------------------------------------

require_relative './model/ID'
require_relative './model/ID_List'
require_relative './model/Comparison_Op'
require_relative './model/Operator'
require_relative './model/Term'
require_relative './model/Exp'
require_relative './model/Comparator'
require_relative './model/Condition'
require_relative './model/Out'
require_relative './model/In'
require_relative './model/If'
require_relative './model/Loop'
require_relative './model/Stmt_Seq'
require_relative './model/Stmt'
require_relative './model/Assign'
require_relative './model/Decl'
require_relative './model/Decl_Seq'
require_relative './model/Program'

#----------------------------------------------------------------------------------------------------------------------------------------------------------------

class Interpreter
  def interpretprog
    #Create program class and get input from user, if one is missing, terminate. If both are prompt the user for both filenames
    prog = Program.new
    filename = nil
    inputdata = nil
    if (not((ARGV[0] == nil) and (ARGV[1] == nil)))
      filename = ARGV[0]
      inputdata = ARGV[1]
    elsif (ARGV[0] == nil or ARGV[1] == nil)
      print("Please enter the Core program file name: ") 
      filename = gets.chomp
      print("Please enter the input file name: ") 
      inputdata = gets.chomp
    end
    if (filename == nil or inputdata == nil)
      puts "Error. Both filenames not provided. Please re run and provide necessary files"
    else
      if (not (File.file?(filename)))   
        puts "Error: Core Program file #{filename} does not exist"
        Process.exit!()
      end
      if (not (File.file?(inputdata)))    
        puts "Error: Input file #{inputdata} does not exist"
        Process.exit!()
      end
      #Proceed to parse, print and execute Core program
      prog.Parse_Program(filename)
      prog.Print_Program
      puts "\nResults for this program are:\n\n"
      prog.Execute_Program(inputdata)
    end
  end
  int = Interpreter.new
  #Intrepreter call
  int.interpretprog
end