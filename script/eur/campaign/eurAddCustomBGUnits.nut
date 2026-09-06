// Registers a handful of faction-unique bodyguard units as cloned unit types
// (keys 5001..5006) and wires them into building recruitment pools.
// Rebound onto the squ database: addEopEduEntryFromEDUID -> units.clone(baseIndex, key)
// (which names the clone "<baseUnit>_<key>", so we fetch it back by that name),
// getEduIndexByType -> units.get(type).index, EDB.* -> buildings.*.
// Field writes on the cloned type (setOwnership/soldierCount/upkeepCost) and
// pool.unitID assume those are exposed as they were under EOP — verify on the host.

::EUR.CUSTOM_UNIT_ADD <- [
    { faction = "turks",   eduType = "Grey Company",     newMax = 35, newUpkeep = 600, bu = "hinterland_unique6",         level = 2,    scope = [0.8, 0.036, 1.0, 2], extra = "factions { turks, }" },
    { faction = "saxons",  eduType = "GilGalads Company", newMax = 35, newUpkeep = 775, bu = "hinterland_tharbad_bridge", level = 2,    scope = [0.8, 0.036, 1.0, 2], extra = "factions { saxons, }" },
    { faction = "france",  eduType = "Guard of the Hand", newMax = 35, newUpkeep = 500, bu = "castle_hall",               level = null, scope = [0.8, 0.036, 1.0, 2], extra = "factions { france, }  and hidden_resource Rohan and hidden_resource ResA" },
    { faction = "denmark", eduType = "Falas Lords",       newMax = 48, newUpkeep = 775, bu = "city_hall",                 level = null, scope = [0.8, 0.036, 1.0, 2], extra = "factions { denmark, }  and hidden_resource Lindon and hidden_resource ResE" },
    { faction = "norway",  eduType = "Balins Guard",      newMax = 35, newUpkeep = 775, bu = "city_hall",                 level = null, scope = [0.8, 0.036, 1.0, 2], extra = "factions { norway, }  and hidden_resource Eregion and hidden_resource ResI" },
    { faction = "sicily",  eduType = "The White Company", newMax = 48, newUpkeep = 600, bu = "hinterland_unique1",         level = 0,    scope = [0.8, 0.036, 1.0, 2], extra = "factions { turks, sicily }" },
]

// The clone of `eduType` under key `eopId` is named "<eduType>_<eopId>".
::EUR.customCloneName <- function(entry, eopId) {
    return entry.eduType + "_" + eopId
}

::EUR.addCustomBGToPool <- function() {
    for (local i = 0; i < ::EUR.CUSTOM_UNIT_ADD.len(); i++) {
        local entry = ::EUR.CUSTOM_UNIT_ADD[i]
        local eopId = 5001 + i

        local baseUnit = ::units.get(entry.eduType)
        if (baseUnit == null) { continue }

        local unit = ::units["clone"](baseUnit.index, eopId)
        if (unit) {
            unit.setOwnership(::EUR.faction_id_list[entry.faction], true)
            unit.soldierCount = entry.newMax
            unit.upkeep = entry.newUpkeep
        }
    }
}

::EUR.enableExtraBG <- function() {
    for (local i = 0; i < ::EUR.CUSTOM_UNIT_ADD.len(); i++) {
        local entry = ::EUR.CUSTOM_UNIT_ADD[i]
        local eopId = 5001 + i

        local clonedUnit = ::units.get(::EUR.customCloneName(entry, eopId))
        if (clonedUnit == null) { continue }
        local unitIndex = clonedUnit.index

        local building = ::buildings.byName(entry.bu)
        if (building == null) { continue }

        if (entry.level == null) {
            for (local j = 0; j < ::buildings.levelCount(building); j++) {
                local level = ::buildings.level(building, j)
                if (level != null) {
                    ::buildings.addRecruitPool(level, unitIndex, entry.scope[0], entry.scope[1], entry.scope[2], entry.scope[3], false, entry.extra)
                }
            }
        } else {
            local level = ::buildings.level(building, entry.level)
            if (level != null) {
                ::buildings.addRecruitPool(level, unitIndex, entry.scope[0], entry.scope[1], entry.scope[2], entry.scope[3], false, entry.extra)
            }
        }
    }
}

::EUR.removeCustomBGFromPool <- function() {
    for (local i = 0; i < ::EUR.CUSTOM_UNIT_ADD.len(); i++) {
        local entry = ::EUR.CUSTOM_UNIT_ADD[i]
        local eopId = 5001 + i

        local clonedUnit = ::units.get(::EUR.customCloneName(entry, eopId))
        if (clonedUnit == null) { continue }
        local unitIndex = clonedUnit.index

        local building = ::buildings.byName(entry.bu)
        if (building == null) { continue }

        if (entry.level == null) {
            // NB: source passes the null level straight through here (unlike enableExtraBG,
            // which loops every level) — preserved as-is.
            local level = ::buildings.level(building, entry.level)
            if (level != null) {
                ::EUR.removeMatchingPools(level, unitIndex)
            }
        } else {
            for (local j = 0; j < ::buildings.levelCount(building); j++) {
                local level = ::buildings.level(building, j)
                if (level != null) {
                    ::EUR.removeMatchingPools(level, unitIndex)
                }
            }
        }
    }
}

// Drops every recruit pool on `level` that produces the given unit index.
// Collects first, then removes back-to-front so removals don't shift the scan.
::EUR.removeMatchingPools <- function(level, unitIndex) {
    local matches = []
    for (local x = 0; ; x++) {
        local pool = ::buildings.capability(level, 1, x)
        if (pool == null) { break }
        if (::buildings.capabilityPayload(pool) == unitIndex) {
            matches.append(x)
        }
    }

    for (local k = matches.len() - 1; k >= 0; k--) {
        ::buildings.removeRecruitPool(level, matches[k])
    }
}
