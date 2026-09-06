// destroy a building if it's present; returns whether it was there (so callers know to rebuild).
::EUR.destroyBuildingIfPresent <- function(sett, buildingName) {
    if (sett.buildingOfChain(buildingName)) {
        sett.destroyBuilding(buildingName, false)
        return true
    }
    return false
}

::EUR.swapRKBarracks <- function() {
    local faction = ::EUR.eur_player_faction
    for (local i = 0; i < faction.settlementCount; i++) {
        local sett = faction.settlement(i)
        if (sett == null) continue

        if (::EUR.eur_player_faction.name == "turks") {
            if (!sett.isCastle) {
                local replace = ::EUR.destroyBuildingIfPresent(sett, "barracks")
                ::EUR.destroyBuildingIfPresent(sett, "equestrian")
                ::EUR.destroyBuildingIfPresent(sett, "missiles")
                if (replace && !sett.buildingOfChain("dunedain_barracks")) { sett.createBuilding("dunedain_warcamp") }
            } else {
                local replace = ::EUR.destroyBuildingIfPresent(sett, "castle_barracks")
                ::EUR.destroyBuildingIfPresent(sett, "c_equestrian")
                ::EUR.destroyBuildingIfPresent(sett, "c_missiles")
                if (replace && !sett.buildingOfChain("c_dunedain_barracks")) { sett.createBuilding("c_dunedain_warcamp") }
            }
        } else if (::EUR.eur_player_faction.name == "sicily") {
            if (!sett.isCastle) {
                if (::EUR.destroyBuildingIfPresent(sett, "dunedain_barracks")) {
                    if (!sett.buildingOfChain("barracks")) { sett.createBuilding("town_guard") }
                    if (!sett.buildingOfChain("equestrian")) { sett.createBuilding("stables") }
                    if (!sett.buildingOfChain("missiles")) { sett.createBuilding("practice_range") }
                }
            } else {
                if (::EUR.destroyBuildingIfPresent(sett, "c_dunedain_barracks")) {
                    if (!sett.buildingOfChain("castle_barracks")) { sett.createBuilding("garrison_quarters") }
                    if (!sett.buildingOfChain("c_missiles")) { sett.createBuilding("c_practice_range") }
                    if (!sett.buildingOfChain("c_equestrian")) { sett.createBuilding("c_stables") }
                }
            }
        }
    }
    ::EUR.game_options.eurRKcomplete = true
}
