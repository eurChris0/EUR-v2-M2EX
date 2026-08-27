require('eur/helpers/eurHistoricEventText')
require('eur/options/eurOptionsUpgrades')
--require('eur/options/eurOptionsUpgrades')

local beta_intro = 
[[Welcome to the Epic Unity Rework V2 beta. This is a pre-release build and subject to change, please do not discuss specifics of the beta outside of the beta testing channels.

Feel free to discuss or feedback on the beta in the general-test channel, we have introduced several new EOP scripts and are looking for feedback and testing on these specifically. 

Testing focus
]]
local beta_focus = 
[[

]]
local beta_changelog = 
[[Changelog: 

]]

local turks_sicily_confed = false
local show_bg_size_text = false

temp_options_tree = {
    ["campaign"] = false,
    ["difficulty"] = false,
    ["font"] = false,
    ["replen"] = false,
    ["genup"] = false,
    ["unitup"] = false,
    ["prebat"] = false,
    ["poe"] = false,
}

temp_options_selected = {
    ["campaign"] = false,
    ["difficulty"] = false,
    ["font"] = false,
    ["replen"] = false,
    ["genup"] = false,
    ["unitup"] = false,
    ["prebat"] = false,
    ["poe"] = false,
}

temp_options_show = {
    ["campaign"] = false,
    ["difficulty"] = false,
    ["font"] = false,
    ["replen"] = false,
    ["genup"] = false,
    ["unitup"] = false,
    ["prebat"] = false,
    ["poe"] = false,
}

temp_event_selected = {
    ["turks"] = {
        ["Northern Dúnedain"] = true,
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ND_TITLE] = false,
    },
    ["russia"] = {
        ["Alternate Start"] = true,
        ["Welcome to EUR V2"] = false,
        [UMBAR_START_TITLE] = false,
    },
    ["milan"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ROHAN_TITLE] = false,
    },
    ["sicily"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_GONDOR_TITLE] = false,
    },
    ["scotland"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DALE_TITLE] = false,
    },
    ["byzantium"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DORWINION_TITLE] = false,
    },
    ["timurids"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ANDUIN_TITLE] = false,
    },
    ["portugal"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ANGMAR_TITLE] = false,
    },
    ["aztecs"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DUNLAND_TITLE] = false,
    },
    ["teutonic_order"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ENEDWAITH_TITLE] = false,
    },
    ["spain"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_HARAD_TITLE] = false,
    },
    ["khand"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_KHAND_TITLE] = false,
    },
    ["venice"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_RHUN_TITLE] = false,
    },
    ["norway"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_KD_TITLE] = false,
    },
    ["hungary"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_EL_TITLE] = false,
    },
    ["moors"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_EREBOR_TITLE] = false,
    },
    ["mongols"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_WR_TITLE] = false,
    },
    ["ireland"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_LORIEN_TITLE] = false,
    },
    ["denmark"] = {
        ["Welcome to EUR V2"] = false,
        ["Faction Info: Lindon"] = false,
    },
    ["england"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_MORDOR_TITLE] = false,
    },
    ["poland"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DG_TITLE] = false,
    },
    ["hre"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_MORIA_TITLE] = false,
    },
    ["gundabad"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_GUNDABAD_TITLE] = false,
    },
    ["france"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ISENGARD_TITLE] = false,
    },
    ["saxons"] = {
        ["Welcome to EUR V2"] = false,
        ["Faction Info: Imladris"] = false,
    },
}

temp_event_show = {
    ["turks"] = {
        ["Northern Dúnedain"] = true,
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ND_TITLE] = false,
    },
    ["russia"] = {
        ["Alternate Start"] = true,
        ["Welcome to EUR V2"] = false,
        [UMBAR_START_TITLE] = false,
    },
    ["milan"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ROHAN_TITLE] = false,
    },
    ["sicily"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_GONDOR_TITLE] = false,
    },
    ["scotland"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DALE_TITLE] = false,
    },
    ["byzantium"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DORWINION_TITLE] = false,
    },
    ["timurids"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ANDUIN_TITLE] = false,
    },
    ["portugal"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ANGMAR_TITLE] = false,
    },
    ["aztecs"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DUNLAND_TITLE] = false,
    },
    ["teutonic_order"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ENEDWAITH_TITLE] = false,
    },
    ["spain"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_HARAD_TITLE] = false,
    },
    ["khand"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_KHAND_TITLE] = false,
    },
    ["venice"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_RHUN_TITLE] = false,
    },
    ["norway"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_KD_TITLE] = false,
    },
    ["hungary"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_EL_TITLE] = false,
    },
    ["moors"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_EREBOR_TITLE] = false,
    },
    ["mongols"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_WR_TITLE] = false,
    },
    ["ireland"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_LORIEN_TITLE] = false,
    },
    ["denmark"] = {
        ["Welcome to EUR V2"] = false,
        ["Faction Info: Lindon"] = false,
    },
    ["england"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_MORDOR_TITLE] = false,
    },
    ["poland"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_DG_TITLE] = false,
    },
    ["hre"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_MORIA_TITLE] = false,
    },
    ["gundabad"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_GUNDABAD_TITLE] = false,
    },
    ["france"] = {
        ["Welcome to EUR V2"] = false,
        [FACTION_INFO_ISENGARD_TITLE] = false,
    },
    ["saxons"] = {
        ["Welcome to EUR V2"] = false,
        ["Faction Info: Imladris"] = false,
    },
}

function optionsButtonSound()
    if options_pre_battlepressed or
        options_poepressed or
        random_poepressed or
        kon_start_ai_eregionpressed or
        speeduipressed or
        disable_skirmishpressed or
        playeronlymodspressed or
        brigandControllerTargetSettlementsEnabledpressed or
        forceNavalInvasionspressed or
        orderoffsetpressed or
        aiboostpressed or
        upkeeppressed or
        evolvepressed or
        revalliedpressed or
        unlimited_revivalpressed or
        global_waystation_reqpressed or
        global_waystation_inc_maxpressed or
        global_recruitmentspressed or
        sortpressed or
        clicked or
        clicked2 or
        options_replen_costspressed or
        options_replen_beastpressed or
        replen_alwayspressed or
        options_replenpressed or
        evolvepressed or
        fortspressed or
        options_addspoilspressed or
        options_mergepressed or
        auto_saves_enabledspressed or
        eregion_spawn_spressed or
        convert_buildingspressed or
        garrisonspressed or
        options_general_large_armypressed or
        show_gen_unit_cardpressed or
        options_unit_upgradespressed or
        ai_unit_upgradespressed or
        genuppressed or
        global_morale_boostpressed or
        global_recruitment_localonlypressed or
        global_recruitment_hidenounitspressed or
        airevivalpressed or
        genpositionpressed or
        genupt2pressed or
        upg_unit_upgradespressed or
        sdg_unit_upgradespressed or
        options_pre_battlepressed then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
end

function optionsButton()
    ImGui.SetNextWindowPos(1170*eurbackgroundWindowSizeRight, 90*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(70, 70)
    ImGui.Begin("options_button_01", true, bit.bor(ImGuiWindowFlags.NoDecoration,ImGuiWindowFlags.NoBackground))
    eurStyle("basic_5", true)
    if icon_options then
        if ImGui.ImageButton("options_button_1",icon_options.img,50*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeRight) then
            if show_options_window == false then
                temp_target = 0
                player_units_target = 1
                show_options_window = true
                M2TWEOP.scriptCommand("play_sound_event", "STRAT_SCROLL_OPENS")
            else
                show_options_window = false
                M2TWEOP.scriptCommand("play_sound_event", "STRAT_SCROLL_CLOSES")
            end
        end
        local hovered = ImGui.IsItemHovered()
        if hovered then
            eurStyle("tooltip", true)
            ImGui.BeginTooltip()
            ImGui.Text("EUR Options")
            ImGui.EndTooltip()
            eurStyle("tooltip", false)
        end
    else
        --
    end
    eurStyle("basic_5", false)
    ImGui.End()
end

show_pw_ok = false


function optionsWindow()
    if not gen_set then
        gen_units_list = {}
        if game_options.BG_T2 then
            for k, v in pairs(gen_units_list_default2) do
                gen_units_list[k] = v
            end
        else
            for k, v in pairs(gen_units_list_default) do
                gen_units_list[k] = v
            end
        end
        UNIT_UPGRADES = {}
        for k, v in pairs(UNIT_UPGRADES_default) do
            UNIT_UPGRADES[k] = v
        end
        gen_set = true
    end
    local temp_i = 0
    local temp_pos_x = {}
    local temp_pos_y = {}
    local pos_x, pos_y = 0,0
    local show_additional = false
    ImGui.SetNextWindowPos(0*eurbackgroundWindowSizeRight, 0)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(1920*eurbackgroundWindowSizeRight, 1080*eurbackgroundWindowSizeBottom)
    ImGui.Begin("options_window_background", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    ImGui.SetWindowFontScale(1.2*eurbackgroundWindowSizeRight)
    eurStyle("options_1", true)
    if bg_1_new then
        ImGui.Image(bg_1_new.img,1920*eurbackgroundWindowSizeRight, 1080*eurbackgroundWindowSizeBottom)
    end

    ImGui.SetNextWindowPos(420*eurbackgroundWindowSizeRight, 200*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.BeginChild("Child Window_options_1", 1080*eurbackgroundWindowSizeRight, 715*eurbackgroundWindowSizeBottom)
    
    if (ImGui.BeginTabBar("options_tabbar_1")) then
        if (ImGui.BeginTabItem("Welcome##01")) then
            ImGui.SetNextWindowBgAlpha(0)
            ImGui.BeginChild("Child Window_options_subtab_1", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
            ImGui.NewLine()
            ImGui.Image(welcome_beta.img, 472*eurbackgroundWindowSizeRight, 72*eurbackgroundWindowSizeBottom)
            
            ImGui.NewLine()
            ImGui.Image(welcome_text.img, 965*eurbackgroundWindowSizeRight, 430*eurbackgroundWindowSizeBottom)
            ImGui.EndChild()
            ImGui.EndTabItem()
        end
        if (ImGui.BeginTabItem("Settings##01")) then
            if (ImGui.BeginTabBar("options_tabbar_2")) then
                if (ImGui.BeginTabItem("Campaign##01")) then
                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.BeginChild("Child Window_options_tab_1_Campaign", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                    --ImGui.NewLine()
                    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
                    if options_first_run then
                        if ImGui.Button("Restore default settings") then
                            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                            restoreDefaultSettings()
                        end
                    end
                    hoveredSimple("Restores the default settings for this menu and not those saved from previous campaigns.")
                    optionsCampaign(true)
            
                    ImGui.EndChild()
                    
                    ImGui.EndTabItem()
                end

                if (ImGui.BeginTabItem("Campaign Extra##01")) then
                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.BeginChild("Child Window_options_tab_1_modifiers", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                    --ImGui.NewLine()
                    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
                    ImGui.PushItemWidth(500)
                    optionsSpeed()
                    ImGui.NewLine()
                    ImGui.Separator()
                    ImGui.NewLine()
                    optionsCampaignExtra()
                    ImGui.PopItemWidth()
                    ImGui.EndChild()
                    ImGui.EndTabItem()
                end
                if (ImGui.BeginTabItem("Battle##01")) then
                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.BeginChild("Child Window_options_tab_1_battle", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
                    optionsBattle()
                    ImGui.EndChild()
                    ImGui.EndTabItem()
                end
                if (ImGui.BeginTabItem("Difficulty##01")) then
                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.BeginChild("Child Window_options_tab_1_Difficulty", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                    --ImGui.NewLine()
                    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
                    optionsDifficulty(true)

                    ImGui.EndChild()
                    ImGui.EndTabItem()
                end
                if (ImGui.BeginTabItem("Upgrades##01")) then
                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.BeginChild("Child Window_options_tab_1_Upgrades", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                    --ImGui.NewLine()
                    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)

                    optionsUpgrades()

                    ImGui.EndChild()
                    ImGui.EndTabItem()
                end
                if collect_stats then
                    if (ImGui.BeginTabItem("Stats##01")) then
                        ImGui.SetNextWindowBgAlpha(0)
                        ImGui.BeginChild("Child Window_options_tab_1_stats", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                        --ImGui.NewLine()
                        ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)

                        drawStats()

                        ImGui.EndChild()
                        ImGui.EndTabItem()
                    end
                end
                --[[if ELVEN_FACTIONS[eur_localFactionName] then
                    if (ImGui.BeginTabItem("Passing of the Elves##01")) then
                        ImGui.SetNextWindowBgAlpha(0)
                        ImGui.BeginChild("Child Window_options_tab_1_poe", 1450*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                        --ImGui.NewLine()
                        ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)

                        optionsPOE(true)

                        ImGui.EndChild()
                        ImGui.EndTabItem()
                    end
                end]]
                if options_first_run then
                    if eur_player_faction.name == "russia" then
                        if (ImGui.BeginTabItem("Alternate Start##01")) then
                            ImGui.SetNextWindowBgAlpha(0)
                            ImGui.BeginChild("Child Window_options_tab_1_aaalt", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                            --ImGui.NewLine()
                            ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)

                            welcomeAA()
                            ImGui.SameLine()
                            optionsSideWindow1()

                            ImGui.EndChild()
                            ImGui.EndTabItem()
                        end
                    end
                    
                end



                if chris_stuff then
                    if (ImGui.BeginTabItem("Chris Submod##01")) then
                        ImGui.SetNextWindowBgAlpha(0)
                        ImGui.BeginChild("Child Window_options_tab_1_chris", 1080*eurbackgroundWindowSizeRight, 615*eurbackgroundWindowSizeBottom)
                        --ImGui.NewLine()
                        ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
                        optionsChrisStuff()

                        ImGui.EndChild()
                        ImGui.EndTabItem()
                    end
                end
                ImGui.EndTabBar()
            end

            ImGui.EndTabItem()
        end
        if (ImGui.BeginTabItem("Credits##01")) then
            --ImGui.Text("credits go here")
            ImGui.NewLine()
            ImGui.Image(credits_text.img, 1030*eurbackgroundWindowSizeRight, 1300*eurbackgroundWindowSizeBottom)
            ImGui.EndTabItem()
        end
        ImGui.EndTabBar()
    end

    ImGui.EndChild()
    if (centeredImageButton("Close me", 200*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, 0)) then
        if options_first_run then
            --show_options_window = false
            show_options_accept = true
            saveOptions()
        else
            show_options_window = false
            setGameOptions()
        end
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    eurStyle("options_1", false)
    ImGui.End()
    optionsButtonSound()
end

function optionsAccept()
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(610*eurbackgroundWindowSizeRight, 310*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowPos(660*eurbackgroundWindowSizeRight, 350*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowFocus()
    ImGui.Begin("options_accept_background", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    if faction_bg[M2TWEOP.getCultureName(eur_player_faction.cultureID)] then
        ImGui.Image(faction_accept[M2TWEOP.getCultureName(eur_player_faction.cultureID)].img, 600*eurbackgroundWindowSizeRight, 300*eurbackgroundWindowSizeBottom)
    end
    eurStyle("basic_4", true)
    ImGui.SetNextWindowPos(710*eurbackgroundWindowSizeRight, 380*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.4)
    ImGui.BeginChild("options_acceptChild Window##A15", 500*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    --ImGui.Dummy(0*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeRight)
    centeredText("Accept and start campaign?",0)
    ImGui.SetNextWindowPos(710*eurbackgroundWindowSizeRight, 510*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.BeginChild("options_acceptChild Window##A16", 500*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    if (centeredImageButton("Yes", 80*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, -40*eurbackgroundWindowSizeRight)) then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        correctCoords()
        show_options_accept = false
        show_options_window = false
        options_first_run = false
        setBGSize(eur_player_faction, nil, nil)
        genEDUcheck()
        setGameOptions()
        if game_options.supplies then
            M2TWEOP.setScriptCounter("supplies_eur", 1)
        end
        if game_options.global_morale_boost then
            globalMoraleIncrease(game_options.morale_value)
        end
        EDU_MODIFIERS:updateDescriptions()
        local camdifficulty = M2TWEOP.getOptions2().campaignDifficulty
        if camdifficulty == 0 then
            eur_player_faction.kingsPurse = eur_player_faction.kingsPurse + 750
            stratmap.game.callConsole("add_money", "-" .. tostring(3000))
            
            M2TWEOP.setScriptCounter("game_easy", 1)
        elseif camdifficulty == 1 then
            eur_player_faction.kingsPurse = eur_player_faction.kingsPurse + 500
            stratmap.game.callConsole("add_money", "-" .. tostring(1500))
            M2TWEOP.setScriptCounter("game_medium", 1)
        elseif camdifficulty == 2 then
            eur_player_faction.kingsPurse = eur_player_faction.kingsPurse + 250
            M2TWEOP.setScriptCounter("game_hard", 1)
        else
            M2TWEOP.setScriptCounter("game_very_hard", 1)
        end
        M2TWEOP.setWatchTowerRange(watchtower_range)
        if eur_player_faction.name == "russia" then
            repostionAA()
        end
        if game_options.options_usemods then
            defaultEDUOffset()
        end
        if options_legendary then
            editTrait()
            orderOffset()
            defaultEDUOffset_leg()
            legendaryGarrisons()
            player_start_threshold = 8 --generals bg level threshold
        end
        if not options_extrabu then
            economyModifiers()
        else
            M2TWEOP.setScriptCounter("options_extrabu", 1)
        end
        if game_options.siege_messages then
            M2TWEOP.setScriptCounter("sieged_messages", 1)
        else
            M2TWEOP.setScriptCounter("sieged_messages", 0)
        end
        playerSetup()
        if misc_options.eregion_start then
            show_eregion_choice = true
            clearMSG()
        end
        if misc_options.kon_start then
            show_kon_choice = true
        end
        if eur_player_faction.name == "egypt" then
            spawnEregionHorde(false)
            M2TWEOP.unlockGameConsoleCommands()
            M2TWEOP.callConsole("kill_faction", "egypt")
        end
    end
    ImGui.SameLine()
    if (centeredImageButton("No", 80*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, 40*eurbackgroundWindowSizeRight)) then
        show_options_window = true
        show_options_accept = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    ImGui.EndChild()
    ImGui.EndChild()
    eurStyle("basic_4", false)
    ImGui.End()
end


function optionsLegendaryChoice()
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(610*eurbackgroundWindowSizeRight, 310*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowPos(660*eurbackgroundWindowSizeRight, 350*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowFocus()
    ImGui.Begin("options_legchoice_main", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    if faction_bg[M2TWEOP.getCultureName(eur_player_faction.cultureID)] then
        ImGui.Image(faction_accept[M2TWEOP.getCultureName(eur_player_faction.cultureID)].img, 600*eurbackgroundWindowSizeRight, 300*eurbackgroundWindowSizeBottom)
    end
    eurStyle("basic_4", true)
    ImGui.SetNextWindowPos(710*eurbackgroundWindowSizeRight, 380*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.4)
    ImGui.BeginChild("options_legchoice Window##A15", 500*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    --ImGui.Dummy(0*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeRight)
    centeredText("Enable Legendary difficulty?",0)

    ImGui.SetNextWindowPos(710*eurbackgroundWindowSizeRight, 510*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.BeginChild("options_legchoice Window##A16", 500*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    if (centeredImageButton("Yes", 80*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, -40*eurbackgroundWindowSizeRight)) then
        legendaryToggle(true)
        show_leg_notif = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    ImGui.SameLine()
    if (centeredImageButton("No", 80*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, 40*eurbackgroundWindowSizeRight)) then
        show_leg_notif = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    ImGui.EndChild()
    ImGui.EndChild()
    eurStyle("basic_4", false)
    ImGui.End()
end

function showHotSeatMSG()
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(400*eurbackgroundWindowSizeRight, 150*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowPos(760*eurbackgroundWindowSizeRight, 440*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowFocus()
    ImGui.Begin("options_hotseat_background", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    eurStyle("basic_6", true)
    ImGui.SetNextWindowBgAlpha(1)
    ImGui.BeginChild("options_hotseatWindow##A15", 400*eurbackgroundWindowSizeRight, 150*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    ImGui.Dummy(0*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeRight)
    centeredText("Hotseat campaigns are not officially supported, all EOP scripted events are disabled, player experience may vary.",0)

    if (centeredImageButton("Ok", 80*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, 0)) then
        --show_options_window = true
        show_hotseat_msg = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    ImGui.EndChild()
    eurStyle("basic_6", false)
    ImGui.End()
end

function optionsbetaBlock()
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(400*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowPos(1520*eurbackgroundWindowSizeRight, 830*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowFocus()
    ImGui.Begin("options_wrongpw_main", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    if faction_bg[M2TWEOP.getCultureName(eur_player_faction.cultureID)] then
        ImGui.Image(faction_accept[M2TWEOP.getCultureName(eur_player_faction.cultureID)].img, 600*eurbackgroundWindowSizeRight, 300*eurbackgroundWindowSizeBottom)
    end
    eurStyle("basic_4", true)
    ImGui.SetNextWindowBgAlpha(1)
    ImGui.BeginChild("options_wrongpw Window##A15", 400*eurbackgroundWindowSizeRight, 150*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    ImGui.Dummy(0*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeRight)
    centeredText("Wrong password",0)

    eurStyle("basic_4", false)
    ImGui.EndChild()
    ImGui.End()
end

function optionsGenUPEnabled()
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(610*eurbackgroundWindowSizeRight, 310*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowPos(660*eurbackgroundWindowSizeRight, 350*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowFocus()
    ImGui.Begin("options_acceptChild Window##A15", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    if faction_bg[M2TWEOP.getCultureName(eur_player_faction.cultureID)] then
        ImGui.Image(faction_accept[M2TWEOP.getCultureName(eur_player_faction.cultureID)].img, 600*eurbackgroundWindowSizeRight, 300*eurbackgroundWindowSizeBottom)
    end
    eurStyle("basic_4", true)
    ImGui.SetNextWindowPos(710*eurbackgroundWindowSizeRight, 380*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.4)
    ImGui.BeginChild("options_acceptChild Window##A15", 500*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
   -- ImGui.Dummy(0*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeRight)
    centeredText("General Upgrades are enabled, any general using the generic faction bodyguard will be swapped for a T1 or T2 unit from the upgrade list, you may change this setting in the Upgrades tab.", 0)
    ImGui.Dummy(160*eurbackgroundWindowSizeRight,0)
    ImGui.SameLine()
    if eur_player_faction ~= nil then
        if default_general_units[eur_player_faction.name] ~= nil then
            if eur_tga_table[M2TWEOPDU.getEduEntryByType(default_general_units[eur_player_faction.name].old).unitCardTga] ~= nil then
                ImGui.Image(eur_tga_table[M2TWEOPDU.getEduEntryByType(default_general_units[eur_player_faction.name].old).unitCardTga].img,img_x, img_y)
            end
        end
    end
    ImGui.SameLine()
    ImGui.Text(" > ")
    ImGui.SameLine()
    if eur_player_faction ~= nil then
        if gen_units_list ~= nil then
            if gen_units_list[eur_player_faction.name] ~= nil then
                if gen_units_list[eur_player_faction.name]["T1"][1] ~= nil then
                    local edu = M2TWEOPDU.getEduEntryByType(gen_units_list[eur_player_faction.name]["T1"][1])
                    if edu ~= nil then
                        if eur_tga_table[edu.unitCardTga] ~= nil then
                            ImGui.Image(eur_tga_table[edu.unitCardTga].img,img_x, img_y)
                        end
                    end
                end
            end
        end
    end
    ImGui.SetNextWindowPos(710*eurbackgroundWindowSizeRight, 530*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.BeginChild("options_acceptChild Window##A16", 500*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    if (centeredImageButton("Ok", 80*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, 0)) then
        --show_options_window = true
        show_genenabled = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    ImGui.EndChild()
    ImGui.EndChild()
    eurStyle("basic_4", false)
    ImGui.End()
end

function optionsRestart()
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(400*eurbackgroundWindowSizeRight, 150*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowPos(760*eurbackgroundWindowSizeRight, 440*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowFocus()
    ImGui.Begin("options_restart_background", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    eurStyle("basic_6", true)
    ImGui.SetNextWindowBgAlpha(1)
    ImGui.BeginChild("options_restart Window##A15", 400*eurbackgroundWindowSizeRight, 150*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    ImGui.Dummy(0*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeRight)
    centeredText("Please restart the game before beginning a new campaign.",0)

    if (centeredImageButton("Ok", 80*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom, 0)) then
        --show_options_window = true
        show_options_restart_window = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    ImGui.EndChild()
    eurStyle("basic_6", false)
    ImGui.End()
end

--[[
function hoveredCheck(element, show_list, selected_list)
    local hovered = ImGui.IsWindowHovered(ImGuiHoveredFlags.ChildWindows)
    if hovered then
        clickedleft = ImGui.IsMouseClicked(ImGuiMouseButton.Left, false)
        if clickedleft then
            if not selected_list[element] then
                for k, v in pairs(selected_list) do
                    if v then
                        selected_list[k] = false
                    end
                end
                for k, v in pairs(show_list) do
                    show_list[k] = false
                end
                show_list[element] = true
                selected_list[element] = true
            else
                selected_list[element] = false
                show_list[element] = false
            end
        end
        local is_selected = false
        for k, v in pairs(selected_list) do
            if v then
                is_selected = true
            end
        end
        if not is_selected then
            for k, v in pairs(show_list) do
                v = false
            end
            show_list[element] = true
        end
    else
        local is_selected = false
        for k, v in pairs(selected_list) do
            if v then
                is_selected = true
            end
        end
        if not is_selected then
            for k, v in pairs(show_list) do
                v = false
            end
            show_list[element] = false
        end
    end

end]]





function optionsPrebattle(bool)
    if bool then


            options_pre_battle, options_pre_battlepressed = ImGui.Checkbox("Enabled##prebat001", options_pre_battle)
            
        
    else
            ImGui.Text("Pre-battle Options")
            ImGui.BulletText("Split a unit for the upcoming battle.")
            ImGui.NewLine()

    end
end

function optionsPOE(bool)
    if not ELVEN_FACTIONS[eur_localFactionName] then return end
    if bool then

            options_poe, options_poepressed = ImGui.Checkbox("Enabled##poe01", options_poe)
            random_poe, random_poepressed = ImGui.Checkbox("Random turns", random_poe)
            if random_poe then
                ImGui.Text("Turns: "..tostring(poe_turns_min).." to "..tostring(poe_turns_max))
            else
                ImGui.Text("Turns: "..tostring(poe_turns_max))
            end
            if random_poe then
                ImGui.Text("Min:")
                if (ImGui.Button("-##01", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    if poe_turns_min > 1 then
                        if poe_turns_min <= poe_turns_max then
                            poe_turns_min=poe_turns_min-1
                        end
                    end
                end
                ImGui.SameLine()
                ImGui.Text(tostring(poe_turns_min))
                ImGui.SameLine()
                if (ImGui.Button("+##01", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    if poe_turns_min < 8 then
                        if poe_turns_min < poe_turns_max then
                            poe_turns_min=poe_turns_min+1
                        end
                    end
                end
            end
            if random_poe then
                ImGui.Text("Max:")
            end
            if (ImGui.Button("-##02", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if poe_turns_max > 1 then
                    if poe_turns_max > poe_turns_min then
                        poe_turns_max=poe_turns_max-1
                    end
                end
            end
            ImGui.SameLine()
            ImGui.Text(tostring(poe_turns_max))
            ImGui.SameLine()
            if (ImGui.Button("+##02", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if poe_turns_max < 8 then
                    if poe_turns_max >= poe_turns_min then
                        poe_turns_max=poe_turns_max+1
                    end
                end
            end

        
    else
            ImGui.Text("Passing of the Elves")
            ImGui.BulletText("Long desc here.")
            ImGui.NewLine()
            ImGui.Text("Options:")
            ImGui.BulletText("Frequency of passings(turns).")
            ImGui.BulletText("Change to random frequency(min-max turns).")
            ImGui.NewLine()
    end
end

function optionsFont(bool)

end

function optionsCampaign(bool)
    ImGui.PushItemWidth(500)
    ImGui.BeginGroup()
    ImGui.Image(rep_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
    ImGui.EndGroup()
    local hovered = ImGui.IsItemHovered()
    if hovered then
        eurStyle("tooltip", true)
        ImGui.BeginTooltip()
        ImGui.Text("Replenishment")
        ImGui.BulletText("All units replenish over the end turn(player and AI).")
        ImGui.BulletText("Default only garrisoned units.")
        ImGui.BulletText("Default beast units disabled(Trolls, Ents ect).")
        ImGui.BulletText("Variable replenishment based on location and unit size.")
        ImGui.BulletText("No replenishment for ships.")
        ImGui.EndTooltip()
        eurStyle("tooltip", false)
    end
    --ImGui.NewLine()
    ImGui.PushItemWidth(500)
        options_replen, options_replenpressed = ImGui.Checkbox("Enabled##01", options_replen)
        hoveredSimple("Enable replenishment.")
        options_replen_beast, options_replen_beastpressed = ImGui.Checkbox("Low Entity Units", options_replen_beast)
        hoveredSimple("Enables replenishment for low entity units such as Trolls, Ents, Skin-changers ect.")
        replen_always, replen_alwayspressed = ImGui.Checkbox("Field Replenishment", replen_always)
        hoveredSimple("Enables replenishment for non-garrisoned armies.")
        if options_replen_beast then
            replen_beast_value = 0
        else
            replen_beast_value = 10
        end
        options_replen_costs, options_replen_costspressed = ImGui.Checkbox("Replenishment costs gold", options_replen_costs)
        hoveredSimple("Enable gold deduction for replenishment, based on recruitment cost.")
        if options_replen_costs then
            replen_cost_multi = ImGui.SliderInt("Replenishment cost multiplier", replen_cost_multi, 10, 100, "%d%%")
            hoveredSimple("Default 50%%(half cost).")
        end
        local replen_multi      = round_half(safe_divide(100, replen_values.replen_multi))
        local replen_aquaduct = round_half(safe_divide(100, replen_values.aquaduct_bonus))
        local replen_waystation = round_half(safe_divide(100, replen_values.waystation_bonus))
        local replen_paved      = round_half(safe_divide(100, replen_values.replen_road_level[2]))
        local replen_dirt       = round_half(safe_divide(100, replen_values.replen_road_level[1]))
        local replen_trade      = round_half(safe_divide(100, replen_values.replen_road_level[3]))
        local replen_allied     = round_half(safe_divide(100, replen_values.replen_field_own))
        local replen_nonallied  = round_half(safe_divide(100, replen_values.replen_field_other))  
        local gobbo_bonus = round_half(safe_divide(100, replen_values.goblin_bonus)) 
        local men_bonus = round_half(safe_divide(100, replen_values.men_bonus)) 
        local global_bonus = round_half(safe_divide(100, replen_values.replen_bonus)) 
        ImGui.PushStyleColor(ImGuiCol.HeaderHovered,1, 1, 1, 0)
        ImGui.PushStyleColor(ImGuiCol.Header,1, 1, 1, 0)
        ImGui.PushStyleColor(ImGuiCol.HeaderActive,1, 1, 1, 0.0)
        ImGui.PushStyleColor(ImGuiCol.Border, 1, 1, 1, 0)
        if (ImGui.CollapsingHeader("Advanced Options##replen01")) then
            global_bonus = ImGui.SliderInt("Flat Global Bonus", global_bonus, 0, 50, "%d%%")
            hoveredSimple("Global bonus applies to all multipliers.")
            ImGui.Text("Individual multipliers.")
            replen_multi = ImGui.SliderInt("Garrisoned rate", replen_multi, 0, 15, "%d%%")
            hoveredSimple("Applies if a unit is garrisoned in a settlement or fort.")
            replen_waystation = ImGui.SliderInt("Waystation bonus", replen_waystation, 0, 15, "%d%%")
            hoveredSimple("Applies if the Waystation building is present in the settlement.")
            replen_aquaduct = ImGui.SliderInt("Health bonus", replen_aquaduct, 0, 15, "%d%%")
            hoveredSimple("Applies if the second level Health building is present in the settlement.")
            replen_dirt = ImGui.SliderInt("Dirt roads", replen_dirt, 0, 15, "%d%%")
            hoveredSimple("Applies if dirt roads are present in the region.")
            replen_paved = ImGui.SliderInt("Paved roads", replen_paved, 0, 15, "%d%%")
            hoveredSimple("Applies if paved roads are present in the region.")
            replen_trade = ImGui.SliderInt("Highways", replen_trade, 0, 15, "%d%%")
            hoveredSimple("Applies if trade route(Highways) are present in the region.")
            ImGui.Text("Field Values")
            replen_allied = ImGui.SliderInt("Own / Allied territory", replen_allied, 0, 15, "%d%%")
            hoveredSimple("Base rate for field armies in friendly territory, road level also applies.")
            replen_nonallied = ImGui.SliderInt("Enemy / Neutral territory", replen_nonallied, 0, 15, "%d%%")
            hoveredSimple("Base rate for field armies in non-friendly territory, road level also applies.")
            if eur_player_faction ~= nil then
                if tableContains(goblin_factions, eur_player_faction.name) then
                    gobbo_bonus = ImGui.SliderInt("Goblin bonus", gobbo_bonus, 0, 15, "%d%%")
                    hoveredSimple("Bonus for Orc and Goblin factions.")
                end
                if tableContains(men_factions, eur_player_faction.name) then
                    men_bonus = ImGui.SliderInt("Human bonus", men_bonus, 0, 15, "%d%%")
                    hoveredSimple("Bonus for Human factions.")
                end
            end
        end
        --hoveredSimple("Show advanced options.")
        ImGui.PopStyleColor(4)

        replen_values.replen_multi           = safe_round_divide(100, replen_multi)
        replen_values.aquaduct_bonus       = safe_round_divide(100, replen_aquaduct)
        replen_values.waystation_bonus       = safe_round_divide(100, replen_waystation)
        replen_values.replen_road_level[1]  = safe_round_divide(100, replen_dirt)
        replen_values.replen_road_level[2]  = safe_round_divide(100, replen_paved)
        replen_values.replen_road_level[3]  = safe_round_divide(100, replen_trade)
        replen_values.replen_field_own       = safe_round_divide(100, replen_allied)
        replen_values.replen_field_other     = safe_round_divide(100, replen_nonallied)
        replen_values.goblin_bonus     = safe_round_divide(100, gobbo_bonus)
        replen_values.replen_bonus     = safe_round_divide(100, global_bonus)
        replen_values.men_bonus     = safe_round_divide(100, men_bonus)
        ImGui.NewLine()
            ImGui.Image(sort_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
            local hovered = ImGui.IsItemHovered()
            if hovered then
                eurStyle("tooltip", true)
                ImGui.BeginTooltip()
                ImGui.Text("Army Sorting")
                ImGui.BulletText("Sorts unit cards within all player armies over the end turn.")
                ImGui.BulletText("Decide the first, second and third order of sorting.")
                if sortstack1 then
                    ImGui.Image(sortstack1.img,630*eurbackgroundWindowSizeRight, 266*eurbackgroundWindowSizeBottom)
                end
                ImGui.EndTooltip()
                eurStyle("tooltip", false)
            end
            --ImGui.NewLine()
            options_sort, sortpressed = ImGui.Checkbox("Enabled##02", options_sort)
            hoveredSimple("Enable army sorting.")
            ImGui.Text("Sort order:") 
            sort_order.a, clicked = ImGui.Combo("First", sort_order.a, {"EDU Name", "Category(eg infantry)", "Class(eg heavy)", "Soldier Count", "Experience", "(Default)Category + Class", "AI unit value"}, 7, 8)
            sort_order.b, clicked2 = ImGui.Combo("Second", sort_order.b, {"(Default)EDU Name", "Category(eg infantry)", "Class(eg heavy)", "Soldier Count", "Experience", "Category + Class", "AI unit value"}, 7, 8)
            sort_order.c, clicked3 = ImGui.Combo("Third", sort_order.c, {"EDU Name", "Category(eg infantry)", "Class(eg heavy)", "(Default)Soldier Count", "Experience", "Category + Class", "AI unit value"}, 7, 8)
            
            ImGui.NewLine()
            ImGui.Image(global_text.img,500*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
            local hovered = ImGui.IsItemHovered()
            if hovered then
                eurStyle("tooltip", true)
                ImGui.BeginTooltip()
                ImGui.Text("Global Recruitment")
                ImGui.BulletText("Global Recruitment button added to the bottom of the settlement scroll.")
                ImGui.BulletText("Allows regular(local) and new(global) recruitment queues to be managed via a new UI.")
                ImGui.BulletText("Global recruitmenet queue that is not linked to any settlement, global recruits are recruited from the remote settlement and spawn in the local settlement.")
                ImGui.BulletText("Additional costs and recruitment time based on distance.")
                ImGui.BulletText("All recruitables listed except for floaty boats and agents.")
                ImGui.BulletText("Global recruit slots start at 2 and increase based on the number of waystations.")
                ImGui.EndTooltip()
                eurStyle("tooltip", false)
            end
            game_options.global_recruitment, global_recruitmentspressed = ImGui.Checkbox("Enabled##global1", game_options.global_recruitment)
            hoveredSimple("Enable Global Recruitment.")
            game_options.global_recruit_start = ImGui.SliderInt("Global queue starting size", game_options.global_recruit_start, 1, 20, "%d")
            hoveredSimple("Global Recruitment starting size(default 2).")
            game_options.global_recruit_max = ImGui.SliderInt("Global queue limit", game_options.global_recruit_max, 2, 20, "%d")
            hoveredSimple("Global Recruitment queue max size(default 10).")
            game_options.global_waystation_inc_max,  global_waystation_inc_maxpressed = ImGui.Checkbox("Waystation increases global queue size", game_options.global_waystation_inc_max)
            hoveredSimple("Constructing Waystations increases the Global Recruitment queue size(disable to simply use the max queue size).")
            game_options.global_recruitment_hidenounits, global_recruitment_hidenounitspressed = ImGui.Checkbox("Hide settlements without units##global1", game_options.global_recruitment_hidenounits)
            hoveredSimple("Hide settlements that have no units to recruit, or have all their recruited units hidden.")
            game_options.global_waystation_req,  global_waystation_reqpressed = ImGui.Checkbox("Waystation required in settlement", game_options.global_waystation_req)
            hoveredSimple("Require a Waystation to be constructed in the settlement in order to receive global recruits.")
            game_options.global_recruitment_localonly,  global_recruitment_localonlypressed = ImGui.Checkbox("Local recruits only", game_options.global_recruitment_localonly)
            hoveredSimple("Enables the UI but you can only recruit locally.")
            game_options.global_sort_aphabetically,  global_sort_aphabeticallypressed = ImGui.Checkbox("Sort alphabetically", game_options.global_sort_aphabetically)
            hoveredSimple("Sort settlements in the UI alphabetically.")
            game_options.global_sort_distance,  global_sort_distancepressed = ImGui.Checkbox("Sort by distance", game_options.global_sort_distance)
            hoveredSimple("Sort settlements in the UI by distance to the local settlement.")

            if global_sort_aphabeticallypressed then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if game_options.global_sort_aphabetically then
                    game_options.global_sort_distance = false
                end
            end
            if global_sort_distancepressed then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if game_options.global_sort_distance then
                    game_options.global_sort_aphabetically = false
                end
            end

            ImGui.NewLine()
            ImGui.Image(revival_text.img,500*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
            local hovered = ImGui.IsItemHovered()
            if hovered then
                eurStyle("tooltip", true)
                ImGui.BeginTooltip()
                ImGui.Text("Faction Revival")
                ImGui.BulletText("Allows dead factions to be revived at their starting capital.")
                ImGui.BulletText("Faction Revival button added to the bottom of the settlement scroll.")
                ImGui.BulletText("Mordor, along with confederated factions cannot be revived.")
                ImGui.BulletText("Single revival by default.")
                ImGui.BulletText("Good factions can be revived by other good factions, evil by evil. Enedwaith, AA and Dunland are neutral and can revive any faction.")
                ImGui.EndTooltip()
                eurStyle("tooltip", false)
            end

            ImGui.BeginGroup()
            if (ImGui.Button("-##revive07", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if game_options.revival_cost >= 2000 then
                    game_options.revival_cost=game_options.revival_cost-1000
                else
                    game_options.revival_cost = 1000
                end
            end
            ImGui.SameLine()
            ImGui.Text("Cost: ")
            ImGui.SameLine()
            ImGui.Text(tostring(game_options.revival_cost))
            ImGui.SameLine()
            ImGui.Image(coins.img,20*eurbackgroundWindowSizeRight,20*eurbackgroundWindowSizeBottom)
            ImGui.SameLine()
            if (ImGui.Button("+##revive08", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if game_options.revival_cost <= 49000 then
                    game_options.revival_cost=game_options.revival_cost+1000
                else
                    game_options.revival_cost = 50000
                end
            end
            ImGui.EndGroup()
            hoveredSimple("Faction revival cost.")
            game_options.unlimited_revival,  unlimited_revivalpressed = ImGui.Checkbox("Unlimited revivals", game_options.unlimited_revival)
            hoveredSimple("Revive factions an unlimited number of times.")
            game_options.airevive,  airevivalpressed = ImGui.Checkbox("AI revivals", game_options.airevive)
            hoveredSimple("AI factions have a chance to revive on their own, provided that the player does not own their capital.")
            game_options.revival_disposition_ignored,  revival_dispositionpressed = ImGui.Checkbox("Ignore disposition", game_options.revival_disposition_ignored)
            hoveredSimple("Allow any faction to revive any other.")
            if revival_dispositionpressed then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if not game_options.revival_disposition_ignored then
                    for k, v in pairs(faction_disposition_default) do
                        faction_disposition[k] = v
                    end
                else
                    for k, v in pairs(faction_disposition) do
                        faction_disposition[k] = "neutral"
                    end
                end
            end

            ImGui.NewLine()
            ImGui.Image(misc_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
            hoveredSimple("Campaign Miscellaneous.")
            --ImGui.NewLine()
        
            watchtower_range = ImGui.SliderInt("Watchtower sight range", watchtower_range, 10, 50, "%d")
            hoveredSimple("Default 10")
            game_options.reveal_allied,  revalliedpressed = ImGui.Checkbox("Allied vision", game_options.reveal_allied)
            hoveredSimple("Reveal fog of war around allied settlements and armies.")
            if not collect_stats then
                options_evolvingnames, evolvepressed = ImGui.Checkbox("Evolving Faction Names", options_evolvingnames)
                hoveredSimple("AI faction names change depending on their size.")
            end

            --[[if options_first_run then
                game_options.supplies, suppliespressed = ImGui.Checkbox("Army Supplies", game_options.supplies)
                hoveredSimple("Enable supply system, impacts how long armies can stay out in the field before needing to rest, adds various supply traits to the general.")
                if suppliespressed then
                    if game_options.supplies then
                        M2TWEOP.setScriptCounter("supplies_eur", 1)
                    else
                        M2TWEOP.setScriptCounter("supplies_eur", 0)
                    end
                end
            end]]

            M2TWEOP.getOptions2().toggleAutoSave = 1
            build_forts, fortspressed = ImGui.Checkbox("Constructable Forts", build_forts)
            hoveredSimple("Build permanent forts in owned regions, scaled costs depending on how many forts are present.")
                game_options.auto_saves_enabled, auto_saves_enabledspressed = ImGui.Checkbox("Autosaves", game_options.auto_saves_enabled)
                hoveredSimple("Enable end turn rolling autosaves.")
                game_options.siege_messages, siegemssages_spressed = ImGui.Checkbox("Settlement messages", game_options.siege_messages)
                hoveredSimple("Enable events for AI settlement loss, such as capitals.")
                if siegemssages_spressed then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    if game_options.siege_messages then
                        M2TWEOP.setScriptCounter("siege_messages", 1)
                    else
                        M2TWEOP.setScriptCounter("siege_messages", 0)
                    end
                end
                options_addspoils, options_addspoilspressed = ImGui.Checkbox("Post-battle loot", options_addspoils)
                local hovered = ImGui.IsItemHovered()
                if hovered then
                    eurStyle("tooltip", true)
                    ImGui.BeginTooltip()
                    ImGui.Text("Post-battle loot")
                    ImGui.BulletText("After winning a battle, the player has a chance of looting the enemy baggage train.")
                    ImGui.BulletText("Chance of looting based on victory type.")
                    ImGui.BulletText("Amount of gold based on victory type and army compositions.")
                    ImGui.EndTooltip()
                    eurStyle("tooltip", false)
                end
                options_merge, options_mergepressed = ImGui.Checkbox("AI Army merging", options_merge)
                hoveredSimple("Smaller AI armier will merge every few turns, reducing stack clutter.")
                game_options.eregion_spawn, eregion_spawn_spressed = ImGui.Checkbox("AI Eregion", game_options.eregion_spawn)
                hoveredSimple("Spawns Eregion as a faction during the campaign, even when not playing as Lindon or Imladris. Eregion spawns between turns 60-80.")
                game_options.convert_buildings, convert_buildingspressed = ImGui.Checkbox("Convert Buildings", game_options.convert_buildings)
                hoveredSimple("Automatically converts like for like buildings to the settlements owner's culture over the end turn.")
                game_options.garrisons, garrisonspressed = ImGui.Checkbox("AI Garrisons", game_options.garrisons)
                hoveredSimple("Enable Garrisons in key AI settlements(not recommended to disable as the AI may lose those settlements earlier.)")
                ImGui.PopItemWidth()

    
end

function optionsDifficulty(bool)
    ImGui.PushItemWidth(500)
    if bool then
        local diff_option = 0
        if options_legendary then
            diff_option = 4
        else
            diff_option = game_options.campaigndiff
        end
        ImGui.NewLine()
        ImGui.Text("Campaign Difficulty: "..campaign_diff_text[diff_option])
        ImGui.Text("Battle Difficulty: "..battlediff_text[game_options.battlediff])
        ImGui.NewLine()
        ImGui.Image(leg_text.img,600*eurbackgroundWindowSizeRight,60*eurbackgroundWindowSizeBottom)
        hoveredSimple("Legendary difficulty settings.")

        options_legendary, legendpressed = ImGui.Checkbox("Enabled##leg01", options_legendary)
        hoveredSimple("Enable legandary difficulty.")
        if legendpressed then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if options_legendary then
                legendaryToggle(true)
            else
                legendaryToggle(false)
            end
        end
        options_hardcore, hardpressed = ImGui.Checkbox("Hardcore mode", options_hardcore)
        hoveredSimple("Disables auto resolve.")
            
            ImGui.PushStyleColor(ImGuiCol.HeaderHovered,1, 1, 1, 0)
            ImGui.PushStyleColor(ImGuiCol.Header,1, 1, 1, 0)
            ImGui.PushStyleColor(ImGuiCol.HeaderActive,1, 1, 1, 0.0)
            ImGui.PushStyleColor(ImGuiCol.Border, 1, 1, 1, 0)
            if (ImGui.CollapsingHeader("Advanced Options##leg01")) then
                if not options_first_run then
                    ImGui.Text("Please save and restart after changing any of the below settings.")
                end
                options_general_large_army, options_general_large_armypressed = ImGui.Checkbox("Add generals to large AI armies", options_general_large_army)
                hoveredSimple("Medium to large AI armies will have a general unit in most cases.")
                
                if hardpressed then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    if options_hardcore then
                        eur_campaign.restrictAutoResolve = 1
                    else
                        eur_campaign.restrictAutoResolve = 0
                    end
                end
                options_no_free_upkeep, upkeeppressed = ImGui.Checkbox("No free upkeep for T2 units", options_no_free_upkeep)
                hoveredSimple("Disables free upkeep for all units T2 and above unless garrisoned in a fort.")
                game_options.options_aiboost, aiboostpressed = ImGui.Checkbox("Buffed AI generals", game_options.options_aiboost)
                hoveredSimple("Provides a buff to AI generals starting stats, buffing troop morale and general hitpoints.")
                game_options.order_offset, orderoffsetpressed = ImGui.Checkbox("20% public order penalty", game_options.order_offset)
                hoveredSimple("Public order penaty for the player.")
                game_options.global_morale_boost, global_morale_boostpressed = ImGui.Checkbox("Global morale increase(not recommended)", game_options.global_morale_boost)
                hoveredSimple("A flat global morale increase, breaks intended game balance(+2 default).")
                game_options.morale_value = ImGui.SliderInt("##moralebonus", game_options.morale_value, 1, 4, "%d")
                hoveredSimple("Morale bonus amount.")
                if not options_first_run then
                    if global_morale_boostpressed then
                        if game_options.global_morale_boost then
                            globalMoraleIncrease(game_options.morale_value)
                        end
                    end
                end
                ImGui.NewLine()
                ImGui.Text("Legendary modifiers(player only)")
                ImGui.Text("Recruitment Time: " .. tostring(EDUOFFET_VARS_LEG.recruitTimeMult) .. "x")
                hoveredSimple("Increase recruit time.")
                --EDUOFFET_VARS.threshold = ImGui.SliderInt("Threshold.", EDUOFFET_VARS.threshold, 0, 2500, "%d Gold")
                EDUOFFET_VARS_LEG.offset1 = ImGui.SliderInt("Recruit & Upkeep.##1", EDUOFFET_VARS_LEG.offset1, -100, 500, "%d%%")
                hoveredSimple("Flat recruitment and upkeep cost modifier.")
                --EDUOFFET_VARS.extragold = ImGui.SliderInt("Flat gold increase.", EDUOFFET_VARS.extragold, 0, 500, "%d Gold")
                EDUOFFET_VARS_LEG.pooloffset1 = ImGui.SliderInt("Pool offset(recruitment speed).", EDUOFFET_VARS_LEG.pooloffset1, -90, 300, "%d%%")
                hoveredSimple("Controls how many turns it takes for a new recruit to become available, negative values give faster pool replenishement, positive slower.")
                ImGui.Text("Increase only.")
                EDUOFFET_VARS_LEG.bu_time = ImGui.SliderInt("Building time increase(turns).", EDUOFFET_VARS_LEG.bu_time, 0, 4, "%d")
                hoveredSimple("Increase building time.")
                EDUOFFET_VARS_LEG.bu_cost = ImGui.SliderInt("Building cost increase.", EDUOFFET_VARS_LEG.bu_cost, 0, 200, "%d%%")
                hoveredSimple("Increase building cost.")
            end
            ImGui.PopStyleColor(4)
            --if dev_enabled then
                ImGui.NewLine()
                ImGui.Image(misc_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
                hoveredSimple("Difficulty Miscellaneous.")
                if not options_first_run then
                    ImGui.Text("Please save and restart after changing any of the below settings.")
                end
                ImGui.PushStyleColor(ImGuiCol.HeaderHovered,1, 1, 1, 0)
                ImGui.PushStyleColor(ImGuiCol.Header,1, 1, 1, 0)
                ImGui.PushStyleColor(ImGuiCol.HeaderActive,1, 1, 1, 0.0)
                ImGui.PushStyleColor(ImGuiCol.Border, 1, 1, 1, 0)
                if (ImGui.CollapsingHeader("Advanced Options##leg02")) then
                   -- set_mods, setmodspressed = ImGui.Checkbox("Use Modifiers", set_mods)
                    if modifier_config.enabled ~= nil then modifier_config.enabled, Enabledpressed = ImGui.Checkbox("EOP AI Enabled", modifier_config.enabled) end
                    hoveredSimple("Uncheck this option to have the campaign AI go back to Medieval 2 default.")
                    if modifier_config.aggressionFactor ~= nil then modifier_config.aggressionFactor = ImGui.InputFloat("aggressionFactor", modifier_config.aggressionFactor) end
                    hoveredSimple("How aggressively the AI will attack, higher values make the AI more likely to attack and less likely to withdraw. If the value is too high the AI will not attack with sufficient force to win, under 1.4 is recommended.")
                    if modifier_config.nonBorderFactor ~= nil then modifier_config.nonBorderFactor = ImGui.InputFloat("nonBorderFactor", modifier_config.nonBorderFactor) end
                    hoveredSimple("How far outside of enemy territory the AI will attack, kept low to stop the AI from travelling half way across the map.")
                    if modifier_config.forceNavalInvasions ~= nil then modifier_config.forceNavalInvasions, forceNavalInvasionspressed = ImGui.Checkbox("forceNavalInvasions", modifier_config.forceNavalInvasions) end
                    hoveredSimple("Force AI naval invasions even if the faction does not normally do this.")
                    --[[if modifier_config.defenseFactor ~= nil then modifier_config.defenseFactor = ImGui.InputFloat("defenseFactor", modifier_config.defenseFactor) end
                    if modifier_config.residenceFactor ~= nil then modifier_config.residenceFactor = ImGui.InputFloat("residenceFactor", modifier_config.residenceFactor) end
                    if modifier_config.aidFactor ~= nil then modifier_config.aidFactor = ImGui.InputFloat("aidFactor", modifier_config.aidFactor) end
                    if modifier_config.moveCostFactor ~= nil then modifier_config.moveCostFactor = ImGui.InputFloat("moveCostFactor", modifier_config.moveCostFactor) end
                    if modifier_config.powerFactor ~= nil then modifier_config.powerFactor = ImGui.InputFloat("powerFactor", modifier_config.powerFactor) end
                    if modifier_config.invadePriorityFactor ~= nil then modifier_config.invadePriorityFactor = ImGui.InputFloat("invadePriorityFactor", modifier_config.invadePriorityFactor) end

                    --ImGui.Separator()
                    ImGui.Text("Campaign Difficulty Modifiers")

                    if modifier_config.orderFromGrowth ~= nil then modifier_config.orderFromGrowth = ImGui.InputInt("orderFromGrowth", modifier_config.orderFromGrowth) end
                    if modifier_config.maxPlayerPeaceTurns ~= nil then modifier_config.maxPlayerPeaceTurns = ImGui.InputInt("maxPlayerPeaceTurns", modifier_config.maxPlayerPeaceTurns) end
                    if modifier_config.brigandChanceAi ~= nil then modifier_config.brigandChanceAi = ImGui.InputFloat("brigandChanceAi", modifier_config.brigandChanceAi) end
                    if modifier_config.aiHireMercenaries ~= nil then modifier_config.aiHireMercenaries, aiHireMercenariespressed = ImGui.Checkbox("aiHireMercenaries", modifier_config.aiHireMercenaries) end
                    if modifier_config.brigandChancePlayer ~= nil then modifier_config.brigandChancePlayer = ImGui.InputFloat("brigandChancePlayer", modifier_config.brigandChancePlayer) end
                    if modifier_config.taxIncomeModifierPlayer ~= nil then modifier_config.taxIncomeModifierPlayer = ImGui.InputFloat("taxIncomeModifierPlayer", modifier_config.taxIncomeModifierPlayer) end
                    if modifier_config.incomeModifierAi ~= nil then modifier_config.incomeModifierAi = ImGui.InputFloat("incomeModifierAi", modifier_config.incomeModifierAi) end
                    if modifier_config.playerRegionValueModifier ~= nil then modifier_config.playerRegionValueModifier = ImGui.InputFloat("playerRegionValueModifier", modifier_config.playerRegionValueModifier) end

                    if modifier_config.popGrowthBonusAi ~= nil then modifier_config.popGrowthBonusAi = ImGui.InputInt("popGrowthBonusAi", modifier_config.popGrowthBonusAi) end
                    if modifier_config.publicOrderBonusAi ~= nil then modifier_config.publicOrderBonusAi = ImGui.InputInt("publicOrderBonusAi", modifier_config.publicOrderBonusAi) end
                    if modifier_config.experienceBonusAi ~= nil then modifier_config.experienceBonusAi = ImGui.InputInt("experienceBonusAi", modifier_config.experienceBonusAi) end
                    if modifier_config.incomeBonusAi ~= nil then modifier_config.incomeBonusAi = ImGui.InputInt("incomeBonusAi", modifier_config.incomeBonusAi) end
                    if modifier_config.dontAttackAiDefenders ~= nil then modifier_config.dontAttackAiDefenders, dontAttackAiDefenderspressed = ImGui.Checkbox("dontAttackAiDefenders", modifier_config.dontAttackAiDefenders) end
                    
                    if modifier_config.brigandControllerTargetSettlements ~= nil then modifier_config.brigandControllerTargetSettlements, brigandControllerTargetSettlementsEnabledpressed = ImGui.Checkbox("brigandControllerTargetSettlements", modifier_config.brigandControllerTargetSettlements) end
                ]]
                end
                --hoveredSimple("Show advanced options.")
                ImGui.PopStyleColor(4)
            --end
            


    else
            local offset1 = percentIntToFloat(EDUOFFET_VARS.offset1)
            local pooloffset1 = percentIntToFloat(EDUOFFET_VARS.pooloffset1)
            ImGui.Text("Hardcore mode:")
            ImGui.BulletText("Disables auto-resolve.")
            ImGui.NewLine()
            --ImGui.Separator()
            ImGui.NewLine()
            ImGui.Text("Campaign Difficulty:")
            ImGui.BulletText("WIP")
            ImGui.NewLine()
            --ImGui.Separator()
            if test1 then
                ImGui.Image(test1.img, 80*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom)
                ImGui.Text("Example Cat Unit default:")
                ImGui.BulletText("Recruit cost: 800")
                ImGui.BulletText("Upkeep cost: 300")
                ImGui.BulletText("Recruit time(turns): 2")
                ImGui.BulletText("Pool replenishment time(turns): 24")
            end
            if test1 then
                ImGui.Image(test1.img, 80*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom)
                ImGui.Text("Example Cat Unit modified:")
                ImGui.BulletText("Recruit cost: "..tostring(math.ceil(800*offset1)))
                ImGui.BulletText("Upkeep cost: "..tostring(math.ceil(300*offset1)+EDUOFFET_VARS.extragold))
                ImGui.BulletText("Recruit time(turns): "..tostring(2*EDUOFFET_VARS.recruitTimeMult))
                ImGui.BulletText("Pool replenishment time(turns): "..tostring(math.ceil(24/pooloffset1)))
            end

    end
    ImGui.PopItemWidth()
end

function optionsChrisStuff()
            ImGui.BeginGroup()
            ImGui.Image(chrisset_text.img,600*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
            ImGui.EndGroup()

            if add_setts then
                ImGui.Text("Additional settlements: Enabled")
            else
                ImGui.Text("Additional settlements: Disabled")
            end
            local hovered = ImGui.IsItemHovered()
            if hovered then
                eurStyle("tooltip", true)
                ImGui.BeginTooltip()
                ImGui.Text("Additional settlements")
                ImGui.BulletText("Adds additional settlements to the campaign map.")
                ImGui.BulletText("Settlements are minor and fall within existing regions on the campaign map, culture is shared amongst all settlments in the region.")
                ImGui.BulletText("Mines are disabled by default unless pre-built.")
                ImGui.EndTooltip()
                eurStyle("tooltip", false)
            end
            if cutdown_setts then
                ImGui.Text("Mode: Lite")
            else
                ImGui.Text("Mode: Full")
            end
            if setts_player_expansion then
                ImGui.Text("Player expansion: Enabled")
            else
                ImGui.Text("Player expansion: Disabled")
            end
            if options_extraBGunits then
                ImGui.Text("Extra units: Enabled")
            else
                ImGui.Text("Extra units: Disabled")
            end
            if options_extrabu then
                ImGui.Text("Extra buildings: Enabled")
            else
                ImGui.Text("Extra buildings: Disabled")
            end
            
end


function optionsSpeed()
    ImGui.Image(speed_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
    game_options.playeronlymods, playeronlymodspressed = ImGui.Checkbox("Player only##02", game_options.playeronlymods)
    hoveredSimple("Enable modifiers only for the player.")
    --game_options.options_usemods, usemodspressed = ImGui.Checkbox("Enabled##07usemods", game_options.options_usemods)
    if not options_first_run then
        ImGui.Text("Please save and restart after changing any of the below settings.")
    end
    ImGui.Text("Presets:")
    if ImGui.Button("Normal") then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        EDUOFFET_VARS = {
            threshold = 500,
            extragold = 0,
            extragold2 = 0,
            recruitTimeMult = 1,
            offset1 = 0,
            offset2 = 0,
            pooloffset1 = 0,
            pooloffset2 = 0,
            bu_time = 0,
            bu_cost = 0,
        }
    end
    ImGui.SameLine()
    if ImGui.Button("0.5x") then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        EDUOFFET_VARS = {
            threshold = 500,
            extragold = 0,
            extragold2 = 0,
            recruitTimeMult = 0.5,
            offset1 = -50,
            offset2 = -50,
            pooloffset1 = -50,
            pooloffset2 = -50,
            bu_time = 0,
            bu_cost = 0,
        }
    end
    ImGui.SameLine()
    if ImGui.Button("1.5x") then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        EDUOFFET_VARS = {
            threshold = 500,
            extragold = 0,
            extragold2 = 0,
            recruitTimeMult = 1.5,
            offset1 = 50,
            offset2 = 50,
            pooloffset1 = 50,
            pooloffset2 = 50,
            bu_time = 0,
            bu_cost = 0,
        }
    end
    ImGui.SameLine()
    if ImGui.Button("2.0x") then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        EDUOFFET_VARS = {
            threshold = 500,
            extragold = 0,
            extragold2 = 0,
            recruitTimeMult = 2,
            offset1 = 100,
            offset2 = 100,
            pooloffset1 = 100,
            pooloffset2 = 100,
            bu_time = 0,
            bu_cost = 0,
        }
    end
    ImGui.SameLine()
    if ImGui.Button("3.0x") then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        EDUOFFET_VARS = {
            threshold = 500,
            extragold = 0,
            extragold2 = 0,
            recruitTimeMult = 3,
            offset1 = 200,
            offset2 = 200,
            pooloffset1 = 200,
            pooloffset2 = 200,
            bu_time = 0,
            bu_cost = 0,
        }
    end
    ImGui.NewLine()
    if options_legendary then
        ImGui.Text("Legendary enabled, legendary modifiers will be added on top of the base campaign modifiers.")
    end
    ImGui.Text("Recruitment Time: " .. tostring(EDUOFFET_VARS.recruitTimeMult) .. "x")
    hoveredSimple("Increase recruit time.")
    --EDUOFFET_VARS.threshold = ImGui.SliderInt("Threshold.", EDUOFFET_VARS.threshold, 0, 2500, "%d Gold")
    EDUOFFET_VARS.offset1 = ImGui.SliderInt("Recruit & Upkeep.##1", EDUOFFET_VARS.offset1, -100, 500, "%d%%")
    hoveredSimple("Flat recruitment and upkeep cost modifier.")
    --EDUOFFET_VARS.extragold = ImGui.SliderInt("Flat gold increase.", EDUOFFET_VARS.extragold, 0, 500, "%d Gold")
    EDUOFFET_VARS.pooloffset1 = ImGui.SliderInt("Pool offset(recruitment speed).", EDUOFFET_VARS.pooloffset1, -50, 300, "%d%%")
    hoveredSimple("Controls how many turns it takes for a new recruit to become available, negative values give faster pool replenishement, positive slower.")
    ImGui.Text("Increase only.")
    EDUOFFET_VARS.bu_time = ImGui.SliderInt("Building time increase(turns).", EDUOFFET_VARS.bu_time, 0, 4, "%d")
    hoveredSimple("Increase building time.")
    EDUOFFET_VARS.bu_cost = ImGui.SliderInt("Building cost increase.", EDUOFFET_VARS.bu_cost, 0, 200, "%d%%")
    hoveredSimple("Increase building cost.")
end


function optionsBattle()
    M2TWEOP.changeGeneralPosition(true)
    ImGui.BeginGroup()
    ImGui.Image(battle_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
    ImGui.EndGroup()

    --game_options.agoAI, agoAIpressed = ImGui.Checkbox("AGO AI", game_options.agoAI)
    --hoveredSimple("Use the AGO style battle AI.")

    game_options.genposition, genpositionpressed = ImGui.Checkbox("Change general position##02skirmish", game_options.genposition)
    hoveredSimple("Place the general in the center of the unit.")
    if genpositionpressed then
        if game_options.genposition then
            M2TWEOP.changeGeneralPosition(true)
        else
            M2TWEOP.changeGeneralPosition(false)
        end
    end

    game_options.disable_skirmish, disable_skirmishpressed = ImGui.Checkbox("Disable skirmish##02skirmish", game_options.disable_skirmish)
    hoveredSimple("Disable skirmish mode for the player's units.")

    game_options.show_speed_ui, speeduipressed = ImGui.Checkbox("Enhanced speed controls##02speed", game_options.show_speed_ui)
    hoveredSimple("Enables the advanced speed battle UI widget, enabling speeds from 0.5x to 12x in multiples of +/- 1 and 3(or 0.1 and 0.5 if holding shift).")
    ImGui.NewLine()
    ImGui.Separator()
    ImGui.NewLine()
    ImGui.Text("Highlight all units - ")
    ImGui.SameLine()
    ImGui.TextColored(0,0,0,1,"CTRL + Q")
    ImGui.Text("Zoom out - ")
    ImGui.SameLine()
    ImGui.TextColored(0,0,0,1,"X")
    ImGui.Text("Zoom in - ")
    ImGui.SameLine()
    ImGui.TextColored(0,0,0,1,"Z")

end

function optionsCampaignExtra()
    ImGui.Image(misc_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
    if (eur_player_faction.name == "saxons" or eur_player_faction.name == "denmark") then
        ImGui.NewLine()
        ImGui.Text("Skip the awesome story and start the campaign as Eregion or the Kingdom of the Noldor(not recommended).")
        ImGui.NewLine()
        misc_options.eregion_start, eregion_startpressed = ImGui.Checkbox("Start as the Kingdom of Eregion", misc_options.eregion_start)
        hoveredSimple("Start as Eregion over the first end turn.")

        misc_options.kon_start, kon_startpressed = ImGui.Checkbox("Start as the Kingdom of the Noldor", misc_options.kon_start)
        hoveredSimple("Confederate with Lindon / Imladris over the first end turn.")
        if misc_options.kon_start then
            misc_options.kon_start_ai_eregion, kon_start_ai_eregionpressed = ImGui.Checkbox("Spawn Eregion AI", misc_options.kon_start_ai_eregion)
            hoveredSimple("Spawn the Eregion AI faction(turn 60-80).")
        end
        if eregion_startpressed then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if misc_options.eregion_start then
                misc_options.kon_start = false
                misc_options.kon_start_ai_eregion = false
            end
        end
        if kon_startpressed then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if misc_options.kon_start then
                misc_options.eregion_start = false
            end
        end
    end
    ImGui.Text("Player gold:")
    eur_player_faction.money = ImGui.SliderInt("Starting Gold", eur_player_faction.money, 1000, 500000, "%d Gold")
    hoveredSimple("Set the starting level of gold")
    eur_player_faction.kingsPurse = ImGui.SliderInt("King's Purse", eur_player_faction.kingsPurse, 500, 50000, "%d Gold")
    hoveredSimple("Set the King's Purse, an amount of gold earned each turn throughout the campaign, amount will be slightly higher depending on campaign difficulty.")
end