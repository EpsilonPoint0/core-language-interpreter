
class Operator

  attr_accessor :id
  attr_accessor :number
  attr_accessor :exp
  
  def initialize
    @id = nil
    @number = nil
    @exp = nil
  end
  def Parse_Operator(tokenizer,idvals,isdeclared)
    #parse the operator, calling the appropriate parse call as needed
    token = tokenizer.gettoken
    if (token == "(")
      tokenizer.skiptoken
      @exp.Parse_Exp(tokenizer,idvals,isdeclared)
      tokenizer.skiptoken
    else
      if(tokenizer.evaltoken(token) == 32)
        @id = ID.new
        @id.Parse_ID(tokenizer,idvals,isdeclared)
      elsif (tokenizer.evaltoken(token) == 31)
        @number = token.to_i
        tokenizer.skiptoken
      else
        puts "Error: In Operator, input must be a number, identifier or expression."
          Process.exit!()
      end 
      
    end
  end

  def Print_Operator(tabspaces)
    #indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    if (not(@id == nil))
      @id.Print_ID(0)
    elsif (not(@number == nil))
      print "#{@number}"
    elsif (not(@exp == nil))
      print "("
      @exp.Print_Exp(0)
      print ")"
    end   
  end

  def Execute_Operator(idvals)
    #return a number if applicable, the value of an identifier by checking hash idvals, uninitialized variables are caught here
    opval = nil
    if (not(@id == nil))      
      id = @id.Execute_ID
      if idvals.include?(id)
        opval = idvals[id]
        if (opval == nil)
          puts "Error: Unitialized variable #{id}."
          Process.exit!()
        end
      else
        puts "Error: Undeclared variable #{id}."
        Process.exit!()
      end
    elsif (not(@number == nil))
      opval =  @number
    elsif (not(@exp == nil))
      opval = @exp.Execute_Exp(idvals)
    end 
    return opval
  end
end
