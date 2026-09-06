::EUR.gen_adv_section <- { draw = function() { ::EUR.eurOptionsGeneralADV.draw() }, w = 470, h = 460 }
::EUR.gen_adv_preview <- { draw = function() { ::EUR.eurOptionsGeneralADV.drawPreview() }, w = 230, h = 110 }

::EUR.EUR_OPTION_TABS.append({
    title = "Upgrades",
    sections = [
        [
            { label = "General Upgrades" },
            { check = "Enabled", bind = ["options_gen_upgrades"], tip = "Enable general upgrades." },
            { check = "Start with T2", bind = ["game_options", "BG_T2"], tip = "Enables the first level of bodyguard units to be T2 rather than T1 level.",
              onChange = function(v) { ::EUR.rebuildUpgradeLists() } },
            { check = "Show Unit Card", bind = ["show_gen_unit_card"], tip = "Display the bodyguard unit card rather than a generic icon in the UI." },
            { slider = "Advanced Rank", bind = ["bg_t2_rank"], min = 0, max = 20, fmt = "%d", tip = "Set the rank for T2 units to be unlocked." },
            { slider = "Elite Rank", bind = ["bg_t3_rank"], min = 0, max = 20, fmt = "%d", tip = "Set the rank for T3 units to be unlocked." },
            { stepper = "Cooldown (turns)", bind = ["bg_swap_cooldown"], min = 5, max = 30, step = 5, tip = "Cooldown between bodyguard changes." },
            { check = "Dynamic Bodyguard Size", bind = ["options_gen_bg_size"], tip = "Variable bodyguard size, calculated from the general's command stars.",
              onChange = function(v) {
                  for (local i = 0; i < ::EUR.mod_general_units_list.len(); i++) {
                      local eduEntry = ::units.get(::EUR.mod_general_units_list[i].name)
                      if (eduEntry == null) continue
                      if (!v) {
                          if (eduEntry.soldierCount == ::EUR.mod_general_units_list[i].size && (eduEntry.name in ::EUR.original_general_units_list) && ::EUR.original_general_units_list[eduEntry.name]) {
                              eduEntry.soldierCount = ::EUR.original_general_units_list[eduEntry.name]
                          }
                      } else {
                          if (!(eduEntry.name in ::EUR.original_general_units_list) || !::EUR.original_general_units_list[eduEntry.name]) { ::EUR.original_general_units_list[eduEntry.name] <- eduEntry.soldierCount }
                          eduEntry.soldierCount = ::EUR.mod_general_units_list[i].size
                      }
                  }
              } },
            { slider = "Minimum bodyguard size", bind = ["bg_min_size_multi"], min = 25, max = 75, fmt = "%d%%" },
            { sep = true },
            { expand = "Advanced Options", body = [
                { button = "Load defaults", tip = "Restore the bodyguard roster shipped with the mod.",
                  onClick = function() { ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN"); ::EUR.loadFactoryBodyguards() } },
                { button = "Save in files", sameLine = true, tip = "Write the current roster over the mod's own data file. Permanent, and a mod update overwrites it.",
                  onClick = function() { ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN"); ::EUR.generalWriteDefault() } },
                { group = [ ::EUR.gen_adv_section ] },
                { sameLine = true, w = 300, group = [
                    ::EUR.gen_adv_preview,
                    ::EUR.gen_adv_picker,
                    { button = "Swap", tip = "Replace the selected bodyguard slot with the chosen unit.",
                      onClick = function() { ::EUR.eurOptionsGeneralADV.swap() } },
                ] },
            ] },
        ],
        [
            { sep = true },
            { label = "Unit Upgrades" },
            { check = "Enabled", bind = ["options_unit_upgrades"], tip = "Enable unit upgrades." },
            { check = "Display upgrade mini icon", bind = ["game_options", "display_upg"], tip = "Show an icon on the unit card when upgrades are available." },
            { check = "Display sidegrade mini icon", bind = ["game_options", "display_sdg"], tip = "Show an icon on the unit card when upgrades of the same tier are available." },
            { stepper = "Experience requirement reduction", bind = ["unit_upgrades_multi"], min = 0, max = 2, step = 1, tip = "Reduce the experience requirement for unit upgrades, player only." },
            { check = "Restrict upgrades", bind = ["restricted_upgrades"], tip = "Only allow upgrades if the upgrade option is available to recruit somewhere within the realm.",
              onChange = function(v) { ::EUR.unitUpgrades.list_edu_recruitable() } },
            { check = "AI Upgrades", bind = ["ai_unit_upgrades"], tip = "Enable unit upgrades for the AI." },
            { sep = true },
            { expand = "Advanced Options", body = [
                { button = "Load defaults", tip = "Restore the upgrade table shipped with the mod.",
                  onClick = function() { ::EUR.eurOptionsUnitADV.loadFactory() } },
                { button = "Save in files", sameLine = true, tip = "Write the current upgrade table over the mod's own data file. Permanent, and a mod update overwrites it.",
                  onClick = function() { ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN"); ::EUR.unitWriteDefault() } },
                { button = "Add unit", tip = "Start a new upgrade entry. Press again once the pane on the right is filled in to add it to the table.",
                  onClick = function() { ::EUR.eurOptionsUnitADV.startOrAddUnit() } },
                { group = [ ::EUR.unit_adv_section ] },

                // The two right panes are mutually exclusive - Add unit raises the first, a card on
                // the left raises the second, and until one of those happens the column is empty.
                { sameLine = true, w = 240, showFn = function() { return ::EUR.unit_adv_mode == "new" }, group = [
                    ::EUR.unit_new_heading,
                    ::EUR.unit_new_base_picker,
                    ::EUR.unit_new_base_card,
                    ::EUR.unit_new_target_picker,
                    ::EUR.unit_new_target_card,
                    ::EUR.unit_new_exp_slider,
                    ::EUR.unit_new_cost_slider,
                    { button = "Add", tip = "Write this entry into the upgrade table. Same as pressing Add unit again on the left.",
                      onClick = function() { ::EUR.eurOptionsUnitADV.addNew() } },
                ] },
                { sameLine = true, w = 320,
                  showFn = function() { return ::EUR.unit_adv_mode == "edit" && ::EUR.unit_adv_edu != "" }, group = [
                    ::EUR.unit_adv_title,
                    { button = "New entry", tip = "Add another upgrade slot to the selected unit, up to four.",
                      onClick = function() { ::EUR.eurOptionsUnitADV.newUpgrade() } },
                    ::EUR.unit_adv_edit,
                    ::EUR.unit_adv_picker,
                    { button = "Change", tip = "Point the selected upgrade slot at the unit chosen in the dropdown.",
                      onClick = function() { ::EUR.eurOptionsUnitADV.replaceEntry() } },
                    { button = "Delete", sameLine = true, tip = "Remove the selected upgrade slot. Removing the last one drops the whole entry.",
                      onClick = function() { ::EUR.eurOptionsUnitADV.deleteUpgrade() } },
                    ::EUR.unit_adv_exp,
                    ::EUR.unit_adv_cost,
                ] },
            ] },
        ],
    ],
})

::EUR.buildPlayerUnits <- function() {
    local mp = ::game.modPath()
    ::EUR.player_units = []
    ::EUR.player_units_local = []
    local seen = {}
    for (local i = 0; i < 1500; i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry == null) continue
        local dir1 = eduEntry.cardImage
        if (dir1 in seen) continue
        if (!::EUR.file_exists(mp + "\\data\\ui\\units\\mercs\\" + dir1)) continue
        seen[dir1] <- true
        if (!::EUR.tableContains(::EUR.player_units, eduEntry.name)
            && eduEntry.name.indexof("Garrison") == null
            && eduEntry.category != ::Enum.UnitCategory.siege && eduEntry.category != ::Enum.UnitCategory.ship
            && eduEntry.hasOwnership(::EUR.eur_playerFactionId)
            && (!(::EUR.eur_player_faction.name in ::EUR.player_units_cut)
                || !::EUR.tableContains(::EUR.player_units_cut[::EUR.eur_player_faction.name], eduEntry.name))) {
            ::EUR.player_units.append(eduEntry.name)
            ::EUR.player_units_local.append(eduEntry.displayName)
        }
    }
    if (::EUR.player_units.len() > 0) { ::EUR.sortPlayerUnitsAlphabetically(::EUR.player_units_local, ::EUR.player_units) }
}
