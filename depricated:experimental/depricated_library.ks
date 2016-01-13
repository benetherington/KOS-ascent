/////////////////// HANDY STUFF

function orbital_velocity {
  parameter target_alt.
  return sqrt( (constant:G * kerbin:mass)/(kerbin:radius + target_alt) ).
}

function time_to_nearest_ap { // allows negative ETA:apoapsis
  if (ship:orbit:period - ETA:apoapsis) > (ship:orbit:period / 2) {
    return ETA:apoapsis.  // we're approaching AP!
  } else {
     return 0 - (ship:orbit:period - ETA:apoapsis).  // we're past AP!
  }
}

function print_corner { parameter text. parameter mode. // 1: upper-left, 2: upper-right, 3: lower-left, 4: lower-right
  local row to 0.
  local col to 0.

  if mode = 2 or mode = 4 { set col to terminal:width - text:length. }
  if mode = 3 or mode = 4 { set row to terminal:height - 2. }

  print text at (col, row).
}

function print_corner_number { parameter number. parameter mode. // Same as above, only for numbers.
  local col to 0.
  local row to 0.

  if number = 0 {
    print_corner("0", mode).
  } else {
    if mode = 2 or mode = 4 { set col to terminal:width - (floor(log10(abs(number))) + 1). } // TODO: account for negative numbers
    if mode = 3 or mode = 4 { set row to terminal:height - 2. }
  }

  print number at (col, row).
}

function countdown_inline { // print the number of seconds from now to a target time.
  parameter target_time.

  if not (defined previous_time) {
    local previous_time to time:seconds.
  }

  if time:seconds - previous_time > 1 {
    print (-1 * floor(time:seconds - target_time)).
    set previous_time to time:seconds.
  }
}

function countdown_corner { // print the number of seconds from now to a target time in a corner.
  parameter target_time, corner.

  if not (defined previous_time) {
    local previous_time to time:seconds.
  }

  if time:seconds - previous_time > 1 {
    print_corner("  ", corner).
    print_corner_number( (-1 * floor(time:seconds - target_time)), corner).
    set previous_time to time:seconds.
  }
}

// TODO: text wrapping function.

wait .001.





/////////////////// DISCOVER

function lexicon_engine { // Find all stages with engines
  list engines in engines.
  global engine_lex to lexicon().
  for engine in engines {                // engine_lex is a lexicon filled with numbered stages.
    if engine_lex:haskey(engine:stage){  // engine_lex[1] is a list filled with engines in that stage
      engine_lex[engine:stage]:add(engine).
    }
    else {
      engine_lex:add(engine:stage, list(engine)).
    }
  }
  global live_stages_count to engine_lex:length.
}

function list_stages {  // Understand what each stage does.
  global stage_list to list().
  from { local x is 0. } until x >= stage:number step { set x to x + 1. } do {
    if engine_lex:haskey(x) {
      stage_list:add(1).
    } else {
      stage_list:add(0).
    }
  }
}

function find_fairings {
  global list_of_fairings to list().
  for part in ship:parts {
    for module in part:modules {
      if module = "ModuleProceduralFairing" {
        list_of_fairings:add(part).
      }
    }
  }
}

  // TODO: Find the minimum TWR of each stage with an engine
  // TODO: figure out when stages run out during an ascent profile
  // TODO: find what's under the fairing, decide if it's delicate, decide to auto deploy fairings earlier


wait .001.

/////////////////// PRELAUNCH

function autostage { // TODO: account for no fuel left. TODO: account for boosters. TODO: allow for a pause between decouple and iginition.
  when maxthrust = 0 then {
    if stage_flag = 1 {
      stage.
      preserve.
    }
  }
}

function autostage_fairings {
  parameter fairing_deploy_altitude.

  print fairing_deploy_altitude.

  if not (defined list_of_fairings) { print "no fairings here!". }
  else if list_of_fairings:length >= 1 {
    when ship:altitude > fairing_deploy_altitude then { // deploy dem fairings
      if stage_flag = 1 {
        for fairing in list_of_fairings {
          fairing:GETMODULE("ModuleProceduralFairing"):doaction("Deploy", true).
        }
      }
    }
  }
}

function limit_throttle { // take a requested throttle and limit it if it's too high.
  parameter requested_throttle.

  if not (defined maximum_safe_Gs) {
    global maximum_safe_Gs to 2.
  }

  local max_throttle to (ship:mass * maximum_safe_Gs / ship:availablethrust). // TODO: account for drag. Account for SRBs.

  return max(requested_throttle, max_throttle).
}

wait .001.

/////////////////// ASCENT

function calcpitch_ascent { // calculate a rough gravity turn
                            // TODO: figure out how to calculate an actual gravity turn.

  local a to 90.276.
  local b to 0.634.
  local c to 52949480000.
  local d to -469523.2.

  if ship:altitude < 150 { return 90. }
  else { return max(D+(A-D)/(1+( ship:altitude /C)^B) , 10). }
}

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

/////////////////// CIRCULARIZE

function precise_circ_throt { // start high, drop as PE rises
  if ship:periapsis < 0 {
    return 1.
  } else {
    return max(-0.00001267606 * ship:periapsis + 1, .1). //TODO allow custom target altitude
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

  until time:seconds >= good_time_to_start { countdown_corner(good_time_to_start, 4). }
  lock throttle to limit_throttle(.5).
  lock steering to heading(90, calcpitch_circ:update(time:seconds, time_to_nearest_ap()) ).
  
  until ship:periapsis > 0 {
    // print_corner_number(round(time_to_nearest_ap, 2), 3).
  }
  lock throttle to limit_throttle(.1).

  until ship:periapsis >= ship:altitude - 10 {
    // print_corner_number(round(time_to_nearest_ap, 2), 3).
  }
  lock throttle to 0.
}

wait .001.

/////////////////// ONORBIT

function list_solar_deploy { // find all deployable solar panels
  local panels to list().
  for part in ship:parts {
    for module in part:modules {
      if module = "ModuleDeployableSolarPanel" {
        panels:add(part).
      }
    }
  }
  global solar_deployable to panels.
}






