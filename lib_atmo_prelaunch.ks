/////////////////// PRELAUNCH

function autostage { // TODO: account for no fuel left. TODO: account for boosters. TODO: allow for a pause between decouple and iginition.
  when stage:liquidfuel < 0.1 then {
    if stage_flag = 1 {
      stage.
      preserve.
    }
  }
}

function autostage_fairings {
  parameter incoming_altitude.
  local fairing_deploy_altitude to incoming_altitude.

  when ship:altitude > fairing_deploy_altitude then { // deploy dem fairings
    if stage_flag = 1 {
      for fairing in list_of_fairings {
        fairing:GETMODULE("ModuleProceduralFairing"):doaction("Deploy", true).
      }
    }
  }
}

function limit_throttle { // take a requested throttle and limit it if it's too high.
  parameter requested_throttle.

  if not (defined maximum_safe_Gs) {
    global maximum_safe_Gs to 2.
  }

  local max_throttle to (ship:mass * maximum_safe_Gs / max(ship:availablethrust,1)). // TODO: account for drag. Account for SRBs.
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



