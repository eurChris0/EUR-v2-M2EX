if (::EUR.EUR_EVENT_TRIGGERS.ui) {

    ::events.on("ButtonPressed", function(eventData) {
        ::EUR.logHelper("onButtonPressed")
        // local buttons = {
        //     decrease_taxation_gadget = true,
        //     increase_taxation_gadget = true,
        //     advanced_settlement_info_scroll = true,
        //     garrison_info_zoom_to_button = true,
        //     settlement_stats_button = true,
        //     advanced_stats_show_trade_button = true,
        //     settlement_info_construction_tab = true,
        // }
        if (eventData.resourceDescription == "mission_button") {
            if (::EUR.eur_player_faction.name == "saxons" || ::EUR.eur_player_faction.name == "denmark" || ::EUR.eur_player_faction.name == "egypt") {
                ::EUR.eurEregion.eregionStoryText()
            }
        }
        if (eventData.resourceDescription == "settlement_info_construction_tab") {
            // ::EUR.show_settUI = true
            ::EUR.show_replen_ui = false
            ::EUR.hud_show_units_tab_pressed = false
        }
        if (eventData.resourceDescription == "settlement_info_retrain_tab") {
            ::EUR.show_replen_ui = true
            ::EUR.hud_show_units_tab_pressed = true
        }
        if (eventData.resourceDescription == "settlement_info_recruitment_tab") {
            ::EUR.show_replen_ui = true
            ::EUR.hud_show_units_tab_pressed = true
        }
        if (eventData.resourceDescription == "settlement_info_repair_tab") {
            ::EUR.show_replen_ui = false
            ::EUR.hud_show_units_tab_pressed = false
        }
        if (eventData.resourceDescription == "hud_show_units_tab") {
            ::EUR.show_replen_ui = true
            ::EUR.hud_show_units_tab_pressed = true
        }
        if (eventData.resourceDescription == "hud_show_buildings_tab") {
            ::EUR.show_replen_ui = false
            ::EUR.hud_show_units_tab_pressed = false
        }
        if (eventData.resourceDescription == "hud_show_agents_tab") {
            ::EUR.hud_show_units_tab_pressed = false
            ::EUR.show_replen_ui = false
        }
        // if (!(eventData.resourceDescription in buttons)) {
        //     ::EUR.show_settUI = false
        // }
        if (::EUR.in_campaign_map) {
            if (::EUR.game_options.global_recruitment) {
                ::EUR.eurGlobalRecruitment.recruitCheckGlobal()
            }
        }
    })

    ::events.on("ScrollOpened", function(eventData) {
        ::EUR.logHelper("onScrollOpened")
        ::EUR.show_events_window = false
        if (eventData.resourceDescription == "unit_info_scroll") {
            ::EUR.show_unitscroll_tooltip = true
        }
        if (eventData.resourceDescription == "end_game_scroll") {
            ::EUR.show_options_button = true
        }
        if (eventData.resourceDescription == "prebattle_scroll") {
            ::EUR.eur_pre_battle = true
        }
        if (eventData.resourceDescription == "own_settlement_info_scroll") {
            ::EUR.show_temp_char_stuff = true
            ::EUR.swap_bg_button = true
        }
        if (eventData.resourceDescription == "post_battle_scroll") {
        }
        if (eventData.resourceDescription == "field_construction_scroll") {
            ::EUR.show_buildfort = true
        }
        // PANEL SLOT HACK - stands in for real UI_REQUEST_MANAGER integration, commented out
        // pending the engine binding. Restore only if that wiring is abandoned.
        // if (eventData.resourceDescription == "hud_show_agents_tab") {
        //     ::EUR.window_states.swap_bg_window = false
        // }
        // if (::EUR.tableContains(::EUR.left_panels, eventData.resourceDescription)) {
        //     ::EUR.window_states.swap_bg_window = false
        //     ::EUR.window_states.show_upgrade_window = false
        //     ::EUR.alias_text = ""
        //     ::EUR.alias_text_set = false
        //     ::EUR.window_states.show_globalrecruit_window = false
        // }
    })

    ::events.on("ScrollClosed", function(eventData) {
        ::EUR.logHelper("onScrollClosed")
        if (eventData.resourceDescription == "unit_info_scroll") {
            ::EUR.show_unitscroll_tooltip = false
        }
        if (eventData.resourceDescription == "end_game_scroll") {
            ::EUR.show_options_button = false
            // ::EUR.show_options_window = false
        }
        if (eventData.resourceDescription == "prebattle_scroll") {
            ::EUR.eur_pre_battle = false
            ::EUR.eur_pre_battle_window = false
        }
        if (eventData.resourceDescription == "own_settlement_info_scroll") {
            ::EUR.temp_char_stuff = null
            ::EUR.show_temp_char_stuff = false
            ::EUR.swap_bg_button = false
            ::EUR.window_states.show_globalrecruit_window = false
            // ::EUR.window_states.swap_bg_window = false
            // ::EUR.window_states.show_globalrecruit_window = false
        }
        if (eventData.resourceDescription == "diplomacy_scroll") {
            ::EUR.diplo_open = false
        }
        if (eventData.resourceDescription == "post_battle_scroll") {
            ::EUR.show_alt_loot = false
        }
        if (eventData.resourceDescription == "field_construction_scroll") {
            ::EUR.show_buildfort = false
        }
        // if (eventData.resourceDescription == "own_settlement_info_scroll") {
        //     ::EUR.show_settUI = false
        // }
    })

    ::events.on("PreBattlePanelOpen", function(eventData) {
        ::EUR.logHelper("onPreBattlePanelOpen")
        ::EUR.eurAddSpoils.getBattlePreInfo()
        ::EUR.in_campaign_map = false
        ::EUR.saved_already_pre = false
    })

    ::events.on("DiplomacyPanelOpen", function(eventData) {
        ::EUR.diplo_open = true
    })

    ::events.on("UIElementVisible", function(eventData) {
    })

}

::UI.keyboard.shortcut("quit", function(shortcutName) {
    if (!::EUR.in_campaign_map) { return false }

    if (::EUR.show_options_accept || ::EUR.show_ug_accept || ::EUR.show_bg_accept) {
        if (::EUR.show_options_accept) {
            ::EUR.show_options_accept = false
            ::EUR.show_options_window = true
        }
        if (::EUR.show_ug_accept) {
            ::EUR.show_ug_accept = false
            ::EUR.window_states.show_upgrade_window = true
        }
        if (::EUR.show_bg_accept) {
            ::EUR.show_bg_accept = false
            ::EUR.window_states.swap_bg_window = true
        }
        return true
    }

    if (::EUR.options_first_run) { return false }

    local closed = false
    if (::EUR.show_options_window) {
        ::EUR.show_options_window = false
        ::EUR.saveOptions()
        closed = true
    }
    foreach (key, open in ::EUR.window_states) {
        if (open) {
            ::EUR.window_states[key] = false
            closed = true
        }
    }
    return closed
})

::UI.onFrame(function() {
    if (!::EUR.in_campaign_map) { return }

    if (::UI.keyboard.chord(::UI.Mod.ctrl | ::UI.Key.x) && !::EUR.options_first_run) {
        ::EUR.show_options_window = !::EUR.show_options_window
    }
})
