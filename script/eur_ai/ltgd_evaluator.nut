let fields = [
  "defendType", "defendPriority", "invasionType", "invadePriority", "atWar",
  "wantsPeace", "wantsAlliance", "wantsProtection", "offersProtection",
  "mustInvade", "mayForceInvade", "allianceAgainstPoints", "desirePoints",
  "alliancePoints", "invasionPoints", "defensePoints"
]

let defenseTypes = {
  defend_minimal = 0
  defend_normal = 1
  defend_raid = 2
  defend_frontline = 3
  defend_fortified = 4
  defend_deep = 5
}

let invasionTypes = {
  invade_buildup = 0
  invade_immediate = 1
  invade_raids = 2
  invade_opportunistic = 3
  invade_start = 4
  invade_none = 5
}

let boolOutputs = {
  at_war = "atWar"
  want_peace = "wantsPeace"
  want_ally = "wantsAlliance"
  want_be_protect = "wantsProtection"
  want_offer_protect = "offersProtection"
  force_invade = "mustInvade"
  can_force_invade = "mayForceInvade"
}

let priorityOutputs = {
  defend_priority = "defendPriority"
  invade_priority = "invadePriority"
}

let additiveOutputs = {
  alliance_against = "allianceAgainstPoints"
  pts_desire = "desirePoints"
  pts_alliance = "alliancePoints"
  pts_invasion = "invasionPoints"
  pts_defense = "defensePoints"
}

let stanceRanks = {
  Allied = 0
  Suspicious = 100
  Neutral = 200
  Hostile = 400
  AtWar = 600
}

// Exact semantic order used by M2EX campaign_ai_db comparisons.
let difficultyRanks = {
  very_easy = 0
  easy = 1
  normal = 2
  hard = 3
  very_hard = 4
  fair = 5
  extreme = 6
  hell = 7
}

function findThreshold(program, value) {
  foreach (index, threshold in program.randThresholds)
    if (threshold == value) return index
  throw "Random threshold was not instrumented: " + value
}

function decodeRandomProbe(program, marker, passName) {
  if (typeof marker != "integer") throw "Missing " + passName + " random probe"
  let lessOrEqual = marker % program.randProbeBase
  let greaterOrEqual = (marker / program.randProbeBase).tointeger()
  let count = program.randThresholds.len()
  if (lessOrEqual < 0 || lessOrEqual > count || greaterOrEqual < 0 ||
      greaterOrEqual > count ||
      (lessOrEqual + greaterOrEqual != count &&
       lessOrEqual + greaterOrEqual != count + 1)) {
    throw "Invalid " + passName + " random probe: " + marker
  }
  return { lessOrEqual, greaterOrEqual }
}

function compareRandom(program, probe, boundary, minimum) {
  let index = findThreshold(program, boundary)
  if (minimum) return probe.greaterOrEqual >= index + 1
  return probe.lessOrEqual >= program.randThresholds.len() - index
}

function ordered(name, value) {
  if (name == "stance") {
    let rank = stanceRanks?[value]
    if (rank == null) throw "Unknown stance selector: " + value
    return rank
  }
  if (name == "difficulty") {
    let rank = difficultyRanks?[value]
    if (rank == null) throw "Unknown difficulty selector: " + value
    return rank
  }
  return value
}

function passesBound(program, inputs, probe, name, boundary, minimum) {
  if (name == "rand") return compareRandom(program, probe, boundary, minimum)
  if (!(name in inputs)) throw "Missing LTGD input: " + name
  let actual = inputs[name]
  if (typeof boundary == "string" && name != "stance" && name != "difficulty")
    return actual == boundary
  local left = ordered(name, actual)
  local right = ordered(name, boundary)
  if (typeof left == "bool") left = left ? 1 : 0
  if (typeof right == "bool") right = right ? 1 : 0
  return minimum ? left >= right : left <= right
}

function matches(program, rule, inputs, probe) {
  foreach (name, value in rule.min)
    if (!passesBound(program, inputs, probe, name, value, true)) return false
  foreach (name, value in rule.max)
    if (!passesBound(program, inputs, probe, name, value, false)) return false
  return true
}

function applyOutput(row, output) {
  foreach (name, value in output) {
    if (name == "defense") {
      let translated = defenseTypes?[value]
      if (translated == null) throw "Unknown defense posture: " + value
      row.defendType = translated
    } else if (name == "invade") {
      let translated = invasionTypes?[value]
      if (translated == null) throw "Unknown invasion posture: " + value
      row.invasionType = translated
    } else if (boolOutputs?[name] != null) {
      row[boolOutputs[name]] = value
    } else if (priorityOutputs?[name] != null) {
      let field = priorityOutputs[name]
      row[field] += value
    } else if (additiveOutputs?[name] != null) {
      let field = additiveOutputs[name]
      row[field] += value
    } else {
      throw "Unknown LTGD output: " + name
    }
  }
}

function runPass(program, rules, inputs, probe, row) {
  local matched = 0
  foreach (rule in rules) {
    if (!matches(program, rule, inputs, probe)) continue
    applyOutput(row, rule.out)
    matched++
    if (!rule.keepGoing) break
  }
  return matched
}

function baseline(original) {
  return {
    defendType = 1
    defendPriority = -1
    invasionType = 5
    invadePriority = -1
    atWar = false
    wantsPeace = false
    wantsAlliance = false
    wantsProtection = false
    offersProtection = false
    mustInvade = false
    mayForceInvade = true
    allianceAgainstPoints = 0
    // The native clear pass computes this from neighbouring region values before
    // XML runs. The _ex probe rules do not alter it, so retain that exact baseline.
    desirePoints = original.values.desirePoints
    alliancePoints = 0
    invasionPoints = 0
    defensePoints = 0
  }
}

function evaluate(program, state, originals, label) {
  let labelRules = program.labels?[label]
  if (labelRules == null) throw "No generated EUR LTGD label: " + label
  let rows = {}
  local defendMatches = 0
  local invadeMatches = 0
  foreach (target in state.targets) {
    let original = originals?[target.name]
    if (original == null) throw "Missing captured attitude: " + target.name
    let row = baseline(original)
    let defendProbe = decodeRandomProbe(program, original.values.defensePoints, "defend")
    let invadeProbe = decodeRandomProbe(program, original.values.invasionPoints, "invade")
    defendMatches += runPass(program, labelRules.defend, target.values, defendProbe, row)
    invadeMatches += runPass(program, labelRules.invade, target.values, invadeProbe, row)
    rows[target.name] <- row
  }
  return { rows, label, defendMatches, invadeMatches }
}

function validate(result, expectedNames) {
  if (result.rows.len() != expectedNames.len()) throw "Incomplete EUR LTGD transaction"
  foreach (name in expectedNames) {
    let row = result.rows?[name]
    if (row == null) throw "Missing EUR LTGD row: " + name
    foreach (field in fields) {
      if (!(field in row)) throw "Missing attitude field: " + field
      let value = row[field]
      let isBoolean = field == "atWar" || field == "wantsPeace" ||
        field == "wantsAlliance" || field == "wantsProtection" ||
        field == "offersProtection" || field == "mustInvade" ||
        field == "mayForceInvade"
      if (isBoolean && typeof value != "bool") throw "Invalid Boolean attitude: " + field
      if (!isBoolean && typeof value != "integer") throw "Invalid integer attitude: " + field
    }
    if (row.defendType < 0 || row.defendType > 5) throw "Invalid defense posture"
    if (row.invasionType < 0 || row.invasionType > 5) throw "Invalid invasion posture"
  }
}

return { fields, evaluate, validate }
