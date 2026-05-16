# #553 (cielavenir). `N.times.map { block-returns-array }`
# now collects into a sp_PtrArray rather than sp_IntArray.
# Pre-fix codegen always built sp_IntArray for the outer
# accumulator, then `sp_IntArray_push` was handed an sp_IntArray
# pointer as its mrb_int second argument -- -Wint-conversion
# warning at compile time, garbage values at runtime.
#
# The fix routes any block-returns-array shape (int_array,
# str_array, float_array, sym_array, poly_array, or any
# *_ptr_array nesting) through sp_PtrArray; analyze's
# `<inner>_ptr_array` static type already existed for the
# normal `recv.map { array }` arm and the inspect helpers
# (sp_IntArrayPtrArray_inspect etc.) know how to format it.

a = 2.times.map { (0..2).map { |i| i + 1 } }
p a

b = 3.times.map { [10, 20, 30] }
p b
