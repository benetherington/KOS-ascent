run once lib_utilities.ks.

local start_time to time:seconds.

until time:seconds > start_time + 5 { countdown_inline(start_time + 5). }