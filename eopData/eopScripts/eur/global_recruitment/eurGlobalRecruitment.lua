sett_list = {}
sett_list_outrange = {}
sett_distance_list = {}
local index = 0
local index_outrange = 0

global_settlement = nil

global_recruit_current = 0
global_range = 2500
global_cost_mod = 1.5

scrollbar_y = 0
reset_scroll_y = false

UNIT_FILTER = {}
UNIT_FILTER_notif = {}

upgrade_clicked = {}

notif_count = 0

local creating_unit = false
local checking_already = false

local size_filter = 80
local size_unit = 80
local filter_enabled = false
local global_notif_enabled = false

local single_filter_global = false
local single_filter_target = ""

function drawGlobalCardExtras(text, eduType, xp, armour, weapon_melee_simple, weapon_melee_blade, weapon_missile_mechanical)
    local eduEntry = M2TWEOPDU.getEduEntryByType(eduType);
    local isMissile = false
    local isMelee = false
    local unitArmour = 0
    if eduEntry ~= nil then
        local armlevels = {}
        local num = eduEntry:getArmourLevelNum()
        if num ~= nil then
            for u = 0, num - 1 do
                local armlevel = eduEntry:getArmourLevel(u)
                if armlevel ~= nil then
                    if armour >= armlevel then
                        unitArmour = u
                    end
                end
            end
        end
        if eduEntry.primaryStats ~= nil then
            if eduEntry.primaryStats.projectile ~= nil then
                isMissile = true
            else
                isMelee = true
            end
        end
        if text == nil then return end
        minIndentation = 65*eurbackgroundWindowSizeRight

        local textWidth, textHeight = ImGui.CalcTextSize(text);
        local windowWidth           = ImGui.GetWindowWidth()

        local textIndentation = (windowWidth - textWidth) * 0.5;

        if textIndentation <= minIndentation then
            textIndentation = minIndentation
        end

        ImGui.SameLine(textIndentation);
        ImGui.PushTextWrapPos(windowWidth - textIndentation);

        ImGui.TextWrapped(text)
        ImGui.PopTextWrapPos()

        local offset = -32*eurbackgroundWindowSizeRight
        local offset2 = -30*eurbackgroundWindowSizeRight
        local windowWidth = ImGui.GetWindowWidth()
        local centre_position_for_button = (windowWidth - 16*eurbackgroundWindowSizeRight) / 2;
        local y_pos = 30*eurbackgroundWindowSizeBottom
        if xp > 0 then
            local chevron_img = chevron_bronze.img
            if xp >= 7 then
                chevron_img = chevron_gold.img
            elseif xp >= 4 then
                chevron_img = chevron_silver.img
            else
                chevron_img = chevron_bronze.img
            end
            for i = 1, xp do
                ImGui.SetCursorPosX(centre_position_for_button+offset2);
                ImGui.SetCursorPosY(y_pos);
                ImGui.Image(chevron_img, 16*eurbackgroundWindowSizeRight, 8*eurbackgroundWindowSizeBottom)
                y_pos = y_pos + 6*eurbackgroundWindowSizeBottom
            end
        end
        if weapon_missile_mechanical > 0 and isMissile then
            local sword_img = sword_bronze.img
            if weapon_missile_mechanical == 3 then
                sword_img = sword_gold.img
            elseif weapon_missile_mechanical == 2 then
                sword_img = sword_silver.img
            else
                sword_img = sword_bronze.img
            end
            ImGui.SetCursorPosX(centre_position_for_button+offset);
            ImGui.SetCursorPosY(45*eurbackgroundWindowSizeBottom);
            ImGui.Image(sword_img, 18*eurbackgroundWindowSizeRight, 14*eurbackgroundWindowSizeBottom)
        elseif weapon_melee_blade > 0 and isMelee then
            local sword_img = sword_bronze.img
            if weapon_melee_blade == 3 then
                sword_img = sword_gold.img
            elseif weapon_melee_blade == 2 then
                sword_img = sword_silver.img
            else
                sword_img = sword_bronze.img
            end
            ImGui.SetCursorPosX(centre_position_for_button+offset);
            ImGui.SetCursorPosY(48*eurbackgroundWindowSizeBottom);
            ImGui.Image(sword_img, 18*eurbackgroundWindowSizeRight, 14*eurbackgroundWindowSizeBottom)
        end
        if unitArmour > 0 then
            local shield_img = shield_bronze.img
            if unitArmour >= 3 then
                shield_img = shield_gold.img
            elseif unitArmour == 2 then
                shield_img = shield_silver.img
            else
                shield_img = shield_bronze.img
            end
            ImGui.SetCursorPosX(centre_position_for_button+offset);
            ImGui.SetCursorPosY(64*eurbackgroundWindowSizeBottom);
            ImGui.Image(shield_img, 18*eurbackgroundWindowSizeRight, 14*eurbackgroundWindowSizeBottom)
        end
    end

end

function checkSettRange(remote_x, remote_y, central_x, central_y)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."checkSettRange");
	end
    if not remote_x then return false end
    if not remote_y then return false end
    if not central_x then return false end
    if not central_y then return false end
    local check_x = false
    local check_y = false
    if (remote_x-central_x or remote_x-central_x) < global_range and (remote_x-central_x or remote_x-central_x) > -global_range then
        check_x = true
    end
    if (remote_y-central_y or remote_y-central_y) < global_range and (remote_y-central_y or remote_y-central_y) > -global_range then
        check_y = true
    end
    if check_y and check_x then
        return true
    end

    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function globalRecruitment(local_sett, remote_sett, unit, index, time, cost, exp, armour, weapon_melee_blade, weapon_missile_mechanical)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."globalRecruitment");
	end
    local isMissile = false
    local isMelee = false
    if unit.primaryStats ~= nil then
        if unit.primaryStats.projectile ~= nil then
            isMissile = true
        else
            isMelee = true
        end
    end
    local unitArmour = 0
    local num = unit:getArmourLevelNum()
    if num ~= nil then
        for u = 0, num - 1 do
            local armlevel = unit:getArmourLevel(u)
            if armlevel ~= nil then
                if armour >= armlevel then
                    unitArmour = u
                end
            end
        end
    end
    local val = 0
    for i = 0, 100 do 
        if global_recruits[local_sett.name..unit.eduType..tostring(i)] == nil then
            val = i
            i = 101
        end
    end
    global_recruits[local_sett.name..unit.eduType..tostring(val)] = {}
    global_recruits[local_sett.name..unit.eduType..tostring(val)].local_sett = local_sett.name
    global_recruits[local_sett.name..unit.eduType..tostring(val)].remote_sett = remote_sett.name
    global_recruits[local_sett.name..unit.eduType..tostring(val)].eduEntry = unit.eduType
    global_recruits[local_sett.name..unit.eduType..tostring(val)].cost = cost
    global_recruits[local_sett.name..unit.eduType..tostring(val)].time = time
    global_recruits[local_sett.name..unit.eduType..tostring(val)].exp = exp
    if isMelee and weapon_melee_blade > 0 then
        global_recruits[local_sett.name..unit.eduType..tostring(val)].weapon = weapon_melee_blade
    elseif isMissile and weapon_missile_mechanical > 0 then
        global_recruits[local_sett.name..unit.eduType..tostring(val)].weapon = weapon_missile_mechanical
    else
        global_recruits[local_sett.name..unit.eduType..tostring(val)].weapon = 0
    end
    global_recruits[local_sett.name..unit.eduType..tostring(val)].armour = unitArmour
    local unit_pool = nil
    for x = 0, remote_sett.recruitmentPoolCount -1 do
        local unit_pool_check = remote_sett:getSettlementRecruitmentPool(x)
        if unit_pool_check ~= nil then
            if index == unit_pool_check.eduIndex then
                unit_pool = unit_pool_check
            end
        end
    end
    if unit_pool ~= nil then 
        unit_pool.availablePool = unit_pool.availablePool - 1
    end
    M2TWEOP.callConsole("add_money", "-" .. tostring(cost))
    recruitCheckGlobal()

    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function globalClearLostSett(sett)
    if sett == nil then return end
    if global_recruits == {} then return end
    for k, v in pairs(global_recruits) do
        if global_recruits[k] ~= nil then
            if sett.name == global_recruits[k].remote_sett then
                global_recruits[k] = nil
            end
        end
    end
end

function globalRecruitmentTurnCheck()
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."globalRecruitmentTurnCheck");
	end
    local uiList = ""
    if global_recruits == {} then return end
    for k, v in pairs(global_recruits) do
        if global_recruits[k] ~= nil then
            local local_sett = eur_sMap:getSettlement(global_recruits[k].local_sett)
            local remote_sett = eur_sMap:getSettlement(global_recruits[k].remote_sett)
            if global_recruits[k].time > 1 then
                if remote_sett.ownerFaction.factionID ~= eur_playerFactionId then
                    global_recruits[k] = nil
                else
                    if remote_sett.siegesNum > 0 then
                        -- do nothing
                    else
                        global_recruits[k].time = global_recruits[k].time - 1
                    end
                end
            else
                local eduEntry = M2TWEOPDU.getEduEntryByType(global_recruits[k].eduEntry);
                if remote_sett.ownerFaction.factionID == eur_playerFactionId then
                    if local_sett.ownerFaction.factionID == eur_playerFactionId then
                        if local_sett.siegesNum == 0 then
                            if local_sett.army then
                                local army = nil
                                local redirected = false
                                if local_sett.army.numOfUnits == 20 then
                                    nearby_sett = findNearbySettlement(local_sett)
                                    if not nearby_sett.army then
                                        army = stratmap.game.createArmyInSettlement(nearby_sett)
                                    else
                                        army = nearby_sett.army
                                    end
                                    redirected = true
                                else
                                    army = local_sett.army                                
                                end
                                if army == nil then return end
                                local unit = army:createUnit(eduEntry.eduType, global_recruits[k].exp, global_recruits[k].armour, global_recruits[k].weapon)
                                if unit ~= nil then
                                    if redirected then
                                        if army:findInSettlement() then
                                            uiList =
                                            uiList .."\n"..army:findInSettlement().localizedName.."(redirected) - "..eduEntry.eduType
                                            global_recruits[k] = nil
                                        end
                                    else
                                        if army:findInSettlement() then
                                            uiList =
                                            uiList .."\n"..army:findInSettlement().localizedName.." - "..eduEntry.eduType
                                            global_recruits[k] = nil
                                        end
                                    end
                                end
                            else
                                local army = stratmap.game.createArmyInSettlement(local_sett)
                                local unit = army:createUnit(eduEntry.eduType, global_recruits[k].exp, global_recruits[k].armour, global_recruits[k].weapon)
                                if unit ~= nil then
                                    uiList = uiList .."\n"..local_sett.localizedName.." - "..eduEntry.eduType
                                    global_recruits[k] = nil
                                end
                            end
                        else
                            local army = nil
                            local redirected = false
                            nearby_sett = findNearbySettlement(local_sett)
                            if nearby_sett ~= nil then
                                if nearby_sett.army == nil then
                                    army = stratmap.game.createArmyInSettlement(nearby_sett)
                                else
                                    army = nearby_sett.army
                                end
                                redirected = true
                            end
                            if army ~= nil then
                                local unit = army:createUnit(eduEntry.eduType, global_recruits[k].exp, global_recruits[k].armour, global_recruits[k].weapon)
                                if unit ~= nil then
                                    if redirected then
                                        if army:findInSettlement() then
                                            uiList =
                                            uiList .."\n"..army:findInSettlement().localizedName.."(redirected)".."\n".."Unit: "..eduEntry.eduType
                                            global_recruits[k] = nil
                                        end
                                    else
                                        if army:findInSettlement() then
                                            uiList =
                                            uiList .."\n"..army:findInSettlement().localizedName.." - "..eduEntry.eduType

                                            global_recruits[k] = nil
                                        end
                                    end
                                end
                            else
                                local sett = remote_sett
                                local unit_pool = sett:getSettlementRecruitmentPool(x)
                                local capability = nil
                                local capabilitynum = sett.recruitmentCapabilityNum
                                for y = 0, capabilitynum -1 do
                                    local temp_capability = sett:getRecruitmentCapability(y)
                                    if temp_capability.eduIndex == eduEntry.index then
                                        capability = temp_capability
                                    end
                                end
                                if capability ~= nil then
                                    if eduEntry.index == unit_pool.eduIndex then
                                        if (unit_pool.availablePool + 1) >= capability.maxSize then
                                            unit_pool.availablePool = capability.maxSize
                                            M2TWEOP.callConsole("add_money", "+" .. tostring(global_recruits[k].cost))
                                        else
                                            unit_pool.availablePool = unit_pool.availablePool + 1
                                            M2TWEOP.callConsole("add_money", "+" .. tostring(global_recruits[k].cost))
                                        end
                                        stratmap.game.historicEvent("battle_reinforcement", "Global Recruitment cancelled", "Units returned to queue at "..sett.localizedName)
                                    end
                                end
                                global_recruits[k] = nil
                            end
                        end                    
                    else
                        local sett = remote_sett
                        local unit_pool = sett:getSettlementRecruitmentPool(x)
                        local capability = nil
                        local capabilitynum = sett.recruitmentCapabilityNum
                        for y = 0, capabilitynum -1 do
                            local temp_capability = sett:getRecruitmentCapability(y)
                            if temp_capability.eduIndex == eduEntry.index then
                                capability = temp_capability
                            end
                        end
                        if capability ~= nil then
                            if eduEntry.index == unit_pool.eduIndex then
                                if (unit_pool.availablePool + 1) >= capability.maxSize then
                                    unit_pool.availablePool = capability.maxSize
                                    M2TWEOP.callConsole("add_money", "+" .. tostring(global_recruits[k].cost))
                                else
                                    unit_pool.availablePool = unit_pool.availablePool + 1
                                    M2TWEOP.callConsole("add_money", "+" .. tostring(global_recruits[k].cost))
                                end
                                stratmap.game.historicEvent("battle_reinforcement", "Global Recruitment cancelled", "Units returned to queue at "..sett.localizedName)
                            end
                        end
                        global_recruits[k] = nil
                    end
                else
                    global_recruits[k] = nil
                end
            end
        end
    end
    print(uiList)
    if uiList ~= "" then
        stratmap.game.historicEvent("battle_reinforcement", "Global Recruitment", "Units recuited \n" .. uiList)
    end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function findNearbySettlement(sett)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."findNearbySettlement");
	end
    local temp_sett = nil
    local coord_check = 0
    local new_coords = 0 
    local central_x, central_y = sett.xCoord, sett.yCoord
    local faction = sett.ownerFaction
    for i = 0, faction.settlementsNum - 1 do
        local near_sett = faction:getSettlement(i)
        if near_sett.name ~= sett.name then
            if near_sett.army then
                if near_sett.army.numOfUnits < 20 then
                    if temp_sett == nil then
                        temp_sett = near_sett
                        coord_check = getDistance(sett.xCoord, sett.yCoord, near_sett.xCoord, near_sett.yCoord)
                    end
                    new_coords = getDistance(sett.xCoord, sett.yCoord, near_sett.xCoord, near_sett.yCoord)
                    if new_coords < coord_check then
                        temp_sett = near_sett
                        coord_check = new_coords
                    end
                end
            else
                if temp_sett == nil then
                    temp_sett = near_sett
                    coord_check = getDistance(sett.xCoord, sett.yCoord, near_sett.xCoord, near_sett.yCoord)
                end
                new_coords = getDistance(sett.xCoord, sett.yCoord, near_sett.xCoord, near_sett.yCoord)
                if new_coords < coord_check then
                    temp_sett = near_sett
                    coord_check = new_coords
                end
            end
        end
    end
    if temp_sett ~= nil then
        return temp_sett
    end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function globalRecruitButton()
    ImGui.SetNextWindowPos(1320*eurbackgroundWindowSizeRight, 750*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(85*eurbackgroundWindowSizeRight, 60*eurbackgroundWindowSizeBottom)
    ImGui.Begin("Global_1", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse,ImGuiWindowFlags.NoDecoration,ImGuiWindowFlags.NoBackground))
    
    eurStyle("button_1", true)
    local show_global_text = "Show Global Recruitment"
    local icon = icon_unit
    if notif_count > 0 then
        icon = icon_unit2
        show_global_text = "Show Global Recruitment - Units available"
    else
    end
    if icon then
        if ImGui.ImageButton("Global_button_1",icon.img,50*eurbackgroundWindowSizeRight,48*eurbackgroundWindowSizeBottom) then
            if window_states.show_globalrecruit_window == false then
                set_active_left_window("show_globalrecruit_window")
                local settlementInfoScroll = M2TWEOP.getSettlementInfoScroll();
                if settlementInfoScroll ~= nil then
                    if settlementInfoScroll.settlement ~= nil then
                        global_settlement = settlementInfoScroll.settlement
                        recruitCheckGlobal()
                    end
                end
                M2TWEOP.scriptCommand("play_sound_event", "STRAT_SCROLL_OPENS")
            else
                window_states.show_globalrecruit_window = false
                M2TWEOP.scriptCommand("play_sound_event", "STRAT_SCROLL_CLOSES")
            end
        end
        hoveredSimple(show_global_text)
    end
        eurStyle("button_1", false)
    ImGui.End()
end

function globalRecruitWindow()
    local settlementInfoScroll = M2TWEOP.getSettlementInfoScroll();
    if settlementInfoScroll ~= nil then
        if settlementInfoScroll.settlement ~= nil then
            global_settlement = settlementInfoScroll.settlement
        end
    end
    ImGui.SetNextWindowPos(5*eurbackgroundWindowSizeRight, 5*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(955*eurbackgroundWindowSizeRight, 825*eurbackgroundWindowSizeBottom)
    ImGui.Begin("global_window_background", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    eurStyle("basic_4", true)
    if faction_bg[M2TWEOP.getCultureName(eur_player_faction.cultureID)] then
        ImGui.Image(faction_bg[M2TWEOP.getCultureName(eur_player_faction.cultureID)].img, 945*eurbackgroundWindowSizeRight, 815*eurbackgroundWindowSizeBottom)
    end

    ImGui.SetNextWindowPos(250*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.SetNextWindowSize(500*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeBottom)
    ImGui.BeginChild("Child Window##A13", 500*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)


    ImGui.Image(global_text.img,500*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
    ImGui.EndChild()

    ImGui.SetNextWindowBgAlpha(0.4)
    ImGui.SetNextWindowPos(70*eurbackgroundWindowSizeRight, 100*eurbackgroundWindowSizeBottom)
    ImGui.BeginChild("Child Window##A12", 820*eurbackgroundWindowSizeRight, 645*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    globalTab1()
    ImGui.EndChild()
    eurStyle("basic_4", false)
    eurStyle("button_1", true)
    ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
    if faction_bu[M2TWEOP.getCultureName(eur_player_faction.cultureID)] then
        if centeredImageButtonReal("##upgclose", faction_bu[M2TWEOP.getCultureName(eur_player_faction.cultureID)].img, 100*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom, 420*eurbackgroundWindowSizeRight) then
            window_states.show_globalrecruit_window = false
            recruitCheckGlobal()
            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        end
        local hovered = ImGui.IsItemHovered()
        if hovered then
            eurStyle("tooltip", true)
            ImGui.BeginTooltip()
            ImGui.Text("Close this scroll")
            ImGui.EndTooltip()
            eurStyle("tooltip", false)
        end
    end
    eurStyle("button_1", false)
    ImGui.End()
end

sett_info = {}

function fillSetInfo()
    sett_info = {}
    notif_count = 0
    global_recruit_limit = game_options.global_recruit_start
    for i = 0, eur_player_faction.settlementsNum - 1 do
        local sett = eur_player_faction:getSettlement(i)
        if sett ~= nil then
            sett_info[sett.name] = {}
            if game_options.global_waystation_inc_max then
                if sett:buildingPresentMinLevel("military_academy", true) then
                    if global_recruit_limit < game_options.global_recruit_max then
                        global_recruit_limit = global_recruit_limit + 1
                    else
                        global_recruit_limit = game_options.global_recruit_max
                    end
                end
            else
                global_recruit_limit = game_options.global_recruit_max
            end
            if sett.siegesNum > 0 then
                sett_info[sett.name].seiged = true
            else
                sett_info[sett.name].seiged = false
            end
            sett_info[sett.name].hidden = true
            if not game_options.global_recruitment_hidenounits then
                sett_info[sett.name].hidden = false
            end
            sett_info[sett.name].capcount = 0
            sett_info[sett.name].waystation = false
            sett_info[sett.name].localizedName = sett.localizedName
            sett_info[sett.name].isCastle = sett.isCastle
            sett_info[sett.name].xCoord = sett.xCoord
            sett_info[sett.name].yCoord = sett.yCoord
            sett_info[sett.name].unitInQueueCount = sett.unitInQueueCount
            sett_info[sett.name].armourlvl = sett:getSettlementCapability(buildingCapability.armour).value
            sett_info[sett.name].weapon_melee_simple = sett:getSettlementCapability(buildingCapability.weapon_melee_simple).value
            sett_info[sett.name].weapon_melee_blade = sett:getSettlementCapability(buildingCapability.weapon_melee_blade).value
            sett_info[sett.name].weapon_missile_mechanical = sett:getSettlementCapability(buildingCapability.weapon_missile_mechanical).value
            sett_info[sett.name].recruit_slots = sett:getSettlementCapability(56).value
            local items = sett:getRecruitmentOptions()
            local unitindex = 0
            if items ~= nil then
                local capcount = 0
                for y = 0, sett.recruitmentCapabilityNum -1 do
                    local cap_check = sett:getRecruitmentCapability(y)
                    if cap_check ~= nil then
                        if cap_check.maxSize >= 1 then
                            capcount = capcount + 1
                        end
                    end
                end
                --sett_info[sett.name].capcount = capcount
                local index = 0
                for j = 0, items.unitNum -1 do
                    local unit = items:getRecruitmentOption(j)
                    if unit.recruitType == 0 then
                        if unit.cost > 0 then
                            for x = 0, sett.recruitmentPoolCount -1 do
                                local unit_pool = sett:getSettlementRecruitmentPool(x)
                                if unit_pool ~= nil then
                                    if unit.eduEntry ~= nil then --ok
                                        if default_general_units[eur_player_faction.name].old ~= nil then --ok
                                            if unit.eduEntry.index == unit_pool.eduIndex then --f
                                                if not sett_info[sett.name].unit then
                                                    sett_info[sett.name].unit = {}
                                                end
                                                for y = 0, sett.recruitmentCapabilityNum -1 do
                                                    local cap = sett:getRecruitmentCapability(y)
                                                    if cap ~= nil then
                                                        if cap.eduIndex == unit.eduEntry.index then
                                                            sett_info[sett.name].unit[index] = {}
                                                            sett_info[sett.name].unit[index].getRecruitmentOption = j
                                                            sett_info[sett.name].unit[index].xp = cap.xp
                                                            sett_info[sett.name].unit[index].active = false
                                                            sett_info[sett.name].unit[index].maxSize = cap.maxSize
                                                            sett_info[sett.name].unit[index].replenishRate = cap.replenishRate
                                                            sett_info[sett.name].unit[index].eduType = unit.eduEntry.eduType
                                                            sett_info[sett.name].unit[index].localizedName = unit.eduEntry.localizedName
                                                            sett_info[sett.name].unit[index].unitCardTga = unit.eduEntry.unitCardTga
                                                            sett_info[sett.name].unit[index].availablePool = unit_pool.availablePool 
                                                            sett_info[sett.name].unit[index].eduIndex = unit_pool.eduIndex
                                                            sett_info[sett.name].unit[index].cost = unit.cost
                                                            sett_info[sett.name].unit[index].recruitTime = unit.recruitTime
                                                            if not UNIT_FILTER[unit.eduEntry.eduType] then
                                                                UNIT_FILTER[unit.eduEntry.eduType] = {}
                                                                UNIT_FILTER[unit.eduEntry.eduType].active = true
                                                                UNIT_FILTER[unit.eduEntry.eduType].eduType = unit.eduEntry.eduType
                                                                UNIT_FILTER[unit.eduEntry.eduType].localizedName = unit.eduEntry.localizedName
                                                                UNIT_FILTER[unit.eduEntry.eduType].unitCardTga = unit.eduEntry.unitCardTga
                                                                upgrade_clicked[unit.eduEntry.eduType] = false
                                                            end
                                                            if not UNIT_FILTER_notif[unit.eduEntry.eduType] then
                                                                UNIT_FILTER_notif[unit.eduEntry.eduType] = {}
                                                                UNIT_FILTER_notif[unit.eduEntry.eduType].active = true
                                                                UNIT_FILTER_notif[unit.eduEntry.eduType].eduType = unit.eduEntry.eduType
                                                                UNIT_FILTER_notif[unit.eduEntry.eduType].localizedName = unit.eduEntry.localizedName
                                                                UNIT_FILTER_notif[unit.eduEntry.eduType].unitCardTga = unit.eduEntry.unitCardTga
                                                                
                                                            end
                                                            if game_options.global_waystation_req then
                                                                sett_info[sett.name].waystation = sett:buildingPresentMinLevel("military_academy", false)
                                                            else
                                                                sett_info[sett.name].waystation = true
                                                            end
                                                            
                                                            if UNIT_FILTER ~= {} then
                                                                for k, v in pairs(UNIT_FILTER) do
                                                                    if UNIT_FILTER[k] ~= nil then
                                                                        if (UNIT_FILTER[k].active and not single_filter_global) or (single_filter_global and k == single_filter_target) then
                                                                            if UNIT_FILTER[k].eduType == unit.eduEntry.eduType then
                                                                                --print("setting false")
                                                                                if cap.maxSize >= 1 then
                                                                                    sett_info[sett.name].hidden = false
                                                                                    sett_info[sett.name].unit[index].active = true
                                                                                    --sett_info[sett.name].capcount = sett_info[sett.name].capcount + 1
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            if UNIT_FILTER_notif ~= {} then
                                                                for k, v in pairs(UNIT_FILTER_notif) do
                                                                    if UNIT_FILTER_notif[k] ~= nil then
                                                                        if not UNIT_FILTER_notif[k].active then
                                                                            if UNIT_FILTER_notif[k].eduType == unit.eduEntry.eduType then
                                                                                if unit_pool.availablePool >= 1 then
                                                                                    notif_count = notif_count + 1
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            index = index + 1
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function recruitCheckGlobal()
    if creating_unit then return end
    if checking_already then return end
    checking_already = true
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."recruitCheckGlobal");
	end
    logHelper("1")
    --print(1)
    if global_settlement == nil then checking_already = false return end
    --print(2)
    logHelper("2")
    sett_list = {}
    sett_list_outrange = {}
    sett_distance_list = {}
    local temp = nil
    index = 0
    index_outrange = 0
    local central_x, central_y = global_settlement.xCoord, global_settlement.yCoord
    local faction = eur_player_faction
    logHelper("3")
    if faction ~= nil then
        logHelper("4")
        --print(3)
        if faction.settlementsNum == 0 then return end
        --print(4)
        for i = 0, faction.settlementsNum - 1 do
            logHelper("5")
            --print(5)
            local sett = faction:getSettlement(i)
            if sett ~= nil then
            logHelper("6")
            if checkSettRange(sett.xCoord, sett.yCoord, central_x, central_y) then
                    sett_list[index] = sett
                    if global_settlement == sett then
                        logHelper("7")
                        if index > 0 then
                            temp = sett_list[0]
                            sett_list[0] = sett
                            sett_list[index] = temp
                        end
                        logHelper("8")
                    end
                    index = index + 1
                else
                    sett_list_outrange[index_outrange] = sett
                    index_outrange = index_outrange + 1
                    logHelper("9")
                end
            end
        end
        logHelper("10")
        if game_options.global_sort_aphabetically then
            if sett_list ~= {} then
                logHelper("11")
                table.sort(sett_list, function(a, b)
                    return a.localizedName < b.localizedName
                end)
            end
        elseif game_options.global_sort_distance then
            logHelper("12")
            globalSortOnDistance()
        end
        logHelper("13")
        fillSetInfo()
        logHelper("14")
    end
    checking_already = false
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function globalSortOnDistance()
    local dist_check = {}
    if global_settlement == nil then return end
    for i = 0, #sett_list do
        if sett_list[i] ~= nil then
            local settname = sett_list[i].name
            if sett_info[settname] ~= nil then
                dist_check[settname] = getDistance(global_settlement.xCoord, global_settlement.yCoord, sett_info[settname].xCoord, sett_info[settname].yCoord)
            end
        end
    end

    table.sort(sett_list, function(a, b)
        local distA = dist_check[a.name] or math.huge
        local distB = dist_check[b.name] or math.huge
        return distA < distB
    end)
end

function scrollBarReset()
    if reset_scroll_y then
        --print("reset scroll bar to "..tostring(scrollbar_y))
        ImGui.SetScrollY(scrollbar_y)
        reset_scroll_y = false
    end

end

function createUnitReset()
    creating_unit = false
    recruitCheckGlobal()
end

function addToLocalQueue(itemsnum, settname)
    --M2TWEOP.logGame("EUR SCRIPT: "..tostring(itemsnum));
    creating_unit = true
    local settlement = eur_sMap:getSettlement(settname)
    if settlement == nil then return end
    local items = settlement:getRecruitmentOptions()
    if items ~= nil then
        local unit = items:getRecruitmentOption(itemsnum)
        if unit ~= nil then
            if unit.eduEntry ~= nil then
                print(unit.eduEntry.eduType)
                print(unit.cost)
                unit:addUnitToQueue()
            end
        end
    end
    --wait(createUnitReset,0.05)
    creating_unit = false
    recruitCheckGlobal()
end

function globalTab1()
    size_filter = 90
    --eurStyle("basic_4", true)
    ImGui.Text("Sort:  ")
    ImGui.SameLine()
    game_options.global_sort_aphabetically,  global_sort_aphabeticallypressed = ImGui.Checkbox("A-Z  ", game_options.global_sort_aphabetically)
    hoveredSimple("Sort settlements in the UI alphabetically.")
    ImGui.SameLine()
    game_options.global_sort_distance,  global_sort_distancepressed = ImGui.Checkbox("Distance  ", game_options.global_sort_distance)
    hoveredSimple("Sort settlements in the UI by distance to the local settlement.")
    ImGui.SameLine()
    game_options.global_recruitment_hidenounits, global_recruitment_hidenounitspressed = ImGui.Checkbox("Hide empty##global1", game_options.global_recruitment_hidenounits)
    hoveredSimple("Hide settlements that have no units to recruit, or have all their recruited units hidden.")
    filter_enabled, filterpressed = ImGui.Checkbox("Filter Units", filter_enabled)
    hoveredSimple("Filter which units appear in the Global Recruitment UI.")
    --ImGui.SameLine()
    global_notif_enabled, notifpressed = ImGui.Checkbox("Notification", global_notif_enabled)
    hoveredSimple("Enable notification icon when specified units are available to recruit.")

    if global_recruitment_hidenounitspressed then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        recruitCheckGlobal()
    end

    if global_sort_aphabeticallypressed then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        if game_options.global_sort_aphabetically then
            game_options.global_sort_distance = false
        end
        recruitCheckGlobal()
    end
    if global_sort_distancepressed then
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
        if game_options.global_sort_distance then
            game_options.global_sort_aphabetically = false
        end
        recruitCheckGlobal()
    end

    if filterpressed then
        global_notif_enabled = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    if notifpressed then
        filter_enabled = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    if filter_enabled then
        local filterindex = 0
        for k, v in pairs(UNIT_FILTER) do
            if filterindex == 11 then
                size_filter = 180
            elseif filterindex == 21 then
                size_filter = 270
            elseif filterindex == 31 then
                size_filter = 360
            end
            filterindex = filterindex + 1
        end
        ImGui.SetNextWindowBgAlpha(0.0)
        ImGui.BeginChild("global_child_sub_1_filter", 940*eurbackgroundWindowSizeRight, size_filter*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
        local filterindex = 0
        for k, v in pairs(UNIT_FILTER) do
            if filterindex ~= 0 and filterindex ~= 10 and filterindex ~= 20 and filterindex ~= 30 then
                ImGui.SameLine()
            end
            if (UNIT_FILTER[k].active and not single_filter_global) or (single_filter_global and k == single_filter_target) then
                ImGui.PushStyleColor(ImGuiCol.Button, 1, 1, 1, 0.1)
                ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 1, 1, 1, 0.2)
            else
                ImGui.PushStyleColor(ImGuiCol.Button, 0, 0, 0, 0.4)
                ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0, 0, 0, 0.5)
            end
            if eur_tga_table[UNIT_FILTER[k].unitCardTga] then
                upgrade_clicked[k] = ImGui.ImageButton(UNIT_FILTER[k].eduType,eur_tga_table[UNIT_FILTER[k].unitCardTga].img, img_x, img_y)
                if (upgrade_clicked[k] == true) then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    if not single_filter_global then
                        if ImGui.IsKeyDown(ImGuiKey.LeftShift) then
                            single_filter_global = true
                            single_filter_target = k
                        else
                            if UNIT_FILTER[k].active == true then
                                UNIT_FILTER[k].active = false
                            else
                                UNIT_FILTER[k].active = true
                            end
                        end
                    else
                        if ImGui.IsKeyDown(ImGuiKey.LeftShift) then
                            if single_filter_target == k then
                                single_filter_global = false
                                single_filter_target = ""
                            else
                                single_filter_target = k
                            end
                        else
                            single_filter_global = false
                        end
                    end
                    recruitCheckGlobal()
                end
                local hovered = ImGui.IsItemHovered()
                if hovered then
                    playMenuSound("7"..UNIT_FILTER[k].eduType)
                    eurStyle("tooltip", true)
                    ImGui.BeginTooltip()
                    ImGui.Text(UNIT_FILTER[k].eduType)
                    showEDUStats(UNIT_FILTER[k].eduType)
                    ImGui.NewLine()
                    ImGui.TextColored(0.75,0.75,0.75,1,"Hold shift to filter on this unit only.")
                    ImGui.EndTooltip()
                    eurStyle("tooltip", false)
                end
            end
            ImGui.PopStyleColor(2)
            filterindex = filterindex + 1
        end
        ImGui.EndChild()
    end
    if global_notif_enabled then
        local filterindex = 0
        for k, v in pairs(UNIT_FILTER_notif) do
            if filterindex == 11 then
                size_filter = 180
            elseif filterindex == 21 then
                size_filter = 270
            elseif filterindex == 31 then
                size_filter = 360
            end
            filterindex = filterindex + 1
        end
        ImGui.SetNextWindowBgAlpha(0.0)
        ImGui.BeginChild("global_child_sub_1_notif", 940*eurbackgroundWindowSizeRight, size_filter*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
        local filterindex = 0
        for k, v in pairs(UNIT_FILTER_notif) do
            if filterindex ~= 0 and filterindex ~= 10 and filterindex ~= 20 and filterindex ~= 30 then
                ImGui.SameLine()
            end
            if UNIT_FILTER_notif[k].active then
                ImGui.PushStyleColor(ImGuiCol.Button, 0, 0, 0, 0.4)
                ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0, 0, 0, 0.5)
            else
                ImGui.PushStyleColor(ImGuiCol.Button, 1, 1, 1, 0.1)
                ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 1, 1, 1, 0.2)
            end
            if eur_tga_table[UNIT_FILTER_notif[k].unitCardTga] then
                upgrade_clicked[k] = ImGui.ImageButton(UNIT_FILTER_notif[k].eduType,eur_tga_table[UNIT_FILTER_notif[k].unitCardTga].img, img_x, img_y)
                if (upgrade_clicked[k] == true) then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    if UNIT_FILTER_notif[k].active == true then
                        UNIT_FILTER_notif[k].active = false
                    else
                        UNIT_FILTER_notif[k].active = true
                    end
                    recruitCheckGlobal()
                end
                local hovered = ImGui.IsItemHovered()
                if hovered then
                    playMenuSound("7"..UNIT_FILTER_notif[k].eduType)
                    eurStyle("tooltip", true)
                    ImGui.BeginTooltip()
                    ImGui.Text(UNIT_FILTER_notif[k].eduType)
                    showEDUStats(UNIT_FILTER_notif[k].eduType)
                    ImGui.EndTooltip()
                    eurStyle("tooltip", false)
                end
            end
            ImGui.PopStyleColor(2)
            filterindex = filterindex + 1
        end
        ImGui.EndChild()
    end
    if global_recruit_current >= global_recruit_limit then
        ImGui.PushStyleColor(ImGuiCol.Text,0.8,0,0,1)
    end
    if not game_options.global_recruitment_localonly then
        ImGui.Text("Global Recruitment Queue: "..tostring(global_recruit_current).."/"..tostring(global_recruit_limit))
    else
        ImGui.Text("Global Recruitment Queue(disabled): "..tostring(global_recruit_current).."/"..tostring(global_recruit_limit))
    end
    if global_recruit_current >= global_recruit_limit then
        ImGui.PopStyleColor()
    end
    local global_active = false
    for k, v in pairs(global_recruits) do
        if global_recruits[k] ~= nil then
            global_active = true
        end
    end
    global_recruit_current = 0
    global_active = true
    local global_size = 90
    local filterindex = 0
    for k, v in pairs(global_recruits) do
        if filterindex >= 10 then
            global_size = 180
        end
        filterindex = filterindex + 1
    end
    if not game_options.global_recruitment_localonly then
        if global_active then
            ImGui.SetNextWindowBgAlpha(0.0)
            ImGui.BeginChild("global_child_sub_1_global_q", 940*eurbackgroundWindowSizeRight, global_size*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
            local filterindex = 0
            for k, v in pairs(global_recruits) do
                if global_recruits[k] ~= nil then
                    if filterindex ~= 0 and filterindex ~= 10 and filterindex ~= 20 and filterindex ~= 30 then
                        ImGui.SameLine()
                    end
                    local local_sett = eur_sMap:getSettlement(global_recruits[k].local_sett)
                    local remote_sett = eur_sMap:getSettlement(global_recruits[k].remote_sett)
                    local eduEntry = M2TWEOPDU.getEduEntryByType(global_recruits[k].eduEntry);
                    global_recruit_current = global_recruit_current + 1
                    local unit_tga = eduEntry.unitCardTga
                    if eur_tga_table[unit_tga] then
                        local upgrade_clicked = ImGui.ImageButton("index_"..k,eur_tga_table[unit_tga].img, img_x, img_y)
                        if (upgrade_clicked == true) then
                            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                            --add back to remote sett
                            for x = 0, remote_sett.recruitmentPoolCount -1 do
                                local sett = remote_sett
                                if sett.ownerFaction.name ~= eur_player_faction.name then
                                    global_recruits[k] = nil --return
                                end
                                local unit_pool = sett:getSettlementRecruitmentPool(x)
                                local capability = nil
                                local capabilitynum = sett.recruitmentCapabilityNum
                                for y = 0, capabilitynum -1 do
                                    local temp_capability = sett:getRecruitmentCapability(y)
                                    if temp_capability.eduIndex == eduEntry.index then
                                        capability = temp_capability
                                    end
                                end
                                if capability ~= nil then
                                    if eduEntry.index == unit_pool.eduIndex then
                                        if (unit_pool.availablePool + 1) >= capability.maxSize then
                                            unit_pool.availablePool = capability.maxSize
                                            M2TWEOP.callConsole("add_money", "+" .. tostring(global_recruits[k].cost))
                                        else
                                            unit_pool.availablePool = unit_pool.availablePool + 1
                                            M2TWEOP.callConsole("add_money", "+" .. tostring(global_recruits[k].cost))
                                        end
                                    end
                                end
                            end
                            global_recruits[k] = nil
                            recruitCheckGlobal() 
                            reset_scroll_y = true
                            --return
                        end
                        if global_recruits[k] ~= nil then
                            local hovered = ImGui.IsItemHovered()
                            if hovered then
                                playMenuSound("13a"..eduEntry.eduType)
                                eurStyle("tooltip", true)
                                ImGui.BeginTooltip()
                                ImGui.Text(eduEntry.eduType)
                                ImGui.Text("From: "..remote_sett.localizedName)
                                ImGui.Text("To: "..local_sett.localizedName)
                                ImGui.Text("Recruitment Cost: "..tostring(global_recruits[k].cost).." Gold.")
                                ImGui.Text("Recruitment Time: "..tostring(global_recruits[k].time).." Turns.")
                                ImGui.EndTooltip()
                                eurStyle("tooltip", false)
                            end
                        end
                    end
                end
                filterindex = filterindex + 1
            end
            ImGui.EndChild()
        end
    end

    --eurStyle("basic_3", true)
    ImGui.SetNextWindowBgAlpha(0.0)
    local main_size = 600
    if game_options.global_recruitment_localonly then
        main_size = 690
    end
    if filter_enabled or global_notif_enabled then
        main_size = main_size-size_filter
    end
    if global_active then
        main_size = main_size-40
        main_size = main_size-global_size
    end
    ImGui.BeginChild("global_child_sub_1", 820*eurbackgroundWindowSizeRight, main_size*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
    
    if reset_scroll_y then
        scrollBarReset()
    end
    scrollbar_y = ImGui.GetScrollY()
    
    settInRange()

    ImGui.EndChild()
    --eurStyle("basic_4", false)
end

function settInRange()
    local size_unit = 80
    for i = 0, #sett_list do
        if i > 0 then
            ImGui.Separator()
            ImGui.Separator()
        end
        if sett_list[i] ~= nil then
            local settname = sett_list[i].name
            if not sett_info[settname].hidden then
                local unitindex = 0
                local capcount = 0
                if sett_info[settname] ~= nil then
                    if sett_info[settname].unit ~= nil then
                        for g = 0, #sett_info[settname].unit do
                            if sett_info[settname].unit[g].active then
                                capcount = capcount + 1
                            end
                        end
                    end
                end
                if capcount == nil then
                    capcount = 0
                end
                if capcount > 24 then
                    size_unit = 320
                elseif capcount > 16 then
                    size_unit = 240
                elseif capcount > 8 then
                    size_unit = 160
                else
                    size_unit = 80
                end
                ImGui.SetNextWindowBgAlpha(0.0)
                ImGui.BeginChild("global_child_sub_"..tostring(i).."_local_q", 940*eurbackgroundWindowSizeRight, size_unit*eurbackgroundWindowSizeBottom, ImGuiChildFlags.None)
                ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
                 if global_settlement ~= nil then
                    if sett_list[i] == global_settlement then 
                        ImGui.PushStyleColor(ImGuiCol.Button, 0.24, 0.6, 0.22, 0.15)
                        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0.24, 0.8, 0.22, 0.25)
                        ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.24, 0.8, 0.22, 0.35)
    
                    else
                        if game_options.global_recruitment_localonly == true then 
                            ImGui.PushStyleColor(ImGuiCol.Button, 0.24, 0.6, 0.22, 0.1)
                        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0.24, 0.8, 0.22, 0.25)
                        ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.24, 0.8, 0.22, 0.35)
        
                        elseif (game_options.global_waystation_req == true and sett_info[global_settlement.name].waystation == false) then
                            ImGui.PushStyleColor(ImGuiCol.Button, 0.24, 0.6, 0.22, 0.1)
                        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0.24, 0.8, 0.22, 0.25)
                        ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.24, 0.8, 0.22, 0.35)
        
                        else

                            ImGui.PushStyleColor(ImGuiCol.Button, 0.24, 0.24, 0.6, 0.1)
                            ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0.24, 0.24, 0.6, 0.2)
                            ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.24, 0.24, 0.6, 0.3)
                        end
                    end
                end
                

                ImGui.SetNextWindowBgAlpha(0)
                ImGui.BeginChild(sett_info[settname].localizedName, 170*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
                local pos_x, pos_y = ImGui.GetWindowPos()
                ImGui.EndChild()
                ImGui.SetNextWindowBgAlpha(0)
                ImGui.SetNextWindowPos(pos_x, pos_y)
                ImGui.BeginChild(sett_info[settname].localizedName.."##2", 170*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
                --ImGui.PushStyleColor(ImGuiCol.Text,0,0,0,1)
                local sett_title_text = sett_info[settname].localizedName
                if (game_options.global_waystation_req == true and sett_info[settname].waystation == true) then
                    sett_title_text =  sett_title_text.."(w)"
                end
                centeredText(sett_title_text,0)
                ImGui.NewLine()
                ImGui.NewLine()
                if (sett_info[settname].unitInQueueCount > 0 and sett_info[settname].recruit_slots > 0) or (sett_info[settname].unitInQueueCount > 0 and sett_info[settname].recruit_slots == 0) then
                    if sett_info[settname].unitInQueueCount >= sett_info[settname].recruit_slots then 
                        ImGui.PushStyleColor(ImGuiCol.Text,0.8,0,0,1)
                    end
                end
                centeredText(tostring(sett_info[settname].unitInQueueCount).."/"..tostring(sett_info[settname].recruit_slots),0)
                if (sett_info[settname].unitInQueueCount > 0 and sett_info[settname].recruit_slots > 0) or (sett_info[settname].unitInQueueCount > 0 and sett_info[settname].recruit_slots == 0) then
                    if sett_info[settname].unitInQueueCount >= sett_info[settname].recruit_slots then 
                        ImGui.PopStyleColor()
                    end
                end
                ImGui.EndChild()
                ImGui.SetNextWindowBgAlpha(0)
                ImGui.SetNextWindowPos(pos_x, pos_y)
                ImGui.BeginChild(sett_info[settname].localizedName.."##3", 170*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
                local sett_clicked = ImGui.Button("##"..sett_info[settname].localizedName, 170*eurbackgroundWindowSizeRight, 80*eurbackgroundWindowSizeBottom)
                if (sett_clicked == true) then
                    stratmap.game.scriptCommand("select_settlement", settname)
                    stratmap.camera.jump(sett_info[settname].xCoord - 10, sett_info[settname].yCoord)
                    if show_settUI then
                        local recruitment_button = gameSTDUI.getUiElement("recruitment_button");
                        if recruitment_button then 
                            recruitment_button:execute();
                            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                        end
                    end
                    global_settlement = sett_list[i]
                    recruitCheckGlobal() 
                    reset_scroll_y = true 
                    scrollbar_y = 0
                    --return
                end
                local hovered = ImGui.IsItemHovered()
                if hovered then
                    eurStyle("tooltip", true)
                    ImGui.BeginTooltip()
                    ImGui.Text("Go to "..sett_info[settname].localizedName)
                    if (game_options.global_waystation_req == true and sett_info[settname].waystation == true) then
                        ImGui.Text("Waystation present")
                    end
                    ImGui.NewLine()
                    ImGui.Text(tostring(sett_info[settname].unitInQueueCount).."/"..tostring(sett_info[settname].recruit_slots).." units in local queue")
                    ImGui.EndTooltip()
                    eurStyle("tooltip", false)
                end
                
                ImGui.EndChild()
                ImGui.PopStyleColor(3)

                ImGui.PushStyleColor(ImGuiCol.Button, 1, 1, 1, 0.2)
                ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 1, 1, 1, 0.5)
                ImGui.PushStyleColor(ImGuiCol.ButtonActive, 1, 1, 1, 0.7)
                ImGui.SameLine()
                if sett_info[settname] ~= nil then
                    if sett_info[settname].unit ~= nil then
                        for j = 0, #sett_info[settname].unit do
                            if sett_info[settname].unit[j] ~= nil then
                                if sett_info[settname].unit[j].maxSize >= 1 then
                                    local unit_tga = sett_info[settname].unit[j].unitCardTga
                                    if global_settlement ~= nil then
                                        local distance_mult = 1
                                        if not sett_distance_list[settname] then
                                            distance_mult = getDistance(global_settlement.xCoord, global_settlement.yCoord, sett_info[settname].xCoord, sett_info[settname].yCoord)
                                            distance_mult = math.ceil(distance_mult/70)
                                            sett_distance_list[settname] = distance_mult
                                        else
                                            distance_mult = sett_distance_list[settname]
                                        end
                                        local local_cost_mod = 1.5
                                        if distance_mult == 1 then
                                            local_cost_mod = 1.5
                                        else
                                            local_cost_mod = global_cost_mod + (distance_mult / 10)
                                        end
                                        local eduEntry = M2TWEOPDU.getEduEntryByType(sett_info[settname].unit[j].eduType);
                                        if eduEntry ~= nil then

                                            if (UNIT_FILTER[eduEntry.eduType].active and not single_filter_global) or (single_filter_global and eduEntry.eduType == single_filter_target) then
                                                unitindex = unitindex + 1
                                                if unitindex == 25 then
                                                    --ImGui.Separator()
                                                elseif unitindex == 17 then
                                                    --ImGui.Separator()
                                                elseif unitindex == 9 then
                                                    --ImGui.Separator()
                                                    ImGui.Indent(170*eurbackgroundWindowSizeRight)
                                                else
                                                    ImGui.SameLine()
                                                end
                                                ImGui.PushStyleColor(ImGuiCol.Button, 0, 0, 0, 0)
                                                ImGui.PushStyleColor(ImGuiCol.FrameBg,1,1,1,1)
                                                local unit = sett_info[settname].unit[j]
                                                if not sett_info[settname].seiged then
                                                    if sett_info[settname].unit[j].availablePool >= 1 then
                                                        if global_settlement ~= sett_list[i] then
                                                            if global_recruit_current < global_recruit_limit then
                                                                if eur_player_faction.money >= unit.cost*local_cost_mod then
                                                                    if default_general_units[eur_player_faction.name].old ~= eduEntry.eduType then
                                                                        if ((game_options.global_recruitment_localonly == false) and (game_options.global_waystation_req == true and sett_info[global_settlement.name].waystation == true)) 
                                                                        or ((game_options.global_recruitment_localonly == false) and (game_options.global_waystation_req == false)) then
                                                                            if eur_tga_table[unit_tga] then
                                                                                ImGui.SetNextWindowBgAlpha(0.2)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                local pos_x, pos_y = ImGui.GetWindowPos()
                                                                                ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                                ImGui.EndChild()
                                                                                ImGui.SetNextWindowBgAlpha(0)
                                                                                ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                ImGui.EndChild()
                                                                                ImGui.SetNextWindowBgAlpha(0)
                                                                                ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                local upgrade_clicked = ImGui.Button("##unit_card"..settname..eduEntry.eduType..tostring(x), img_x, img_y)
                                                                                if (upgrade_clicked == true) then
                                                                                    globalRecruitment(global_settlement, sett_list[i], eduEntry, unit.eduIndex, sett_info[settname].unit[j].recruitTime+distance_mult, math.ceil(sett_info[settname].unit[j].cost*local_cost_mod),sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                end
                                                                                local hovered = ImGui.IsItemHovered()
                                                                                if hovered then
                                                                                    --playMenuSound("13"..eduEntry.eduType)
                                                                                    eurStyle("tooltip", true)
                                                                                    ImGui.BeginTooltip()
                                                                                    ImGui.Text(eduEntry.localizedName)
                                                                                    print(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                    showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                    ImGui.NewLine()
                                                                                    ImGui.Text("Recruitment cost: "..tostring(math.ceil(sett_info[settname].unit[j].cost*local_cost_mod)).." gold.")
                                                                                    ImGui.Text("Recruitment time: "..tostring(sett_info[settname].unit[j].recruitTime+distance_mult).." turns.")
                                                                                    ImGui.TextColored(0.0, 1.0, 1.0, 1, "Global Recruitment.")
                                                                                    ImGui.Text("Right click to add unit to local queue. Cost: "..tostring(sett_info[settname].unit[j].cost).." gold. Time: "..tostring(sett_info[settname].unit[j].recruitTime).. " turns.")
                                                                                    ImGui.EndTooltip()
                                                                                    eurStyle("tooltip", false)
                                                                                    local rclicked = ImGui.IsMouseClicked(ImGuiMouseButton.Right)
                                                                                    if rclicked then
                                                                                        addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                        --recruitCheckGlobal() 
                                                                                        reset_scroll_y = true
                                                                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                    end
                                                                                end
                                                                                ImGui.EndChild()
                                                                            end

                                                                        else
                                                                            local show_text = "Local Recruitment."
                                                                            if (game_options.global_waystation_req == true) then
                                                                                show_text = "No Waystation at "..global_settlement.localizedName..", Right Click for Local Recruitment."
                                                                            end
                                                                            if sett_info[settname].unitInQueueCount < 9 then
                                                                                if eur_tga_table[unit_tga] then
                                                                                    ImGui.SetNextWindowBgAlpha(0.2)
                                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                    local pos_x, pos_y = ImGui.GetWindowPos()
                                                                                    ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                                    ImGui.EndChild()
                                                                                    ImGui.SetNextWindowBgAlpha(0)
                                                                                    ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                    drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                    ImGui.EndChild()
                                                                                    ImGui.SetNextWindowBgAlpha(0)
                                                                                    ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                    local upgrade_clicked = ImGui.Button("##unit_card"..settname..eduEntry.eduType..tostring(x), img_x, img_y)
                                                                                    if (upgrade_clicked == true) then
                                                                                        if not (game_options.global_waystation_req == true) then
                                                                                            addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                            --recruitCheckGlobal() 
                                                                                            reset_scroll_y = true
                                                                                            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                        end
                                                                                        --return
                                                                                    end
                                                                                    local hovered = ImGui.IsItemHovered()
                                                                                    if hovered then
                                                                                        --playMenuSound("15"..eduEntry.eduType)
                                                                                        eurStyle("tooltip", true)
                                                                                        ImGui.BeginTooltip()
                                                                                        ImGui.Text(eduEntry.localizedName)
                                                                                        showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                        ImGui.NewLine()
                                                                                        ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                                        ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                                        ImGui.TextColored(0.3, 1.0, 0.3, 1, show_text)
                                                                                        ImGui.EndTooltip()
                                                                                        eurStyle("tooltip", false)
                                                                                        local rclicked = ImGui.IsMouseClicked(ImGuiMouseButton.Right)
                                                                                        if rclicked then
                                                                                            addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                            --recruitCheckGlobal() 
                                                                                            reset_scroll_y = true
                                                                                            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                        end
                                                                                    end
                                                                                    ImGui.EndChild()
                                                                                end
                                                                            else
                                                                                if eur_tga_table[unit_tga] then
                                                                                    ImGui.SetNextWindowBgAlpha(0)
                                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                    local pos_x, pos_y = ImGui.GetWindowPos()
                                                                                    ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                                    ImGui.EndChild()
                                                                                    ImGui.SetNextWindowBgAlpha(0)
                                                                                    ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                    drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                    ImGui.EndChild()
                                                                                    ImGui.SetNextWindowBgAlpha(0.1)
                                                                                    ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                    ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                    ImGui.EndChild()
                                                                                    ImGui.PopStyleColor()
                                                                                    local hovered = ImGui.IsItemHovered()
                                                                                    if hovered then
                                                                                        eurStyle("tooltip", true)
                                                                                        ImGui.BeginTooltip()
                                                                                        ImGui.Text(eduEntry.localizedName)
                                                                                        showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                        ImGui.NewLine()
                                                                                        ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                                        ImGui.Text("Recruitment Timeime: "..tostring(unit.recruitTime).." turns.")
                                                                                        ImGui.TextColored(0.8, 0.8, 0.8, 1, "Local Queue Full.")
                                                                                        ImGui.EndTooltip()
                                                                                        eurStyle("tooltip", false)
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    else
                                                                        if sett_info[settname].unitInQueueCount < 9 then
                                                                            if eur_tga_table[unit_tga] then
                                                                                ImGui.SetNextWindowBgAlpha(0.2)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                local pos_x, pos_y = ImGui.GetWindowPos()
                                                                                ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                                ImGui.EndChild()
                                                                                ImGui.SetNextWindowBgAlpha(0)
                                                                                ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                ImGui.EndChild()
                                                                                ImGui.SetNextWindowBgAlpha(0)
                                                                                ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                local upgrade_clicked = ImGui.Button("##unit_card"..settname..eduEntry.eduType..tostring(x), img_x, img_y)
                                                                                if (upgrade_clicked == true) then
                                                                                    addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                    --recruitCheckGlobal() 
                                                                                    reset_scroll_y = true
                                                                                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                    --return
                                                                                end
                                                                                local hovered = ImGui.IsItemHovered()
                                                                                if hovered then
                                                                                    --playMenuSound("14"..eduEntry.eduType)
                                                                                    eurStyle("tooltip", true)
                                                                                    ImGui.BeginTooltip()
                                                                                    ImGui.Text(eduEntry.localizedName)
                                                                                    showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                    ImGui.NewLine()
                                                                                    ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                                    ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                                    ImGui.TextColored(0.3, 1.0, 0.3, 1, "General Unit - Local Recruitment.")
                                                                                    ImGui.EndTooltip()
                                                                                    eurStyle("tooltip", false)
                                                                                    local rclicked = ImGui.IsMouseClicked(ImGuiMouseButton.Right)
                                                                                    if rclicked then
                                                                                        addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                        --recruitCheckGlobal() 
                                                                                        reset_scroll_y = true
                                                                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                    end
                                                                                end
                                                                                ImGui.EndChild()
                                                                            end
                                                                        else
                                                                            if eur_tga_table[unit_tga] then
                                                                                ImGui.SetNextWindowBgAlpha(0)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                local pos_x, pos_y = ImGui.GetWindowPos()
                                                                                ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                                ImGui.EndChild()
                                                                                ImGui.SetNextWindowBgAlpha(0)
                                                                                ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                ImGui.EndChild()
                                                                                ImGui.SetNextWindowBgAlpha(0.1)
                                                                                ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                                ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                                ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                                ImGui.EndChild()
                                                                                ImGui.PopStyleColor()
                                                                                local hovered = ImGui.IsItemHovered()
                                                                                if hovered then
                                                                                    eurStyle("tooltip", true)
                                                                                    ImGui.BeginTooltip()
                                                                                    ImGui.Text(eduEntry.localizedName)
                                                                                    showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                    ImGui.NewLine()
                                                                                    ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                                    ImGui.Text("Recruitment Timeime: "..tostring(unit.recruitTime).." turns.")
                                                                                    ImGui.TextColored(0.8, 0.8, 0.8, 1, "Local Queue Full.")
                                                                                    ImGui.EndTooltip()
                                                                                    eurStyle("tooltip", false)
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                else
                                                                    if sett_info[settname].unitInQueueCount < 9 then
                                                                        if eur_player_faction.money >= unit.cost then
                                                                            ImGui.SetNextWindowBgAlpha(0.2)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            local pos_x, pos_y = ImGui.GetWindowPos()
                                                                            ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                            ImGui.EndChild()
                                                                            ImGui.SetNextWindowBgAlpha(0)
                                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.EndChild()
                                                                            ImGui.SetNextWindowBgAlpha(0)
                                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            local upgrade_clicked = ImGui.Button("##unit_card"..settname..eduEntry.eduType..tostring(x), img_x, img_y)
                                                                            if (upgrade_clicked == true) then
                                                                                --addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                
                                                                                --reset_scroll_y = true
                                                                                --M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                --return
                                                                            end
                                                                            local hovered = ImGui.IsItemHovered()
                                                                            if hovered then
                                                                                --playMenuSound("15"..eduEntry.eduType)
                                                                                eurStyle("tooltip", true)
                                                                                ImGui.BeginTooltip()
                                                                                ImGui.Text(eduEntry.localizedName)
                                                                                showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                ImGui.NewLine()
                                                                                ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                                ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                                ImGui.TextColored(0.3, 1.0, 0.3, 1, "Not Enough Gold, Right Click for Local Recruitment.")
                                                                                ImGui.EndTooltip()
                                                                                eurStyle("tooltip", false)
                                                                                local rclicked = ImGui.IsMouseClicked(ImGuiMouseButton.Right)
                                                                                if rclicked then
                                                                                    addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                    --recruitCheckGlobal() 
                                                                                    reset_scroll_y = true
                                                                                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                                end
                                                                            end
                                                                            ImGui.EndChild()
                                                                        else
                                                                            ImGui.SetNextWindowBgAlpha(0)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            local pos_x, pos_y = ImGui.GetWindowPos()
                                                                            ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                            ImGui.EndChild()
                                                                            ImGui.SetNextWindowBgAlpha(0)
                                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.EndChild()
                                                                            ImGui.SetNextWindowBgAlpha(0.1)
                                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                            ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            ImGui.EndChild()
                                                                            ImGui.PopStyleColor()
                                                                            local hovered = ImGui.IsItemHovered()
                                                                            if hovered then
                                                                                eurStyle("tooltip", true)
                                                                                ImGui.BeginTooltip()
                                                                                ImGui.Text(eduEntry.localizedName)
                                                                                showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                ImGui.NewLine()
                                                                                ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                                ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                                ImGui.TextColored(0.8, 0.8, 0.8, 1, "Not Enough Gold for Local or Global Recruitment.")
                                                                                ImGui.EndTooltip()
                                                                                eurStyle("tooltip", false)
                                                                            end
                                                                        end
                                                                    else
                                                                        if eur_tga_table[unit_tga] then
                                                                            ImGui.SetNextWindowBgAlpha(0)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            local pos_x, pos_y = ImGui.GetWindowPos()
                                                                            ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                            ImGui.EndChild()
                                                                            ImGui.SetNextWindowBgAlpha(0)
                                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.EndChild()
                                                                            ImGui.SetNextWindowBgAlpha(0.1)
                                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                            ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                            ImGui.EndChild()
                                                                            ImGui.PopStyleColor()
                                                                            local hovered = ImGui.IsItemHovered()
                                                                            if hovered then
                                                                                eurStyle("tooltip", true)
                                                                                ImGui.BeginTooltip()
                                                                                ImGui.Text(eduEntry.localizedName)
                                                                                showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                                ImGui.NewLine()
                                                                                ImGui.Text("Recruitment cost: "..tostring(math.ceil(unit.cost*local_cost_mod)).." gold.")
                                                                                ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                                ImGui.TextColored(0.8, 0.8, 0.8, 1, "Not Enough Gold, Local Queue Full.")
                                                                                ImGui.EndTooltip()
                                                                                eurStyle("tooltip", false)
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            else
                                                                if sett_info[settname].unitInQueueCount < 9 then
                                                                    if eur_player_faction.money >= unit.cost then
                                                                        ImGui.SetNextWindowBgAlpha(0.2)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        local pos_x, pos_y = ImGui.GetWindowPos()
                                                                        ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        local upgrade_clicked = ImGui.Button("##unit_card"..settname..eduEntry.eduType..tostring(x), img_x, img_y)
                                                                        if (upgrade_clicked == true) then
                                                                            --addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)

                                                                            --reset_scroll_y = true
                                                                            --M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                            --return
                                                                        end
                                                                        local hovered = ImGui.IsItemHovered()
                                                                        if hovered then
                                                                            --playMenuSound("15"..eduEntry.eduType)
                                                                            eurStyle("tooltip", true)
                                                                            ImGui.BeginTooltip()
                                                                            ImGui.Text(eduEntry.localizedName)
                                                                            showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.NewLine()
                                                                            ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                            ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                            ImGui.TextColored(0.3, 1.0, 0.3, 1, "Global Full, Rick Click for Local Recruitment.")
                                                                            ImGui.EndTooltip()
                                                                            eurStyle("tooltip", false)
                                                                            local rclicked = ImGui.IsMouseClicked(ImGuiMouseButton.Right)
                                                                            if rclicked then
                                                                                addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)

                                                                                reset_scroll_y = true
                                                                                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                            end
                                                                        end
                                                                        ImGui.EndChild()
                                                                    else
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        local pos_x, pos_y = ImGui.GetWindowPos()
                                                                        ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0.1)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        ImGui.EndChild()
                                                                        ImGui.PopStyleColor()
                                                                        local hovered = ImGui.IsItemHovered()
                                                                        if hovered then
                                                                            eurStyle("tooltip", true)
                                                                            ImGui.BeginTooltip()
                                                                            ImGui.Text(eduEntry.localizedName)
                                                                            showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.NewLine()
                                                                            ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                            ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                            ImGui.TextColored(0.8, 0.8, 0.8, 1, "Global Queue Full, Not Enough Gold for Local Recruitment.")
                                                                            ImGui.EndTooltip()
                                                                            eurStyle("tooltip", false)
                                                                        end
                                                                    end
                                                                else
                                                                    if eur_tga_table[unit_tga] then
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        local pos_x, pos_y = ImGui.GetWindowPos()
                                                                        ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0.1)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        ImGui.EndChild()
                                                                        ImGui.PopStyleColor()
                                                                        local hovered = ImGui.IsItemHovered()
                                                                        if hovered then
                                                                            eurStyle("tooltip", true)
                                                                            ImGui.BeginTooltip()
                                                                            ImGui.Text(eduEntry.localizedName)
                                                                            showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.NewLine()
                                                                            ImGui.Text("Recruitment cost: "..tostring(math.ceil(unit.cost*local_cost_mod)).." gold.")
                                                                            ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                            ImGui.TextColored(0.8, 0.8, 0.8, 1, "Global Recruitment Queue Full, Local Queue Full.")
                                                                            ImGui.EndTooltip()
                                                                            eurStyle("tooltip", false)
                                                                        end
                                                                    end
                                                                    
                                                                end
                                                            end
                                                        else
                                                            if eur_player_faction.money >= unit.cost then
                                                                if sett_info[settname].unitInQueueCount < 9 then
                                                                    if eur_tga_table[unit_tga] then
                                                                        ImGui.SetNextWindowBgAlpha(0.2)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        local pos_x, pos_y = ImGui.GetWindowPos()
                                                                        ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        local upgrade_clicked = ImGui.Button("##unit_card"..settname..eduEntry.eduType..tostring(x), img_x, img_y)
                                                                        if (upgrade_clicked == true) then
                                                                            addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                            -- recruitCheckGlobal() 
                                                                            reset_scroll_y = true
                                                                            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                            --return
                                                                        end
                                                                        local hovered = ImGui.IsItemHovered()
                                                                        if hovered then
                                                                            --playMenuSound("15"..eduEntry.eduType)
                                                                            eurStyle("tooltip", true)
                                                                            ImGui.BeginTooltip()
                                                                            ImGui.Text(eduEntry.localizedName)
                                                                            showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.NewLine()
                                                                            ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                            ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                            ImGui.TextColored(0.3, 1.0, 0.3, 1, "Local recruitment.")
                                                                            ImGui.EndTooltip()
                                                                            eurStyle("tooltip", false)
                                                                            local rclicked = ImGui.IsMouseClicked(ImGuiMouseButton.Right)
                                                                            if rclicked then
                                                                                addToLocalQueue(sett_info[settname].unit[j].getRecruitmentOption, settname)
                                                                                -- recruitCheckGlobal() 
                                                                                reset_scroll_y = true
                                                                                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                                            end
                                                                        end
                                                                        ImGui.EndChild()
                                                                    end
                                                                else
                                                                    if eur_tga_table[unit_tga] then
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        local pos_x, pos_y = ImGui.GetWindowPos()
                                                                        ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                        ImGui.EndChild()
                                                                        ImGui.SetNextWindowBgAlpha(0.1)
                                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                        ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                        ImGui.EndChild()
                                                                        ImGui.PopStyleColor()
                                                                        local hovered = ImGui.IsItemHovered()
                                                                        if hovered then
                                                                            eurStyle("tooltip", true)
                                                                            ImGui.BeginTooltip()
                                                                            ImGui.Text(eduEntry.localizedName)
                                                                            showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                            ImGui.NewLine()
                                                                            ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                            ImGui.Text("Recruitment Timeime: "..tostring(unit.recruitTime).." turns.")
                                                                            ImGui.TextColored(0.8, 0.8, 0.8, 1, "Local queue full.")
                                                                            ImGui.EndTooltip()
                                                                            eurStyle("tooltip", false)
                                                                        end
                                                                    end
                                                                end
                                                            else
                                                                if eur_tga_table[unit_tga] then
                                                                    ImGui.SetNextWindowBgAlpha(0)
                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                    local pos_x, pos_y = ImGui.GetWindowPos()
                                                                    ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                                    ImGui.EndChild()
                                                                    ImGui.SetNextWindowBgAlpha(0)
                                                                    ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                    drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                    ImGui.EndChild()
                                                                    ImGui.SetNextWindowBgAlpha(0.1)
                                                                    ImGui.SetNextWindowPos(pos_x, pos_y)
                                                                    ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                                    ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                                    ImGui.EndChild()
                                                                    ImGui.PopStyleColor()
                                                                    local hovered = ImGui.IsItemHovered()
                                                                    if hovered then
                                                                        eurStyle("tooltip", true)
                                                                        ImGui.BeginTooltip()
                                                                        ImGui.Text(eduEntry.localizedName)
                                                                        showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                        ImGui.NewLine()
                                                                        ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                        ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                        ImGui.TextColored(0.8, 0.8, 0.8, 1, "Not Enough Gold")
                                                                        ImGui.EndTooltip()
                                                                        eurStyle("tooltip", false)
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    else
                                                        if eur_tga_table[unit_tga] then
                                                            ImGui.SetNextWindowBgAlpha(0)
                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                            local pos_x, pos_y = ImGui.GetWindowPos()
                                                            ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                            ImGui.EndChild()
                                                            ImGui.SetNextWindowBgAlpha(0)
                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                            drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                            ImGui.EndChild()
                                                            ImGui.SetNextWindowBgAlpha(0.2)
                                                            ImGui.SetNextWindowPos(pos_x, pos_y)
                                                            ImGui.PushStyleColor(ImGuiCol.FrameBg,1,1,1,0.2)
                                                            ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                            --ImGui.PushStyleColor(ImGuiCol.Text,0.9,0.9,0.9,1)
                                                            ImGui.NewLine()
                                                            ImGui.NewLine()
                                                            ImGui.NewLine()
                                                            local turns_remaining = floatToWhole(sett_info[settname].unit[j].replenishRate, (1-sett_info[settname].unit[j].availablePool))
                                                            --local textWidth, textHeight = ImGui.CalcTextSize(tostring(turns_remaining));
                                                            --ImGui.SetCursorPosY(img_y-textHeight);
                                                            centeredText(tostring(turns_remaining),0)
                                                            --ImGui.PopStyleColor()
                                                            ImGui.EndChild()
                                                            ImGui.PopStyleColor()
                                                            local hovered = ImGui.IsItemHovered()
                                                            if hovered then
                                                                eurStyle("tooltip", true)
                                                                ImGui.BeginTooltip()
                                                                ImGui.Text(eduEntry.localizedName)
                                                                showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                                ImGui.NewLine()
                                                                ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                                ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                                --ImGui.Text("Recruitment Time: "..tostring(unit_pool.availablePool).." availablePool.")
                                                                --ImGui.Text("Recruitment Time: "..tostring(recruit_cap.replenishRate).." replenishRate.")
                                                                ImGui.TextColored(1.0, 0.84, 0.0, 1, tostring(turns_remaining).." Turns until available.")
                                                                ImGui.EndTooltip()
                                                                eurStyle("tooltip", false)
                                                            end
                                                        end
                                                    end
                                                else
                                                    if eur_tga_table[unit_tga] then
                                                        ImGui.SetNextWindowBgAlpha(0)
                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x), img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                        local pos_x, pos_y = ImGui.GetWindowPos()
                                                        ImGui.Image(eur_tga_table[unit_tga].img, img_x, img_y)
                                                        ImGui.EndChild()
                                                        ImGui.SetNextWindowBgAlpha(0)
                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##2", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                        drawGlobalCardExtras(tostring(math.floor(sett_info[settname].unit[j].availablePool)), eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl, sett_info[settname].weapon_melee_simple, sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                        ImGui.EndChild()
                                                        ImGui.SetNextWindowBgAlpha(0.1)
                                                        ImGui.SetNextWindowPos(pos_x, pos_y)
                                                        ImGui.PushStyleColor(ImGuiCol.FrameBg,0.75,0.75,0.75,0.1)
                                                        ImGui.BeginChild(settname..eduEntry.eduType..tostring(x).."##3", img_x, img_y, ImGuiChildFlags.FrameStyle)
                                                        ImGui.EndChild()
                                                        ImGui.PopStyleColor()
                                                        local hovered = ImGui.IsItemHovered()
                                                        if hovered then
                                                            eurStyle("tooltip", true)
                                                            ImGui.BeginTooltip()
                                                            ImGui.Text(eduEntry.localizedName)
                                                            showEDUStatsAdjusted(eduEntry.eduType, sett_info[settname].unit[j].xp, sett_info[settname].armourlvl ,sett_info[settname].weapon_melee_blade, sett_info[settname].weapon_missile_mechanical)
                                                            ImGui.NewLine()
                                                            ImGui.Text("Recruitment cost: "..tostring(unit.cost).." gold.")
                                                            ImGui.Text("Recruitment time: "..tostring(unit.recruitTime).." turns.")
                                                            ImGui.TextColored(0.8, 0.8, 0.8, 1, "Settlement under siege.")
                                                            ImGui.EndTooltip()
                                                            eurStyle("tooltip", false)
                                                        end
                                                    end
                                                end
                                                ImGui.PopStyleColor(2)
                                            end
                                           
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                ImGui.PopStyleColor(3)
                ImGui.EndChild()
            end
        end
    end
end
