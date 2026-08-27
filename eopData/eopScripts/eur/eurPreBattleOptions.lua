local invalid_split_cat = {
    "ship",
    "siege",
}

saved_already_pre = false

function preBattleButton()
    ImGui.SetNextWindowPos(90*eurbackgroundWindowSizeRight, 140*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(150, 150)
    ImGui.Begin("pre_battle_button_01", true, bit.bor(ImGuiWindowFlags.NoDecoration,ImGuiWindowFlags.NoBackground))
    eurStyle("button_1", true)
    if icon_save then
        --[[if ImGui.ImageButton("pre_battle_button_1",icon_unit.img,50,50) then
            if eur_pre_battle_window == false then
                eur_pre_battle_window = true
                if EOP_WAVS["uicah_menuclick1"] ~= nil then
                    M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
                end
            else
                eur_pre_battle_window = false
                if EOP_WAVS["uicah_menuclick1"] ~= nil then
                    M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
                end
            end
        end
        ImGui.NewLine()]]
        if ImGui.ImageButton("pre_battle_button_2",icon_save.img,50*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeRight) then
            M2TWEOP.saveGame(M2TWEOP.getModPath().."\\saves\\eurprebattle.sav")
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            saved_already_pre = true
        end
        hoveredSimple("Save Game")
        if saved_already_pre then
            ImGui.TextColored(0,0,0,1,"Saved!")
        end
    else
        --
    end
    eurStyle("button_1", false)
    ImGui.End()
end

function preBattleWindow()
        ImGui.SetNextWindowPos(1075*eurbackgroundWindowSizeRight, 10*eurbackgroundWindowSizeBottom)
        ImGui.SetNextWindowBgAlpha(0)
        ImGui.SetNextWindowSize(840*eurbackgroundWindowSizeRight, 600*eurbackgroundWindowSizeBottom)
        ImGui.Begin("pre_battle_window_background", true, bit.bor(ImGuiWindowFlags.NoDecoration))
        eurStyle("basic_1", true)
        if bg_small_1 then
            ImGui.Image(bg_small_1.img, 835*eurbackgroundWindowSizeRight, 590*eurbackgroundWindowSizeBottom)
        end
        ImGui.SetNextWindowBgAlpha(0.5)
        ImGui.SetNextWindowPos(1075*eurbackgroundWindowSizeRight, 85*eurbackgroundWindowSizeBottom)
        ImGui.BeginChild("pre_battle_child_1", 840*eurbackgroundWindowSizeRight, 450*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
        ImGui.NewLine()
        ImGui.Separator()
        local temp = {}
        local temp_name = {}
        if temp_player_army ~= nil then
            for i = 0, temp_player_army.numOfUnits - 1 do
                local unit = temp_player_army:getUnit(i)
                if unit.character == nil then
                    if not tableContains(invalid_split_cat, unit.eduEntry.category) then
                        if not tableContains(temp_units, unit) then
                            if unit.soldierCountStratMap > 40 then
                                table.insert(temp, unit)
                                table.insert(temp_name, unit.eduEntry.eduType)
                            end
                        end
                    end
                end
            end
            temp_temp_player_army_target, temp_temp_player_army_target_clicked = ImGui.Combo("", temp_temp_player_army_target, temp_name, #temp_name, #temp_name+1)
            if temp_temp_player_army_target_clicked then 
                temp_value = 20
            end
            if temp_player_army.numOfUnits < 20 then
                if temp[1] ~= nil then
                    local unit = temp[temp_temp_player_army_target+1]
                    temp_value, used = ImGui.SliderInt("", temp_value, 20, unit.soldierCountStratMap-20, "%d")
                    if (ImGui.Button("Split", 80, 50)) then
                        local val1 = math.floor(unit.soldierCountStratMap-temp_value)
                        local val2 = math.floor(temp_value)
                        if val1+val2 < unit.soldierCountStratMap then
                            val1 = val1+(unit.soldierCountStratMap-(val1+val2))
                        end
                        local temp_unit = temp_player_army:createUnit(unit.eduEntry.eduType, unit.exp, unit.weaponLVL, unit.armourLVL)
                        unit.soldierCountStratMap = val1
                        temp_unit.soldierCountStratMap = val2
                        table.insert(temp_units, unit)
                        table.insert(temp_units, temp_unit)
                        temp_unit_nu = temp_unit_nu+2
                        temp_temp_player_army_target = 0
                        temp_value = 20
                    end
                else
                    ImGui.TextColored(1,0,0,1,"No valid units.")
                end
            else
                ImGui.TextColored(1,0,0,1,"Not enough room in army.")
            end
        end
        ImGui.EndChild()
        if (centeredImageButton("Undo", 80, 50, -40)) then
            restoreSplitUnits(false)
        end
        ImGui.SameLine()
        if (centeredImageButton("Close", 80, 50, 40)) then
            eur_pre_battle_window = false
            if EOP_WAVS["uicah_menuclick1"] ~= nil then
                M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
            end
        end
        eurStyle("basic_1", false)
        ImGui.End()
end

function restoreSplitUnits(bool)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."restoreSplitUnits");
	end
    if temp_unit_nu == 0 then return end
    for i = 1, temp_unit_nu do
        if (i % 2 == 1) then
            local un1 = temp_units[i]
            local un2 = temp_units[i+1]
            if un1.soldierCountStratMap > 0 then
                --print("un1")
                if un2.soldierCountStratMap > 0 then
                    --print("un2")
                    un1.soldierCountStratMap = un1.soldierCountStratMap+un2.soldierCountStratMap
                    if un2.exp ~= un1.exp then 
                        un1.exp = math.floor(un1.exp+un2.exp/2)
                    end
                    un2.soldierCountStratMap = 1
                    un2:kill()
                end
            end
        end
    end
    temp_units = {}
    temp_unit_nu = 0
    if bool then
        temp_player_army = nil
    end
end
