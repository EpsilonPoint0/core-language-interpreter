require_relative './Decl_Seq'
require_relative './Stmt_Seq'
require_relative '../tokenizer/Tokenizer'

class Program
  attr_accessor :tokenizer
  attr_accessor :dsequence
  attr_accessor :stmtseq

  def initialize
    @tokenizer = Tokenizer.new
    @dsequence = Decl_Seq.new
    @stmtseq = Stmt_Seq.new
    @declarations = Array.new
    @idvals = Hash.new
    @isdeclared = false
  end

  def Parse_Program(filename)
    #Program is parsed and non terminal expansion parse functions are called as well
    @tokenizer.tokenizefile(filename)
    starttoken = @tokenizer.gettoken
    if (starttoken != 'program')
      puts "Error: In program, word to be parsed should be \"program\"."
      Process.exit!()
    end
    @tokenizer.skiptoken
    #Add all ids to the array declarations to verify all ids are declared and initialized
    @declarations = @dsequence.Parse_Decl_Seq(@tokenizer,@idvals,@isdeclared)
    for x in 0..@declarations.length-1
      @idvals[@declarations[x]] = nil
    end
    @declared = true
    tkn = @tokenizer.gettoken
    if (tkn != 'begin')
      puts "Error: In program, word to be parsed should be \"begin\"."
      Process.exit!()
    end
    @tokenizer.skiptoken
    @stmtseq.Parse_Stmt_Seq(@tokenizer,@idvals,@isdeclared)
    tkn = @tokenizer.gettoken
    if (tkn != 'end')
      puts "Error: In program, word to be parsed should be \"end\"."
      Process.exit!()
    end
    @tokenizer.skiptoken
    # @declarations.each do |id|
    #   puts "#{id}"
    # end
  end

  def Print_Program
    #Print the program by calling the print declaration sequence and statement sequence
    puts
    one = 1
    print "program "
    #indent the begin and end
    @dsequence.Print_Decl_Seq(0)
    print "\n\n\n\tbegin "
    @stmtseq.Print_Stmt_Seq(2)
    print "\n\n\n\tend\n"
  end

  def Execute_Program(inputdata)
    inputs = Array.new
    #Get the input data into an array
    File.open(inputdata, "r").each do |line|
        inputs = line.split()
      end
      @stmtseq.Execute_Stmt_Seq(@idvals,inputs)
  end

end
