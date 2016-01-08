set terminal:visualbeep to true.

clearscreen.

run once library.ks.
run once modes.ks.

set calcpitch_circ to pidloop(2.4, .5, 3, -10, 10).

global target_orbit_height = 80000.
print "our cruising altitude today will be " + target_orbit_height + ".".

mode("circularize").

print "taking a deep breath.".
from { set dots to 5. } until dots = 0 step { set dots to dots - 1. } do { print "..." + dots. Wait 5. }

mode("onorbit").