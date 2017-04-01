require_relative './ID_List'

class Out
  attr_accessor :idlist
  
  def initialize
    @idlist = ID_List.new
  end

  def Parse_Out(tokenizer,idvals,isdeclared)
    #parse id list 
    token = tokenizer.gettoken
    if (token != "write")
      puts "Error: In write statememt, word to be parsed should be \"write\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    @idlist.Parse_ID_List(tokenizer,idvals,isdeclared)
    tokenizer.skiptoken#semicolon
  end

  def Print_Out(tabspaces)
    #Indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print "write "
    @idlist.Print_ID_List(0)
    print " ;"
  end

  def Execute_Out(idvals)
    #print each id and corresponding value in the list
    vals = @idlist.Execute_ID_List
    vals.each do |id|
      puts "#{id} = #{idvals[id]}"
    end
  end
end
