local PNG = [
    "minus", "plus", "leg_text", "revival_text", "battle_text", "chrisset_text", "sort_text",
    "misc_text", "rep_text", "u_text", "gu_text", "global_text", "welcome_beta",
    "koe_title", "kon_title", "imladris_kon_icon", "lindon_kon_icon", "imladris_icon", "lindon_icon",
    "coins", "replen", "upg_icon", "sdg_icon", "siege", "sword", "hammer", "unrest",
    "pored", "poblue", "pogreen", "poyellow", "sett_upgrade", "plague", "gov",
    "sortstack1", "bg_small_1", "bg_1_new", "bg_1", "bg_2", "bg_3_elven", "scroll_bg",
    "button_01", "button_02", "seperator", "speed_text", "credits_text", "welcome_text",
    "revive_yes", "revive_no", "fort", "fort_text", "fort_text_no", "eregion_icon", "aa_icon",
    "crown1", "stew1", "ship1", "crown1locked", "stew1locked", "ship1locked", "bg_test", "bg_test2",
    "icon_unit", "icon_unit2", "icon_save", "icon_options", "test1", "ent1", "eldarlight",
    "mirror1", "mirror2", "mirror3", "yavanna", "orome", "tulkas", "ulmo", "button1", "anor",
    "mengood_pic_0", "oatheorl",
    "chevron_gold", "chevron_silver", "chevron_bronze",
    "sword_gold", "sword_silver", "sword_bronze",
    "shield_gold", "shield_silver", "shield_bronze",
]

local PIPS = [
    "pip_dwarves", "pip_elvish", "pip_evil", "pip_kings", "pip_middlemen", "pip_nomadic",
    "pip_northmen", "pip_numenorian", "pip_religious_unrest", "pip_rohirrim", "pip_uruk",
    "pip_wicked", "pip_wicked2",
]

local IMAGES_ODD = {
    kon_council_choice       = "kon_council_choice.jpg",
    eregion_rebellion_choice = "eregion_rebellion_choice.jpg",
    bg_gondor_1              = "gondor_1.png",
    map1                     = "pp-me-newest-big.png",
    lordsgondor              = "lordsgondor_2.png",
}

local CULTURES = [
    "northern_european", "eastern_european", "gondor", "greek", "noldor",
    "mesoamerican", "middle_eastern", "southern_european", "crags",
]
local CULTURE_FILE = { noldor = "Noldor" }

local UPGRADE_BASE = {
    hungary = "dwarves", denmark = "elves", milan = "rohan", normans = "orc", turks = "dunedain",
    scotland = "northmen", timurids = "northmen", byzantium = "northmen", moors = "dwarves",
    sicily = "northmen", norway = "dwarves", saxons = "elves", ireland = "elves", mongols = "elves",
    teutonic_order = "northmen", venice = "southron", england = "orc", poland = "orc",
    france = "isengard", aztecs = "northmen", hre = "orc", gundabad = "orc", portugal = "orc",
    spain = "southron", khand = "southron", russia = "northmen", papal_states = "orc",
    scripts = "orc", united = "orc", slave = "orc", egypt = "elves",
}
local UPGRADE_TABLES = { gold = "", silver = "_silver", bronze = "_bronze", blue = "_blue", bw = "_bw" }

foreach (n in PNG)  { ::EUR[n] <- { x = 0, y = 0, img = null } }
foreach (n in PIPS) { ::EUR[n] <- { x = 0, y = 0, img = null } }
foreach (n, p in IMAGES_ODD) { ::EUR[n] <- { x = 0, y = 0, img = null } }

::EUR.faction_bg <- {}
::EUR.faction_accept <- {}
foreach (c in CULTURES) {
    ::EUR.faction_bg[c] <- { x = 0, y = 0, img = null }
    ::EUR.faction_accept[c] <- { x = 0, y = 0, img = null }
}
foreach (suffixKey, suffix in UPGRADE_TABLES) {
    local t = {}
    foreach (fac, baseFile in UPGRADE_BASE) { t[fac] <- { x = 0, y = 0, img = null } }
    ::EUR["faction_upgrade_card_" + suffixKey] <- t
}

::EUR.loadImages <- function() {
    local basePath = ::game.modPath() + "\\eopData\\images\\"

    foreach (n in PNG)  { ::EUR[n] = ::UI.loadTexture(basePath + n + ".png") }
    foreach (n in PIPS) { ::EUR[n] = ::UI.loadTexture(basePath + "pips\\" + n + ".tga") }
    foreach (n, p in IMAGES_ODD) { ::EUR[n] = ::UI.loadTexture(basePath + p) }

    foreach (c in CULTURES) {
        local f = (c in CULTURE_FILE) ? CULTURE_FILE[c] : c
        ::EUR.faction_bg[c] = ::UI.loadTexture(basePath + f + ".png")
        ::EUR.faction_accept[c] = ::UI.loadTexture(basePath + f + "_accept.png")
    }
    foreach (suffixKey, suffix in UPGRADE_TABLES) {
        local t = ::EUR["faction_upgrade_card_" + suffixKey]
        foreach (fac, cardBase in UPGRADE_BASE) {
            t[fac] = ::UI.loadTexture(basePath + "upgrade_card\\" + cardBase + suffix + ".png")
        }
    }

    ::EUR.wireEventImages()
}

::EUR.wireEventImages <- function() {
    ::EUR.EUR_EVENTS["ireland"][0].image = ::EUR.mirror1
    ::EUR.EUR_EVENTS["ireland"][1].image = ::EUR.yavanna
    ::EUR.EUR_EVENTS["ireland"][2].image = ::EUR.ent1
    ::EUR.EUR_EVENTS["ireland"][3].image = ::EUR.eldarlight

    ::EUR.EUR_EVENTS["mongols"][0].image = ::EUR.mirror1
    ::EUR.EUR_EVENTS["mongols"][1].image = ::EUR.yavanna
    ::EUR.EUR_EVENTS["mongols"][2].image = ::EUR.orome
    ::EUR.EUR_EVENTS["mongols"][3].image = ::EUR.eldarlight

    ::EUR.EUR_EVENTS["saxons"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["saxons"][1].image = ::EUR.tulkas
    ::EUR.EUR_EVENTS["saxons"][2].image = ::EUR.yavanna
    ::EUR.EUR_EVENTS["saxons"][3].image = ::EUR.eldarlight

    ::EUR.EUR_EVENTS["denmark"][0].image = ::EUR.ulmo
    ::EUR.EUR_EVENTS["denmark"][1].image = ::EUR.yavanna
    ::EUR.EUR_EVENTS["denmark"][2].image = ::EUR.test1
    ::EUR.EUR_EVENTS["denmark"][3].image = ::EUR.eldarlight

    ::EUR.EUR_EVENTS["england"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["england"][1].image = ::EUR.test1
    ::EUR.EUR_EVENTS["hre"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["hre"][1].image = ::EUR.test1
    ::EUR.EUR_EVENTS["poland"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["poland"][1].image = ::EUR.test1
    ::EUR.EUR_EVENTS["normans"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["normans"][1].image = ::EUR.test1
    ::EUR.EUR_EVENTS["hungary"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["norway"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["moors"][0].image = ::EUR.test1

    ::EUR.EUR_EVENTS["sicily"][0].image = ::EUR.anor
    ::EUR.EUR_EVENTS["sicily"][1].image = ::EUR.mengood_pic_0
    ::EUR.EUR_EVENTS["sicily"][2].image = ::EUR.oatheorl
    ::EUR.EUR_EVENTS["sicily"][3].image = ::EUR.lordsgondor

    ::EUR.EUR_EVENTS["turks"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["turks"][1].image = ::EUR.test1
    ::EUR.EUR_EVENTS["scotland"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["scotland"][1].image = ::EUR.test1
    ::EUR.EUR_EVENTS["milan"][0].image = ::EUR.test1
    ::EUR.EUR_EVENTS["milan"][1].image = ::EUR.test1
    ::EUR.EUR_EVENTS["milan"][2].image = ::EUR.test1

}
