/////////////////// ASCENT

function target_time_to_ap { // can be uncommented/refined for single burn to orbit
//  local b to 60.
//  local a to -b/target_orbit_height.
//  return a * (ship:altitude) + b.
  return 60.
}

function circularize_approximation { // figure out how long the circularization burn will take
  local dv_needed to orbital_velocity(target_orbit_height) - velocityat(ship, time + ETA:apoapsis):orbit:mag. // TODO: allow custom target orbit
  local momentary_acceleration to ship:availablethrust/ship:mass.
  return dv_needed/momentary_acceleration.
}

wait .001.



