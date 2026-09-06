// Difficulty / economy tuning: rescales EDU recruit-cost, upkeep, build cost and
// recruit-pool gain, trims free-upkeep, and seeds AI modifiers. Edits the LIVE
// unit/building database via the squ accessors (units.* / buildings.* / vnv.*).

::EUR.FREE_UPKEEP_LIST <- {
    ["Tawar Areiniyr"] = true,
    ["umunzahar Nobles"] = true,
    ["Watch Shirriffs"] = true,
    ["Erebor Infantry"] = true,
    ["Nomad Warriors"] = true,
    ["Claw-Guard"] = true,
    ["Muhad Warriors"] = true,
    ["Bandits"] = true,
    ["Steppe Tribesmen"] = true,
    ["Lorien Scouts"] = true,
    ["Uruk-hai Raiders"] = true,
    ["Dunedain Bodyguard"] = true,
    ["Clan Axemen"] = true,
    ["Warg Skirmishers"] = true,
    ["Woodland Warriors"] = true,
    ["Mordag Fishermen"] = true,
    ["Orc Band"] = true,
    ["Pinnath Gelin Footmen"] = true,
    ["Anfalas Herdsmen"] = true,
    // ["Heavy Falathrim Wavebreakers"] = true,
    ["Lamedon Clansmen"] = true,
    ["Uruk Bodyguard"] = true,
    ["Blue Crag Goblin Slingers"] = true,
    ["Goblin Bodyguards"] = true,
    ["Mountain-Orc Hunters"] = true,
    ["Lebennin Marines"] = true,
    ["Blue Crag Blunt"] = true,
    ["Warg Riders"] = true,
    ["Gondor Bodyguard"] = true,
    ["Lindon Rangers"] = true,
    ["Seregil Riders"] = true,
    ["Pharazim Nobles"] = true,
    ["Lindon Bladesmen"] = true,
    ["Uruk Reavers"] = true,
    ["Dunedain Rangers"] = true,
    ["Angmar Bodyguards"] = true,
    ["Goblin Infantry"] = true,
    // ["Shadowblades of Himring"] = true,
    ["Orc Host"] = true,
    ["Khandish Hunters"] = true,
    ["Elbereths Sentinels"] = true,
    ["Woodman Warriors"] = true,
    ["Ered Luin Scouts"] = true,
    ["Lindar Mariners"] = true,
    ["Warband Host"] = true,
    ["Snow-Orc Raiders"] = true,
    ["Gathring Shieldbearers"] = true,
    ["Haradrim Spearmen"] = true,
    ["Sworn Defenders"] = true,
    ["Warg Marauders"] = true,
    ["Rivermen"] = true,
    ["Lorien Sentries"] = true,
    ["Mirkwood Archers"] = true,
    ["Lindon Mounted Wardens"] = true,
    ["Misty Mangonel"] = true,
    ["Goblin Band"] = true,
    ["Fylani Herders"] = true,
    ["Clan Heralds"] = true,
    ["Blue Crag Dual"] = true,
    ["Loke Rim Bodyguard"] = true,
    ["Woodman Trackers"] = true,
    ["Warband Sentries"] = true,
    ["Khazad Sentries"] = true,
    ["Sworn Horsemen"] = true,
    ["Mirkwood Spears"] = true,
    ["Orc Raiders"] = true,
    // ["Hirneryn Marchwardens"] = true,
    ["Rohirrim Archers"] = true,
    ["Orc Maulers"] = true,
    ["Bandobras Archers"] = true,
    ["Faolan Warriors"] = true,
    ["Thorn Crossbowmen"] = true,
    ["Liadan Billmen"] = true,
    ["Daritai Clansmen"] = true,
    ["Khandish Raiders"] = true,
    ["Beorning Axemen"] = true,
    ["Rhudaur Pikemen"] = true,
    ["Peasant Militia"] = true,
    ["Merchant Militia"] = true,
    ["Archer Militia"] = true,
    ["Isengard Ballista"] = true,
    ["Hillmen"] = true,
    ["Blue Crag Ballista"] = true,
    ["Snaga Archers"] = true,
    ["Skin-Changers"] = true,
    ["Blue Crag Goblin Spears"] = true,
    ["Blue Crag Goblin Axes"] = true,
    ["Blue Crag Slingers"] = true,
    ["Territorial Watchmen"] = true,
    ["Falas Lords"] = true,
    ["Thralls"] = true,
    // ["Doross Archers"] = true,
    ["Northmen Militia"] = true,
    ["Beekeepers"] = true,
    ["Lindon Coastal Wardens"] = true,
    ["Lindon Infantry"] = true,
    ["Nomad Horsemen"] = true,
    ["Daerbor Archers"] = true,
    ["Lindon Marines"] = true,
    ["Mornhîth Warriors"] = true,
    ["Aglon Defenders"] = true,
    ["Clan Hunters"] = true,
    ["Feanor BG"] = true,
    ["Mochaini Touta"] = true,
    ["Aglon Archers"] = true,
    ["Dalian Swordsmen"] = true,
    ["Lindon Longspears"] = true,
    ["Blue Crag Skirmishers"] = true,
    ["Fang-Guard"] = true,
    // ["Helevorn Pikemen"] = true,
    ["Noldorin Sword Bodyguard"] = true,
    ["Belegaer Archers"] = true,
    ["Noldorin Javelin Bodyguard"] = true,
    ["Eregion Barad Skirmishers"] = true,
    ["Southron Warband"] = true,
    ["Thorn Riders"] = true,
    ["Dubhshith Elders"] = true,
    ["Sworn Archers"] = true,
    ["Mounted Quendi"] = true,
    ["Dalian Billmen"] = true,
    ["Eregion Lindar Mariners"] = true,
    ["Dale Cavalry"] = true,
    // ["Orc-men spearguard"] = true,
    ["Haradrim Archers"] = true,
    // ["Eregion Mithrim Archers"] = true,
    ["Dunedain Garrison"] = true,
    ["Eregion Lindar Bowmen"] = true,
    ["Lorien Warders"] = true,
    ["Eregion Lindon Longspears"] = true,
    ["Eregion Lindar Guards"] = true,
    ["Woodman Defenders"] = true,
    ["Brenin's Guard"] = true,
    ["Zenith Guard"] = true,
    ["Eregion Mounted Quendi"] = true,
    ["Frekkalingir Hill-Riders"] = true,
    ["Territorial Cavalry"] = true,
    ["Eregion Sword Quendi"] = true,
    ["Dunedain Wardens"] = true,
    ["Lindar Guards"] = true,
    // ["Barad Eithel Blademasters"] = true,
    ["Rohirrim"] = true,
    ["Liadan Spearmen"] = true,
    ["Erebor Axethrowers"] = true,
    ["Southron Archers"] = true,
    // ["Eregion Mithrim Spearmen"] = true,
    ["Angmarim Archers"] = true,
    // ["Heavenly Arch Archers"] = true,
    // ["Eotheod Cavalry"] = true,
    // ["Sindar Riders"] = true,
    // ["Barad Eithel Archers"] = true,
    ["Thorn Bladesmen"] = true,
    ["Goblin Archers"] = true,
    ["Bow Quendi"] = true,
    ["Snaga Catapult"] = true,
    ["Blue Crag Goblin Dual"] = true,
    ["Sword Quendi"] = true,
    // ["Gondor Cavalry"] = true,
    ["Thorn Guard"] = true,
    ["Rhunnic Spears"] = true,
    ["Lindon Pike Quendi"] = true,
    ["Khazad Volunteers"] = true,
    ["Firebeard Warriors"] = true,
    ["Snow-Orc Scouts"] = true,
    ["Goblin Stalkers"] = true,
    ["Lumbermen"] = true,
    ["Lindon Marines Quendi"] = true,
    ["Orc Archers"] = true,
    ["Lindon Scouts Quendi"] = true,
    // ["Lindon Heavy Pikes"] = true,
    ["Clan Spearmen"] = true,
    // ["Northmen Garrison Elite"] = true,
    ["Lindon Cavalry"] = true,
    ["Dunlending Longspears"] = true,
    ["Marauders"] = true,
    ["Uruk-hai Archers"] = true,
    ["Steppe Archers"] = true,
    ["Spear Quendi"] = true,
    ["Lorien Archers"] = true,
    ["Snaga Skirmishers"] = true,
    ["Mordag Skirmishers"] = true,
    ["Regent Spearguard"] = true,
    ["Westron Catapult"] = true,
    ["Azrazair Archers"] = true,
    ["Royal Guardsmen"] = true,
    ["Raider Warband"] = true,
    ["Woodland Hunters"] = true,
    ["Dwarven Labourers"] = true,
    ["Raider Skirmishers"] = true,
    ["Druedain Hunters"] = true,
    ["Woodland Wardens"] = true,
    ["Eorling Archers"] = true,
    ["Eored Axemen"] = true,
    ["Eorling Spearmen"] = true,
    ["Angmarim Infantry"] = true,
    ["Dunedain Scouts"] = true,
    ["Rhovanion Hunters"] = true,
    ["Breeland Militia"] = true,
    ["Beorning Spearmen"] = true,
    // ["Variag Nobles"] = true,
    ["Dol Guldur Host"] = true,
    ["Territorial Swordsmen"] = true,
    ["Woodman Wardens"] = true,
    ["Goblin Striders"] = true,
    ["Noldorin Bodyguards"] = true,
    ["Thorn Patrolers"] = true,
    ["Dunlending Raiders"] = true,
    ["Fylani War Wagons"] = true,
    // ["Carinquar Riders"] = true,
    // ["Rhudaur Savages"] = true,
    // ["Yavannas Chosen"] = true,
    ["Eregion Spear Quendi"] = true,
    // ["Black Pit Spears"] = true,
    ["Snaga Stalkers"] = true,
    // ["Merchant Cavalry"] = true,
    // ["Frekkalingir Stalwarts"] = true,
    // ["Gondor Infantry"] = true,
    ["Rhovanion Riders"] = true,
    ["Dol Guldur Archers"] = true,
    // ["Greenway Riders"] = true,
    ["Territorial Guardsmen"] = true,
    ["Belegaer Footmen"] = true,
    ["High Paladins"] = true,
    ["Rohan Bodyguard"] = true,
    ["Woodland Spearmen"] = true,
    ["Southron Lancers"] = true,
    ["Farmhand Pikemen"] = true,
    ["Dourhand Catapult"] = true,
    ["Rhunnic Bowmen"] = true,
    ["Ered Luin Pikemen"] = true,
    ["Blue Crag Warg Riders"] = true,
    // ["Balaketh Axeguard"] = true,
    // ["Regent Axeguard"] = true,
    ["Rhovanion Spearmen"] = true,
    ["Orc Raiders old"] = true,
    // ["Athala Rangers"] = true,
    // ["Wolf Pack"] = true,
    ["Mount Gram Marauders"] = true,
    ["Nomad Axemen"] = true,
    // ["Rhudaur Huscarles"] = true,
    // ["Dunhird Berserkers"] = true,
    ["Orc Ballista"] = true,
    ["Vale Archers"] = true,
    ["Ered Luin Militia"] = true,
    ["Ered Luin Militia Pikemen"] = true,
    // ["Cardolan Sentinels"] = true,
    // ["Riddermark Axemen"] = true,
    ["Rhovanion Gadrauhts"] = true,
    ["Eregion Bow Quendi"] = true,
    ["Woodland Scouts"] = true,
    ["Maethyr i-Thewair"] = true,
    ["Frekkalingir Harriers"] = true,
    ["Calaquendi Lords"] = true,
    ["Beorning Defenders"] = true,
    ["Morannon Guard"] = true,
    ["Rhunnic Warriors"] = true,
    ["Lindon Bow Quendi"] = true,
    // ["Black Uruks"] = true,
    // ["Iron Crown Warriors"] = true,
    ["Southron Pikemen"] = true,
    ["Azrazair Raiders"] = true,
    ["Uruk-hai Bodyguards"] = true,
    ["Faolan Borderguard"] = true,
    ["Mountain Guard"] = true,
    ["Mount Gram Raiders"] = true,
    ["Woodman Hunters"] = true,
    ["Dol Guldur Scouts"] = true,
    ["Mirkwood Slayers"] = true,
    // ["Black Pit Infantry"] = true,
    ["Iron Hills Mattocks"] = true,
    ["Snaga Ballista"] = true,
    ["Lindar Bowmen"] = true,
    // ["Blackshield Warband"] = true,
    ["Mirkwood Bodyguard"] = true,
    // ["Blackshield Halberds"] = true,
    ["Keefei Huntsmen"] = true,

    ["Realm Sentinels"] = true,
    ["Eldarinwe Bodyguards"] = true,
    ["Sindar Riders"] = true,

    ["Mornhith Warriors"] = true,
}

// ---- eurDifficulty's own state flags (newly ported; declared so runtime
//      reads/writes below don't hit undefined globals) ----
::EUR.editTrait_on <- false
::EUR.orderOffset_on <- false
::EUR.defaultEDUOffset_on <- false
::EUR.defaultEDUOffset_faction <- ""
::EUR.defaultEDUOffsetleg_on <- false
::EUR.defaultEDUOffset_factionleg <- ""
::EUR.defaultEDUOffsetSetts_on <- false
::EUR.ecomod_added <- false
::EUR.globalmoraleset <- false
::EUR.diplo_removed <- false
::EUR.PURSE_MODIFIED <- {}

// NOTE ON THE HOST REBIND: the old EOP data APIs are mapped to the squ database
// surface — M2TWEOPDU.getEduEntry -> units.at, EDB.getBuildingByName/ByID ->
// buildings.byName/byIndex, building:getBuildingLevel(j) -> buildings.level(b,j),
// level.buildCost/buildTime -> buildings.levelCost/setLevelCost (+BuildTime),
// level:addCapability -> buildings.addCapability(level, 0, ...), level:getRecruitPool
// -> buildings.recruitPool(level, i) (iterated until it returns null, since the
// surface has no pool-count), M2TWEOP.getTrait -> vnv.trait, checkDipStance/
// setDipStance -> checkStance/setStance. Field-level writes on the returned edu /
// pool records (recruitCost, upkeepCost, gainPerTurn, agentType, ...) assume those
// fields are named+settable as they were under EOP — verify against the live host.

::EUR.TRAITS_MODIFY <- {
    militaryAI = {
        name = "AIBoostMilitary",
        // per level: [command, hitPoints, lineOfSight, personalSecurity, bodyguardSize, siegeEngineering, troopMorale, nightBattle]
        levels = [
            [3, 5, 5, 5, 5, 50, 4, 1],
            [4, 7, 5, 5, 5, 60, 7, 1],
        ],
    },
}

// Walks the AI-boost trait's effect table. As in the source, the per-effect value
// is only read into a local (never written back), so this applies nothing yet.
::EUR.editTrait <- function() {
    if (!::EUR.game_options.options_aiboost) { return }
    if (::EUR.editTrait_on) { return }

    foreach (key, entry in ::EUR.TRAITS_MODIFY) {
        local trait = ::vnv.trait(entry.name)
        if (trait == null) { continue }

        for (local i = 0; i < trait.levelCount; i++) {
            local level = trait.getLevel(i)
            if (level == null) { continue }

            for (local j = 0; j < level.effectCount; j++) {
                local effect = level.getEffect(j)
                if (effect != null) {
                    local value = entry.levels[i][j]   // source reads this without persisting it
                }
            }
        }
    }

    ::EUR.editTrait_on = true
}

// Legendary-only: give AI factions already at war with the player a one-off purse boost.
::EUR.legendaryDifficulty <- function(faction) {
    ::EUR.player_start_threshold = 8

    if (faction == null) { return }
    if (faction.isPlayerControlled != 0) { return }

    local isInWar = ::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.war, faction, ::EUR.eur_player_faction)
    if (!isInWar) { return }

    if (!(faction.name in ::EUR.PURSE_MODIFIED)) {
        ::EUR.PURSE_MODIFIED[faction.name] <- true
        faction.kingsPurse = faction.kingsPurse + 1000
    }
}

::EUR.GREEN_BOOK_BU <- [
    "hinterland_green_book_01",
    "hinterland_green_book_02",
    "hinterland_green_book_03",
    "hinterland_green_book_04",
    "hinterland_green_book_05",
    "hinterland_green_book_06",
    "hinterland_green_book_07",
    "hinterland_green_book_08",
]

// Adds a flat public-order penalty to the "green book" buildings for the player faction.
::EUR.orderOffset <- function() {
    if (!::EUR.game_options.order_offset) { return }
    if (::EUR.orderOffset_on) { return }

    for (local x = 0; x < ::EUR.GREEN_BOOK_BU.len(); x++) {
        local building = ::buildings.byName(::EUR.GREEN_BOOK_BU[x])
        if (building == null) { continue }

        local bonus = -4
        for (local i = 0; i < ::buildings.levelCount(building); i++) {
            local level = ::buildings.level(building, i)
            if (level != null) {
                ::buildings.addCapability(level, 0, ::Enum.BuildingCapability.lawBonus, bonus, true, "factions { " + ::EUR.eur_player_faction.name + ", }")
            }
        }
    }

    ::EUR.orderOffset_on = true
}

::EUR.EDUOFFET_VARS <- {
    threshold = 500,
    extragold = 0,
    extragold2 = 0,
    recruitTimeMult = 1,
    offset1 = 0,
    offset2 = 0,
    pooloffset1 = 0,
    pooloffset2 = 0,
    bu_time = 0,
    bu_cost = 0,
}

::EUR.EDUOFFET_VARS_LEG <- {
    threshold = 500,
    extragold = 0,
    extragold2 = 0,
    recruitTimeMult = 2,
    offset1 = 0,
    offset2 = 0,
    pooloffset1 = 60,
    pooloffset2 = 40,
    bu_time = 1,
    bu_cost = 10,
}

::EUR.EDB_POOL_CUSTOM <- {}
::EUR.temp_unit_levels <- {}   // only referenced by dead (commented-out) source paths

// Snapshots so defaultEDUEDBReset can restore the originals.
::EUR.default_edu_reset <- []
::EUR.default_edb_reset <- []
::EUR.default_edb_reset2 <- []

::EUR.defaultEDUEDBReset <- function() {
    for (local i = 0; i < ::EUR.default_edu_reset.len(); i++) {
        local entry = ::EUR.default_edu_reset[i]
        local eduEntry = ::units.at(entry.index)
        if (eduEntry != null) {
            ::EUR.setIfChanged(eduEntry, "recruitPoints", entry.recruitTime)
            ::EUR.setIfChanged(eduEntry, "recruitCost", entry.recruitCost)
            ::EUR.setIfChanged(eduEntry, "upkeep", entry.upkeepCost)
        }
    }

    for (local i = 0; i < ::EUR.default_edb_reset.len(); i++) {
        local entry = ::EUR.default_edb_reset[i]
        local building = ::buildings.byIndex(entry.id)
        if (building != null) {
            local level = ::buildings.level(building, entry.level)
            if (level != null) {
                ::EUR.setLevelIfChanged(level, entry.buildCost, entry.buildTime)
            }
        }
    }

    for (local i = 0; i < ::EUR.default_edb_reset2.len(); i++) {
        local entry = ::EUR.default_edb_reset2[i]
        local building = ::buildings.byIndex(entry.id)
        if (building != null) {
            local level = ::buildings.level(building, entry.level)
            if (level != null) {
                local pool = ::buildings.capability(level, 1, entry.pool)   // source used an undefined loop var here; uses the stored pool index now
                if (pool != null) {
                    if (::buildings.capabilityReplenishment(pool) != entry.gainPerTurn) {
                        ::buildings.setCapabilityReplenishment(pool, entry.gainPerTurn)
                    }
                }
            }
        }
    }

    ::EUR.defaultEDUOffsetleg_on = false
    ::EUR.defaultEDUOffset_on = false
    ::EUR.defaultEDUOffsetSetts_on = false
}

// Shared cost/upkeep scaling for one EDU entry.
::EUR.applyEduCostOffset <- function(eduEntry, vars, offset1, offset2) {
    if (::EUR.options_no_free_upkeep) {
        if (!(eduEntry.name in ::EUR.FREE_UPKEEP_LIST)) {
            eduEntry.freeUpkeep = false
        }
    }

    ::EUR.setIfChanged(eduEntry, "recruitPoints", ::EUR.math.ceil(eduEntry.recruitPoints * vars.recruitTimeMult))

    if (eduEntry.recruitCost > 0 && eduEntry.upkeep < vars.threshold) {
        ::EUR.setIfChanged(eduEntry, "recruitCost", ::EUR.math.ceil(eduEntry.recruitCost * offset1))
    } else if (eduEntry.recruitCost > 0) {
        ::EUR.setIfChanged(eduEntry, "recruitCost", ::EUR.math.ceil(eduEntry.recruitCost * offset2))
    }

    if (eduEntry.upkeep > 0 && eduEntry.upkeep < vars.threshold) {
        ::EUR.setIfChanged(eduEntry, "upkeep", ::EUR.math.ceil(eduEntry.upkeep * offset1) + vars.extragold)
    } else if (eduEntry.upkeep > 0) {
        ::EUR.setIfChanged(eduEntry, "upkeep", ::EUR.math.ceil(eduEntry.upkeep * offset2) + vars.extragold2)
    }
}

// Shared recruit-pool gain scaling for one pool.
::EUR.applyPoolGainOffset <- function(pool, eduEntry, vars, pooloffset1, pooloffset2) {
    local rate = ::buildings.capabilityReplenishment(pool)
    if (rate > 0) {
        local divisor = (eduEntry.upkeep > 0 && eduEntry.upkeep < vars.threshold) ? pooloffset1 : pooloffset2
        if (divisor != 1.0) { ::buildings.setCapabilityReplenishment(pool, rate / divisor) }
    }
}

::EUR.defaultEDUOffset <- function() {
    local offset1 = ::EUR.percentIntToFloat(::EUR.EDUOFFET_VARS.offset1)
    local offset2 = offset1
    local pooloffset1 = ::EUR.percentIntToFloat(::EUR.EDUOFFET_VARS.pooloffset1)
    local pooloffset2 = pooloffset1
    local bu_cost = ::EUR.percentIntToFloat(::EUR.EDUOFFET_VARS.bu_cost)

    if (::EUR.defaultEDUOffset_on) { return }
    if (::EUR.defaultEDUOffset_faction == ::EUR.eur_player_faction.name) { return }

    for (local i = 0; i <= 1500; i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry == null) { continue }
        if (::EUR.game_options.playeronlymods && !eduEntry.hasOwnership(::EUR.eur_playerFactionId)) { continue }

        ::EUR.default_edu_reset.append({ index = eduEntry.index, recruitTime = eduEntry.recruitPoints, recruitCost = eduEntry.recruitCost, upkeepCost = eduEntry.upkeep })
        ::EUR.applyEduCostOffset(eduEntry, ::EUR.EDUOFFET_VARS, offset1, offset2)
    }

    for (local i = 0; i <= 200; i++) {
        local building = ::buildings.byIndex(i)
        if (building == null) { continue }

        for (local j = 0; j < ::buildings.levelCount(building); j++) {
            local level = ::buildings.level(building, j)
            if (level == null) { continue }

            ::EUR.default_edb_reset.append({ id = i, level = j, buildCost = ::buildings.levelCost(level), buildTime = ::buildings.levelBuildTime(level) })
            ::EUR.setLevelIfChanged(level, ::EUR.math.ceil(::buildings.levelCost(level) * bu_cost),
                                    ::buildings.levelBuildTime(level) + ::EUR.EDUOFFET_VARS.bu_time)

            for (local x = 0; ; x++) {
                local pool = ::buildings.capability(level, 1, x)
                if (pool == null) { break }

                local poolEdu = ::units.at(::buildings.capabilityPayload(pool))
                if (poolEdu == null) { continue }
                if (::EUR.game_options.playeronlymods && !poolEdu.hasOwnership(::EUR.eur_playerFactionId)) { continue }

                ::EUR.default_edb_reset2.append({ id = i, level = j, pool = x, gainPerTurn = ::buildings.capabilityReplenishment(pool) })
                ::EUR.applyPoolGainOffset(pool, poolEdu, ::EUR.EDUOFFET_VARS, pooloffset1, pooloffset2)
            }
        }
    }

    ::EUR.defaultEDUOffset_on = true
    ::EUR.defaultEDUOffset_faction = ::EUR.eur_player_faction.name
}

::EUR.defaultEDUOffset_leg <- function() {
    local offset1 = ::EUR.percentIntToFloat(::EUR.EDUOFFET_VARS_LEG.offset1)
    local offset2 = offset1
    local pooloffset1 = ::EUR.percentIntToFloat(::EUR.EDUOFFET_VARS_LEG.pooloffset1)
    local pooloffset2 = pooloffset1
    local bu_cost = ::EUR.percentIntToFloat(::EUR.EDUOFFET_VARS_LEG.bu_cost)

    if (::EUR.defaultEDUOffsetleg_on) { return }
    if (::EUR.defaultEDUOffset_factionleg == ::EUR.eur_player_faction.name) { return }

    for (local i = 0; i <= 1500; i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry == null) { continue }
        if (!eduEntry.hasOwnership(::EUR.eur_playerFactionId)) { continue }
        ::EUR.applyEduCostOffset(eduEntry, ::EUR.EDUOFFET_VARS_LEG, offset1, offset2)
    }

    for (local i = 0; i <= 200; i++) {
        local building = ::buildings.byIndex(i)
        if (building == null) { continue }

        for (local j = 0; j < ::buildings.levelCount(building); j++) {
            local level = ::buildings.level(building, j)
            if (level == null) { continue }

            ::EUR.setLevelIfChanged(level, ::EUR.math.ceil(::buildings.levelCost(level) * bu_cost),
                                    ::buildings.levelBuildTime(level) + ::EUR.EDUOFFET_VARS_LEG.bu_time)

            for (local x = 0; ; x++) {
                local pool = ::buildings.capability(level, 1, x)
                if (pool == null) { break }
                local poolEdu = ::units.at(::buildings.capabilityPayload(pool))
                if (poolEdu == null) { continue }
                if (!poolEdu.hasOwnership(::EUR.eur_playerFactionId)) { continue }
                ::EUR.applyPoolGainOffset(pool, poolEdu, ::EUR.EDUOFFET_VARS_LEG, pooloffset1, pooloffset2)
            }
        }
    }

    ::EUR.defaultEDUOffsetleg_on = true
    ::EUR.defaultEDUOffset_factionleg = ::EUR.eur_player_faction.name
}

::EUR.EDB_POOL_DEFAULT <- {}

// Snapshots the player's default recruit pools. Dead in the current call graph
// (its only call site is commented out) but kept for parity.
::EUR.defaultEDUGather <- function() {
    for (local i = 0; i <= 200; i++) {
        local building = ::buildings.byIndex(i)
        if (building == null) { continue }

        for (local j = 0; j < ::buildings.levelCount(building); j++) {
            local level = ::buildings.level(building, j)
            if (level == null) { continue }

            for (local x = 0; ; x++) {
                local pool = ::buildings.capability(level, 1, x)
                if (pool == null) { break }
                local eduEntry = ::units.at(::buildings.capabilityPayload(pool))
                if (eduEntry == null) { continue }
                if (!eduEntry.hasOwnership(::EUR.eur_playerFactionId)) { continue }

                if (!(::buildings.name(building) in ::EUR.EDB_POOL_DEFAULT)) {
                    ::EUR.EDB_POOL_DEFAULT[::buildings.name(building)] <- {}
                    ::EUR.EDB_POOL_DEFAULT[::buildings.name(building)].localname <- ::buildings.displayName(building)
                }
                if (!(j in ::EUR.EDB_POOL_DEFAULT[::buildings.name(building)])) {
                    ::EUR.EDB_POOL_DEFAULT[::buildings.name(building)][j] <- {}
                    ::EUR.EDB_POOL_DEFAULT[::buildings.name(building)][j][::EUR.eur_playerFactionId] <- {}
                    ::EUR.EDB_POOL_DEFAULT[::buildings.name(building)][j][::EUR.eur_playerFactionId]["units"] <- {}
                }
                ::EUR.EDB_POOL_DEFAULT[::buildings.name(building)][j][::EUR.eur_playerFactionId]["units"][eduEntry.name] <- {
                    experience = ::buildings.capabilityBase(pool),
                    eduType = eduEntry.name,
                    recruitCost = eduEntry.recruitCost,
                    upkeepCost = eduEntry.upkeep,
                    unitCardTga = eduEntry.cardImage,
                    initialSize = ::buildings.capabilityInitialUnits(pool),
                    gainPerTurn = ::buildings.capabilityReplenishment(pool),
                    maxSize = ::buildings.capabilityMaxUnits(pool),
                }
            }
        }
    }
}

::EUR.faction_list <- [
    "aztecs", "byzantium", "denmark", "england", "france", "gundabad", "hre", "hungary",
    "ireland", "khand", "milan", "mongols", "moors", "normans", "norway", "poland",
    "portugal", "russia", "saxons", "scotland", "sicily", "spain", "teutonic_order",
    "timurids", "turks", "venice",
]

// Forces a war (choice != 1) or peace (choice == 1) stance across factions.
::EUR.setDiplomacyBulk <- function(player_only, choice) {
    local diplo_stance = ::Enum.DiplomaticRelation.war
    if (choice == 1) {
        diplo_stance = ::Enum.DiplomaticRelation.peace
    } else {
        if (!::EUR.diplo_removed) {
            ::EUR.disableDiplomats()
        }
    }

    if (player_only) {
        for (local i = 0; i < ::EUR.faction_list.len(); i++) {
            local fac1 = ::EUR.eur_player_faction
            local fac2 = ::EUR.eur_campaign.factionByName(::EUR.faction_list[i])
            if (!::EUR.eur_campaign.checkStance(diplo_stance, fac1, fac2)) {
                ::EUR.eur_campaign.setStance(diplo_stance, fac1, fac2)
            }
        }
    } else {
        for (local i = 0; i < ::EUR.faction_list.len(); i++) {
            for (local j = i + 1; j < ::EUR.faction_list.len(); j++) {
                local fac1 = ::EUR.eur_campaign.factionByName(::EUR.faction_list[i])
                local fac2 = ::EUR.eur_campaign.factionByName(::EUR.faction_list[j])
                if (!::EUR.eur_campaign.checkStance(diplo_stance, fac1, fac2)) {
                    ::EUR.eur_campaign.setStance(diplo_stance, fac1, fac2)
                }
            }
        }
    }
}

// Kills every diplomat and zeroes diplomat recruit pools.
::EUR.disableDiplomats <- function() {
    for (local i = 0; i < ::EUR.faction_list.len(); i++) {
        local faction = ::EUR.eur_campaign.factionByName(::EUR.faction_list[i])
        if (faction == null) { continue }

        for (local j = 0; j < faction.characterCount; j++) {
            local char = faction.character(j)
            if (char != null && char.typeId == 2) {
                char.kill()
            }
        }
    }

    for (local i = 0; i <= 200; i++) {
        local building = ::buildings.byIndex(i)
        if (building == null) { continue }

        for (local j = 0; j < ::buildings.levelCount(building); j++) {
            local level = ::buildings.level(building, j)
            if (level == null) { continue }

            for (local x = 0; ; x++) {
                local pool = ::buildings.capability(level, 1, x)
                if (pool == null) { break }
                if (::buildings.capabilityCategory(pool) == 2 && ::buildings.capabilityPayload(pool) == 2) {
                    ::buildings.setCapabilityMaxUnits(pool, 0.0)
                    ::buildings.setCapabilityInitialUnits(pool, 0.0)
                }
            }
        }
    }

    ::EUR.diplo_removed = true
}

// EOP AI-config modifiers: getEopAiConfig / getCampaignDifficulty2 have no squ equivalent.
// ::EUR.getEOPModifiers <- function() {
//     local EopAiConfig = M2TWEOP.getEopAiConfig()
//     if (::game.options.campaignDifficulty() == 3) {
//         ::EUR.modifier_config.aggressionFactor <- 1.3
//     } else {
//         ::EUR.modifier_config.aggressionFactor <- 1.25
//     }
//     ::EUR.modifier_config.nonBorderFactor <- 0.05
//     ::EUR.modifier_config.forceNavalInvasions <- true
// }
//
// ::EUR.setEOPModifiers <- function() {
//     local EopAiConfig = M2TWEOP.getEopAiConfig()
//     EopAiConfig.enabled = ::EUR.modifier_config.enabled
//     EopAiConfig.aggressionFactor = ::EUR.modifier_config.aggressionFactor
//     EopAiConfig.nonBorderFactor = ::EUR.modifier_config.nonBorderFactor
//     campaignDiff2.forceNavalInvasions = ::EUR.modifier_config.forceNavalInvasions
// }

// Scales farm income up as campaign difficulty drops.
::EUR.economyModifiers <- function() {
    if (::EUR.ecomod_added) { return }

    local difficulty = ::game.options.campaignDifficulty() * 10
    local addition = ::EUR.math.ceil(120 - (difficulty * 4))

    if (addition > 0) {
        local building = ::buildings.byName("hinterland_farms")
        if (building != null) {
            for (local j = 0; j < ::buildings.levelCount(building); j++) {
                local level = ::buildings.level(building, j)
                if (level != null) {
                    ::buildings.addCapability(level, 0, ::Enum.BuildingCapability.incomeBonus, addition * (j + 1), true, "factions { all, }")
                }
            }
        }
    }

    ::EUR.ecomod_added = true
}

::EUR.legendaryToggle <- function(bool) {
    if (bool) {
        ::EUR.options_legendary = true
        ::EUR.options_hardcore = true
        ::EUR.options_no_free_upkeep = true
        ::EUR.game_options.options_aiboost = true
        ::EUR.game_options.order_offset = true
    } else {
        ::EUR.options_hardcore = false
        ::EUR.options_no_free_upkeep = false
        ::EUR.game_options.options_aiboost = false
        ::EUR.game_options.order_offset = false
    }
}

::EUR.globalMoraleIncrease <- function(value) {
    if (::EUR.globalmoraleset) { return }

    for (local i = 0; i <= 1500; i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry != null) {
            eduEntry.morale = eduEntry.morale + value
        }
    }

    ::EUR.globalmoraleset = true
}

// ---- settlement-difficulty EDU/EDB offset (ported from chrisAddSetts) ----
::EUR.EDUOFFET_SETT_VARS <- {
    threshold = 500, extragold = 0, extragold2 = 0, recruitTimeMult = 1,
    offset1 = 0, offset2 = 0, pooloffset1 = 0, pooloffset2 = 0,
}

::EUR.defaultEDUOffsetSetts <- function() {
    if (!::EUR.options_legendary) {
        ::EUR.EDUOFFET_SETT_VARS.pooloffset1 = -50
        ::EUR.EDUOFFET_SETT_VARS.pooloffset2 = -30
    }

    local vars = ::EUR.EDUOFFET_SETT_VARS
    local offset1 = ::EUR.percentIntToFloat(vars.offset1)
    local offset2 = ::EUR.percentIntToFloat(vars.offset2)
    local pooloffset1 = ::EUR.percentIntToFloat(vars.pooloffset1)
    local pooloffset2 = ::EUR.percentIntToFloat(vars.pooloffset2)
    local aiPoolOffset1 = ::EUR.percentIntToFloat(-50)
    local aiPoolOffset2 = ::EUR.percentIntToFloat(-30)

    if (::EUR.defaultEDUOffsetSetts_on) { return }

    for (local i = 0; i <= 1500; i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry == null) { continue }

        ::EUR.setIfChanged(eduEntry, "recruitPoints", eduEntry.recruitPoints * vars.recruitTimeMult)
        if (eduEntry.recruitCost > 0 && eduEntry.upkeep < vars.threshold) {
            ::EUR.setIfChanged(eduEntry, "recruitCost", ::EUR.math.ceil(eduEntry.recruitCost * offset1))
        } else if (eduEntry.recruitCost > 0) {
            ::EUR.setIfChanged(eduEntry, "recruitCost", ::EUR.math.ceil(eduEntry.recruitCost * offset2))
        }
        if (eduEntry.upkeep > 0 && eduEntry.upkeep < vars.threshold) {
            ::EUR.setIfChanged(eduEntry, "upkeep", ::EUR.math.ceil(eduEntry.upkeep * offset1) + vars.extragold)
        } else if (eduEntry.upkeep > 0) {
            ::EUR.setIfChanged(eduEntry, "upkeep", ::EUR.math.ceil(eduEntry.upkeep * offset2) + vars.extragold2)
        }
    }

    for (local i = 0; i <= 200; i++) {
        local building = ::buildings.byIndex(i)
        if (building == null) { continue }

        for (local j = 0; j < ::buildings.levelCount(building); j++) {
            local level = ::buildings.level(building, j)
            if (level == null) { continue }

            for (local x = 0; ; x++) {
                local pool = ::buildings.capability(level, 1, x)
                if (pool == null) { break }

                local poolEdu = ::units.at(::buildings.capabilityPayload(pool))
                if (poolEdu == null) { continue }
                if (::buildings.capabilityReplenishment(pool) <= 0) { continue }

                local ownsIt = poolEdu.hasOwnership(::EUR.eur_playerFactionId)
                local lowUpkeep = (poolEdu.upkeep > 0 && poolEdu.upkeep < vars.threshold)
                if (!ownsIt) {
                    local factor = lowUpkeep ? aiPoolOffset1 : aiPoolOffset2
                    if (factor != 1.0) {
                        ::buildings.setCapabilityReplenishment(pool, ::buildings.capabilityReplenishment(pool) * factor)
                    }
                } else {
                    local factor = lowUpkeep ? pooloffset1 : pooloffset2
                    if (factor != 1.0) {
                        ::buildings.setCapabilityReplenishment(pool, ::buildings.capabilityReplenishment(pool) * factor)
                    }
                }
            }
        }
    }

    ::EUR.defaultEDUOffsetSetts_on = true
}
