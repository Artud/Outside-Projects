#!/usr/bin/ruby
require 'stringio'
require 'set'

class Token
  attr_reader :type, :line, :col

  def initialize(type,lineNum,colNum)
    @type = type
    @line = lineNum
    @col = colNum
  end
end

class LexicalToken < Token
  attr_reader :lex

  def initialize(type,lex,lineNum,colNum)
    super(type,lineNum,colNum)

    @lex = lex
  end
end

class Scanner
  def initialize(inStream)
    @istream = inStream
    @keywords = Set.new(["S","R","P","M","C"])
    @lineCount = 1
    @colCount = -1
    @needToken = true
    @lastToken = nil
  end

  def putBackToken()
    @needToken = false
  end

  def getToken()
    if !@needToken
      @needToken = true
      return @lastToken
    end

    state = 0
    foundOne = false
    c = @istream.getc()

    if @istream.eof() then
      @lastToken = Token.new(:eof,@lineCount,@colCount)
      return @lastToken
    end

    while !foundOne
      @colCount = @colCount + 1
      case state
        when 0
          lex = ""
          column = @colCount
          line = @lineCount
          if isLetter(c) then state=1
          elsif isDigit(c) then state=2
          elsif c == ?+ then state = 3
          elsif c == ?- then state = 4
          elsif c == ?* then state = 5
          elsif c == ?/ then state = 6
          elsif c == ?% then state = 7
          elsif c == ?( then state = 8
          elsif c == ?) then state = 9
          elsif c == ?\n then
            @colCount = -1
            @lineCount = @lineCount+1
          elsif isWhiteSpace(c) then state = state #ignore whitespace
          elsif @istream.eof() then
            @foundOne = true
            type = :eof
          else
            puts "Unrecognized Token found at line ",line," and column ",column,"\n"
            raise "Unrecognized Token"
          end
        when 1
          if isLetter(c) or isDigit(c) then state = 1
          else
            if @keywords.include?(lex) then
              foundOne = true
              type = :keyword
            else
              foundOne = true
              type = :identifier
            end
          end
        when 2
          if isDigit(c) then state = 2
          else
            type = :number
            foundOne = true
          end
        when 3
          type = :add
          foundOne = true
        when 4
          type = :sub
          foundOne = true
        when 5
          type = :times
          foundOne = true
        when 6
          type = :divide
          foundOne = true
        when 7
          type = :mod
		  foundOne = true
        when 8
          type = :lparen
          foundOne = true
        when 9
          type = :rparen
          foundOne = true
      end

      if !foundOne then
        lex.concat(c)
        c = @istream.getc()
      end

    end

    @istream.ungetc(c)
    @colCount = @colCount - 1
    if type == :number or type == :identifier or type == :keyword then
      t = LexicalToken.new(type,lex,line,column)
    else
      t = Token.new(type,line,column)
    end

    @lastToken = t
    return t
  end

  private
  def isLetter(c)
    return ((?a <= c and c <= ?z) or (?A <= c and c <= ?Z))
  end

  def isDigit(c)
    return (?0 <= c and c <= ?9)
  end

  def isWhiteSpace(c)
    return (c == ?\  or c == ?\n or c == ?\t)
  end
end

class BinaryNode
  attr_reader :left, :right

  def initialize(left,right)
    @left = left
    @right = right
  end
end

class UnaryNode
  attr_reader :subTree

  def initialize(subTree)
    @subTree = subTree
  end
end

class AddNode < BinaryNode
  def initialize(left, right)
    super(left,right)
  end

  def evaluate()
    @left.evaluate()
    @right.evaluate()
    if $compilador
		$calc.out.write("# Add\n")
		$calc.out.write("	operator2 := M[sp + 0]\n")
		$calc.out.write("	operator1 := M[sp+1]\n")
		$calc.out.write("	operator1 := operator1 + operator2\n")
		$calc.out.write("	sp := sp + one\n")
		$calc.out.write("	M[sp+0] := operator1\n")
		#return @left.evaluate() + @right.evaluate()
    else
		return @left.evaluate() + @right.evaluate()
    end
  end
end

class SubNode < BinaryNode
  def initialize(left, right)
    super(left,right)
  end

  def evaluate()
    @left.evaluate()
    @right.evaluate()
    if $compilador
		$calc.out.write("# Sub\n")
		$calc.out.write("	operator2 := M[sp + 0]\n")
		$calc.out.write("	operator1 := M[sp+1]\n")
		$calc.out.write("	operator1 := operator1 - operator2\n")
		$calc.out.write("	sp := sp + one\n")
		$calc.out.write("	M[sp+0] := operator1\n")
	else
		return @left.evaluate() - @right.evaluate()
    end
  end
end

class NumNode
  def initialize(num)
    @num = num
  end

  def evaluate()
	if $compilador
		$calc.out.write("# Push\n")
		$calc.out.write("	sp := sp - one\n")
		$calc.out.write("	operator1 :=  ")
		$calc.out.write(@num)
		$calc.out.write("\n")
		$calc.out.write("	M[sp + 0] := operator1\n")
		#return @num
	else
		return @num
    end
  end
end

class TimesNode < BinaryNode
  def initialize(left, right)
    super(left,right)
  end

  def evaluate()
    @left.evaluate()
    @right.evaluate()
    if $compilador
		$calc.out.write("# Times\n")
		$calc.out.write("	operator2 := M[sp + 0]\n")
		$calc.out.write("	operator1 := M[sp+1]\n")
		$calc.out.write("	operator1 := operator1 * operator2\n")
		$calc.out.write("	sp := sp + one\n")
		$calc.out.write("	M[sp+0] := operator1\n")
	else
		return @left.evaluate() * @right.evaluate()
	end
  end
end

class DivNode < BinaryNode
  def initialize(left, right)
    super(left,right)
  end

  def evaluate()
    @left.evaluate()
    @right.evaluate()
    if $compilador
		$calc.out.write("# Divide\n")
		$calc.out.write("	operator2 := M[sp + 0]\n")
		$calc.out.write("	operator1 := M[sp+1]\n")
		$calc.out.write("	operator1 := operator1 / operator2\n")
		$calc.out.write("	sp := sp + one\n")
		$calc.out.write("	M[sp+0] := operator1\n")
	else
		return @left.evaluate() / @right.evaluate()
	end
  end
end

class ModNode < BinaryNode
  def initialize(left, right)
    super(left,right)
  end

  def evaluate()
    @left.evaluate()
    @right.evaluate()
    if $compilador
		$calc.out.write("# Mod\n")
		$calc.out.write("	operator2 := M[sp + 0]\n")
		$calc.out.write("	operator1 := M[sp+1]\n")
		$calc.out.write("	operator1 := operator1 % operator2\n")
		$calc.out.write("	sp := sp + one\n")
		$calc.out.write("	M[sp+0] := operator1\n")
	else
		return @left.evaluate() % @right.evaluate()
	end
  end
end

class StoreMem < UnaryNode
  def initialize(subTree)
    super(subTree)
  end

  def evaluate()
    @subTree.evaluate()
    if $compilador
		$calc.out.write("# Store\n")
		$calc.out.write("	memory := M[sp+0]\n")
	else
		$calc.memory = @subTree.evaluate()
	end
  end
end

class PlusMem < UnaryNode
  def initialize(subTree)
    super(subTree)
  end

  def evaluate()
    @subTree.evaluate()
    if $compilador
		$calc.out.write("# Memory Plus\n")
		$calc.out.write("	operator2 := M[sp+0]\n")
		$calc.out.write("	memory := memory + operator2\n")
		$calc.out.write("	M[sp+0] := memory\n")
	else
		$calc.memory = @subTree.evaluate() + $calc.memory
	end
  end
end

class MinusMem < UnaryNode
  def initialize(subTree)
    super(subTree)
  end

  def evaluate()
    @subTree.evaluate()
    if $compilador
		$calc.out.write("# Memory Minus\n")
		$calc.out.write("	operator2 := M[sp+0]\n")
		$calc.out.write("	memory := memory - operator2\n")
		$calc.out.write("	M[sp+0] := memory\n")
	else
		$calc.memory = $calc.memory - @subTree.evaluate()
	end
  end
end

class RecallMem
  def evaluate()
	if $compilador
		$calc.out.write("# Recall\n")
		$calc.out.write("	sp := sp - one\n")
		$calc.out.write("	M[sp+0] := memory\n")
	else
		return $calc.memory
	end
  end
end


class ClearMem
  def evaluate()
	if $compilador
		$calc.out.write("# Memory\n")
		$calc.out.write("	memory := zero\n")
		$calc.out.write("	sp := sp - one\n")
		$calc.out.write("	M[sp+0] := memory\n")
	else
		return $calc.memory = 0
	end
  end
end

class Parser
  def initialize(istream)
    @scan = Scanner.new(istream)
  end

  def parse()
    return Prog()
  end

  private
  def Prog()
    result = Expr()
    t = @scan.getToken()

    if t.type != :eof then
      print "Expected EOF. Found ", t.type, ".\n"
      raise "Parse Error"
    end

    return result
  end

  def Expr()
    return RestExpr(Term())
  end

  def RestExpr(e)
    t = @scan.getToken()

    if t.type == :add then
      return RestExpr(AddNode.new(e,Term()))
    end

    if t.type == :sub then
      return RestExpr(SubNode.new(e,Term()))
    end


    @scan.putBackToken()

    return e
  end

  def Term()
    return RestTerm(Storable())
  end

  def RestTerm(e)
    t = @scan.getToken()

    if t.type == :times then
      return RestExpr(TimesNode.new(e,Term()))
    end

    if t.type == :divide then
      return RestExpr(DivNode.new(e,Term()))
    end

	if t.type == :mod then
      return RestExpr(DivNode.new(e,Term()))
    end
    
    @scan.putBackToken()

    return e
  end

  def Storable()
    return MemOperation(Factor())
  end

  def MemOperation(e)
    t = @scan.getToken()

    if t.type == :keyword
      if t.lex == ('S')
        return StoreMem.new(e)
      elsif t.lex == ('P')
        return PlusMem.new(e)
      elsif t.lex == ('M')
        return MinusMem.new(e)
      end
    end

    @scan.putBackToken()

    return e
  end

  def Factor()
    t = @scan.getToken()
      if t.type == :number
        val = t.lex.to_i
        return NumNode.new(val)
      end
    if t.type == :keyword
      if t.lex == ("R")
        return RecallMem.new()
      elsif t.lex == ("C")
		return ClearMem.new()
	  end
    end
    @scan.putBackToken()
  end
end 
 



class Calculator
  attr_reader :memory, :out
  attr_writer :memory

  def initialize(salProg)
    @out = salProg
    @memory = 0
  end

  def eval(expr)
    parser = Parser.new(StringIO.new(expr))
    ast = parser.parse()
    if $compilador
		@out.write("# Instrucciones antes del recorrido del arbol abstracto sintactico.\n")
		@out.write("	sp := 1000\n")
		@out.write("	one := 1\n")
		@out.write("	zero := 0\n")
		@out.write("	memory := zero\n")
		ast.evaluate()
		@out.write("# Write Result\n")
		@out.write("	operator1 := M[sp+0]\n")
		@out.write("	sp := sp - one\n")
		@out.write("	writeInt(operator1)\n")
		@out.write("end: halt\n")
		@out.write("equ memory M[0]\n")
		@out.write("equ one M[1]\n")
		@out.write("equ zero M[2]\n")
		@out.write("equ operator1 M[3]\n")
		@out.write("equ operator2 M[4]\n")
		@out.write("equ sp M[5]\n")
		@out.write("equ stack M[1000]\n")
    else
		return ast.evaluate()
    end
  end
end


for h in 0..ARGV.length - 1
    text2 = ""
	if ARGV[h] == "-c"
		 $compilador = true
	else
		nombreArch = ARGV[h].to_s
		archivoAbierto = File.open(nombreArch, "r") do |f|
		f.each_line do |line|
		puts "Expresion " + line
		text2 += line
	    end
	    end
	    file = 0
	    $calc = Calculator.new(file)
		$calc.eval(text2)	
		puts ">= " + $calc.eval(text2).to_s
	end
end

ARGV.clear
if $compilador
	file = File.open("a.ewe","w")
	$calc = Calculator.new(file)
	text = gets
	$calc.eval(text)
	$compilador = false
	ARGV.clear
else
	file = 0
	until STDIN.eof? do
		STDOUT.putc '>' 
		text = gets
		$calc = Calculator.new(file)
		puts "= #{$calc.eval(text)}"
     end
	#$calc = Calculator.new(file)
	#puts ">= " + $calc.eval(text).to_s
end












