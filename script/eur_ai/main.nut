let runtime = require("eur_ai.runtime")
let config = require("eur_ai.config")
let game = require("game.state")
let events = require("game.events")
let hinterlandProtection = require("eur_ai.hinterland_protection")

// This module is loaded only by the EUR manifest.  Reapply on every script
// load because the engine's live EDB edits are intentionally not saved.
hinterlandProtection.apply()

function campaignProvider() {
  return ::Campaign.current()
}
let ai = runtime.create(game, ::scripting, config, campaignProvider, ::stratMap)
events.on("calculateLtgd", ai.calculate)
return ai
