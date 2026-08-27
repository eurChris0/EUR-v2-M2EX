---@diagnostic disable: lowercase-global

-- Uncomment to use VSCode Lua Debugger
-- json = require "helpers/dkjson"
--local mobdebug = require "helpers/mobdebug"
--mobdebug.start('127.0.0.1', 8818)

to_log = true
collect_stats = false

dev_enabled = false
eur_main_scripts = true
eur_overrides = true

auto_turn = false
auto_turn_number = 74

chris_stuff = false

is_m2ex = false

Action = {}
function Action:new(func, waitTime, ...)
    newObj = {
        func = func or nil,
         -- store func pointer
        waitTime = waitTime,
         -- store time to wait
        waitEndTime = nil,
         -- we initialize end time later
        args = {...} or {}
     -- pack and store function args
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function Action:execute()
    self.func(unpack(self.args)) -- unpack all args and execute function
end

if not eur_main_scripts or not eur_overrides then
    -- table with our waiting functions
    ourWaitingFuncs = {}

    function waitingFuncsTick()
        local currTime = ImGui.GetTime() -- store time once in func
        for i = #ourWaitingFuncs, 1, -1 do -- check all actions
            if (ourWaitingFuncs[i].waitEndTime == nil) then -- if we not calc end time yet
                ourWaitingFuncs[i].waitEndTime = currTime + ourWaitingFuncs[i].waitTime --calc wait end time for function
            end
            if ourWaitingFuncs[i].waitEndTime <= currTime then -- if now time to execute function
                local currAction = table.remove(ourWaitingFuncs, i) -- table.remove removes our action from table and return it
                currAction:execute() -- execute action. Action destroyed when we out from this code block(it`s local)
            end
        end
    end

    function wait(functionName, sec, arg1, arg2, arg3, arg4, arg5) -- more arguments can be added
        table.insert(ourWaitingFuncs, Action:new(functionName, sec, arg1, arg2, arg3, arg4, arg5))
    end

        function onFactionTurnStart(eventData)
            if eventData.faction.isPlayerControlled == 1 then
                if auto_turn then
                    local campaign = M2TW.campaign
                    if campaign.turnNumber > 0 and campaign.turnNumber < auto_turn_number then
                        wait(end_turn, 0.5)
                    end
                end
            end
        end

        function end_turn()
            local financeScroll = gameSTDUI.getUiElement("end_turn");
            if financeScroll ~= nil then
                financeScroll:execute();
            end
        end
    end

--eurEOPUnits = require('eur/units/eurEOPUnits')
--eurEOPUnits_speed = require('eur/units/eurEOPUnits_speed')

if eur_main_scripts then


    require('eur/temp/listView')
    require('eur/dev/chrisDev')
    require('eur/chris_setts/chrisAddSetts')
    require('eur/chris_setts/chrisAddResBU')
    require('eur/temp/battleMap')
    require('helpers/EopLuaHelpers')
    require('eur/PoE/eurSupplyLines')
    require('eur/confed/eurRK')
    require('eur/upgrades/eurUnitCardLoc')
    
    -- EUR Helpers
    require('eur/helpers/eurGlobal')
    require('eur/keybinds/eurKeybinds')
    require("eur/eru/eurMapHelpers")
    require("eur/campaign/stuff")

    require('eur/loaded/eurImgLoad')
    require('eur/loaded/eurCasLoad')
    require('eur/loaded/eurSoundLoad')
    require('eur/loaded/eurFontLoad')

    require('eur/rebels/eurRebelSetup')
    require('eur/eurFactionSetup')
    require('eur/campaign/eurUniqueNames')
    
    require('eur/options/eurGameOptions')
    require('eur/options/eurOptions')

    require('eur/upgrades/eurUnitUpgradeDefault')
    require('eur/upgrades/eurUnitUpgradeList')
    require('eur/upgrades/eurUnitUpgrades')

    require('eur/eurEvent/eurEvents')

    require('eur/eurPreBattleOptions')

    require('eur/upgrades/eurGeneralBGSwapDefault')
    require('eur/upgrades/eurGeneralBGSwapList')
    require('eur/upgrades/eurGeneralBGSwapDefault2')
    require('eur/upgrades/eurGeneralBGSwapList2')
    require('eur/upgrades/eurGeneralBGSwapData')
    require('eur/upgrades/eurGeneralBGSwap')
    require('eur/upgrades/eurLeaderHeirSwap')
    require("eur/global_recruitment/eurGlobalRecruitment")
    require("eur/spoils/eurAltLoot")
    require("eur/eurAddCustomBGUnits")
    require("eur/eurDifficulty")
    require("eur/eurCustomGenerals")
    require("eur/eurEvolvingFactions")
    require("eur/eursetBattleMapPKG")
    require("eur/eurStatistics")
    require("eur/campaign/eurRevealAllied")
    require("eur/campaign/eurCampaignUIWidgets")
    require("eur/campaign/eurSpawnGeneral")
    require("eur/campaign/eurAssignFactionTraits")
    require("eur/campaign/eurReviveFactions")
    require("eur/battle/eurBattleAI")
    --require("eur/battle/eurbattleAiAssist")
    
    eurHelmsBrick = require('eur/helmsbrick/eurHelmsBrick')
    require("eur/campaign/eurGuilds")

    eurMerge = require('eur/army sort-merge/eurMergeArmies')
    require('eur/confed/eurSwapUnits')
    eurReplenishment = require('eur/replenishment/eurReplenishment')
    eurAddSpoils = require('eur/spoils/eurAddSpoils')
    eurConfed = require('eur/confed/eurConfed')
    eurSortStack = require('eur/army sort-merge/eurSortStack')
    EUR_UI_Swap = require("eur/confed/EUR_UI_Swap")
    require("eur/temp/EDU")
    --require('eur/temp/nazgul')
    
    require("eur/garrisons/eurGarrisonsList")
    require("eur/garrisons/eurGarrisons")
    

    -- Helper for managing persistence of tables across save/load
    require('helpers/tableSave')

    -- Our campaign config table.
    campaignConfig = { ["someConfigValue"] = 5 };

    -- Fires when loading a save file
    function onLoadSaveFile(paths)
        if to_log then
            M2TWEOP.logGame("EUR SCRIPT: ".."onLoadSaveFile");
        end
        campaignPopup = true;
        for index, path in pairs(paths) do
            if (string.find(path, "configTable.lua"))
            then
                -- Function from helper, load saved table
                campaignConfig = persistence.load(path);
            end
            if to_log then
                M2TWEOP.logGame("EUR SCRIPT: ".."loading eur persistent values");
            end
            if (string.find(path, "eurEventsData.lua"))
            then
            --function from helper, load saved table
            eurEventsData = persistence.load(path);
            if eurEventsData then
                if eur_main_scripts then
                    eurSaveLoadValues(false)
                end
            end
            end
            if to_log then
                M2TWEOP.logGame("EUR SCRIPT: ".."loading eur persistent values finished");
            end
        end
        if eur_main_scripts then
            show_options_restart_window = false
            wait(eurGlobalVars, 0.5)
        end
    end

    -- Fires when creating a save file
    -- Returns a list of M2TWEOP save files
    function onCreateSaveFile()
        local savefiles = {};
        currentPath = M2TWEOP.getPluginPath();

        -- Function from helper, save our table
        persistence.store(currentPath .. "configTable.lua", campaignConfig);

        savefiles[1] = currentPath .. "configTable.lua";
        if eur_main_scripts then
            eurSaveLoadValues(true)
        end
        persistence.store(currentPath.."eurEventsData.lua",eurEventsData);
        savefiles[2]=currentPath.."eurEventsData.lua";

        return savefiles;
    end
end

-- Fires when the plugin is first loaded at game start or restarted with restartLua()
function onPluginLoad()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: ".."onPluginLoad");
	end
    --M2TWEOP.unlockGameConsoleCommands();
    -- UNCOMMENT LINES BELOW TO ENABLE THEM
    --M2TWEOP.setAncillariesLimit(8);
    --M2TWEOP.setMaxBgSize(31);
    --M2TWEOP.setReligionsLimit(10);
    --M2TWEOP.setBuildingChainLimit(9);
    --M2TWEOP.setGuildCooldown(3);
    M2TWEOP.unlockGameConsoleCommands();
    -- UNCOMMENT TO ENABLE BELOW SETTINGS
    M2TWEOP.setAncillariesLimit(20);
    M2TWEOP.setMaxBgSize(60);
    -- M2TWEOP.setReligionsLimit(50);
    M2TWEOP.setBuildingChainLimit(15);
    M2TWEOP.setEDUUnitsSize(1,300);
    M2TWEOP.setGuildCooldown(5);
    M2TWEOP.unlockWeaponLimit()
    M2TWEOP.enableRangedWeaponUpg(true)
    M2TWEOP.setWeaponBonusModifier(1)
    M2TWEOP.setArmourUpgradeModifier(1)
    --M2TWEOP.setWatchTowerRange(15)
    if eur_main_scripts then
        loadStratCAS()
    end

    if scripting ~= nil and scripting.port() == "medieval2" then
        is_m2ex = true
    end

end

function onReadGameDbsAtStart()
    --eurEOPUnits.populateEDU()
end

function onGameInit()
    --[[local path = M2TWEOP.getModPath().."\\data\\data\\world\\maps\\campaign\\imperial_campaign\\unlocked.txt"

    local file = io.open(path, "r")
    if file then
        file:close()
        os.remove(path)
    end]]
    if eur_main_scripts then
        load_submod_config()
        --eurEOPUnits.populateEDB()
        if chris_stuff then
            if options_extraBGunits then
                addCustomBGToPool()
                enableExtraBG()
            end
        end
    end

end 

--- Called every time an image is rendered for display
--- Change hotkeys here
---@param pDevice LPDIRECT3DDEVICE9
function draw(pDevice)
    waitingFuncsTick()
    if (ImGui.IsKeyPressed(ImGuiKey.GraveAccent))
    and (ImGui.IsKeyDown(ImGuiKey.LeftCtrl))
    then
        M2TWEOP.toggleConsole()
    elseif (ImGui.IsKeyPressed(ImGuiKey.GraveAccent))
    and (ImGui.IsKeyDown(ImGuiKey.LeftAlt))
    then
        M2TWEOP.toggleDeveloperMode()
    end
    -- 
    if dev_enabled then
        devButton()
        --setEMT()
    end
    if show_alt_loot and won_battle_alt then
        altLootWindow()
    end
    --
    if show_hotseat_msg then
        showHotSeatMSG()
    end
    if eur_main_scripts then
        if options_pre_battle then
            if eur_pre_battle then
                preBattleButton()
            end
            if eur_pre_battle_window then
                preBattleWindow()
            end
        end
        if eurbackgroundWindowSizeRight == 0 then
            calcWindow()
        end
        if show_options_restart_window then
            optionsRestart()
        end
        if in_campaign_map == true then
            tooltipAtCoord()
            --supplyTooltip()
            if (ImGui.IsKeyPressed(ImGuiKey.Escape)) then
                if not options_first_run then
                    if show_options_window then
                        show_options_window = false
                        saveOptions()
                    end
                end
                for k, v in pairs(window_states) do
                    window_states[k] = false
                end
            end

            if (ImGui.IsKeyPressed(ImGuiKey.X)) 
            and (ImGui.IsKeyDown(ImGuiKey.LeftCtrl)) then
                if not options_first_run then
                    if show_options_window then
                        show_options_window = false
                    else
                        temp_target = 0
                        player_units_target = 1
                        show_options_window = true
                    end
                end
            end
            --noAttack()
            if not diplo_open then
                checkcard()
                --eventsButton()
                if not is_m2ex then
                    showFinUIextra()
                end
            end
            --eurMapTooltips()
            if options_gen_upgrades then
                if not show_leg_notif then
                    if show_genenabled then
                        optionsGenUPEnabled()
                    end
                end
            end
            if show_options_accept then
                optionsAccept()
            end
            if options_unit_upgrades then
                if window_states.show_upgrade_window == true then
                    if not diplo_open then
                        upgradeWindow()
                    end
                end
            end
            if show_unitscroll_tooltip then
                --showUnitScrollextra()
            end
            if show_events_window == true then
                --eventsWindow()
            end
            if show_options_button == true then
                optionsButton()
            end
            if show_options_window == true then
                optionsWindow()
            end
            if show_leg_notif == true then
                optionsLegendaryChoice()
            end
            if swap_bg_button == true then
                if game_options.global_recruitment then
                    globalRecruitButton()
                end
                reviveFactionButton()
            end
            if show_revive_choice then
                reviveFactionChoice()
            end
            if not show_bg_accept then
                if window_states.swap_bg_window == true then
                    swapBGWindow()
                end
            end
            if show_bg_accept then
                bgSwapAccept()
            end
            if show_ug_accept then
                ugSwapAccept()
            end
            if window_states.show_globalrecruit_window == true then
                if game_options.global_recruitment then
                    globalRecruitWindow()
                end
            end
            if build_forts then
                if show_buildfort then
                    buildFortButton()
                    if show_fortaccept then
                        buildFortAccept()
                    end
                end
            end
            if show_kon_choice then
                KoNChoiceWindow()
            end
            if show_eregion_choice then
                KoEChoiceWindow()
            end
            if show_settUI and not is_m2ex then
                showSettUIExtra()
            end
            --checkGarrison()
        else
            if game_options.show_speed_ui then
                battleOverviewWindow()
            end
        end
        if (ImGui.IsKeyPressed(ImGuiKey.X)) then
            tacticalViewUp()
        elseif (ImGui.IsKeyPressed(ImGuiKey.Z)) then
            tacticalViewDown()
        elseif (ImGui.IsKeyPressed(ImGuiKey.Q)) 
        and (ImGui.IsKeyDown(ImGuiKey.LeftCtrl)) and not is_m2ex then
            BMapHighlight()
        elseif (ImGui.IsKeyPressed(ImGuiKey.P)) 
        and (ImGui.IsKeyDown(ImGuiKey.LeftCtrl)) then
            if not dev_enabled then
                --dev_enabled = true
            else
                --dev_enabled = false
            end
        end
    end

    

end
