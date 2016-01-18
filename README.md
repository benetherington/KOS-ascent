This program might require a higher IPU than expected (~350) until it is optimized.

This suite is broken into the widest and tallest tree that makes sense.

The highest level is a "director" program that is run by the user. It calls up different modes and feeds them variables as required by the mission profile. At this time, the only director is "Ascent.ks," which will get an ascent vehicle with > 3500 m/s of dV into low Kerbin orbit. You can change your orbit parameters (currently just altitude), by editing the variables at the top.

The second level is the "modes" program. It loads functions into memory that are then called by the director. These functions control each phase of the mission profile. The Discover mode learns about the ship. The Atmo-Ascent mode autostages, throttle limits and performs a (as yet) rough gravity turn. The Circularize mode decides how agressive to be at apoapsis and gets the vehicle into a nice, circular orbit. The Onorbit mode deploys any solar arrays.

The third level are the library programs. These load functions into memory that are called by each mode in turn. These are the very guts of the suite. Also included is a utilities library that is used for displaying information and making calculations about the vehicle's situation and flightpath.