selected2 = false
hoveredtest = false
showtext = false

map_id = nil
map_x = 0
map_y = 0

extra_window = false
castle = false
level = 0
max = 5
setttext = "Lothlolien"

sett_names = {}

local temp_target = 0
local curr_item = "T1"

local player_units_target = 1

temp_upg_edu = ""
temp_upg_target = ""

settlement_names = {
    "Saxonville",
    "Elandorë",
    "Lindorlin",
    "Eärendur",
    "Calenfëanor",
    "Tirithil",
    "Amarathorn",
    "Ilmarinor",
    "Alqualmírë",
    "Galadhrim",
    "Ithildor",
    "Lothenel",
    "Aldawen",
    "Tirnanor",
    "Nimrothal",
    "Silmarion",
    "Elenithil",
    "Fëanoldëa",
    "Noldorinost",
    "Alcarindë",
    "Elenloth",
    "Calaquendi",
    "Vanyarë",
    "Mithlondir",
    "Elensûl",
    "Alduinor",
    "Fingolost",
    "Teleriand",
    "Gilthirin",
    "Tiriondë",
    "Eledhion",
    "Calenlómë",
    "Nimbrethil",
    "Taurëa",
    "Lóthendor",
    "Lindirion",
    "Aranlómë",
    "Fëanárel",
    "Lómëthil",
    "Elentirmo",
    "Anoron",
    "Lothilion",
    "Laurefindë",
    "Menelluin",
    "Galadhrel",
    "Minlaurëa",
    "Eärquendi",
    "Celebost",
    "Lauremel",
    "Nimlothion",
    "Calenfirin"
}



function deleteItem(list, index)
    if index < 1 or index > #list then
        --print("Invalid index")
        return
    end

    -- Shift elements to the left
    for i = index, #list - 1 do
        list[i] = list[i + 1]
    end

    -- Remove the last item (which is now duplicated)
    list[#list] = nil
end


function devButton()
    ImGui.SetNextWindowPos(10*eurbackgroundWindowSizeRight, 840*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(200, 200)
    ImGui.Begin("dev_button_01", true, bit.bor(ImGuiWindowFlags.NoDecoration))
    eurStyle("tooltip", true)
    --if ImGui.ImageButton("upgrades_button_1",button_01.img ,60,60) then
        if (ImGui.Button("console", 80, 80)) then
            M2TWEOP.toggleConsole()
        end
        ImGui.SameLine()
        if (ImGui.Button("Window", 80, 80)) then
            if not extra_window then
                extra_window = true
            else
                extra_window = false
            end
        end
        if (ImGui.Button("reset", 80, 80)) then
            M2TWEOP.restartLua();
            print("----Lua Restart----")
            --unloadImages()
        end
        ImGui.SameLine()
        if (ImGui.Button("ICM", 80, 80)) then
            in_campaign_map = true
            eurGlobalVars()
            startLog(M2TWEOP.getModPath())
            loadImages()
            loadSounds()
            for i = 1, #wavs do
                if EOP_WAVS[wavs[i]] then
                    EOP_WAVS[wavs[i]] = nil
                end
            end
        end
        eurStyle("tooltip", false)
    ImGui.End()
    if extra_window then
        --ImGui.SetNextWindowPos(500*eurbackgroundWindowSizeRight, 500*eurbackgroundWindowSizeBottom)
        ImGui.SetNextWindowBgAlpha(1)
        ImGui.SetNextWindowSize(700, 500)
        ImGui.Begin("dev_window_background", true, bit.bor(ImGuiWindowFlags.NoDecoration))
        eurStyle("tooltip", true)
        ImGui.SetNextWindowBgAlpha(0)
        --ImGui.SetNextWindowPos(505*eurbackgroundWindowSizeRight, 505*eurbackgroundWindowSizeBottom)
        ImGui.BeginChild("Name1", 700, 300, ImGuiWindowFlags.NoInputs)
        --[[
        if map_id ~= nil then
            ImGui.Image(map_id, map_x, map_y)
        end
        if in_campaign_map then
            if eur_player_faction ~= nil then
                if eur_player_faction.facStrat ~= nil then
                    eur_player_faction.facStrat.primaryColorRed, used1 = ImGui.VSliderInt("R", 25, 250, eur_player_faction.facStrat.primaryColorRed, 0, 255)
                    ImGui.SameLine()
                    eur_player_faction.facStrat.primaryColorGreen, used2 = ImGui.VSliderInt("G", 25, 250, eur_player_faction.facStrat.primaryColorGreen, 0, 255)
                    ImGui.SameLine()
                    eur_player_faction.facStrat.primaryColorBlue, used3 = ImGui.VSliderInt("B", 25, 250, eur_player_faction.facStrat.primaryColorBlue, 0, 255)
                    ImGui.SameLine()
                    eur_player_faction.facStrat.secondaryColorRed, used1 = ImGui.VSliderInt("R2", 25, 250, eur_player_faction.facStrat.secondaryColorRed, 0, 255)
                    ImGui.SameLine()
                    eur_player_faction.facStrat.secondaryColorGreen, used2 = ImGui.VSliderInt("G2", 25, 250, eur_player_faction.facStrat.secondaryColorGreen, 0, 255)
                    ImGui.SameLine()
                    eur_player_faction.facStrat.secondaryColorBlue, used3 = ImGui.VSliderInt("B2", 25, 250, eur_player_faction.facStrat.secondaryColorBlue, 0, 255)
                end
            end
        end
        ImGui.NewLine()
        ]]
        if (ImGui.BeginTabBar("dev_tabbar_1")) then
            ImGui.Separator()
            if (ImGui.BeginTabItem("dev1##01")) then
                
                local tile = M2TW.stratMap.getTile(map_x, map_y)
                if tile.resource ~= nil then
                    ImGui.Text(tostring(tile.resource.resourceID))
                    --tile.resource = nil
                end
                if not checkTileEmpty(map_x, map_y) then
                    ImGui.TextColored(1,0,0,1,"Invalid Tile")
                end
                ImGui.Text(tostring(map_x))
                ImGui.Text(tostring(map_y))
                if castle then
                    max = 4
                else
                    max = 5
                end
                level, levelused = ImGui.SliderInt("Level", level, 0, max)
                if (ImGui.Button("Rand", 100, 80)) then
                    local rand_nu = math.random(1, #settlement_names)
                    setttext = settlement_names[rand_nu]
                end
                setttext, selected2 = ImGui.InputTextWithHint("Name", "", setttext, 100)
                if tableContains(sett_names, setttext) then
                    ImGui.TextColored(1,0,0,1,"Name Taken")
                end
                castle, castlepressed = ImGui.Checkbox("Castle", castle)

                if (ImGui.Button("Add Model", 100, 80)) then
                    for k, v in pairs(ruin_tiles) do
                        ruin_tiles[k].active = true
                        print("Adding model:", v.x, v.y)
                        M2TW.stratMap.startDrawModelAt(101, v.x, v.y, 1)
                    end
                end
                ImGui.SameLine()
                if (ImGui.Button("Add Setts", 100, 80)) then
                    M2TW.stratMap.stopDrawModel(101)
                    local rebels = eur_campaign:getFaction("sicily")
                    for k, v in pairs(ruin_tiles) do
                        if checkTileEmpty(v.x, v.y) then
                            local tile = M2TW.stratMap.getTile(v.x, v.y)
                            if tile.resource then
                                tile.resource:setStratModel(101)
                            end
                            ruin_tiles[k].active = false
                            print("Adding sett:", v.x, v.y)
                            local value = math.random(1, 4)
                            if value == 4 then
                                if math.random(1, 100) > 20 then
                                    local rebels = eur_campaign:getFactionByID(tile.factionID)
                                    sett = rebels:addSettlement(v.x, v.y, v.message, (math.random(1,2)-1), true)
                                else
                                    sett = rebels:addSettlement(v.x, v.y, v.message, (math.random(1,2)-1), true)
                                end
                            else
                                if math.random(1, 100) > 20 then
                                    local rebels = eur_campaign:getFactionByID(tile.factionID)
                                    sett = rebels:addSettlement(v.x, v.y, v.message, (math.random(1,2)-1), false)
                                else
                                    sett = rebels:addSettlement(v.x, v.y, v.message, (math.random(1,2)-1), false)
                                end
                            end
                            if sett then
                                --M2TWEOP.setModel(v.x, v.y,101,101)
                                if sett.ownerFaction.name == "slave" then
                                local army = stratmap.game.createArmyInSettlement(sett)
                                    army:createUnit("Sellswords", 2, 0, 0)
                                    army:createUnit("Bandits", 0, 0, 0)
                                    army:createUnit("Bandits", 0, 0, 0)
                                    if math.random(1, 100) < 30 then
                                        army:createUnit("Lumbermen", 0, 0, 0)
                                        army:createUnit("Lumbermen", 0, 0, 0)
                                        army:createUnit("Woodland Hunters", 0, 0, 0)
                                        army:createUnit("Woodland Hunters", 0, 0, 0)
                                    end
                                else
                                    local army = stratmap.game.createArmyInSettlement(sett)
                                    local rand1 = math.random(1, 3)
                                    local rand2 = math.random(1, 3)
                                    if SWAP_GARRISON[sett.ownerFaction.name] then
                                        army:createUnit(SWAP_GARRISON[sett.ownerFaction.name].new[rand1], 0, 0, 0)
                                        army:createUnit(SWAP_GARRISON[sett.ownerFaction.name].new[rand2], 0, 0, 0)
                                    end
                                end
                                sett.settlementStats.population = (sett.settlementStats.population+math.random(150, 300))
                            else
                                print("Adding sett failed:", v.x, v.y)
                            end
                        end
                    end
                end
                ImGui.SameLine()
                local rebels = eur_campaign:getFaction("sicily")
                if (ImGui.Button("Add Sett", 100, 80)) then
                    --if ruin_tiles[tostring(map_x..map_y)] then
                        if checkTileEmpty(map_x, map_y) then
                            if not tableContains(sett_names, setttext) then
                                --ruin_tiles[tostring(map_x..map_y)].active = false
                                --M2TW.stratMap.stopDrawModel(101)
                                local sett = rebels:addSettlement(map_x, map_y, setttext, level, castle)
                                if sett then
                                    table.insert(sett_names, setttext)
                                    local rand_nu = math.random(1, #settlement_names)
                                    setttext = settlement_names[rand_nu]
                                    --M2TWEOP.setModel(map_x, map_y,101,101)
                                end
                            end
                        end
                    --end
                end
                ImGui.EndTabItem()
            end
            if (ImGui.BeginTabItem("dev2##01")) then
                if EDB_POOL_DEFAULT ~= {} then
                    for k, v in pairs(EDB_POOL_DEFAULT) do
                        --ImGui.SetNextWindowBgAlpha(0)
                        --ImGui.BeginChild("edbtest1"..EDB_POOL_DEFAULT[k].localname, 500*eurbackgroundWindowSizeRight, 500*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
                        if (ImGui.CollapsingHeader(EDB_POOL_DEFAULT[k].localname)) then
                            for x = 0, 10 do
                                if EDB_POOL_DEFAULT[k][x] then
                                    if EDB_POOL_DEFAULT[k][x][eur_playerFactionId] then
                                        ImGui.Text(EDB_POOL_DEFAULT[k][x][eur_playerFactionId].name)
                                        for k2, v2 in pairs(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"]) do
                                            if eur_tga_table[EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].unitCardTga] then
                                                ImGui.Image(eur_tga_table[EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].unitCardTga].img, 48*eurbackgroundWindowSizeRight, 64*eurbackgroundWindowSizeBottom)
                                            end
                                            --ImGui.Text(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].eduType)
                                            ImGui.NewLine()
                                            ImGui.Text("Default: ")
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].experience))
                                            ImGui.SameLine()
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].initialSize))
                                            ImGui.SameLine()
                                            local gain_turns = floatToWhole(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].gainPerTurn, 1)
                                            ImGui.Text(tostring(gain_turns))
                                            ImGui.SameLine()
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].maxSize))
                                            ImGui.SameLine()
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].upkeepCost))
                                            ImGui.SameLine()
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].recruitCost))
                                            --modded
                                            ImGui.NewLine()
                                            ImGui.Text("Modified: ")
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].experience))
                                            ImGui.SameLine()
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].initialSize))
                                            ImGui.SameLine()
                                            local float = EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].gainPerTurn
                                            if EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].recruitCost < EDUOFFET_VARS.threshold then 
                                                float = float*percentIntToFloat(EDUOFFET_VARS.pooloffset1)
                                            else
                                                float = float*percentIntToFloat(EDUOFFET_VARS.pooloffset2)
                                            end
                                            local gain_turns = floatToWhole(float, 1)
                                            ImGui.Text(tostring(gain_turns))
                                            ImGui.SameLine()
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].maxSize))
                                            ImGui.SameLine()
                                            if EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].upkeepCost < EDUOFFET_VARS.threshold then
                                                ImGui.Text(tostring((EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].upkeepCost*percentIntToFloat(EDUOFFET_VARS.offset1))+EDUOFFET_VARS.extragold))
                                            else
                                                ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].upkeepCost*percentIntToFloat(EDUOFFET_VARS.offset1)+EDUOFFET_VARS.extragold2))
                                            end
                                            ImGui.SameLine()
                                            ImGui.Text(tostring(EDB_POOL_DEFAULT[k][x][eur_playerFactionId]["units"][k2].recruitCost*percentIntToFloat(EDUOFFET_VARS.offset1)))
                                        end
                                    end
                                end
                            end
                        end
                        --ImGui.EndChild()
                    end
                end
                ImGui.EndTabItem()
            end
            if (ImGui.BeginTabItem("dev3##01")) then

                --------------
                for i = 1, #wavs do
                    if EOP_WAVS[wavs[i]] then
                        if (i % 3 == 0) then
                            ImGui.NewLine()
                            if (ImGui.Button(wavs[i], 150, 20)) then
                                if EOP_WAVS[wavs[i]] then
                                    M2TWEOPSounds.playEOPSound(EOP_WAVS[wavs[i]])
                                end
                            end
                        else
                            ImGui.SameLine()
                            if (ImGui.Button(wavs[i], 150, 20)) then
                                if EOP_WAVS[wavs[i]] then
                                    M2TWEOPSounds.playEOPSound(EOP_WAVS[wavs[i]])
                                end
                            end
                        end
                    end
                end
                ImGui.EndTabItem()
            end
        end
        eurStyle("tooltip", false)
        ImGui.EndChild()
        ImGui.End()
    end--[[
    if in_campaign_map then
        ImGui.SetNextWindowBgAlpha(1)
        ImGui.SetNextWindowSize(900, 700)
        ImGui.Begin("dev_window_background_2", true, bit.bor(ImGuiWindowFlags.None))
        local count = 0
        for i = 1, #player_units do
            local eduEntry = M2TWEOPDU.getEduEntryByType(player_units[i])
            if eduEntry ~= nil then
                if eduEntry:hasOwnership(eur_playerFactionId) then
                    count = count + 1
                    if eur_tga_table[eduEntry.unitCardTga] then
                        if ImGui.ImageButton("swapBGButton_button_s_0"..tostring(i),eur_tga_table[eduEntry.unitCardTga].img,img_x, img_y) then
                            temp_upg_edu = eduEntry.eduType
                        end
                    end
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        ImGui.BeginTooltip()
                        ImGui.Text(eduEntry.eduType)
                        ImGui.EndTooltip()
                    end
                end
            end
            if (count % 8 == 0) then
                ImGui.NewLine()
            else
                ImGui.SameLine()
            end
        end
        ImGui.NewLine()
        if temp_upg_edu ~= "" then
            local count = 0
            if UNIT_UPGRADES[temp_upg_edu] then
                for i = 1, #UNIT_UPGRADES[temp_upg_edu].unit do
                    if UNIT_UPGRADES[temp_upg_edu].unit[i] ~= nil then
                        local eduEntry = M2TWEOPDU.getEduEntryByType(UNIT_UPGRADES[temp_upg_edu].unit[i])
                        if eduEntry ~= nil then
                            if eduEntry:hasOwnership(eur_playerFactionId) then
                                count = count + 1
                                if eur_tga_table[eduEntry.unitCardTga] then
                                    if ImGui.ImageButton("swapBGButton_button_s_0"..tostring(i),eur_tga_table[eduEntry.unitCardTga].img,img_x, img_y) then
                                        emp_upg_target = eduEntry.eduType
                                    end
                                end
                                local hovered = ImGui.IsItemHovered()
                                if hovered then
                                    ImGui.BeginTooltip()
                                    ImGui.Text(eduEntry.eduType)
                                    ImGui.EndTooltip()
                                end
                            end
                        end
                    end
                    if count == 8 or count == 16 or count == 24 or count == 32 then
                        ImGui.NewLine()
                    else
                        ImGui.SameLine()
                    end
                end
            end
        end
        ImGui.End()
    end]]
end

edus = {}

--[[
function onCalculateUnitValue(entry, value)
	if edus[entry.eduType] then
		print(entry.eduType)
        print(value)
	end
end
]]

function onClickAtTile(x, y)
    print(x, y)
    local tile = M2TW.stratMap.getTile(x,y)
    --print(tile.regionID)
    local region = eur_sMap.getRegion(tile.regionID);
    print(region.name)

end

function onSettlementSelected2(eventData)
    --[[for i = 0, 1500 do
        local eduEntry=M2TWEOPDU.getEduEntry(i);
        if eduEntry ~= nil then
            print('"'..eduEntry.eduType..'",')
        end
    end]]
    --eur_campaign.execScriptEvent("", "storm", eventData.settlement.xCoord, eventData.settlement.yCoord, 1, "")
    --M2TWEOP.addModelToGame("data/models_strat/residences/faction_variants/ireland/elf_castle.cas", 1)
    --stratmap.game.scriptCommand("give_everything_to_faction", "mongols ireland false")
--stratmap.game.setScriptCounter("elven_union", 1)
    --local free = M2TWEOP.isTileFree(250, 312) 
    --if free then
        --eventData.faction:addSettlement(250, 312, "lothlolienen", 5, false)
    --end
    --M2TWEOP.setModel(eventData.settlement.xCoord, eventData.settlement.yCoord, 1, 1);
    --for i = 0, eventData.settlement.army.numOfUnits - 1 do
        --local un = eventData.settlement.army:getUnit(i)
        --un.soldierCountStratMap = 1
        --un:kill()
    --end
    --eventData.settlement.ownerFaction.facStrat.canHorde = true
    --local fac1 = eur_campaign:getFaction("turks")
    --eventData.settlement:changeOwner(fac1, true)
    --[[for i = 0, eur_campaign.numberOfFactions - 1 do
        local faction = eur_campaign:getFactionByOrder(i)
        for j = 0, faction.numOfCharacters - 1 do
            local char = faction:getCharacter(j)
            if char.characterRecord ~= nil then
                local name = char.characterRecord.label
                if string.find(name, "nazgul") then
                    if char.characterRecord.status == 0 then
                        print(char.characterRecord.label)
                        print(char.characterRecord.localizedDisplayName)
                    end
                elseif string.find(name, "z%d") then
                    if char.characterRecord.status == 0 then
                        print(char.characterRecord.label)
                        print(char.characterRecord.localizedDisplayName)
                    end
                end
            end
        end
        local faction = eur_player_faction
        for j = 0, faction.numOfCharacters - 1 do
            local char = faction:getCharacter(j)
            if char.characterRecord ~= nil then
                print(char.characterRecord.label)
                print(char.characterRecord.localizedDisplayName)
            end
        end
    end

    for i = 0, 1500 do
        local eduEntry = M2TWEOPDU.getEduEntry(i)
        if eduEntry ~= nil then
            if eduEntry:hasOwnership(eur_playerFactionId) then
                print(eduEntry.eduType)
            end
        end
    end]]
end

function testBu()
    for i = 0, eur_campaign.numberOfFactions - 1 do
        local faction = eur_campaign:getFactionByOrder(i)
        if faction ~= nil then
            local armycount = 0
            local unitcount = 0
            for j = 0, faction.armiesNum - 1 do
                local army = faction:getArmy(j)
                if army ~= nil then
                    armycount = armycount + 1
                    for j = 0, army.numOfUnits - 1 do 
                        local unit = army:getUnit(j)
                        if unit ~= nil then
                            unitcount = unitcount + 1
                            if unit.eduType == "Dunedain Wardens" then
                                unit:setParams(4,4,1);
                            end
                        end
                    end
                end
            end
            --print("Faction: "..faction.name)
            --print("Armies: "..tostring(armycount))
            --print("Units: "..tostring(unitcount))
        end
    end
end





 cursor_enabled = true
 something_hovered = false

 function noAttack()
    --local char = M2TW.selectionInfo.selectedCharacter
    --local nmechar = M2TW.selectionInfo.hoveredCharacter
    local sett = M2TW.selectionInfo.selectedSettlement
    --local fort = M2TW.selectionInfo.hoveredFort
    if sett ~= nil then
        swap_bg_button = true
    else
        swap_bg_button = false
    end
 end

local image_imported = false
local mapx, mapy, mapid = 0, 0, nil
mapImage = nil

TILES = {}

GROUND_TYPES_HEX = {
    [0]  = 0xFF2E552E,  -- grassShort (DarkOliveGreen)
    [1]  = 0xFF2E552E,  -- grassLong (Subdued Dark Green)
    [2]  = 0xFFD2B48C,  -- sand (Tan)
    [3]  = 0xFF696969,  -- rock (DimGray)
    [4]  = 0xFF2E552E,  -- forestDense (Muted Forest Green)
    [5]  = 0xFF2E552E,  -- scrubDense (DarkKhaki)
    [6]  = 0xFF5A3C2D,  -- swamp (Muted Slate)
    [7]  = 0xFF5A3C2D,  -- mud (Subdued Mud Brown)
    [8]  = 0xFF6E4632,  -- mudRoad (Muted SaddleBrown)
    [9]  = 0xFF606973,  -- stoneRoad (Muted SlateGray)
    [10] = 0xFF466E82,  -- water (Muted Blue)
    [11] = 0xFFF0F0F0,  -- ice (Cool Desaturated Blue)
    [12] = 0xFFF0F0F0,  -- snow (Soft White)
    [13] = 0xFF2E552E,  -- wood (Muted Wood Brown)
    [14] = 0xFFD2B48C,  -- dirt (Soft Sienna)
    [15] = 0xFF646464,  -- unknown (Neutral Gray)
}

GROUND_TYPES = {
    [0] = {85, 107, 47},    -- grassShort (DarkOliveGreen)
    [1] = {46, 85, 46},     -- grassLong (Subdued Dark Green)
    [2] = {210, 180, 140},  -- sand (Tan)
    [3] = {105, 105, 105},  -- rock (DimGray)
    [4] = {34, 60, 34},     -- forestDense (Muted Forest Green)
    [5] = {119, 136, 85},   -- scrubDense (DarkKhaki)
    [6] = {60, 70, 65},     -- swamp (Muted Slate)
    [7] = {90, 60, 45},     -- mud (Subdued Mud Brown)
    [8] = {110, 70, 50},    -- mudRoad (Muted SaddleBrown)
    [9] = {96, 105, 115},   -- stoneRoad (Muted SlateGray)
    [10] = {70, 110, 130},  -- water (Muted Blue)
    [11] = {180, 210, 220}, -- ice (Cool Desaturated Blue)
    [12] = {240, 240, 240}, -- snow (Soft White)
    [13] = {120, 80, 50},   -- wood (Muted Wood Brown)
    [14] = {139, 90, 60},   -- dirt (Soft Sienna)
    [15] = {100, 100, 100}, -- unknown (Neutral Gray)
}

function importMap(thisBattle)
    --print("generating map")
    --mapImage = mapImageStruct.makeMapImage()
    --mapImage.useBlur = true
    --mapImage.blurStrength = 10
    --if not image_imported then
        --getBattleTiles(thisBattle)
    --end
    for i = 1, #TILES do
        --mapImage:fillTileColor(TILES[i][1], TILES[i][2], GROUND_TYPES[TILES[i][3]][1], GROUND_TYPES[TILES[i][3]][2], groundColors[TILES[i][3]][3], 255)
        --drawList:AddRectFilled(TILES[i][1], TILES[i][2], TILES[i][1]+25, TILES[i][2]+25, GROUND_TYPES_HEX[TILES[i][3]])
    end
    --mapx, mapy, mapid = mapImage:loadMapTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\mapbg.png')
    image_imported = true
    --mapImage:fillRegionColor(50, 0, 255, 0, 255);
end

function convertCoordinates(x, y, scale, offsetX, offsetY)
    local newX = x * scale + offsetX
    local newY = y * scale + offsetY
    return newX, newY
end

function getBattleTiles(thisBattle)
    print("filling tiles")
    TILES = {}
    local groundTypeValue = nil
    local count = 0
    for i = 0, thisBattle.mapWidth do        
        for j = 0, thisBattle.mapWidth do
            if (i % 25 == 0) and (j % 25 == 0) then
                local tile = thisBattle.getBattleTile(i, j);
                if tile then
                    table.insert(TILES, {i, j, tile.physicalGroundType})
                end
            end
        end
    end
end

function battleOverviewWindow2()
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowPos(200*eurbackgroundWindowSizeRight, 10*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowSize(1500*eurbackgroundWindowSizeRight, 900*eurbackgroundWindowSizeBottom)
    ImGui.Begin("map_window_01", true, bit.bor(ImGuiWindowFlags.NoDecoration))
    eurStyle("options_1", true)
    local thisBattle = M2TW.battle
    ImGui.Text(tostring(thisBattle.mapWidth))
    ImGui.Text(tostring(thisBattle.mapHeight))
    --ImGui.Text(tostring(thisBattle.terrainFeatures.terrainLineCount))
    --drawList = ImGui.GetWindowDrawList()
    --(thisBattle)
    --ImGui.Image(mapid, 1024, 1024)

    local pos_x, pos_y = ImGui.GetWindowPos()

    -- original battle map size
    local sourceWidth, sourceHeight = thisBattle.mapWidth, thisBattle.mapHeight
    -- available window space
    local targetWidth, targetHeight = 1500*eurbackgroundWindowSizeRight, 900*eurbackgroundWindowSizeBottom

    -- calculate scale factor to preserve aspect ratio
    local scale = math.min(targetWidth / sourceWidth, targetHeight / sourceHeight)

    -- calculate offset to center the map inside the window
    local offsetX = (targetWidth - (sourceWidth * scale)) / 2
    local offsetY = (targetHeight - (sourceHeight * scale)) / 2
    if (ImGui.Button("speed", 150, 20)) then
        thisBattle.battleSpeed = 1
    end
    if thisBattle then
        --thisBattle.battleSpeed = ImGui.VSliderInt("speed", 25, 250, thisBattle.battleSpeed, 0, 24)
        local player = thisBattle:getPlayerArmy(0)
        ----ImGui.Text(tostring(player.totalStrength))
        --if (ImGui.Button("win", 150, 20)) then
            --M2TWEOP.callConsole("force_battle_victory")
        --end
        local text_desc = "O"
        for i = 0, player.numOfUnits -1 do
            local unit = player:getUnit(i)
            if unit then
                if unit.eduEntry.class == unitClass.missile then
                    text_desc = "M"
                elseif unit.eduEntry.class == unitClass.light then
                    text_desc = "L"
                elseif unit.eduEntry.class == unitClass.heavy then
                    text_desc = "H"
                elseif unit.eduEntry.class == unitClass.spearmen then
                    text_desc = "S"
                end
                local pos_x, pos_y = ((pos_x+(targetWidth/2))+math.ceil(unit.battlePosX)), ((pos_y+targetHeight/2)+unit.battlePosY)
                ImGui.SetNextWindowBgAlpha(1)
                ImGui.SetNextWindowPos(pos_x*eurbackgroundWindowSizeRight, pos_y*eurbackgroundWindowSizeBottom)
                ImGui.BeginChild(unit.eduEntry.eduType..tostring(i), 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)
                ImGui.Text(text_desc)
                ImGui.EndChild()
                local pos_x, pos_y = ((pos_x+(targetWidth/2))+math.ceil(unit.battlePosX)), ((pos_y+targetHeight/2)+unit.battlePosY)
                ImGui.SetNextWindowBgAlpha(1)
                ImGui.SetNextWindowPos(pos_x*eurbackgroundWindowSizeRight, pos_y*eurbackgroundWindowSizeBottom)
                ImGui.BeginChild(unit.eduEntry.eduType..tostring(i).."##2", 50*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
                local selected = ImGui.Selectable("", true, ImGuiSelectableFlags.None, 50*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
                centeredText("hey", 0)
                ImGui.EndChild()
                --ImGui.Text(unit.eduEntry.eduType)
                --ImGui.Text(tostring(unit.battlePosX))
                --ImGui.Text(tostring(unit.battlePosY))
                --if (ImGui.Button("place "..unit.eduEntry.eduType.."##"..tostring(i), 150, 20)) then
                    --unit:immediatePlace(150, -300, 60, 0);
                --end
                --local hasProp = unit:hasBattleProperty(unitBattleProperties.skirmish);
                --if hasProp then
                    --unit:setBattleProperty(unitBattleProperties.skirmish, false);
                --end
            end
        end
    end

    eurStyle("options_1", false)
    ImGui.End()
end


free_upkeep_list = {}

function freeUp()
free_upkeep_list = {}
free_upkeep_list["free"] = {}
free_upkeep_list["not_free"] = {}
    for i = 0, 1500 do
        local eduEntry = M2TWEOPDU.getEduEntry(i)
        if eduEntry ~= nil then
            --if eduEntry.freeUpkeepUnit == true then
                if eduEntry:hasOwnership(eur_playerFactionId) then
                    if eduEntry.upkeepCost > 0 and eduEntry.upkeepCost < 400 then
                        if not free_upkeep_list["free"][eduEntry.eduType] or free_upkeep_list["not_free"][eduEntry.eduType] then
                            free_upkeep_list["free"][eduEntry.eduType] = eduEntry.upkeepCost
                        end
                    elseif eduEntry.upkeepCost > 0 then
                        if not free_upkeep_list["free"][eduEntry.eduType] or free_upkeep_list["not_free"][eduEntry.eduType] then
                            free_upkeep_list["not_free"][eduEntry.eduType] = eduEntry.upkeepCost
                        end
                    end
                end
            --end
        end
    end
end

selectedUnit = nil

function cardtest()
    local cardManager = M2TW.uiCardManager
    M2TWEOP.logGame("cardManager ok");
    if cardManager.selectedUnitCardsCount then
        M2TWEOP.logGame("selectedUnitCardsCount ok");
        selectedUnit = cardManager:getSelectedUnitCard(0) --ok
        --print(selectedUnit)
        if selectedUnit ~= nil then --ok
            M2TWEOP.logGame("selectedUnit ok");
            --[[if selectedUnit.character then --f
                M2TWEOP.logGame("char ok");
                local char = selectedUnit.character
                if char.characterType == 7 then
                    M2TWEOP.logGame("characterType 7");
                end
            end]]
        end
    end
end


local groups = {
    [0] = {
        name = "group1",
        list = {"Dunedain Wardens", "Dunedain Wardens", "Dunedain Wardens"},
    },
    [1] = {
        name = "group2",
        list = {"Dunedain Rangers", "Dunedain Rangers"},
    },
}

local temp_units_gather = {}

local groups_set = false

function groupTest()

    -- Reset temp_units_gather
    temp_units_gather = {}

    local cameraCoords = M2TWEOP.getBattleCamCoords()
    if not cameraCoords then return end

    local thisBattle = M2TW.battle
    local playerArmy = thisBattle:getPlayerArmy(0)
    if playerArmy == nil then return end
    if thisBattle.battleState ~= 5 then return end

    -- Gather ungrouped units
    for i = 0, playerArmy.numOfUnits - 1 do
        local unit = playerArmy:getUnit(i)
        if unit and unit.unitGroup == nil then
            table.insert(temp_units_gather, {
                name = unit.eduEntry.eduType,
                set = false,
                index = i
            })
        end
    end

    -- Assign units to groups
    if not groups_set then
        local createdGroups = {}  -- Table to store created unit groups by groupIndex
    --print("check1")
        for groupIndex, group in pairs(groups) do
            for _, targetName in ipairs(group.list) do
                for _, entry in ipairs(temp_units_gather) do
                    --print("check2")
                    if not entry.set and entry.name == targetName then
                        --print("check3")
                        entry.set = true
                        local playerUnit = playerArmy:getUnit(entry.index)
                        if playerUnit then
                            --print("check4")
                            -- Create group if it hasn't been created yet
                            if not createdGroups[groupIndex] then
                                --print("check5")
                                createdGroups[groupIndex] = playerArmy:defineUnitGroup(group.name, playerUnit)
                            else
                                --print("check6")
                                createdGroups[groupIndex]:addUnit(playerUnit)
                            end
                        end
                        break
                    end
                end
            end
        end
    
        groups_set = true
    end
end

function testje()
    local campaign = M2TW.campaign
    for i = 0, campaign.settlementNum - 1 do
    local sett = campaign:getSettlement(i)
        if sett ~= nil then
            if sett.ownerFaction.name == "normans" then
                M2TWEOP.setModel(sett.xCoord,sett.yCoord,1,1)
            end
        end
    end
end
--[[
for i = 0, 1500 do
    local eduEntry = M2TWEOPDU.getEduEntry(i)
    if eduEntry ~= nil then
        if eduEntry:hasOwnership(eur_playerFactionId) then
            if eduEntry.localizedName == 'Unlocalised placement text' then
                print("Entry: "..eduEntry.eduType, "Localised: "..eduEntry.localizedName)
            end
        end
    end
end
]]
            --[[
            ImGui.Text("Click to form re-united kingdom next turn.")
            if (ImGui.Button("Re-united", 80, 20)) then
                if not turks_sicily_confed then
                    turks_sicily_confed = true
                    local ND = eur_campaign:getFaction("turks")
                    local Gondor = eur_campaign:getFaction("sicily")
                    local aragorn = getnamedCharbyLabel("aragorn_1")
                    if aragorn then
                        aragorn:addTraitPoints("Aragorn", 7)
                    end
                    M2TWEOP.setScriptCounter("nd_choose_rk", 1)
                    eur_campaign:setDipStance(dipRelType.alliance, ND, Gondor);

                    if EOP_WAVS["uicah_menuclick1"] ~= nil then
                        M2TWEOPSounds.playEOPSound(EOP_WAVS["uicah_menuclick1"])
                    end
                end
            end
            if turks_sicily_confed then
                ImGui.TextColored(0,1,0,1,"Gondor Confederation chosen!")
            end
            ]]



--[[
    function collectFin()
        for i = 0, eur_campaign.numberOfFactions - 1 do
            local faction = eur_campaign:getFactionByOrder(i)
            if faction ~= eur_player_faction then
                print(faction.name)
                print(tostring(faction.money).." income")
                local economyTable = faction:getFactionEconomy(1)
                local income = 
                economyTable.farmingIncome +
                economyTable.taxesIncome +
                economyTable.miningIncome +
                economyTable.tradeIncome +
                economyTable.merchantIncome +
                --economyTable.constructionIncome +
                economyTable.lootingIncome +
                finance_calc.missionIncome +
                finance_calc.diplomacyIncome +
                finance_calc.tributesIncome +
                economyTable.adminIncome +
                economyTable.kingsPurseIncome
                print(tostring(income).." income")
            end
        end
    end
    collectFin()
    ]]

    
deploy_garrison = true
function checkGarrison()
    if M2TW.selectionInfo.selectedCharacter then
        if M2TW.selectionInfo.selectedCharacter.characterType == 6 or M2TW.selectionInfo.selectedCharacter.characterType == 7 then
            if M2TW.selectionInfo.hoveredSettlement ~= nil then
                local sett = M2TW.selectionInfo.hoveredSettlement
                if sett.ownerFaction == eur_player_faction then
                    local extents = M2TW.selectionInfo.selectedCharacter:getMovementExtents(searchType.avoidZoc, 1)
                    if extents ~= nil then
                        local extentTile = extents:getTile(sett.xCoord, sett.yCoord)
                        if extentTile ~= nil then
                            if extentTile.turns == 1 then
                                if sett.army ~= nil then
                                    local rclicked = ImGui.IsMouseClicked(ImGuiMouseButton.Right)
                                    if rclicked then
                                        --clearGarrison(sett)
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

function clearGarrison(sett)
    for i = 0, sett.army.numOfUnits - 1 do
        local unit = sett.army:getUnit(i)
        if unit ~= nil then
            if unit.alias == "test" then
                deploy_garrison = false
                unit:kill()
            end
        end
    end
    --sett:createArmyInSettlement()
    wait(dep_gar_switch, 2)
end


function dep_gar_switch()
    deploy_garrison = true
end

    function testexpand()
        local settlement = eur_sMap:getSettlement("South_Enedwaith")
        if settlement ~= nil then
            if settlement.ownerFaction.name == "slave" then
                local army = eurSpawnArmy("teutonic_order", "random_name", "enedwaith_attackers_5", "", true, 31, "Mountain Uruks", 179, 256, 2, 1, 1)
                if army then
                    army:createUnit("Clan Heralds", 3, 0, 0);
                    army:createUnit("Liadan Spearmen", 2, 0, 0);
                    army:createUnit("Dubhshith Foresters", 2, 0, 0);
                    if army.leader ~= nil then
                        char = army.leader.namedCharacter
                        if char ~= nil then
                            char:addTrait("MiddleManRace", 1)
                            char:addTrait("EnedwaithClansman", 1)
                            char:addTrait("AIBoost", 1)
                            char:addTrait("Berserker", 1)
                            char:addTrait("GoodAmbusher", 2)
                            char:addTrait("GoodCommander", 2)
                            char:addTrait("Loyal", 2)
                            char:addTrait("LoyaltyStarter", 1)
                            char:addTrait("NightBattleCapable", 1)
                            char:addTrait("PietyStarter", 1)
                        end
                    end
                end
            end
        end
    end

    function setEMT()
        local sett = M2TW.selectionInfo.hoveredSettlement
        if sett ~= nil then
            if sett.name == "Weather_Hills" then
                print("set name")
                M2TWEOP.setExpandedString("EMT_TURKS_FACTION_LEADER", "High King");
            else
                M2TWEOP.setExpandedString("EMT_TURKS_FACTION_LEADER", "Dudejemans");
            end
        end
    end

    local gondor_fiefs = {
        ["Lossarnach"] = {
            ids = {180},  -- Lossarnach_Province
            r = 140, g = 80, b = 100
        },
        ["Lebennin"] = {
            ids = {178, 191, 194, 188},  -- Brethil_Province, Lebennin_Province, Fanuilond_Province, West_Lebennin_Province
            r = 60, g = 110, b = 50
        },
        ["Belfalas"] = {
            ids = {193, 186},  -- Methrast_Province, Edhellond_Haven_Province
            r = 20, g = 50, b = 100
        },
        ["Lamedon"] = {
            ids = {176},  -- Tarnost_Province
            r = 120, g = 100, b = 70
        },
        ["Anfalas"] = {
            ids = {185, 163},  -- Anfalas_Province, Andrast_Province
            r = 160, g = 140, b = 110
        },
        ["Morothond"] = {
            ids = {174, 157},  -- Lamedon_Province, Erech_Hill_Province
            r = 50, g = 55, b = 60
        },
        ["Ringló Vale"] = {
            ids = {165},  -- Ethring_Province
            r = 55, g = 100, b = 70
        },
        ["Pinnath_Gelin"] = {
            ids = {173},  -- Pinnath_Gelin_Province
            r = 40, g = 90, b = 50
        }
    }
    
    -- Create reverse lookup and set banner colors
    local regionID_to_fief = {}
    for fief, data in pairs(gondor_fiefs) do
        if type(data.ids) == "table" then
            for _, id in ipairs(data.ids) do
                regionID_to_fief[id] = fief
            end
        else
            regionID_to_fief[data.ids] = fief
        end
    end
    
    function setBannerColors(faction)
        for i = 0, faction.settlementsNum - 1 do
            local settlement = faction:getSettlement(i);
            if settlement ~= nil then
                local fief = regionID_to_fief[settlement.regionID]
                if fief ~= nil then
                    if settlement.army ~= nil then
                        local color = gondor_fiefs[fief]
                        settlement.army.bannerRed = color.r
                        settlement.army.bannerGreen = color.g
                        settlement.army.bannerBlue = color.b
                        settlement.army.bannerSet = true
                    end
                end
            end
        end
    end


-- Unit Validation Function
-- Loops through all unit lists and checks if each unit exists in EDU

-- Function to validate all units in the gen_units_list_default
function validateAllUnits()
    print("=== Starting Unit Validation ===\n")
    
    local notFoundCount = 0
    local totalCount = 0
    
    -- Validate gen_units_list_default
    print("--- Validating gen_units_list_default ---")
    for faction, tiers in pairs(gen_units_list_default) do
        
        for tier, units in pairs(tiers) do
            if tier == "special" then
                -- Special units are in an array
                for _, unitName in ipairs(units) do
                    totalCount = totalCount + 1
                    local eduEntry = M2TWEOPDU.getEduEntryByType(unitName)
                    if eduEntry == nil then
                        print("  " .. unitName .. " - not found")
                        notFoundCount = notFoundCount + 1
                    end
                end
            else
                -- T1, T2, T3 units are indexed
                for _, unitName in pairs(units) do
                    totalCount = totalCount + 1
                    local eduEntry = M2TWEOPDU.getEduEntryByType(unitName)
                    if eduEntry == nil then
                        print("  " .. unitName .. " - not found")
                        notFoundCount = notFoundCount + 1
                    end
                end
            end
        end
    end

        
    -- Validate gen_units_list_default
    print("--- Validating gen_units_list_default ---")
    for faction, tiers in pairs(gen_units_list_default2) do
        
        for tier, units in pairs(tiers) do
            if tier == "special" then
                -- Special units are in an array
                for _, unitName in ipairs(units) do
                    totalCount = totalCount + 1
                    local eduEntry = M2TWEOPDU.getEduEntryByType(unitName)
                    if eduEntry == nil then
                        print("  " .. unitName .. " - not found")
                        notFoundCount = notFoundCount + 1
                    end
                end
            else
                -- T1, T2, T3 units are indexed
                for _, unitName in pairs(units) do
                    totalCount = totalCount + 1
                    local eduEntry = M2TWEOPDU.getEduEntryByType(unitName)
                    if eduEntry == nil then
                        print("  " .. unitName .. " - not found")
                        notFoundCount = notFoundCount + 1
                    end
                end
            end
        end
    end
    
    
    -- Validate leaderheir_combi_list
    print("\n--- Validating leaderheir_combi_list ---")
    for faction, roles in pairs(leaderheir_combi_list) do
        
        -- Check leader unit
        totalCount = totalCount + 1
        local eduEntry = M2TWEOPDU.getEduEntryByType(roles.leader.unit)
        if eduEntry == nil then
            print("  " .. roles.leader.unit .. " (leader) - not found")
            notFoundCount = notFoundCount + 1
        end
        
        -- Check heir unit
        totalCount = totalCount + 1
        eduEntry = M2TWEOPDU.getEduEntryByType(roles.heir.unit)
        if eduEntry == nil then
            print("  " .. roles.heir.unit .. " (heir) - not found")
            notFoundCount = notFoundCount + 1
        end
    end
    
    -- Validate SWAP_GARRISON
    print("\n--- Validating SWAP_GARRISON ---")
    for faction, data in pairs(SWAP_GARRISON) do
        
        -- Check all units in the new garrison array
        for _, unitName in ipairs(data.new) do
            totalCount = totalCount + 1
            local eduEntry = M2TWEOPDU.getEduEntryByType(unitName)
            if eduEntry == nil then
                print("  " .. unitName .. " - not found")
                notFoundCount = notFoundCount + 1
            end
        end
    end
    
    
    -- Validate SETT_GARRISONS
    print("\n--- Validating SETT_GARRISONS ---")
    for faction, settlements in pairs(SETT_GARRISONS) do
        
        for settlement, enemyFactions in pairs(settlements) do
            for enemyFaction, garrisonUnits in pairs(enemyFactions) do
                -- Each garrison unit entry is a table: { "unit_name", num1, num2, num3, num4 }
                for _, unitEntry in ipairs(garrisonUnits) do
                    local unitName = unitEntry[1]
                    totalCount = totalCount + 1
                    local eduEntry = M2TWEOPDU.getEduEntryByType(unitName)
                    if eduEntry == nil then
                        print("  " .. unitName .. " (settlement: " .. settlement .. ", vs: " .. enemyFaction .. ") - not found")
                        notFoundCount = notFoundCount + 1
                    end
                end
            end
        end
    end
    
    -- Summary
    print("\n=== Validation Complete ===")
    print("Total units checked: " .. totalCount)
    print("Units not found: " .. notFoundCount)
    print("Units valid: " .. (totalCount - notFoundCount))
    
    if notFoundCount == 0 then
        print("\nAll units validated successfully!")
    else
        print("\nWarning: Some units were not found in EDU")
    end
end

-- Call the validation function
--validateAllUnits()

function addStacks()
  local  faction_list = {
        "aztecs",
        "byzantium",
        "denmark",
        "england",
        "france",
        "gundabad",
        "hre",
        "hungary",
        "ireland",
        "khand",
        "milan",
        "mongols",
        "moors",
        "normans",
        "norway",
        "poland",
        "portugal",
        "russia",
        "saxons",
        "scotland",
        "sicily",
        "spain",
        "teutonic_order",
        "timurids",
        "turks",
        "venice",
    }
    for i = 5, #faction_list do
        local faction = eur_campaign:getFaction(faction_list[i])
        if faction ~= eur_player_faction then
            if faction.capital then
                local army = eurSpawnArmy(faction.name, "random_name", "leg_", "", false, 18, gen_units_list[faction.name]["special"][1], faction.capital.xCoord, faction.capital.yCoord, 3, 1, 0)
                if army then    
                    for i = 1, 5 do
                            local rand = math.random(0, #gen_units_list[faction.name]["T2"]-1)
                            local new_unit = gen_units_list[faction.name]["T2"][rand]
                            army:createUnit(new_unit, 0, 0, 0)
                    end
                    for i = 1, 10 do
                        local rand = math.random(0, #gen_units_list[faction.name]["T1"]-1)
                        local new_unit = gen_units_list[faction.name]["T1"][rand]
                        army:createUnit(new_unit, 0, 0, 0)
                    end
                end
            end
        end
    end
end


local unique_names = {

}

local unique_labels = {

}

function fixCharUniqueName(char)
    if char ~= nil then
        if tableContains(unique_names,char.shortName) then
            if not tableContains(unique_labels, char.label) then
                char:giveRandomName()
            end
        end
    end
end


function charsOff()
    local characterNum = eur_player_faction.numOfCharacters
    for i = 0, characterNum - 1 do
    local char = eur_player_faction:getCharacter(i)
    print(char.characterRecord.fullName)
    print(char.characterType)
        --if char.isGeneral == true then
            if char.characterType == 7 then
                if char.characterRecord:isHeir() then
                    --
                elseif char.characterRecord:isLeader() then
                    --
                else
                    --char:sendOffMap()
                    --print("2")
                end
            end
        --end
    end
end

---@class (exact) waitCallback
---@field tick integer
---@field hasFired boolean
---@field callback function

CAMPAIGN_WAIT = {
    ---@type table<integer, waitCallback>
    callbacks = {},
}

function CAMPAIGN_WAIT:wait(duration, callback)
    local tick = CAMPAIGN.tickCount + duration
    table.insert(self.callbacks, {
        tick = tick,
        callback = callback,
        hasFired = false,
    })
    --log(stringFormat("Wait started: {1} ticks, {2} seconds", duration, duration / 10.0, logLevel.TRACE))
end

function CAMPAIGN_WAIT:waitSeconds(duration, callback)
    self:wait(duration * 10, callback)
end

function CAMPAIGN_WAIT:execute()
    for key, element in pairs(self.callbacks) do
        if CAMPAIGN.tickCount >= element.tick and not element.hasFired then
            element.hasFired = true
            if element.callback then
                element.callback()
            end
            --log("Wait Finished", logLevel.TRACE)
            self.callbacks[key] = nil
        end
    end
end


