local function applyPreset(rtm, off, pool) {
    ::EUR.EDUOFFET_VARS.threshold = 500
    ::EUR.EDUOFFET_VARS.extragold = 0
    ::EUR.EDUOFFET_VARS.extragold2 = 0
    ::EUR.EDUOFFET_VARS.recruitTimeMult = rtm
    ::EUR.EDUOFFET_VARS.offset1 = off
    ::EUR.EDUOFFET_VARS.offset2 = off
    ::EUR.EDUOFFET_VARS.pooloffset1 = pool
    ::EUR.EDUOFFET_VARS.pooloffset2 = pool
    ::EUR.EDUOFFET_VARS.bu_time = 0
    ::EUR.EDUOFFET_VARS.bu_cost = 0
    ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
}

local function isNoldor() {
    return ::EUR.eur_player_faction != null && (::EUR.eur_player_faction.name == "saxons" || ::EUR.eur_player_faction.name == "denmark")
}

::EUR.EUR_OPTION_TABS.append({
    title = "Campaign Extra",
    sections = [
        [
            { label = "Recruitment Speed", tip = "Enable modifiers only for the player." },
            { check = "Enabled", bind = ["game_options", "options_usemods"], tip = "Enable speed options." },
            { check = "Player only", bind = ["game_options", "playeronlymods"], tip = "Enable modifiers only for the player." },
            { label = "Presets:" },
            { button = "Normal", onClick = function() { applyPreset(1,   0,   0)   } },
            { button = "0.5x",   onClick = function() { applyPreset(0.5, -50, -50) } },
            { button = "1.5x",   onClick = function() { applyPreset(1.5, 50,  50)  } },
            { button = "2.0x",   onClick = function() { applyPreset(2,   100, 100) } },
            { button = "3.0x",   onClick = function() { applyPreset(3,   200, 200) } },
            { slider = "Recruit & Upkeep", bind = ["EDUOFFET_VARS", "offset1"], min = -100, max = 500, fmt = "%d%%", tip = "Flat recruitment and upkeep cost modifier." },
            { slider = "Pool offset (recruitment speed)", bind = ["EDUOFFET_VARS", "pooloffset1"], min = -50, max = 300, fmt = "%d%%", tip = "Turns for a new recruit to become available; negative faster, positive slower." },
            { slider = "Building time increase (turns)", bind = ["EDUOFFET_VARS", "bu_time"], min = 0, max = 4, fmt = "%d", tip = "Increase building time." },
            { slider = "Building cost increase", bind = ["EDUOFFET_VARS", "bu_cost"], min = 0, max = 200, fmt = "%d%%", tip = "Increase building cost." },
        ],
        [
            { sep = true },
            { label = "Campaign Start (Noldor factions)", showFn = isNoldor },
            { check = "Start as the Kingdom of Eregion", bind = ["misc_options", "eregion_start"], showFn = isNoldor,
              tip = "Start as Eregion over the first end turn.",
              onChange = function(v) { if (v) { ::EUR.misc_options.kon_start = false; ::EUR.misc_options.kon_start_ai_eregion = false } } },
            { check = "Start as the Kingdom of the Noldor", bind = ["misc_options", "kon_start"], showFn = isNoldor,
              tip = "Confederate with Lindon / Imladris over the first end turn.",
              onChange = function(v) { if (v) ::EUR.misc_options.eregion_start = false } },
            { check = "Spawn Eregion AI", bind = ["misc_options", "kon_start_ai_eregion"],
              tip = "Spawn the Eregion AI faction (turn 60-80).",
              showFn = function() { return isNoldor() && ::EUR.misc_options.kon_start } },
        ],
        [
            { sep = true },
            { label = "Player gold" },
            { slider = "Starting Gold", min = 1000, max = 500000, fmt = "%d Gold", tip = "Set the starting level of gold.",
              get = function() { return ::EUR.eur_player_faction != null ? ::EUR.eur_player_faction.money : 0 },
              set = function(v) { if (::EUR.eur_player_faction != null) ::EUR.eur_player_faction.money = v } },
            { slider = "King's Purse", min = 500, max = 50000, fmt = "%d Gold", tip = "Gold earned each turn throughout the campaign.",
              get = function() { return ::EUR.eur_player_faction != null ? ::EUR.eur_player_faction.kingsPurse : 0 },
              set = function(v) { if (::EUR.eur_player_faction != null) ::EUR.eur_player_faction.kingsPurse = v } },
        ],
    ],
})
