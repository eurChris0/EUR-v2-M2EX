::EUR.diff_readout_section <- {
    draw = function() {
        if (!::EUR.in_campaign_map) return
        if (!("canvas" in ::EUR.diff_readout_section)) return
        local rect = ::UI.widgetRectGet(::EUR.diff_readout_section.canvas)
        if (rect == null) return

        local camp = ::EUR.options_legendary ? 4 : ::EUR.game_options.campaigndiff
        if (!(camp in ::EUR.campaign_diff_text)) { camp = 10 }
        local batt = ::EUR.game_options.battlediff
        if (!(batt in ::EUR.battlediff_text)) { batt = 10 }

        ::UI.pushStyle({ [::UI.Colour.text] = [0, 0, 0, 255] })
        ::UI.layoutAt(rect[0], rect[1])
        ::UI.text("Campaign Difficulty: " + ::EUR.campaign_diff_text[camp])
        ::UI.layoutAt(rect[0], rect[1] + 18)
        ::UI.text("Battle Difficulty: " + ::EUR.battlediff_text[batt])
        ::UI.popStyle()
    },
    h = 44,
}

// Difficulty tab.
::EUR.EUR_OPTION_TABS.append({
    title = "Difficulty",
    sections = [
        [
            ::EUR.diff_readout_section,
            { label = "Extra Difficulty", tip = "Legendary difficulty settings." },
            { check = "Enabled", bind = ["options_legendary"], tip = "Enable Extra Difficulty Options.",
              onChange = function(v) { ::EUR.legendaryToggle(v) } },
            { check = "Hardcore mode", bind = ["options_hardcore"], tip = "Disables auto resolve.",
              onChange = function(v) { ::EUR.eur_campaign.restrictAutoResolve = v ? 1 : 0 } },
        ],
        [
            { sep = true },
            { expand = "Advanced", tip = "Difficulty Miscellaneous.", body = [
                { check = "Add generals to large AI armies", bind = ["options_general_large_army"], tip = "Medium to large AI armies will have a general unit in most cases." },
                { check = "No free upkeep for T2 units", bind = ["options_no_free_upkeep"], tip = "Disables free upkeep for all units T2 and above unless garrisoned in a fort." },
                { check = "Buffed AI generals", bind = ["game_options", "options_aiboost"], tip = "Provides a buff to AI generals' starting stats, buffing troop morale and general hitpoints." },
                { check = "20% public order penalty", bind = ["game_options", "order_offset"], tip = "Public order penalty for the player." },
                { check = "Global morale increase (not recommended)", bind = ["game_options", "global_morale_boost"], tip = "A flat global morale increase; breaks intended game balance (+2 default).",
                  onChange = function(v) { if (v && !::EUR.options_first_run) ::EUR.globalMoraleIncrease(::EUR.game_options.morale_value) } },
                { slider = "Morale bonus amount", bind = ["game_options", "morale_value"], min = 1, max = 4, fmt = "%d", tip = "Morale bonus amount." },
            ] },
        ],
        [
            { sep = true },
            { label = "Extra difficulty modifiers (player only)" },
            { slider = "Recruit & Upkeep", bind = ["EDUOFFET_VARS_LEG", "offset1"], min = -100, max = 500, fmt = "%d%%", tip = "Flat recruitment and upkeep cost modifier." },
            { slider = "Pool offset (recruitment speed)", bind = ["EDUOFFET_VARS_LEG", "pooloffset1"], min = -90, max = 300, fmt = "%d%%", tip = "Turns for a new recruit to become available; negative faster, positive slower." },
            { slider = "Building time increase (turns)", bind = ["EDUOFFET_VARS_LEG", "bu_time"], min = 0, max = 4, fmt = "%d", tip = "Increase building time." },
            { slider = "Building cost increase", bind = ["EDUOFFET_VARS_LEG", "bu_cost"], min = 0, max = 200, fmt = "%d%%", tip = "Increase building cost." },
        ],
    ],
})
