class ID
  attr_accessor :id
  def initialize
    @id = nil
  end
  def Parse_ID(tokenizer,idvals,isdeclared)
    #Parse the id and return the name of the id
    token = tokenizer.gettoken
    if (not (tokenizer.evaltoken(token) == 32))
      puts "Error: In ID, the identifier #{token} is not a valid identifier."
      Process.exit!() 
    end
    #The id variable gets the valid identifier stored
    @id = token
    tokenizer.skiptoken
    #Check if id being parsed is in idval hash already. if it is not and declaration has been completed, then the variable is undeclared.
    if (not(idvals.include?(@id)) and isdeclared == true)
      puts "Error: Undeclared variable #{id}."
      Process.exit!() 
    end
    return @id
    #tokenizer.skiptoken
    #puts"next token in ID is #{tokenizer.gettoken}"
  end

  def Print_ID(tabspaces)
    #Indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print "#{@id}"
  end

  def Execute_ID
    #Simply return id name
    return @id
  end
end