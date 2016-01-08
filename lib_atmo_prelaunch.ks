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





