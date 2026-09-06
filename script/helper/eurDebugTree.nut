// DIAGNOSTIC - delete this file and its main.nut entry when the render questions are answered.
//
// 1. A gate HUD, top right, always on top: one line per WINDOW showing whether it should be on
//    screen and every bool that decides it.
// 2. ctrl+D dumps the whole visible widget tree to eur_tree_dump.txt (println only reaches the
//    in-game console, and ::game.log is campaign-gated so it throws in the menu).

::EUR.debugOut <- ""
::EUR.debugFrame <- 0
::EUR.debugDumpDone <- false

::EUR.debugSay <- function(line) {
    ::EUR.debugOut += line + "\n"
    println(line)
}

// Each row is one window. parts() returns [label, value] for every bool the window gates on;
// the window is showing when all of them are true. Mirrors the expressions in each render().
::EUR.DEBUG_GATES <- [
    { name = "options", parts = function() { return [
        ["show_options_window", ::EUR.show_options_window],
        ["in_campaign_map", ::EUR.in_campaign_map]] },
      force = function() { ::EUR.show_options_window = true } },

    { name = "options accept", parts = function() { return [
        ["show_options_accept", ::EUR.show_options_accept],
        ["in_campaign_map", ::EUR.in_campaign_map]] },
      force = function() { ::EUR.show_options_accept = true } },

    { name = "unit upgrades", parts = function() { return [
        ["show_upgrade_window", ::EUR.window_states.show_upgrade_window],
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["!diplo_open", !::EUR.diplo_open]] },
      force = function() { ::EUR.window_states.show_upgrade_window = true } },

    { name = "upgrade accept", parts = function() { return [
        ["show_ug_accept", ::EUR.show_ug_accept],
        ["in_campaign_map", ::EUR.in_campaign_map]] },
      force = function() { ::EUR.show_ug_accept = true } },

    { name = "bg swap", parts = function() { return [
        ["swap_bg_window", ::EUR.window_states.swap_bg_window],
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["!show_bg_accept", !::EUR.show_bg_accept]] },
      force = function() { ::EUR.window_states.swap_bg_window = true; ::EUR.show_bg_accept = false } },

    { name = "bg accept", parts = function() { return [
        ["show_bg_accept", ::EUR.show_bg_accept],
        ["in_campaign_map", ::EUR.in_campaign_map]] },
      force = function() { ::EUR.show_bg_accept = true } },

    { name = "global recruit", parts = function() { return [
        ["show_globalrecruit_window", ::EUR.window_states.show_globalrecruit_window],
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["global_recruitment", ::EUR.game_options.global_recruitment]] },
      force = function() { ::EUR.window_states.show_globalrecruit_window = true; ::EUR.game_options.global_recruitment = true } },

    { name = "revive choice", parts = function() { return [
        ["show_revive_choice", ::EUR.show_revive_choice],
        ["in_campaign_map", ::EUR.in_campaign_map]] },
      force = function() { ::EUR.show_revive_choice = true } },

    { name = "eregion choice", parts = function() { return [
        ["show_eregion_choice", ::EUR.show_eregion_choice],
        ["in_campaign_map", ::EUR.in_campaign_map]] },
      force = function() { ::EUR.show_eregion_choice = true } },

    { name = "kon choice", parts = function() { return [
        ["show_kon_choice", ::EUR.show_kon_choice],
        ["in_campaign_map", ::EUR.in_campaign_map]] },
      force = function() { ::EUR.show_kon_choice = true } },

    { name = "dev window", parts = function() { return [
        ["chris_stuff", ::EUR.chris_stuff],
        ["extra_window", ::EUR.extra_window]] },
      force = function() { ::EUR.chris_stuff = true; ::EUR.extra_window = true } },

    // The opener buttons. Each is its own always-on canvas with its own gate - they are what OPEN
    // the windows above, so if none of these is showing nothing else can be reached.
    { name = "BTN options", parts = function() { return [
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["show_options_button", ::EUR.show_options_button],
        ["icon_options", ::EUR.icon_options != null && ::EUR.icon_options.img != 0]] },
      force = function() { ::EUR.show_options_button = true } },

    { name = "BTN recruit", parts = function() { return [
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["show_settUI", ::EUR.show_settUI],
        ["icon_unit", ::EUR.icon_unit != null && ::EUR.icon_unit.img != 0]] },
      force = function() { ::EUR.show_settUI = true } },

    { name = "BTN revive", parts = function() { return [
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["settScrollOpen", ::ui.settlementScroll() != null]] } },

    { name = "BTN bg card", parts = function() { return [
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["swap_bg_button", ::EUR.swap_bg_button],
        ["sel_unit", ::EUR.sel_unit != null]] },
      force = function() { ::EUR.swap_bg_button = true } },

    { name = "BTN buildfort", parts = function() { return [
        ["in_campaign_map", ::EUR.in_campaign_map],
        ["show_buildfort", ::EUR.show_buildfort],
        ["build_forts", ::EUR.build_forts]] },
      force = function() { ::EUR.show_buildfort = true; ::EUR.build_forts = true } },
]

// One symbol per module. A module that fails to load registers NOTHING, so a missing symbol names
// the module that died - which the loader only reports to the console.
::EUR.DEBUG_MODULES <- [
    ["eurHelpers", "round_half"], ["eurVars", "game_options"], ["eurVarsTemp", "window_states"],
    ["eurStyles", "eurStyles"], ["eurGlobalVars", "eurGlobalVars"], ["eurScroll", "scroll"],
    ["eurSaveLoadOptions", "saveOptions"], ["eurSaveLoadValues", "eurSaveLoadValues"],
    ["eurImgLoad", "loadImages"], ["eurCasLoad", "setCasStandalone"], ["eurSoundLoad", "loadSounds"],
    ["eurFontLoad", "loadFonts"], ["eurOptions", "EUR_OPTION_TABS"], ["eurUnitUpgrades", "unitUpgrades"],
    ["eurGeneralBGSwap", "generalBGSwap"], ["eurGlobalRecruitment", "eurGlobalRecruitment"],
    ["eurReviveFactions", "eurReviveUI"], ["eurEregion", "eurEregion"],
    ["eurPlayerUnitsCut", "player_units_cut"], ["eurUnitUpgradeList", "UNIT_UPGRADES_default"],
    ["eurGeneralBGSwapList", "gen_units_list_default"], ["eurEventsFunc", "eurSpawnArmy"],
    ["eurGarrisons", "clampGarrisonArmy"], ["eurMapHelpers", "strat_cas_standalone"],
]

class eurDebugHud {
    window = 0
    rows = null
    modules = 0
    placedW = 0

    function ensure() {
        if (this.window != 0) return

        this.window = ::UI.window("EUR window gates", 460, 320, 0, 0,
                                  [::UI.WindowFlag.resizableEdges, ::UI.WindowFlag.alwaysScrollBarY])

        ::UI.setWidgetStyle(this.window, ::UI.Colour.text, [235, 235, 235, 255])
        ::UI.setWidgetStyle(this.window, ::UI.Surface.window, [0, 0, 0, 140])
        ::UI.setWidgetStyle(this.window, ::UI.Colour.border, [255, 255, 255, 60])

        // each row IS the force button: clicking it sets that window's own gates to what they need
        // to be. in_campaign_map and diplo_open are engine state and are never forced.
        this.rows = []
        foreach (gate in ::EUR.DEBUG_GATES) {
            local g = gate
            local row = ::UI.button(g.name, 0, 26)
            ::UI.setWidgetStyle(row, ::UI.Colour.text, [235, 235, 235, 255])
            ::UI.setWidgetStyle(row, ::UI.Surface.button, [255, 255, 255, 20])
            if ("force" in g && g.force != null) {
                ::UI.buttonClick(row, function() { g.force() })
            }
            this.rows.append(row)
        }

        this.modules = ::UI.bullet("")
        ::UI.setWidgetStyle(this.modules, ::UI.Colour.text, [255, 160, 160, 255])

        ::UI.setParent(0)
    }

    function render() {
        this.ensure()

        local screen = ::UI.screenSize()
        if (screen[0] != this.placedW) {
            this.placedW = screen[0]
            ::UI.widgetRect(this.window, screen[0] - 470, 10, 460, 320)
        }
        ::UI.raise(this.window)

        foreach (i, gate in ::EUR.DEBUG_GATES) {
            local parts = gate.parts()
            local showing = true
            local detail = ""
            foreach (p in parts) {
                if (!p[1]) { showing = false }
                detail += (detail == "" ? "" : "  ") + p[0] + "=" + (p[1] ? "1" : "0")
            }
            ::UI.textSet(this.rows[i], (showing ? "SHOWING  " : "hidden   ") + gate.name + "   " + detail)
        }

        local dead = ""
        foreach (m in ::EUR.DEBUG_MODULES) {
            if (!(m[1] in ::EUR)) { dead += (dead == "" ? "" : ", ") + m[0] }
        }
        local why = ""
        if ("moduleErrors" in ::EUR && ::EUR.moduleErrors.len() > 0) { why = "   " + ::EUR.moduleErrors[0] }
        ::UI.textSet(this.modules, dead == "" ? "all modules loaded" : "MODULES FAILED: " + dead + why)
    }
}

::EUR.eurDebugHud <- eurDebugHud()

::EUR.debugDumpTree <- function() {
    ::EUR.debugOut = ""
    ::EUR.debugSay("=== EUR TREE DUMP ===")
    ::EUR.debugSay("in_campaign_map=" + ::EUR.in_campaign_map
        + " show_options_window=" + ::EUR.show_options_window
        + " show_options_accept=" + ::EUR.show_options_accept
        + " show_options_button=" + ::EUR.show_options_button
        + " options_first_run=" + ::EUR.options_first_run)

    if ("eurOptionsHandles" in ::EUR) { ::EUR.debugSay("our handles: " + ::EUR.eurOptionsHandles) }
    else { ::EUR.debugSay("our handles: ABSENT - eurOptions.ensure() did not finish") }

    local dead = ""
    foreach (m in ::EUR.DEBUG_MODULES) {
        if (!(m[1] in ::EUR)) { dead += (dead == "" ? "" : ", ") + m[0] }
    }
    ::EUR.debugSay(dead == "" ? "modules: all loaded" : "MODULES FAILED: " + dead)

    if ("moduleErrors" in ::EUR) {
        foreach (line in ::EUR.moduleErrors) { ::EUR.debugSay("  LOAD ERROR " + line) }
    }

    local tree = ::UI.widgetTree(0)
    if (tree == null) { ::EUR.debugSay("widgetTree returned null"); return }
    ::EUR.debugSay("rows=" + tree.len())

    foreach (r in tree) {
        if (!r.visible) { continue }
        if (r.w <= 0 || r.h <= 0) { continue }
        local pad = ""
        for (local i = 0; i < r.depth; i++) { pad += "  " }
        ::EUR.debugSay("  " + r.path + " " + pad + r.label
            + " [" + r.type + "] handle=" + r.handle
            + " rect=" + r.x + "," + r.y + " " + r.w + "x" + r.h
            + (r.absolute ? " ABS" : ""))
    }
    ::EUR.debugSay("=== END TREE DUMP ===")

    local io = require("io")
    try {
        local out = io.file("eur_tree_dump.txt", "wb")
        out.writestring(::EUR.debugOut)
        out.close()
    } catch (e) { println("tree dump write failed: " + e) }
}

::UI.onFrame(function() {
    ::EUR.eurDebugHud.render()

    ::EUR.debugFrame++
    if (!::EUR.debugDumpDone && ::EUR.debugFrame == 120) {
        ::EUR.debugDumpDone = true
        ::EUR.debugDumpTree()
    }
    if (::UI.keyboard.chord(::UI.Mod.ctrl | ::UI.Key.d)) { ::EUR.debugDumpTree() }
})
