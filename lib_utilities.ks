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

  if not (defined inline_previous_time) {
    global inline_previous_time to time:seconds. // TODO: allow multiple counters at once. Big scope issue.
  }

  if time:seconds - inline_previous_time > 1 {
    print (-1 * floor(time:seconds - target_time)).
    set inline_previous_time to time:seconds.
  }
}

function countdown_corner { // print the number of seconds from now to a target time in a corner.
  parameter target_time, corner.

  if not (defined corner_previous_time) {
    global corner_previous_time to time:seconds. // TODO: allow multiple counters at once. Big scope issue.
  }

  if time:seconds - corner_previous_time > 1 {
    print_corner("  ", corner).
    print_corner_number( (-1 * floor(time:seconds - target_time)), corner).
    set corner_previous_time to time:seconds.
  }
}

// TODO: text wrapping function.



