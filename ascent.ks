set terminal:visualbeep to true.


global target_orbit_height to 75000.
global maximum_safe_Gs to 2.



clearscreen. set ship:control:pilotmainthrottle to 0.

print "loading libraries into memory.".
run once lib_utilities.ks.
run once lib_discover.ks.
run once lib_atmo_prelaunch.ks.
run once lib_atmo_ascent.ks.
run once lib_circularize.ks.
print "finished loading libraries.".

print "our cruising altitude today will be " + target_orbit_height + ".".

run modes("discover").
run modes("atmo_prelaunch").
run modes("atmo_ascent").
run modes("circularize").

print "taking a deep breath.".
local countdown_to_onorbit to time:seconds + 10.
until countdown_to_onorbit >= time:seconds { countdown_inline(countdown_to_onorbit). }

mode("onorbit").