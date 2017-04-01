require_relative './Decl'

class Decl_Seq
  attr_accessor :decl
  attr_accessor :declseq

  def initialize
    @decl = Decl.new
    @declseq = nil
    @declared = Array.new
  end
  

  def Parse_Decl_Seq(tokenizer,idvals,isdeclared)
    #Declaration Sequence is parsed and non terminal expansion parse functions are called as well
    temp = @decl.Parse_Decl(tokenizer,idvals,isdeclared)
    temp.each do |element|
      @declared.push(element)
    end
    #If there is another sequence, recursively parse it
    if(tokenizer.gettoken == "int")
      @declseq = Decl_Seq.new
      temp = @declseq.Parse_Decl_Seq(tokenizer,idvals,isdeclared)
      for x in 0..temp.length-1
        @declared.push(temp[x])
      end
    end 
    return @declared  
  end

  def Print_Decl_Seq(tabspaces)
    #print the required amount of tabspaces to indent
    counter = 0
    while (counter < tabspaces)
      print "\t"
      counter = counter + 1
    end
    @decl.Print_Decl(0)
    if (not (@declseq == nil))
      @declseq.Print_Decl_Seq(0)
    end
  end
  #Not used
  def Execute_Decl_Seq
    @decl.Execute_Decl
  end

end
