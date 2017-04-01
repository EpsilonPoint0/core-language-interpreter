require_relative './Term'
class Exp
  attr_accessor :trm
  attr_accessor :addition
  attr_accessor :exp
  
  def initialize
    @trm = Term.new
    @addition = nil
    @exp = nil
  end

  def Parse_Exp(tokenizer,idvals,isdeclared)
    #parse the term and if there id more, parse the remaining expression
    @trm.Parse_Term(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    if (token == "+" or token == "-")
      @addition = token
      tokenizer.skiptoken
      @exp = Exp.new
      @exp.Parse_Exp(tokenizer,idvals,isdeclared)
    else
      #not needed, as tokens other than these can occur
      # puts "Error: In expression, symbol to be parsed should be \'+\' or \'-'\'."
      # Process.exit!()
    end
  end

  def Print_Exp(tabspaces)
    #Indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    @trm.Print_Term(0)
    if (not (@addition == nil))
      print " #{addition} "
      @exp.Print_Exp(0)
    end
  end

  def Execute_Exp(idvals)
    #execute the expression and return the value
    expval = nil
    term1 = @trm.Execute_Term(idvals)
    expval = term1
    if (not (@addition == nil))
      exp1 = @exp.Execute_Exp(idvals)
      if (@addition == '+')
        expval = expval + exp1
      elsif (@addition == '-')
        expval = expval - exp1
      end     
    end
    return expval
  end
end
