require_relative './ID_List'

class In
  attr_accessor :idlist
  
  def initialize
    @idlist = ID_List.new
  end

  def Parse_In(tokenizer,idvals,isdeclared)
    #parse the id list for the read
    token = tokenizer.gettoken
    if (token != "read")
      puts "Error: In read statememt, word to be parsed should be \"read\"."
      Process.exit!()
    end
    tokenizer.skiptoken
    @idlist.Parse_ID_List(tokenizer,idvals,isdeclared)
    tokenizer.skiptoken#semicolon
  end

  def Print_In(tabspaces)
    #Indent and print accordingly
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    print "read "
    @idlist.Print_ID_List(0)
    print " ;"
  end

  def Execute_In(idvals,inputs)
    #for each id in the list, read in the first thing from the array
    vals = @idlist.Execute_ID_List
    temp = Tokenizer.new
    vals.each do |id|
      stringid = inputs.shift
      if stringid[0] =='-'
        tempstr = stringid[1, stringid.length-1]
      else
        tempstr = stringid
      end
      if (temp.evaltoken(tempstr) == 31)#If input is an integer, read. Else exit
        idvals[id] = (stringid.to_i)
      else
        puts "Error: Invalid input data. All input data should be integers."
        Process.exit!()
      end
    end
  end
end
