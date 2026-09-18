// module-locals in the source; globals here because Quirrel closures capture upvalues by value.
::EUR.alt_kills_unit  <- []
::EUR.alt_caught_unit <- []
::EUR.alt_exp_unit    <- []
::EUR.alt_checked     <- false

::EUR.filterAltLoot <- function(entries, minCount, key, threshold, comparison) {
    if (entries.len() < minCount) return []

    local matches = []
    foreach (entry in entries) {
        local value = (key in entry) ? entry[key] : null
        if (!value) continue
        local ok = (comparison == "gt" && value > threshold)
                || (comparison == "lt" && value < threshold)
                || (comparison == "eq" && value == threshold)
        if (ok) { matches.append(entry) }
    }
    if (matches.len() < minCount) return []

    for (local i = matches.len() - 1; i >= 1; i--) {   // Fisher-Yates shuffle
        local j = ::EUR.math.random(0, i)
        local swap = matches[i]; matches[i] = matches[j]; matches[j] = swap
    }
    local result = []
    for (local i = 0; i < minCount; i++) { result.append(matches[i]) }
    return result
}

::EUR.checkAltLoot <- function() {
    local killThreshold = (::EUR.alt_loot_units.len() > 10) ? 2 : 1
    ::EUR.alt_kills_unit  = ::EUR.filterAltLoot(::EUR.alt_loot_units, killThreshold, "kills", 50, "gt")
    ::EUR.alt_caught_unit = ::EUR.filterAltLoot(::EUR.alt_loot_units, 1, "caught", 50, "gt")
    ::EUR.alt_exp_unit    = ::EUR.filterAltLoot(::EUR.alt_loot_units, 1, "expgain", 1, "gt")
    ::EUR.alt_checked = true
}

::EUR.resetAltLoot <- function() {
    ::EUR.show_alt_loot = false
    ::EUR.alt_loot = false
    ::EUR.alt_loot_units = []
    ::EUR.alt_loot_anc = []
    ::EUR.alt_loot_enemy_gen = {}
    ::EUR.alt_loot_player_gen = {}
    ::EUR.won_battle_alt = false
    ::EUR.alt_checked = false
}

::EUR.altLootWindow <- function() {
    if (!::EUR.alt_loot) { ::EUR.resetAltLoot(); return }
    if (!::EUR.alt_checked) { ::EUR.checkAltLoot() }

    // ~70% chance: bump the biggest killers up one chevron (capped below veteran).
    if (::EUR.math.random(1, 100) > 30) {
        foreach (entry in ::EUR.alt_kills_unit) {
            if (entry == null || entry.unit == null || entry.unit.isDead) continue
            if (entry.unit.experience >= 9 || entry.unit.type == null) continue
            entry.unit.setParams(entry.unit.experience + 1, entry.unit.armourLevel, entry.unit.weaponLevel)
        }
    }
    ::EUR.resetAltLoot()
}

::EUR.endTurnRemoveStuff <- function() {
    ::EUR.logHelper("endTurnRemoveStuff")
    if (::EUR.alt_loot_remove_stuff.len() > 2 && ::EUR.alt_loot_remove_stuff[2]) {
        if (::EUR.alt_loot_remove_stuff[0].isAlive) {
            ::EUR.alt_loot_remove_stuff[0].removeAncillary(::EUR.alt_loot_remove_stuff[1])
        }
    }
    ::EUR.alt_loot_remove_stuff[0] = null
    ::EUR.alt_loot_remove_stuff[1] = null
    ::EUR.alt_loot_remove_stuff[2] = false
    ::EUR.logHelper("endTurnRemoveStuff end")
}
