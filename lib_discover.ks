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
} // TODO: consider filling out stages without engines to eliminate error checking down the line.

function list_stages {  // Understand what each stage does. Must be run before decoupling clamps.
  global stage_list to list(). // TODO: change to queue.
  from { local x is 0. } until x >= stage:number step { set x to x + 1. } do {
    if engine_lex:haskey(x) {
      stage_list:add(1).
    } else {
      stage_list:add(0).
    }
  }
}

function there_are_flamed_out_engines { // returns true if there aren't engines or if any of them are flamed out.
                                        // ONLY WORKS WHEN THROTTLED UP!
  list engines in engines.
  for engine in engines {
    if engine:flameout { return true. } 
  }
  return false. // if we got to this point, there must not be any dead engines.
}

function there_are_no_active_engines {
  if stage:number > stage_list:length-1 { return true. } // If we haven't staged yet, we're on an extra, invisible stage.
  return stage_list[stage:number] = 0.
}

function next_stage_with_engines { // must be run after decoupling clamps.

  if stage:number = 0 { return 0. }
  else { local with_engines to -1. } // init with an error code.

  from { local inspect_stage to stage:number - 1. } // start with the next stage.
    until stage_list[inspect_stage] = 1
    step { set inspect_stage to inspect_stage - 1. }
    do { set with_engines to inspect_stage - 1. } // get ready to return the next stage, because this loop won't run again if so.

  return with_engines.
}


function find_fairings { // Find all fairings, put them in a list. TODO: include parts dubbed fairing.
  global list_of_fairings to list().
  for part in ship:parts {
    for module in part:modules {
      if module = "ModuleProceduralFairing" {
        list_of_fairings:add(part).
      }
    }
  }
}

function TWR {
  return ship:availablethrust/ship:mass/9.81.
}

function throttle_needed_for_TWR_of {
  parameter TWR_needed.
  return (TWR_needed/TWR()).
}


  // TODO: log TWR to find good requirements.
  // TODO: Find the minimum TWR of each stage with an engine. Limit if too high (to save pogo)
  // TODO: figure out when stages run out during an ascent profile
  // TODO: find what's under the fairing, decide if it's delicate, decide to auto deploy fairings earlier/later



