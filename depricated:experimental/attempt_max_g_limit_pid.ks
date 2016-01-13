clearscreen.

global old_time to time:seconds.
global last_vel to 0.
global current_acc to 200.

global maximum_safe_Gs to .2.
set max_g_throt to pidloop(.06, 15, 0.006, 0, 1).


function countdown_inline { // print the number of seconds from now to a target time.
  parameter target_time.

  if not (defined previous_time) {
    local previous_time to time:seconds.
  }

  if not (defined inline_previous_time) {
    global inline_previous_time to time:seconds. // TODO: allow multiple counters at once. Big scope issue.
  }

  if time:seconds - inline_previous_time > 1 {
    print (-1 * floor(time:seconds - target_time)).
    set inline_previous_time to time:seconds.
  }
}

function current_acceleration {
  
                            function time_rememberer {
                              parameter new_time.
                              local spit_time to old_time.
                              if new_time <> "last" { set old_time to new_time. }
                              return spit_time.
                            }


  print "       " at(10,12).
  if ( time:seconds - time_rememberer("last") ) > 0.0001 {
    global current_acc to abs( ((ship:velocity:surface:mag - last_vel) /
                                            (time:seconds - time_rememberer("last"))) / 9.81 ).
        time_rememberer(time:seconds).
        set last_vel to ship:velocity:surface:mag.
  }
  
  return current_acc.
}

// function limit_throttle { // take a requested throttle and limit it if it causes acceleration higher than max limit
//   parameter requested_throttle.

//   local max_throttle to max_g_throt:update(time:seconds, current_acceleration() - maximum_safe_Gs).

//   print "current_acceleration: " + current_acceleration() at(10,10).
//   print "max_throttle: " + max_throttle at(10,11).

//   return min(requested_throttle, max_throttle).
// }

lock throttle to max_g_throt:update(time:seconds, current_acceleration() - maximum_safe_Gs).

global end_timer to time:seconds + 5.

until time:seconds > end_timer {
  log time:seconds + "," + current_acceleration() + "," + max_g_throt:output to log.csv.
  // print max_g_throt:output at(10,11).
  // print max_g_throt:lastsampletime at(10,12).
  countdown_inline(end_timer).
}







