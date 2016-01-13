set terminal:visualbeep to true.


global target_orbit_height to 75000.
global maximum_safe_Gs to 2.
//TODO: allow inclination selection
//TODO: allow coplanar launches


clearscreen. set ship:control:pilotmainthrottle to 0.

print "loading libraries into memory.".
run once lib_utilities.ks.
run once lib_discover.ks.
run once lib_atmo_ascent.ks.
run once lib_circularize.ks.
run once lib_onorbit.ks.
run once modes.ks.

print "our cruising altitude today will be " + target_orbit_height + ".".

mode_discover().
mode_atmo_ascent().
mode_circularize().

print "taking a deep breath.".
local countdown_to_onorbit to time:seconds + 10.
until time:seconds >= countdown_to_onorbit { countdown_inline(countdown_to_onorbit). }

mode_onorbit().
