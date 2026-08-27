
local CONFED_FACTIONS = {
    ["ireland"] = {
        counter = "elven_union",
        value = 1,
        run_once = "elven_confed_units",
        old = {"Woodland Scouts","Woodland Spearmen","Woodland Warriors",},
        new = {"Lorien Archers","Lorien Warders","Lorien Sentries",},
    },
    ["mongols"] = {
        counter = "elven_union",
        value = 1,
        run_once = "elven_confed_units",
        old = {"Lorien Archers","Lorien Warders","Lorien Sentries",},
        new = {"Woodland Scouts","Woodland Spearmen","Woodland Warriors",},
    },
    ["denmark"] = {
        counter = "konkoe_union",
        value = 1,
        run_once = "konkoe_confed_units",
        old = {"Lindar Guards","Lindar Mariners","Lindon Longspears","Lindar Bowmen","Sword Quendi","Spear Quendi","Bow Quendi","Mounted Quendi",},
        new = {"Eregion Lindar Guards","Eregion Lindar Mariners","Eregion Lindon Longspears","Eregion Lindar Bowmen","Eregion Sword Quendi","Eregion Spear Quendi","Eregion Bow Quendi","Eregion Mounted Quendi",},
    },
    ["saxons"] = {
        counter = "konkoe_union",
        value = 1,
        run_once = "konkoe_confed_units",
        old = {"Lindar Guards","Lindar Mariners","Lindon Longspears","Lindar Bowmen","Sword Quendi","Spear Quendi","Bow Quendi","Mounted Quendi",},
        new = {"Eregion Lindar Guards","Eregion Lindar Mariners","Eregion Lindon Longspears","Eregion Lindar Bowmen","Eregion Sword Quendi","Eregion Spear Quendi","Eregion Bow Quendi","Eregion Mounted Quendi",},
    },
}

SWAP_GARRISON = {
    ["milan"] = {
        new = {"Eorling Spearmen", "Eorling Spearmen", "Eorling Archers"}
    },
    ["sicily"] = {
        new = {"Territorial Guardsmen", "Territorial Guardsmen", "Territorial Watchmen"}
    },
    ["turks"] = {
        new = {"Dunedain Wardens", "Dunedain Wardens", "Woodland Hunters"}
    },
    ["normans"] = {
        new = {"Blue Crag Goblin Spears", "Blue Crag Goblin Spears", "Blue Crag Slingers"}
    },
    ["russia"] = {
        new = {"Belegaer Footmen", "Belegaer Footmen", "Belegaer Archers"}
    },
    ["scotland"] = {
        new = {"Dalian Swordsmen", "Dalian Swordsmen", "Dalian Longbowmen"}
    },
    ["byzantium"] = {
        new = {"Thorn Bladesmen", "Thorn Bladesmen", "Thorn Crossbowmen"}
    },
    ["timurids"] = {
        new = {"Woodman Defenders", "Woodman Defenders", "Vale Archers"}
    },
    ["portugal"] = {
        new = {"Gram Marauders", "Gram Trackers", "Gram Trackers"}
    },
    ["aztecs"] = {
        new = {"Clan Spearmen", "Clan Spearmen", "Clan Hunters"}
    },
    ["teutonic_order"] = {
        new = {"Faolan Borderguard", "Faolan Borderguard", "Faolan Borderguard"}
    },
    ["spain"] = {
        new = {"Haradrim Spearmen", "Haradrim Spearmen", "Haradrim Archers"}
    },
    ["khand"] = {
        new = {"Steppe Tribesmen", "Steppe Tribesmen", "Steppe Tribesmen"}
    },
    ["venice"] = {
        new = {"Rhunnic Spears", "Rhunnic Spears", "Rhunnic Bowmen"}
    },
    ["norway"] = {
        new = {"Khazad Sentries", "Khazad Sentries", "Khazad Sentries"}
    },
    ["hungary"] = {
        new = {"Ered Luin Militia", "Ered Luin Militia Pikemen", "Ered Luin Scouts"}
    },
    ["moors"] = {
        new = {"Erebor Infantry", "Erebor Infantry", "Erebor Axethrowers"}
    },
    ["mongols"] = {
        new = {"Woodland Spearmen", "Woodland Spearmen", "Woodland Scouts"}
    },
    ["ireland"] = {
        new = {"Lorien Warders", "Lorien Warders", "Lorien Archers"}
    },
    ["denmark"] = {
        new = {"Lindar Guards", "Lindar Guards", "Lindar Bowmen"}
    },
    ["saxons"] = {
        new = {"Spear Quendi", "Spear Quendi", "Bow Quendi"}
    },
    ["england"] = {
        new = {"Orc Band", "Orc Band", "Orc Band"}
    },
    ["poland"] = {
        new = {"Dol Guldur Host", "Dol Guldur Host", "Dol Guldur Scouts"}
    },
    ["hre"] = {
        new = {"Goblin Band", "Goblin Band", "Goblin Archers"}
    },
    ["gundabad"] = {
        new = {"Snow-Orc Spearmen", "Snow-Orc Spearmen", "Snow-Orc Scouts"}
    },
    ["france"] = {
        new = {"Uruk-hai Raiders", "Uruk-hai Raiders", "Uruk-hai Archers"}
    },
    ["slave"] = {
        new = {"Bandits", "Bandits", "Bandits"}
    },
    ["egypt"] = {
        new = {"Gathring Shieldbearers","Gathring Shieldbearers", "Daerbor Archers"}
    },
}

function eurSwapUnitsOnTrade(sett)
    if sett == nil then return end
    local settlement = eur_sMap:getSettlement(sett)
    if settlement == nil then return end
    if settlement.name == "Eregion" or settlement.name == "Enedwaith" then return end
    if checkCounter("eregion_is_spawning") then return end
    if checkCounter("faction_spawning") then return end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."eurSwapUnitsOnTrade");
	end
    local faction_name = settlement.ownerFaction.name
    if not SWAP_GARRISON[faction_name] then return end
    if settlement.army then
        for j = 0, settlement.army.numOfUnits - 1 do
            local rand = math.random(1, 3)
            local un = settlement.army:getUnit(j)
            local new_edu = M2TWEOPDU.getEduEntryByType(SWAP_GARRISON[faction_name].new[rand])
            if new_edu then
                un.eduEntry = new_edu
                un.soldierCountStratMap = un.soldierCountStratMapMax
            end
        end
    else
        local army = stratmap.game.createArmyInSettlement(settlement)
        local rand1 = math.random(1, 3)
        local rand2 = math.random(1, 3)
        army:createUnit(SWAP_GARRISON[faction_name].new[rand1], 0, 0, 0)
        army:createUnit(SWAP_GARRISON[faction_name].new[rand2], 0, 0, 0)
    end
end

function SwapUnitsOnConfed(faction)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."SwapUnitsOnConfed");
	end
    local uiList = ""
    local fac_name = faction.name
    if not CONFED_FACTIONS[fac_name] then return end
    local isExist, counterValue = stratmap.game.getScriptCounter(CONFED_FACTIONS[fac_name].counter)
    if counterValue ~= CONFED_FACTIONS[fac_name].value then return end
    if not checkCounter(CONFED_FACTIONS[fac_name].run_once) then
        stratmap.game.setScriptCounter(CONFED_FACTIONS[fac_name].run_once, 1)
        local unitSize = 2.5--getUnitSizeMult()
        for i = 0, faction.stacksNum - 1 do
            local army = faction:getStack(i)
            for j = 0, army.numOfUnits - 1 do
                local un = army:getUnit(j)
                if un.eduEntry ~= nil then
                    for x = 1, #CONFED_FACTIONS[fac_name].old do
                        if un.eduEntry.eduType == CONFED_FACTIONS[fac_name].old[x] then
                            local eduEntry = M2TWEOPDU.getEduEntryByType(CONFED_FACTIONS[fac_name].new[x])
                                if eduEntry ~= nil then
                                uiList =
                                    uiList ..
                                    "\n" ..
                                        "Unit: " .. un.eduEntry.eduType .. " replaced by " .. CONFED_FACTIONS[fac_name].new[x]
                                un.eduEntry = M2TWEOPDU.getEduEntryByType(CONFED_FACTIONS[fac_name].new[x])
                                un.soldierCountStratMap = math.min(un.soldierCountStratMap, un.eduEntry.soldierCount * unitSize)
                            end
                        end
                    end
                end
            end
        end
        if uiList ~= "\n" then
            stratmap.game.historicEvent("settlement_taken", "Units Retrained", "Now that our realms have united, our militia forces have undergone retaining and refitting. \n" .. uiList)
        end
    end
end
--[[
---@param eventData eventTrigger 
function onSettlementTurnStart(eventData)
    local settlement = eventData.settlement
    eurUnitSwap.killGarrison(settlement, nil)
    if settlement.siegesNum ~= 0 then
        eurUnitSwap.spawnGarrisons(settlement)
    end
end


---@param eventData eventTrigger 
function onSettlementTurnEnd(eventData)
    local settlement = eventData.settlement
    if settlement.siegesNum == 0 then
        eurUnitSwap.killGarrison(settlement, nil)
    end
end

]]
---@param settlement settlementStruct 
function spawnGarrisons(settlement)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."spawnGarrisons");
	end
    local tag = 'Settlement Garrison'
    local rand1 = math.random(1, 3)
    local rand2 = math.random(1, 3)
    if not SWAP_GARRISON[settlement.ownerFaction.name] then return end
    --addGarrisonUnit(SWAP_GARRISON[settlement.ownerFaction.name].new[rand1],tag,settlement,1,1,1,1);
    --addGarrisonUnit(SWAP_GARRISON[settlement.ownerFaction.name].new[rand2],tag,settlement,1,1,1,1);
    --example for other faciton
    --if settlement.ownerFaction.name == 'otherfaction' then
    --    local tag = 'otherfaction Garrison'
    --    addGarrisonUnit('otherfaction Militia',tag,settlement,3,1,1,1);
    --    addGarrisonUnit('otherfaction Heavy Infantry',tag,settlement,2,1,1,1);
    --end
end