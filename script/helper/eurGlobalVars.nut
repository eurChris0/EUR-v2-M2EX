// Gondor Glory track is not in use: gloryShip/Kings/Stew and their glory_table were
// lost when eurEventsFunc was truncated at Lua line 1358, and nothing sets the _active flags.
::EUR.eurGlobalVars <- function() {
    ::EUR.eur_campaign_options <- ::game.options
    ::EUR.eur_campaign <- ::game.campaign()
    ::EUR.eur_sMap <- ::stratMap
    ::EUR.eur_numberOfFactions <- ::game.factionCount()

    if (::EUR.eregion_maernil_choice) {
        // unlockGameConsoleCommands removed — console always available
        ::EUR.eur_player_faction <- ::EUR.eur_campaign.factionByName("egypt")
    } else {
        ::EUR.eur_player_faction <- ::game.localFaction()
    }

    ::EUR.eur_playerFactionId <- ::game.localFactionId()

    if (::EUR.eur_player_faction != null) {

        if (::EUR.eur_player_faction.name == "denmark" || ::EUR.eur_player_faction.name == "saxons") {
            if (::EUR.checkCounter("kon_council_choice_accepted")) {
                ::EUR.eur_player_faction.displayName = "Kingdom of the Ñoldor"
                ::EUR.eur_player_faction.setColour(0, 0, 139)
                ::EUR.eur_player_faction.setSecondaryColour(192, 192, 192)
            }
        }
        ::EUR.defaultEDU()
        ::EUR.loadCharCAS()
        ::EUR.setCols()
        // changeGeneralPosition removed — not a feature
        if (!::EUR.options_first_run) {
            ::EUR.defaultEDUOffset()
            if (::EUR.options_legendary) {
                ::EUR.editTrait()
                ::EUR.orderOffset()
                ::EUR.defaultEDUOffset_leg()
                ::EUR.legendaryGarrisons()
                ::EUR.player_start_threshold <- 8   // generals bg level threshold
            }
            if (::EUR.chris_stuff) {
                if (::EUR.add_setts) {
                    ::EUR.defaultEDUOffsetSetts()
                }
            }
            ::EUR.economyModifiers()
            ::EUR.EDU_MODIFIERS.updateDescriptions()
            if (::EUR.checkCounter("kon_council_choice_accepted")) {
                ::units.get("Calaquendi Lords").generalUnit = false      // was `fals` in source — undefined-var throw in Quirrel
                ::units.get("Noldorin Bodyguards").generalUnit = false   // was `falsee` in source — undefined-var throw in Quirrel
            }
            ::EUR.checkEngineerGuild()
        } else {
            ::EUR.game_options.campaigndiff = ::game.options.campaignDifficulty()   // TODO host
            ::EUR.game_options.battlediff = ::game.options.battleDifficulty()        // TODO host
            ::EUR.show_options_window = true
            //defaultEDUGather()
        }

        ::EUR.eur_localculture <- ::game.cultureName(::EUR.eur_player_faction.cultureId)
        ::EUR.eur_localFactionName <- ::EUR.eur_player_faction.name
        ::EUR.FACTION_PLAYER[::EUR.eur_localFactionName] <- true

        //save unit values
        if (!::EUR.options_first_run) {
            ::EUR.genEDUcheck()
        }
        if (::EUR.eur_localFactionName in ::EUR.EUR_EVENTS) {
            local events = ::EUR.EUR_EVENTS[::EUR.eur_localFactionName]
            for (local i = 0; i < events.len(); i++) {
                local cooldownKey = ::EUR.eur_localFactionName + ("" + i) + "active_cooldown"
                local durationKey = ::EUR.eur_localFactionName + ("" + i) + "active_duration"
                if (cooldownKey in ::EUR.eurEventsData) {
                    events[i].active_cooldown = ::EUR.eurEventsData[cooldownKey]
                }
                if (durationKey in ::EUR.eurEventsData) {
                    events[i].active_duration = ::EUR.eurEventsData[durationKey]
                }
            }
        }
        ::EUR.modifyEDUcheck(::EUR.eur_playerFactionId, false)
        if (::EUR.lindon_0_count > 0) {
            if (!::EUR.lindon_0_bu_added) {
                ::EUR.ulmoAdd()
            }
        }
        if (::EUR.dwarven_0_count > 0) {
            if (!::EUR.dwarven_0_bu_added) {
                ::EUR.miningdwarvesAdd()
            }
        }
        // if (::EUR.ship_1_active) {
            // if (!::EUR.ship_1_added) {
                // ::EUR.gloryShip1()
                // ::EUR.ship_1_added = true
            // }
        // }
        // if (::EUR.ship_2_active) {
            // if (!::EUR.ship_2_added) {
                // ::EUR.gloryShip2()
                // ::EUR.ship_2_added = true
            // }
        // }
        // if (::EUR.ship_3_active) {
            // if (!::EUR.ship_3_added) {
                // ::EUR.gloryShip3()
                // ::EUR.ship_3_added = true
            // }
        // }
        // if (::EUR.ship_4_active) {
            // if (!::EUR.ship_4_added) {
                // ::EUR.gloryShip4()
                // ::EUR.ship_4_added = true
            // }
        // }
        // if (::EUR.king_1_active) {
            // if (!::EUR.king_1_added) {
                // ::EUR.gloryKings1()
                // ::EUR.king_1_added = true
            // }
        // }
        // if (::EUR.king_2_active) {
            // if (!::EUR.king_2_added) {
                // ::EUR.gloryKings2()
                // ::EUR.king_2_added = true
            // }
        // }
        // if (::EUR.king_3_active) {
            // if (!::EUR.king_3_added) {
                // ::EUR.gloryKings3()
                // ::EUR.king_3_added = true
            // }
        // }
        // if (::EUR.stew_1_active) {
            // if (!::EUR.stew_1_added) {
                // ::EUR.gloryStew1()
                // ::EUR.stew_1_added = true
            // }
        // }
        // if (::EUR.stew_2_active) {
            // if (!::EUR.stew_2_added) {
                // ::EUR.gloryStew2()
                // ::EUR.stew_2_added = true
            // }
        // }
        // if (::EUR.stew_3_active) {
            // if (!::EUR.stew_3_added) {
                // ::EUR.gloryStew3()
                // ::EUR.stew_3_added = true
            // }
        // }
    } else {
        ::EUR.eur_player_faction = ::EUR.eur_campaign.factionByName("papal_states")
    }

    //wait(calcWindow, 2)   // calcWindow retired (ffi window scaling not needed under autoScale)
    ::EUR.dorwinionGeneralBGCheck()

    if (::EUR.eur_localFactionName in ::EUR.ELVEN_FACTIONS) {
        ::EUR.elven_faction = true
    }

    ::EUR.eur_turn_number = ::EUR.eur_campaign.turnNumber

}
