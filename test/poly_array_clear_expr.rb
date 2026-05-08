# `Array#clear` in *expression* position on a poly_array. The
# stmt-form was already supported; the expr-form fell through
# to the unresolved-call warning and emitted literal 0, which
# made `c = a.clear` mistype `c` as int.
#
# Surfaced via optcarrot's `@sp_visible ||= @sp_map.clear` shape
# (the `||=` form needs a typed initializer here so Spinel's
# per-variable type inference has a concrete poly_array tag to
# unify with — Ruby allows type changes across reassignment but
# Spinel doesn't).

a = [1, "two", :three, [4, 5]]
b = a.clear

puts a.length    # 0
puts b.length    # 0 (b is a, just emptied — same array, just mutated)

# Subsequent push refills from index 0.
a.push(99)
puts a.length    # 1
