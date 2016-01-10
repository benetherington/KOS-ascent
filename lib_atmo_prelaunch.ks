/////////////////// PRELAUNCH

function autostage { // TODO: account for no fuel left. TODO: account for boosters. TODO: allow for a pause between decouple and iginition.
  when stage:liquidfuel < 0.1 then {
    if stage_flag = 1 { // TODO: implement stage:ready
      stage.
      preserve.
    }
  }
}

function autostage_fairings {
  parameter incoming_altitude.
  global fairing_deploy_altitude to incoming_altitude.

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

// SET PREV_TIME to TIME:SECONDS.
// SET PREV_VEL to SHIP:VELOCITY.
// SET ACCEL to V(9999,9999,9999).
// PRINT "Waiting for accellerations to stop.".
// UNTIL ACCEL:MAG < 0.5 {
//     SET ACCEL TO (SHIP:VELOCITY - PREV_VEL) / (TIME:SECONDS - PREV_TIME).
//     SET PREV_TIME to TIME:SECONDS.
//     SET PREV_VEL to SHIP:VELOCITY.

//     WAIT 0.001.  // This line is Vitally Important.
// }


//   if not (defined maximum_safe_Gs) {
//     global maximum_safe_Gs to 2.
//   }

//   local max_throttle to throttle_limit_controller:update(time:seconds, )
//   return min(requested_throttle, max_throttle).
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



