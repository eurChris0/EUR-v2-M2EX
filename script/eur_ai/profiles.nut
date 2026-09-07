// Internal names and families follow EUR's imperial_campaign assignments.
// Affinities are preferences, never a substitute for current diplomacy.
let profiles = {
  sicily = { family = "good", expansion = 0.9, defense = 1.2, rivals = ["england", "russia"], friends = ["milan", "denmark"] }
  denmark = { family = "good", expansion = 0.85, defense = 1.2, rivals = ["portugal", "hre"], friends = ["turks", "saxons"] }
  turks = { family = "good", expansion = 0.9, defense = 1.15, rivals = ["portugal"], friends = ["normans", "denmark"] }
  milan = { family = "good", expansion = 1.0, defense = 1.15, rivals = ["france", "aztecs"], friends = ["sicily", "timurids"] }
  scotland = { family = "good", expansion = 0.85, defense = 1.1, rivals = ["spain", "gundabad"], friends = ["hungary", "byzantium"] }
  timurids = { family = "good", expansion = 0.85, defense = 1.25, rivals = ["hre", "poland"], friends = ["milan", "mongols"] }
  byzantium = { family = "good", expansion = 0.8, defense = 1.1, rivals = ["spain"], friends = ["scotland"] }
  moors = { family = "good", expansion = 0.8, defense = 1.3, rivals = ["hre", "gundabad"], friends = ["hungary", "norway"] }
  hungary = { family = "good", expansion = 0.9, defense = 1.3, rivals = ["gundabad", "hre"], friends = ["scotland", "moors"] }
  norway = { family = "good", expansion = 0.8, defense = 1.3, rivals = ["hre", "gundabad"], friends = ["moors", "hungary"] }
  saxons = { family = "good", expansion = 0.65, defense = 1.3, rivals = ["portugal", "russia"], friends = ["denmark", "ireland"] }
  egypt = { family = "good", expansion = 0.8, defense = 1.25, rivals = ["england", "poland"], friends = ["ireland", "mongols"] }
  ireland = { family = "good", expansion = 0.7, defense = 1.3, rivals = ["hre", "poland"], friends = ["saxons", "mongols"] }
  mongols = { family = "good", expansion = 0.75, defense = 1.3, rivals = ["poland", "gundabad"], friends = ["timurids", "scotland"] }
  teutonic_order = { family = "independent", expansion = 0.8, defense = 1.15, rivals = [], friends = ["aztecs"] }
  normans = { family = "independent", expansion = 0.9, defense = 1.15, rivals = [], friends = ["turks"] }
  venice = { family = "evil", expansion = 1.1, defense = 1.0, rivals = ["sicily"], friends = ["england", "khand"] }
  spain = { family = "evil", expansion = 1.15, defense = 1.0, rivals = ["byzantium", "scotland"], friends = ["england", "khand"] }
  khand = { family = "evil", expansion = 1.1, defense = 0.95, rivals = ["sicily"], friends = ["spain", "venice"] }
  england = { family = "evil", expansion = 1.25, defense = 1.0, rivals = ["sicily"], friends = ["poland", "portugal"] }
  poland = { family = "evil", expansion = 1.15, defense = 1.05, rivals = ["mongols", "ireland", "timurids"], friends = ["england", "portugal"] }
  france = { family = "evil", expansion = 1.15, defense = 1.0, rivals = ["milan"], friends = ["aztecs"] }
  aztecs = { family = "independent", expansion = 1.05, defense = 1.1, rivals = ["milan"], friends = ["france", "teutonic_order"] }
  hre = { family = "evil", expansion = 1.2, defense = 1.05, rivals = ["moors", "hungary", "norway", "timurids"], friends = ["gundabad"] }
  gundabad = { family = "evil", expansion = 1.1, defense = 1.2, rivals = ["hungary", "moors", "norway"], friends = ["hre", "portugal"] }
  portugal = { family = "evil", expansion = 1.15, defense = 1.1, rivals = ["denmark", "turks"], friends = ["england", "poland"] }
  russia = { family = "evil", expansion = 1.15, defense = 1.0, rivals = ["sicily", "saxons", "england"], friends = [] }
  slave = { family = "rebel", expansion = 0.0, defense = 1.0, rivals = [], friends = [] }
}
let utility = { papal_states = true, scripts = true, united = true }
function get(name) { return profiles?[name] }
function affinity(owner, target, transformed) {
  let a = get(owner)
  let b = get(target)
  if (a == null || b == null || transformed) return 0.0
  if (a.rivals.contains(target)) return 120.0
  if (a.friends.contains(target)) return -150.0
  if (b.family == "rebel") return 35.0
  if (a.family == b.family && a.family != "independent") return -80.0
  if ((a.family == "good" && b.family == "evil") || (a.family == "evil" && b.family == "good")) return 70.0
  return 0.0
}
return { get, affinity, utility }
