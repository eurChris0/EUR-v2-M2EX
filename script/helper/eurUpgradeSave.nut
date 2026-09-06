// Serialise a live table back over the data file it was seeded from - the port of the Lua's
// serializeTable / generalWriteDefault / unitWriteDefault. Whole-file rewrite, not a delta: the
// shipped default IS the store, so an edit is permanent and a mod update overwrites it.

::EUR.serialiseString <- function(text) {
    local out = ""
    for (local i = 0; i < text.len(); i++) {
        local c = text.slice(i, i + 1)
        if (c == "\\") { out += "\\\\" }
        else if (c == "\"") { out += "\\\"" }
        else { out += c }
    }
    return "\"" + out + "\""
}

::EUR.serialiseValue <- function(value, indent) {
    local kind = typeof(value)
    if (kind == "string") { return ::EUR.serialiseString(value) }
    if (kind == "integer" || kind == "float") { return "" + value }
    if (kind == "bool") { return value ? "true" : "false" }
    if (kind == "null") { return "null" }

    local pad = ""
    for (local i = 0; i <= indent; i++) { pad += "    " }
    local padEnd = ""
    for (local i = 0; i < indent; i++) { padEnd += "    " }

    if (kind == "array") {
        if (value.len() == 0) { return "[]" }
        local out = "[\n"
        foreach (v in value) { out += pad + ::EUR.serialiseValue(v, indent + 1) + ",\n" }
        return out + padEnd + "]"
    }
    if (kind == "table") {
        local keys = []
        foreach (k, v in value) { keys.append(k) }
        if (keys.len() == 0) { return "{}" }
        local out = "{\n"
        foreach (k in keys) {
            out += pad + "[" + ::EUR.serialiseValue(k, indent + 1) + "] = "
                 + ::EUR.serialiseValue(value[k], indent + 1) + ",\n"
        }
        return out + padEnd + "}"
    }
    return "null"
}

// The whole file is built in memory BEFORE anything is opened, so a serialiser throw leaves the
// existing data file untouched rather than truncated. A truncated one would fail to compile, and a
// module that fails to compile takes every symbol in it with it.
::EUR.writeDataFile <- function(relativePath, globalName, value) {
    local body = null
    try {
        body = "::EUR." + globalName + " <- " + ::EUR.serialiseValue(value, 0) + "\n"
    }
    catch (e) {
        println("eur: refusing to write " + relativePath + " - serialise failed: " + e)
        return false
    }

    local io = require("io")
    try {
        local out = io.file(::game.modPath() + "\\script\\" + relativePath, "wb")
        out.writestring(body)
        out.close()
    }
    catch (e) {
        println("eur: could not write " + relativePath + " - " + e)
        return false
    }
    return true
}

::EUR.generalWriteDefault <- function() {
    local target = ::EUR.game_options.BG_T2
        ? { path = "eur\\upgrades\\eurGeneralBGSwapList2.nut", name = "gen_units_list_default2" }
        : { path = "eur\\upgrades\\eurGeneralBGSwapList.nut",  name = "gen_units_list_default" }
    return ::EUR.writeDataFile(target.path, target.name, ::EUR.gen_units_list)
}

::EUR.unitWriteDefault <- function() {
    return ::EUR.writeDataFile("eur\\upgrades\\eurUnitUpgradeList.nut", "UNIT_UPGRADES_default", ::EUR.UNIT_UPGRADES)
}
