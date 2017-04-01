require_relative './Condition'
require_relative './Stmt_Seq'

class Loop
  attr_accessor :condition
  attr_accessor :stmtseq
  
  def initialize
    @condition = Condition.new
    @stmtseq = Stmt_Seq.new
  end
  

  def Parse_Loop(tokenizer,idvals,isdeclared)
    #Check syntax of loop and parse condition and stmt accordingly
    token = tokenizer.gettoken
    if (token != "while")
      puts "Error: In loop statememt, word to be parsed should be \"while\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    @condition.Parse_Condition(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    if (token != "loop")
      puts "Error: In loop statememt, word to be parsed should be \"loop\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    @stmtseq.Parse_Stmt_Seq(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    if (token != "end")
      puts "Error: In loop statememt, word to be parsed should be \"end\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    tokenizer.skiptoken
  end

  def Print_Loop(tabspaces)
    #Indent accordingly and print loop stmt
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    one = 1
    print "while "
    @condition.Print_Condition(0)
    print" loop"
    print"\n\n"
    @stmtseq.Print_Stmt_Seq(tabspaces+1)
    print"\n"
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print "\n\n"
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print "end ;\n\n"
  end

  def Execute_Loop(idvals,inputs)
    #While the condition remains, true, execute the stmt
    while (@condition.Execute_Condition(idvals))
      @stmtseq.Execute_Stmt_Seq(idvals,inputs)
    end
  end
end
