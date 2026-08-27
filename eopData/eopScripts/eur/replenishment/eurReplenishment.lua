local replen = {}

replen_exempt = {
    "Sauron",
    "Moria Balrog",
    "Armored Balrog",
    "Goblin King",
}

function replen.replenishUnits(faction)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."replenishUnits");
	end
    local bonus = 0
    if faction.isPlayerControlled == 1 then bonus = (bonus+replen_bonus) end
    if faction.isPlayerControlled == 0 then bonus = 8 end
    local sett_num = faction.settlementsNum;
    local forts_num = faction.fortsNum;
    --if not replen_always then
        for x = 0, forts_num -1 do
            local fort = faction:getFort(x)
            if fort.army ~= nil then
                if fort.siegeNum == 0 then
                    local army = fort.army
                    local num_unit = army.numOfUnits
                    for i = 0, num_unit -1 do
                        local random_value = math.random(replen_values.replen_randmin, replen_values.replen_randmax);
                        local stack_unit = army:getUnit(i);
                        if stack_unit ~= nil then
                            if not string.find(stack_unit.alias, "Garrison") then
                                if stack_unit.eduEntry.category ~= 4 then
                                    local road_level = replenRoadLevel(army.regionID)
                                    if road_level ~= 0 then
                                        if replen_values.replen_road_level[road_level] ~= 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.replen_road_level[road_level]+random_value)
                                        end
                                    end
                                    if replen_values.replen_multi ~= 0 then
                                        random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.replen_multi+random_value)
                                    end
                                    if tableContains(goblin_factions, faction.name) then
                                        if (replen_values.goblin_bonus ~= nil) and replen_values.goblin_bonus > 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.goblin_bonus+random_value)
                                        end
                                    end
                                    if tableContains(men_factions, faction.name) then
                                        if (replen_values.men_bonus ~= nil) and replen_values.men_bonus > 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.men_bonus+random_value)
                                        end
                                    end
                                    local random_value = (random_value+bonus)
                                    if replen_values.replen_bonus ~= nil then
                                        if replen_values.replen_bonus > 0 then
                                            local bonus = replen_values.replen_bonus / 100
                                            random_value = math.floor(random_value* (1 + bonus))
                                        end
                                    end
                                    if stack_unit.eduEntry.category == 1 then
                                        random_value = math.random(1, 2);
                                        random_value = math.ceil(stack_unit.soldierCountStratMapMax/50+random_value)
                                    end
                                    if stack_unit.eduEntry.soldierCount <= 10 then
                                        random_value = 1
                                    end
                                    --print("adding: "..random_value.." to: "..stack_unit.eduEntry.eduType)
                                    if stack_unit.eduEntry ~= nil then
                                        if stack_unit.eduEntry.soldierCount > replen_beast_value then
                                            local unit_soldier_max = stack_unit.soldierCountStratMapMax;
                                            local unit_soldier = stack_unit.soldierCountStratMap;
                                            if (unit_soldier + random_value < unit_soldier_max) then
                                                if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                    stack_unit.soldierCountStratMap = 1
                                                else
                                                    stack_unit.soldierCountStratMap = unit_soldier + random_value;
                                                end
                                                if faction == eur_player_faction then
                                                    if not tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                        local cost = math.floor(stack_unit.eduEntry.recruitCost / stack_unit.soldierCountStratMap)
                                                        cost = cost * random_value
                                                        replen_totals = replen_totals+cost
                                                        replenished_over_turn = true
                                                    end
                                                end
                                            end
                                            if (unit_soldier_max - (unit_soldier + random_value) < 2) then
                                                if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                    stack_unit.soldierCountStratMap = 1
                                                else
                                                    stack_unit.soldierCountStratMap = unit_soldier_max;
                                                end
                                                if faction == eur_player_faction then
                                                    if not tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                        local cost = math.floor(stack_unit.eduEntry.recruitCost / stack_unit.soldierCountStratMap)
                                                        local diff = unit_soldier_max - stack_unit.soldierCountStratMap
                                                        cost = cost * diff
                                                        replen_totals = replen_totals+cost
                                                        replenished_over_turn = true
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                        stack_unit.soldierCountStratMap = 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        for x = 0, sett_num -1 do
            local settlement = faction:getSettlement(x)
            if settlement.army ~= nil then
                if settlement.siegesNum == 0 then
                    local waystation_present = false
                    if settlement:buildingPresentMinLevel("military_academy", false) then
                        waystation_present = true
                    else
                        waystation_present = false
                    end
                    local aquaduct_present = false
                    if settlement:buildingPresentMinLevel("aqueduct", true) then
                        aquaduct_present = true
                    else
                        aquaduct_present = false
                    end
                    local army = settlement.army
                    local num_unit = army.numOfUnits
                    for i = 0, num_unit -1 do
                        local random_value = math.random(replen_values.replen_randmin, replen_values.replen_randmax);
                        local stack_unit = army:getUnit(i);
                        if stack_unit ~= nil then
                            if not string.find(stack_unit.alias, "Garrison") then
                                if stack_unit.eduEntry.category ~= 4 then
                                    local road_level = replenRoadLevel(army.regionID)
                                    if road_level ~= 0 then
                                        if replen_values.replen_road_level[road_level] ~= 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.replen_road_level[road_level]+random_value)
                                        end
                                    end
                                    if replen_values.replen_multi ~= 0 then
                                        random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.replen_multi+random_value)
                                    end
                                    if tableContains(goblin_factions, faction.name) then
                                        if (replen_values.goblin_bonus ~= nil) and replen_values.goblin_bonus > 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.goblin_bonus+random_value)
                                        end
                                    end
                                    if tableContains(men_factions, faction.name) then
                                        if (replen_values.men_bonus ~= nil) and replen_values.men_bonus > 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.men_bonus+random_value)
                                        end
                                    end
                                    local random_value = (random_value+bonus)
                                    if waystation_present then
                                        if replen_values.waystation_bonus ~= 0 then
                                            random_value = math.ceil((stack_unit.soldierCountStratMapMax/replen_values.waystation_bonus)+random_value)
                                        end
                                    end
                                    if aquaduct_present then
                                        if replen_values.aquaduct_bonus ~= 0 then
                                            random_value = math.ceil((stack_unit.soldierCountStratMapMax/replen_values.aquaduct_bonus)+random_value)
                                        end
                                    end
                                    if replen_values.replen_bonus ~= nil then
                                        if replen_values.replen_bonus > 0 then
                                            local bonus = replen_values.replen_bonus / 100
                                            random_value = math.floor(random_value* (1 + bonus))
                                        end
                                    end
                                    if stack_unit.eduEntry.category == 1 then
                                        random_value = math.random(1, 2);
                                        random_value = math.ceil(stack_unit.soldierCountStratMapMax/50+random_value)
                                    end
                                    if stack_unit.eduEntry.soldierCount <= 10 then
                                        random_value = 1
                                    end
                                    --print("adding: "..random_value.." to: "..stack_unit.eduEntry.eduType)
                                    if stack_unit.eduEntry ~= nil then
                                        if stack_unit.eduEntry.soldierCount > replen_beast_value then
                                            local unit_soldier_max = stack_unit.soldierCountStratMapMax;
                                            local unit_soldier = stack_unit.soldierCountStratMap;
                                            if (unit_soldier + random_value < unit_soldier_max) then
                                                if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                    stack_unit.soldierCountStratMap = 1
                                                else
                                                    stack_unit.soldierCountStratMap = unit_soldier + random_value;
                                                end
                                                if faction == eur_player_faction then
                                                    if not tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                        local cost = math.floor(stack_unit.eduEntry.recruitCost / stack_unit.soldierCountStratMap)
                                                        cost = cost * random_value
                                                        replen_totals = replen_totals+cost
                                                        replenished_over_turn = true
                                                    end
                                                end
                                            end
                                            if (unit_soldier_max - (unit_soldier + random_value) < 2) then
                                                if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                    stack_unit.soldierCountStratMap = 1
                                                else
                                                    stack_unit.soldierCountStratMap = unit_soldier_max;
                                                end
                                                if faction == eur_player_faction then
                                                    if not tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                        local cost = math.floor(stack_unit.eduEntry.recruitCost / stack_unit.soldierCountStratMap)
                                                        local diff = unit_soldier_max - stack_unit.soldierCountStratMap
                                                        cost = cost * diff
                                                        replen_totals = replen_totals+cost
                                                        replenished_over_turn = true
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                        stack_unit.soldierCountStratMap = 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if replen_always then
            for x = 0, faction.stacksNum - 1 do
                local army = faction:getStack(x)
                if army ~= nil then
                    if not (army:findInSettlement() or army:findInFort()) then
                    local num_unit = army.numOfUnits
                    for i = 0, num_unit -1 do
                        local random_value = math.random(replen_values.replen_randmin, replen_values.replen_randmax);
                        local stack_unit = army:getUnit(i);
                        if stack_unit ~= nil then
                            if not string.find(stack_unit.alias, "Garrison") then
                                if stack_unit.eduEntry.category ~= 4 then
                                    local road_level, owner = replenRoadLevel(army.regionID)
                                    if road_level ~= 0 then
                                        if replen_values.replen_road_level[road_level] ~= 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.replen_road_level[road_level]+random_value)
                                        end
                                    end
                                    if tableContains(goblin_factions, faction.name) then
                                        if (replen_values.goblin_bonus ~= nil) and replen_values.goblin_bonus > 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.goblin_bonus+random_value)
                                        end
                                    end
                                    if tableContains(men_factions, faction.name) then
                                        if (replen_values.men_bonus ~= nil) and replen_values.men_bonus > 0 then
                                            random_value = math.ceil(stack_unit.soldierCountStratMapMax/replen_values.men_bonus+random_value)
                                        end
                                    end
                                    local field_multi = replen_values.replen_field_other
                                    if owner ~= nil then
                                        if owner == faction then
                                            field_multi = replen_values.replen_field_own
                                        else
                                            local alliance = eur_campaign:checkDipStance(dipRelType.alliance, faction, owner)
                                            if alliance then
                                                field_multi = replen_values.replen_field_own
                                            end
                                        end
                                    end
                                    if field_multi ~= 0 then
                                        random_value = math.ceil(stack_unit.soldierCountStratMapMax/field_multi+random_value)
                                    end
                                    local random_value = (random_value+bonus)
                                    if replen_values.replen_bonus ~= nil then
                                        if replen_values.replen_bonus > 0 then
                                            local bonus = replen_values.replen_bonus / 100
                                            random_value = math.floor(random_value* (1 + bonus))
                                        end
                                    end
                                    if stack_unit.eduEntry.category == 1 then
                                        random_value = math.random(1, 2);
                                        random_value = math.ceil(stack_unit.soldierCountStratMapMax/50+random_value)
                                    end
                                    if stack_unit.eduEntry.soldierCount <= 10 then
                                        random_value = 1
                                    end
                                    --print("adding: "..random_value.." to: "..stack_unit.eduEntry.eduType)
                                    if stack_unit.eduEntry ~= nil then
                                        if stack_unit.eduEntry.soldierCount > replen_beast_value then
                                            local unit_soldier_max = stack_unit.soldierCountStratMapMax;
                                            local unit_soldier = stack_unit.soldierCountStratMap;
                                            if (unit_soldier + random_value < unit_soldier_max) then
                                                if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                    stack_unit.soldierCountStratMap = 1
                                                else
                                                    stack_unit.soldierCountStratMap = unit_soldier + random_value;
                                                end
                                                if faction == eur_player_faction then
                                                    if not tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                        local cost = math.floor(stack_unit.eduEntry.recruitCost / stack_unit.soldierCountStratMap)
                                                        cost = cost * random_value
                                                        replen_totals = replen_totals+cost
                                                        replenished_over_turn = true
                                                    end
                                                end
                                            end
                                            if (unit_soldier_max - (unit_soldier + random_value) < 2) then
                                                if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                    stack_unit.soldierCountStratMap = 1
                                                else
                                                    stack_unit.soldierCountStratMap = unit_soldier_max;
                                                end
                                                if faction == eur_player_faction then
                                                    if not tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                                        local cost = math.floor(stack_unit.eduEntry.recruitCost / stack_unit.soldierCountStratMap)
                                                        local diff = unit_soldier_max - stack_unit.soldierCountStratMap
                                                        cost = cost * diff
                                                        replen_totals = replen_totals+cost
                                                        replenished_over_turn = true
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    if tableContains(replen_exempt, stack_unit.eduEntry.eduType) then
                                        stack_unit.soldierCountStratMap = 1
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

function replen.setRadagastLevel(character)
    if character.character ~= nil then
        if character.label == "radagast" then
            if not character.character.markedForDeath then
                if character.character.bodyguards ~= nil then
                    if character.character.bodyguards.soldierCountStratMap < 21 then
                        character.character.bodyguards.soldierCountStratMap = character.character.bodyguards.soldierCountStratMap+2
                        if character.character.bodyguards.soldierCountStratMap > 20 then
                            character.character.bodyguards.soldierCountStratMap = 20
                        end
                    end
                end
            end
        end
    end
end

function clampChars(faction)
    if faction == nil then return end
    if faction.numOfCharacters == 0 then return end
    if faction.name == "slave" then return end
    for i = 0, faction.numOfCharacters - 1 do
        local character = faction:getCharacter(i)
        if character ~= nil then
            if character.characterType == 7 then
                if not character.markedForDeath then
                    if character.bodyguards ~= nil then
                        if character.bodyguards.eduEntry ~= nil then
                            if tableContains(replen_exempt, character.bodyguards.eduEntry.eduType) then
                                character.bodyguards.soldierCountStratMap = 1
                                --print("---------------------------------------------------------test found")
                                --print(character.characterRecord.label)
                                --print(character.bodyguards.soldierCountStratMap)
                            end
                        end
                    end
                end
            end
        end
    end
end

function replen.setGeneralLevel(character)
    if character.character ~= nil then
        if not character.character.markedForDeath then
            if character.character.bodyguards ~= nil then
                if character.character.bodyguards.eduEntry ~= nil then
                    if tableContains(replen_exempt, character.character.bodyguards.eduEntry.eduType) then
                        character.character.bodyguards.soldierCountStratMap = 1
                        --print("---------------------------------------------------------test found")
                        --print(character.character.bodyguards.soldierCountStratMap)
                    end
                end
            end
        end
    end
end

function replen.disbandToPool(unit)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."disbandToPool");
	end
    if pause_disband then return end
    if unit.dead then return end
    local army = unit.army
    if unit.eduEntry.eduType == default_general_units[army.faction.name].old then return end
    if army then
        local sett = army:findInSettlement()
        if sett == nil then return end
        for i = 0, sett.recruitmentPoolCount - 1 do
            local pool = sett:getSettlementRecruitmentPool(i)
            --print(pool.availablePool)
            if pool.eduIndex == unit.eduEntry.index then
                pool.availablePool = pool.availablePool + (unit.soldierCountStratMap / unit.soldierCountStratMapMax)
            end
        end
    end
end

function replen.deductReplen()
    if not replenished_over_turn then return end
    local multi = replen_cost_multi / 100
    if multi == nil then return end
    if multi == 0 then return end
    if replen_totals ~= nil then
        if replen_totals > 1 then
            replen_totals = math.floor(replen_totals*multi)
            stratmap.game.callConsole("add_money", "-" .. tostring(replen_totals))
            if to_log then
                M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."===================== deducted replenishment costs "..tostring(replen_totals));
            end
            print("===================== deducted replenishment costs "..tostring(replen_totals))
        end
    end

    replen_totals = 0
    replenished_over_turn = false
end

return replen