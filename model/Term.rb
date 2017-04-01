require_relative './Operator'
class Term
  
  attr_accessor :op1
  attr_accessor :trm
  
  def initialize
    @op1 = Operator.new
    @trm = nil
  end
  def Parse_Term(tokenizer,idvals,isdeclared)
    #parse the operator and if applicable the term after it
    @op1.Parse_Operator(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    if (token == "*")
      tokenizer.skiptoken
      @trm = Term.new
      @trm.Parse_Term(tokenizer,idvals,isdeclared)
    end 
  end

  def Print_Term(tabspaces)
    #indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    op1.Print_Operator(0)
    if (not(@trm == nil))
      print " * "
    @trm.Print_Term(0)
    end
  end

  def Execute_Term(idvals)
    #return the value of the term by recusrively evaluating operator or operator and term
    termval = nil
    termval = @op1.Execute_Operator(idvals)
    if (not(@trm == nil))
      othertermval = @trm.Execute_Term(idvals)
      termval = termval * othertermval
    end
    return termval
  end
end