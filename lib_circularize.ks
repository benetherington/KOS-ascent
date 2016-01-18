/////////////////// CIRCULARIZE

function precise_circ_throt { // start high, drop as PE rises
  if ship:periapsis < 0 {
    return 1.
  } else {
    return max(-0.00001267606 * ship:periapsis + 1, .01). //TODO allow custom target eccentricity
  }
}


function full_throttle_circ_burn { // TODO: set throttle by TWR to allow for low-thrust upper stages.
  parameter burn_time, expected_arrival.

  local good_time_to_start to expected_arrival - burn_time/2.

  if time:seconds >= good_time_to_start + 2 {
    print "Initiating full-throttle AP burn.".
  } else {
    print "Coasting to full-throttle AP burn.".
  }

  until time:seconds >= good_time_to_start { countdown_corner(good_time_to_start, 4). }
  lock throttle to limit_throttle(1).
  lock steering to heading(90, calcpitch_circ:update(time:seconds, time_to_nearest_ap()) ).
  
  wait until ship:periapsis > 0.
  lock throttle to limit_throttle(.1).

  wait until ship:periapsis >= ship:altitude - 10.
  lock throttle to 0.
}

function half_throttle_circ_burn { parameter burn_time, expected_arrival.

  local good_time_to_start to expected_arrival - burn_time.
  local time_to_good_time to (good_time_to_start - time:seconds).

  print "Coasting to half-throttle AP burn.".

  // TODO: add timewarp.

  until time:seconds >= good_time_to_start { countdown_corner(good_time_to_start, 4). }
  lock throttle to limit_throttle(.5).
  lock steering to heading(90, calcpitch_circ:update(time:seconds, circularization_strategy()) ). // TODO: control by AP instead of time to AP? Ascend a bit too high then burn early?
  
  wait until ship:periapsis > 0. //TODO: control by throttle as long as possible.
  lock throttle to limit_throttle(.1). //TODO: control by smooth acceleration curve
  lock steering to heading(90, calcpitch_circ:update(time:seconds, time_to_nearest_ap()) ).

  wait until ship:periapsis >= ship:altitude - 10.
  lock throttle to 0.
}

function circularization_strategy { // Strategy to keep AP as close to the target as possible.
  if time_to_nearest_ap > 0 { return ship:apoapsis-target_orbit_height. }
                       else { return time_to_nearest_ap(). }
}




