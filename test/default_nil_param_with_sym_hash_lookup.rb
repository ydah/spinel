# Sym-keyed sibling of #482. Same shape — nil-default param +
# body uses param as Hash receiver — but with a SymbolNode key
# instead of a StringNode key. The widening pass now distinguishes
# between str / sym keys and picks sym_str_hash instead of
# str_str_hash when the body's `param[<key>]` carries a symbol.

class Box
  attr_accessor :s
  def initialize(other = nil)
    @s = nil
    return if other.nil?
    v = other[:key]
    @s = v if !v.nil?
  end
end

b = Box.new
b.s = "hello"
puts b.s
