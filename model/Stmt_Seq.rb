require_relative './Stmt'

class Stmt_Seq 
  attr_accessor :stmt
  attr_accessor :stmtseq

  def initialize
    @stmt = Stmt.new 
    @stmtseq = nil
  end

  def Parse_Stmt_Seq(tokenizer,idvals,isdeclared)
    token = tokenizer.gettoken
    @stmt.Parse_Stmt(tokenizer,idvals,isdeclared)
    #If there is another sequence recursively parse it
    token = tokenizer.gettoken
    if(not (token == "end" or token == "else"))
      @stmtseq = Stmt_Seq.new
      @stmtseq.Parse_Stmt_Seq(tokenizer,idvals,isdeclared)
    end
   end

  def Print_Stmt_Seq(tabspaces)
    #Print the stmt_seq, and recursively, print the rest
    @stmt.Print_Stmt(tabspaces)
    if (not (@stmtseq == nil))
      print "\n"
      @stmtseq.Print_Stmt_Seq(tabspaces)
    end
  end

  def Execute_Stmt_Seq(idvals,inputs)
    #Execute stmt_seq, and recursively execute the rest
    @stmt.Execute_Stmt(idvals,inputs)
    if (not (@stmtseq == nil))
      @stmtseq.Execute_Stmt_Seq(idvals,inputs)
    end
  end

end
