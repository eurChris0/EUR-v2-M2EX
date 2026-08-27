local spoils = {}

local spoils_loot = 0
local our_num_units = 0

local victory_type = 0
won_battle = false
won_battle_alt = false
local lost_battle = false
pre_battle_garrison = {}
pre_battle_faction = ""

function spoils.postBattleChecks(faction)
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."postBattleChecks");
	end
    spoils.getBattleOutcomeWin()
    local victory_multi = 0
    if lost_battle == true then 
        lost_battle = false
        return end
    if victory_type == 3 then
        victory_multi = 0.8
    else
        victory_multi = 0.4
    end
    if won_battle then
        print("won")
        if spoils_loot ~= 0 then
            --print("initial", spoils_loot)
            spoils_loot = math.ceil(spoils_loot * victory_multi)
            --print("victory mult",spoils_loot)
            if our_num_units < 11 then
                --print("units", our_num_units)
                our_num_units = (our_num_units/10)
                spoils_loot = math.ceil(spoils_loot*our_num_units)
            end
            total_spoils_loot = (total_spoils_loot+spoils_loot)
            if not options_addspoils then
                spoils_loot = (400*victory_multi)
            end
            print("starting post battle check...")
            stratmap.game.callConsole("add_money", tostring(spoils_loot))
            print("adding cash " .. tostring(spoils_loot))
            stratmap.game.historicEvent("spoils_of_war_ai", "Enemy Camp Sacked", "Good tidings! Our men have found the enemy camp and claimed anything of worth. We should be able to make some coin out of this victory!\n\n" .. "Gold taken: " .. tostring(spoils_loot))
            spoils_loot = 0
        end
    end
    if eur_playerFactionId == faction.factionID then
        if spoils.getBattleOutcome() then
            total_losses_upkeep = (total_losses_upkeep+losses_upkeep)
        end
    end
    victory_type = 0
    won_battle = false
end

function spoils.getBattlePreInfo()
    pre_battle_faction = ""
    pre_battle_garrison = {}
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."getBattlePreInfo");
	end
    spoils_loot = 0
    our_num_units = 0
    if not eur_gameData then return end
    local thisBattle, battleList = eur_gameData.battleStruct, "Function: getBattleData()"
    for i = 1, thisBattle.sidesNum, 1 do
        local thisSide = thisBattle.sides[i]
        if thisSide.armies[1] ~= nil then
            local k = 1
            repeat
                local thisArmy = thisSide.armies[k].army
                if thisArmy ~= nil then
                    if thisArmy.faction.isPlayerControlled == 1 then
                        our_num_units = our_num_units+thisArmy.numOfUnits
                        temp_player_army = thisArmy
                        if thisArmy.leader ~= nil then
                            if thisArmy.leader.characterRecord ~= nil then
                                alt_loot_player_gen = thisArmy.leader.characterRecord
                            end
                        end
                        for i = 0, thisArmy.numOfUnits -1 do
                            local unit = thisArmy:getUnit(i)
                            print(unit.eduEntry.eduType)
                            losses_upkeep = (losses_upkeep+unit.eduEntry.upkeepCost)
                            print("Adding loss upkeep: " .. tostring(losses_upkeep))
                        end
                    end
                    local army_faction = thisArmy.faction
                    local isInWar = eur_campaign:checkDipStance(dipRelType.war, army_faction, eur_player_faction)
                    if thisArmy.faction.isPlayerControlled ~= 1 then
                        if isInWar == true then
                            local isInSett = thisArmy:findInSettlement()
                            local checkedalready = {}
                            local matchedSlots = {}
                            if isInSett == nil then
                                for j = 0, thisArmy.numOfUnits - 1 do
                                    local un = thisArmy:getUnit(j)
                                    if un.eduEntry.category ~= 4 then
                                        spoils_loot = spoils_loot + un.eduEntry.upkeepCost
                                        if GARRISON_TRACK[thisArmy.faction.name] then
                                            for settName, settData in pairs(GARRISON_TRACK[thisArmy.faction.name]) do
                                                for tierIndex, tierData in ipairs(settData) do
                                                    for g = 1, #tierData do
                                                        local slotKey = tierIndex .. "_" .. g
                                                        if not matchedSlots[slotKey] then
                                                            if not checkedalready[j] then
                                                                if un.eduEntry ~= nil then
                                                                    if tierData[g].alias == un.alias then
                                                                        tierData[g].pre_battle = true
                                                                        matchedSlots[slotKey] = true
                                                                        checkedalready[j] = true
                                                                        pre_battle_faction = thisArmy.faction.name
                                                                        if not tableContains(pre_battle_garrison, un.alias) then
                                                                            table.insert(pre_battle_garrison, un.alias)
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
                                if thisBattle.battleType == 5 then
                                    spoils_loot = 0
                                end
                                if thisArmy.leader ~= nil then
                                    if math.random(1, 100) > 10 then
                                        alt_loot = true
                                    end
                                    if thisArmy.leader.characterRecord ~= nil then
                                        alt_loot_anc = {}
                                        alt_loot_enemy_gen = thisArmy.leader.characterRecord
                                        for x = 0, thisArmy.leader.characterRecord.ancNum - 1 do
                                            local anc = thisArmy.leader.characterRecord:getAncillary(x)
                                            if anc ~= nil then
                                                if anc.transferable == true and anc.isUnique == false then
                                                    --print("check 3")
                                                    --if not anc:isCultureExcluded(eur_player_faction.cultureID) then
                                                        --print("check 4")
                                                        table.insert(alt_loot_anc, anc)
                                                   -- end
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                
                                for j = 0, thisArmy.numOfUnits - 1 do
                                    local un = thisArmy:getUnit(j)
                                    if un.eduEntry.category ~= 4 then
                                        spoils_loot = spoils_loot + un.eduEntry.upkeepCost
                                        
                                        if GARRISON_TRACK[thisArmy.faction.name] then
                                            for settName, settData in pairs(GARRISON_TRACK[thisArmy.faction.name]) do
                                                for tierIndex, tierData in ipairs(settData) do
                                                    for g = 1, #tierData do
                                                        local slotKey = tierIndex .. "_" .. g
                                                        if not matchedSlots[slotKey] then
                                                            if not checkedalready[j] then
                                                                if un.eduEntry ~= nil then
                                                                    if tierData[g].alias == un.alias then
                                                                        tierData[g].pre_battle = true
                                                                        matchedSlots[slotKey] = true
                                                                        checkedalready[j] = true
                                                                        pre_battle_faction = thisArmy.faction.name
                                                                        if not tableContains(pre_battle_garrison, un.alias) then
                                                                            table.insert(pre_battle_garrison, un.alias)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        
                                        print("Adding upkeep: " .. tostring(spoils_loot))
                                    end
                                end
                            end
                        end
                    end
                end
                k = k + 1
            until thisSide.armies[k] == nil
        end
    end
end

function spoils.getBattleOutcome()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."getBattleOutcome");
	end
    if not eur_gameData then return end

    local thisBattle, battleList = eur_gameData.battleStruct, "Function: getBattleData()"
    for i = 1, thisBattle.sidesNum, 1 do
        local thisSide = thisBattle.sides[i]
        if thisSide.armies[1] ~= nil then

            local k = 1
            repeat
                local thisArmy = thisSide.armies[k].army
                if thisArmy ~= nil then

                    if thisArmy.faction.isPlayerControlled == 1 then

                        if thisSide.wonBattle == 0 then
                            --print("Battle lost")
                            battles_lost = (battles_lost+1)
                            lost_battle = true
                            return true
                        else
                            victory_type = thisSide.battleSuccess
                        end
                    else
                        --
                    end
                end
                k = k + 1
            until thisSide.armies[k] == nil

        end
    end
end

function spoils.getBattleOutcomeWin()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."getBattleOutcomeWin");
	end
    if not eur_gameData then return end
    local thisBattle, battleList = eur_gameData.battleStruct, "Function: getBattleData()"
    for i = 1, thisBattle.sidesNum, 1 do
        local thisSide = thisBattle.sides[i]
        if thisSide.armies[1] ~= nil then
            local k = 1
            repeat
                local thisArmy = thisSide.armies[k].army
                if thisArmy ~= nil then
                    if thisArmy.faction.isPlayerControlled == 1 then
                        for y = 0, thisSide.battleArmyNum - 1 do
                            local battleArmy = thisSide:getBattleArmy(y)
                            if battleArmy.army.faction == eur_player_faction then
                                for x = 0, battleArmy.unitCount - 1 do
                                    local battleUnit = battleArmy:getBattleUnit(x)
                                    if battleUnit ~= nil then
                                        if battleUnit.unit ~= nil then
                                            if battleUnit.isGeneral == 0 then
                                                if not battleUnit.unit.dead then
                                                    if battleUnit.unit.eduEntry ~= nil then
                                                        if battleUnit.unit.eduEntry.category == 1 then
                                                            if battleUnit.expGained ~= nil then
                                                                if battleUnit.expGained > 0 then
                                                                    if math.random(1,100) > 50 then
                                                                        battleUnit.unit:setParams(battleUnit.expStart+1,battleUnit.unit.armourLVL,battleUnit.unit.weaponLVL);
                                                                    else
                                                                        battleUnit.unit:setParams(battleUnit.expStart+1,battleUnit.unit.armourLVL,battleUnit.unit.weaponLVL);
                                                                    end
                                                                else
                                                                    battleUnit.unit:setParams(battleUnit.expStart,battleUnit.unit.armourLVL,battleUnit.unit.weaponLVL);
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
                        if thisSide.isDefender == false then
                            if thisSide.wonBattle == 2 then
                                --print("Battle won")
                                victory_type = thisSide.battleSuccess
                                won_battle = true
                                won_battle_alt = true
                                local battleArmy = thisSide:getBattleArmy(0)
                                if battleArmy ~= nil then
                                    if battleArmy.character ~= nil then
                                        if battleArmy.character.characterType == 7 then
                                            if battleArmy.character.characterRecord ~= nil then
                                                local name = battleArmy.character.characterRecord.shortName..tostring(battleArmy.character.characterRecord.label)
                                                if persistent_gen_list[name] ~= nil then
                                                    local kills_clamped = battleArmy.generalNumKillsBattle
                                                    if kills_clamped > 200 then
                                                        kills_clamped = 200
                                                    end
                                                    --print("adding kills ", kills_clamped)
                                                    persistent_gen_list[name].battle_kills = persistent_gen_list[name].battle_kills + kills_clamped
                                                    persistent_gen_list[name].battle_won = persistent_gen_list[name].battle_won + 1
                                                end
                                            end
                                        end
                                    end
                                    alt_loot_units = {}
                                    for x = 0, battleArmy.unitCount - 1 do
                                        local battleUnit = battleArmy:getBattleUnit(x)
                                        if battleUnit ~= nil then
                                            if battleUnit.isGeneral == 0 then
                                                if battleUnit.unit.eduEntry ~= nil then
                                                    if battleUnit.unit.eduEntry.category == 0 then
                                                        table.insert(alt_loot_units, {unit = battleUnit.unit, kills = battleUnit.soldiersKilled, caught =  battleUnit.prisonersCaught, expgain = battleUnit.expGained})
                                                    end
                                                end
                                            else
                                                if battleUnit.unit ~= nil then
                                                    if battleUnit.unit.character ~= nil then
                                                        if battleUnit.unit.character.characterRecord ~= nil then
                                                            local name = battleUnit.unit.character.characterRecord.shortName..tostring(battleUnit.unit.character.characterRecord.label)
                                                            if persistent_gen_list[name] ~= nil then
                                                                local kills_clamped = battleUnit.soldiersKilled
                                                                if kills_clamped > 200 then
                                                                    kills_clamped = 200
                                                                end
                                                                --print("adding kills ", kills_clamped)
                                                                persistent_gen_list[name].battle_kills = persistent_gen_list[name].battle_kills + kills_clamped
                                                                
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
                    else
                        --print("ai army")
                        local checkedalready = {}
                        local matchedSlots = {}  -- before the pairs loop
                        for j = 0, thisArmy.numOfUnits - 1 do
                            local un = thisArmy:getUnit(j)
                            if un ~= nil then
                                --print("unit found")
                                if not un.dead then
                                    --print("unit alive")
                                    --print(un.alias)
                                    if string.find(un.alias, "Garrison") then
                                        --print("found garrison unit")
                                        un.movePoints = 0
                                        local settlement = thisArmy:findInSettlement()
                                        if settlement ~= nil then
                                            --print("found garrison unit in sett")
                                            if GARRISON_TRACK[thisArmy.faction.name] ~= nil then
                                                --print("found fac")
                                                if GARRISON_TRACK[thisArmy.faction.name][settlement.name] ~= nil then
                                                    --print(settlement.name)
                                                   -- print(un.ID)
                                                    
                                                   for tierIndex, tierData in ipairs(GARRISON_TRACK[thisArmy.faction.name][settlement.name]) do
                                                    for g = 1, #tierData do
                                                        local slotKey = tierIndex .. "_" .. g
                                                        if not matchedSlots[slotKey] then
                                                            if not checkedalready[j] then
                                                                if un.eduEntry ~= nil then
                                                                    if tierData[g].alias == un.alias then
                                                                        print("found garrison unit "..un.eduEntry.eduType.." setting to "..tostring(un.soldierCountStratMap))
                                                                        tierData[g].count = un.soldierCountStratMap
                                                                        tierData[g].post_battle = true
                                                                        matchedSlots[slotKey] = true
                                                                        checkedalready[j] = true
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                                end
                                            end
                                        else
                                            if GARRISON_TRACK[thisArmy.faction.name] ~= nil then
                                                

                                                for settName, settData in pairs(GARRISON_TRACK[thisArmy.faction.name]) do
                                                    for tierIndex, tierData in ipairs(settData) do
                                                        for g = 1, #tierData do
                                                            local slotKey = tierIndex .. "_" .. g
                                                            if not matchedSlots[slotKey] then
                                                                if not checkedalready[j] then
                                                                    if un.eduEntry ~= nil then
                                                                        if tierData[g].alias == un.alias then
                                                                            print("found garrison unit "..un.eduEntry.eduType.." setting to "..tostring(un.soldierCountStratMap))
                                                                            tierData[g].count = un.soldierCountStratMap
                                                                            tierData[g].post_battle = true
                                                                            matchedSlots[slotKey] = true
                                                                            checkedalready[j] = true
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
                                else
                                    print("unit dead")
                                    if string.find(un.alias, "Garrison") then
                                        print("found garrison unit")
                                        local settlement = thisArmy:findInSettlement()
                                        if settlement ~= nil then
                                            print("found garrison unit in sett")
                                            if GARRISON_TRACK[thisArmy.faction.name] ~= nil then
                                                print("found fac")
                                                if GARRISON_TRACK[thisArmy.faction.name][settlement.name] ~= nil then
                                                    print(settlement.name)
                                                    print(un.ID)
                                                   
                                                    for tierIndex, tierData in ipairs(GARRISON_TRACK[thisArmy.faction.name][settlement.name]) do
                                                        for g = 1, #tierData do
                                                            local slotKey = tierIndex .. "_" .. g
                                                            if not matchedSlots[slotKey] then
                                                                if not checkedalready[j] then
                                                                    if un.eduEntry ~= nil then
                                                                        if tierData[g].alias == un.alias then
                                                                            print("found garrison unit "..un.eduEntry.eduType.." setting to "..tostring(un.soldierCountStratMap))
                                                                            tierData[g].count = un.soldierCountStratMap
                                                                            tierData[g].post_battle = true
                                                                            matchedSlots[slotKey] = true
                                                                            checkedalready[j] = true
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        else
                                            if GARRISON_TRACK[thisArmy.faction.name] ~= nil then
                                                
                                                
                                                for settName, settData in pairs(GARRISON_TRACK[thisArmy.faction.name]) do
                                                    for tierIndex, tierData in ipairs(settData) do
                                                        for g = 1, #tierData do
                                                            local slotKey = tierIndex .. "_" .. g
                                                            if not matchedSlots[slotKey] then
                                                                if not checkedalready[j] then
                                                                    if un.eduEntry ~= nil then
                                                                        if tierData[g].alias == un.alias then
                                                                            print("found garrison unit "..un.eduEntry.eduType.." setting to "..tostring(un.soldierCountStratMap))
                                                                            tierData[g].count = un.soldierCountStratMap
                                                                            tierData[g].post_battle = true
                                                                            matchedSlots[slotKey] = true
                                                                            checkedalready[j] = true
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
                k = k + 1
            until thisSide.armies[k] == nil
        end
    end
    pre_battle_faction = ""
    pre_battle_garrison = {}
end

return spoils