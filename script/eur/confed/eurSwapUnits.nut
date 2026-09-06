local CONFED_FACTIONS = {
    ireland = {
        counter = "elven_union", value = 1, run_once = "elven_confed_units",
        old = ["Woodland Scouts", "Woodland Spearmen", "Woodland Warriors"],
        new = ["Lorien Archers", "Lorien Warders", "Lorien Sentries"],
    },
    mongols = {
        counter = "elven_union", value = 1, run_once = "elven_confed_units",
        old = ["Lorien Archers", "Lorien Warders", "Lorien Sentries"],
        new = ["Woodland Scouts", "Woodland Spearmen", "Woodland Warriors"],
    },
    denmark = {
        counter = "konkoe_union", value = 1, run_once = "konkoe_confed_units",
        old = ["Lindar Guards", "Lindar Mariners", "Lindon Longspears", "Lindar Bowmen", "Sword Quendi", "Spear Quendi", "Bow Quendi", "Mounted Quendi"],
        new = ["Eregion Lindar Guards", "Eregion Lindar Mariners", "Eregion Lindon Longspears", "Eregion Lindar Bowmen", "Eregion Sword Quendi", "Eregion Spear Quendi", "Eregion Bow Quendi", "Eregion Mounted Quendi"],
    },
    saxons = {
        counter = "konkoe_union", value = 1, run_once = "konkoe_confed_units",
        old = ["Lindar Guards", "Lindar Mariners", "Lindon Longspears", "Lindar Bowmen", "Sword Quendi", "Spear Quendi", "Bow Quendi", "Mounted Quendi"],
        new = ["Eregion Lindar Guards", "Eregion Lindar Mariners", "Eregion Lindon Longspears", "Eregion Lindar Bowmen", "Eregion Sword Quendi", "Eregion Spear Quendi", "Eregion Bow Quendi", "Eregion Mounted Quendi"],
    },
}

// three flavour units per faction, drawn at random for a captured settlement's new garrison.
::EUR.SWAP_GARRISON <- {
    milan = { new = ["Eorling Spearmen", "Eorling Spearmen", "Eorling Archers"] },
    sicily = { new = ["Territorial Guardsmen", "Territorial Guardsmen", "Territorial Watchmen"] },
    turks = { new = ["Dunedain Wardens", "Dunedain Wardens", "Woodland Hunters"] },
    normans = { new = ["Blue Crag Goblin Spears", "Blue Crag Goblin Spears", "Blue Crag Slingers"] },
    russia = { new = ["Belegaer Footmen", "Belegaer Footmen", "Belegaer Archers"] },
    scotland = { new = ["Dalian Swordsmen", "Dalian Swordsmen", "Dalian Longbowmen"] },
    byzantium = { new = ["Thorn Bladesmen", "Thorn Bladesmen", "Thorn Crossbowmen"] },
    timurids = { new = ["Woodman Defenders", "Woodman Defenders", "Vale Archers"] },
    portugal = { new = ["Gram Marauders", "Gram Trackers", "Gram Trackers"] },
    aztecs = { new = ["Clan Spearmen", "Clan Spearmen", "Clan Hunters"] },
    teutonic_order = { new = ["Faolan Borderguard", "Faolan Borderguard", "Faolan Borderguard"] },
    spain = { new = ["Haradrim Spearmen", "Haradrim Spearmen", "Haradrim Archers"] },
    khand = { new = ["Steppe Tribesmen", "Steppe Tribesmen", "Steppe Tribesmen"] },
    venice = { new = ["Rhunnic Spears", "Rhunnic Spears", "Rhunnic Bowmen"] },
    norway = { new = ["Khazad Sentries", "Khazad Sentries", "Khazad Sentries"] },
    hungary = { new = ["Ered Luin Militia", "Ered Luin Militia Pikemen", "Ered Luin Scouts"] },
    moors = { new = ["Erebor Infantry", "Erebor Infantry", "Erebor Axethrowers"] },
    mongols = { new = ["Woodland Spearmen", "Woodland Spearmen", "Woodland Scouts"] },
    ireland = { new = ["Lorien Warders", "Lorien Warders", "Lorien Archers"] },
    denmark = { new = ["Lindar Guards", "Lindar Guards", "Lindar Bowmen"] },
    saxons = { new = ["Spear Quendi", "Spear Quendi", "Bow Quendi"] },
    england = { new = ["Orc Band", "Orc Band", "Orc Band"] },
    poland = { new = ["Dol Guldur Host", "Dol Guldur Host", "Dol Guldur Scouts"] },
    hre = { new = ["Goblin Band", "Goblin Band", "Goblin Archers"] },
    gundabad = { new = ["Snow-Orc Spearmen", "Snow-Orc Spearmen", "Snow-Orc Scouts"] },
    france = { new = ["Uruk-hai Raiders", "Uruk-hai Raiders", "Uruk-hai Archers"] },
    slave = { new = ["Bandits", "Bandits", "Bandits"] },
    egypt = { new = ["Gathring Shieldbearers", "Gathring Shieldbearers", "Daerbor Archers"] },
}

// on a settlement changing hands, re-skin its garrison to the new owner's flavour units.
::EUR.eurSwapUnitsOnTrade <- function(sett) {
    if (sett == null) return
    local settlement = ::EUR.eur_sMap.findSettlement(sett)
    if (settlement == null) return
    if (settlement.name == "Eregion" || settlement.name == "Enedwaith") return
    if (::EUR.checkCounter("eregion_is_spawning")) return
    if (::EUR.checkCounter("faction_spawning")) return
    ::EUR.logHelper("eurSwapUnitsOnTrade")

    local factionName = settlement.owner.name
    if (!(factionName in ::EUR.SWAP_GARRISON)) return
    local newUnits = ::EUR.SWAP_GARRISON[factionName].new

    if (settlement.army) {
        for (local j = 0; j < settlement.army.unitCount; j++) {
            local un = settlement.army.unit(j)
            local newEdu = ::units.get(newUnits[::EUR.math.random(0, newUnits.len() - 1)])
            if (newEdu) {
                un.type = newEdu
                un.soldiers = un.soldiersMax
            }
        }
    } else {
        local army = settlement.createGarrisonArmy()
        army.createUnit(newUnits[::EUR.math.random(0, newUnits.len() - 1)], 0, 0, 0, -1)
        army.createUnit(newUnits[::EUR.math.random(0, newUnits.len() - 1)], 0, 0, 0, -1)
    }
    ::EUR.logHelper("eurSwapUnitsOnTrade end")
}

// on confederation, retrain a faction's old units into their united equivalents (once).
::EUR.SwapUnitsOnConfed <- function(faction) {
    ::EUR.logHelper("SwapUnitsOnConfed")
    local factionName = faction.name
    if (!(factionName in CONFED_FACTIONS)) return
    local confed = CONFED_FACTIONS[factionName]
    if (::game.campaign().getEventCounter(confed.counter) != confed.value) return
    if (::EUR.checkCounter(confed.run_once)) { ::EUR.logHelper("SwapUnitsOnConfed end"); return }
    ::game.campaign().setEventCounter(confed.run_once, 1)

    local unitSize = 2.5
    local retrained = ""
    for (local i = 0; i < faction.armyCount; i++) {
        local army = faction.army(i)
        for (local j = 0; j < army.unitCount; j++) {
            local un = army.unit(j)
            if (un.type == null) continue
            for (local x = 0; x < confed.old.len(); x++) {
                if (un.type.name != confed.old[x]) continue
                local newEdu = ::units.get(confed.new[x])
                if (newEdu == null) continue
                retrained += "\nUnit: " + un.type.name + " replaced by " + confed.new[x]
                un.type = newEdu
                local cap = (newEdu.soldierCount * unitSize).tointeger()
                un.soldiers = (un.soldiers < cap) ? un.soldiers : cap
            }
        }
    }
    if (retrained != "") {
        ::game.showHistoricEvent("settlement_taken", "Units Retrained",
            "Now that our realms have united, our militia forces have undergone retaining and refitting. \n" + retrained)
    }
    ::EUR.logHelper("SwapUnitsOnConfed end")
}

::EUR.spawnGarrisons <- function(settlement) {
    if (!(settlement.owner.name in ::EUR.SWAP_GARRISON)) return
    // disabled in source: addGarrisonUnit(SWAP_GARRISON[owner].new[randN], "Settlement Garrison", settlement, ...)
}
