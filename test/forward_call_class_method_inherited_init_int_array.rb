# Inherited-init forward-ref with an IntArray param flowing through
# the super call. The parent's `arr` param must end up
# `sp_IntArray *` (not the default `mrb_int`) so the body's
# `@arr = arr` stores the right pointer type and a parent-defined
# accessor reads the typed value.

class Driver
  def initialize
    @child = Subscriber.new([10, 20, 30, 40])
  end
  def report
    @child.length
  end
end

class Listener
  def initialize(arr)
    @arr = arr
  end
  def length
    @arr.length
  end
end

class Subscriber < Listener
  def initialize(_arr)
    super
  end
end

d = Driver.new
puts d.report
