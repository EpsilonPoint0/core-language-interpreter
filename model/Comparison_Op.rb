class Comparison_Op
  @@symbols =['==', '!=', '<', '>', '<=', '>=']
  attr_accessor :symbol
  def initialize
    @symbol = nil
  end
  def Parse_Comparison_Op(tokenizer)
    #Parse the comparison operator and ensure it is valid
    token = tokenizer.gettoken
    if (not (@@symbols.include?(token)))
      puts "Error: In comparison statement, comparison operator should be one of:[\'=='\, \'!=\', \'<\', \'>\', \'<=\', \'>=\']."
      Process.exit!() 
    end
    #The symbol comparison symbol gets stored in @symbol
    @symbol = token
    tokenizer.skiptoken
  end

  def Print_Comparison_Op(tabspaces)
    #Indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print " #{@symbol} "
  end 

  def Execute_Comparison_Op
    #return the symbol 
    return @symbol
  end
end