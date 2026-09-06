require('eur/eurEvent/eurEventsFunc')
require('eur/eurEvent/eurEventsVars')
require('eur/eurEvent/eurEventImGiuWindows')

function eventsButton()
    if not active_event_factions[eur_localFactionName] then return end
    if not EUR_EVENTS[eur_localFactionName] then return end
    ImGui.SetNextWindowPos(1490*eurbackgroundWindowSizeRight, 840*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(80, 80)
    ImGui.Begin("Events_button_01", true, bit.bor(ImGuiWindowFlags.NoDecoration,ImGuiWindowFlags.NoBackground))
    eurStyle("basic_1", true)
    local show_button = false
    if EUR_EVENTS[eur_localFactionName] then
        for i = 0, #EUR_EVENTS[eur_localFactionName] do
            if EUR_EVENTS[eur_localFactionName][i].unlocked then
                show_button = true
            end
        end
    end
    if show_button then
        if button1 then
            if ImGui.ImageButton("events_button_1",button1.img,60,60) then
                if show_events_window == false then
                    show_events_window = true
                    if EOP_WAVS["uicah_menuclick1"] ~= nil then
                        M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
                    end
                else
                    show_events_window = false
                    if EOP_WAVS["uicah_menuclick1"] ~= nil then
                        M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
                    end
                end
            end
            local hovered = ImGui.IsItemHovered()
            if hovered then
                ImGui.BeginTooltip()
                if eur_event_min_cooldown > 0 then
                    ImGui.TextColored(1, 0, 0, 1, "Event cooldown: "..eur_event_min_cooldown.." turns")
                end
                if EUR_EVENTS[eur_localFactionName] then
                    for i = 0, #EUR_EVENTS[eur_localFactionName] do
                        if EUR_EVENTS[eur_localFactionName][i].active_duration > 0 then
                            ImGui.TextColored(0, 1, 0, 1,EUR_EVENTS[eur_localFactionName][i].name..", active: "..EUR_EVENTS[eur_localFactionName][i].active_duration.." turns")
                        else
                            if EUR_EVENTS[eur_localFactionName][i].active_cooldown > 0 then
                                ImGui.TextColored(0, 0, 1, 1,EUR_EVENTS[eur_localFactionName][i].name..", cooldown: "..EUR_EVENTS[eur_localFactionName][i].active_cooldown.." turns")
                            else
                                if EUR_EVENTS[eur_localFactionName][i].unlocked then
                                    ImGui.Text(EUR_EVENTS[eur_localFactionName][i].name..": Available")
                                end
                            end
                        end
                    end
                    ImGui.EndTooltip()
                end
            end
        else
            if (ImGui.Button("Events", 80, 20)) then
                if show_events_window == false then
                    show_events_window = true
                    if EOP_WAVS["uicah_menuclick1"] ~= nil then
                        M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
                    end
                else
                    show_events_window = false
                    if EOP_WAVS["uicah_menuclick1"] ~= nil then
                        M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
                    end
                end
            end
        end
    else
        if test1 then
            ImGui.Image(test1.img,60,60)
            local hovered = ImGui.IsItemHovered()
            if hovered then
                ImGui.BeginTooltip()
                ImGui.Text("No events available")
                ImGui.EndTooltip()
            end
        end
    end
    eurStyle("basic_1", false)
    ImGui.End()
end

local showtext = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
}
local hoveredtest = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
}
event_selected = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
}

local curr_event_selected = {
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
}

local pos_x = {}
local pos_y = {}

function eventsWindow()
    if not active_event_factions[eur_localFactionName] then return end
    ImGui.SetNextWindowPos(200*eurbackgroundWindowSizeRight, 5*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(1500*eurbackgroundWindowSizeRight, 825*eurbackgroundWindowSizeBottom)
    ImGui.Begin("Events_window_background", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    eurStyle("basic_1", true)
    if event_backgrounds[eur_player_faction.name] then
        ImGui.Image(event_backgrounds[eur_player_faction.name],1500*eurbackgroundWindowSizeRight, 850*eurbackgroundWindowSizeBottom)
    end
    ImGui.SetNextWindowPos(210*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.5)
    ImGui.BeginChild("Events_window_main", 1480*eurbackgroundWindowSizeRight, 660*eurbackgroundWindowSizeBottom)
    if (ImGui.BeginTabBar("events_tabbar_1")) then
        ImGui.Separator()
        if (ImGui.BeginTabItem("events1##01")) then

            ImGui.NewLine()
            ImGui.SetNextWindowBgAlpha(0.5)
            ImGui.BeginChild("Events_window_child_01", 900*eurbackgroundWindowSizeRight, 545*eurbackgroundWindowSizeBottom,ImGuiChildFlags.FrameStyle)
            if not EUR_EVENTS[eur_localFactionName] then return end
            for i = 0, #EUR_EVENTS[eur_localFactionName] do
                ImGui.SetNextWindowBgAlpha(0)
                if i == 2 then 
                    ImGui.NewLine()
                elseif i > 0 then
                    ImGui.SameLine()
                end
                if EUR_EVENTS[eur_localFactionName][i].unlocked then
                    ImGui.BeginChild("Events_window_child_inner_" .. tostring(i), 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
                    --ImGui.TextColored(1, 1, 1, 1,"img goes here")
                    pos_x[i], pos_y[i] = ImGui.GetWindowPos()
                    --centeredText(EUR_EVENTS[faction_name][i].name, 0)
                    if EUR_EVENTS[eur_localFactionName][i].image ~= nil then
                        ImGui.Image(EUR_EVENTS[eur_localFactionName][i].image.img, 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom)
                    end

                    ImGui.EndChild()

                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.SetNextWindowPos(pos_x[i], pos_y[i])
                    ImGui.BeginChild("Name3".. tostring(i), 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
                    centeredText(EUR_EVENTS[eur_localFactionName][i].name, 0)
                    ImGui.EndChild()

                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.SetNextWindowPos(pos_x[i], pos_y[i])
                    ImGui.BeginChild("Name2".. tostring(i), 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom)

                    event_selected[i] = ImGui.Selectable("", event_selected[i], ImGuiSelectableFlags.None, 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom)
                
                    if event_selected[i] then
                        if not showtext[i] then
                            showtext[i] = true
                            event_number = i
                            if EOP_WAVS["uicah_menuclick2"] ~= nil then
                                M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick2"])
                            end
                            for j = 0, #EUR_EVENTS[eur_localFactionName] do
                                if j ~= i then
                                    event_selected[j] = false
                                end
                            end
                        end
                    else
                        showtext[i] = false
                        --number = 99
                    end
                
                    ImGui.EndChild()
                else
                    ImGui.BeginChild("Events_window_child_inner_" .. tostring(i), 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
                    --ImGui.TextColored(1, 1, 1, 1,"img goes here")
                    pos_x[i], pos_y[i] = ImGui.GetWindowPos()
                    if EUR_EVENTS[eur_localFactionName][i].image ~= nil then
                        ImGui.Image(EUR_EVENTS[eur_localFactionName][i].image.img, 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom)
                    end
                    ImGui.EndChild()

                    ImGui.SetNextWindowBgAlpha(0.5)
                    ImGui.SetNextWindowPos(pos_x[i], pos_y[i])
                    ImGui.BeginChild("Name3".. tostring(i), 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
                    centeredText(EUR_EVENTS[eur_localFactionName][i].name, 0)
                    ImGui.NewLine()
                    centeredText(("(Locked)"), 0)
                    ImGui.NewLine()
                    local hovered = ImGui.IsWindowHovered(ImGuiHoveredFlags.ChildWindows)
                    if hovered then
                        ImGui.NewLine()
                        ImGui.BeginTooltip()
                        if EUR_EVENTS[eur_localFactionName][i].active_duration > 0 then
                            ImGui.Text("Event active: "..tostring(EUR_EVENTS[eur_localFactionName][i].active_duration.." turns remaining."))
                        else
                            if EUR_EVENTS[eur_localFactionName][i].locked_desc ~= nil then
                                ImGui.Text(EUR_EVENTS[eur_localFactionName][i].locked_desc)
                            end
                        end
                        ImGui.EndTooltip()
                    end
                    ImGui.EndChild()

                end
            end
            ImGui.EndChild()

            eventSideWindow(eur_localFactionName, eur_player_faction)
            --ImGui.EndChild()
            ImGui.EndTabItem()
        end
            if (ImGui.BeginTabItem("events2##01")) then
                --RoRRecruit()
                ImGui.EndTabItem()
            end
            if options_poe then
                if ELVEN_FACTIONS[eur_localFactionName] then
                    if (ImGui.BeginTabItem("events3##01")) then
                            PoEEvent()
                        ImGui.EndTabItem()
                    end
                end
            end
            ImGui.EndTabBar()
        end
    if (centeredImageButton("Close", 80, 50, 0)) then
        show_events_window = false
        if EOP_WAVS["uicah_menuclick1"] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
        end
    end
    
    eurStyle("basic_1", false)
    ImGui.EndChild()
    ImGui.End()
end


function PoEEvent()
    ImGui.BeginChild("poe_window_main", 1480*eurbackgroundWindowSizeRight, 660*eurbackgroundWindowSizeBottom)

    

    ImGui.EndChild()
end

local ELITE_EDU = {
    "Gabilgathol Guard",
    "Longbeard Phalanx",
}

function RoRRecruit()
    local edu = nil
    ImGui.BeginChild("ror_window_main", 1480*eurbackgroundWindowSizeRight, 660*eurbackgroundWindowSizeBottom)
    --centeredText(eur_player_faction.localizedName .. " Events", 20)
    ImGui.NewLine()
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.BeginChild("ror_window_child_01", 900*eurbackgroundWindowSizeRight, 545*eurbackgroundWindowSizeBottom)
    for i = 1, #ELITE_EDU do
        ImGui.SetNextWindowBgAlpha(0)
        if i == 5 then 
            ImGui.NewLine()
        elseif i > 0 then
            ImGui.SameLine()
        end
        if ELITE_EDU[i] ~= nil then
            ImGui.BeginChild("ror_window_child_inner_" .. tostring(i), 136*eurbackgroundWindowSizeRight, 168*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
            --ImGui.TextColored(1, 1, 1, 1,"img goes here")
            pos_x[i], pos_y[i] = ImGui.GetWindowPos()
            edu = M2TWEOPDU.getEduEntryByType(ELITE_EDU[i])
            local unit_tga = edu.unitCardTga
            --centeredText(EUR_EVENTS[faction_name][i].name, 0)
            if eur_tga_table[unit_tga] then
                local upgrade_clicked = ImGui.ImageButton("upgrade_button_0"..tostring(i),eur_tga_table[unit_tga].img, 128*eurbackgroundWindowSizeRight, 160*eurbackgroundWindowSizeBottom)
                if (upgrade_clicked == true) then
                end
            end

            ImGui.EndChild()

            ImGui.SetNextWindowBgAlpha(0)
            ImGui.SetNextWindowPos(pos_x[i], pos_y[i])
            ImGui.BeginChild("Name3".. tostring(i), 136*eurbackgroundWindowSizeRight, 168*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
            
            ImGui.EndChild()

            ImGui.SetNextWindowBgAlpha(0)
            ImGui.SetNextWindowPos(pos_x[i], pos_y[i])
            ImGui.BeginChild("Name2".. tostring(i), 136*eurbackgroundWindowSizeRight, 168*eurbackgroundWindowSizeBottom)

            event_selected[i] = ImGui.Selectable("", event_selected[i], ImGuiSelectableFlags.None, 136*eurbackgroundWindowSizeRight, 168*eurbackgroundWindowSizeBottom)
        
            if event_selected[i] then
                if not showtext[i] then
                    showtext[i] = true
                    ror_number = i
                    if EOP_WAVS["uicah_menuclick2"] ~= nil then
                        M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick2"])
                    end
                    for j = 0, #ELITE_EDU do
                        if j ~= i then
                            event_selected[j] = false
                        end
                    end
                end
            else
                showtext[i] = false
                --number = 99
            end
        
            ImGui.EndChild()
        else
            ImGui.BeginChild("ror_window_child_inner_" .. tostring(i), 160*eurbackgroundWindowSizeRight, 128*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
            --ImGui.TextColored(1, 1, 1, 1,"img goes here")
            pos_x[i], pos_y[i] = ImGui.GetWindowPos()
            if EUR_EVENTS[eur_localFactionName][i].image ~= nil then
                ImGui.Image(EUR_EVENTS[eur_localFactionName][i].image.img, 160*eurbackgroundWindowSizeRight, 128*eurbackgroundWindowSizeBottom)
            end
            ImGui.EndChild()

            ImGui.SetNextWindowBgAlpha(0.5)
            ImGui.SetNextWindowPos(pos_x[i], pos_y[i])
            ImGui.BeginChild("Name3".. tostring(i), 160*eurbackgroundWindowSizeRight, 128*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
            centeredText(EUR_EVENTS[eur_localFactionName][i].name, 0)
            ImGui.NewLine()
            centeredText(("(Locked)"), 0)
            ImGui.NewLine()
            local hovered = ImGui.IsWindowHovered(ImGuiHoveredFlags.ChildWindows)
            if hovered then
                ImGui.NewLine()
                ImGui.BeginTooltip()
                if EUR_EVENTS[eur_localFactionName][i].active_duration > 0 then
                    ImGui.Text("ror active: "..tostring(EUR_EVENTS[eur_localFactionName][i].active_duration.." turns remaining."))
                else
                    if EUR_EVENTS[eur_localFactionName][i].locked_desc ~= nil then
                        ImGui.Text(EUR_EVENTS[eur_localFactionName][i].locked_desc)
                    end
                end
                ImGui.EndTooltip()
            end
            ImGui.EndChild()
        end
        --ImGui.EndChild()
    end
    ImGui.EndChild()
    if edu ~= nil then
        rorSideWindow()
    end
    ImGui.EndChild()
end


function rorSideWindow()
    if ror_number ~= nil then
        local edu = M2TWEOPDU.getEduEntryByType(ELITE_EDU[ror_number])
        if edu == nil then return end
        ImGui.SameLine()
        ImGui.BeginGroup()
        ImGui.SetNextWindowBgAlpha(0.5)
        ImGui.BeginChild("ror_window_02", 620*eurbackgroundWindowSizeRight, 620*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
        ImGui.TextWrapped("hey")
        --centeredText(EUR_EVENTS[faction_name][event_number].name, 20)
        ImGui.NewLine()
        --ImGui.TextWrapped("Gold: "..tostring(EUR_EVENTS[faction_name][event_number].cost))
        --ImGui.TextWrapped("Cooldown: "..tostring(EUR_EVENTS[faction_name][event_number].cooldown))
        ImGui.NewLine()
        ImGui.SetNextWindowBgAlpha(0)
        ImGui.BeginChild("ror_window_05", 400*eurbackgroundWindowSizeRight, 150*eurbackgroundWindowSizeBottom)
        ImGui.TextWrapped(edu.eduType)
        --ImGui.TextWrapped(EUR_EVENTS[faction_name][event_number].desc)
        ImGui.EndChild()
        ImGui.NewLine()



        ImGui.EndChild()

        ImGui.SetNextWindowBgAlpha(0)
        ImGui.SetNextWindowPos(1115*eurbackgroundWindowSizeRight, 670*eurbackgroundWindowSizeBottom)
        ImGui.BeginChild("ror_window_03", 620*eurbackgroundWindowSizeRight, 60*eurbackgroundWindowSizeBottom)
        --if EUR_EVENTS[faction_name][event_number].active_cooldown == 0 then
            --if eur_event_min_cooldown == 0 then
            if eur_player_faction.money >= edu.recruitCost then
                local sett = eur_player_faction.capital
                if sett ~= nil then
                    if sett.army then
                        if sett.army.numOfUnits < 20 then
                            if (centeredImageButton("Accept", 80, 50, 0)) then
                                sett.army:createUnit(ELITE_EDU[ror_number], 2, 0, 0)
                            end
                        end
                    else
                        if (centeredImageButton("Accept", 80, 50, 0)) then
                            local army = stratmap.game.createArmyInSettlement(sett)
                            army:createUnit(ELITE_EDU[ror_number], 2, 0, 0)
                        end
                    end
                end
            else
                centeredText("Requires: ".. tostring(edu.recruitCost) .. " Gold.", 20)
            end
            --else
                --centeredText("Too soon since last event, next available in: ".. tostring(eur_event_min_cooldown) .. " Turns.", 20)
            --end
        --else
            --centeredText("Event on cooldown for: ".. tostring(EUR_EVENTS[faction_name][event_number].active_cooldown) .. " Turns.", 20)
        --end
        ImGui.EndChild()
        ImGui.EndGroup()
    end
end
