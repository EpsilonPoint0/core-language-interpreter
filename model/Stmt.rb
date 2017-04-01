require_relative './Assign'
require_relative './If'
require_relative './Loop'
require_relative './In'
require_relative './Out'

class Stmt
  attr_accessor :assignstmt
  attr_accessor :ifstmt
  attr_accessor :loopstmt
  attr_accessor :readstmt
  attr_accessor :writestmt

  def initialize
    @assignstmt = nil
    @ifstmt = nil
    @loopstmt = nil
    @readstmt = nil
    @writestmt = nil
  end

  def Parse_Stmt(tokenizer,idvals,isdeclared)
    #depending on leading token, go to the appropriate parse call
    token = tokenizer.gettoken
    id_number = 32
    if (token == "if")
      @ifstmt = If.new
      @ifstmt.Parse_If(tokenizer,idvals,isdeclared)
    elsif (tokenizer.evaltoken(token) == id_number)
      @assignstmt = Assign.new
      @assignstmt.Parse_Assign(tokenizer, idvals,isdeclared) 
      #puts "Next after assign is #{tokenizer.gettoken}"
    elsif (token == "while")
      @loopstmt = Loop.new
      @loopstmt.Parse_Loop(tokenizer,idvals,isdeclared)
    elsif (token == "read")
      @readstmt = In.new
      @readstmt.Parse_In(tokenizer, idvals,isdeclared)
    elsif (token == "write")
      @writestmt = Out.new
      @writestmt.Parse_Out(tokenizer, idvals,isdeclared)
    else
      puts "Error: In statement, word to be parsed should be an \"if\", \"while\", \"read\", \"write\", or an identifier for assign."
      Process.exit!()
    end
  end

  def Print_Stmt(tabspaces)
    #indent as required and print stmt. print newline after each stmt
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print"\n"
    if (not (@assignstmt == nil))
      @assignstmt.Print_Assign(tabspaces)
    elsif (not (@ifstmt == nil))
      print"\n\n"
      @ifstmt.Print_If(tabspaces)
    elsif (not (@loopstmt == nil))
      print"\n\n"
      @loopstmt.Print_Loop(tabspaces)
    elsif (not (@readstmt == nil))
      @readstmt.Print_In(tabspaces)
    elsif (not (@writestmt == nil))
      @writestmt.Print_Out(tabspaces)
    end
  end

  def Execute_Stmt(idvals,inputs)
    #jump to requied execution call
    if (not (@assignstmt == nil))
      @assignstmt.Execute_Assign(idvals)
    elsif (not (@ifstmt == nil))
      @ifstmt.Execute_If(idvals,inputs)
    elsif (not (@loopstmt == nil))
      @loopstmt.Execute_Loop(idvals,inputs)
    elsif (not (@readstmt == nil))
      @readstmt.Execute_In(idvals,inputs)
    elsif (not (@writestmt == nil))
      @writestmt.Execute_Out(idvals)
    end
  end

end