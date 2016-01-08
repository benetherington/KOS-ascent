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

global runmode to "discover".
run modes.
wait until runmode = "idle".

global runmode to "atmo_prelaunch".
run modes.
wait until runmode = "idle".

global runmode to "atmo_ascent".
run modes.
wait until runmode = "idle".

global runmode to "circularize".
run modes.
wait until runmode = "idle".

// print "taking a deep breath.".
// local countdown_to_onorbit to time:seconds + 10.
// until countdown_to_onorbit >= time:seconds { countdown_inline(countdown_to_onorbit). }

// mode("onorbit").