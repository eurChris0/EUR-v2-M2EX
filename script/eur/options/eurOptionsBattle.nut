// Battle tab.
::EUR.EUR_OPTION_TABS.append({
    title = "Battle",
    sections = [[
        { label = "Battle" },
        { check = "Change general position", bind = ["game_options", "genposition"], tip = "Place the general in the centre of the unit." },   // changeGeneralPosition removed — not a feature
        { check = "Disable skirmish", bind = ["game_options", "disable_skirmish"], tip = "Disable skirmish mode for the player's units." },
        { check = "Enhanced speed controls", bind = ["game_options", "show_speed_ui"], tip = "Enables the advanced speed battle UI widget, speeds from 0.5x to 12x in multiples of +/- 1 and 3 (or 0.1 and 0.5 if holding shift)." },
        { sep = true },
        { desc = "Highlight all units - CTRL + Q" },
        { desc = "Zoom out - X" },
        { desc = "Zoom in - Z" },
    ]],
})
