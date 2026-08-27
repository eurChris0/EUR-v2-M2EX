function filter_table_altloot(dict, min_count, key, threshold, comparison)
    if #dict < min_count then
        return {}
    end

    local matches = {}
    for _, entry in ipairs(dict) do
        local value = entry[key]
        if value then
            local ok = false
            if comparison == "gt" and value > threshold then ok = true end
            if comparison == "lt" and value < threshold then ok = true end
            if comparison == "eq" and value == threshold then ok = true end

            if ok then
                table.insert(matches, entry)
            end
        end
    end

    if #matches < min_count then
        return {}
    end

    -- Shuffle and return exactly min_count matches
    for i = #matches, 2, -1 do
        local j = math.random(i)
        matches[i], matches[j] = matches[j], matches[i]
    end

    local result = {}
    for i = 1, min_count do
        table.insert(result, matches[i])
    end

    return result
end

local alt_kills_unit = {}
local alt_caught_unit = {}
local alt_exp_unit = {}
local alt_checked = false

function checkAltLoot()
    local value = 1
    if #alt_loot_units > 10 then 
        value = 2
    end
    alt_kills_unit = filter_table_altloot(alt_loot_units, value, "kills", 50, "gt")
    alt_caught_unit = filter_table_altloot(alt_loot_units, 1, "caught", 50, "gt")
    alt_exp_unit = filter_table_altloot(alt_loot_units, 1, "expgain", 1, "gt")
    alt_checked = true
end

function altLootWindow()
    if not alt_loot then
        show_alt_loot = false
        alt_loot = false
        alt_loot_units = {}
        alt_loot_anc = {}
        alt_loot_enemy_gen = {}
        alt_loot_player_gen = {}
        won_battle_alt = false
        alt_checked = false
        return
    end

    if not alt_checked then
        checkAltLoot()
    end

    if (math.random(1, 100) > 30) then
        for k, v in pairs(alt_kills_unit) do
            if k ~= nil then
                if v.unit ~= nil then
                    if not v.unit.dead then
                        if v.unit.exp < 9 then
                            if v.unit.eduEntry ~= nil then
                                print("adding exp "..v.unit.eduEntry.eduType)
                                v.unit:setParams((v.unit.exp+1),v.unit.armourLVL,v.unit.weaponLVL);
                            end
                        end
                    end
                end
            end
        end
        show_alt_loot = false
        alt_loot = false
        alt_loot_units = {}
        alt_loot_anc = {}
        alt_loot_enemy_gen = {}
        alt_loot_player_gen = {}
        won_battle_alt = false
        alt_checked = false
        return
    else
        show_alt_loot = false
        alt_loot = false
        alt_loot_units = {}
        alt_loot_anc = {}
        alt_loot_enemy_gen = {}
        alt_loot_player_gen = {}
        won_battle_alt = false
        alt_checked = false
        return
    end

    -- ends here

    local count = 0
    if alt_kills_unit ~= {} and (math.random(1, 100) > 50) then
        count = 1
    elseif alt_caught_unit ~= {} and (math.random(1, 100) > 50) then
        count = 2
    elseif alt_exp_unit ~= {} and (math.random(1, 100) > 50) then
        count = 3
    else
        show_alt_loot = false
        alt_loot = false
        alt_loot_units = {}
        alt_loot_anc = {}
        alt_loot_enemy_gen = {}
        alt_loot_player_gen = {}
        won_battle_alt = false
        alt_checked = false
        return
    end

    ImGui.SetNextWindowPos(760*eurbackgroundWindowSizeRight, 450*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(1)
    ImGui.SetNextWindowSize(400*eurbackgroundWindowSizeRight, 300*eurbackgroundWindowSizeBottom)
    ImGui.Begin("altloot_window_background", true, bit.bor(ImGuiWindowFlags.NoDecoration))
    eurStyle("basic_1", true)
    if bg_small_1 then
        --ImGui.Image(bg_small_1.img, 835*eurbackgroundWindowSizeRight, 590*eurbackgroundWindowSizeBottom)
    end
    ImGui.SetNextWindowPos(760*eurbackgroundWindowSizeRight, 450*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.5)
    ImGui.BeginChild("altloot_child_1", 400*eurbackgroundWindowSizeRight, 220*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)

    if count == 1 then
        func_alt_kills_unit()
    elseif count == 2 then
        func_alt_caught_unit()
    elseif count == 3 then
        func_alt_exp_unit()
    end

    --[[for k, v in pairs(alt_loot_anc) do
        if k ~= nil then
            if alt_loot_player_gen ~= nil and alt_loot_enemy_gen ~= nil then
                if test1 then
                    local upgrade_clicked = ImGui.ImageButton(v.name,test1.img, 64*eurbackgroundWindowSizeRight, 64*eurbackgroundWindowSizeBottom)
                    if (upgrade_clicked == true) then
                        alt_loot_remove_stuff[0] = alt_loot_enemy_gen
                        alt_loot_remove_stuff[1] = v
                        alt_loot_remove_stuff[2] = true
                        alt_loot_player_gen:addAncillary(v.name);
                        show_alt_loot = false
                        alt_loot = false
                        alt_loot_units = {}
                        alt_loot_anc = {}
                        alt_loot_enemy_gen = {}
                        alt_loot_player_gen = {}
                        won_battle_alt = false
                        alt_checked = false
                    end
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        ImGui.BeginTooltip()
                        ImGui.Text("Steal: "..v.localizedName)
                        ImGui.EndTooltip()
                    end
                end
            end
        end
    end]]
    ImGui.EndChild()
    if (centeredImageButton("Close", 80, 50, 40)) then
        show_alt_loot = false
        alt_loot = false
        alt_loot_units = {}
        alt_loot_anc = {}
        alt_loot_enemy_gen = {}
        alt_loot_player_gen = {}
        won_battle_alt = false
        alt_checked = false
        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
    end
    eurStyle("basic_1", false)
    ImGui.End()
end

function endTurnRemoveStuff()
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."endTurnRemoveStuff");
	end
    if alt_loot_remove_stuff[2] then
        if alt_loot_remove_stuff[0].isAlive then
            alt_loot_remove_stuff[0]:removeAncillary(alt_loot_remove_stuff[1]);
        end
    end
    alt_loot_remove_stuff[0] = nil
    alt_loot_remove_stuff[1] = nil
    alt_loot_remove_stuff[2] = false
end

function func_alt_kills_unit()

end

function func_alt_caught_unit()

end

function func_alt_exp_unit()
    local unit = alt_exp_unit[1].unit
    if unit.dead then return end
    local armourLVL = unit.armourLVL
    local max_armour = unit.eduEntry:getArmourLevel(unit.eduEntry:getArmourLevelNum())
    if unit.exp < 5 and (math.random(1, 100) > 50) then
        --option extra exp
    elseif armourLVL ~= max_armour and (math.random(1, 100) > 50) then
        -- max armour/weapon option
    elseif unit.exp > 3 and (math.random(1, 100) > 50) then
        local count = 0
        for i = 1, #UNIT_UPGRADES[unit.eduEntry.eduType].unit do
            if UNIT_UPGRADES[unit.eduEntry.eduType].unit[i] ~= nil then
                if UNIT_UPGRADES[unit.eduEntry.eduType].cost_multi[i] >= 1 then
                    local eduEntry = M2TWEOPDU.getEduEntryByType(UNIT_UPGRADES[unit.eduEntry.eduType].unit[i])
                    if eduEntry:hasOwnership(eur_playerFactionId) then
                        local check_counter = checkCounter(UNIT_UPGRADES[unit.eduEntry.eduType].counter[i])
                        if check_counter == true then
                            count = count + 1
                            local unit_tga = eduEntry.unitCardTga
                            if eur_tga_table[unit_tga] then
                                local upgrade_clicked = ImGui.ImageButton("upgrade_button_0"..tostring(i),eur_tga_table[unit_tga].img, img_x, img_y)
                                if (upgrade_clicked == true) then
                                    unit.eduEntry = eduEntry
                                    unit.armourLVL = unit.eduEntry:getArmourLevel(unit.eduEntry:getArmourLevelNum())
                                    unit.weaponLVL = 1
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
                end
            end
        end
        if count == 0 then
            if unit.exp < 9 then
                local unit_tga = unit.eduEntry.unitCardTga
                if eur_tga_table[unit_tga] then
                    local upgrade_clicked = ImGui.ImageButton("upgrade_button_0_exp",eur_tga_table[unit_tga].img, img_x, img_y)
                    if (upgrade_clicked == true) then
                        if unit.exp >= 7 then
                            unit.exp = 9
                        else
                            unit.exp = unit.exp + 2
                        end
                    end
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        ImGui.BeginTooltip()
                        ImGui.Text("Experience bonus for: "..eduEntry.eduType)
                        ImGui.EndTooltip()
                    end
                end
            end
        end
    end
end