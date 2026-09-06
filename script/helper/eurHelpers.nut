::EUR.getDistance <- function(x1, y1, x2, y2) {
    local dx = x2 - x1
    local dy = y2 - y1
    return ::EUR.math.sqrt(dx * dx + dy * dy)
}

::EUR.sort_on_values <- function(t, ...) {
    local a = vargv
    t.sort(function(u, v) {
        for (local i = 0; i < a.len(); i++) {
            if (u[a[i]] > v[a[i]]) return 1
            if (u[a[i]] < v[a[i]]) return -1
        }
        return 0
    })
}

::EUR.set_active_left_window <- function(active_window) {
    foreach (name, v in ::EUR.window_states) {
        ::EUR.window_states[name] = (name == active_window)
    }
}

::EUR.registerLeftWindow <- function(stateKey, window) {
    ::EUR.left_windows[stateKey] <- window
}

::EUR.leftWindowHeld <- function(stateKey) {
    if (!(stateKey in ::EUR.left_windows)) { return false }
    if (!("gamePanelHeld" in ::UI)) { return true }
    return ::UI.gamePanelHeld(::EUR.left_windows[stateKey])
}

::EUR.syncLeftWindows <- function() {
    if (!::EUR.in_campaign_map) { return }
    local cm = ::ui.cardManager()
    if (cm == null) { return }
    local picked = cm.selectedUnit(0)
    if (picked != null) { ::EUR.sel_unit = picked }

    local windowOpen = ::EUR.window_states.swap_bg_window || ::EUR.window_states.show_upgrade_window
    local live = picked != null || cm.selectedCharacter != null
                 || cm.selectedSettlement != null || cm.selectedFort != null
    if (!live && !windowOpen) { return }
    if (::EUR.sel_unit == null) {
        ::EUR.can_bg_swap = false
        ::EUR.can_unit_upgrade = false
        return
    }

    ::EUR.temp_fort_char = (::EUR.sel_unit.general != null) ? ::EUR.sel_unit.general : null
    ::EUR.unit_only = (::EUR.temp_fort_char == null)

    ::EUR.can_bg_swap = ::EUR.options_gen_upgrades && ::EUR.temp_fort_char != null
                        && ::EUR.temp_fort_char.markedForDeath == false
                        && ::EUR.temp_fort_char.record != null
    ::EUR.can_unit_upgrade = !::EUR.can_bg_swap && ::EUR.sel_unit.type != null
                             && ::EUR.UNIT_UPGRADES != null
                             && (::EUR.sel_unit.type.name in ::EUR.UNIT_UPGRADES)
                             && ::EUR.UNIT_UPGRADES[::EUR.sel_unit.type.name] != null

    if (::EUR.window_states.swap_bg_window && !::EUR.can_bg_swap) {
        ::EUR.alias_text = ""
        ::EUR.alias_text_set = false
        local handOff = ::EUR.can_unit_upgrade && ::EUR.leftWindowHeld("swap_bg_window")
        ::EUR.set_active_left_window(handOff ? "show_upgrade_window" : "")
    }
    else if (::EUR.window_states.show_upgrade_window && !::EUR.can_unit_upgrade) {
        ::EUR.alias_text = ""
        ::EUR.alias_text_set = false
        local handOff = ::EUR.can_bg_swap && ::EUR.leftWindowHeld("show_upgrade_window")
        ::EUR.set_active_left_window(handOff ? "swap_bg_window" : "")
    }
}

::EUR.panelFollow <- function(window, stateTable, stateKey, wantShow, shownLast) {
    if (!("widgetVisibleGet" in ::UI)) {
        ::UI.widgetVisible(window, wantShow)
        return wantShow
    }
    if (wantShow && shownLast && !::UI.widgetVisibleGet(window)) {
        stateTable[stateKey] = false
        return false
    }
    ::UI.widgetVisible(window, wantShow)
    return wantShow
}

::EUR.setIfChanged <- function(record, field, value) {
    if (record[field] == value) { return }
    record[field] = value
}

::EUR.setLevelIfChanged <- function(level, cost, buildTime) {
    if (::buildings.levelCost(level) != cost) { ::buildings.setLevelCost(level, cost) }
    if (::buildings.levelBuildTime(level) != buildTime) { ::buildings.setLevelBuildTime(level, buildTime) }
}

::EUR.compare_up <- function(a, b) {
    return a[::EUR.sort_option] < b[::EUR.sort_option]
}

::EUR.compare_down <- function(a, b) {
    return a[::EUR.sort_option] > b[::EUR.sort_option]
}

::EUR.teststats <- function(type, slot) {
    local format = require("string").format
    local lines = [
        format("isMissile: %s", ("" + type.isMissile(slot))),
        format("AP: %s", ("" + type.isArmourPiercing(slot))),
        format("isSpearBonus12: %s", ("" + (type.spearBonus(slot) == 12))),
        format("isSpearBonus10: %s", ("" + (type.spearBonus(slot) == 10))),
        format("isSpearBonus8: %s", ("" + (type.spearBonus(slot) == 8))),
        format("isSpearBonus6: %s", ("" + (type.spearBonus(slot) == 6))),
        format("isSpearBonus4: %s", ("" + (type.spearBonus(slot) == 4))),
        format("attack: %d", type.attack(slot)),
        format("charge: %d", type.charge(slot)),
        format("Ammo: %d", type.ammo(slot)),
        format("Range: %d", type.range(slot)),
    ]
    local out = ""
    foreach (i, l in lines) out += (i == 0 ? "" : "\n") + l
    println(out)
}

::EUR.showEDUStatsAdjusted <- function(eduEntry, exp, armour, weapon_melee_blade, weapon_missile_mechanical) {
    if (eduEntry == null) { return "" }
    local edu = ::units.get(eduEntry)
    if (edu == null) { return "" }

    local unitArmour = 0
    local num = edu.armourTierCount()
    if (num != null) {
        for (local u = 0; u <= num - 1; u++) {
            local armlevel = edu.armourLevel(u)
            if (armlevel != null && armour >= armlevel) {
                unitArmour = u
            }
        }
    }

    local lines = []
    if (edu.attack(0) != null) {
        local expbonus = (exp > 0) ? ::EUR.math.ceil(exp / 3.0) : 0
        if (edu.category != 2) {
            if (edu.hasProjectile(0)) {
                local missile_text = " - Range: " + edu.range(0) + ", Ammo: " + edu.ammo(0)
                if (edu.isArmourPiercing(0)) { missile_text += ", Armour Piercing." }
                local melee_text = edu.isArmourPiercing(1) ? " - Armour Piercing." : ""
                local newmelee = edu.attack(1) + ((weapon_melee_blade > 0) ? weapon_melee_blade : 0) + expbonus
                local newmissile = edu.attack(0) + ((weapon_missile_mechanical > 0) ? weapon_missile_mechanical : 0)
                lines.append("Melee attack " + ("" + newmelee) + melee_text)
                lines.append("Missile attack " + ("" + newmissile) + missile_text)
                lines.append("Charge Bonus " + ("" + edu.charge(1)))
            } else {
                local melee_text = edu.isArmourPiercing(0) ? " - Armour Piercing." : ""
                local newmelee = edu.attack(0) + ((weapon_melee_blade > 0) ? weapon_melee_blade : 0) + expbonus
                lines.append("Melee attack " + ("" + newmelee) + melee_text)
                lines.append("Charge Bonus " + ("" + edu.charge(0)))
            }
        } else if (edu.attack(3) != null) {
            local missile_text = " - Range: " + edu.range(3) + ", Ammo: " + edu.ammo(3)
            local newmelee = edu.attack(0) + ((weapon_melee_blade > 0) ? weapon_melee_blade : 0) + expbonus
            local newmissile = edu.attack(3) + ((weapon_missile_mechanical > 0) ? weapon_missile_mechanical : 0)
            lines.append("Melee attack " + ("" + newmelee))
            lines.append("Missile attack " + ("" + newmissile) + missile_text)
            lines.append("Charge Bonus " + ("" + edu.charge(1)))
        } else {
            local melee_text = edu.isArmourPiercing(0) ? " - Armour Piercing." : ""
            local newmelee = edu.attack(0) + ((weapon_melee_blade > 0) ? weapon_melee_blade : 0) + expbonus
            lines.append("Melee attack " + ("" + newmelee) + melee_text)
            lines.append("Charge Bonus " + ("" + edu.charge(0)))
        }
    }

    lines.append("")
    local newarmour = edu.armour(0) + unitArmour
    lines.append("Defence total " + ("" + (edu.defence(0) + newarmour + edu.shield(0))))
    lines.append("Armour " + ("" + newarmour))
    lines.append("Defence skill " + ("" + edu.defence(0)))
    lines.append("Shield " + ("" + edu.shield(0)))

    local out = ""
    foreach (i, l in lines) { out += (i == 0 ? "" : "\n") + l }
    return out
}

::EUR.showEDUStats <- function(eduEntry) {
    if (eduEntry == null) { return "" }
    local edu = ::units.get(eduEntry)
    if (edu == null) { return "" }

    local lines = []
    if (edu.attack(0) != null) {
        if (edu.hasProjectile(0)) {
            lines.append("Melee attack " + ("" + edu.attack(1)))
            lines.append("Missile attack " + ("" + edu.attack(0)))
            lines.append("Charge Bonus " + ("" + edu.charge(1)))
        } else {
            lines.append("Melee attack " + ("" + edu.attack(0)))
            lines.append("Charge Bonus " + ("" + edu.charge(0)))
        }
    }
    lines.append("")
    lines.append("Defence total " + ("" + (edu.defence(0) + edu.armour(0) + edu.shield(0))))
    lines.append("Armour " + ("" + edu.armour(0)))
    lines.append("Defence skill " + ("" + edu.defence(0)))
    lines.append("Shield " + ("" + edu.shield(0)))

    local out = ""
    foreach (i, l in lines) out += (i == 0 ? "" : "\n") + l
    return out
}

::EUR.logHelper <- function(text) {
    if (::EUR.to_log) {
        println("EUR SLOG: " + text)
    }
}

::EUR.checkCounter <- function(counter) {
    if (counter == "") {
        return true
    }
    local value = ::game.campaign().getEventCounter(counter)
    return value != null && value > 0
}

local vals = [
    [1000, "M"],
    [ 900, "CM"],
    [ 500, "D"],
    [ 400, "CD"],
    [ 100, "C"],
    [  90, "XC"],
    [  50, "L"],
    [  40, "XL"],
    [  10, "X"],
    [   9, "IX"],
    [   5, "V"],
    [   4, "IV"],
    [   1, "I"],
]

::EUR.to_roman <- function(n) {
    local result = ""
    foreach (pair in vals) {
        while (n >= pair[0]) {
            result = result + pair[1]
            n = n - pair[0]
        }
    }
    return result
}

::EUR.replenRoadLevel <- function(regionID) {
    if (regionID == null) { return [0, null] }
    local road_level = 0
    local owner = null
    local region = ::stratMap.region(regionID)
    if (region != null) {
        if (region.name != "the sea") {
            road_level = region.roadLevel
            owner = region.faction
        }
    }
    return [road_level, owner]
}

::EUR.safe_divide <- function(numerator, denominator) {
    if (denominator == 0 || denominator == null) {
        return 0
    }
    return numerator / denominator
}

::EUR.safe_round_divide <- function(numerator, denominator) {
    if (denominator == 0 || denominator == null) {
        return 0
    }
    return ::EUR.math.floor((numerator / denominator) * 2 + 1e-9) / 2
}

::EUR.round_half <- function(x) {
    if (x == null || x == 0 || x == ::EUR.math.huge || x == -::EUR.math.huge) {
        return 0
    }
    local val = ::EUR.math.floor(x * 2 + 1e-9) / 2
    if (val >= 12 && val < 13) {
        return 12
    } else {
        return val
    }
}

::EUR.getUnitSizeMult <- function() {
    local gameOptions = ::game.options
    local unitSize = gameOptions.unitSize()
    if (unitSize == 0) {
    } else if (unitSize == 1) {
        return 1
    } else if (unitSize == 2) {
    } else if (unitSize == 3) {
    }
}

::EUR.removeDuplicates <- function(t) {
    local hash = {}
    local result = []
    foreach (v in t) {
        if (!(v in hash)) {
            result.append(v)
            hash[v] <- true
        }
    }
    return result
}

::EUR.rk_char_cas <- {
    denethor_rk = "denethor",
    faramir_rk = "faramir",
    boromir_rk = "boromir",
    orodreth_rk = "orodreth",
    forlong_rk = "forlong",
    hirluin_rk = "hirluin",
    angbor_rk = "angbor",
}

::EUR.fixRKCAS <- function() {
    foreach (k, v in ::EUR.rk_char_cas) {
        local char = ::EUR.getnamedCharbyLabel(k)
        if (char != null) {
            char.character.setStratModel(v)
        }
    }
}

::EUR.tableContains <- function(t, value) {
    foreach (v in t) {
        if (v == value) {
            return true
        }
    }
    return false
}

::EUR.tablePosition <- function(t, value) {
    foreach (i, v in t) {
        if (v == value) {
            return i
        }
    }
    return 15
}

::EUR.reverseTable <- function(myTable) {
    if (myTable && myTable.len() > 1) {
        myTable.reverse()
    }
}

::EUR.floatToPercentInt <- function(value) {
    return ::EUR.math.floor((value - 1) * 100 + 0.5)
}

::EUR.percentIntToFloat <- function(percent) {
    return 1 + (percent / 100.0)
}

::EUR.getnamedCharbyLabel <- function(label) {
    local rec = ::game.campaign().findCharacterByLabel(label)
    return (rec != null && rec.character != null) ? rec : null
}

::EUR.file_exists <- function(name) {
    local io = require("io")
    local f = null
    try { f = io.file(name, "rb") } catch (e) { return false }
    if (f == null) { return false }
    f.close()
    return true
}

::EUR.last_random <- {}

::EUR.random_no_repeat <- function(min, max) {
    if (min == null) { return 1 }
    if (max == null) { return 1 }
    if (min > max) { return 1 }
    if (min == max) { return min }
    if (max - min == 1) {
        local result = ((min in ::EUR.last_random) && ::EUR.last_random[min] == min) ? max : min
        ::EUR.last_random[min] <- result
        return result
    }

    local n
    local attempts = 0
    do {
        n = ::EUR.math.random(min, max)
        attempts = attempts + 1
        if (attempts > 10) { return n }
    } while (!(min in ::EUR.last_random) || n == ::EUR.last_random[min])

    ::EUR.last_random[min] <- n
    return n
}

::EUR.randomChance <- function(percent) {
    if (percent == 0) { return false }
    return percent >= ::EUR.math.random(1, 100)
}

::EUR.sortPlayerUnitsAlphabetically <- function(t1, t2) {
    local indices = []
    for (local i = 0; i < t1.len(); i++) indices.append(i)

    indices.sort(function(a, b) {
        return ("" + t1[a]).tolower() <=> ("" + t1[b]).tolower()
    })

    local sorted1 = []
    local sorted2 = []
    foreach (idx in indices) {
        sorted1.append(t1[idx])
        sorted2.append(t2[idx])
    }
    for (local i = 0; i < sorted1.len(); i++) {
        t1[i] = sorted1[i]
        t2[i] = sorted2[i]
    }
}

::EUR.shuffle <- function(tbl) {
    for (local i = tbl.len() - 1; i >= 1; i--) {
        local j = ::EUR.math.random(0, i)
        local tmp = tbl[i]; tbl[i] = tbl[j]; tbl[j] = tmp
    }
    return tbl
}

::EUR.printTable <- function(t) {
    local printTable_cache = {}

    local function rep(s, n) { local r = ""; for (local i = 0; i < n; i++) r += s; return r }

    local sub_printTable = null
    sub_printTable = function(t, indent) {
        if (("" + t) in printTable_cache) {
            println(indent + "*" + ("" + t))
        } else {
            printTable_cache[("" + t)] <- true
            if (typeof(t) == "table" || typeof(t) == "array") {
                foreach (pos, val in t) {
                    if (typeof(val) == "table" || typeof(val) == "array") {
                        println(indent + "[" + pos + "] => " + ("" + t) + " {")
                        sub_printTable(val, indent + rep(" ", ("" + pos).len() + 8))
                        println(indent + rep(" ", ("" + pos).len() + 6) + "}")
                    } else if (typeof(val) == "string") {
                        println(indent + "[" + pos + "] => \"" + val + "\"")
                    } else {
                        println(indent + "[" + pos + "] => " + ("" + val))
                    }
                }
            } else {
                println(indent + ("" + t))
            }
        }
    }

    if (typeof(t) == "table" || typeof(t) == "array") {
        println(("" + t) + " {")
        sub_printTable(t, "  ")
        println("}")
    } else {
        sub_printTable(t, "  ")
    }
}

::EUR.reorder_top_cost_items <- function(list, count_to_move) {
    local max_index = -1
    foreach (k, v in list) {
        if (k > max_index) max_index = k
    }

    local items = []
    for (local i = 0; i <= max_index; i++) {
        if (i in list && list[i] != null) {
            items.append({ index = i, item = list[i] })
        }
    }

    items.sort(function(a, b) {
        if (a.item.cost != b.item.cost) {
            return (a.item.cost > b.item.cost) ? -1 : 1
        } else {
            return (a.index < b.index) ? -1 : 1
        }
    })

    local top_set = {}
    for (local i = 0; i < ::EUR.math.min(count_to_move, items.len()); i++) {
        top_set[items[i].index] <- true
    }

    local front = []
    local back = []
    for (local i = 0; i <= max_index; i++) {
        if (i in list && list[i] != null) {
            if (i in top_set) {
                back.append({ index = i, item = list[i] })
            } else {
                front.append({ index = i, item = list[i] })
            }
        }
    }

    back.sort(function(a, b) {
        return (a.index > b.index) ? -1 : 1
    })

    local result = {}
    local i = 0
    foreach (entry in front) {
        result[i] <- entry.item
        i = i + 1
    }
    foreach (entry in back) {
        result[i] <- entry.item
        i = i + 1
    }

    return result
}

::EUR.reorder_top_cost_free_upkeep_only <- function(list, count_to_move, free_upkeep_index) {
    local is_in_free_upkeep = function(edu) {
        foreach (v in free_upkeep_index) {
            if (v == edu) return true
        }
        return false
    }

    local items = []
    for (local i = 0; i <= list.len(); i++) {
        items.append({ index = i, item = (i in list) ? list[i] : null })
    }

    local eligible = []
    foreach (entry in items) {
        if (entry != null) {
            if (entry.item != null) {
                if (entry.item.free && is_in_free_upkeep(entry.item.eduindex)) {
                    eligible.append(entry)
                }
            }
        }
    }

    eligible.sort(function(a, b) {
        if (a.item.cost != b.item.cost) {
            return (a.item.cost > b.item.cost) ? -1 : 1
        } else {
            return (a.index < b.index) ? -1 : 1
        }
    })

    local top_set = {}
    for (local i = 0; i < ::EUR.math.min(count_to_move, eligible.len()); i++) {
        top_set[eligible[i].index] <- true
    }

    local front = []
    local back = []
    foreach (entry in items) {
        if (entry != null) {
            if (entry.index != null) {
                if (entry.index in top_set) {
                    back.append(entry)
                } else {
                    front.append(entry)
                }
            }
        }
    }

    back.sort(function(a, b) {
        return (a.index > b.index) ? -1 : 1
    })

    local result = {}
    local i = 0
    foreach (entry in front) {
        result[i] <- entry.item
        i = i + 1
    }
    foreach (entry in back) {
        result[i] <- entry.item
        i = i + 1
    }

    return result
}

::EUR.isInsideArea <- function(x, y, minX, minY, maxX, maxY) {
    return x >= minX && x < maxX && y >= minY && y < maxY
}

::EUR.checkStratRange <- function(remote_x, remote_y, central_x, central_y, range) {
    if (!remote_x) { return false }
    if (!remote_y) { return false }
    if (!central_x) { return false }
    if (!central_y) { return false }
    local check_x = false
    local check_y = false
    if (range) {
        if ((remote_x - central_x) < range && (remote_x - central_x) > -range) {
            check_x = true
        }
        if ((remote_y - central_y) < range && (remote_y - central_y) > -range) {
            check_y = true
        }
        if (check_y && check_x) {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

::EUR.floatToWhole <- function(float, whole) {
    if (float == 0) {
        return null
    }
    return ::EUR.math.ceil(whole / float)
}

::EUR.wholeToFloat <- function(turns) {
    if (turns == 0) {
        return null
    }
    return (1.0 / turns)
}

::EUR.reversedPercentage <- function(value) {
    if (value < 0) value = 0
    if (value > 10) value = 10
    return 100 - (value * 10)
}

::EUR.dict_length <- function(tbl) {
    return tbl.len()
}

::EUR.getValidTile <- function(x, y) {
    local newx = x, newy = y
    if (::EUR.checkTileEmpty(x, y) == true) return [x, y]
    if (::EUR.checkTileEmpty(x + 1, y) == true) return [x + 1, y]
    if (::EUR.checkTileEmpty(x - 1, y) == true) return [x - 1, y]
    if (::EUR.checkTileEmpty(x, y + 1) == true) return [x, y + 1]
    if (::EUR.checkTileEmpty(x, y - 1) == true) return [x, y - 1]
    while (::EUR.checkTileEmpty(newx, newy) == false && newy >= y - 5) {
        newy = newy - 1
    }
    if (::EUR.checkTileEmpty(newx, newy) == true) return [newx, newy]
    newx = x; newy = y
    while (::EUR.checkTileEmpty(newx, newy) == false && newy <= y - 5) {
        newy = newy + 1
    }
    if (::EUR.checkTileEmpty(newx, newy) == true) return [newx, newy]
    newx = x; newy = y
    while (::EUR.checkTileEmpty(newx, newy) == false && newx >= x - 5) {
        newx = newx - 1
    }
    if (::EUR.checkTileEmpty(newx, newy) == true) return [newx, newy]
    newx = x; newy = y
    while (::EUR.checkTileEmpty(newx, newy) == false && newx <= x - 5) {
        newx = newx + 1
    }
    if (::EUR.checkTileEmpty(newx, newy) == true) return [newx, newy]
    return [x, y]
}

::EUR.checkTileEmpty <- function(x, y) {
    local tile = ::stratMap.tile(x, y)
    if (tile == null) { return false }
    if (::game.isTileFree(x, y)
        && !tile.settlement
        && !tile.fort
        && !tile.watchtower
        && !tile.port) {
        return true
    }
    return false
}

::EUR.deepCopyValue <- function(value) {
    local kind = typeof(value)
    if (kind == "table") {
        local out = {}
        foreach (k, v in value) { out[k] <- ::EUR.deepCopyValue(v) }
        return out
    }
    if (kind == "array") {
        local out = []
        foreach (v in value) { out.append(::EUR.deepCopyValue(v)) }
        return out
    }
    return value
}

// The Lua rebuilt both tables from their defaults on every options draw, latched by gen_set. Here
// it runs once per campaign instead, from campaignBoot - resetGameVars clears the live tables on
// newGameStart and nothing else refilled them, so a second campaign in one process came up with an
// empty bodyguard roster. Deep, not shallow: the editors write into these tables, and a shallow
// copy would let them edit the defaults they are meant to be restorable from.
::EUR.rebuildUpgradeLists <- function() {
    local bgSource = ::EUR.game_options.BG_T2 ? ::EUR.gen_units_list_default2 : ::EUR.gen_units_list_default

    ::EUR.gen_units_list = {}
    foreach (k, v in bgSource) { ::EUR.gen_units_list[k] <- ::EUR.deepCopyValue(v) }

    ::EUR.UNIT_UPGRADES = {}
    foreach (k, v in ::EUR.UNIT_UPGRADES_default) { ::EUR.UNIT_UPGRADES[k] <- ::EUR.deepCopyValue(v) }

    ::EUR.gen_set = true
}

::EUR.resetGameVars <- function() {
    println("resetGameVars")
    ::EUR.options_first_run = true
    ::EUR.gen_set = false

    ::EUR.options_replen = true
    ::EUR.options_poe = true
    ::EUR.options_merge = true
    ::EUR.options_sort = true
    ::EUR.options_prepost_save = false
    ::EUR.options_legendary = false
    ::EUR.options_extraBGunits = false
    ::EUR.options_no_free_upkeep = false
    ::EUR.build_forts = false
    ::EUR.options_extrabu = false
    ::EUR.eregion_spawned = false
    ::EUR.options_evolvingnames = false
    ::EUR.options_general_large_army = false
    ::EUR.watchtower_range = 10

    ::EUR.show_options_window = true

    ::EUR.replen_randmax = 2
    ::EUR.replen_multi = 20
    ::EUR.replen_beast_value = 8
    ::EUR.options_replen_beast = false
    ::EUR.waystation_bonus = 20

    ::EUR.replen_low = false
    ::EUR.replen_mid = true
    ::EUR.replen_high = false
    ::EUR.replen_text = "Rate: 5%"
    ::EUR.replen_always = false
    ::EUR.poe_turns_min = 1
    ::EUR.poe_turns_max = 2
    ::EUR.random_poe = false
    ::EUR.options_unit_upgrades = true
    ::EUR.unit_upgrades_multi = 0
    ::EUR.options_pre_battle = true
    ::EUR.options_addspoils = true
    ::EUR.options_gen_upgrades = true
    ::EUR.options_gen_bg_size = false
    ::EUR.merge_turn_multi = 5
    ::EUR.bg_swap_cooldown = 10
    ::EUR.options_hardcore = false
    ::EUR.bg_min_size_multi = 50
    ::EUR.options_gennotif = true
    ::EUR.dwarven_0_bu_added = false
    ::EUR.dwarven_0_count = 0
    ::EUR.anor_target_faction = null
    ::EUR.anorTurnsRemain = 0
    ::EUR.tempmengoodTarget = 0
    ::EUR.mengood_0_sett = null
    ::EUR.mengoodTurnsRemain = 0
    ::EUR.ship_1_active = false
    ::EUR.ship_2_active = false
    ::EUR.ship_3_active = false
    ::EUR.ship_4_active = false
    ::EUR.king_1_active = false
    ::EUR.king_2_active = false
    ::EUR.king_3_active = false
    ::EUR.stew_1_active = false
    ::EUR.stew_2_active = false
    ::EUR.stew_3_active = false

    ::EUR.noldor_ui_updated = false

    ::EUR.global_recruits = {}

    ::EUR.PURSE_MODIFIED = {}
    ::EUR.towers_already = {}

    ::EUR.gen_units_list = {}

    ::EUR.eur_eregion_active = false
    ::EUR.eregion_realms_start = 0
    ::EUR.eregion_realms_sett_taken = 0
    ::EUR.eregion_maernil_choice = false

    ::EUR.modifier_config = {}

    ::EUR.personal_guard_limit = 5
    ::EUR.set_mods = true
    ::EUR.show_gen_unit_card = false
    ::EUR.bg_t2_rank = 12
    ::EUR.bg_t3_rank = 18
    ::EUR.ai_unit_upgrades = true

    ::EUR.list_edu_table_default = []
    ::EUR.list_edu_table = []
    ::EUR.restricted_upgrades = true
    ::EUR.replen_cost_multi = 25
}

::EUR.defaultEDU <- function() {
    if (::EUR.defaultEDUOffset_on) { return }
    for (local i = 0; i <= 1500; i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry != null) {
            if (eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
                ::EUR.UNIT_ORIGINAL[eduEntry.name] <- {}
                ::EUR.UNIT_ORIGINAL[eduEntry.name].ammo <- eduEntry.ammo(0)
                ::EUR.UNIT_ORIGINAL[eduEntry.name].recruitCost <- eduEntry.recruitCost
                ::EUR.UNIT_ORIGINAL[eduEntry.name].recruitTime <- eduEntry.recruitPoints
                ::EUR.UNIT_ORIGINAL[eduEntry.name].range <- eduEntry.range(0)
            }
        }
    }
}

::EUR.clearMSG <- function() {
    ::game.runConsoleCommand("clear_messages", "")
}

::EUR.eurfixBuildingPics <- function(sett) {
    for (local i = 0; i <= sett.buildingCount - 1; i++) {
        local build = sett.building(i)
        local entry = build.type
        if (sett.owner.name != "slave") {
            if (build.factionId != sett.owner.id
                && sett.canConstruct(entry, build.level)) {
                build.factionId = sett.owner.id
            }
        }
        if (sett.isMinorSettlement && sett.owner.name == "slave"
            && build.levelName.indexof("green_book") == null) {
            build.factionId = sett.planFactionId
        }
    }
}

::EUR.revealTilesAround <- function(xCoord, yCoord) {
    local mapSizex = 500
    local mapSizey = 485
    local radius = 3

    for (local dx = -radius; dx <= radius; dx++) {
        for (local dy = -radius; dy <= radius; dy++) {
            local x = xCoord + dx
            local y = yCoord + dy
            if (x >= 0 && x < mapSizex && y >= 0 && y < mapSizey) {
                ::game.runScriptCommand("reveal_tile", x + " " + y)
            }
        }
    }
}

::EUR.genEDUcheck <- function() {
    if (::EUR.options_gen_bg_size) {
        for (local i = 0; i < ::EUR.mod_general_units_list.len(); i++) {
            local eduEntry = ::units.get(::EUR.mod_general_units_list[i].name)
            if (eduEntry != null) {
                if (!(eduEntry.name in ::EUR.original_general_units_list)) {
                    ::EUR.original_general_units_list[eduEntry.name] <- eduEntry.soldierCount
                }
                eduEntry.soldierCount = ::EUR.mod_general_units_list[i].size
            }
        }
    } else {
        for (local i = 0; i < ::EUR.mod_general_units_list.len(); i++) {
            local eduEntry = ::units.get(::EUR.mod_general_units_list[i].name)
            if (eduEntry != null) {
                if (eduEntry.soldierCount == ::EUR.mod_general_units_list[i].size) {
                    if (eduEntry.name in ::EUR.original_general_units_list) {
                        eduEntry.soldierCount = ::EUR.original_general_units_list[eduEntry.name]
                    }
                }
            }
        }
    }
}

::EUR.eurListTraits <- function(namedCharacter) {
    for (local i = 0; i <= namedCharacter.traitCount - 1; i++) {
        local trait = namedCharacter.getTrait(i)
        if (trait != null) {
            if (trait.traitType != null) {
                ::EUR.traits_temp.append(trait.traitType.name)
            }
        }
    }
}
