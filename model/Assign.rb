require_relative './ID'
require_relative './Exp'

class Assign
  attr_accessor :id
  attr_accessor :exp

  def initialize
    @id = ID.new
    @exp = Exp.new
  end

  def Parse_Assign(tokenizer,idvals,isdeclared)
    #check assign format, and parse id and expression
    token = tokenizer.gettoken
    @id.Parse_ID(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    if (token != "=")
      puts "Error: In assign, symbol to be parsed should be \"=\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    token = tokenizer.gettoken
    @exp.Parse_Exp(tokenizer,idvals,isdeclared)
    tokenizer.skiptoken#semicolon
  end

  def Print_Assign(tabspaces)
    #indent as required and print assign stmt
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    @id.Print_ID(0)
    print " = "
    @exp.Print_Exp(0)
    print " ; "
  end

  def Execute_Assign(idvals)
    #get id and exp val, and store value in idvals hash 
    id = @id.Execute_ID
    exp = @exp.Execute_Exp(idvals)
    idvals[id] = exp
  end
end
