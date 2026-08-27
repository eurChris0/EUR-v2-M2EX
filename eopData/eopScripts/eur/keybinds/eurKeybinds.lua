function BMapHighlight()
    cameraCoords = M2TWEOP.getBattleCamCoords();
    if not cameraCoords then return end
    M2TWEOP.toggleUnitsBMapHighlight();
end

function tacticalViewUp()
    cameraCoords = M2TWEOP.getBattleCamCoords();
    if not cameraCoords then return end;
        if cameraCoords.zCoord < 500 then
            cameraCoords.zCoord = cameraCoords.zCoord + 50
        end
end

function tacticalViewDown()
    cameraCoords = M2TWEOP.getBattleCamCoords();
    if not cameraCoords then return end;
        if cameraCoords.zCoord > 60 then
            cameraCoords.zCoord = cameraCoords.zCoord - 50
        else
            cameraCoords.zCoord = 10
        end
end

function round1(x)
    return math.floor(x * 10 + 0.5) / 10
end

function battleOverviewWindow()
    cameraCoords = M2TWEOP.getBattleCamCoords();
    if not cameraCoords then return end;
    if eur_player_faction == nil then return end;
    local options1 = M2TWEOP.getOptions1();
    local options2 = M2TWEOP.getOptions2()
    local thisBattle = M2TW.battle
    if not (thisBattle.battleState == 5 or thisBattle.battleState == 7) then return end

    if options2.isNormalHud == 1 then
        ImGui.SetNextWindowPos(270*eurbackgroundWindowSizeRight, 945*eurbackgroundWindowSizeBottom)
        ImGui.SetNextWindowSize(255*eurbackgroundWindowSizeRight, 60*eurbackgroundWindowSizeBottom)
    elseif options2.isNormalHud == 0 then
        ImGui.SetNextWindowPos(1460*eurbackgroundWindowSizeRight, 120*eurbackgroundWindowSizeBottom)
        ImGui.SetNextWindowSize(180*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom)
    end
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.Begin("map_window_01", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoBackground, ImGuiWindowFlags.NoDecoration))
    eurStyle("battle_1", true)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    if thisBattle.battleSpeed == 0.0 then
        thisBattle.battleSpeed = 1
    end
    local speedStr = string.format("%.1f", thisBattle.battleSpeed)

    if options2.isNormalHud == 0 then
        ImGui.SetNextWindowPos(1524*eurbackgroundWindowSizeRight, 123*eurbackgroundWindowSizeBottom)
        ImGui.SetNextWindowBgAlpha(1)
        ImGui.BeginChild("Child Window##A13speedStr", 50*eurbackgroundWindowSizeRight, 28*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
        centeredText(speedStr, 0)
        ImGui.EndChild()
        ImGui.SameLine()
        --ImGui.Dummy(12, 0)
        ImGui.NewLine()
    end
    if ImGui.IsKeyDown(ImGuiKey.LeftShift) then
        ImGui.Dummy(0, 5*eurbackgroundWindowSizeBottom)
        local speed_down_big = ImGui.ImageButton("<<", minus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_down_big == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.battleSpeed <= 0.1 then
                thisBattle.paused = true
            elseif thisBattle.battleSpeed <= 0.5 then
                thisBattle.battleSpeed = 0.1
            else
                thisBattle.battleSpeed = round1(math.floor((thisBattle.battleSpeed - 0.1) / 0.5) * 0.5)
            end
        end
        hoveredSimple("Lower battle speed")
        ImGui.SameLine()
        local speed_down = ImGui.ImageButton("<", minus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_down == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.battleSpeed > 0.2 then
                thisBattle.battleSpeed = round1(thisBattle.battleSpeed - 0.1)
            elseif thisBattle.battleSpeed > 0.1 then
                thisBattle.battleSpeed = 0.1
            else
                thisBattle.paused = true
            end
        end
        hoveredSimple("Lower battle speed")
        ImGui.SameLine()
        if options2.isNormalHud == 1 then
            ImGui.SetNextWindowPos(372*eurbackgroundWindowSizeRight, 965*eurbackgroundWindowSizeBottom)
            ImGui.SetNextWindowBgAlpha(1)
            ImGui.BeginChild("Child Window##A13speedStr", 50*eurbackgroundWindowSizeRight, 28*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
            centeredText(speedStr, 0)
            ImGui.EndChild()
            ImGui.SameLine()
            ImGui.Dummy(12, 0)
            ImGui.SameLine()
        end
        local speed_up = ImGui.ImageButton(">", plus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_up == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.paused == true then
                thisBattle.paused = false
            elseif thisBattle.battleSpeed < 0.2 then
                thisBattle.battleSpeed = 0.2
            elseif thisBattle.battleSpeed < 12 then
                thisBattle.battleSpeed = round1(math.min(12, thisBattle.battleSpeed + 0.1))
            end
        end
        hoveredSimple("Raise battle speed")
        ImGui.SameLine()
        local speed_up_big = ImGui.ImageButton(">>", plus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_up_big == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.paused then
                thisBattle.paused = false
            elseif thisBattle.battleSpeed < 0.2 then
                thisBattle.battleSpeed = 0.5
            elseif thisBattle.battleSpeed < 12 then
                thisBattle.battleSpeed = round1(math.min(12, math.ceil((thisBattle.battleSpeed + 0.1) / 0.5) * 0.5))
            end
        end
        hoveredSimple("Raise battle speed")
        thisBattle.battleSpeed = round1(thisBattle.battleSpeed)
    else
        ImGui.Dummy(0, 5*eurbackgroundWindowSizeBottom)
        local speed_down_big = ImGui.ImageButton("<<", minus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_down_big == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.battleSpeed == 0.5 then
                thisBattle.paused = true
            elseif thisBattle.battleSpeed <= 3 then
                thisBattle.battleSpeed = 0.5
            else
                thisBattle.battleSpeed = (math.floor((thisBattle.battleSpeed - 1) / 3) * 3)
            end
        end
        hoveredSimple("Lower battle speed")
        ImGui.SameLine()
        local speed_down = ImGui.ImageButton("<", minus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_down == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.battleSpeed >= 2 then
                thisBattle.battleSpeed = thisBattle.battleSpeed - 1
            elseif thisBattle.battleSpeed == 1 then
                thisBattle.battleSpeed = 0.5
            elseif thisBattle.battleSpeed == 0.5 then
                thisBattle.paused = true
            end
        end
        hoveredSimple("Lower battle speed")
        ImGui.SameLine()
        if options2.isNormalHud == 1 then
            ImGui.SetNextWindowPos(372*eurbackgroundWindowSizeRight, 965*eurbackgroundWindowSizeBottom)
            ImGui.SetNextWindowBgAlpha(1)
            ImGui.BeginChild("Child Window##A13speedStr", 50*eurbackgroundWindowSizeRight, 28*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
            centeredText(speedStr, 0)
            ImGui.EndChild()
            ImGui.SameLine()
            ImGui.Dummy(12, 0)
            ImGui.SameLine()
        end
        local speed_up = ImGui.ImageButton(">", plus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_up == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.paused == true then
                thisBattle.paused = false
            elseif thisBattle.battleSpeed == 0.5 then
                thisBattle.battleSpeed = 1
            elseif thisBattle.battleSpeed <= 11 then
                thisBattle.battleSpeed = thisBattle.battleSpeed + 1
            end
        end
        hoveredSimple("Raise battle speed")
        ImGui.SameLine()
        local speed_up_big = ImGui.ImageButton(">>", plus.img, 42*eurbackgroundWindowSizeRight, 42*eurbackgroundWindowSizeBottom)
        if (speed_up_big == true) then
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            if thisBattle.paused then
                thisBattle.paused = false
            elseif thisBattle.battleSpeed == 0.5 then
                thisBattle.battleSpeed = 3
            elseif thisBattle.battleSpeed < 12 then
                thisBattle.battleSpeed = math.ceil((thisBattle.battleSpeed + 1) / 3) * 3
            end
        end
        hoveredSimple("Raise battle speed")
    end
    
    eurStyle("battle_1", false)
    ImGui.End()
end


