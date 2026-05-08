# `Array#sort` (non-bang) on a float array. Surfaced via
# optcarrot's `@fps_history.sort[(@fps_history.length * 0.05).floor]`
# p95 calculation. Mirrors the existing int_array sort path —
# yields a fresh sorted array; the source stays untouched.

a = [3.5, 1.25, 2.0, 0.75, 4.125]
b = a.sort
puts b.length

i = 0
while i < b.length
  puts b[i]
  i = i + 1
end

# Source unchanged.
puts a[0]
puts a[1]
