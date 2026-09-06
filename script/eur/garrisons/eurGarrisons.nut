::EUR.FACTION_PLAYER <- {
    aztecs = false, byzantium = false, denmark = false, england = false, france = false,
    gundabad = false, hre = false, hungary = false, ireland = false, khand = false,
    milan = false, mongols = false, moors = false, normans = false, norway = false,
    poland = false, portugal = false, russia = false, saxons = false, scotland = false,
    sicily = false, spain = false, teutonic_order = false, timurids = false, turks = false,
    venice = false, none = false,
}

::EUR.GARRISON_TRACK <- {}

::EUR.addAiGarrison <- function(fac) {
    ::EUR.logHelper("addAiGarrison")
    if (fac == null) return
    local faction = ::EUR.eur_campaign.factionByName(fac)
    if (faction == null) return
    if (!::EUR.game_options.garrisons) return
    if (::EUR.checkCounter("garrison_skip")) return

    local facName = faction.name
    if (facName == "slave") return
    if (!(facName in ::EUR.SETT_GARRISONS)) return
    if (!(facName in ::EUR.GARRISON_TRACK)) { ::EUR.GARRISON_TRACK[facName] <- {} }

    foreach (settlementKey, perCulture in ::EUR.SETT_GARRISONS[facName]) {
        local settlement = ::EUR.eur_sMap.findSettlement(settlementKey)
        if (settlement == null) continue
        if (settlement.owner.name != facName) continue

        if (!(settlement.name in ::EUR.GARRISON_TRACK[facName])) { ::EUR.GARRISON_TRACK[facName][settlement.name] <- {} }

        // culture-specific garrison list if present, otherwise the "none" default
        local garrisonList = (::EUR.eur_localFactionName in perCulture) ? perCulture[::EUR.eur_localFactionName]
                           : (("none" in perCulture) ? perCulture["none"] : null)
        if (garrisonList == null) continue

        local army = settlement.army
        if (army == null) { army = settlement.createGarrisonArmy() }
        if (army == null) continue

        local settTrack = ::EUR.GARRISON_TRACK[facName][settlement.name]

        // each entry is [ unitType, copies, experience, weaponUpgrade, armourUpgrade ]
        foreach (entryIndex, unitData in garrisonList) {
            local tierNumber = entryIndex + 1   // 1-based, used for the alias + track key
            local copies = unitData[1]
            for (local copyNumber = 1; copyNumber <= copies; copyNumber++) {
                if (settlement.army.unitCount >= 20) continue
                if (!army.inSettlement()) continue

                local newUnit = army.createUnit(unitData[0], unitData[2], unitData[3], unitData[4], -1)
                if (!newUnit) continue
                newUnit.name = settlement.displayName + " Garrison " + ::EUR.to_roman(tierNumber) + "-" + ::EUR.to_roman(copyNumber)

                if (!(tierNumber in settTrack)) { settTrack[tierNumber] <- {} }
                if (!(copyNumber in settTrack[tierNumber])) {
                    // first time this slot is created: record it as-is
                    settTrack[tierNumber][copyNumber] <- {
                        ID = newUnit.id,
                        alias = newUnit.name,
                        count = newUnit.soldiers,
                        pre_battle = false,
                        post_battle = false,
                    }
                } else {
                    // slot seen before: reinforce it back toward full, or reset if it fought
                    local track = settTrack[tierNumber][copyNumber]
                    local reinforced = track.count + ::EUR.math.ceil(newUnit.soldiersMax / 5)
                    track.ID = newUnit.id
                    if (track.pre_battle && !track.post_battle) {
                        newUnit.soldiers = ::EUR.math.ceil(newUnit.soldiersMax / 5)
                    } else if (reinforced < newUnit.soldiersMax) {
                        newUnit.soldiers = reinforced
                    } else {
                        newUnit.soldiers = newUnit.soldiersMax
                    }
                    track.count = newUnit.soldiers
                    track.pre_battle = false
                    track.post_battle = false
                }
            }
        }
    }
    ::EUR.logHelper("addAiGarrison end")
}

::EUR.removeAiGarrison <- function(faction, start) {
    if (!::EUR.game_options.garrisons) return
    if (faction == null || faction.name == null) return
    if (::EUR.SETT_GARRISONS == null || !(faction.name in ::EUR.SETT_GARRISONS)) return
    ::EUR.logHelper("removeAiGarrison")

    local toKill = []
    local seen = {}
    local collectFromArmy = function(army) {
        if (army == null) return
        for (local i = 0; i < army.unitCount; i++) {
            local unit = army.unit(i)
            if (unit == null || unit.isDead) continue
            if (typeof(unit.name) != "string" || unit.name.indexof("Garrison") == null) continue
            if (unit.general) continue
            if (!(unit.id in seen)) { seen[unit.id] <- true; toKill.append(unit) }
        }
    }

    // settlement garrisons (skip settlements freshly under siege on turn start)
    for (local x = 0; x < faction.settlementCount; x++) {
        local settlement = faction.settlement(x)
        if (settlement == null) continue
        local underSiegeStart = settlement.siegeCount > 0 && start
        if (!underSiegeStart) { collectFromArmy(settlement.army) }
    }

    // field armies not sitting in a settlement
    for (local j = 0; j < faction.armyCount; j++) {
        local army = faction.army(j)
        if (army == null) continue
        local inSett = false
        try { inSett = army.inSettlement() } catch (e) { inSett = false }
        if (!inSett) { collectFromArmy(army) }
    }

    foreach (unit in toKill) {
        if (unit == null || unit.isDead || unit.general) continue
        try { unit.kill() } catch (e) { ::EUR.logHelper("removeAiGarrison kill failed: " + e) }
    }
    ::EUR.logHelper("removeAiGarrison end")
}

// shared by clampGarrison / clampGarrisonSett: freeze every garrison unit in an army in place.
::EUR.clampGarrisonArmy <- function(army) {
    if (army == null) return
    for (local i = 0; i < army.unitCount; i++) {
        local unit = army.unit(i)
        if (unit == null || unit.isDead || unit.type == null) continue
        if (unit.type.name.indexof("Garrison") != null) {
            unit.movePoints = 0
        }
    }
}

::EUR.clampGarrison <- function(character) {
    ::EUR.logHelper("clampGarrison")
    if (character == null || character.settlement == null) return
    ::EUR.clampGarrisonArmy(character.settlement.army)
    ::EUR.logHelper("clampGarrison end")
}

::EUR.clampGarrisonSett <- function(settlement) {
    ::EUR.logHelper("clampGarrisonSett")
    if (settlement == null) return
    ::EUR.clampGarrisonArmy(settlement.army)
    ::EUR.logHelper("clampGarrisonSett end")
}

::EUR.resetPostBattleGarrison <- function() {
    ::EUR.logHelper("resetPostBattleGarrison")
    if (::EUR.pre_battle_faction == "" || ::EUR.pre_battle_garrison.len() == 0) return
    if (!(::EUR.pre_battle_faction in ::EUR.GARRISON_TRACK)) return

    foreach (pbAlias in ::EUR.pre_battle_garrison) {
        foreach (settName, settData in ::EUR.GARRISON_TRACK[::EUR.pre_battle_faction]) {
            foreach (tierIndex, tierData in settData) {
                foreach (copyNumber, entry in tierData) {
                    if (entry.alias == pbAlias) { entry.post_battle = true }
                }
            }
        }
    }
    ::EUR.pre_battle_faction = ""
    ::EUR.pre_battle_garrison = []
    ::EUR.logHelper("resetPostBattleGarrison end")
}

::EUR.legendaryGarrisons <- function() {
    ::EUR.SETT_GARRISONS["sicily"] <- {
        ["Anorien"] = {
            ["none"] = [
                ["Fountain Guard Garrison", 2, 3, 1, 1],
                ["Lossarnach Axemen Garrison", 2, 3, 1, 1],
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 3, 3, 1, 1],
            ],
            ["england"] = [
                ["Fountain Guard Garrison", 2, 3, 1, 1],
                ["Lossarnach Axemen Garrison", 2, 3, 1, 1],
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 3, 3, 1, 1],
            ],
            ["spain"] = [
                ["Fountain Guard Garrison", 2, 3, 1, 1],
                ["Lossarnach Axemen Garrison", 2, 3, 1, 1],
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 3, 3, 1, 1],
            ],
        },
        ["Anorien_Fields"] = {
            ["none"] = [ ["Gondor Garrison Infantry", 4, 3, 1, 1] ],
            ["england"] = [ ["Gondor Garrison Infantry", 4, 3, 1, 1] ],
            ["spain"] = [ ["Gondor Garrison Infantry", 4, 3, 1, 1] ],
        },
        ["Cair_Andros"] = {
            ["none"] = [
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 2, 3, 1, 1],
            ],
            ["england"] = [
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
            ["spain"] = [
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
        },
        ["West_Osgiliath"] = {
            ["none"] = [
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
            ],
            ["spain"] = [
                ["Guards of Osgiliath Garrison", 1, 3, 1, 1],
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
            ["england"] = [
                ["Guards of Osgiliath Garrison", 1, 3, 1, 1],
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
        },
        ["West_Lebennin"] = {
            ["none"] = [
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 2, 3, 1, 1],
            ],
            ["spain"] = [
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 2, 3, 1, 1],
            ],
            ["russia"] = [
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 2, 3, 1, 1],
            ],
        },
        ["Lebennin"] = {
            ["none"] = [
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 3, 3, 1, 1],
            ],
            ["spain"] = [
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 2, 3, 1, 1],
            ],
            ["russia"] = [
                ["Gondor Garrison Infantry", 3, 3, 1, 1],
                ["Gondor Garrison Archers", 2, 3, 1, 1],
            ],
        },
        ["East_Osgiliath"] = {
            ["none"] = [
                ["Guards of Osgiliath Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
            ["spain"] = [
                ["Guards of Osgiliath Garrison", 1, 3, 1, 1],
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
            ["england"] = [
                ["Guards of Osgiliath Garrison", 1, 3, 1, 1],
                ["Osgiliath Veterans Garrison", 1, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
        },
        ["Lossarnach"] = {
            ["none"] = [
                ["Lossarnach Axemen Garrison", 2, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
            ["england"] = [
                ["Lossarnach Axemen Garrison", 2, 3, 1, 1],
                ["Gondor Garrison Infantry", 2, 3, 1, 1],
                ["Gondor Garrison Archers", 1, 3, 1, 1],
            ],
        },
    }
}
