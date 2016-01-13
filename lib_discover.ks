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
  global stage_list to list(). // TODO: change to queue.
  from { local x is 0. } until x >= stage:number step { set x to x + 1. } do {
    if engine_lex:haskey(x) {
      stage_list:add(1).
    } else {
      stage_list:add(0).
    }
  }
}

function find_fairings { // Find all fairings, put them in a list
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



