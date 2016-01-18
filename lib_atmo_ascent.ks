/////////////////// ASCENT


// init variables
global staging_cooldown_bookmark to time:seconds.
// TODO: define backup global staging_cooldown_buffer.
// TODO: define backup stage_flag.


function autostage { // TODO: account for strap-on boosters. TODO: account for ullage motors.
  when (   (there_are_flamed_out_engines() or ship:maxthrust = 0) and staging_cooldown() ) and stage_flag = 1 then {
    log "autostage" to log.txt.
    stage.
    preserve.
  }
}

function autostage_fairings { // take a list of fairings and eject them when the time is right
  parameter incoming_altitude.

  global fairing_deploy_altitude to incoming_altitude. // local scope makes this value unavailable in the following trigger

  when (ship:altitude > fairing_deploy_altitude) then { 
    if stage_flag = 1 {
      for fairing in list_of_fairings {
        fairing:GETMODULE("ModuleProceduralFairing"):doaction("Deploy", true).
      }
    }
  }
}

function on_stage { // flipflops back and forth when you stage, resetting staging_cooldown_bookmark.
  when stage:ready then {
    when not stage:ready then { set staging_cooldown_bookmark to time:seconds. on_stage(). }
  }
}

function staging_cooldown {
  return ( staging_cooldown_bookmark+staging_cooldown_buffer < time:seconds ).
}



function limit_throttle { // take a requested throttle and limit it if it causes acceleration higher than max limit
  parameter requested_throttle.

  local max_throttle to 1.
  
  return min(requested_throttle, max_throttle).
}


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
//  local b to 60. // TODO: think about target time to AP and make it a bit smarter
//  local a to -b/target_orbit_height.
//  return a * (ship:altitude) + b.
  return 60.
}

function circularize_approximation { // figure out how long the circularization burn will take
  local dv_needed to orbital_velocity(target_orbit_height) - velocityat(ship, time + ETA:apoapsis):orbit:mag. // TODO: allow custom target orbit eccentricity
  local momentary_acceleration to ship:availablethrust/ship:mass.

  return dv_needed/momentary_acceleration.
}





// init functions
on_stage().
wait .001.



