::EUR.engineer_boost_set <- false

::EUR.faction_artillery_list <- {
    moors     = ["Dwarven Catapult", "Dwarven Ballista"],
    hungary   = ["Ered Luin Catapult", "Ered Luin Ballista"],
    norway    = ["Dwarven Catapult", "Dwarven Ballista"],
    sicily    = ["Gondor Catapult", "Gondor Ballista", "Gondor Trebuchet"],
    turks     = ["Eriador Catapult", "Eriador Ballista", "Eriador Trebuchet"],
    byzantium = ["Westron Catapult", "Westron Ballista"],
    scotland  = ["Westron Catapult", "Westron Ballista"],
    milan     = ["Westron Catapult", "Westron Ballista"],
}

::EUR.checkEngineerGuild <- function() {
    if (!(::EUR.eur_player_faction.name in ::EUR.faction_artillery_list)) return
    local guildPresent = false
    for (local x = 0; x < ::EUR.eur_player_faction.settlementCount; x++) {
        local sett = ::EUR.eur_player_faction.settlement(x)
        if (sett != null && sett.hasBuildingLevel("m_engineer_guild", false)) {
            guildPresent = true
        }
    }
    if (guildPresent && !::EUR.engineer_boost_set) { ::EUR.setEngineerGuildBoost(true) }
    else if (!guildPresent && ::EUR.engineer_boost_set) { ::EUR.setEngineerGuildBoost(false) }
}

::EUR.setEngineerGuildBoost <- function(enable) {
    if (!(::EUR.eur_player_faction.name in ::EUR.faction_artillery_list)) return
    local delta = enable ? 4 : -4
    foreach (unitType in ::EUR.faction_artillery_list[::EUR.eur_player_faction.name]) {
        local eduEntry = ::units.get(unitType)
        if (eduEntry != null && eduEntry.ammo(3) != null) {
            eduEntry.setAmmo(3, eduEntry.ammo(3) + delta)
        }
    }
    ::EUR.engineer_boost_set = enable
}
