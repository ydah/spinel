# Nested blocks that capture a variable through string interpolation
# inside a block that itself captures the same variable.
#
# This exercises the @nd_parts recursion fix in scan_lambda_free_vars:
# LocalVariableReadNode("i") is nested under
#   InterpolatedStringNode → @nd_parts → EmbeddedStatementsNode → body
# and without @nd_parts recursion the variable is never detected as free.

class Defer
  def initialize
    @cnt = 0
  end

  def add(&blk)
    if @cnt == 0
      @blk0 = blk
    elsif @cnt == 1
      @blk1 = blk
    else
      @blk2 = blk
    end
    @cnt += 1
    nil
  end

  def call
    @blk2.call
    @blk1.call
    @blk0.call
  end
end

class Runner
  def self.with_deferred(&outer)
    d = Defer.new
    outer.call(d)
    d.call
  end
end

Runner.with_deferred do |d|
  i = 1
  d.add { puts "first #{i}" }
  i += 1
  d.add { puts "second #{i}" }
  puts "mid"
  i += 1
  d.add { puts "third #{i}" }
end
