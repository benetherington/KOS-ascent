function mode_discover { // Get info about this ship
  lexicon_engine().
  list_stages().
  find_fairings().
  print "discover complete.".
}

function mode_atmo_prelaunch { // Prep the computer and ship for launch
  
  set throttle_limit_controller to pidloop(1, 0, 0, 0, 1).

  lock throttle to 1. // TODO: fix limit throttle and implement
  set time_to_ap_throt to pidloop(3, .18, .045, 0, 1).
  set calcpitch_circ to pidloop(2.4, .5, 3, -10, 10). // TODO: could use further tweaking
  
  lock steering to heading(90, calcpitch_ascent()).

  global stage_flag to 0. // disable auto-staging until we've activated the first stage.

  autostage().
  autostage_fairings(30000).

  print "prelaunch complete.".
}




function mode_atmo_ascent { // Get pretty much anything into orbit
  stage.
  global stage_flag to 1. // enable autostaging.

  when time_to_nearest_ap() >= target_time_to_ap() then { // need a high-pass filter to reduce throttle jitter.
    lock throttle to time_to_ap_throt:update(time:seconds, time_to_nearest_ap() - target_time_to_ap()).
    print "Throttle limiting".
  }

  wait until ship:apoapsis >= target_orbit_height. //TODO: for high TWR vehicles, pitch down near end of ascent burn? Maybe minimum throttle?
  lock throttle to 0.
  lock steering to heading(90, 0).

  print "ascent complete.".
}

function mode_circularize {
  // TODO: ask for remaining time in stage, ditch nearly empty ascent stages before circularizing?
  local expected_arrival to time:seconds + eta:apoapsis.
  local burn_time to circularize_approximation().

  lock steering to heading(90, 0).

  if burn_time > (eta:apoapsis * .9) {
    full_throttle_circ_burn(burn_time, expected_arrival).
  } else {
    half_throttle_circ_burn(burn_time, expected_arrival).
  }
  print "circularize complete.".
}

function mode_onorbit { // Survive in space-ace-ace
  print "runmode on orbit".
  set stage_flag to 0.
  list_solar_deploy(). // TODO: refactor to push function into for/in?
  for panel in solar_deployable {
    panel:GETMODULE("ModuleDeployableSolarPanel"):DOEVENT("extend panels").
    wait 5.
  }
  unlock steering.
  set ship:control:pilotmainthrottle to 0.
  print "onorbit complete.".
}