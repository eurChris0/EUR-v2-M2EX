let profiles = require("eur_ai.profiles")
let memoryApi = require("eur_ai.persistence")
function clamp(value, low, high) { return value < low ? low : (value > high ? high : value) }
function maximum(a, b) { return a > b ? a : b }
let fields = ["defendType", "defendPriority", "invasionType", "invadePriority", "atWar",
  "wantsPeace", "wantsAlliance", "wantsProtection", "offersProtection", "mustInvade", "mayForceInvade",
  "allianceAgainstPoints", "desirePoints", "alliancePoints", "invasionPoints", "defensePoints"]
function neutral() {
  return { defendType = 0, defendPriority = 0, invasionType = 5, invadePriority = 0,
    atWar = false, wantsPeace = false, wantsAlliance = false, wantsProtection = false,
    offersProtection = false, mustInvade = false, mayForceInvade = false,
    allianceAgainstPoints = 0, desirePoints = 0, alliancePoints = 0, invasionPoints = 0, defensePoints = 0 }
}
function assess(snapshot) {
  let o = snapshot.owner
  local frontierThreat = 0.0
  local wars = 0
  foreach (t in snapshot.targets) if (t.alive && t.war) {
    wars++
    frontierThreat += t.theirFront
  }
  let pressure = maximum(o.contested, frontierThreat * 0.5) / maximum(100.0, o.freeStrength + o.strength * 0.25)
  let net = o.income < o.projectedIncome ? o.income : o.projectedIncome
  let reserve = maximum(1500, o.settlements * 500)
  let stressed = o.money < reserve || o.money + 3 * (net < 0 ? net : 0) < reserve
  return { pressure, urgent = pressure >= 0.9, pressured = pressure >= 0.5,
    stressed, sustainable = !stressed && o.freeStrength > 0,
    wars, overstretched = pressure >= 0.9 || (wars >= 2 && (stressed || pressure >= 0.5)) }
}
function evaluate(snapshot, previous, config) {
  let profile = profiles.get(snapshot.owner.name)
  if (profile == null) throw "No faction profile"
  let aggression = { cautious = 0.8, normal = 1.0, assertive = 1.2 }?[config.aggression]
  if (aggression == null) throw "Invalid aggression setting"
  let context = assess(snapshot)
  let memory = memoryApi.advance(previous, snapshot.turn, snapshot?.activeTurn ?? true)
  let rows = {}
  let candidates = []
  let reasons = {}
  foreach (t in snapshot.targets) {
    let row = neutral()
    rows[t.name] <- row
    if (!t.alive || t.utility || t.name == snapshot.owner.name) {
      reasons[t.name] <- "inactive, utility or self"
      continue
    }
    row.atWar = t.war
    let lore = t?.storyRival == true ? 120.0 :
      profiles.affinity(snapshot.owner.name, t.name, snapshot.owner.transformed || t.transformed)
    let localRatio = (t.ourFront + clamp(snapshot.owner.freeStrength * 0.2, 0.0, snapshot.owner.production * 2.0 + 200.0)) /
      maximum(100.0, t.theirFront + clamp(t.production, 0.0, 300.0))
    let threat = t.theirFront / maximum(100.0, t.ourFront + snapshot.owner.freeStrength * 0.25)
    if (t.war) {
      row.defendType = context.urgent ? 5 : (threat >= 1.0 ? 4 : 3)
      row.defendPriority = clamp(300 + threat * 160 * profile.defense, 300, 800).tointeger()
      row.defensePoints = clamp(threat * 100, 0, 1000).tointeger()
      row.wantsPeace = context.overstretched || (context.stressed && localRatio < 1.0)
      row.allianceAgainstPoints = t.allyEnemy ? 50 : 0
      // Retaliation remains a long-term goal even when another front is primary
      // or newly scripted armies are not yet reflected in available strength.
      // Live war is required; the story choice cannot override peace or alliance.
      if (t?.storyInvasion == true) {
        row.invasionType = 0 // buildup; the event supplies the immediate assault orders
        row.invadePriority = 350
      }
    } else {
      row.defendType = t.allied || t.protected ? 0 : (t.border ? 1 : 0)
      row.defendPriority = row.defendType == 1 ? 100 : 0
      let partner = t.allied || t.protected || (t.standing > 0.25 && (t.allyEnemy || lore < 0))
      row.wantsAlliance = partner && !t.protected
      row.alliancePoints = partner ? clamp(40 + t.stanceTurns * 2 + t.standing * 40, 0, 150).tointeger() : 0
    }
    let protectedNow = !t.war && (t.allied || t.protected || t.ceasefireTurns < 3)
    // Native naval planning retains reachability, landing choice, force size and timing.
    row.mayForceInvade = !protectedNow && !context.pressured && context.sustainable &&
      snapshot.owner.seaAccess && t.seaAccess && (t.war ||
      (snapshot.owner.maritime && context.wars == 0 && lore > 0 && t.nativeNavalPermission))
    local rejected = null
    if (protectedNow) rejected = "ally, protectorate or recent ceasefire"
    else if (snapshot.owner.freeStrength <= 0) rejected = "no available offensive strength"
    else if (!t.border && t.ourFront <= 0) rejected = "no land frontier; native navy only"
    else if (context.urgent && (!t.war || t.theirFront <= 0 || localRatio < 0.65)) rejected = "homeland defense"
    else if (!t.war && (!context.sustainable || context.pressured || context.wars > 0)) rejected = "finances, defense or existing wars"
    else if (!t.war && (!t.border || localRatio < 1.15 / aggression || lore < 0)) rejected = "new war not locally viable or compatible"
    if (rejected != null) {
      reasons[t.name] <- rejected + (t.war && t?.storyInvasion == true ? "; Khand Istari retaliation goal retained" : "")
      continue
    }
    let score = maximum(1.0, (t.war ? 350 : 150) + lore + clamp(localRatio, 0, 3) * 90 +
      (t.allyEnemy ? 45 : 0) + (t.rebel ? 35 : 0) +
      (context.urgent ? clamp(threat * 140, 0, 250) : 0) +
      (!t.war ? (profile.expansion * aggression - 1) * 100 : 0))
    candidates.append({ name = t.name, score, localRatio, war = t.war })
    reasons[t.name] <- "eligible score=" + score + " frontierRatio=" + localRatio + " lore=" + lore
  }
  candidates.sort(@(a, b) a.score == b.score ? (a.name <=> b.name) : (b.score <=> a.score))
  local chosen = candidates.len() > 0 ? candidates[0] : null
  local current = null
  foreach (candidate in candidates) if (candidate.name == memory.target) current = candidate
  if (current != null && !context.urgent && chosen != null &&
      (memory.heldTurns < 3 || chosen.score < current.score * 1.2)) chosen = current
  let target = chosen?.name
  if (target != memory.target) memory.heldTurns = 0
  memory.target = target
  if (chosen != null) {
    reasons[chosen.name] += " selected" + (current != null && current.name == chosen.name ? " (commitment/hysteresis retained)" : " (highest eligible score)")
    let row = rows[chosen.name]
    row.invasionType = context.urgent || context.stressed ? 2 :
      (chosen.war && chosen.localRatio >= 1.15 ? 1 : 3)
    row.invadePriority = clamp(chosen.score, 250, 800).tointeger()
    row.invasionPoints = clamp(chosen.score / 5, 0, 200).tointeger()
    row.desirePoints = clamp(chosen.score / 10, 0, 100).tointeger()
  }
  return { rows, memory, context, reasons, target }
}
function validate(result, names) {
  if (result.rows.len() != names.len()) throw "Incomplete attitude set"
  foreach (name in names) {
    let row = result.rows?[name]
    if (row == null || row.len() != fields.len()) throw "Incomplete attitude row"
    let baseline = neutral()
    foreach (field in fields) {
      if (typeof row?[field] != typeof baseline[field]) throw "Invalid attitude field: " + field
      if (typeof row[field] == "integer" && (row[field] < 0 || row[field] > 1000)) throw "Attitude out of bounds"
    }
    if (row.defendType > 5 || row.invasionType > 5 || row.mustInvade) throw "Invalid posture or forced attack"
  }
  return true
}
return { evaluate, assess, validate, fields, neutral, clamp }
