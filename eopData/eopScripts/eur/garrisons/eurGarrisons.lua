

FACTION_PLAYER = {
	["aztecs"] = false,
	["byzantium"] = false,
	["denmark"] = false,
	["england"] = false,
	["france"] = false,
	["gundabad"] = false,
	["hre"] = false,
	["hungary"] = false,
	["ireland"] = false,
	["khand"] = false,
	["milan"] = false,
	["mongols"] = false,
	["moors"] = false,
	["normans"] = false,
	["norway"] = false,
	["poland"] = false,
	["portugal"] = false,
	["russia"] = false,
	["saxons"] = false,
	["scotland"] = false,
	["sicily"] = false,
	["spain"] = false,
	["teutonic_order"] = false,
	["timurids"] = false,
	["turks"] = false,
	["venice"] = false,
    ["null"] = false,
}

GARRISON_TRACK = {}

function addAiGarrison(fac)
    if to_log then
        M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."addAiGarrison");
    end
    if fac == nil then return end
    local faction = eur_campaign:getFaction(fac)
    if faction == nil then return end
    if not game_options.garrisons then return end
    if checkCounter("garrison_skip") then return end

    local facName = faction.name
    if facName == "slave" then return end
    if not SETT_GARRISONS[facName] then return end
    if GARRISON_TRACK[facName] == nil then 
        GARRISON_TRACK[facName] = {}
    end

    for k, v in pairs(SETT_GARRISONS[facName]) do
        local settlement = eur_sMap:getSettlement(k)
        if settlement ~= nil then
            if settlement.ownerFaction.name == facName then
                if GARRISON_TRACK[facName][settlement.name] == nil then 
                    GARRISON_TRACK[facName][settlement.name] = {}
                end
                
                local currentGarrisonConfig = SETT_GARRISONS[facName][k][eur_localFactionName] or SETT_GARRISONS[facName][k]["null"]
                local army = settlement.army

                if army == nil and currentGarrisonConfig then
                    army = stratmap.game.createArmyInSettlement(settlement)
                end

                if army ~= nil and currentGarrisonConfig then
                    local trackIndex = 1
                    for i = 1, #currentGarrisonConfig do
                        for j = 1, currentGarrisonConfig[i][2] do
                            if settlement.army.numOfUnits < 20 then
                                if army:findInSettlement() then
                                    local unitData = currentGarrisonConfig[i]
                                    logHelper("creating unit")
                                    local new_unit = army:createUnit(
                                        unitData[1], unitData[3], unitData[4], unitData[5]
                                    )
                                    if new_unit then
                                        new_unit.alias = settlement.localizedName .. " Garrison "..to_roman(i).."-"..to_roman(j)
                                        if GARRISON_TRACK[facName][settlement.name][i] == nil then
                                            GARRISON_TRACK[facName][settlement.name][i] = {}
                                        end
                                        if GARRISON_TRACK[facName][settlement.name][i][j] == nil then
                                            GARRISON_TRACK[facName][settlement.name][i][j] = {}
                                            GARRISON_TRACK[facName][settlement.name][i][j].ID = new_unit.ID
                                            GARRISON_TRACK[facName][settlement.name][i][j].alias = new_unit.alias
                                            GARRISON_TRACK[facName][settlement.name][i][j].count = new_unit.soldierCountStratMap
                                            GARRISON_TRACK[facName][settlement.name][i][j].pre_battle = false
                                            GARRISON_TRACK[facName][settlement.name][i][j].post_battle = false
                                        else
                                            local track = GARRISON_TRACK[facName][settlement.name][i][j]
                                            local new_count = track.count + math.ceil(new_unit.soldierCountStratMapMax / 5)
                                            track.ID = new_unit.ID
                                            if track.pre_battle and not track.post_battle then
                                                new_unit.soldierCountStratMap = math.ceil(new_unit.soldierCountStratMapMax / 5)
                                                track.count = new_unit.soldierCountStratMap
                                            else
                                                new_unit.soldierCountStratMap = track.count
                                                if new_count < new_unit.soldierCountStratMapMax then
                                                    new_unit.soldierCountStratMap = new_count
                                                else
                                                    new_unit.soldierCountStratMap = new_unit.soldierCountStratMapMax
                                                end
                                                track.count = new_unit.soldierCountStratMap
                                            end
                                            track.pre_battle = false
                                            track.post_battle = false
                                        end
                                        trackIndex = trackIndex + 1
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

function removeAiGarrison(faction, start)
    if not game_options.garrisons then return end
    if not faction or not faction.name then return end
    if not SETT_GARRISONS or not SETT_GARRISONS[faction.name] then return end

    if to_log then
        M2TWEOP.logGame("EUR SCRIPT: " .. tostring(os.clock()) .. "removeAiGarrison")
    end

    local GARRISON_KILL = {}

    local function collectFromArmy(army)
        if not army then return end
        local num_unit = tonumber(army.numOfUnits) or 0
        if num_unit < 1 then return end

        for i = 0, num_unit - 1 do
            local stack_unit = army.getUnit and army:getUnit(i) or nil
            if stack_unit
                and not stack_unit.dead
                and stack_unit.alias
                and type(stack_unit.alias) == "string"
                and string.find(stack_unit.alias, "Garrison")
            then
                -- Never kill a unit that has a character attached (bodyguard / general).
                -- That is the main path that can produce null characters.
                if not stack_unit.character then
                    GARRISON_KILL[stack_unit] = stack_unit
                end
            end
        end
    end

    -- Settlement armies
    local sett_num = tonumber(faction.settlementsNum) or 0
    if sett_num > 0 then
        for x = 0, sett_num - 1 do
            local settlement = faction.getSettlement and faction:getSettlement(x) or nil
            if settlement then
                local underSiegeStart = (tonumber(settlement.siegesNum) or 0) > 0 and start
                if not underSiegeStart then
                    collectFromArmy(settlement.army)
                end
            end
        end
    end

    -- Field armies (not in a settlement)
    local stacks_num = tonumber(faction.stacksNum) or 0
    if stacks_num > 0 then
        for j = 0, stacks_num - 1 do
            local army = faction.getArmy and faction:getArmy(j) or nil
            if army then
                local inSett = false
                if army.findInSettlement then
                    local ok, result = pcall(function() return army:findInSettlement() end)
                    inSett = ok and result
                end
                if not inSett then
                    collectFromArmy(army)
                end
            end
        end
    end

    -- Safe deletes
    for _, unit in pairs(GARRISON_KILL) do
        if unit and not unit.dead then
            -- Re-check character in case state changed
            if not unit.character then
                logHelper("deleting unit")
                local ok, err = pcall(function() unit:kill() end)
                if not ok and to_log then
                    M2TWEOP.logGame("EUR SCRIPT: removeAiGarrison kill failed: " .. tostring(err))
                end
            end
        end
    end

    if to_log then
        M2TWEOP.logGame("EUR SCRIPT: " .. tostring(os.clock()) .. "Function End")
    end
end

function clampGarrison(character)
    if to_log then M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."clampGarrison") end
    if character == nil or character.settlement == nil or character.settlement.army == nil then return end
    
    local army = character.settlement.army
    for i = 0, army.numOfUnits - 1 do
        local unit = army:getUnit(i)
        if unit ~= nil and not unit.dead and unit.eduEntry ~= nil then 
            if string.find(unit.eduEntry.eduType, "Garrison") then
                unit.movePoints = 0
            end
        end
    end
    if to_log then M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End") end
end

function clampGarrisonSett(settlement)
    if to_log then M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."clampGarrisonSett") end
    if settlement == nil or settlement.army == nil then return end
    
    local army = settlement.army
    for i = 0, army.numOfUnits - 1 do
        local unit = army:getUnit(i)
        if unit ~= nil and not unit.dead and unit.eduEntry ~= nil then 
            if string.find(unit.eduEntry.eduType, "Garrison") then
                unit.movePoints = 0
            end
        end
    end
    if to_log then M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End") end
end

function resetPostBattleGarrison()
    if to_log then
        M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."resetPostBattleGarrison");
    end
    if pre_battle_faction == "" or #pre_battle_garrison == 0 then return end
    if GARRISON_TRACK[pre_battle_faction] == nil then return end

    for j = 1, #pre_battle_garrison do
        for settName, settData in pairs(GARRISON_TRACK[pre_battle_faction]) do
            -- Use pairs here instead of ipairs in case structural indexes are disjointed
            for tierIndex, tierData in pairs(settData) do
                for g = 1, #tierData do
                    if tierData[g].alias == pre_battle_garrison[j] then
                        tierData[g].post_battle = true
                    end
                end
            end
        end
    end
    pre_battle_faction = ""
    pre_battle_garrison = {}
    if to_log then
        M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
    end
end

function legendaryGarrisons()
	SETT_GARRISONS["sicily"] = {
		["Anorien"] = {
			["null"] = {
				{ "Fountain Guard Garrison", 2, 3, 1, 1 },
				{ "Lossarnach Axemen Garrison", 2, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 3, 3, 1, 1 },
			},
			["england"] = {
				{ "Fountain Guard Garrison", 2, 3, 1, 1 },
				{ "Lossarnach Axemen Garrison", 2, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 3, 3, 1, 1 },
			},
			["spain"] = {
				{ "Fountain Guard Garrison", 2, 3, 1, 1 },
				{ "Lossarnach Axemen Garrison", 2, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 3, 3, 1, 1 },
			},
		},
		["Anorien_Fields"] = {
			["null"] = {
				{ "Gondor Garrison Infantry", 4, 3, 1, 1 },
			},
			["england"] = {
				{ "Gondor Garrison Infantry", 4, 3, 1, 1 },
			},
			["spain"] = {
				{ "Gondor Garrison Infantry", 4, 3, 1, 1 },
			},
		},
		["Cair_Andros"] = {
			["null"] = {
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 2, 3, 1, 1 },
			},
			["england"] = {
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
			["spain"] = {
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
		},
		["West_Osgiliath"] = {
			["null"] = {
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
			},
			["spain"] = {
				{ "Guards of Osgiliath Garrison", 1, 3, 1, 1 },
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
			["england"] = {
				{ "Guards of Osgiliath Garrison", 1, 3, 1, 1 },
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
		},
		["West_Lebennin"] = {
			["null"] = {
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 2, 3, 1, 1 },
			},
			["spain"] = {
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 2, 3, 1, 1 },
			},
			["russia"] = {
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 2, 3, 1, 1 },
			},
		},
		["Lebennin"] = {
			["null"] = {
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 3, 3, 1, 1 },
			},
			["spain"] = {
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 2, 3, 1, 1 },
			},
			["russia"] = {
				{ "Gondor Garrison Infantry", 3, 3, 1, 1 },
				{ "Gondor Garrison Archers", 2, 3, 1, 1 },
			},
		},
		["East_Osgiliath"] = {
			["null"] = {
				{ "Guards of Osgiliath Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
			["spain"] = {
				{ "Guards of Osgiliath Garrison", 1, 3, 1, 1 },
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
			["england"] = {
				{ "Guards of Osgiliath Garrison", 1, 3, 1, 1 },
				{ "Osgiliath Veterans Garrison", 1, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
		},
		["Lossarnach"] = {
			["null"] = {
				{ "Lossarnach Axemen Garrison", 2, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
			["england"] = {
				{ "Lossarnach Axemen Garrison", 2, 3, 1, 1 },
				{ "Gondor Garrison Infantry", 2, 3, 1, 1 },
				{ "Gondor Garrison Archers", 1, 3, 1, 1 },
			},
		},
	}
end
