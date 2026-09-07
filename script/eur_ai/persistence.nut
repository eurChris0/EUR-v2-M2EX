// Save only strategic observations. Never store engine objects or numeric ids.
function read(persistent, name, turn) {
  let root = persistent?.eurAi
  if (root != null && (typeof root != "table" || root?.version != 1))
    throw "Unsupported eurAi memory version; native AI retained"
  if (root != null && typeof root?.factions != "table") throw "Invalid eurAi faction memory"
  let old = root?.factions?[name]
  if (old == null) return { target = null, heldTurns = 0, lastTurn = turn }
  if (typeof old != "table" || typeof old?.heldTurns != "integer" ||
      typeof old?.lastTurn != "integer" || old.heldTurns < 0 ||
      (old?.target != null && typeof old.target != "string")) throw "Invalid strategic memory"
  // Loading an earlier save must not invent time spent pursuing a target.
  if (old.lastTurn > turn) return { target = null, heldTurns = 0, lastTurn = turn }
  return { target = old.target, heldTurns = old.heldTurns, lastTurn = old.lastTurn }
}
function advance(memory, turn, activeTurn = true) {
  return { target = memory.target,
    heldTurns = memory.heldTurns + (activeTurn && turn > memory.lastTurn ? 1 : 0),
    lastTurn = activeTurn ? turn : memory.lastTurn }
}
function commit(persistent, name, memory) {
  let factions = persistent?.eurAi == null ? {} : clone persistent.eurAi.factions
  factions[name] <- clone memory
  persistent.eurAi <- { version = 1, factions }
}
return { read, advance, commit }
