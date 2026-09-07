function number(value, label) {
  if (typeof value != "integer" && typeof value != "float") throw "Missing/invalid " + label
  return value
}

function integer(value, label) {
  if (typeof value != "integer") throw "Missing/invalid " + label
  return value
}

function valid(value, label) {
  if (value == null || !value.valid) throw "Missing " + label
  return value
}

function atLeastOne(value) {
  return value > 0 ? value : 1
}

function ratio(numerator, denominator) {
  return atLeastOne(numerator).tofloat() / atLeastOne(denominator).tofloat()
}

function stanceName(value) {
  if (value == 0) return "Allied"
  if (value == 100) return "Suspicious"
  if (value == 200) return "Neutral"
  if (value == 400) return "Hostile"
  if (value == 600) return "AtWar"
  throw "Unknown diplomatic stance: " + value
}

function difficultyName(campaign) {
  let player = campaign.playerFaction(0)
  if (player == null) return "normal"
  let value = campaign.campaignDifficultyOf(player.id)
  if (value == 0) return "easy"
  if (value == 1) return "normal"
  if (value == 2) return "hard"
  if (value == 3) return "very_hard"
  if (value == 4) return "very_easy"
  if (value == 5) return "extreme"
  if (value == 6) return "hell"
  if (value == 7) return "fair"
  return "normal"
}

function relation(campaign, first, second) {
  return valid(campaign.diplomacyWith(first.id, second.id),
    "diplomacy " + first.name + "->" + second.name)
}

function stats(faction) {
  return valid(faction.aiStats(), "statistics for " + faction.name)
}

function pairStats(first, second) {
  return valid(first.aiStatsVs(second), "pair statistics " + first.name + "->" + second.name)
}

function standing(first, second) {
  return number(first.standingTowards(second), "standing " + first.name + "->" + second.name)
}

function normalizeRebelStrength(aggregate, target, owner, stratMap) {
  if (target.name != "slave") return aggregate
  local weakest = null
  for (local index = 0; index < owner.neighbourRegionCount; index++) {
    let region = stratMap.region(owner.neighbourRegionId(index))
    if (region == null || !region.valid || region.faction?.name != "slave") continue
    let settlement = region.settlement
    if (settlement == null || !settlement.valid) continue
    let army = settlement.army
    let strength = army != null && army.valid ? integer(army.strength, "rebel garrison strength") : 0
    if (weakest == null || strength < weakest) weakest = strength
  }
  if (weakest != null) return weakest > 0 ? weakest : 1
  let regions = target.settlementCount > 0 ? target.settlementCount : 1
  return aggregate > regions ? aggregate / regions : 1
}

function collectFactions(campaign) {
  let result = []
  let limit = integer(campaign.factionIdLimit, "faction id limit")
  for (local id = 0; id < limit; id++) {
    let faction = campaign.factionById(id)
    if (faction != null && faction.valid) result.append(faction)
  }
  return result
}

function targetStrengthPlusOurEnemies(campaign, owner, target, factions, statsById) {
  local result = integer(statsById[target.id].armyStrength, "target army strength")
  foreach (other in factions) {
    if (other.id == target.id || other.name == "slave") continue
    if (relation(campaign, owner, other).state == 600)
      result += integer(statsById[other.id].armyStrength, "enemy army strength")
  }
  return result
}

function ourStrengthPlusRelevantAllies(campaign, owner, target, factions, statsById) {
  local result = integer(statsById[owner.id].armyStrength, "owner army strength")
  foreach (other in factions) {
    if (other.id == owner.id || other.name == "slave") continue
    if (target.isNeighbourFaction(other) &&
        relation(campaign, owner, other).state == 0 &&
        relation(campaign, target, other).state != 0) {
      result += integer(statsById[other.id].armyStrength, "allied army strength")
    }
  }
  return result
}

function isTrustedAllyProtectorate(campaign, ltgd, target, factions) {
  foreach (other in factions) {
    if (other.id == target.id || !ltgd.isTrustedAlly(other.id)) continue
    if (relation(campaign, target, other).isProtectorate) return true
  }
  return false
}

function collect(campaign, owner, ltgd, game, stratMap) {
  valid(campaign, "campaign")
  if (!campaign.isOpen) throw "Campaign is not open"
  let factions = collectFactions(campaign)
  let statsById = {}
  foreach (faction in factions) statsById[faction.id] <- stats(faction)

  let ownerStats = statsById[owner.id]
  let ownerStrength = integer(ownerStats.armyStrength, "owner army strength")
  let ownerFree = integer(ownerStats.freeArmyStrength, "owner free strength")
  let ownerProduction = integer(ownerStats.productionPower, "owner production")
  let ownerEnemies = integer(ownerStats.enemyFactionCount, "owner enemy count")
  let ownerSettlements = integer(owner.settlementCount, "owner settlement count")
  let difficulty = difficultyName(campaign)
  let rows = []

  foreach (target in factions) {
    if (target.id == owner.id) continue
    let targetStats = statsById[target.id]
    let forward = relation(campaign, owner, target)
    let reverse = relation(campaign, target, owner)
    let ours = pairStats(owner, target)
    let theirs = pairStats(target, owner)
    let targetReligion = target.religionId >= 0 ? game.religionName(target.religionId) : ""
    let condition = owner.winCondition
    let targetStrength = normalizeRebelStrength(
      integer(targetStats.armyStrength, "target army strength"), target, owner, stratMap)
    let targetFree = normalizeRebelStrength(
      integer(targetStats.freeArmyStrength, "target free strength"), target, owner, stratMap)
    let targetProduction = normalizeRebelStrength(
      integer(targetStats.productionPower, "target production"), target, owner, stratMap)
    let targetFrontline = normalizeRebelStrength(
      integer(theirs.frontlineStrength, "target frontline strength"), target, owner, stratMap)
    let targetAndEnemies = normalizeRebelStrength(
      targetStrengthPlusOurEnemies(campaign, owner, target, factions, statsById),
      target, owner, stratMap)
    let values = {
      alliance_military_balance = ratio(
        ourStrengthPlusRelevantAllies(campaign, owner, target, factions, statsById),
        targetStrength)
      difficulty = difficulty
      faction_standing = standing(owner, target)
      free_strength_balance = ratio(ownerFree, targetFree)
      frontline_balance = ratio(
        integer(ours.frontlineStrength, "owner frontline strength"),
        targetFrontline)
      has_alliance_against = ours.hasAllianceAgainst
      is_neighbour = target.isNeighbourFaction(owner)
      is_protectorate = reverse.isProtectorate
      is_target_faction_to_outlive = condition != null && condition.valid &&
        condition.outlivesFaction(target.id)
      military_balance = ratio(ownerStrength, targetStrength)
      military_balance_plus_enemies = ratio(ownerStrength, targetAndEnemies)
      num_enemies = ownerEnemies
      num_settlements = ownerSettlements
      num_turns_allied = forward.state == 0 ?
        integer(forward.turnsAtCurrentStance, "alliance age") : 0
      num_turns_ceasfire = integer(forward.turnsSinceCeasefire, "ceasefire age")
      production_balance = ratio(ownerProduction, targetProduction)
      stance = stanceName(integer(forward.state, "diplomatic stance"))
      strongest_neighbour = ours.isStrongestNeighbour
      target_faction = target.name
      target_global_standing = standing(target, target)
      target_human = target.isPlayerControlled != 0
      target_num_enemies = integer(targetStats.enemyFactionCount, "target enemy count")
      target_religion = targetReligion
      target_weakest_neighbour = theirs.isWeakestNeighbour
      trusted_ally = ltgd.isTrustedAlly(target.id)
      trusted_ally_enemy = ltgd.isTrustedAllyEnemy(target)
      trusted_ally_protectorate = isTrustedAllyProtectorate(campaign, ltgd, target, factions)
      turn_number = integer(campaign.turnNumber, "campaign turn")
      weakest_neighbour = ours.isWeakestNeighbour
      enemy_excommunicated = target.isExcommunicated
      excommunicated = owner.isExcommunicated
      target_is_shadow = false
      borders_all_our_regions = false
      has_ceasehostilities = false
      is_protectorate_of_catholic = false
    }
    rows.append({ id = target.id, name = target.name, values })
  }

  return {
    turn = integer(campaign.turnNumber, "campaign turn")
    owner
    targets = rows
  }
}

return { collect }
