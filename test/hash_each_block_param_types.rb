# `h.each do |k, v|` previously had its block params typed via
# elem_type_of_array(recv_type), which only knows about typed
# arrays — for a hash receiver it fell back to "int" for both
# `k` and `v`. Code inside the block like `puts k + ": " + v.to_s`
# then had analyze cache (and codegen's infer_type fallback)
# return "int" for the chained `+`, lowering `puts` to
# `printf("%lld", (long long)(string_concat + int_to_s))` — both
# the cast and the raw `+` between pointers fail C compile.
#
# Fix: block_param_type_at now branches on is_hash_type for the
# `each` family and returns the hash's key part for pi==0 and the
# value part for pi==1, expanded to full names (str→string,
# sym→symbol). Codegen's infer_type CallNode cache-miss path also
# learned `+` on string recv returns string and `.to_s` returns
# string, covering nodes inside block bodies that walk_and_cache
# doesn't cache.

h = { "a" => 1, "b" => 2 }
h.each do |k, v|
  puts k + ": " + v.to_s
end
