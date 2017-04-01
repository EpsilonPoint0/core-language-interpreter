=begin
Obinna U Ngini, 10/10/2013 ---Happy 26th Chizoba!!!
This is an interpreter for the Core language written for CSE 3341 in Ruby
Using the Object Oriented Approach, each non terminal has a class that contains methods to parse, print and execute. 
A tokenizer is implemented to gather valid tokens for Core and parse any Core program effectively	
=end
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#TOKENIZER

class Tokenizer
	
	Array $alltokens = Array.new
		$curr_token = 0
		$tot_tkn_count = 0
		$keywords = {
		'program' => 1,
		'begin' => 2,
		'end' => 3,
		'int' => 4,
		'if' => 5,
		'then' => 6,
		'else' => 7,
		'while' => 8,
		'loop' => 9,
		'read' => 10,
		'write' => 11,
		';' => 12,
		',' => 13,
		'=' => 14,
		'!' => 15,
		'[' => 16,
		']' => 17,
		'&&' => 18,
		'||' => 19,
		'(' => 20,
		')' => 21,
		'+' => 22,
		'-' => 23,
		'*' => 24,
		'!=' => 25,
		'==' => 26,
		'<' => 27,
		'>' => 28,
		'<=' => 29,
		'>=' => 30,
		}

		$symbols = [';', ',', '=', '!', '[', ']', '&', '|', '(', ')', '+', '-', '*', '>', '<']


	#def initialize()
		
	#end

	def numeric?(lookAhead)
	  lookAhead =~ /[0-9]/
	end

	def letter?(lookAhead)
	  lookAhead =~ /[A-Za-z]/
	end

	def capletter?(lookAhead)
		lookAhead =~ /[A-Z]/
	end
	
	def tokenize(input)
		Array tokens = Array.new
		token_count = 0
		tkn = ""
		#x = 0
		state = 1 #letter is starting postition
		#puts "#{input}"
		for x in 0..input.length-1
			#puts "pos counter #{x} input : #{input[x]}"
			added_symbol = false
			if state == 0 #error
				#Keep collecting characters until a 
				if not $symbols.include?(input[x])
					tkn<<input[x]
					#print "tkn #{tkn}"
					state = 0
				else
					#tokens[token_count] = tkn
					#token_count = token_count + 1
					state = 3
				end
			end
			if state == 1#collecting letter
				#Keep collecting letters while in this states
				if letter?(input[x])
					tkn<<input[x]
					state = 1
				#Change to digit collection state if a digit is seen
				elsif numeric?(input[x])
					state = 2
				#Change to symbol collection state
				elsif $symbols.include?(input[x])
					#puts"1st add"
					#If there is a non empty token so , add to array of tokens
					if not tkn == ""
						tokens[token_count] = tkn
						token_count = token_count + 1
					end
					tkn = input[x]
					state = 3
					added_symbol = true
				end
			end
			if state == 2 # collecting digits
				#Go tot error state if letter comes after digit
				if letter?(input[x])
					tkn<<input[x]
					state = 0
				elsif numeric?(input[x])
					state = 2
					tkn<<input[x]
				elsif $symbols.include?(input[x])
					#puts"2nd add"
					tokens[token_count] = tkn
					token_count = token_count + 1
					tkn = input[x]
					state = 3
					added_symbol = true
				end
			end
			if state == 3 #collecting symbols
				#Fix bug to enable this not add blank to the array
				if letter?(input[x])
					#puts"3rd add"
					tokens[token_count] = tkn
					token_count = token_count + 1
					tkn = input[x]
					state = 1
				elsif numeric?(input[x])
					#puts"4th add"
					tokens[token_count] = tkn
					token_count = token_count + 1
					tkn = input[x]
					state = 2
				elsif $symbols.include?(input[x])
					#puts "tkn length is #{tkn.length}"
					if ((input[x] == '=') and (tkn.length == 1) and (added_symbol == false) and (tkn[0] == '>' or tkn[0] == '<' or tkn[0] == '!' or tkn[0] == '='))							
						tkn<<input[x]
						state = 3
					elsif input[x] == '&' and  tkn[tkn.length - 2] ==  '&'
						if added_symbol == false
							tkn<<input[x]
						end
						#puts "tkn is #{tkn} state is #{state}"
					elsif input[x] == '|' and  tkn[tkn.length - 2] ==  '|'
						if added_symbol == false
							tkn<<input[x]
						end
					elsif added_symbol == false
						#puts"5th add"
						tokens[token_count] = tkn
						token_count = token_count + 1
						tkn = input[x]
					elsif added_symbol == true
						#puts"5th add"
						#tokens[token_count] = tkn
						#token_count = token_count + 1
						tkn = input[x]
					else 
						state = 0
					end
					#puts "#{tkn}"
				end
			end
			#puts"Input #{input[x]} state #{state} tkn #{tkn}\n"
		end

		#add the last stuff to the  array if not state == 0
			#puts"Outside add"
		if (not state == 0)
			tokens[token_count] = tkn
			tkn = ""
		#else
		#	puts"Warning: Illegal token #{tkn}"	
		end
		#simple token test
		#tokens.each do |test|
		#	puts test
		return tokens	
	end

	def evaltoken(input)
		#Evaluate the token, getting the hashmap value if it is a keyword
		x = 0
		if $keywords.key?(input)
			x = $keywords[input]
		#Else check if it is a number
		elsif number?(input)
			x = 31
		#Else check if it is an identifier
		elsif (not identifier?(input) == 0)
			x = 32
		else
		# Else token is an 
			x = 35
		end
		return x
	end


	def number?(input)
		#Make sure input forms a number
		x = 0
		flag = false
		for x in 0..input.length-1
			if numeric?(input[x])
				flag = true
			else
				flag = false
				break
			end	
		end
		#puts "#{flag}"
		return flag
	end

	def identifier?(input)
		#Make sure identifier is all caps letters and numbers and numbers only come at the end
		flag = true
		state = 0
		if capletter?(input[0])
			state = 1
		end
		for x in 0..input.length-1
			#print"input[x] is #{input[x]} count is #{x} and state is #{state}"
			if state == 1#collecting letter
				if capletter?(input[x])
					state = 1
				elsif numeric?(input[x])
					state = 2
				end
			end
			if state == 2#collecting digits
				if capletter?(input[x])
					flag = false
					state = 0
					break
				elsif numeric?(input[x])
					state = 2
				end
			end
		end
		#puts "\n#{state}"
		return state
	end

	def skiptoken
		flag = false
		if $curr_token < $tot_tkn_count -1
			#puts "#{$curr_token}  #{$tot_tkn_count}"
			$curr_token = $curr_token + 1
			flag = true
		end
		#puts flag
		return flag
	end

	def gettoken	
		return $alltokens[$curr_token]
	end

	def tokenizefile(fname)
		exists = false
		if File.file?(fname)
			exists = true
			#output = File.open("C:\\Users\\Obinna\\Documents\\tokenized.txt", 'w')
			#output = File.open("tokenized.txt", 'w')
			
			File.open(fname, 'r').each do |line|
				Array temp = line.split()
				temp.each do |word|
					#puts"The word is #{word}"
					Array tokens = 	tokenize(word)
					tokens.each do |token|	
						$alltokens[$tot_tkn_count] = token
						value = evaltoken(token)
						$tot_tkn_count = $tot_tkn_count + 1
						#puts(token)
						if value == 35
							puts "Error token #{token} found! This is an invalid Core Program."
							Process.exit!()
						end
						#puts(value)
						#puts "token:#{token} value:#{value}"
					end
				end
			end
			#write 33 to file at the end
			#output.puts("33");
			#output.close()
			#puts("33")
			#puts "Result file named \"tokenized.txt\" is stored in current directory\n"
		end
		return exists
	end
end

#----------------------------------------------------------------------------------------------------------------------------------------------------------------
#INTERPRETER 
$declared = false#Used to check if program has been parsed past declaration stage
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
	end

	def Parse_Program(filename)
		#Program is parsed and non terminal expansion parse functions are called as well
		#puts "Got to Program"
		@tokenizer.tokenizefile(filename)
		starttoken = @tokenizer.gettoken
		#Exit if token is not program
		if (starttoken != 'program')
			puts "Error: In program, word to be parsed should be \"program\"."
			Process.exit!()
		end
		@tokenizer.skiptoken
		#Add all ids to the array declarations to verify all ids are declared and initialized
		@declarations = @dsequence.Parse_Decl_Seq(@tokenizer,@idvals)
		for x in 0..@declarations.length-1
			@idvals[@declarations[x]] = nil
		end
		$declared = true
		tkn = @tokenizer.gettoken
		#Exit if token is not begin
		if (tkn != 'begin')
			puts "Error: In program, word to be parsed should be \"begin\"."
			Process.exit!()
		end
		@tokenizer.skiptoken
		@stmtseq.Parse_Stmt_Seq(@tokenizer,@idvals)
		tkn = @tokenizer.gettoken
		#Exit if token is not end
		if (tkn != 'end')
			puts "Error: In program, word to be parsed should be \"end\"."
			Process.exit!()
		end
		@tokenizer.skiptoken
		#puts "Leaving Program"

		# @declarations.each do |id|
		# 	puts "#{id}"
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

class Decl_Seq
	attr_accessor :decl
	attr_accessor :declseq

	def initialize
		@decl = Decl.new
		@declseq = nil
		@declared = Array.new
	end
	

	def Parse_Decl_Seq(tokenizer,idvals)
		#Declaration Sequence is parsed and non terminal expansion parse functions are called as well
		#puts "Got to Decl Seq"
		temp = @decl.Parse_Decl(tokenizer,idvals)
		temp.each do |element|
			@declared.push(element)
		end
		#If there is another sequence, recursively parse it
		if(tokenizer.gettoken == "int")
			@declseq = Decl_Seq.new
			temp = @declseq.Parse_Decl_Seq(tokenizer,idvals)
			for x in 0..temp.length-1
				@declared.push(temp[x])
			end
		end	
		return @declared	
		#puts "Leaving Decl_Seq"
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

class Stmt_Seq 
	attr_accessor :stmt
	attr_accessor :stmtseq

	def initialize
		@stmt = Stmt.new 
		@stmtseq = nil
	end

	def Parse_Stmt_Seq(tokenizer,idvals)
		#puts "Got to Stmt_Seq"
		token = tokenizer.gettoken
		@stmt.Parse_Stmt(tokenizer,idvals)
		#If there is another sequence recursively parse it
		token = tokenizer.gettoken
		if(not (token == "end" or token == "else"))
		 	@stmtseq = Stmt_Seq.new
		 	@stmtseq.Parse_Stmt_Seq(tokenizer,idvals)
		end
		#puts "Leaving Stmt_Seq"
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

class Decl
	attr_accessor :idlist
	
	def initialize
		@idlist = ID_List.new
	end

	def Parse_Decl(tokenizer,idvals)
		#puts "Got to Decl"
		token = tokenizer.gettoken
		#remove "int " token and then parse the ID list
		if (token != "int")
			puts "Error: In declaration, word to be parsed should be \"int\"."
			Process.exit!()
		end
		token = tokenizer.skiptoken
		arr = @idlist.Parse_ID_List(tokenizer,idvals)
		tokenizer.skiptoken #The semi colon
		return arr
		#puts "Leaving Decl"
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

class ID_List
	attr_accessor :id
	attr_accessor:idlist

	def initialize
		@id = ID.new
		@idlist = nil
		@ids = Array.new
	end

	def Parse_ID_List(tokenizer,idvals)
		#puts "Got to ID_List"
		#get the ids stored in array while parsing the id list recursively
		@ids[0] = @id.Parse_ID(tokenizer,idvals)
		if (tokenizer.gettoken == ",")
			tokenizer.skiptoken
			@idlist = ID_List.new
			temp = @idlist.Parse_ID_List(tokenizer,idvals)	
			for x in 0..temp.length-1
				@ids.push(temp[x])
			end
		end
		#return array 
		return @ids
		#puts "Leaving ID_List"
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

class Stmt
	attr_accessor :assignstmt
	attr_accessor :ifstmt
	attr_accessor :loopstmt
	attr_accessor :readstmt
	attr_accessor :writestmt

	def initialize
		@assignstmt = nil
		@ifstmt = nil
		@loopstmt = nil
		@readstmt = nil
		@writestmt = nil
	end

	def Parse_Stmt(tokenizer,idvals)
		#puts "Got to Stmt"
		#depending on leading token, go to the appropriate parse call
		token = tokenizer.gettoken
		id_number = 32
		if (token == "if")
			@ifstmt = If.new
			@ifstmt.Parse_If(tokenizer,idvals)
		elsif (tokenizer.evaltoken(token) == id_number)
			@assignstmt = Assign.new
			@assignstmt.Parse_Assign(tokenizer, idvals)	
			#puts "Next after assign is #{tokenizer.gettoken}"
		elsif (token == "while")
			@loopstmt = Loop.new
			@loopstmt.Parse_Loop(tokenizer,idvals)
		elsif (token == "read")
			@readstmt = In.new
			@readstmt.Parse_In(tokenizer, idvals)
		elsif (token == "write")
			@writestmt = Out.new
			@writestmt.Parse_Out(tokenizer, idvals)
		else
			puts "Error: In statement, word to be parsed should be an \"if\", \"while\", \"read\", \"write\", or an identifier for assign."
			Process.exit!()
		end
		#puts "Leaving Stmt"
	end

	def Print_Stmt(tabspaces)
		#indent as required and print stmt. print newline after each stmt
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		print"\n"
		if (not (@assignstmt == nil))
			@assignstmt.Print_Assign(tabspaces)
		elsif (not (@ifstmt == nil))
			print"\n\n"
			@ifstmt.Print_If(tabspaces)
		elsif (not (@loopstmt == nil))
			print"\n\n"
			@loopstmt.Print_Loop(tabspaces)
		elsif (not (@readstmt == nil))
			@readstmt.Print_In(tabspaces)
		elsif (not (@writestmt == nil))
			@writestmt.Print_Out(tabspaces)
		end
	end

	def Execute_Stmt(idvals,inputs)
		#jump to requied execution call
		if (not (@assignstmt == nil))
			@assignstmt.Execute_Assign(idvals)
		elsif (not (@ifstmt == nil))
			@ifstmt.Execute_If(idvals,inputs)
		elsif (not (@loopstmt == nil))
			@loopstmt.Execute_Loop(idvals,inputs)
		elsif (not (@readstmt == nil))
			@readstmt.Execute_In(idvals,inputs)
		elsif (not (@writestmt == nil))
			@writestmt.Execute_Out(idvals)
		end
	end

end

class Assign
	attr_accessor :id
	attr_accessor :exp

	def initialize
		@id = ID.new
		@exp = Exp.new
	end

	def Parse_Assign(tokenizer,idvals)
		#puts "Got to Assign"
		#check assign format, and parse id and expression
		token = tokenizer.gettoken
		@id.Parse_ID(tokenizer,idvals)
		token = tokenizer.gettoken
		if (token != "=")
			puts "Error: In assign, symbol to be parsed should be \"=\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		token = tokenizer.gettoken
		@exp.Parse_Exp(tokenizer,idvals)
		tokenizer.skiptoken#semicolon
		#puts "Leaving Assign"
	end

	def Print_Assign(tabspaces)
		#indent as required and print assign stmt
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		@id.Print_ID(0)
		print " = "
		@exp.Print_Exp(0)
		print " ; "
	end

	def Execute_Assign(idvals)
		#get id and exp val, and stor value in idvals hash 
		id = @id.Execute_ID
		exp = @exp.Execute_Exp(idvals)
		idvals[id] = exp
	end
end

class If
	attr_accessor :condition
	attr_accessor :ifstmtseq
	attr_accessor :elsestmtseq
	
	def initialize
		@condition = Condition.new
		@ifstmtseq = Stmt_Seq.new
		@elsestmtseq = nil
	end

	def Parse_If(tokenizer,idvals)
		#puts "Got to If"
		#check statement syntax and parse accordingly, condition, first statement and if there is one, the else statement
		token = tokenizer.gettoken
		if (token != "if")
			puts "Error: In if statement, word to be parsed should be \"if\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		@condition.Parse_Condition(tokenizer,idvals)
		token = tokenizer.gettoken
		if (token != "then")
			puts "Error: In if statememt, word to be parsed should be \"then\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		@ifstmtseq.Parse_Stmt_Seq(tokenizer,idvals)
		token = tokenizer.gettoken
		if (token == "end")
			tokenizer.skiptoken
			tokenizer.skiptoken
		elsif (token == "else")
			tokenizer.skiptoken
			@elsestmtseq = Stmt_Seq.new
			@elsestmtseq.Parse_Stmt_Seq(tokenizer,idvals)
			token = tokenizer.gettoken
			if (token != "end")
				puts "Error: In if statement, word to be parsed should be \"end\"."
				Process.exit!()
			end
			tokenizer.skiptoken
			tokenizer.skiptoken
		else
			puts "blah"
			#Exit
		end
		#puts "Leaving If"
	end

	def Print_If(tabspaces)
		#Indent accoridngly and print statement, as well as the else portion if applicable
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		print "if "
		@condition.Print_Condition(0)
		print " then "
		print "\n\n"
		@ifstmtseq.Print_Stmt_Seq(tabspaces+1)
		print "\n"
		if (not (@elsestmtseq == nil))
			counter = 0
			while (counter < tabspaces)
				print "\t"
				counter = counter + 1
			end
			print "else "
			print "\n\n"
			@elsestmtseq.Print_Stmt_Seq(tabspaces+1)
			print "\n\n\n"
		end
		counter = 0
			while (counter < tabspaces)
				print "\t"
				counter = counter + 1
			end
		print "end ;\n\n"
	end

	def Execute_If(idvals,inputs)
		#if the condition is evaluated to true, execute the stmt
		if (@condition.Execute_Condition(idvals))
			@ifstmtseq.Execute_Stmt_Seq(idvals,inputs)
			#if there is an else stmt, execute it if the condition is not true
		elsif(not (@elsestmtseq == nil))
			@elsestmtseq.Execute_Stmt_Seq(idvals,inputs)
		end
	end
end

class Loop
	attr_accessor :condition
	attr_accessor :stmtseq
	
	def initialize
		@condition = Condition.new
		@stmtseq = Stmt_Seq.new
	end
	

	def Parse_Loop(tokenizer,idvals)
		#puts "Got to Loop"
		#Check syntax of loop and parse condition and stmt accordingly
		token = tokenizer.gettoken
		if (token != "while")
			puts "Error: In loop statememt, word to be parsed should be \"while\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		@condition.Parse_Condition(tokenizer,idvals)
		token = tokenizer.gettoken
		if (token != "loop")
			puts "Error: In loop statememt, word to be parsed should be \"loop\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		@stmtseq.Parse_Stmt_Seq(tokenizer,idvals)
		token = tokenizer.gettoken
		if (token != "end")
			puts "Error: In loop statememt, word to be parsed should be \"end\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		tokenizer.skiptoken
		#puts "Leaving Loop"
	end

	def Print_Loop(tabspaces)
		#Indent accordingly and print loop stmt
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		one = 1
		print "while "
		@condition.Print_Condition(0)
		print" loop"
		print"\n\n"
		@stmtseq.Print_Stmt_Seq(tabspaces+1)
		print"\n"
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		print "\n\n"
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		print "end ;\n\n"
	end

	def Execute_Loop(idvals,inputs)
		#While the condition remains, true, execute the stmt
		while (@condition.Execute_Condition(idvals))
			@stmtseq.Execute_Stmt_Seq(idvals,inputs)
		end
	end
end


class In
	attr_accessor :idlist
	
	def initialize
		@idlist = ID_List.new
	end

	def Parse_In(tokenizer,idvals)
		#puts "Got to In"
		#parse the id list for the read
		token = tokenizer.gettoken
		if (token != "read")
			puts "Error: In read statememt, word to be parsed should be \"read\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		@idlist.Parse_ID_List(tokenizer,idvals)
		tokenizer.skiptoken#semicolon
		#puts "Leaving In"
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

class Out
	attr_accessor :idlist
	
	def initialize
		@idlist = ID_List.new
	end

	def Parse_Out(tokenizer,idvals)
		#puts "Got to Out"
		#parse id list 
		token = tokenizer.gettoken
		if (token != "write")
			puts "Error: In write statememt, word to be parsed should be \"write\"."
			Process.exit!()
		end
		tokenizer.skiptoken
		@idlist.Parse_ID_List(tokenizer,idvals)
		tokenizer.skiptoken#semicolon
		#puts "Leaving Out"
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

#TO BE COMPLETED
class Condition

	attr_accessor :comp
	attr_accessor :cond
	attr_accessor :not
	attr_accessor :comboop
	
	def initialize
		@comp = nil
		@cond1 = nil
		@not = false
		@cond2 = nil
		@comboop = nil
	end

	def Parse_Condition(tokenizer,idvals)
		#puts "Got to Condition"
		#parse condition accordingly, parsing comparator if needed, negate or combine the condition with another
		token = tokenizer.gettoken
		if (token == "(")
			@comp = Comparator.new
			@comp.Parse_Comparator(tokenizer,idvals)
		elsif (token == '!')
			@not = true
			tokenizer.skiptoken
			@cond1 = Condition.new
			@cond1.Parse_Condition(tokenizer,idvals)
		elsif(token == '[')
			tokenizer.skiptoken
			@cond1 = Condition.new
			@cond1.Parse_Condition(tokenizer,idvals)
			token = tokenizer.gettoken#and or or
			#puts "token is #{token}"
			if (not(token == "&&" or token == "||"))
				puts "Error: In condition, symbol to be parsed should be \'&&\' or \'||\'."
				Process.exit!()
			end
			@comboop = token
			tokenizer.skiptoken
			@cond2 = Condition.new
			@cond2.Parse_Condition(tokenizer,idvals)
			token = tokenizer.gettoken#and or or
			if (not(token == "]"))
				puts "Error: In condition, symbol to be parsed should be \']\'."
				Process.exit!()
			end
			tokenizer.skiptoken
		end
		#puts "Leaving Condition"
	end

	def Print_Condition(tabspaces)
		#Indent and print according to depth of parse
		if (not(@comp == nil)) 
			@comp.Print_Comparator(0)
		elsif(@not == true)
			print "!"
			@cond1.Print_Condition(0)
		elsif(not (@cond2 == nil))
			print "["
			@cond1.Print_Condition(0)
			print " #{@comboop} "
			@cond2.Print_Condition(0)
			print "]"
		end

	end

	def Execute_Condition(idvals)
		#Evaluate condtion as neede d and return value
		condeval = nil
		if (not(@comp == nil)) 
			condeval = @comp.Execute_Comparator(idvals)
		elsif(@not == true)
			condeval = not(@cond1.Execute_Condition(idvals))
		elsif(not (@cond2 == nil))
			if (@comboop == "&&")
				condeval = ((@cond1.Execute_Condition(idvals)) and (@cond2.Execute_Condition(idvals)))
			elsif (@comboop == "||")
				condeval = ((@cond1.Execute_Condition(idvals)) or (@cond2.Execute_Condition(idvals)))
			end			
		end
		return condeval
	end

end

class Comparator

	attr_accessor :op1
	attr_accessor :compop
	attr_accessor :op2
	
	def initialize
		@op1 = Operator.new
		@compop = Comparison_Op.new
		@op2 = Operator.new
	end

	def Parse_Comparator(tokenizer,idvals)
		#Parse operators and comparison operator
		#puts "Got to Comparator"
		tokenizer.skiptoken#parenthese
		@op1.Parse_Operator(tokenizer,idvals)
		@compop.Parse_Comparison_Op(tokenizer)
		@op2.Parse_Operator(tokenizer,idvals)
		tokenizer.skiptoken#closing paranthese
		#puts "Leaving Comparator"
	end

	def Print_Comparator(tabspaces)
		#Indent and print accordingly
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		print "("
		@op1.Print_Operator(0)
		@compop.Print_Comparison_Op(0)
		@op2.Print_Operator(0)
		print ")"
	end

	def Execute_Comparator(idvals)
		#Execute the coomparator and return the value accoording to the comparison operator
		operator1 = @op1.Execute_Operator(idvals)
		operator2 = @op2.Execute_Operator(idvals)
		comp = @compop.Execute_Comparison_Op
		val = nil
		if (comp == '==')
			if (operator1 == operator2)
				val = true
			else
				val = false
			end
		elsif(comp == '!=')
			if  (not(operator1 == operator2))
				val = true
			else
				val = false
			end
		elsif (comp == '<')
			if (operator1 < operator2)
				val = true
			else
				val = false
			end
		elsif(comp == '>')
			if (operator1 > operator2)
				val = true
			else
				val = false
			end
		elsif (@comp== '<=')
			if (operator1 <= operator2)
				val = true
			else
				val = false
			end
		elsif(comp == '>=')
			if (operator1 >= operator2)
				val = true
			else
				val = false
			end
		end
		return val		
	end
end

class Exp
	attr_accessor :trm
	attr_accessor :addition
	attr_accessor :exp
	
	def initialize
		@trm = Term.new
		@addition = nil
		@exp = nil
	end

	def Parse_Exp(tokenizer,idvals)
		#puts "Got to Exp"
		#parse the term and if there id more, parse the remaining expression
		@trm.Parse_Term(tokenizer,idvals)
		token = tokenizer.gettoken
		if (token == "+" or token == "-")
			@addition = token
			tokenizer.skiptoken
			@exp = Exp.new
			@exp.Parse_Exp(tokenizer,idvals)
		else
			#not needed, as tokens other than these can occur
			# puts "Error: In expression, symbol to be parsed should be \'+\' or \'-'\'."
			# Process.exit!()
		end
		#puts "Leaving Exp"
	end

	def Print_Exp(tabspaces)
		#Indent and print accordingly
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		@trm.Print_Term(0)
		if (not (@addition == nil))
			print " #{addition} "
			@exp.Print_Exp(0)
		end
	end

	def Execute_Exp(idvals)
		#execute the expression and return the value
		expval = nil
		term1 = @trm.Execute_Term(idvals)
		expval = term1
		if (not (@addition == nil))
			exp1 = @exp.Execute_Exp(idvals)
			if (@addition == '+')
				expval = expval + exp1
			elsif (@addition == '-')
				expval = expval - exp1
			end			
		end
		return expval
	end
end

class Term
	
	attr_accessor :op1
	attr_accessor :trm
	
	def initialize
		@op1 = Operator.new
		@trm = nil
	end
	def Parse_Term(tokenizer,idvals)
		#puts "Got to Term"
		#parse the operator and if applicable the term after it
		@op1.Parse_Operator(tokenizer,idvals)
		token = tokenizer.gettoken
		if (token == "*")
			tokenizer.skiptoken
			@trm = Term.new
			@trm.Parse_Term(tokenizer,idvals)
		end	
		#puts "Leaving Term"
	end

	def Print_Term(tabspaces)
		#indent and print accordingly
		counter = 0
		while (counter < tabspaces)
			print "\t"
			counter = counter + 1
		end
		op1.Print_Operator(0)
		if (not(@trm == nil))
			print " * "
		@trm.Print_Term(0)
		end
	end

	def Execute_Term(idvals)
		#return the value of the term by recusrively evaluating operator or operator and term
		termval = nil
		termval = @op1.Execute_Operator(idvals)
		if (not(@trm == nil))
			othertermval = @trm.Execute_Term(idvals)
			termval = termval * othertermval
		end
		return termval
	end
end

class Operator

	attr_accessor :id
	attr_accessor :number
	attr_accessor :exp
	
	def initialize
		@id = nil
		@number = nil
		@exp = nil
	end
	def Parse_Operator(tokenizer,idvals)
		#puts "Got to Operator"
		#parse the operator, calling the appropriate parse call as needed
		token = tokenizer.gettoken
		if (token == "(")
			tokenizer.skiptoken
			@exp.Parse_Exp(tokenizer,idvals)
			tokenizer.skiptoken
		else
			if(tokenizer.evaltoken(token) == 32)
				@id = ID.new
				@id.Parse_ID(tokenizer,idvals)
			elsif (tokenizer.evaltoken(token) == 31)
				@number = token.to_i
				tokenizer.skiptoken
			else
				puts "Error: In Operator, input must be a number, identifier or expression."
					Process.exit!()
			end	
			
		end
		#puts "Leaving Operator"
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

class Comparison_Op
	@@symbols =['==', '!=', '<', '>', '<=', '>=']
	attr_accessor :symbol
	def initialize
		@symbol = nil
	end
	def Parse_Comparison_Op(tokenizer)
		#puts "Got to Comparison_Op"
		#Parse the comparison operator and ensure it is valid
		token = tokenizer.gettoken
		if (not (@@symbols.include?(token)))
			puts "Error: In comparison statement, comparison operator should be one of:[\'=='\, \'!=\', \'<\', \'>\', \'<=\', \'>=\']."
			Process.exit!()	
		end
		#The symbol comparison symbol gets stored in @symbol
		@symbol = token
		tokenizer.skiptoken
		#puts "Leaving Comparison_Op"
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

class ID
	attr_accessor :id
	def initialize
		@id = nil
	end
	def Parse_ID(tokenizer,idvals)
		#Parse the id and return the name of the id
		#puts "Got to ID"
		token = tokenizer.gettoken
		if (not (tokenizer.evaltoken(token) == 32))
			puts "Error: In ID, the identifier #{token} is not a valid identifier."
			Process.exit!()	
		end
		#The id variable gets the valid identifier stored
		@id = token
		tokenizer.skiptoken
		#puts "declared is #{$declared}, id is #{@id}"
		#Check if id being parsed is in idval hash already. if it is not and declaration has been completed, then the variable is undeclared.
		if (not(idvals.include?(@id)) and $declared == true)
			puts "Error: Undeclared variable #{id}."
			Process.exit!()	
		end
		return @id
		#tokenizer.skiptoken
		#puts"next token in ID is #{tokenizer.gettoken}"
		#puts "Leaving ID"
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

class Interpreter
	def interpretprog
		#Create program class and get input from user, if one is missing, terminate. If both are prompt the user for both filenames
		prog = Program.new
		filename = nil
		inputdata = nil
		if (not((ARGV[0] == nil) and (ARGV[1] == nil)))
			filename = ARGV[0]
			inputdata = ARGV[1]
		elsif (ARGV[0] == nil or ARGV[1] == nil)
			print("Please enter the Core program file name: ") 
			filename = gets.chomp
			print("Please enter the input file name: ") 
			inputdata = gets.chomp
		end
		if (filename == nil or inputdata == nil)
			puts "Error. Both filenames not provided. Please re run and provide necessary files"
		else
			if (not (File.file?(filename)))		
				puts "Error: Core Program file does not exist"
				Process.exit!()
			end
			if (not (File.file?(inputdata)))		
				puts "Error: Input file does not exist"
				Process.exit!()
			end
			#Proceed to parse, print and execute Core program
			prog.Parse_Program(filename)
			prog.Print_Program
			puts "\nResults for this program are:\n\n"
			prog.Execute_Program(inputdata)
		end
	end
	int = Interpreter.new
	#Intrepreter call
	int.interpretprog
end
