# A while condition that depends on a mutated receiver must be evaluated on
# every iteration.

items = [1, 2, 3]
sum = 0

while items.length > 0
  item = items.pop
  sum += item
end

puts sum
puts items.length
