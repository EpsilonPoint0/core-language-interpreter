require_relative './ID'

class ID_List
  attr_accessor :id
  attr_accessor:idlist

  def initialize
    @id = ID.new
    @idlist = nil
    @ids = Array.new
  end

  def Parse_ID_List(tokenizer,idvals,isdeclared)
    #get the ids stored in array while parsing the id list recursively
    @ids[0] = @id.Parse_ID(tokenizer,idvals,isdeclared)
    if (tokenizer.gettoken == ",")
      tokenizer.skiptoken
      @idlist = ID_List.new
      temp = @idlist.Parse_ID_List(tokenizer,idvals,isdeclared)  
      for x in 0..temp.length-1
        @ids.push(temp[x])
      end
    end
    #return array 
    return @ids
  end

  def Print_ID_List(tabspaces)
    #indent accordingly and then print the id list
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    @id.Print_ID(0)
    if (not (@idlist == nil))
      print " , "
      @idlist.Print_ID_List(0)
    end
  end

  def Execute_ID_List
    #return the id list 
    @ids[0] =  @id.Execute_ID
    if (not (@idlist == nil))
      temp = @idlist.Execute_ID_List
      for x in 0..temp.length-1
        @ids.push(temp[x])
      end
    end
    return @ids
  end
end
