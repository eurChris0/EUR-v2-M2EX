::EUR.campaignBoot <- function() {
    if (::EUR.to_log) { println("EUR SCRIPT: " + "onCampaignMapLoaded") }
    // removed host-global cache (::campaign is the host API global)
    // removed host-global cache (::stratMap is the host API global)
    // removed host-global cache (::Battle.current() is the host API global)
    ::EUR.UI_MANAGER = ::ui.cardManager()

    ::EUR.eur_campaign = ::game.campaign()
    ::EUR.eur_sMap = ::stratMap
    ::EUR.eur_numberOfFactions = ::game.factionCount()
    ::EUR.eur_playerFactionId = ::game.localFactionId()
    ::EUR.eur_player_faction = ::game.localFaction()
    // Before anything can build a widget - every EUR window's render() refuses until the line above
    // has run, precisely so the palette below is in place first.
    ::EUR.buildStyles(::EUR.eur_player_faction != null ? ::EUR.eur_player_faction.name : null)
    // Windows build at the main menu, before any faction exists, so the palette has to be pushed
    // back into the widgets that already carry the grey one.
    ::EUR.repaintStyles()

    local campaign = ::game.campaign()
    if (campaign != null) { campaign.setEventCounter("mithlond_controlled", 1) }

    ::game.campaign().setEventCounter("mithlond_controlled", 1)
    ::EUR.startLog(::game.modPath())
    if (::EUR.button_01.img == null) {
        ::EUR.loadImages()
        ::EUR.loadSounds()
    }
    if (!::EUR.gen_set) { ::EUR.rebuildUpgradeLists() }
    ::EUR.buildPlayerUnits()
    ::EUR.in_campaign_map = true
    ::EUR.eurGlobalVars()
    if (!::EUR.cas_standalone_set_already) {
        ::EUR.setCasStandalone()
        ::EUR.cas_standalone_set_already = true
    }
    if (::EUR.curr_faction == "") {
        if (::EUR.eur_player_faction != null) {
            if (::EUR.eur_player_faction.name != null) {
                ::EUR.curr_faction = ::EUR.eur_player_faction.name
            }
        }
    } else {
        if (::EUR.eur_player_faction != null) {
            if (::EUR.eur_player_faction.name != null) {
                if (::EUR.curr_faction == ::EUR.eur_player_faction.name) {
                    // nothing
                } else {
                    ::EUR.loadImages()
                    ::EUR.loadSounds()
                    ::EUR.curr_faction = ::EUR.eur_player_faction.name
                }
            }
        }
    }
    //if (eur_main_scripts) { calcWindow() }   // calcWindow retired (autoScale)
    if (::EUR.to_log) { println("FUNCTION END: " + "onCampaignMapLoaded") }
}

if (::EUR.EUR_EVENT_TRIGGERS.campaign) {

    ::events.on("PreFactionTurnStart", function(eventData) {
        ::EUR.logHelper("onPreFactionTurnStart")
        ::game.campaign().setEventCounter("garrison_skip", 0)
        ::EUR.mordorAnorienCheck(eventData.faction)
        ::EUR.isengardSwapCheck(eventData.faction)
        ::EUR.amonlancSwapCheck(eventData.faction)
        ::EUR.minasIthilSwapCheck(eventData.faction)
        ::EUR.carasSwapCheck(eventData.faction)
        ::EUR.helmSwapCheck(eventData.faction)
        ::EUR.tharbadSwapCheck(eventData.faction)
        ::EUR.amonSulSwapCheck(eventData.faction)
        if (::EUR.custom_cas.tauriel) {
            ::EUR.spawnTauriel()
        }
        if (::EUR.custom_cas.galadriel) {
            ::EUR.spawnGaladriel()
        }
        if (::EUR.custom_cas.sharku) {
            if (!::EUR.anorien_swap.sharku_spawned) {
                ::EUR.spawnSharku()
            }
        }

        if (eventData.faction.name == "slave") { return }
        if (eventData.faction.isPlayerControlled == 0) {
            ::EUR.spawnGeneralLargeArmy(eventData.faction)
        }
        ::EUR.addWatchtowers(eventData.faction)
        if (::EUR.options_gen_upgrades) {
            ::EUR.setBGSize(eventData.faction, null, null)
        }
        if (eventData.faction.isPlayerControlled == 1) {
            if (::EUR.eur_turn_number > 0) {
                ::EUR.checkEngineerGuild()
            }
        }
        // EOP AI-config modifiers: no squ equivalent for getEopAiConfig / getCampaignDifficulty2.
        // if (eventData.faction.isPlayerControlled == 1) {
        //     if (::EUR.eur_turn_number > 0) {
        //         if (::EUR.set_mods) { ::EUR.setEOPModifiers() }
        //     } else {
        //         ::EUR.getEOPModifiers()
        //     }
        // }
        ::EUR.logHelper("onPreFactionTurnStart end")
    })

    ::events.on("FactionTurnStart", function(eventData) {
        if (::EUR.to_log) { println("EUR SCRIPT: " + "onFactionTurnStart") }

        if (::EUR.options_legendary) {
            ::EUR.legendaryDifficulty(eventData.faction)
        }
        if (eventData.faction.name == "slave") {
            if (::EUR.eur_turn_number == 24) {
                ::game.campaign().setEventCounter("turn_25", 1)
            }
            if (::EUR.eur_turn_number == 49) {
                ::game.campaign().setEventCounter("turn_50", 1)
            }
            return
        }
        ::EUR.show_events_window = false
        if (eventData.faction.isPlayerControlled == 1) {
            // clampChars removed
            // clampChars removed
            // clampChars removed
            ::game.setWatchtowerRange(::EUR.watchtower_range)   // TODO host: watchtower range
            ::EUR.unitUpgrades.list_edu_recruitable()
            ::game.campaign().setEventCounter("tile_messages", 0)
            ::game.runScriptCommand("hide_all_revealed_tiles", "")
            ::EUR.revealAllied()
            ::game.campaign().setEventCounter("tile_messages", 1)
            if (::EUR.eur_player_faction.name == "turks") {
                if (!::EUR.anorien_swap.NDCASset) {
                    if (::EUR.checkCounter("reunited_kingdom")) {
                        ::EUR.removeAiGarrison(::EUR.eur_player_faction, false)
                        ::EUR.fixRKCAS()
                        ::EUR.bgunlock_units_list["faramir_1"] = "The White Company"
                        ::EUR.bgunlock_units_list["faramir_rk"] = "The White Company"
                        ::EUR.anorien_swap.NDCASset = true
                    }
                }
            }
            if (eventData.faction.name == "egypt") {
                if (!::EUR.misc_options.maernil_ring) {
                    ::EUR.eurEregion.maernilRingCheck()
                }
            }
            if ((eventData.faction.name == "saxons" || eventData.faction.name == "denmark" || eventData.faction.name == "egypt")) {
                if (::EUR.eregion_realms_start < 22) {
                    ::EUR.eurEregion.eregionStoryCheck()
                }
                if ((eventData.faction.name == "saxons" || eventData.faction.name == "denmark")) {
                    if (::EUR.misc_options.kon_start) {
                        if (::EUR.misc_options.kon_start_ai_eregion) {
                            if (!::EUR.eregion_spawned) {
                                if (::EUR.eur_turn_number >= 68 && ::EUR.eur_turn_number <= 80) {
                                    if (::EUR.math.random(1, 100) > 20) {
                                        ::EUR.eurEregion.spawnEregionHorde(false)
                                        ::EUR.eregion_spawned = true
                                    }
                                } else if (::EUR.eur_turn_number == 81) {
                                    ::EUR.eurEregion.spawnEregionHorde(false)
                                    ::EUR.eregion_spawned = true
                                }
                            }
                        }
                    }
                }
            } else {
                if (::EUR.game_options.eregion_spawn) {
                    if (!::EUR.eregion_spawned) {
                        if (::EUR.eur_turn_number >= 68 && ::EUR.eur_turn_number <= 80) {
                            if (::EUR.math.random(1, 100) > 20) {
                                ::EUR.eurEregion.spawnEregionHorde(false)
                                ::EUR.eregion_spawned = true
                            }
                        } else if (::EUR.eur_turn_number == 81) {
                            ::EUR.eurEregion.spawnEregionHorde(false)
                            ::EUR.eregion_spawned = true
                        }
                    }
                }
            }
            if (::EUR.game_options.global_recruitment) {
                ::EUR.eurGlobalRecruitment.globalRecruitmentTurnCheck()
            }
            ::EUR.genRankCheck(eventData.faction, null)
            if (eventData.faction.name == "turks" || eventData.faction.name == "sicily") {
                if (!::EUR.game_options.eurRKcomplete) {
                    if (::EUR.checkCounter("reunited_kingdom")) {
                        ::EUR.swapRKBarracks()
                        ::EUR.removeAiGarrison(eventData.faction, false)
                    }
                }
            }
            ::EUR.SwapUnitsOnConfed(eventData.faction)
        }

        if (eventData.faction.isPlayerControlled == 1) {
            ::EUR.swapHierStuffCheck(::EUR.eur_player_faction)
        }
        if (::EUR.eur_player_faction.name == "milan" || ::EUR.eur_player_faction.name == "france") {
            //eurHelmsBrick.triggerIfReady(eventData)
        }
        if (eventData.faction.isPlayerControlled == 0) {
            ::EUR.removeAiGarrison(eventData.faction, true)
        }
        if (::EUR.to_log) { println("EUR SCRIPT END: " + "onFactionTurnStart") }
    })

    ::events.on("FactionTurnEnd", function(eventData) {
        if (::EUR.to_log) { println("EUR SCRIPT: " + "onFactionTurnEnd") }
        if (::EUR.options_replen == true) {
            ::EUR.eurReplenishment.replenishUnits(eventData.faction)
            if (::EUR.options_replen_costs) {
                if (eventData.faction.isPlayerControlled == 1) {
                    ::EUR.eurReplenishment.deductReplen()
                }
            }
        }
        // radagast bodyguard top-up, once per turn (was per-general in onCharacterTurnStart)
        if (eventData.faction == ::EUR.eur_player_faction) {
            ::EUR.setRadagastLevel()
        }
        if (::EUR.options_evolvingnames) {
            ::EUR.checkEvolvingFaction(eventData.faction)
        }
        if (::EUR.options_sort == true) {
            ::EUR.eurSortStack.eurSortStack(eventData.faction)
        }
        if (::EUR.options_merge) {
            ::EUR.eurMergeArmies.mergeFactionArmies(eventData.faction)
        }
        if (::EUR.options_unit_upgrades) {
            ::EUR.unitUpgrades.checkAIUpgrades(eventData.faction)
        }
        if (eventData.faction.isPlayerControlled == 0) {
            // clampChars removed
            //garrison stuff
        } else if (eventData.faction.isPlayerControlled == 1) {
            if (::EUR.game_options.airevive) {
                ::EUR.checkAIRevival()
            }
            ::EUR.checkEvoCounters()
            if (::EUR.eur_turn_number > 0) {
                ::EUR.removeAiGarrison(eventData.faction, false)
            }
        }
        if (::EUR.eur_event_active) {
            if (::EUR.ship_4_active) {
                // ::EUR.hyarmendacilAdd()
            }
            ::EUR.mengood_0_check(eventData.faction.id)
            ::EUR.traitCheck(eventData.faction.id)
            ::EUR.growthCheck(eventData.faction.id)
            ::EUR.modifyEDUcheck(eventData.faction.id, true)
            ::EUR.tulkasCheck(eventData.faction.id, null, false)
        }
        ::EUR.eurEventActiveCheck(eventData.faction.id, eventData.faction.name)
        ::EUR.eurEventUnlockCheck(eventData.faction.id)
        ::EUR.swapHeirLeaderStuffAI(eventData.faction)
        if (eventData.faction.isPlayerControlled == 1) {
            ::EUR.dorwinionGeneralBGCheck()
        } else {
            if (::EUR.eur_turn_number > 0) {
                ::EUR.removeAiGarrison(eventData.faction, false)
                local faction = eventData.faction.name
                //wait(addAiGarrison, 0.2, faction)
                ::EUR.addAiGarrison(faction)
            }
        }
        if (::EUR.to_log) { println("EUR SCRIPT END: " + "onFactionTurnEnd") }
    })

    // Called after loading the campaign map
    ::events.on("campaignMapLoaded", function() {
        ::EUR.campaignBoot()
    })

    ::events.on("exitToMenu", function() {
        ::EUR.in_campaign_map = false
    })

    // newGameStart fires in the DataBuild phase - ::game is Campaign-gated, so the counter has to
    // wait for campaignMapLoaded (it is set there instead).
    ::events.on("newGameStart", function() {
        if (!::EUR.options_first_run) {
            ::EUR.resetGameVars()
        }
    })

    ::events.on("newGameLoaded", function() {
        ::EUR.eur_campaign_options = ::game.options
        ::EUR.eur_campaign = ::game.campaign()
        ::EUR.eur_sMap = ::stratMap
        ::EUR.eur_numberOfFactions = ::game.factionCount()
        ::EUR.eur_player_faction = ::game.localFaction()
        // addEURSetts()  -- now real settlements in descr_strat; runtime spawn disabled
        if (::EUR.chris_stuff) {
            if (::EUR.add_setts) {
                ::EUR.addSetts()
                ::EUR.addSettsBu()
                ::EUR.defaultEDUOffsetSetts()
                ::game.campaign().setEventCounter("chris_setts", 1)
            }
        }
        if (::game.options.campaignDifficulty() == 3) {   // TODO host: game options
            ::EUR.show_leg_notif = true
        }
        ::game.options.setAutosave(true)
        ::EUR.saveDefaultSettings()
        ::EUR.loadOptions()
        //::EUR.show_genenabled = true
    })

    ::events.on("unloadCampaign", function() {
        if (::EUR.to_log) { println("EUR SCRIPT: " + "onUnloadCampaign") }
        ::EUR.in_campaign_map = false
        if (::EUR.to_log) { println("EUR SCRIPT END: " + "onUnloadCampaign") }
    })

    ::events.on("turnChanged", function(eventData) {
        if (::EUR.eur_turn_number != ::EUR.eur_campaign.turnNumber) {
            ::EUR.eur_turn_number = ::EUR.eur_campaign.turnNumber
        }
    })

    ::events.on("campaignTick", function() {
        if (::EUR.in_campaign_map) {
        }
    })

}
