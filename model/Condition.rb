require_relative './Comparator'
#TO BE COMPLETED
class Condition

  attr_accessor :comp
  attr_accessor :cond
  attr_accessor :not
  attr_accessor :comboop
  
  def initialize
    @comp = nil
    @cond1 = nil
    @not = false
    @cond2 = nil
    @comboop = nil
  end

  def Parse_Condition(tokenizer,idvals,isdeclared)
    #parse condition accordingly, parsing comparator if needed, negate or combine the condition with another
    token = tokenizer.gettoken
    if (token == "(")
      @comp = Comparator.new
      @comp.Parse_Comparator(tokenizer,idvals,isdeclared)
    elsif (token == '!')
      @not = true
      tokenizer.skiptoken
      @cond1 = Condition.new
      @cond1.Parse_Condition(tokenizer,idvals,isdeclared)
    elsif(token == '[')
      tokenizer.skiptoken
      @cond1 = Condition.new
      @cond1.Parse_Condition(tokenizer,idvals,isdeclared)
      token = tokenizer.gettoken#and or or
      #puts "token is #{token}"
      if (not(token == "&&" or token == "||"))
        puts "Error: In condition, symbol to be parsed should be \'&&\' or \'||\'."
        Process.exit!()
      end
      @comboop = token
      tokenizer.skiptoken
      @cond2 = Condition.new
      @cond2.Parse_Condition(tokenizer,idvals,isdeclared)
      token = tokenizer.gettoken#and or or
      if (not(token == "]"))
        puts "Error: In condition, symbol to be parsed should be \']\'."
        Process.exit!()
      end
      tokenizer.skiptoken
    end
  end

  def Print_Condition(tabspaces)
    #Indent and print according to depth of parse
    if (not(@comp == nil)) 
      @comp.Print_Comparator(0)
    elsif(@not == true)
      print "!"
      @cond1.Print_Condition(0)
    elsif(not (@cond2 == nil))
      print "["
      @cond1.Print_Condition(0)
      print " #{@comboop} "
      @cond2.Print_Condition(0)
      print "]"
    end

  end

  def Execute_Condition(idvals)
    #Evaluate condtion as neede d and return value
    condeval = nil
    if (not(@comp == nil)) 
      condeval = @comp.Execute_Comparator(idvals)
    elsif(@not == true)
      condeval = not(@cond1.Execute_Condition(idvals))
    elsif(not (@cond2 == nil))
      if (@comboop == "&&")
        condeval = ((@cond1.Execute_Condition(idvals)) and (@cond2.Execute_Condition(idvals)))
      elsif (@comboop == "||")
        condeval = ((@cond1.Execute_Condition(idvals)) or (@cond2.Execute_Condition(idvals)))
      end     
    end
    return condeval
  end

end
