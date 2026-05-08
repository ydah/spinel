# Forward-ref `Class.new(arg)` whose Class is a subclass with its
# own `def initialize(_arg); super; end`. Pre-fix codegen widened
# the child's #initialize ptype from the call site but never
# propagated the type through the bare `super` to the parent's
# #initialize, leaving the parent's `owner` param at the default
# `mrb_int`. The parent's body `@owner = owner` then stored the
# int payload; subsequent `@owner.<method>` dispatches on a child
# instance landed on the wrong class via the int→class fallback.

class Outer
  def initialize
    @child = Sub.new(self)
  end
  def report
    @child.read_owner_name
  end
  def name; "outer"; end
end

class Base
  def initialize(owner)
    @owner = owner
  end
  def read_owner_name
    @owner.name
  end
end

class Sub < Base
  def initialize(_owner)
    super
  end
end

o = Outer.new
puts o.report
