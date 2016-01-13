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