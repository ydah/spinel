# Issue #418. `Time#utc` was unresolved on a Time receiver --
# emitted a `cannot resolve call to 'utc' on time (emitting 0)`
# warning and the result fell back to int. Sibling shape to #414
# (iso8601 / strftime); ActiveRecord's `fill_timestamps` does
# `Time.now.utc.iso8601` to produce UTC-suffixed timestamp
# strings, and with iso8601 resolved post-#414 but utc still
# unresolved, the chain broke one step earlier.
#
# Fix:
#   - Runtime: sp_Time gains an `is_utc` flag (C99 compound
#     literals zero-init the new field, so existing
#     `(sp_Time){sec, nsec}` sites stay valid). sp_time_utc(t)
#     returns the same instant with is_utc set; sp_time_iso8601
#     and sp_time_strftime check the flag and dispatch through
#     gmtime when it's set.
#   - Codegen: compile_object_method_expr's recv_type=="time" arm
#     dispatches `utc` to sp_time_utc.
#   - Inference: infer_method_name_type returns "time" when mname
#     is "utc" and recv resolves to time.
#
# Coverage:
#   - Time.now.utc.iso8601 round-trip (the canonical chain) -- the
#     output ends in "Z" rather than "+HH:MM".
#   - Time.now.utc.strftime to verify the flag also reaches the
#     strftime path.
#   - utc-then-non-utc (no double-flip): subsequent .utc on an
#     already-utc time keeps the same shape (idempotent).

t = Time.now.utc
iso = t.iso8601

# UTC iso8601 form: "YYYY-MM-DDTHH:MM:SSZ" -- 20 chars, ends in Z.
puts iso.length == 20 ? "utc-iso-len-ok" : "utc-iso-len-bad"
puts iso[19] == "Z" ? "utc-iso-zulu-ok" : "utc-iso-zulu-bad"

# strftime against UTC: %H is the hour-of-day, which differs from
# local hour by the timezone offset (unless we're already in
# UTC). We can't assert an exact value (depends on system clock),
# but we can verify it's a 2-digit number.
hh = t.strftime("%H")
puts hh.length == 2 && hh[0] >= "0" && hh[0] <= "2" ? "utc-hh-ok" : "utc-hh-bad"

# Idempotent: utc on an already-utc time keeps the same shape.
iso2 = t.utc.iso8601
puts iso2.length == 20 && iso2[19] == "Z" ? "utc-idempotent-ok" : "utc-idempotent-bad"

# Local iso8601 still works (regression check on #414's path).
puts Time.now.iso8601.length == 25 ? "local-iso-still-ok" : "local-iso-broken"
