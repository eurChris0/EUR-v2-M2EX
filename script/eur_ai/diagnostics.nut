function create(game, config) {
  let reported = {}
  return {
    failure = function(message) {
      let text = message.tostring()
      if (reported?[text] != null) return
      reported[text] <- true
      try { game.log("[EUR AI] Native fallback: " + text) }
      catch (_) { print("[EUR AI] Native fallback: " + text + "\n") }
    }
    decision = function(snapshot, result) {
      if (!config.tracing) return
      game.log("[EUR AI] turn=" + snapshot.turn + " faction=" + snapshot.owner.name +
        " label=" + result.label + " targets=" + result.rows.len() +
        " defend_matches=" + result.defendMatches +
        " invade_matches=" + result.invadeMatches)
    }
  }
}
return { create }
