require_relative './Operator'
require_relative './Comparison_Op'

class Comparator

  attr_accessor :op1
  attr_accessor :compop
  attr_accessor :op2
  
  def initialize
    @op1 = Operator.new
    @compop = Comparison_Op.new
    @op2 = Operator.new
  end

  def Parse_Comparator(tokenizer,idvals,isdeclared)
    #Parse operators and comparison operator
    tokenizer.skiptoken#parenthese
    @op1.Parse_Operator(tokenizer,idvals,isdeclared)
    @compop.Parse_Comparison_Op(tokenizer)
    @op2.Parse_Operator(tokenizer,idvals,isdeclared)
    tokenizer.skiptoken#closing paranthese
  end

  def Print_Comparator(tabspaces)
    #Indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print "("
    @op1.Print_Operator(0)
    @compop.Print_Comparison_Op(0)
    @op2.Print_Operator(0)
    print ")"
  end

  def Execute_Comparator(idvals)
    #Execute the coomparator and return the value accoording to the comparison operator
    operator1 = @op1.Execute_Operator(idvals)
    operator2 = @op2.Execute_Operator(idvals)
    comp = @compop.Execute_Comparison_Op
    val = nil
    if (comp == '==')
      if (operator1 == operator2)
        val = true
      else
        val = false
      end
    elsif(comp == '!=')
      if  (not(operator1 == operator2))
        val = true
      else
        val = false
      end
    elsif (comp == '<')
      if (operator1 < operator2)
        val = true
      else
        val = false
      end
    elsif(comp == '>')
      if (operator1 > operator2)
        val = true
      else
        val = false
      end
    elsif (@comp== '<=')
      if (operator1 <= operator2)
        val = true
      else
        val = false
      end
    elsif(comp == '>=')
      if (operator1 >= operator2)
        val = true
      else
        val = false
      end
    end
    return val    
  end
end
