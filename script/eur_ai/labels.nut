// Historical main-campaign LTGD labels. Production personas remain native.
let mainCampaign = {
  sicily = "dunedain"
  denmark = "dunedain"
  milan = "rohan"
  normans = "goblins"
  turks = "arnor"
  scotland = "dale"
  timurids = "anduin"
  byzantium = "dale"
  moors = "dwarves"
  hungary = "dwarves"
  norway = "dwarves"
  saxons = "elves"
  egypt = "elves"
  ireland = "elves"
  mongols = "elves"
  teutonic_order = "enedwaith"
  venice = "evil_men"
  england = "orcs"
  poland = "orcs"
  france = "isengard"
  aztecs = "dunland"
  hre = "goblins"
  gundabad = "goblins"
  portugal = "angmar"
  spain = "evil_men"
  khand = "khand"
  russia = "dark_numenoreans"
}

function owns(name) {
  return mainCampaign?[name] != null
}

function resolve(game, faction) {
  let name = faction.name
  let label = mainCampaign?[name]
  if (label == null) return null
  if (name == "france" &&
      (game.eventCounter("dunland_player") == 0 ||
       game.eventCounter("dunland_failure") == 1 ||
       game.eventCounter("dunland_traitor") == 1)) {
    return "isengard_active"
  }
  return label
}

return { mainCampaign, owns, resolve }
