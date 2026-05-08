# Inherited-init forward-ref where the param type is itself an
# obj_X user class. Verifies the type flows through both the
# `Class.new(@h)` constructor branch and the bare `super` of the
# child's initialize.

class Holder
  def initialize(name)
    @name = name
  end
  def label
    "h:#{@name}"
  end
end

class Outer
  def initialize
    @h = Holder.new("alpha")
    @child = Sub.new(@h)
  end
  def report
    @child.held_label
  end
end

class Base
  def initialize(holder)
    @holder = holder
  end
  def held_label
    @holder.label
  end
end

class Sub < Base
  def initialize(_holder)
    super
  end
end

o = Outer.new
puts o.report
