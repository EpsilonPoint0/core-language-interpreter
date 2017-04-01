require_relative './ID_List'

class Decl
  attr_accessor :idlist
  
  def initialize
    @idlist = ID_List.new
  end

  def Parse_Decl(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    #remove "int" token and then parse the ID list
    if (token != "int")
      puts "Error: In declaration, word to be parsed should be \"int\"."
      Process.exit!()
    end
    token = tokenizer.skiptoken
    arr = @idlist.Parse_ID_List(tokenizer,idvals,isdeclared)
    tokenizer.skiptoken #The semi colon
    return arr
  end

  def Print_Decl(tabspaces)
    #print "int " and then the id list
    print "int "
    @idlist.Print_ID_List(0)
    print " ; "
  end

  #Not used
  def Execute_Decl
    @idlist.Execute_ID_List
  end

end
