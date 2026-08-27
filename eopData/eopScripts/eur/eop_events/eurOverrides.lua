if eur_overrides then


    function onPreFactionTurnStart(eventData)
        logHelper("onPreFactionTurnStart")
        logHelper(eventData.faction.name)
        M2TWEOP.setScriptCounter("garrison_skip", 0)
        logHelper("cas checks")
        mordorAnorienCheck(eventData.faction)
        isengardSwapCheck(eventData.faction)
        amonlancSwapCheck(eventData.faction)
        minasIthilSwapCheck(eventData.faction)
        carasSwapCheck(eventData.faction)
        helmSwapCheck(eventData.faction)
        tharbadSwapCheck(eventData.faction)
        amonSulSwapCheck(eventData.faction)
        if custom_cas.tauriel then
            logHelper("spawnTauriel")
            spawnTauriel()
        end
        if custom_cas.galadriel then
            logHelper("spawnGaladriel")
            spawnGaladriel()
        end
        if custom_cas.sharku then
            if not anorien_swap.sharku_spawned then
                logHelper("spawnSharku")
                spawnSharku()
            end
        end

        if eventData.faction.name == "slave" then return end
        if eventData.faction.isPlayerControlled == 0 then
            logHelper("spawnGeneralLargeArmy")
            spawnGeneralLargeArmy(eventData.faction)
        end
        logHelper("addWatchtowers")
        addWatchtowers(eventData.faction)
        if options_gen_upgrades then
            logHelper("setBGSize")
            setBGSize(eventData.faction, nil, nil)
        end
        if eventData.faction.isPlayerControlled == 1 then
            if eur_turn_number > 0 then
                logHelper("checkEngineerGuild")
                checkEngineerGuild()
                if set_mods then
                    logHelper("setEOPModifiers")
                    setEOPModifiers()
                end
            else
                logHelper("getEOPModifiers")
                getEOPModifiers()
            end
        end
        logHelper("onPreFactionTurnStart end")
    end
    
    function onFactionTurnStart(eventData)
        if to_log then
            M2TWEOP.logGame("EUR SCRIPT: ".."onFactionTurnStart");
        end
        logHelper(eventData.faction.name)

        if options_legendary then
            logHelper("legendaryDifficulty")
            legendaryDifficulty(eventData.faction)
        end
        if eventData.faction.name == "slave" then 
            if eur_turn_number == 24 then
                M2TWEOP.setScriptCounter("turn_25", 1)
            end    
            if eur_turn_number == 49 then
                M2TWEOP.setScriptCounter("turn_50", 1)
            end  
        return end
        show_events_window = false
        if eventData.faction.isPlayerControlled == 1 then
            logHelper("clampChars")
            clampChars(eur_campaign:getFaction("hre"))
            clampChars(eur_campaign:getFaction("england"))
            clampChars(eur_campaign:getFaction("normans"))
            logHelper("clampChars")
            M2TWEOP.setWatchTowerRange(watchtower_range)
            logHelper("clampChars")
            list_edu_recruitable()
            M2TWEOP.setScriptCounter("tile_messages", 0)
            stratmap.game.scriptCommand("hide_all_revealed_tiles")
            logHelper("clampChars")
            revealAllied()
            M2TWEOP.setScriptCounter("tile_messages", 1)
            if eur_player_faction.name == "turks" then
                if not anorien_swap.NDCASset then
                    if checkCounter("reunited_kingdom") then
                        logHelper("removeAiGarrison3")
                        removeAiGarrison(eur_player_faction, false)
                        fixRKCAS()
                        bgunlock_units_list["faramir_1"] = "The White Company"
                        bgunlock_units_list["faramir_rk"] = "The White Company"
                        anorien_swap.NDCASset = true
                    end
                end
            end
            if eventData.faction.name == "egypt" then
                if not misc_options.maernil_ring then
                    logHelper("maernilRingCheck")
                    maernilRingCheck()
                end
            end
            if (eventData.faction.name == "saxons" or eventData.faction.name == "denmark" or eventData.faction.name == "egypt") then
                if eregion_realms_start < 22 then
                    eurConfed.eregionStoryCheck()
                end
                if (eventData.faction.name == "saxons" or eventData.faction.name == "denmark") then
                    if misc_options.kon_start then
                        if misc_options.kon_start_ai_eregion then
                            if not eregion_spawned then
                                if eur_turn_number >= 68 and eur_turn_number <= 80 then
                                    if math.random(1, 100) > 20 then
                                        spawnEregionHorde(false)
                                        eregion_spawned = true
                                    end
                                elseif eur_turn_number == 81 then
                                    spawnEregionHorde(false)
                                    eregion_spawned = true
                                end
                            end
                        end
                    end
                end
            else
                if game_options.eregion_spawn then
                    if not eregion_spawned then
                        if eur_turn_number >= 68 and eur_turn_number <= 80 then
                            if math.random(1, 100) > 20 then
                                spawnEregionHorde(false)
                                eregion_spawned = true
                            end
                        elseif eur_turn_number == 81 then
                            spawnEregionHorde(false)
                            eregion_spawned = true
                        end
                    end
                end
            end
            if game_options.global_recruitment then
                logHelper("globalRecruitmentTurnCheck")
                globalRecruitmentTurnCheck()
            end
            logHelper("turnImageCheck")
            turnImageCheck(eventData.faction)
            logHelper("genRankCheck")
            genRankCheck(eventData.faction, nil)
            if eventData.faction.name == "turks" or eventData.faction.name == "sicily" then
                if not game_options.eurRKcomplete then
                    if checkCounter("reunited_kingdom") then
                        swapRKBarracks()
                        removeAiGarrison(eventData.faction, false)
                    end
                end
            end
            SwapUnitsOnConfed(eventData.faction)
        end

        if eventData.faction.isPlayerControlled == 1 then
            logHelper("swapHierStuffCheck")
            swapHierStuffCheck(eur_player_faction)
            local economyTable = eur_player_faction:getFactionEconomy(0)
            finance_calc.missionIncome = economyTable.missionIncome
            finance_calc.diplomacyIncome = economyTable.diplomacyIncome
            finance_calc.tributesIncome = economyTable.tributesIncome
            finance_calc.tributesExpense = economyTable.tributesExpense
            finance_calc.diplomacyExpense = economyTable.diplomacyExpense
            if auto_turn then
                if eur_campaign.turnNumber > 1 and eur_campaign.turnNumber < auto_turn_number then
                    wait(end_turn, 2.5)
                end
            end
        end
        if eur_player_faction.name == "milan" or eur_player_faction.name == "france" then
            --eurHelmsBrick.triggerIfReady(eventData)
        end
        if eventData.faction.isPlayerControlled == 0 then
            logHelper("removeAiGarrison4")
            removeAiGarrison(eventData.faction, true)
        end
        if to_log then
            M2TWEOP.logGame("EUR SCRIPT END: ".."onFactionTurnStart");
        end
    end

    function onFactionTurnEnd(eventData)
        if to_log then
            M2TWEOP.logGame("EUR SCRIPT: ".."onFactionTurnEnd");
        end
        logHelper(eventData.faction.name)
        if options_replen == true then
            logHelper("replen")
            eurReplenishment.replenishUnits(eventData.faction)
            if options_replen_costs then
                if eventData.faction.isPlayerControlled == 1 then
                    logHelper("deductReplen")
                    eurReplenishment.deductReplen()
                end
            end
        end
        if options_evolvingnames then
            logHelper("checkEvolvingFaction")
            checkEvolvingFaction(eventData.faction)
        end
        if collect_stats then
            logHelper("checkEvolvingFaction")
            collectFin(eventData.faction)
        end
        if options_sort == true then
            logHelper("eurSortStack")
            eurSortStack.eurSortStack(eventData.faction)
        end
        if options_merge then
            logHelper("mergeFactionArmies")
            eurMerge.mergeFactionArmies(eventData.faction)
        end
        if options_unit_upgrades then
            logHelper("checkAIUpgrades")
            checkAIUpgrades(eventData.faction)
        end
        if eventData.faction.isPlayerControlled == 0 then 
            logHelper("clampChars")
            clampChars(eventData.faction)
--garrison stuff
        elseif eventData.faction.isPlayerControlled == 1 then
            if game_options.airevive then
                logHelper("checkAIRevival")
                checkAIRevival()
            end
            logHelper("checkEvoCounters")
            checkEvoCounters()
            if eur_turn_number > 0 then
                logHelper("removeAiGarrison2")
                removeAiGarrison(eventData.faction, false)
            end
        end
        if eur_event_active then
            if ship_4_active then
                hyarmendacilAdd()
            end
            mengood_0_check(eventData.faction.factionID)
            traitCheck(eventData.faction.factionID)
            growthCheck(eventData.faction.factionID)
            modifyEDUcheck(eventData.faction.factionID, true)
            tulkasCheck(eventData.faction.factionID, nil, false)
        end
        logHelper("eurEventActiveCheck")
        eurEventActiveCheck(eventData.faction.factionID, eventData.faction.name)
        eurEventUnlockCheck(eventData.faction.factionID)
        swapHeirLeaderStuffAI(eventData.faction)
        if eventData.faction.isPlayerControlled == 1 then
            logHelper("dorwinionGeneralBGCheck")
            dorwinionGeneralBGCheck()
        else
            if eur_turn_number > 0 then
                logHelper("removeAiGarrison1")
               removeAiGarrison(eventData.faction, false)
               local faction = eventData.faction.name
               logHelper("addAiGarrison")
               --wait(addAiGarrison, 0.2, faction)
               addAiGarrison(faction)
            end
        end
        if to_log then
            M2TWEOP.logGame("EUR SCRIPT END: ".."onFactionTurnEnd");
        end
    end

    
--- Called after loading the campaign map
function onCampaignMapLoaded()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: ".."onCampaignMapLoaded");
	end
    CAMPAIGN   = M2TW.campaign
    STRAT_MAP  = M2TW.stratMap
    BATTLE     = M2TW.battle
    UI_MANAGER = M2TW.uiCardManager

    eur_gameData = gameDataAll.get()
    eur_campaign = gameDataAll.get().campaignStruct
    eur_sMap = gameDataAll.get().stratMap
    eur_numberOfFactions = stratmap.game.getFactionsCount()
    eur_playerFactionId = M2TWEOP.getLocalFactionID()
    eur_player_faction = stratmap.game.getFaction(0)

    if eur_main_scripts then
        startLog(M2TWEOP.getModPath())
        if button_01.img == nil then
            loadImages()
            wait(loadSounds, 1)
            M2TWEOP.logGame("EUR SCRIPT: ".."global loading...");
        end
        in_campaign_map = true
        eurGlobalVars()
        if not cas_standalone_set_already then
            setCasStandalone()
            cas_standalone_set_already = true
        end
        if curr_faction == "" then
            if eur_player_faction ~= nil then
                if eur_player_faction.name ~= nil then
                    curr_faction = eur_player_faction.name
                end
            end
        else
            if eur_player_faction ~= nil then
                if eur_player_faction.name ~= nil then
                    if curr_faction == eur_player_faction.name then
                        -- nothing
                    else
                        loadImages()
                        wait(loadSounds, 1)
                        curr_faction = eur_player_faction.name
                    end
                end
            end
        end
    end
    if eur_main_scripts then
        calcWindow()
    end
    if to_log then
		M2TWEOP.logGame("FUNCTION END: ".."onCampaignMapLoaded");
	end
end

function onExitToMenu()
    if eur_main_scripts then
        in_campaign_map = false
        if not options_first_run then
            show_options_restart_window = true
        end
    end
end

function onNewGameStart()
    M2TWEOP.setScriptCounter("mithlond_controlled", 1)
    if not options_first_run then
        resetGameVars()
    end
    if collect_stats then
        initTurnStatTable()
    end
end

function onNewGameLoaded()
    eur_campaign_options = M2TWEOP.getOptions1();
    eur_gameData = gameDataAll.get()
    eur_campaign = gameDataAll.get().campaignStruct
    eur_sMap = gameDataAll.get().stratMap
    eur_numberOfFactions = stratmap.game.getFactionsCount()
    eur_player_faction = stratmap.game.getFaction(0)
    -- addEURSetts()  -- now real settlements in descr_strat; runtime spawn disabled
    if chris_stuff then
        if add_setts then
            addSetts()
            addSettsBu()
            defaultEDUOffsetSetts()
            M2TWEOP.setScriptCounter("chris_setts", 1)
        end
    end
    if M2TWEOP.getOptions2().campaignDifficulty == 3 then
        show_leg_notif = true
    end
    M2TWEOP.getOptions2().toggleAutoSave = 1
    saveDefaultSettings()
    loadOptions()
    show_genenabled = true
end

function onUnloadCampaign()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: ".."onUnloadCampaign");
	end
    if eur_main_scripts then
        in_campaign_map = false
    end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT END: ".."onUnloadCampaign");
	end
end

function onLoadingFonts()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: ".."onLoadingFonts");
	end
    if eur_main_scripts then
        loadFonts()
    end
end

    function onChangeTurnNum(eventData)
        if eur_turn_number ~= eur_campaign.turnNumber then
            eur_turn_number = eur_campaign.turnNumber
        end
    end

    function onButtonPressed(eventData)
        logHelper("onButtonPressed")
        local buttons = {
            ["decrease_taxation_gadget"] = true,
            ["increase_taxation_gadget"] = true,
            ["advanced_settlement_info_scroll"] = true,
            ["garrison_info_zoom_to_button"] = true,
            ["settlement_stats_button"] = true,
            ["advanced_stats_show_trade_button"] = true,
            ["settlement_info_construction_tab"] = true,
        }
        if eventData.resourceDescription == "mission_button" then
            if (eur_player_faction.name == "saxons" or eur_player_faction.name == "denmark" or eur_player_faction.name == "egypt") then
                eregionStoryText()
            end
        end
        if eventData.resourceDescription == "settlement_info_construction_tab" then
            show_settUI = true
            show_replen_ui = false
            hud_show_units_tab_pressed = false
        end
        if eventData.resourceDescription == "settlement_info_retrain_tab" then
            show_replen_ui = true
            hud_show_units_tab_pressed = true
        end
        if eventData.resourceDescription == "settlement_info_recruitment_tab" then
            show_replen_ui = true
            hud_show_units_tab_pressed = true
        end
        if eventData.resourceDescription == "settlement_info_repair_tab" then
            show_replen_ui = false
            hud_show_units_tab_pressed = false
        end
        if eventData.resourceDescription == "hud_show_units_tab" then
            show_replen_ui = true
            hud_show_units_tab_pressed = true
        end
        if eventData.resourceDescription == "hud_show_buildings_tab" then
            show_replen_ui = false
            hud_show_units_tab_pressed = false
        end
        if eventData.resourceDescription == "hud_show_agents_tab" then
            hud_show_units_tab_pressed = false
            show_replen_ui = false
        end
        if not buttons[eventData.resourceDescription] then
            show_settUI = false
        end
        print("button")
        print(eventData.resourceDescription)
        if in_campaign_map then
            if game_options.global_recruitment then
                recruitCheckGlobal()
            end
        end
    end

    function onGiveSettlement(eventData)
        logHelper("onGiveSettlement")
        local name = eventData.settlement.name
        wait(eurSwapUnitsOnTrade, 0.5, name)
    end

    function onGeneralCaptureSettlement(eventData)
        logHelper("onGeneralCaptureSettlement")
        if game_options.global_recruitment then
            globalClearLostSett(eventData.settlement)
        end
    end

    function onPreBattlePanelOpen(eventData)
        logHelper("onPreBattlePanelOpen")
        print("huh")
        eurAddSpoils.getBattlePreInfo()
        in_campaign_map = false
        saved_already_pre = false
    end

    function onPostBattle(eventData)
        logHelper("onPostBattle")
        if eventData.faction.name == "slave" then return end
        in_campaign_map = true
        eurAddSpoils.getBattleOutcomeWin()
        if eventData.faction.isPlayerControlled == 1 then
            show_alt_loot = true
            wait(eurAddSpoils.postBattleChecks, 0.5, eventData.faction)
            --wait(restoreSplitUnits, 2, true)
        end
    end


    function onScrollOpened(eventData)
        logHelper("onScrollOpened")
        show_events_window = false
        if eventData.resourceDescription == "unit_info_scroll" then
            show_unitscroll_tooltip = true
        end
        if eventData.resourceDescription == "end_game_scroll" then
            show_options_button = true
        end
        if eventData.resourceDescription == "prebattle_scroll" then
            eur_pre_battle = true
        end
        if eventData.resourceDescription == "own_settlement_info_scroll" then
            show_temp_char_stuff = true
            swap_bg_button = true
        end
        if eventData.resourceDescription == "post_battle_scroll" then
        end
        if eventData.resourceDescription == "field_construction_scroll" then
            show_buildfort = true
        end
        if eventData.resourceDescription == "hud_show_agents_tab" then
            window_states.swap_bg_window = false
        end
        if tableContains(left_panels, eventData.resourceDescription) then
            window_states.swap_bg_window = false
            window_states.show_upgrade_window = false
            alias_text = ""
            alias_text_set = false
            window_states.show_globalrecruit_window = false
        end
        print(eventData.resourceDescription)
    end

    function onScrollClosed(eventData)
        logHelper("onScrollClosed")
        if eventData.resourceDescription == "unit_info_scroll" then
            show_unitscroll_tooltip = false
        end
        if eventData.resourceDescription == "end_game_scroll" then
            show_options_button = false
            show_options_window = false
        end
        if eventData.resourceDescription == "prebattle_scroll" then
            eur_pre_battle = false
            eur_pre_battle_window = false
        end
        if eventData.resourceDescription == "own_settlement_info_scroll" then
            temp_char_stuff = nil
            show_temp_char_stuff = false
            swap_bg_button = false
            window_states.swap_bg_window = false
            window_states.show_globalrecruit_window = false
        end
        if eventData.resourceDescription == "diplomacy_scroll" then
            diplo_open = false
        end
        if eventData.resourceDescription == "post_battle_scroll" then
            show_alt_loot = false
        end
        if eventData.resourceDescription == "field_construction_scroll" then
            show_buildfort = false
        end
        if eventData.resourceDescription == "own_settlement_info_scroll" then
            print("tab closed")
            show_settUI = false
        end

        print(eventData.resourceDescription)
    end

    function onPreBattleWithdrawal(eventData)
        logHelper("onPreBattleWithdrawal")
        resetPostBattleGarrison()
        --M2TW.campaign.ignoreSpeedUp = false
        --M2TW.campaign.speedUp = true
        --M2TW.campaign.followMovement = false
        if eventData.faction.name == "slave" then return end
        in_campaign_map = true
        eur_pre_battle = false
        eur_pre_battle_window = false
        --restoreSplitUnits(true)
        eur_already_saved = false
        losses_upkeep = 0
    end

    function onCharacterSelected(eventData)
        print(eventData.character.label)
        print("portrait:", eventData.character.portrait)
        print("custom portrait:", eventData.character.portrait_custom)
        hud_show_units_tab_pressed = true
        show_replen_ui = true
        sel_unit = nil
        window_states.swap_bg_window = false
        window_states.show_upgrade_window = false
        alias_text = ""
        alias_text_set = false
        if eventData.character.character.characterType == 7 then
            temp_fort_char = eventData.character.character
        elseif eventData.character.character.characterType == 6 then
            if eventData.character.character.army then
                sel_unit = eventData.character.character.army:getUnit(0)
                temp_fort_char = nil
            end
        else
            temp_fort_char = nil
        end
        if options_sort == true then
            eurSortStack.eurSortOnSelected(eventData.character)
        end
        if options_gen_upgrades then
            setBGSize(eventData.faction, nil, nil)
        end
    end

    function onDiplomacyPanelOpen(eventData)
        diplo_open = true
    end


    function onEventCounter(eventData)
        logHelper("onEventCounter")
        if eventData.eventCounter == "elven_union" then
            removeAiGarrison(eur_player_faction, false)
            fixWoodElvesUnion()
        end
        if eventData.eventCounter == "WKcangotoCD" then
            removeAiGarrison(eur_player_faction, false)
            killWitchKing()
        end
        
        if eventData.eventCounter == "reunited_kingdom_gondor_side" then
            removeAiGarrison(eur_player_faction, false)
            fixRKGondor()
        end
        if eventData.eventCounter == "reunited_kingdom" then
            if checkCounter(eventData.eventCounter) then
                faction_revival["sicily"].revived_already = true
                faction_revival["sicily"].revived_already_ai = true
            end
        end
        if eventData.eventCounter == "blue_wizards_arrive" then
            if checkCounter(eventData.eventCounter) then
                faction_disposition["khand"] = "good"
            end
        end
        if eventData.eventCounter == "dunland_traitor" then
            if checkCounter(eventData.eventCounter) then
                faction_disposition["aztecs"] = "neutral"
            end
        end
        if eventData.eventCounter == "kon_council_choice_accepted" then
            if checkCounter(eventData.eventCounter) then
                faction_revival["denmark"].revived_already = true
                faction_revival["saxons"].revived_already = true
                faction_revival["denmark"].revived_already_ai = true
                faction_revival["saxons"].revived_already_ai = true
            end
        end
        if eventData.eventCounter == "elven_union" then
            if checkCounter(eventData.eventCounter) then
                faction_revival["mongols"].revived_already = true
                faction_revival["ireland"].revived_already = true
                faction_revival["mongols"].revived_already_ai = true
                faction_revival["ireland"].revived_already_ai = true
            end
        end
        if eventData.eventCounter == "durin_stop_7" then
            if checkCounter(eventData.eventCounter) then
                faction_revival["hungary"].revived_already = true
                faction_revival["moors"].revived_already = true
                faction_revival["hungary"].revived_already_ai = true
                faction_revival["moors"].revived_already_ai = true
            end
        end
        if eventData.eventCounter == "durin_kh_ok" then
            if checkCounter(eventData.eventCounter) then
                faction_revival["hungary"].revived_already = true
                faction_revival["norway"].revived_already = true
                faction_revival["hungary"].revived_already_ai = true
                faction_revival["norway"].revived_already_ai = true
            
            end
        end
        if eventData.eventCounter == "fusion_bc_accepted" then
            if checkCounter(eventData.eventCounter) then
                faction_revival["normans"].revived_already = true
                faction_revival["hre"].revived_already = true
                faction_revival["normans"].revived_already_ai = true
                faction_revival["hre"].revived_already_ai = true
            end
        end
        
    end

    function onUnitDisbanded(eventData)
        sel_unit = nil
    end


    function onUnitTrained(eventData)
        logHelper("onUnitTrained")
        if eventData.faction.name == "slave" then return end
        if options_gen_upgrades then
            setBGSize(nil, nil, eventData.playerUnit)
        end
        if eventData.faction == eur_player_faction then
            print(eventData.playerUnit.eduEntry.eduEntry)
        end
        if eventData.faction == eur_player_faction then
            tulkasCheck(eventData.faction.factionID, eventData.playerUnit, true)
        end
        if collect_stats then
            countUnitsTrained(eventData.faction.localizedName, eventData.playerUnit.eduEntry.eduType)
        end
    end

    function onSettlementTurnStart(eventData)
        if to_log then
            M2TWEOP.logGame("EUR SCRIPT: ".."onSettlementTurnStart");
        end
        clampGarrisonSett(eventData.settlement)
        if game_options.convert_buildings then
            eurfixBuildingPics(eventData.settlement)
        end
        if strat_cas_setts[eventData.settlement.name] then
            if not cas_set_already[eventData.settlement.name] then
                setCasSett(eventData.settlement)
                cas_set_already[eventData.settlement.name] = true
            end
        end
        if eur_player_faction.name == "milan" or eur_player_faction.name == "france" then
            --eurHelmsBrick.checkForBrick(eventData)
        end
        if to_log then
            M2TWEOP.logGame("EUR SCRIPT END: ".."onSettlementTurnStart");
        end
    end

    function onSettlementSelected(eventData)
        print(eventData.settlement.name)
        print(eventData.settlement.regionID)
        if hud_show_units_tab_pressed then
            show_replen_ui = true
        else
            show_replen_ui = false
        end
        sel_unit = nil
        window_states.swap_bg_window = false
        window_states.show_upgrade_window = false
        alias_text = ""
        alias_text_set = false
        if eventData.settlement.governor ~= nil then
            if eventData.settlement.governor.characterType == 7 then
                temp_fort_char = eventData.settlement.governor
            else
                temp_fort_char = nil
            end
        else
            temp_fort_char = nil
            if eventData.settlement.army ~= nil then
                if eventData.settlement.army.numOfUnits > 0 then
                    sel_unit = eventData.settlement.army:getUnit(0)
                end
            end
        end
        if options_gen_upgrades then
            setBGSize(eventData.settlement.ownerFaction, nil, nil)
        end
    end

    function onGovernorUnitTrained(eventData)
        logHelper("onGovernorUnitTrained")
        if options_gen_upgrades then
            setBGSize(eventData.faction, nil, nil)
        end
    end

    function onBecomesFactionLeader(eventData)
        logHelper("onBecomesFactionLeader")
        if eventData.faction == nil then return end
        if eventData.faction.name == "slave" then return end
        if eur_turn_number > 5 then
            galadrielTitleCheck()
        end
        if eventData.character ~= nil then
            if eventData.character.character ~= nil then
                swapHierLeaderStuff(eventData.character.character, true)
            end
        end
    end

    function onBecomesFactionHeir(eventData)
        logHelper("onBecomesFactionHeir")
        if eventData.faction == nil then return end
        if eventData.faction.name == "slave" then return end
        if eventData.character ~= nil then
            if eventData.character.character ~= nil then
                swapHierLeaderStuff(eventData.character.character, false)
            end
        end
    end

function onGeneralAssaultsGeneral(eventData)
    logHelper("onGeneralAssaultsGeneral")
    if options_hardcore then
        if eventData.characterType == 3 then
            eur_campaign.restrictAutoResolve = 0
        else
            eur_campaign.restrictAutoResolve = 1
        end
    end
end

function onAddedToTrainingQueue(eventData)
    logHelper("onAddedToTrainingQueue")
    if game_options.global_recruitment then
        recruitCheckGlobal()
    end
end

function onRemoveFromUnitQueue(eventData)
    logHelper("onRemoveFromUnitQueue")
    if game_options.global_recruitment then
        recruitCheckGlobal()
    end
end

function onCharacterTurnStart(eventData)
    logHelper("onCharacterTurnStart")
    if eventData.character.character ~= nil then
        if eventData.character.character.characterType == 7 then
            clampGarrison(eventData.character.character)
        end
    end
    if eventData.characterType == 7 then
        eurReplenishment.setGeneralLevel(eventData.character)
        eurReplenishment.setRadagastLevel(eventData.character)
        if eventData.faction.name == "sicily" then
            addGondorFiefTrait(eventData.character)
        end
    end
    fixCharUniqueName(eventData.character)
    logHelper("onCharacterTurnStart end")
end

function onCharacterComesOfAge(eventData)
    logHelper("onCharacterComesOfAge")
    if eventData.faction.name == "sicily" then
        addGondorFiefTrait(eventData.character)
    end
    fixCharUniqueName(eventData.character)
end

function onOfferedForAdoption(eventData)
    if eventData.faction.name == "sicily" then
        addGondorFiefTrait(eventData.character)
    end
end

function onLesserGeneralOfferedForAdoption(eventData)

    if eventData.faction.name == "sicily" then
        addGondorFiefTrait(eventData.character)
    end
    fixCharUniqueName(eventData.character)
end

function onOfferedForMarriage(eventData)
    if eventData.faction.name == "sicily" then
        addGondorFiefTrait(eventData.character)
    end
    fixCharUniqueName(eventData.character)
end

function onBrotherAdopted(eventData)
    if eventData.faction.name == "sicily" then
        addGondorFiefTrait(eventData.character)
    end
    fixCharUniqueName(eventData.character)
end


function onCampaignTick()
    if in_campaign_map then
        --M2TW.campaign.ignoreSpeedUp = false
        --M2TW.campaign.speedUp = true
        --M2TW.campaign.followMovement = false
    end
end

function onCharacterTurnEnd(eventData)
    logHelper("onCharacterTurnEnd")
    if eventData.characterType == 7 then
        eurReplenishment.setGeneralLevel(eventData.character)
    end
    --M2TW.campaign.ignoreSpeedUp = false
    --M2TW.campaign.speedUp = true
    --M2TW.campaign.followMovement = false
    logHelper("onCharacterTurnEnd")
end


function onUIElementVisible(eventData)
    print(eventData.resourceDescription)
end

function onGuildUpgraded(eventData)
    logHelper("onGuildUpgraded")
    if eventData.faction == eur_player_faction then
        if eventData.guildId == 7 then
            wait(checkEngineerGuild, 0.2)
        end
    end
end

function onBuildingDestroyed(eventData)
    logHelper("onBuildingDestroyed")
    if eventData.faction == eur_player_faction then
        --if eventData.guildId == 7 then
            wait(checkEngineerGuild, 0.2)
        --end
    end
end

---The deployment phase has begun.
---Exports: faction, religion
---@param eventData eventTrigger
function onBattleDeploymentPhaseCommenced(eventData)
	BATTLE = M2TW.battle          
	--BATTLE_AI:deployStakes()
    --BATTLE_GUI:openRegionInfo()
end

---The conflict phase has begun.
---Exports: faction, religion
---@param eventData eventTrigger
function onBattleConflictPhaseCommenced(eventData)
	BATTLE = M2TW.battle 
    BATTLE_AI:initialize()
    if game_options.disable_skirmish then
        BATTLE_AI:disablePlayerSkirmishMode()
    end
    BATTLE_AI:start()
end

function onBattleTick()
    if M2TW.battle.ticksSinceBattleStart % 100 == 0 then
        BATTLE_AI:update()
    end
    --BATTLE_GUI:updateRegionInfoFade()
end


end