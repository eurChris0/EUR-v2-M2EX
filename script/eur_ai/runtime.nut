let labels = require("eur_ai.labels")
let inputs = require("eur_ai.ltgd_inputs")
let evaluator = require("eur_ai.ltgd_evaluator")
let program = require("eur_ai.ltgd_rules.generated")
let transaction = require("eur_ai.transaction")
let diagnostics = require("eur_ai.diagnostics")

function allowed(game, scripting, config) {
  return config.enabled && scripting.port() == "medieval2" &&
    game.modName().tolower() == "divide_and_conquer_eur" &&
    game.eventCounter("imperial_campaign") == 1
}

function owns(faction) {
  return faction != null && faction.valid && faction.status == 0 &&
    faction.isPlayerControlled == 0 && faction.aiFrozen == 0 && !faction.isHorde &&
    labels.owns(faction.name)
}

function create(game, scripting, config, campaignProvider, stratMap) {
  let trace = diagnostics.create(game, config)
  local busy = false
  function calculate(ltgd) {
    if (busy) return
    try {
      if (!allowed(game, scripting, config) || ltgd == null || !ltgd.valid || !owns(ltgd.faction)) return
      busy = true
      let state = inputs.collect(campaignProvider(), ltgd.faction, ltgd, game, stratMap)
      let label = labels.resolve(game, state.owner)
      let original = transaction.capture(ltgd, state.targets)
      let result = evaluator.evaluate(program, state, original, label)
      transaction.apply(result, original)
      trace.decision(state, result)
    } catch (error) { trace.failure(error) }
    busy = false
  }
  return { calculate }
}
return { create }
