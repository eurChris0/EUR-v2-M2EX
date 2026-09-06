let profiles = require("eur_ai.profiles")
function integer(value, label, nonnegative = false) {
  if (typeof value != "integer" || (nonnegative && value < 0)) throw "Missing/invalid " + label
  return value
}
function valid(value, label) {
  if (value == null || !value.valid) throw "Missing " + label
  return value
}
function allowed(game, scripting, config) {
  return config.enabled && scripting.port() == "medieval2" &&
    game.modName().tolower() == "divide_and_conquer_eur" && game.eventCounter("imperial_campaign") == 1
}
function owns(faction) {
  return faction != null && faction.valid && faction.status == 0 && faction.isPlayerControlled == 0 &&
    faction.aiFrozen == 0 && faction.name != "slave" && profiles.utility?[faction.name] == null &&
    profiles.get(faction.name) != null
}
function collect(campaign, owner, ltgd, game) {
  valid(campaign, "campaign")
  if (!campaign.isOpen) throw "Campaign is not open"
  let stats = valid(owner.aiStats(), "owner statistics")
  let record = valid(owner.record, "owner faction record")
  let turn = integer(campaign.turnNumber, "campaign turn", true)
  let o = {
    name = owner.name,
    strength = integer(stats.armyStrength, "army strength", true),
    freeStrength = integer(stats.freeArmyStrength, "available strength", true),
    production = integer(stats.productionPower, "production power", true),
    contested = integer(stats.contestedEnemyStrength, "homeland threat", true),
    money = integer(owner.money, "treasury"), income = integer(owner.netIncome, "net income"),
    projectedIncome = integer(owner.projectedIncome, "projected income"),
    settlements = integer(owner.settlementCount, "settlements", true),
    seaAccess = owner.hasSeaAccess && owner.portCount > 0,
    maritime = record.prefersNavalInvasions != 0,
    transformed = owner.religionId != record.religionId
  }
  // civil_war persists for both the player and AI Istari choice. The good_khand
  // counters are recruitment switches reset on other factions' turns.
  let khandWithIstari = game.eventCounter("civil_war") == 1
  let targets = []
  // Walk the id space, not a 32-bit mask and not just the surviving turn order.
  // Destroyed factions get neutral rows so no old target survives extinction.
  let limit = integer(campaign.factionIdLimit, "faction id limit", true)
  for (local id = 0; id < limit; id++) {
    let target = campaign.factionById(id)
    if (target == null) continue
    valid(target, "target faction")
    let t = { id, name = target.name, alive = target.status == 0,
      utility = profiles.utility?[target.name] != null, war = false, allied = false, protected = false,
      ceasefireTurns = 0, stanceTurns = 0, standing = 0.0, ourFront = 0, theirFront = 0,
      production = 0, border = false, allyEnemy = false, rebel = target.name == "slave",
      seaAccess = false, transformed = false, nativeNavalPermission = false, storyRival = false, storyInvasion = false }
    targets.append(t)
    if (!t.alive || t.utility || id == owner.id) continue
    let forward = valid(campaign.diplomacyWith(owner.id, id), "directed diplomacy")
    let reverse = valid(campaign.diplomacyWith(id, owner.id), "reverse diplomacy")
    integer(forward.state, "diplomatic stance")
    integer(reverse.state, "reverse diplomatic stance")
    t.war = forward.state == 600 || reverse.state == 600
    t.allied = !t.war && (forward.state == 0 || reverse.state == 0)
    t.protected = !t.war && (forward.isProtectorate || reverse.isProtectorate)
    // -1 denotes no historical ceasefire. It is not a fresh ceasefire.
    let ceasefire = integer(forward.turnsSinceCeasefire, "ceasefire age")
    let reverseCeasefire = integer(reverse.turnsSinceCeasefire, "reverse ceasefire age")
    t.ceasefireTurns = ceasefire < 0 ? 1000000 : ceasefire
    if (reverseCeasefire >= 0 && reverseCeasefire < t.ceasefireTurns) t.ceasefireTurns = reverseCeasefire
    t.stanceTurns = integer(forward.turnsAtCurrentStance, "stance age", true)
    t.standing = forward.standing
    if ((typeof t.standing != "float" && typeof t.standing != "integer") ||
        !(t.standing >= -1 && t.standing <= 1)) throw "Invalid standing"
    let ours = valid(owner.aiStatsVs(target), "directed frontier")
    let theirs = valid(target.aiStatsVs(owner), "reverse frontier")
    let targetStats = valid(target.aiStats(), "target statistics")
    t.ourFront = integer(ours.frontlineStrength, "own frontier strength", true)
    t.theirFront = integer(theirs.frontlineStrength, "enemy frontier strength", true)
    t.production = integer(targetStats.productionPower, "target production", true)
    t.border = owner.isNeighbourFaction(target)
    t.allyEnemy = ltgd.isTrustedAllyEnemy(target)
    t.seaAccess = target.hasSeaAccess && target.portCount > 0
    let targetRecord = valid(target.record, "target record")
    t.transformed = target.religionId != targetRecord.religionId
    t.nativeNavalPermission = valid(ltgd.attitudeTowards(id), "native naval permission").mayForceInvade
    t.storyInvasion = khandWithIstari && owner.name == "england" && target.name == "khand"
    t.storyRival = t.storyInvasion || (game.eventCounter("dunland_traitor") == 1 &&
      ((owner.name == "aztecs" && target.name == "france") || (owner.name == "france" && target.name == "aztecs")))
  }
  return { turn, owner = o, targets, activeTurn = campaign.currentFaction?.id == owner.id }
}
return { allowed, owns, collect }
