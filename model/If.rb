require_relative './Condition'
require_relative './Stmt_Seq'

class If
  attr_accessor :condition
  attr_accessor :ifstmtseq
  attr_accessor :elsestmtseq
  
  def initialize
    @condition = Condition.new
    @ifstmtseq = Stmt_Seq.new
    @elsestmtseq = nil
  end

  def Parse_If(tokenizer,idvals,isdeclared)
    #check statement syntax and parse accordingly, condition, first statement and if there is one, the else statement
    token = tokenizer.gettoken
    if (token != "if")
      puts "Error: In if statement, word to be parsed should be \"if\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    @condition.Parse_Condition(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    if (token != "then")
      puts "Error: In if statememt, word to be parsed should be \"then\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    @ifstmtseq.Parse_Stmt_Seq(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    if (token == "end")
      tokenizer.skiptoken
      tokenizer.skiptoken
    elsif (token == "else")
      tokenizer.skiptoken
      @elsestmtseq = Stmt_Seq.new
      @elsestmtseq.Parse_Stmt_Seq(tokenizer,idvals,isdeclared)
      token = tokenizer.gettoken
      if (token != "end")
        puts "Error: In if statement, word to be parsed should be \"end\"."
        Process.exit!()
      end
      tokenizer.skiptoken
      tokenizer.skiptoken
    end
  end

  def Print_If(tabspaces)
    #Indent accoridngly and print statement, as well as the else portion if applicable
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print "if "
    @condition.Print_Condition(0)
    print " then "
    print "\n\n"
    @ifstmtseq.Print_Stmt_Seq(tabspaces+1)
    print "\n"
    if (not (@elsestmtseq == nil))
      counter = 0
      while (counter < tabspaces)
        print "\t"
        counter = counter + 1
      end
      print "else "
      print "\n\n"
      @elsestmtseq.Print_Stmt_Seq(tabspaces+1)
      print "\n\n\n"
    end
    counter = 0
      while (counter < tabspaces)
        print "\t"
        counter = counter + 1
      end
    print "end ;\n\n"
  end

  def Execute_If(idvals,inputs)
    #if the condition is evaluated to true, execute the stmt
    if (@condition.Execute_Condition(idvals))
      @ifstmtseq.Execute_Stmt_Seq(idvals,inputs)
      #if there is an else stmt, execute it if the condition is not true
    elsif(not (@elsestmtseq == nil))
      @elsestmtseq.Execute_Stmt_Seq(idvals,inputs)
    end
  end
end
