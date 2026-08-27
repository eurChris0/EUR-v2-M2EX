-- third_age/battleAiAssist.lua
-- Rebuilt from safe, directly supported battle AI controls only.
-- All comments are in English. Logs are controlled by BATTLE_AI_ASSIST_ENABLE_LOGS.

local BATTLE_AI_ASSIST_ENABLE_LOGS = true

-- =========================================================
-- CONFIG: ORDER TIMING
-- =========================================================
local BATTLE_AI_ASSIST_TICK_INTERVAL = 30
local BATTLE_AI_ASSIST_UNIT_ORDER_COOLDOWN_TICKS = 180
local BATTLE_AI_ASSIST_GTA_COOLDOWN_TICKS = 600
local BATTLE_AI_ASSIST_ATTACK_ARC = 360
local BATTLE_AI_ASSIST_RUN_ORDERS = true
-- third_age/battleAiAssist.lua
-- Rebuilt from safe, directly supported battle AI controls only.
-- All comments are in English. Logs are controlled by BATTLE_AI_ASSIST_ENABLE_LOGS.

local BATTLE_AI_ASSIST_ENABLE_LOGS = true

-- =========================================================
-- CONFIG: ORDER TIMING
-- =========================================================
local BATTLE_AI_ASSIST_TICK_INTERVAL = 30
local BATTLE_AI_ASSIST_UNIT_ORDER_COOLDOWN_TICKS = 180
local BATTLE_AI_ASSIST_GTA_COOLDOWN_TICKS = 600
local BATTLE_AI_ASSIST_ATTACK_ARC = 360
local BATTLE_AI_ASSIST_RUN_ORDERS = true

-- =========================================================
-- CONFIG: PLAZA FALLBACK AFTER FULL PERIMETER BREACH
-- =========================================================
local BATTLE_AI_ASSIST_PLAZA_FALLBACK_ENABLE = true
local BATTLE_AI_ASSIST_PLAZA_IDLE_LIMIT = 3
local BATTLE_AI_ASSIST_PLAZA_ORDER_COOLDOWN_TICKS = 900

-- =========================================================
-- CONFIG: ORIGINAL BATTLE SCRIPT BEHAVIORS RESTORED
-- =========================================================
local BATTLE_AI_ASSIST_DEPLOY_STAKES_ENABLE = true
local BATTLE_AI_ASSIST_SPECIAL_ABILITY_ENABLE = true
local BATTLE_AI_ASSIST_GENERAL_DEFENSE_ENABLE = true

-- Original waits were 20 / 25 / 30 / 35 battle_wait steps.
-- In Lua this is represented as battle ticks, with the same editable thresholds.
local GENERAL_DEFENSE_WAIT_TICKS_BY_ENEMY_UNIT_COUNT = {
    lessThan7 = 600,
    from7To11 = 750,
    from12To15 = 900,
    from16Plus = 1050,
}

local GENERAL_DEFENSE_RELEASE_ENEMY_RADIUS = 60
local SPECIAL_ABILITY_ARM_COUNTER_START = 3
local SPECIAL_ABILITY_USE_COUNTER = 6
local SPECIAL_ABILITY_MAX_UNITS = 3
-- =========================================================
-- CONFIG: HERO ABILITY XML LIMITS
-- =========================================================
local HERO_ABILITY_XML_LIMITS_ENABLE = true
local HERO_ABILITY_XML_SECONDS_TO_TICKS = 10
local HERO_ABILITY_XML_DEFAULT_ACTIVATIONS = 1
local HERO_ABILITY_XML_DEFAULT_COOLDOWN_SECONDS = 0
local HERO_ABILITY_XML_BLOCK_IF_ABILITY_NOT_FOUND = true
-- =========================================================
-- CONFIG: UNITS THAT MUST ATTACK GATE/WALL IN SIEGE ATTACK
-- =========================================================
local FORCE_GATE_ATTACK_UNITS = {

}

-- 50 = 50% chance to choose gate / 50% chance to choose wall when both exist.
local FORCE_GATE_ATTACK_GATE_CHANCE_PERCENT = 50
local FORCE_GATE_ATTACK_EMPTY_AMMO_MELEE_ENABLE = true
local FORCE_GATE_ATTACK_MELEE_AFTER_BREACH_ENABLE = true
local FORCE_GATE_ATTACK_MELEE_AFTER_BREACH_DELAY_TICKS = 1200 -- give 120 seconds to other units the chance to break other walls/gates too after the first one is breached, then they will start attacking units. but regular units will enter the first gate/wall once its breached.
local FORCE_GATE_ATTACK_GENERAL_PRIORITY_ENABLE = true
local REGULAR_UNITS_ATTACK_AFTER_BREACH_ENABLE = true


-- Siege category attackers also attack gate/wall, except these types.
local ATTACKER_SIEGE_CATEGORY_EXCLUDE_TYPES = {

}

-- =========================================================
-- CONFIG: DEFENDER UNITS BY SETTLEMENT LEVEL
-- =========================================================
-- These unit types attack the nearest invading unit when they are on the settlement side.
-- Use allLevels = true to allow every settlement level.
-- Or list exact settlement levels as [level] = true.
local DEFENDER_UNITS_BY_SETTLEMENT_LEVEL = {

}

-- =========================================================
-- CONFIG: SETTLEMENT-SPECIFIC AI OVERRIDES
-- =========================================================
-- These rules override only conflicting generic behavior in the listed settlements.
-- Generic behavior not mentioned here continues to work normally.
local SETTLEMENT_AI_OVERRIDES = {
    ["Gorgoroth"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Lune-land"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Black_Gate"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Far-Southern-Orocarni"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Grey-Mountains"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Erebor"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["High-Pass"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Center-Northern-Orocarni"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Minas_Morgul"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Haradwaith_Estate"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Weather-Mines"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["North-West-Orocarni"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Center-Southern-Orocarni"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Nan-i-Naugrim"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Elven-Mirkwood"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderDefenderLevelUnitsHalt = true,
    },
    ["Misty-Mountains"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderSpecificHaltTypes = {
            ["Gondor Trebuchet"] = true,
            ["barrel_thrower"] = true,
            ["Arnor Trebuchet"] = true,
        },
    },
    ["Lower-Misty-Mountains"] = {
        attackerDefenderLevelUnitsGateOnly = true,
        attackerDefenderLevelUnitsHaltAfterGateDestroyed = true,
        attackerForceGateUnitsGateOnly = true,
        defenderSpecificHaltTypes = {
            ["Gondor Trebuchet"] = true,
            ["barrel_thrower"] = true,
            ["Arnor Trebuchet"] = true,
        },
    },
    ["Carn-Dum"] = {
        attackerTwoPerimeterGateLogic = true,
    },
    ["Iron-Hills"] = {
        attackerDefenderLevelUnitsHaltAfterAnyStructureDestroyed = true,
        defenderDefenderLevelUnitsHalt = true,
    },
}

local SETTLEMENT_RULE_EXCLUDED_TYPES = {

}

local SETTLEMENT_AI_COORDINATES = {
    ["Gorgoroth"] = { x = 290, y = 138 },
    ["Lune-land"] = { x = 56, y = 277 },
    ["Black_Gate"] = { x = 273, y = 149 },
    ["Far-Southern-Orocarni"] = { x = 394, y = 207 },
    ["Grey-Mountains"] = { x = 237, y = 298 },
    ["Erebor"] = { x = 292, y = 269 },
    ["High-Pass"] = { x = 207, y = 253 },
    ["Center-Northern-Orocarni"] = { x = 395, y = 251 },
    ["Minas_Morgul"] = { x = 273, y = 125 },
    ["Haradwaith_Estate"] = { x = 62, y = 306 },
    ["Weather-Mines"] = { x = 220, y = 301 },
    ["North-West-Orocarni"] = { x = 377, y = 265 },
    ["Center-Southern-Orocarni"] = { x = 396, y = 235 },
    ["Nan-i-Naugrim"] = { x = 51, y = 290 },
    ["Elven-Mirkwood"] = { x = 261, y = 271 },
    ["Misty-Mountains"] = { x = 180, y = 216 },
    ["Lower-Misty-Mountains"] = { x = 182, y = 216 },
    ["Iron-Hills"] = { x = 329, y = 271 },
    ["Carn-Dum"] = { x = 151, y = 307 },
}

local SETTLEMENT_AI_NAME_BY_COORD_KEY = {}
for settlementName, coords in pairs(SETTLEMENT_AI_COORDINATES) do
    if type(coords) == "table" and coords.x ~= nil and coords.y ~= nil then
        SETTLEMENT_AI_NAME_BY_COORD_KEY[tostring(coords.x) .. ":" .. tostring(coords.y)] = settlementName
    end
end

-- =========================================================
-- CONFIG: PROGRESSIVE PERIMETER ATTACKS
-- =========================================================
-- When enabled, settlements with 3 perimeters are handled progressively:
-- perimeter 1 first, then perimeter 2, then perimeter 3, then nearest enemy.
local THREE_PERIMETER_PROGRESSIVE_ATTACK_ENABLE = true

-- User-facing perimeters are 1 / 2 / 3. getPerimeter() uses zero-based indexes in the API.
local BATTLE_AI_ASSIST_PERIMETER_API_INDEX_OFFSET = -1

-- Carn-Dum second perimeter gate approach control.
-- The unit first moves to a point between itself and the gate, then attacks the gate.
local CARN_DUM_SECOND_GATE_APPROACH_DISTANCE_TILES = 9
local CARN_DUM_SECOND_GATE_ATTACK_DISTANCE_TILES = 10

-- Optional manual list. Leave empty to use automatic detection by perimeterCount == 3.
local THREE_PERIMETER_PROGRESSIVE_ATTACK_SETTLEMENTS = {
    -- ["Settlement-Internal-Name"] = true,
}

local M = {}

M._state = {
    battleTick = 0,
    conflictStarted = false,
    lastProcessTick = -999999,
    lastUnitOrderTickByKey = {},
    lastGtaOrderTickByKey = {},
    gateWallChoiceByUnitKey = {},
    deployStakesDoneBySide = {},
    specialAbilityCounterByUnitKey = {},
	heroAbilityXmlLoaded = false,
    heroAbilityXmlRulesByName = {},
    heroAbilityUsesByUnitKey = {},
    heroAbilityLastUseTickByUnitKey = {},
    specialAbilityArmed = false,
    generalDefenseBySide = {},
    gateWallBreachDetectedTick = nil,
    gateDestroyedDetected = false,
    structureDestroyedDetected = false,
    initialGateWallCheckDone = false,
    noInitialGateWallTargets = false,
    carnDumPerimeter1GateDestroyed = false,
    carnDumPerimeter2GateDestroyed = false,
    carnDumSecondGateApproachByUnitKey = {},
    progressivePerimeterDestroyedBySettlement = {},
    plazaIdleCountByUnitKey = {},
    plazaFallbackLastOrderTickBySide = {},
    forceGateUnitsMeleeAfterTick = nil,
    forceGateUnitsMeleeActive = false,
    lastEventData = nil,
}

local TAG = "[BattleAiAssist] "

local function appendFileLog(line)
    if not BATTLE_AI_ASSIST_ENABLE_LOGS then return end
    pcall(function()
        local path = "eop.log"
        if type(M2TWEOP) == "table" and type(M2TWEOP.getModPath) == "function" then
            local modPath = M2TWEOP.getModPath()
            if modPath and tostring(modPath) ~= "" then
                path = tostring(modPath) .. "/eop.log"
            end
        end
        local f = io.open(path, "a")
        if f then
            f:write(tostring(line) .. "\n")
            f:close()
        end
    end)
end

local function logi(msg)
--
end

local function safeCall(label, fn)
    if type(fn) ~= "function" then
        logi("SAFE SKIP | invalid function | label=" .. tostring(label))
        return false, nil
    end
    local ok, result = pcall(fn)
    if not ok then
        logi("SAFE ERROR | label=" .. tostring(label) .. " | err=" .. tostring(result))
        return false, nil
    end
    return true, result
end

local function safeGet(label, fn, fallback)
    local ok, result = safeCall(label, fn)
    if not ok or result == nil then return fallback end
    return result
end

local function safeNumber(label, fn, fallback)
    local value = safeGet(label, fn, fallback or 0)
    return tonumber(value) or fallback or 0
end

local function safeBool(label, fn, fallback)
    local value = safeGet(label, fn, fallback == true)
    return value == true or value == 1
end

local function hasMethod(obj, methodName)
    if not obj or not methodName then return false end
    local ok, result = pcall(function() return type(obj[methodName]) == "function" end)
    return ok and result == true
end

local unpackLua = table.unpack or unpack

local function safeMethod(label, obj, methodName, ...)
    if not obj then
        logi("SAFE SKIP | missing object | label=" .. tostring(label))
        return false, nil
    end
    if not hasMethod(obj, methodName) then
        logi("SAFE SKIP | missing method | label=" .. tostring(label) .. " | method=" .. tostring(methodName))
        return false, nil
    end
    local args = { ... }
    return safeCall(label, function()
        if type(unpackLua) ~= "function" then return nil end
        return obj[methodName](obj, unpackLua(args))
    end)
end

local function resetState(reason)
    M._state = {
        battleTick = 0,
        conflictStarted = false,
        lastProcessTick = -999999,
        lastUnitOrderTickByKey = {},
        lastGtaOrderTickByKey = {},
        gateWallChoiceByUnitKey = {},
        deployStakesDoneBySide = {},
        specialAbilityCounterByUnitKey = {},
        heroAbilityXmlLoaded = false,
        heroAbilityXmlRulesByName = {},
        heroAbilityUsesByUnitKey = {},
        heroAbilityLastUseTickByUnitKey = {},
        specialAbilityArmed = false,
        generalDefenseBySide = {},
        gateWallBreachDetectedTick = nil,
        gateDestroyedDetected = false,
        structureDestroyedDetected = false,
        initialGateWallCheckDone = false,
        noInitialGateWallTargets = false,
        carnDumPerimeter1GateDestroyed = false,
        carnDumPerimeter2GateDestroyed = false,
        progressivePerimeterDestroyedBySettlement = {},
        plazaIdleCountByUnitKey = {},
        plazaFallbackLastOrderTickBySide = {},
        settlementLookupDebugCount = 0,
        settlementLookupDebugLastLine = nil,
        forceGateUnitsMeleeAfterTick = nil,
        forceGateUnitsMeleeActive = false,
        lastEventData = nil,
    }
    logi("STATE reset | reason=" .. tostring(reason))
end

local function getState()
    if type(M._state) ~= "table" then resetState("state_missing") end
    local state = M._state
    if type(state.lastUnitOrderTickByKey) ~= "table" then state.lastUnitOrderTickByKey = {} end
    if type(state.lastGtaOrderTickByKey) ~= "table" then state.lastGtaOrderTickByKey = {} end
    if type(state.gateWallChoiceByUnitKey) ~= "table" then state.gateWallChoiceByUnitKey = {} end
    if type(state.deployStakesDoneBySide) ~= "table" then state.deployStakesDoneBySide = {} end
    if type(state.specialAbilityCounterByUnitKey) ~= "table" then state.specialAbilityCounterByUnitKey = {} end
    if state.heroAbilityXmlLoaded ~= true then state.heroAbilityXmlLoaded = false end
    if type(state.heroAbilityXmlRulesByName) ~= "table" then state.heroAbilityXmlRulesByName = {} end
    if type(state.heroAbilityUsesByUnitKey) ~= "table" then state.heroAbilityUsesByUnitKey = {} end
    if type(state.heroAbilityLastUseTickByUnitKey) ~= "table" then state.heroAbilityLastUseTickByUnitKey = {} end	
    if type(state.generalDefenseBySide) ~= "table" then state.generalDefenseBySide = {} end
    if state.forceGateUnitsMeleeActive ~= true then state.forceGateUnitsMeleeActive = false end
    if state.gateDestroyedDetected ~= true then state.gateDestroyedDetected = false end
    if state.structureDestroyedDetected ~= true then state.structureDestroyedDetected = false end
    if state.initialGateWallCheckDone ~= true then state.initialGateWallCheckDone = false end
    if state.noInitialGateWallTargets ~= true then state.noInitialGateWallTargets = false end
    if state.carnDumPerimeter1GateDestroyed ~= true then state.carnDumPerimeter1GateDestroyed = false end
    if state.carnDumPerimeter2GateDestroyed ~= true then state.carnDumPerimeter2GateDestroyed = false end
    if type(state.carnDumSecondGateApproachByUnitKey) ~= "table" then state.carnDumSecondGateApproachByUnitKey = {} end
    if type(state.progressivePerimeterDestroyedBySettlement) ~= "table" then state.progressivePerimeterDestroyedBySettlement = {} end
    if type(state.plazaIdleCountByUnitKey) ~= "table" then state.plazaIdleCountByUnitKey = {} end
    if type(state.plazaFallbackLastOrderTickBySide) ~= "table" then state.plazaFallbackLastOrderTickBySide = {} end
    if type(state.settlementLookupDebugCount) ~= "number" then state.settlementLookupDebugCount = 0 end
    return state
end

local function getBattle()
    return safeGet("M2TW.battle", function()
        if type(M2TW) ~= "table" then return nil end
        return M2TW.battle
    end, nil)
end

local function getSides(battle)
    local sides = safeGet("battle.sides", function() return battle and battle.sides or nil end, nil)
    local sidesNum = safeNumber("battle.sidesNum", function() return battle and battle.sidesNum or 0 end, 0)
    return sides, sidesNum
end

local function getSide(sides, luaIndex)
    return safeGet("side lua index " .. tostring(luaIndex), function() return sides and sides[luaIndex] or nil end, nil)
end

local function getBattleArmy(side, index)
    local ok, result = safeMethod("side:getBattleArmy " .. tostring(index), side, "getBattleArmy", index)
    if ok then return result end
    return nil
end

local function getBattleUnit(bArmy, index)
    local ok, result = safeMethod("battleArmy:getBattleUnit " .. tostring(index), bArmy, "getBattleUnit", index)
    if ok then return result end
    return nil
end

local function getFaction(side, index)
    local ok, result = safeMethod("side:getFaction " .. tostring(index), side, "getFaction", index)
    if ok then return result end
    return nil
end

local function getFactionID(fac)
    if not fac then return -1 end
    local id = safeNumber("fac.factionID", function() return fac.factionID end, -1)
    if id >= 0 then return id end
    id = safeNumber("fac.id", function() return fac.id end, -1)
    if id >= 0 then return id end
    return safeNumber("fac.index", function() return fac.index end, -1)
end

local function isPlayerFactionID(facID)
    facID = tonumber(facID) or -1
    if facID < 0 then return false end
    return safeBool("campaign:isPlayerFaction", function()
        return type(M2TW) == "table" and M2TW.campaign and type(M2TW.campaign.isPlayerFaction) == "function" and M2TW.campaign:isPlayerFaction(facID)
    end, false)
end

local function factionIsPlayer(fac)
    if not fac then return false end
    if isPlayerFactionID(getFactionID(fac)) then return true end
    return safeBool("fac.isPlayerControlled", function() return fac.isPlayerControlled end, false)
end

local function getPlayerArmy(battle, playerArmyIndex)
    if not battle or not hasMethod(battle, "getPlayerArmy") then return nil end
    local ok, army = safeMethod("battle:getPlayerArmy " .. tostring(playerArmyIndex), battle, "getPlayerArmy", playerArmyIndex)
    if ok then return army end
    return nil
end

local function sameBattleArmy(a, b)
    if not a or not b then return false end
    if a == b then return true end
    local aa = safeGet("compare playerArmy.army", function() return a.army end, nil)
    local ba = safeGet("compare sideArmy.army", function() return b.army end, nil)
    return aa ~= nil and ba ~= nil and aa == ba
end

local function battleArmyIsPlayerControlled(battle, bArmy)
    if not bArmy then return false end
    local army = safeGet("bArmy.army", function() return bArmy.army end, nil)
    local fac = safeGet("bArmy.army.faction", function() return army and army.faction or nil end, nil)
    if factionIsPlayer(fac) then return true end

    for i = 0, 7 do
        local pArmy = getPlayerArmy(battle, i)
        if pArmy and sameBattleArmy(pArmy, bArmy) then return true end
    end
    return false
end

local function sideHasPlayerFaction(side)
    if not side then return false end
    local factionCount = safeNumber("side.factionCount", function() return side.factionCount end, 0)
    for i = 0, factionCount - 1 do
        local fac = getFaction(side, i)
        if factionIsPlayer(fac) then return true end
    end
    if hasMethod(side, "hasFaction") then
        local maxFac = safeNumber("M2TWEOP.getFactionRecordNum", function()
            if type(M2TWEOP) == "table" and type(M2TWEOP.getFactionRecordNum) == "function" then
                return M2TWEOP.getFactionRecordNum()
            end
            return 31
        end, 31)
        for facID = 0, maxFac - 1 do
            if isPlayerFactionID(facID) then
                local ok, hasFac = safeMethod("side:hasFaction player", side, "hasFaction", facID)
                if ok and (hasFac == true or hasFac == 1) then return true end
            end
        end
    end
    return false
end

local function sideHasPlayerArmy(battle, side)
    if not battle or not side then return false end
    local battleArmyNum = safeNumber("side.battleArmyNum", function() return side.battleArmyNum end, 0)
    for p = 0, 7 do
        local pArmy = getPlayerArmy(battle, p)
        if pArmy then
            for b = 0, battleArmyNum - 1 do
                if sameBattleArmy(pArmy, getBattleArmy(side, b)) then return true end
            end
        end
    end
    return false
end

local function detectSides(battle, sides, sidesNum)
    local playerSideIndex = nil
    local aiSideIndexes = {}

    for s = 1, sidesNum do
        local sideIndex = s - 1
        local side = getSide(sides, s)
        if side and (sideHasPlayerFaction(side) or sideHasPlayerArmy(battle, side)) then
            playerSideIndex = sideIndex
            break
        end
    end

    if playerSideIndex ~= nil then
        for s = 1, sidesNum do
            local sideIndex = s - 1
            if sideIndex ~= playerSideIndex and getSide(sides, s) then
                aiSideIndexes[#aiSideIndexes + 1] = sideIndex
            end
        end
    end

    return playerSideIndex, aiSideIndexes
end

local function getBattleTypeFlags(battle)
    local battleTypeValue = safeGet("battle.battleType", function() return battle and battle.battleType or nil end, nil)
    local isSiege = false
    local isSally = false
    if type(battleType) == "table" then
        isSiege = safeBool("battleType.siege", function() return battleTypeValue == battleType.siege end, false)
        isSally = safeBool("battleType.sally", function() return battleTypeValue == battleType.sally end, false)
    end
    return isSiege, isSally, (not isSiege and not isSally)
end

local function getBattleResidence(battle)
    if not battle then return nil end
    if hasMethod(battle, "getBattleResidence") then
        local ok, residence = safeMethod("battle:getBattleResidence", battle, "getBattleResidence")
        if ok and residence then return residence end
    end
    local ok, residence = safeCall("battle.getBattleResidence", function()
        if type(battle.getBattleResidence) == "function" then return battle.getBattleResidence() end
        return nil
    end)
    if ok then return residence end
    return nil
end

local canIssueUnitOrder
local collectSideUnits
local updateProgressivePerimeterState
local progressiveUnitUsesThreePerimeterLogic
local getCurrentProgressivePerimeter


local function getBattleSettlement(battle)
    local residence = getBattleResidence(battle)
    return safeGet("battleResidence.settlement", function() return residence and residence.settlement or nil end, nil)
end

local function logBattleSettlementLookup(battle, context)
    local state = getState()
    if (tonumber(state.settlementLookupDebugCount) or 0) >= 12 then return end

    local residence = getBattleResidence(battle)
    local settlement = safeGet("battleResidence.settlement debug", function() return residence and residence.settlement or nil end, nil)
    local name = safeGet("battleResidence.settlement.name debug", function() return settlement and settlement.name or nil end, nil)
    local level = safeGet("battleResidence.settlement.level debug", function() return settlement and settlement.level or nil end, nil)
    local label = safeGet("battleResidence.settlement.localizedName debug", function() return settlement and settlement.localizedName or nil end, nil)
    local region = safeGet("battleResidence.settlement.region debug", function() return settlement and settlement.region or nil end, nil)

    local battleXCoord = safeGet("battle.xCoord debug", function() return battle and battle.xCoord or nil end, nil)
    local battleYCoord = safeGet("battle.yCoord debug", function() return battle and battle.yCoord or nil end, nil)
    local battleXcoord = safeGet("battle.xcoord debug", function() return battle and battle.xcoord or nil end, nil)
    local battleYcoord = safeGet("battle.ycoord debug", function() return battle and battle.ycoord or nil end, nil)
    local battleX = safeGet("battle.x debug", function() return battle and battle.x or nil end, nil)
    local battleY = safeGet("battle.y debug", function() return battle and battle.y or nil end, nil)
    local residenceXCoord = safeGet("battleResidence.xCoord debug", function() return residence and residence.xCoord or nil end, nil)
    local residenceYCoord = safeGet("battleResidence.yCoord debug", function() return residence and residence.yCoord or nil end, nil)
    local settlementXCoord = safeGet("settlement.xCoord debug", function() return settlement and settlement.xCoord or nil end, nil)
    local settlementYCoord = safeGet("settlement.yCoord debug", function() return settlement and settlement.yCoord or nil end, nil)

    local line = "SETTLEMENT_DEBUG | context=" .. tostring(context)
        .. " | battle=" .. tostring(battle) .. " type=" .. tostring(type(battle))
        .. " | residence=" .. tostring(residence) .. " type=" .. tostring(type(residence))
        .. " | settlement=" .. tostring(settlement) .. " type=" .. tostring(type(settlement))
        .. " | name=" .. tostring(name) .. " type=" .. tostring(type(name))
        .. " | level=" .. tostring(level) .. " type=" .. tostring(type(level))
        .. " | localizedName=" .. tostring(label) .. " type=" .. tostring(type(label))
        .. " | region=" .. tostring(region) .. " type=" .. tostring(type(region))
        .. " | battle.xCoord=" .. tostring(battleXCoord) .. " type=" .. tostring(type(battleXCoord))
        .. " | battle.yCoord=" .. tostring(battleYCoord) .. " type=" .. tostring(type(battleYCoord))
        .. " | battle.xcoord=" .. tostring(battleXcoord) .. " type=" .. tostring(type(battleXcoord))
        .. " | battle.ycoord=" .. tostring(battleYcoord) .. " type=" .. tostring(type(battleYcoord))
        .. " | battle.x=" .. tostring(battleX) .. " type=" .. tostring(type(battleX))
        .. " | battle.y=" .. tostring(battleY) .. " type=" .. tostring(type(battleY))
        .. " | residence.xCoord=" .. tostring(residenceXCoord) .. " type=" .. tostring(type(residenceXCoord))
        .. " | residence.yCoord=" .. tostring(residenceYCoord) .. " type=" .. tostring(type(residenceYCoord))
        .. " | settlement.xCoord=" .. tostring(settlementXCoord) .. " type=" .. tostring(type(settlementXCoord))
        .. " | settlement.yCoord=" .. tostring(settlementYCoord) .. " type=" .. tostring(type(settlementYCoord))

    if state.settlementLookupDebugLastLine ~= line then
        state.settlementLookupDebugLastLine = line
        state.settlementLookupDebugCount = (tonumber(state.settlementLookupDebugCount) or 0) + 1
        logi(line)
    end
end

local function getBattleCoordinateKey(battle)
    local settlement = getBattleSettlement(battle)
    local x = safeGet("battleResidence.settlement.xCoord", function() return settlement and settlement.xCoord or nil end, nil)
    local y = safeGet("battleResidence.settlement.yCoord", function() return settlement and settlement.yCoord or nil end, nil)

    if x == nil then x = safeGet("battle.xCoord", function() return battle and battle.xCoord or nil end, nil) end
    if y == nil then y = safeGet("battle.yCoord", function() return battle and battle.yCoord or nil end, nil) end
    if x == nil then x = safeGet("battle.xcoord", function() return battle and battle.xcoord or nil end, nil) end
    if y == nil then y = safeGet("battle.ycoord", function() return battle and battle.ycoord or nil end, nil) end

    x = tonumber(x)
    y = tonumber(y)
    if x == nil or y == nil then return nil, x, y end

    x = math.floor(x + 0.5)
    y = math.floor(y + 0.5)
    return tostring(x) .. ":" .. tostring(y), x, y
end

local function getBattleSettlementNameFromCoordinates(battle)
    local key, x, y = getBattleCoordinateKey(battle)
    if key == nil then return nil, x, y end
    return SETTLEMENT_AI_NAME_BY_COORD_KEY[key], x, y
end

local function getBattleSettlementName(battle)
    logBattleSettlementLookup(battle, "getBattleSettlementName")
    local settlement = getBattleSettlement(battle)
    local name = safeGet("battleResidence.settlement.name", function() return settlement and settlement.name or nil end, nil)
    if name ~= nil and tostring(name) ~= "" then return tostring(name), "name" end

    local coordName = nil
    local x = nil
    local y = nil
    coordName, x, y = getBattleSettlementNameFromCoordinates(battle)
    if coordName ~= nil and tostring(coordName) ~= "" then
        return tostring(coordName), "coords", x, y
    end

    if name ~= nil then return tostring(name), "empty_name", x, y end
    return nil, "missing", x, y
end

local function getSettlementOverrideRule(battle)
    local settlementName, source, x, y = getBattleSettlementName(battle)
    if settlementName == nil or tostring(settlementName) == "" then
        logi("SETTLEMENT_RULE lookup | settlement=nil | source=" .. tostring(source) .. " | x=" .. tostring(x) .. " | y=" .. tostring(y) .. " | hasRule=false")
        return nil, nil
    end
    local rule = SETTLEMENT_AI_OVERRIDES[settlementName]
    logi("SETTLEMENT_RULE lookup | settlement=" .. tostring(settlementName) .. " | source=" .. tostring(source) .. " | x=" .. tostring(x) .. " | y=" .. tostring(y) .. " | hasRule=" .. tostring(type(rule) == "table"))
    if type(rule) == "table" then return rule, settlementName end
    return nil, settlementName
end

local function unitTypeInDefenderLevelTable(unitType)
    if unitType == nil then return false end
    if SETTLEMENT_RULE_EXCLUDED_TYPES[tostring(unitType)] == true then return false end
    return type(DEFENDER_UNITS_BY_SETTLEMENT_LEVEL[tostring(unitType)]) == "table"
end

local function unitTypeUsesCarnDumTwoPerimeterLogic(unitType)
    unitType = tostring(unitType or "?")
    if SETTLEMENT_RULE_EXCLUDED_TYPES[unitType] == true then return false end
    if FORCE_GATE_ATTACK_UNITS[unitType] == true then return true end
    if unitTypeInDefenderLevelTable(unitType) then return true end
    return false
end

local function carnDumTwoPerimeterLogicEnabled(battle, aiIsAttacker, isSiege, isSally)
    if aiIsAttacker ~= true or not (isSiege == true and isSally ~= true) then return false, nil end
    local rule, settlementName = getSettlementOverrideRule(battle)
    if settlementName ~= "Carn-Dum" or type(rule) ~= "table" then return false, settlementName end
    return rule.attackerTwoPerimeterGateLogic == true, settlementName
end

local function carnDumUnitUsesTwoPerimeterLogic(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    local enabled, settlementName = carnDumTwoPerimeterLogicEnabled(battle, aiIsAttacker, isSiege, isSally)
    if enabled ~= true or not unitInfo then return false, settlementName end
    return unitTypeUsesCarnDumTwoPerimeterLogic(unitInfo.unitType), settlementName
end

local function orderHaltUnit(unitInfo, reason)
    if not unitInfo or not unitInfo.unit then return false end
    local un = unitInfo.unit
    if not canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, "halt_" .. tostring(reason or "settlement_rule")) then return false end
    local okHalt, errHalt = false, nil
    if hasMethod(un, "halt") then
        okHalt, errHalt = safeMethod("unit:halt " .. tostring(reason), un, "halt")
    end
    logi("ORDER halt | reason=" .. tostring(reason) .. " | unitType=" .. tostring(unitInfo.unitType) .. " | ok=" .. tostring(okHalt) .. " | err=" .. tostring(errHalt))
    return okHalt == true
end

local function settlementRuleRequiresHalt(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    if not unitInfo then return false, nil end
    if not (isSiege == true and isSally ~= true) then return false, nil end
    local rule, settlementName = getSettlementOverrideRule(battle)
    if type(rule) ~= "table" then return false, settlementName end
    local unitType = tostring(unitInfo.unitType or "?")
    local isDefenderLevelUnit = unitTypeInDefenderLevelTable(unitType)
    local state = getState()

    if aiIsAttacker == true then
        if isDefenderLevelUnit and rule.attackerDefenderLevelUnitsHaltAfterGateDestroyed == true and state.gateDestroyedDetected == true then
            return true, settlementName
        end
        if isDefenderLevelUnit and rule.attackerDefenderLevelUnitsHaltAfterAnyStructureDestroyed == true and state.structureDestroyedDetected == true then
            return true, settlementName
        end
        return false, settlementName
    end

    if rule.defenderDefenderLevelUnitsHalt == true and isDefenderLevelUnit then
        return true, settlementName
    end
    if type(rule.defenderSpecificHaltTypes) == "table" and rule.defenderSpecificHaltTypes[unitType] == true then
        return true, settlementName
    end
    return false, settlementName
end

local function settlementRuleAllowsOnlyGateForAttacker(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    if not unitInfo or aiIsAttacker ~= true or not (isSiege == true and isSally ~= true) then return false, nil end
    local rule, settlementName = getSettlementOverrideRule(battle)
    if type(rule) ~= "table" then return false, settlementName end
    local unitType = tostring(unitInfo.unitType or "?")
    if rule.attackerDefenderLevelUnitsGateOnly == true and unitTypeInDefenderLevelTable(unitType) then
        return true, settlementName
    end
    if rule.attackerForceGateUnitsGateOnly == true and FORCE_GATE_ATTACK_UNITS[unitType] == true then
        return true, settlementName
    end
    return false, settlementName
end

local function forceSettlementRuleHalts(battle, aiSide, aiIsAttacker, isSiege, isSally)
    if not (isSiege == true and isSally ~= true) then return end
    local rule, settlementName = getSettlementOverrideRule(battle)
    if type(rule) ~= "table" then return end
    local aiUnits = collectSideUnits(battle, aiSide)
    local checked = 0
    local halted = 0
    for _, unitInfo in ipairs(aiUnits) do
        local mustHalt = settlementRuleRequiresHalt(battle, unitInfo, aiIsAttacker, isSiege, isSally)
        if mustHalt == true then
            checked = checked + 1
            if orderHaltUnit(unitInfo, "settlement_rule_" .. tostring(settlementName)) then halted = halted + 1 end
        end
    end
    if checked > 0 then
        logi("SETTLEMENT_RULE halt pass | settlement=" .. tostring(settlementName) .. " | checked=" .. tostring(checked) .. " | halted=" .. tostring(halted))
    end
end

local function getBuilding(buildings, buildingIndex)
    local ok, building = safeMethod("battleBuildings:getBuilding " .. tostring(buildingIndex), buildings, "getBuilding", buildingIndex)
    if ok then return building end
    return nil
end

local function safeNumberOrNil(label, fn)
    local ok, value = safeCall(label, fn)
    if not ok or value == nil then return nil end
    return tonumber(value)
end

local function getBuildingBattleCoords(building)
    if not building then return nil, nil end
    local x = safeNumberOrNil("building.posX", function() return building.posX end)
    local y = safeNumberOrNil("building.posY", function() return building.posY end)
    if x == nil then x = safeNumberOrNil("building.xCoord", function() return building.xCoord end) end
    if y == nil then y = safeNumberOrNil("building.yCoord", function() return building.yCoord end) end
    if x == nil then x = safeNumberOrNil("building.x", function() return building.x end) end
    if y == nil then y = safeNumberOrNil("building.y", function() return building.y end) end
    if x == nil or y == nil then return nil, nil end
    return x, y
end

local function getUnitBattleCoords(un)
    if not un then return nil, nil end
    local x = safeNumberOrNil("unit.battlePosX", function() return un.battlePosX end)
    local y = safeNumberOrNil("unit.battlePosY", function() return un.battlePosY end)
    if x == nil or y == nil then return nil, nil end
    return x, y
end

local function collectValidGateAndWallBuildings(battle)
    local targets = { gate = {}, wall = {} }
    local residence = getBattleResidence(battle)
    local buildings = safeGet("residence.battleBuildings", function() return residence and residence.battleBuildings or nil end, nil)
    if not buildings then return targets end

    local buildingCount = safeNumber("battleBuildings.buildingCount", function() return buildings.buildingCount end, 0)
    for i = 0, buildingCount - 1 do
        local building = getBuilding(buildings, i)
        local isGate = safeBool("building.type gate", function()
            return building and type(battleBuildingType) == "table" and building.type == battleBuildingType.gate
        end, false)
        local isWall = safeBool("building.type wall", function()
            return building and type(battleBuildingType) == "table" and building.type == battleBuildingType.wall
        end, false)

        if isGate or isWall then
            local kind = isGate and "gate" or "wall"
            local breached = safeBool(kind .. ".breached", function() return building.breached end, false)
            local currentHealth = safeNumberOrNil(kind .. ".currentHealth", function() return building.currentHealth end)
            local startHealth = safeNumberOrNil(kind .. ".startHealth", function() return building.startHealth end)
            local x, y = getBuildingBattleCoords(building)
            local validHealth = true
            if currentHealth ~= nil and startHealth ~= nil and startHealth > 0 and currentHealth <= 0 then validHealth = false end
            if not breached and validHealth and x ~= nil and y ~= nil then
                targets[kind][#targets[kind] + 1] = { building = building, index = i, x = x, y = y, kind = kind }
            end
        end
    end

    return targets
end

local function getBattleBuildings(battle)
    local residence = getBattleResidence(battle)
    return safeGet("residence.battleBuildings", function() return residence and residence.battleBuildings or nil end, nil)
end

local function getPerimeterApiIndex(perimeterNumber)
    local number = tonumber(perimeterNumber)
    if number == nil then return nil end
    local offset = tonumber(BATTLE_AI_ASSIST_PERIMETER_API_INDEX_OFFSET) or 0
    local apiIndex = number + offset
    if apiIndex < 0 then apiIndex = 0 end
    return apiIndex
end

local function getPerimeterBuildings(battle, perimeterNumber)
    local buildings = getBattleBuildings(battle)
    if not buildings then return nil end

    local apiIndex = getPerimeterApiIndex(perimeterNumber)
    if apiIndex ~= nil then
        local ok, perimeter = safeMethod("battleBuildings:getPerimeter logical=" .. tostring(perimeterNumber) .. " api=" .. tostring(apiIndex), buildings, "getPerimeter", apiIndex)
        if ok and perimeter then return perimeter end
    end

    local rawIndex = tonumber(perimeterNumber)
    if rawIndex ~= nil and rawIndex ~= apiIndex then
        local ok, perimeter = safeMethod("battleBuildings:getPerimeter raw=" .. tostring(rawIndex), buildings, "getPerimeter", rawIndex)
        if ok and perimeter then return perimeter end
    end

    return nil
end

local function getPerimeterBuilding(perimeterBuildings, buildingIndex)
    local ok, building = safeMethod("perimeterBuildings:getBuilding " .. tostring(buildingIndex), perimeterBuildings, "getBuilding", buildingIndex)
    if ok then return building end
    return nil
end

local function buildingIsDestroyedOrBreached(building)
    if not building then return false end
    local breached = safeBool("building.breached", function() return building.breached end, false)
    if breached == true then return true end
    local currentHealth = safeNumberOrNil("building.currentHealth", function() return building.currentHealth end)
    local startHealth = safeNumberOrNil("building.startHealth", function() return building.startHealth end)
    if currentHealth ~= nil and startHealth ~= nil and startHealth > 0 and currentHealth <= 0 then return true end
    return false
end

local function collectStructureBuildingsByPerimeter(battle, perimeterNumber, kinds, onlyValid)
    local targets = { gate = {}, wall = {} }
    local perimeter = getPerimeterBuildings(battle, perimeterNumber)
    if not perimeter then return targets end

    local buildingCount = safeNumber("perimeterBuildings.buildingCount " .. tostring(perimeterNumber), function() return perimeter.buildingCount end, 0)
    for i = 0, buildingCount - 1 do
        local building = getPerimeterBuilding(perimeter, i)
        local isGate = safeBool("perimeter building.type gate", function()
            return building and type(battleBuildingType) == "table" and building.type == battleBuildingType.gate
        end, false)
        local isWall = safeBool("perimeter building.type wall", function()
            return building and type(battleBuildingType) == "table" and building.type == battleBuildingType.wall
        end, false)

        if (isGate and (not kinds or kinds.gate == true)) or (isWall and (not kinds or kinds.wall == true)) then
            local kind = isGate and "gate" or "wall"
            local x, y = getBuildingBattleCoords(building)
            local destroyed = buildingIsDestroyedOrBreached(building)
            if x ~= nil and y ~= nil and (onlyValid ~= true or destroyed ~= true) then
                targets[kind][#targets[kind] + 1] = { building = building, index = i, x = x, y = y, kind = kind, perimeter = perimeterNumber, destroyed = destroyed }
            end
        end
    end
    return targets
end

local function countTargetsInPerimeterTargets(targets)
    if type(targets) ~= "table" then return 0 end
    local total = 0
    if type(targets.gate) == "table" then total = total + #targets.gate end
    if type(targets.wall) == "table" then total = total + #targets.wall end
    return total
end

local function perimeterHasDestroyedStructure(battle, perimeterNumber, kinds)
    local targets = collectStructureBuildingsByPerimeter(battle, perimeterNumber, kinds, false)
    for _, kind in ipairs({ "gate", "wall" }) do
        for _, target in ipairs(targets[kind] or {}) do
            if target and target.destroyed == true then return true end
        end
    end
    return false
end

local function collectGateBuildingsByPerimeter(battle, perimeterNumber, onlyValid)
    local targets = collectStructureBuildingsByPerimeter(battle, perimeterNumber, { gate = true }, onlyValid)
    return targets.gate or {}
end

local function getBattlePerimeterCount(battle)
    local buildings = getBattleBuildings(battle)
    if not buildings then return 0 end
    return safeNumber("battleBuildings.perimeterCount", function() return buildings.perimeterCount end, 0)
end

local function updateCarnDumPerimeterGateState(battle, aiIsAttacker, isSiege, isSally)
    local enabled = carnDumTwoPerimeterLogicEnabled(battle, aiIsAttacker, isSiege, isSally)
    if enabled ~= true then return end

    local state = getState()
    if perimeterHasDestroyedStructure(battle, 1, { gate = true }) == true then
        if state.carnDumPerimeter1GateDestroyed ~= true then
            logi("CARN_DUM perimeter 1 gate destroyed detected")
        end
        state.carnDumPerimeter1GateDestroyed = true
    end

    if perimeterHasDestroyedStructure(battle, 2, { gate = true }) == true then
        if state.carnDumPerimeter2GateDestroyed ~= true then
            logi("CARN_DUM perimeter 2 gate destroyed detected")
        end
        state.carnDumPerimeter2GateDestroyed = true
    end
end

local function findNearestTargetForUnit(targets, un, targetKind)
    if not targets or not un or not targetKind then return nil end
    local list = targets[targetKind]
    if not list or #list <= 0 then return nil end
    local ux, uy = getUnitBattleCoords(un)
    if ux == nil or uy == nil then return nil end
    local best = nil
    local bestDistSq = nil
    for _, target in ipairs(list) do
        if target and target.x ~= nil and target.y ~= nil and target.building then
            local dx = ux - target.x
            local dy = uy - target.y
            local distSq = dx * dx + dy * dy
            if bestDistSq == nil or distSq < bestDistSq then
                bestDistSq = distSq
                best = target
            end
        end
    end
    return best
end

local function getUnitChoiceKey(un, battleArmyIndex, unitIndex)
    local unitID = safeNumberOrNil("unit.ID", function() return un and un.ID or nil end)
    if unitID ~= nil then return "ID:" .. tostring(unitID) end
    return "BA:" .. tostring(battleArmyIndex) .. ":U:" .. tostring(unitIndex)
end

canIssueUnitOrder = function(un, battleArmyIndex, unitIndex, orderName)
    if not un then return false end
    local state = getState()
    local now = tonumber(state.battleTick) or 0
    local key = getUnitChoiceKey(un, battleArmyIndex, unitIndex) .. ":" .. tostring(orderName or "order")
    local last = tonumber(state.lastUnitOrderTickByKey[key]) or -999999
    local cooldown = tonumber(BATTLE_AI_ASSIST_UNIT_ORDER_COOLDOWN_TICKS) or 180
    if now - last < cooldown then return false end
    state.lastUnitOrderTickByKey[key] = now
    return true
end

local function canIssueGtaOrder(sideIndex, orderName)
    local state = getState()
    local now = tonumber(state.battleTick) or 0
    local key = tostring(sideIndex) .. ":" .. tostring(orderName or "gta")
    local last = tonumber(state.lastGtaOrderTickByKey[key]) or -999999
    local cooldown = tonumber(BATTLE_AI_ASSIST_GTA_COOLDOWN_TICKS) or 600
    if now - last < cooldown then return false end
    state.lastGtaOrderTickByKey[key] = now
    return true
end

local function chooseGateOrWallForUnit(un, battleArmyIndex, unitIndex, targets)
    local hasGate = targets and targets.gate and #targets.gate > 0
    local hasWall = targets and targets.wall and #targets.wall > 0
    if hasGate and not hasWall then return "gate" end
    if hasWall and not hasGate then return "wall" end
    if not hasGate and not hasWall then return nil end

    local state = getState()
    local key = getUnitChoiceKey(un, battleArmyIndex, unitIndex)
    local stored = state.gateWallChoiceByUnitKey[key]
    if stored == "gate" or stored == "wall" then return stored end

    local chance = tonumber(FORCE_GATE_ATTACK_GATE_CHANCE_PERCENT) or 50
    if chance < 0 then chance = 0 end
    if chance > 100 then chance = 100 end
    local choice = (math.random(1, 100) <= chance) and "gate" or "wall"
    state.gateWallChoiceByUnitKey[key] = choice
    return choice
end

local function getUnitTypeName(un)
    if not un then return "?" end
    local edu = safeGet("unit.eduEntry", function() return un.eduEntry end, nil)
    local candidates = {}
    local function add(fn)
        local value = safeGet("unit type candidate", fn, nil)
        if value ~= nil and tostring(value) ~= "" and tostring(value) ~= "nil" then candidates[#candidates + 1] = tostring(value) end
    end
    if edu then
        add(function() return edu.type end)
        add(function() return edu.Type end)
        add(function() return edu.eduType end)
        add(function() return edu.eduTypeName end)
        add(function() return edu.typeName end)
        add(function() return edu.name end)
        add(function() return edu.Name end)
        add(function() return edu.unitType end)
    end
    add(function() return un.type end)
    add(function() return un.Type end)
    add(function() return un.eduType end)
    add(function() return un.typeName end)
    add(function() return un.name end)
    return candidates[1] or "?"
end

local function unitTypeIs(un, typeTable)
    local unitType = getUnitTypeName(un)
    return typeTable[unitType] == true, unitType
end

local function getUnitCurrentAmmo(un)
    if not un then return nil end
    return safeNumberOrNil("unit.currentAmmo", function() return un.currentAmmo end)
end

local function getUnitCategoryValue(un)
    if not un then return nil end
    local edu = safeGet("unit.eduEntry category", function() return un.eduEntry end, nil)
    local candidates = {}
    local function add(fn)
        local value = safeGet("unit category candidate", fn, nil)
        if value ~= nil then candidates[#candidates + 1] = value end
    end
    if edu then
        add(function() return edu.category end)
        add(function() return edu.Category end)
        add(function() return edu.unitCategory end)
        add(function() return edu.categoryName end)
    end
    add(function() return un.category end)
    add(function() return un.Category end)
    add(function() return un.unitCategory end)
    return candidates[1]
end

local function unitIsSiegeCategory(un)
    local value = getUnitCategoryValue(un)
    if value == nil then return false end
    if type(unitCategory) == "table" and unitCategory.siege ~= nil and value == unitCategory.siege then return true end
    local text = string.lower(tostring(value))
    return text == "siege" or text:find("siege", 1, true) ~= nil
end

local unitIsEngaged
local isUnitDeadOrInvalid

local function unitShouldUseBreachMelee(un)
    if not un then return false, "?", "missing_unit" end
    local unitType = getUnitTypeName(un)
    if ATTACKER_SIEGE_CATEGORY_EXCLUDE_TYPES[unitType] == true then return false, unitType, "excluded_type" end
    if FORCE_GATE_ATTACK_UNITS[unitType] == true then return true, unitType, "forced_type" end
    if unitIsSiegeCategory(un) then return true, unitType, "siege_category" end
    return false, unitType, "not_allowed"
end

local function unitShouldAttackGateWall(un)
    local useBreachMelee, unitType, reason = unitShouldUseBreachMelee(un)
    local state = getState()
    if useBreachMelee == true and state.forceGateUnitsMeleeActive == true then
        return false, unitType, "breach_melee_active"
    end
    if useBreachMelee == true then return true, unitType, reason end
    return false, unitType, reason
end

local function getGateMeleeProfile(unitInfo)
    local un = unitInfo and unitInfo.unit or nil
    if not un then return false, "?", "missing_unit", nil end
    local allowed, unitType, reason = unitShouldUseBreachMelee(un)
    if allowed ~= true then return false, unitType, reason, nil end
    local ammo = getUnitCurrentAmmo(un)
    return true, unitType, reason, ammo
end

local function targetIsAllowedForGateMeleeUnit(unitInfo, targetUnit)
    if not targetUnit then return false end
    local allowed, unitType, reason, ammo = getGateMeleeProfile(unitInfo)
    if allowed ~= true then return true end

    local targetEngaged = unitIsEngaged(targetUnit)
    if targetEngaged ~= true then return true end

    if reason == "forced_type" then
        return ammo ~= nil and ammo <= 0
    end

    if reason == "siege_category" then
        return false
    end

    return false
end

local function getEnemyGeneralUnit(enemyUnits)
    if type(enemyUnits) ~= "table" then return nil end
    local first = enemyUnits[1]
    local general = first and first.unit or nil
    if general and not isUnitDeadOrInvalid(general) then return general end
    return nil
end

local function findNearestAllowedEnemyUnitForGateMelee(unitInfo, enemyUnits)
    local un = unitInfo and unitInfo.unit or nil
    if not enemyUnits or not un then return nil end
    local ux, uy = getUnitBattleCoords(un)
    if ux == nil or uy == nil then return nil end

    local best = nil
    local bestDistSq = nil
    for _, enemyInfo in ipairs(enemyUnits) do
        local enemy = enemyInfo and enemyInfo.unit or nil
        local ex, ey = getUnitBattleCoords(enemy)
        if enemy and not isUnitDeadOrInvalid(enemy) and ex ~= nil and ey ~= nil and targetIsAllowedForGateMeleeUnit(unitInfo, enemy) then
            local dx = ux - ex
            local dy = uy - ey
            local distSq = dx * dx + dy * dy
            if bestDistSq == nil or distSq < bestDistSq then
                bestDistSq = distSq
                best = enemy
            end
        end
    end
    return best
end

local function findPriorityTargetForGateMeleeUnit(unitInfo, enemyUnits, allowGeneralPriority)
    if allowGeneralPriority == true and FORCE_GATE_ATTACK_GENERAL_PRIORITY_ENABLE == true then
        local general = getEnemyGeneralUnit(enemyUnits)
        if general and targetIsAllowedForGateMeleeUnit(unitInfo, general) then
            return general, "general"
        end
    end

    local nearest = findNearestAllowedEnemyUnitForGateMelee(unitInfo, enemyUnits)
    if nearest then return nearest, "nearest_allowed" end
    return nil, "none"
end

isUnitDeadOrInvalid = function(un)
    if not un then return true end
    local status = safeGet("unit:getActionStatus", function()
        if hasMethod(un, "getActionStatus") then return un:getActionStatus() end
        return nil
    end, nil)
    local statusText = string.lower(tostring(status or ""))
    return statusText == "dead" or statusText == "left_battle" or statusText == "routing"
end

collectSideUnits = function(battle, side, includePlayerControlled)
    local units = {}
    if not battle or not side then return units end
    local battleArmyNum = safeNumber("side.battleArmyNum", function() return side.battleArmyNum end, 0)
    for b = 0, battleArmyNum - 1 do
        local bArmy = getBattleArmy(side, b)
        if bArmy and (includePlayerControlled == true or not battleArmyIsPlayerControlled(battle, bArmy)) then
            local unitCount = safeNumber("bArmy.unitCount", function() return bArmy.unitCount end, 0)
            for u = 0, unitCount - 1 do
local bUnit = getBattleUnit(bArmy, u)
local un = safeGet("battleUnit.unit", function() return bUnit and bUnit.unit or nil end, nil)
local battleCharacter = safeGet("battleArmy.character", function() return bArmy and bArmy.character or nil end, nil)

if un and not isUnitDeadOrInvalid(un) then
    units[#units + 1] = {
        unit = un,
        battleUnit = bUnit,
        battleArmy = bArmy,
        battleCharacter = battleCharacter,
        battleArmyIndex = b,
        unitIndex = u,
        unitType = getUnitTypeName(un)
    }
end
            end
        end
    end
    return units
end


local function getArmyFromBattleArmy(bArmy)
    return safeGet("battleArmy.army", function() return bArmy and bArmy.army or nil end, nil)
end

local function countCategoryOnSide(battle, side, categoryValue)
    if not battle or not side or categoryValue == nil then return 0 end
    local total = 0
    local battleArmyNum = safeNumber("side.battleArmyNum category count", function() return side.battleArmyNum end, 0)
    for b = 0, battleArmyNum - 1 do
        local bArmy = getBattleArmy(side, b)
        if bArmy and not battleArmyIsPlayerControlled(battle, bArmy) then
            local army = getArmyFromBattleArmy(bArmy)
            if army and hasMethod(army, "getNumberOfCategory") then
                local ok, count = safeMethod("army:getNumberOfCategory", army, "getNumberOfCategory", categoryValue)
                if ok then total = total + (tonumber(count) or 0) end
            end
        end
    end
    return total
end

local function countCategoryOnAnySide(side, categoryValue)
    if not side or categoryValue == nil then return 0 end
    local total = 0
    local battleArmyNum = safeNumber("side.battleArmyNum any category count", function() return side.battleArmyNum end, 0)
    for b = 0, battleArmyNum - 1 do
        local bArmy = getBattleArmy(side, b)
        local army = getArmyFromBattleArmy(bArmy)
        if army and hasMethod(army, "getNumberOfCategory") then
            local ok, count = safeMethod("army:getNumberOfCategory any", army, "getNumberOfCategory", categoryValue)
            if ok then total = total + (tonumber(count) or 0) end
        end
    end
    return total
end

local function unitHasStakes(un)
    if not un then return false end
    return safeBool("unit.eduEntry.stakes", function()
        return un.eduEntry and un.eduEntry.stakes == true
    end, false)
end

unitIsEngaged = function(un)
    if not un then return false end
    if hasMethod(un, "isEngaged") then
        return safeBool("unit:isEngaged", function() return un:isEngaged() end, false)
    end
    local status = safeGet("unit:getActionStatus engaged fallback", function()
        if hasMethod(un, "getActionStatus") then return un:getActionStatus() end
        return nil
    end, nil)
    local text = string.lower(tostring(status or ""))
    return text == "fighting" or text == "charging" or text == "pursuing" or text:find("fighting", 1, true) ~= nil
end

local function unitIsMovingFast(un)
    if not un then return false end
    if hasMethod(un, "isMovingFastSet") then
        return safeBool("unit:isMovingFastSet", function() return un:isMovingFastSet() end, false)
    end
    return false
end

local function getFirstUnitInfo(units)
    if type(units) ~= "table" then return nil end
    return units[1]
end

local function getEnemyWithinRadius(unitInfo, enemyUnits, radius)
    if not unitInfo or not unitInfo.unit or not enemyUnits then return nil end
    local ux, uy = getUnitBattleCoords(unitInfo.unit)
    if ux == nil or uy == nil then return nil end
    local maxDistSq = (tonumber(radius) or 0) * (tonumber(radius) or 0)
    for _, enemyInfo in ipairs(enemyUnits) do
        local enemy = enemyInfo and enemyInfo.unit or nil
        local ex, ey = getUnitBattleCoords(enemy)
        if enemy and ex ~= nil and ey ~= nil and not isUnitDeadOrInvalid(enemy) then
            local dx = ux - ex
            local dy = uy - ey
            if dx * dx + dy * dy <= maxDistSq then return enemy end
        end
    end
    return nil
end

local function getGeneralHoldTicks(enemyUnitCount)
    enemyUnitCount = tonumber(enemyUnitCount) or 0
    if enemyUnitCount < 7 then return GENERAL_DEFENSE_WAIT_TICKS_BY_ENEMY_UNIT_COUNT.lessThan7 end
    if enemyUnitCount < 12 then return GENERAL_DEFENSE_WAIT_TICKS_BY_ENEMY_UNIT_COUNT.from7To11 end
    if enemyUnitCount < 16 then return GENERAL_DEFENSE_WAIT_TICKS_BY_ENEMY_UNIT_COUNT.from12To15 end
    return GENERAL_DEFENSE_WAIT_TICKS_BY_ENEMY_UNIT_COUNT.from16Plus
end

local function findNearestEnemyUnitForUnit(enemyUnits, un)
    if not enemyUnits or not un then return nil end
    local ux, uy = getUnitBattleCoords(un)
    if ux == nil or uy == nil then return nil end
    local best = nil
    local bestDistSq = nil
    for _, enemyInfo in ipairs(enemyUnits) do
        local enemy = enemyInfo and enemyInfo.unit or nil
        local ex, ey = getUnitBattleCoords(enemy)
        if enemy and not isUnitDeadOrInvalid(enemy) and ex ~= nil and ey ~= nil then
            local dx = ux - ex
            local dy = uy - ey
            local distSq = dx * dx + dy * dy
            if bestDistSq == nil or distSq < bestDistSq then
                bestDistSq = distSq
                best = enemy
            end
        end
    end
    return best
end

local function getNearbyEnemyByExistingSearch(un)
    if not un or not hasMethod(un, "getNearbyEnemyUnit") then return nil end
    for i = 0, 60 do
        local ok, enemy = safeMethod("unit:getNearbyEnemyUnit " .. tostring(i), un, "getNearbyEnemyUnit", i)
        if ok and enemy and not isUnitDeadOrInvalid(enemy) then return enemy end
    end
    return nil
end

local function getBattlePlazaCoords(battle)
    local residence = getBattleResidence(battle)
    local plaza = safeGet("battleResidence.plazaData", function() return residence and residence.plazaData or nil end, nil)
    if not plaza then return nil, nil end

    local x = safeNumberOrNil("plazaData.xCoord", function() return plaza.xCoord end)
    local y = safeNumberOrNil("plazaData.yCoord", function() return plaza.yCoord end)

    if x == nil or y == nil then return nil, nil end
    return x, y
end

local function allBattlePerimetersBreached(battle)
    local perimeterCount = getBattlePerimeterCount(battle)
    if perimeterCount <= 0 then return false, perimeterCount, 0 end

    local breached = 0
    for perimeterNumber = 1, perimeterCount do
        if perimeterHasDestroyedStructure(battle, perimeterNumber, { gate = true, wall = true }) == true then
            breached = breached + 1
        else
            return false, perimeterCount, breached
        end
    end

    return true, perimeterCount, breached
end

local function isIdleLikeCampaignLua(un)
    if not un or isUnitDeadOrInvalid(un) then return false end

    if unitIsEngaged(un) == true then return false end

    local status = safeGet("unit:getActionStatus plaza idle", function()
        if hasMethod(un, "getActionStatus") then return un:getActionStatus() end
        return nil
    end, nil)

    local text = string.lower(tostring(status or ""))

    if text == "" or text == "nil" then return true end
    if text == "idle" then return true end
    if text == "stand" then return true end
    if text == "standing" then return true end
    if text == "waiting" then return true end
    if text == "ready" then return true end
    if text:find("idle", 1, true) ~= nil then return true end
    if text:find("stand", 1, true) ~= nil then return true end
    if text:find("wait", 1, true) ~= nil then return true end

    return false
end

local function orderMoveUnitToPlaza(unitInfo, plazaX, plazaY, reason)
    if not unitInfo or not unitInfo.unit then return false end
    local un = unitInfo.unit

    if not hasMethod(un, "moveToPosition") then
        logi("PLAZA_FALLBACK skip | moveToPosition missing | unitType=" .. tostring(unitInfo.unitType))
        return false
    end

    if not canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, "move_to_plaza_" .. tostring(reason)) then return false end

    local okMove, errMove = safeMethod("unit:moveToPosition plaza fallback", un, "moveToPosition", plazaX, plazaY)

    logi("PLAZA_FALLBACK move | reason=" .. tostring(reason) .. " | unitType=" .. tostring(unitInfo.unitType) .. " | x=" .. tostring(math.floor((tonumber(plazaX) or 0) + 0.5)) .. " | y=" .. tostring(math.floor((tonumber(plazaY) or 0) + 0.5)) .. " | ok=" .. tostring(okMove) .. " | err=" .. tostring(errMove))
    return okMove == true
end

local function orderAttackNearestEnemy(unitInfo, enemyUnits, reason)
    if not unitInfo or not unitInfo.unit then return false end
    local un = unitInfo.unit
    if not canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, "attack_nearest") then return false end

    local target = getNearbyEnemyByExistingSearch(un) or findNearestEnemyUnitForUnit(enemyUnits, un)
    local okAttack, errAttack = false, nil
    if target and hasMethod(un, "attackUnit") then
        okAttack, errAttack = safeMethod("unit:attackUnit", un, "attackUnit", target, BATTLE_AI_ASSIST_RUN_ORDERS == true)
    elseif hasMethod(un, "attackClosestUnit") then
        okAttack, errAttack = safeMethod("unit:attackClosestUnit", un, "attackClosestUnit", BATTLE_AI_ASSIST_ATTACK_ARC, BATTLE_AI_ASSIST_RUN_ORDERS == true)
    end

    logi("ORDER attack nearest | reason=" .. tostring(reason) .. " | unitType=" .. tostring(unitInfo.unitType) .. " | ok=" .. tostring(okAttack) .. " | err=" .. tostring(errAttack))
    return okAttack == true
end

local function orderGateMeleePriorityTarget(unitInfo, enemyUnits, reason, allowGeneralPriority)
    if not unitInfo or not unitInfo.unit then return false end
    local un = unitInfo.unit
    if not canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, "gate_melee_priority") then return false end

    local target, targetReason = findPriorityTargetForGateMeleeUnit(unitInfo, enemyUnits, allowGeneralPriority)
    if not target then
        logi("GENERAL_PRIORITY no valid target | reason=" .. tostring(reason) .. " | unitType=" .. tostring(unitInfo.unitType))
        return false
    end

    local okAttack, errAttack = false, nil
    if hasMethod(un, "attackUnit") then
        okAttack, errAttack = safeMethod("unit:attackUnit gate melee priority", un, "attackUnit", target, BATTLE_AI_ASSIST_RUN_ORDERS == true)
    end

    logi("GENERAL_PRIORITY action | reason=" .. tostring(reason) .. " | targetReason=" .. tostring(targetReason) .. " | unitType=" .. tostring(unitInfo.unitType) .. " | ok=" .. tostring(okAttack) .. " | err=" .. tostring(errAttack))
    return okAttack == true
end

local function orderForceAmmoEmptyMelee(unitInfo, enemyUnits, allowGeneralPriority)
    if not unitInfo or not unitInfo.unit then return false end
    local un = unitInfo.unit
    if not canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, "empty_ammo_melee") then return false end

    local target, targetReason = findPriorityTargetForGateMeleeUnit(unitInfo, enemyUnits, allowGeneralPriority)
    local okAttack, errAttack = false, nil
    if target and hasMethod(un, "attackUnit") then
        okAttack, errAttack = safeMethod("unit:attackUnit empty ammo melee", un, "attackUnit", target, BATTLE_AI_ASSIST_RUN_ORDERS == true)
    end

    logi("EMPTY_AMMO_MELEE action | unitType=" .. tostring(unitInfo.unitType) .. " | currentAmmo=0 | targetReason=" .. tostring(targetReason) .. " | ok=" .. tostring(okAttack) .. " | err=" .. tostring(errAttack))
    return okAttack == true
end

local function forceEmptyAmmoMeleeForGateAttackUnits(battle, aiSide, enemyUnits, allowGeneralPriority)
    if FORCE_GATE_ATTACK_EMPTY_AMMO_MELEE_ENABLE ~= true then return end
    local aiUnits = collectSideUnits(battle, aiSide)
    local checked = 0
    local ordered = 0

    for _, unitInfo in ipairs(aiUnits) do
        local un = unitInfo and unitInfo.unit or nil
        local unitType = unitInfo and unitInfo.unitType or "?"
        if un and FORCE_GATE_ATTACK_UNITS[unitType] == true then
            checked = checked + 1
            local ammo = getUnitCurrentAmmo(un)
            if ammo ~= nil and ammo <= 0 then
                if orderForceAmmoEmptyMelee(unitInfo, enemyUnits, allowGeneralPriority) then ordered = ordered + 1 end
            end
        end
    end

    if checked > 0 then
        logi("EMPTY_AMMO_MELEE done | checked=" .. tostring(checked) .. " | ordered=" .. tostring(ordered))
    end
end

local function markGateWallBreachForMelee(reason)
    local state = getState()
    state.structureDestroyedDetected = true
    if tostring(reason) == "gate_destroyed" then
        state.gateDestroyedDetected = true
        logi("GATE destroyed detected | reason=" .. tostring(reason))
    end

    if FORCE_GATE_ATTACK_MELEE_AFTER_BREACH_ENABLE ~= true then return end
    if state.gateWallBreachDetectedTick ~= nil then return end
    local now = tonumber(state.battleTick) or 0
    local delayTicks = tonumber(FORCE_GATE_ATTACK_MELEE_AFTER_BREACH_DELAY_TICKS) or 70
    if delayTicks < 0 then delayTicks = 0 end
    state.gateWallBreachDetectedTick = now
    state.forceGateUnitsMeleeAfterTick = now + delayTicks
    state.forceGateUnitsMeleeActive = false
    logi("GATE_WALL_BREACH marked | reason=" .. tostring(reason) .. " | now=" .. tostring(now) .. " | meleeAfterTick=" .. tostring(state.forceGateUnitsMeleeAfterTick))
end

local function updateGateWallBreachMeleeState()
    local state = getState()
    if state.forceGateUnitsMeleeActive == true then return true end
    local afterTick = tonumber(state.forceGateUnitsMeleeAfterTick)
    if afterTick == nil then return false end
    local now = tonumber(state.battleTick) or 0
    if now >= afterTick then
        state.forceGateUnitsMeleeActive = true
        logi("GATE_WALL_BREACH melee active | now=" .. tostring(now))
        return true
    end
    return false
end

local function forceGateAttackUnitsMeleeAfterBreach(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnits)
    if FORCE_GATE_ATTACK_MELEE_AFTER_BREACH_ENABLE ~= true then return end
    if not (isSiege == true and isSally ~= true and aiIsAttacker == true) then return end
    if updateGateWallBreachMeleeState() ~= true then return end

    local aiUnits = collectSideUnits(battle, aiSide)
    local checked = 0
    local ordered = 0
    updateCarnDumPerimeterGateState(battle, aiIsAttacker, isSiege, isSally)
    updateProgressivePerimeterState(battle, aiIsAttacker, isSiege, isSally)
    for _, unitInfo in ipairs(aiUnits) do
        local un = unitInfo and unitInfo.unit or nil
        local mustHalt = settlementRuleRequiresHalt(battle, unitInfo, aiIsAttacker, isSiege, isSally)
        if mustHalt == true then
            checked = checked + 1
            if orderHaltUnit(unitInfo, "settlement_rule_after_breach") then ordered = ordered + 1 end
        else
            local carnDumUnit = carnDumUnitUsesTwoPerimeterLogic(battle, unitInfo, aiIsAttacker, isSiege, isSally)
            local progressiveUnit = progressiveUnitUsesThreePerimeterLogic(battle, unitInfo, aiIsAttacker, isSiege, isSally)
            local state = getState()
            local progressivePerimeter = getCurrentProgressivePerimeter(battle)
            if carnDumUnit == true and state.carnDumPerimeter2GateDestroyed ~= true then
                checked = checked + 1
                logi("CARN_DUM skip generic breach melee | unitType=" .. tostring(unitInfo.unitType) .. " | p1=" .. tostring(state.carnDumPerimeter1GateDestroyed) .. " | p2=" .. tostring(state.carnDumPerimeter2GateDestroyed))
            elseif progressiveUnit == true and progressivePerimeter ~= nil then
                checked = checked + 1
                logi("PROGRESSIVE_PERIMETER skip generic breach melee | unitType=" .. tostring(unitInfo.unitType) .. " | nextPerimeter=" .. tostring(progressivePerimeter))
            else
                local allowed, unitType, reason = unitShouldUseBreachMelee(un)
                if allowed == true then
                    checked = checked + 1
                    if orderGateMeleePriorityTarget(unitInfo, enemyUnits, "gate_wall_breach_melee_" .. tostring(reason), false) then ordered = ordered + 1 end
                end
            end
        end
    end

    if checked > 0 then
        logi("GATE_WALL_BREACH melee orders | checked=" .. tostring(checked) .. " | ordered=" .. tostring(ordered))
    end
end


local function getOperatedVanillaSiegeEngineType(un)
    if not un then return nil end
    if not hasMethod(un, "getSiegeEngine") then return nil end
    if type(engineType) ~= "table" then return nil end

    local engineCount = safeNumber(
        "unit.siegeEngineNum vanilla siege operator",
        function()
            return un and un.siegeEngineNum or 0
        end,
        0
    )

    if engineCount <= 0 then return nil end

    for engineIndex = 0, engineCount - 1 do
        local okEngine, engine = safeMethod(
            "unit:getSiegeEngine vanilla siege operator " .. tostring(engineIndex),
            un,
            "getSiegeEngine",
            engineIndex
        )

        if okEngine == true and engine then
            local currentUnit = safeGet(
                "siegeEngine.currentUnit vanilla siege operator",
                function()
                    return engine and engine.currentUnit or nil
                end,
                nil
            )

            local isCurrentOperator = false
            local okCompare = pcall(function()
                isCurrentOperator = currentUnit ~= nil and currentUnit == un
            end)

            if okCompare == true and isCurrentOperator == true then
                local okType, currentType = safeMethod(
                    "siegeEngine:getType vanilla siege operator",
                    engine,
                    "getType"
                )

                if okType == true then
                    if engineType.ram ~= nil and currentType == engineType.ram then
                        return "ram"
                    end

                    if engineType.ladder ~= nil and currentType == engineType.ladder then
                        return "ladder"
                    end

                    if engineType.tower ~= nil and currentType == engineType.tower then
                        return "tower"
                    end
                end
            end
        end
    end

    return nil
end

local function unitIsProtectedVanillaSiegeOperator(battle, un)
    if not battle or not un then return false end

    local engineKind = getOperatedVanillaSiegeEngineType(un)
    if engineKind == nil then return false end

    local allBreached, perimeterCount, breachedCount = allBattlePerimetersBreached(battle)

    if allBreached == true then
        return false
    end

    local state = getState()
    local unitKey = tostring(un) .. ":" .. tostring(engineKind)

    if state.vanillaSiegeOperatorProtectionLoggedByUnitKey[unitKey] ~= true then
        state.vanillaSiegeOperatorProtectionLoggedByUnitKey[unitKey] = true

        logi(
            "VANILLA_SIEGE_OPERATOR protected"
            .. " | unitType=" .. tostring(getUnitTypeName(un))
            .. " | engineType=" .. tostring(engineKind)
            .. " | perimeterCount=" .. tostring(perimeterCount)
            .. " | breachedPerimeters=" .. tostring(breachedCount)
        )
    end

    return true
end

local function unitIsRegularAfterBreach(battle, un)
    if not un then return false end

    if unitIsProtectedVanillaSiegeOperator(battle, un) == true then
        return false
    end
    local unitType = getUnitTypeName(un)
    if FORCE_GATE_ATTACK_UNITS[unitType] == true then return false end
    if unitIsSiegeCategory(un) then return false end
    return true
end

local function orderConfiguredStructureUnitsAttackNearest(battle, aiSide, enemyUnits, reason, aiIsAttacker, isSiege, isSally)
    local aiUnits = collectSideUnits(battle, aiSide)
    local checked = 0
    local ordered = 0
    for _, unitInfo in ipairs(aiUnits) do
        local un = unitInfo and unitInfo.unit or nil
        if un and not isUnitDeadOrInvalid(un) then
            local mustHalt = settlementRuleRequiresHalt(battle, unitInfo, aiIsAttacker, isSiege, isSally)
            if mustHalt == true then
                checked = checked + 1
                if orderHaltUnit(unitInfo, tostring(reason) .. "_halt") then ordered = ordered + 1 end
            else
                local allowed = unitShouldAttackGateWall(un)
                local gateOnly = settlementRuleAllowsOnlyGateForAttacker(battle, unitInfo, aiIsAttacker, isSiege, isSally)
                if allowed == true or gateOnly == true then
                    checked = checked + 1
                    if orderAttackNearestEnemy(unitInfo, enemyUnits, tostring(reason)) then ordered = ordered + 1 end
                end
            end
        end
    end
    logi("NO_INITIAL_GATE_WALL_TARGETS fallback | reason=" .. tostring(reason) .. " | checked=" .. tostring(checked) .. " | ordered=" .. tostring(ordered))
end

local function chooseGateOrWallForUnitWithSettlementRule(battle, unitInfo, aiIsAttacker, isSiege, isSally, targets)
    local gateOnly, settlementName = settlementRuleAllowsOnlyGateForAttacker(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    if gateOnly == true then
        if targets and targets.gate and #targets.gate > 0 then return "gate", "settlement_gate_only", settlementName end
        return nil, "settlement_gate_only_no_gate", settlementName
    end
    return chooseGateOrWallForUnit(unitInfo and unitInfo.unit, unitInfo and unitInfo.battleArmyIndex, unitInfo and unitInfo.unitIndex, targets), "generic", settlementName
end

local function findNearestCarnDumPerimeterGateForUnit(battle, un, perimeterNumber)
    local targets = { gate = collectGateBuildingsByPerimeter(battle, perimeterNumber, true) }
    return findNearestTargetForUnit(targets, un, "gate")
end

local function getDistanceSqBetweenUnitAndTarget(un, target)
    if not un or not target then return nil end
    local ux, uy = getUnitBattleCoords(un)
    if ux == nil or uy == nil or target.x == nil or target.y == nil then return nil end
    local dx = ux - target.x
    local dy = uy - target.y
    return dx * dx + dy * dy
end

local function getCarnDumSecondGateApproachPosition(un, target)
    if not un or not target then return nil, nil, nil end
    local ux, uy = getUnitBattleCoords(un)
    local gx = tonumber(target.x)
    local gy = tonumber(target.y)
    if ux == nil or uy == nil or gx == nil or gy == nil then return nil, nil, nil end

    local dx = ux - gx
    local dy = uy - gy
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist <= 0.01 then return nil, nil, dist end

    local approachDistance = tonumber(CARN_DUM_SECOND_GATE_APPROACH_DISTANCE_TILES) or 7
    if approachDistance < 1 then approachDistance = 1 end

    local moveX = gx + (dx / dist) * approachDistance
    local moveY = gy + (dy / dist) * approachDistance
    return moveX, moveY, dist
end

local function orderCarnDumMoveNearSecondGate(unitInfo, target)
    if not unitInfo or not unitInfo.unit or not target then return false end
    local un = unitInfo.unit
    if not hasMethod(un, "moveToPosition") then
        logi("CARN_DUM second gate approach skip | moveToPosition missing | unitType=" .. tostring(unitInfo.unitType))
        return false
    end

    local moveX, moveY, dist = getCarnDumSecondGateApproachPosition(un, target)
    if moveX == nil or moveY == nil then
        logi("CARN_DUM second gate approach skip | invalid coords | unitType=" .. tostring(unitInfo.unitType) .. " | dist=" .. tostring(dist))
        return false
    end

    local orderName = "carn_dum_move_to_second_gate_" .. tostring(target.index)
    if not canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, orderName) then return false end

    local okMove, errMove = safeMethod("unit:moveToPosition carn dum second gate", un, "moveToPosition", moveX, moveY)
    local state = getState()
    local key = getUnitChoiceKey(un, unitInfo.battleArmyIndex, unitInfo.unitIndex)
    state.carnDumSecondGateApproachByUnitKey[key] = {
        gateIndex = target.index,
        gateX = target.x,
        gateY = target.y,
        moveX = moveX,
        moveY = moveY,
    }

    logi("CARN_DUM ORDER move near second gate | unitType=" .. tostring(unitInfo.unitType) .. " | gateIndex=" .. tostring(target.index) .. " | moveX=" .. tostring(math.floor(moveX + 0.5)) .. " | moveY=" .. tostring(math.floor(moveY + 0.5)) .. " | gateDistance=" .. tostring(math.floor((dist or 0) + 0.5)) .. " | ok=" .. tostring(okMove) .. " | err=" .. tostring(errMove))
    return okMove == true
end

local function carnDumUnitReadyToAttackSecondGate(unitInfo, target)
    if not unitInfo or not unitInfo.unit or not target then return false end
    local distSq = getDistanceSqBetweenUnitAndTarget(unitInfo.unit, target)
    if distSq == nil then return false end
    local attackDistance = tonumber(CARN_DUM_SECOND_GATE_ATTACK_DISTANCE_TILES) or 8
    if attackDistance < 1 then attackDistance = 1 end
    return distSq <= attackDistance * attackDistance
end

local function getSettlementProgressivePerimeterKey(battle)
    local settlementName = getBattleSettlementName(battle)
    if settlementName ~= nil and tostring(settlementName) ~= "" then return tostring(settlementName) end
    local key = getBattleCoordinateKey(battle)
    return key or "unknown"
end

local function progressiveThreePerimeterLogicEnabled(battle, aiIsAttacker, isSiege, isSally)
    if THREE_PERIMETER_PROGRESSIVE_ATTACK_ENABLE ~= true then return false, nil end
    if aiIsAttacker ~= true or not (isSiege == true and isSally ~= true) then return false, nil end
    local rule, settlementName = getSettlementOverrideRule(battle)
    if settlementName == "Carn-Dum" then return false, settlementName end
    if type(THREE_PERIMETER_PROGRESSIVE_ATTACK_SETTLEMENTS) == "table" and settlementName and THREE_PERIMETER_PROGRESSIVE_ATTACK_SETTLEMENTS[tostring(settlementName)] == true then
        return true, settlementName
    end
    return getBattlePerimeterCount(battle) == 3, settlementName
end

progressiveUnitUsesThreePerimeterLogic = function(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    local enabled, settlementName = progressiveThreePerimeterLogicEnabled(battle, aiIsAttacker, isSiege, isSally)
    if enabled ~= true or not unitInfo or not unitInfo.unit then return false, settlementName end
    local allowed = unitShouldAttackGateWall(unitInfo.unit)
    local gateOnly = settlementRuleAllowsOnlyGateForAttacker(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    return allowed == true or gateOnly == true, settlementName
end

local function getProgressivePerimeterState(battle)
    local state = getState()
    local key = getSettlementProgressivePerimeterKey(battle)
    if type(state.progressivePerimeterDestroyedBySettlement[key]) ~= "table" then
        state.progressivePerimeterDestroyedBySettlement[key] = {}
    end
    return state.progressivePerimeterDestroyedBySettlement[key], key
end

updateProgressivePerimeterState = function(battle, aiIsAttacker, isSiege, isSally)
    local enabled, settlementName = progressiveThreePerimeterLogicEnabled(battle, aiIsAttacker, isSiege, isSally)
    if enabled ~= true then return end
    local record = getProgressivePerimeterState(battle)
    for perimeterNumber = 1, 3 do
        if record[perimeterNumber] ~= true and perimeterHasDestroyedStructure(battle, perimeterNumber, { gate = true, wall = true }) == true then
            record[perimeterNumber] = true
            logi("PROGRESSIVE_PERIMETER destroyed detected | settlement=" .. tostring(settlementName) .. " | perimeter=" .. tostring(perimeterNumber))
        end
    end
end

getCurrentProgressivePerimeter = function(battle)
    local record = getProgressivePerimeterState(battle)
    if record[1] ~= true then return 1 end
    if record[2] ~= true then return 2 end
    if record[3] ~= true then return 3 end
    return nil
end

local function findNearestProgressivePerimeterTargetForUnit(battle, unitInfo, targets)
    if not battle or not unitInfo or not unitInfo.unit then return nil, nil, nil end
    local perimeterNumber = getCurrentProgressivePerimeter(battle)
    if perimeterNumber == nil then return nil, nil, nil end

    local perimeterTargets = collectStructureBuildingsByPerimeter(battle, perimeterNumber, { gate = true, wall = true }, true)
    logi("PROGRESSIVE_PERIMETER target scan | logicalPerimeter=" .. tostring(perimeterNumber) .. " | apiIndex=" .. tostring(getPerimeterApiIndex(perimeterNumber)) .. " | gates=" .. tostring(perimeterTargets and perimeterTargets.gate and #perimeterTargets.gate or 0) .. " | walls=" .. tostring(perimeterTargets and perimeterTargets.wall and #perimeterTargets.wall or 0))
    if countTargetsInPerimeterTargets(perimeterTargets) <= 0 then
        local record = getProgressivePerimeterState(battle)
        record[perimeterNumber] = true
        logi("PROGRESSIVE_PERIMETER no valid target, skipping | perimeter=" .. tostring(perimeterNumber))
        return findNearestProgressivePerimeterTargetForUnit(battle, unitInfo, targets)
    end

    local chosenKind = chooseGateOrWallForUnit(unitInfo.unit, unitInfo.battleArmyIndex, unitInfo.unitIndex, perimeterTargets)
    local target = chosenKind and findNearestTargetForUnit(perimeterTargets, unitInfo.unit, chosenKind) or nil
    return target, chosenKind, perimeterNumber
end

local function handleProgressiveThreePerimeterUnit(battle, unitInfo, enemyUnits, aiIsAttacker, isSiege, isSally)
    local enabled, settlementName = progressiveUnitUsesThreePerimeterLogic(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    if enabled ~= true or not unitInfo or not unitInfo.unit then return false, false end

    updateProgressivePerimeterState(battle, aiIsAttacker, isSiege, isSally)
    local perimeterNumber = getCurrentProgressivePerimeter(battle)
    if perimeterNumber == nil then
        local ordered = orderAttackNearestEnemy(unitInfo, enemyUnits, "progressive_perimeter_done")
        return true, ordered
    end

    local un = unitInfo.unit
    local target, chosenKind, targetPerimeter = findNearestProgressivePerimeterTargetForUnit(battle, unitInfo)
    if target and target.building and chosenKind and hasMethod(un, "attackBuilding") and canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, "progressive_perimeter_" .. tostring(targetPerimeter) .. "_" .. tostring(chosenKind)) then
        local okAttack, errAttack = safeMethod("unit:attackBuilding progressive perimeter", un, "attackBuilding", target.building)
        logi("PROGRESSIVE_PERIMETER ORDER attack building | settlement=" .. tostring(settlementName) .. " | unitType=" .. tostring(unitInfo.unitType) .. " | perimeter=" .. tostring(targetPerimeter) .. " | target=" .. tostring(chosenKind) .. " | index=" .. tostring(target.index) .. " | ok=" .. tostring(okAttack) .. " | err=" .. tostring(errAttack))
        return true, okAttack == true
    end

    logi("PROGRESSIVE_PERIMETER no order | settlement=" .. tostring(settlementName) .. " | unitType=" .. tostring(unitInfo.unitType) .. " | perimeter=" .. tostring(perimeterNumber) .. " | target=" .. tostring(chosenKind))
    return true, false
end

local function handleCarnDumTwoPerimeterGateUnit(battle, unitInfo, enemyUnits, aiIsAttacker, isSiege, isSally)
    local enabled = carnDumUnitUsesTwoPerimeterLogic(battle, unitInfo, aiIsAttacker, isSiege, isSally)
    if enabled ~= true or not unitInfo or not unitInfo.unit then return false, false end

    updateCarnDumPerimeterGateState(battle, aiIsAttacker, isSiege, isSally)

    local state = getState()
    if state.carnDumPerimeter2GateDestroyed == true then
        local ordered = orderAttackNearestEnemy(unitInfo, enemyUnits, "carn_dum_second_perimeter_gate_destroyed")
        return true, ordered
    end

    local un = unitInfo.unit
    local targetPerimeter = state.carnDumPerimeter1GateDestroyed == true and 2 or 1
    local debugTargets = collectGateBuildingsByPerimeter(battle, targetPerimeter, true)
    logi("CARN_DUM target scan | unitType=" .. tostring(unitInfo.unitType) .. " | logicalPerimeter=" .. tostring(targetPerimeter) .. " | apiIndex=" .. tostring(getPerimeterApiIndex(targetPerimeter)) .. " | validGates=" .. tostring(#debugTargets))
    local target = findNearestTargetForUnit({ gate = debugTargets }, un, "gate")

    if target == nil and targetPerimeter == 1 then
        state.carnDumPerimeter1GateDestroyed = true
        state.carnDumSecondGateApproachByUnitKey = {}
        targetPerimeter = 2
        target = findNearestCarnDumPerimeterGateForUnit(battle, un, targetPerimeter)
        logi("CARN_DUM perimeter 1 gate has no valid target, advancing to perimeter 2 | unitType=" .. tostring(unitInfo.unitType))
    end

    if target == nil and targetPerimeter == 2 then
        state.carnDumPerimeter2GateDestroyed = true
        state.carnDumSecondGateApproachByUnitKey = {}
        local ordered = orderAttackNearestEnemy(unitInfo, enemyUnits, "carn_dum_no_valid_perimeter_2_gate")
        logi("CARN_DUM perimeter 2 gate has no valid target, attacking nearest enemy | unitType=" .. tostring(unitInfo.unitType) .. " | ordered=" .. tostring(ordered))
        return true, ordered
    end

    if targetPerimeter == 2 and target and target.building then
        local key = getUnitChoiceKey(un, unitInfo.battleArmyIndex, unitInfo.unitIndex)
        local approachRecord = state.carnDumSecondGateApproachByUnitKey[key]
        local readyToAttack = carnDumUnitReadyToAttackSecondGate(unitInfo, target)

        if readyToAttack ~= true then
            local moved = orderCarnDumMoveNearSecondGate(unitInfo, target)
            logi("CARN_DUM second gate approach pending | unitType=" .. tostring(unitInfo.unitType) .. " | gateIndex=" .. tostring(target.index) .. " | hasApproachRecord=" .. tostring(type(approachRecord) == "table") .. " | moved=" .. tostring(moved))
            return true, moved
        end
    end

    if target and target.building and hasMethod(un, "attackBuilding") and canIssueUnitOrder(un, unitInfo.battleArmyIndex, unitInfo.unitIndex, "carn_dum_attack_perimeter_" .. tostring(targetPerimeter) .. "_gate") then
        local okAttack, errAttack = safeMethod("unit:attackBuilding carn dum perimeter gate", un, "attackBuilding", target.building)
        logi("CARN_DUM ORDER attack perimeter gate | unitType=" .. tostring(unitInfo.unitType) .. " | perimeter=" .. tostring(targetPerimeter) .. " | gateIndex=" .. tostring(target.index) .. " | ok=" .. tostring(okAttack) .. " | err=" .. tostring(errAttack))
        return true, okAttack == true
    end

    logi("CARN_DUM no valid perimeter gate target | unitType=" .. tostring(unitInfo.unitType) .. " | perimeter=" .. tostring(targetPerimeter))
    return true, false
end

local function forcePerimeterControlledUnitsWithoutGenericTargets(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnits, reason)
    local aiUnits = collectSideUnits(battle, aiSide)
    local checked = 0
    local ordered = 0
    for _, unitInfo in ipairs(aiUnits) do
        if unitInfo and unitInfo.unit and not isUnitDeadOrInvalid(unitInfo.unit) then
            local carnHandled, carnOrdered = handleCarnDumTwoPerimeterGateUnit(battle, unitInfo, enemyUnits, aiIsAttacker, isSiege, isSally)
            if carnHandled == true then
                checked = checked + 1
                if carnOrdered == true then ordered = ordered + 1 end
            else
                local progressiveHandled, progressiveOrdered = handleProgressiveThreePerimeterUnit(battle, unitInfo, enemyUnits, aiIsAttacker, isSiege, isSally)
                if progressiveHandled == true then
                    checked = checked + 1
                    if progressiveOrdered == true then ordered = ordered + 1 end
                end
            end
        end
    end
    if checked > 0 then
        logi("PERIMETER_CONTROLLED no generic targets pass | reason=" .. tostring(reason) .. " | checked=" .. tostring(checked) .. " | ordered=" .. tostring(ordered))
    end
    return checked, ordered
end

local function forceForcedGateAttackUnitsRun(battle, aiSide)
    if not battle or not aiSide then return end
    local aiUnits = collectSideUnits(battle, aiSide)
    local checked = 0
    local ordered = 0
    for _, unitInfo in ipairs(aiUnits) do
        local un = unitInfo and unitInfo.unit or nil
        local unitType = unitInfo and unitInfo.unitType or "?"
        if un and FORCE_GATE_ATTACK_UNITS[unitType] == true then
            checked = checked + 1
            if hasMethod(un, "setMovingFastSet") then
                local okRun = safeBool("unit:isMovingFastSet run check", function()
                    if hasMethod(un, "isMovingFastSet") then return un:isMovingFastSet() end
                    return false
                end, false)
                if okRun ~= true then
                    local okSet, errSet = safeMethod("unit:setMovingFastSet force gate run", un, "setMovingFastSet", true)
                    if okSet == true then ordered = ordered + 1 end
                    logi("FORCE_GATE_ATTACK_RUN action | unitType=" .. tostring(unitType) .. " | ok=" .. tostring(okSet) .. " | err=" .. tostring(errSet))
                end
            end
        end
    end
    if checked > 0 then
        logi("FORCE_GATE_ATTACK_RUN done | checked=" .. tostring(checked) .. " | ordered=" .. tostring(ordered))
    end
end

local function forceGateWallUnits(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnits)
    if not (isSiege == true and isSally ~= true and aiIsAttacker == true) then return end
    local targets = collectValidGateAndWallBuildings(battle)
    local validGates = targets and targets.gate and #targets.gate or 0
    local validWalls = targets and targets.wall and #targets.wall or 0
    local state = getState()
    updateCarnDumPerimeterGateState(battle, aiIsAttacker, isSiege, isSally)
    updateProgressivePerimeterState(battle, aiIsAttacker, isSiege, isSally)

    if state.initialGateWallCheckDone ~= true then
        state.initialGateWallCheckDone = true
        state.noInitialGateWallTargets = (validGates <= 0 and validWalls <= 0)
        logi("GATE_WALL initial check | gates=" .. tostring(validGates) .. " | walls=" .. tostring(validWalls) .. " | noInitialTargets=" .. tostring(state.noInitialGateWallTargets))
    end

    if validGates <= 0 and validWalls <= 0 then
        logi("GATE_WALL no valid generic gate/wall targets")
        local perimeterChecked, perimeterOrdered = forcePerimeterControlledUnitsWithoutGenericTargets(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnits, "no_generic_gate_wall_targets")
        if state.noInitialGateWallTargets == true and (tonumber(perimeterOrdered) or 0) <= 0 then
            orderConfiguredStructureUnitsAttackNearest(battle, aiSide, enemyUnits, "no_initial_gate_wall_targets", aiIsAttacker, isSiege, isSally)
        end
        return
    end

    local ordered = 0
    local checked = 0
    local battleArmyNum = safeNumber("aiSide.battleArmyNum gatewall", function() return aiSide and aiSide.battleArmyNum or 0 end, 0)
    for b = 0, battleArmyNum - 1 do
        local bArmy = getBattleArmy(aiSide, b)
        if bArmy and not battleArmyIsPlayerControlled(battle, bArmy) then
            local unitCount = safeNumber("bArmy.unitCount gatewall", function() return bArmy.unitCount end, 0)
            for u = 0, unitCount - 1 do
                local bUnit = getBattleUnit(bArmy, u)
                local un = safeGet("battleUnit.unit gatewall", function() return bUnit and bUnit.unit or nil end, nil)
                checked = checked + 1
                if un and not isUnitDeadOrInvalid(un) then
                    local unitInfo = { unit = un, battleArmyIndex = b, unitIndex = u, unitType = getUnitTypeName(un) }
                    local carnHandled, carnOrdered = handleCarnDumTwoPerimeterGateUnit(battle, unitInfo, enemyUnits, aiIsAttacker, isSiege, isSally)
                    if carnHandled == true then
                        if carnOrdered == true then ordered = ordered + 1 end
                    else
                        local progressiveHandled, progressiveOrdered = handleProgressiveThreePerimeterUnit(battle, unitInfo, enemyUnits, aiIsAttacker, isSiege, isSally)
                        if progressiveHandled == true then
                            if progressiveOrdered == true then ordered = ordered + 1 end
                        else
                            local mustHalt, settlementName = settlementRuleRequiresHalt(battle, unitInfo, aiIsAttacker, isSiege, isSally)
                        if mustHalt == true then
                        if orderHaltUnit(unitInfo, "settlement_rule_attacker_structure") then ordered = ordered + 1 end
                    else
                        local allowed, unitType, reason = unitShouldAttackGateWall(un)
                        local gateOnly = settlementRuleAllowsOnlyGateForAttacker(battle, unitInfo, aiIsAttacker, isSiege, isSally)
                        if (allowed or gateOnly == true) and hasMethod(un, "attackBuilding") then
                            local chosenKind, choiceReason, choiceSettlement = chooseGateOrWallForUnitWithSettlementRule(battle, unitInfo, aiIsAttacker, isSiege, isSally, targets)
                            local target = chosenKind and findNearestTargetForUnit(targets, un, chosenKind) or nil
                            if target and target.building and canIssueUnitOrder(un, b, u, "attack_building_" .. tostring(chosenKind)) then
                                local okAttack, errAttack = safeMethod("unit:attackBuilding", un, "attackBuilding", target.building)
                                if okAttack then ordered = ordered + 1 end
                                logi("ORDER attack building | unitType=" .. tostring(unitType) .. " | reason=" .. tostring(reason) .. " | target=" .. tostring(chosenKind) .. " | choiceReason=" .. tostring(choiceReason) .. " | settlement=" .. tostring(choiceSettlement) .. " | ok=" .. tostring(okAttack) .. " | err=" .. tostring(errAttack))
                            elseif choiceReason == "settlement_gate_only_no_gate" then
                                if orderAttackNearestEnemy(unitInfo, enemyUnits, "settlement_gate_only_no_gate") then ordered = ordered + 1 end
                            end
                        end
                    end
                    end
                    end
                end
            end
        end
    end
    logi("GATE_WALL done | checked=" .. tostring(checked) .. " | ordered=" .. tostring(ordered))
end

local function getBattleSettlementLevel(battle)
    local settlement = getBattleSettlement(battle)
    local level = safeNumberOrNil("battleResidence.settlement.level", function() return settlement and settlement.level or nil end)
    return level
end

local function defenderUnitTypeAllowedForSettlementLevel(unitType, settlementLevel)
    if unitType == nil or settlementLevel == nil then return false end
    local rules = DEFENDER_UNITS_BY_SETTLEMENT_LEVEL[tostring(unitType)]
    if type(rules) ~= "table" then return false end
    if rules.allLevels == true then return true end
    return rules[tonumber(settlementLevel)] == true
end

local function forceDefenderArtillery(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnits, eventData)
    if not ((isSiege == true and isSally ~= true and aiIsAttacker ~= true) or (isSally == true and aiIsAttacker == true)) then return end
    local settlementLevel = getBattleSettlementLevel(battle)
    if settlementLevel == nil then
        logi("DEFENDER_LEVEL_UNITS stop | settlementLevel=nil")
        return
    end

    local aiUnits = collectSideUnits(battle, aiSide)
    local ordered = 0
    local checked = 0
    for _, unitInfo in ipairs(aiUnits) do
        checked = checked + 1
        local unitType = unitInfo and unitInfo.unitType or "?"
        local mustHalt = settlementRuleRequiresHalt(battle, unitInfo, aiIsAttacker, isSiege, isSally)
        if mustHalt == true then
            if orderHaltUnit(unitInfo, "settlement_rule_defender") then ordered = ordered + 1 end
        else
            local allowed = defenderUnitTypeAllowedForSettlementLevel(unitType, settlementLevel)
            if allowed then
                if orderAttackNearestEnemy(unitInfo, enemyUnits, "defender_level_unit") then ordered = ordered + 1 end
            end
        end
    end
    logi("DEFENDER_LEVEL_UNITS done | checked=" .. tostring(checked) .. " | ordered=" .. tostring(ordered) .. " | settlementLevel=" .. tostring(settlementLevel))
end

local function forceSallyOutAttackers(battle, aiSide, aiIsAttacker, isSally, enemyUnits)
    if not (isSally == true and aiIsAttacker == true) then return end
    local aiUnits = collectSideUnits(battle, aiSide)
    local ordered = 0
    for _, unitInfo in ipairs(aiUnits) do
        local allowed = unitShouldUseBreachMelee(unitInfo and unitInfo.unit)
        if allowed == true then
            if orderGateMeleePriorityTarget(unitInfo, enemyUnits, "sallyout_priority", false) then ordered = ordered + 1 end
        else
            if orderAttackNearestEnemy(unitInfo, enemyUnits, "sallyout_attack") then ordered = ordered + 1 end
        end
    end
    logi("SALLY_OUT attack orders done | aiUnits=" .. tostring(#aiUnits) .. " | ordered=" .. tostring(ordered))
end


local function deployStakesFromOriginal(battle, playerSide, aiSide, aiSideIndex, aiIsAttacker, isSiege, isSally)
    if BATTLE_AI_ASSIST_DEPLOY_STAKES_ENABLE ~= true then return end
    if aiIsAttacker == true then return end
    if isSiege == true and isSally ~= true then
        logi("DEPLOY_STAKES skip | settlement siege defender")
        return
    end
    if type(unitCategory) ~= "table" or unitCategory.cavalry == nil then
        logi("DEPLOY_STAKES skip | unitCategory.cavalry missing")
        return
    end

    local state = getState()
    local sideKey = tostring(aiSideIndex or "?")
    if state.deployStakesDoneBySide[sideKey] == true then return end

    local playerCavalry = countCategoryOnAnySide(playerSide, unitCategory.cavalry)
    local aiCavalry = countCategoryOnSide(battle, aiSide, unitCategory.cavalry)
    if playerCavalry <= 0 or aiCavalry > 0 then
        logi("DEPLOY_STAKES skip | playerCavalry=" .. tostring(playerCavalry) .. " | aiCavalry=" .. tostring(aiCavalry))
        return
    end

    local aiUnits = collectSideUnits(battle, aiSide)
    local hasStakes = false
    for _, unitInfo in ipairs(aiUnits) do
        if unitHasStakes(unitInfo and unitInfo.unit) then hasStakes = true; break end
    end
    if not hasStakes then
        logi("DEPLOY_STAKES skip | no AI stakes units")
        return
    end

    local deployed = 0
    for _, unitInfo in ipairs(aiUnits) do
        local un = unitInfo and unitInfo.unit or nil
        if unitHasStakes(un) and hasMethod(un, "deployStakes") then
            local okStake, errStake = safeMethod("unit:deployStakes", un, "deployStakes")
            if okStake then deployed = deployed + 1 end
            logi("DEPLOY_STAKES action | unitType=" .. tostring(unitInfo.unitType) .. " | ok=" .. tostring(okStake) .. " | err=" .. tostring(errStake))
        end
    end

    state.deployStakesDoneBySide[sideKey] = true
    logi("DEPLOY_STAKES done | aiSide=" .. tostring(aiSideIndex) .. " | deployed=" .. tostring(deployed))
end

local function trimXmlValue(value)
    if value == nil then return nil end
    value = tostring(value)
    value = value:gsub("^%s+", "")
    value = value:gsub("%s+$", "")
    if value == "" then return nil end
    return value
end

local function extractXmlTag(block, tagName)
    if type(block) ~= "string" or type(tagName) ~= "string" then return nil end
    local pattern = "<%s*" .. tagName .. "%s*>(.-)</%s*" .. tagName .. "%s*>"
    return trimXmlValue(block:match(pattern))
end

local function readTextFileSafe(path)
    if type(path) ~= "string" or path == "" then return nil end

    local ok, content = pcall(function()
        local f = io.open(path, "r")
        if not f then return nil end
        local data = f:read("*a")
        f:close()
        return data
    end)

    if ok and type(content) == "string" and content ~= "" then
        return content
    end

    return nil
end

local function getHeroAbilityXmlPathCandidates()
    local paths = {}

    local modPath = safeGet("M2TWEOP.getModPath hero ability xml", function()
        if type(M2TWEOP) == "table" and type(M2TWEOP.getModPath) == "function" then
            return M2TWEOP.getModPath()
        end
        return nil
    end, nil)

    local pluginPath = safeGet("M2TWEOP.getPluginPath hero ability xml", function()
        if type(M2TWEOP) == "table" and type(M2TWEOP.getPluginPath) == "function" then
            return M2TWEOP.getPluginPath()
        end
        return nil
    end, nil)

    if type(modPath) == "string" and modPath ~= "" then
        paths[#paths + 1] = modPath .. "/data/descr_hero_abilities.xml"
        paths[#paths + 1] = modPath .. "\\data\\descr_hero_abilities.xml"
    end

    if type(pluginPath) == "string" and pluginPath ~= "" then
        paths[#paths + 1] = pluginPath .. "/descr_hero_abilities.xml"
        paths[#paths + 1] = pluginPath .. "\\descr_hero_abilities.xml"
    end

    paths[#paths + 1] = "data/descr_hero_abilities.xml"
    paths[#paths + 1] = "descr_hero_abilities.xml"

    return paths
end

local function loadHeroAbilityXmlRules()
    local state = getState()

    if state.heroAbilityXmlLoaded == true then
        return state.heroAbilityXmlRulesByName or {}
    end

    state.heroAbilityXmlLoaded = true
    state.heroAbilityXmlRulesByName = {}

    if HERO_ABILITY_XML_LIMITS_ENABLE ~= true then
        logi("HERO_ABILITY_XML disabled")
        return state.heroAbilityXmlRulesByName
    end

    local xmlText = nil
    local usedPath = nil
    local paths = getHeroAbilityXmlPathCandidates()

    for _, path in ipairs(paths) do
        xmlText = readTextFileSafe(path)
        if xmlText then
            usedPath = path
            break
        end
    end

    if not xmlText then
        logi("HERO_ABILITY_XML failed | reason=file not found")
        return state.heroAbilityXmlRulesByName
    end

    xmlText = xmlText:gsub("<!%-%-.-%-%->", "")

    local loaded = 0
    for block in xmlText:gmatch("<%s*hero_ability%s*>(.-)</%s*hero_ability%s*>") do
        local name = extractXmlTag(block, "name")
        if name then
            local activations = tonumber(extractXmlTag(block, "activations")) or tonumber(HERO_ABILITY_XML_DEFAULT_ACTIVATIONS) or 1
            local cooldownSeconds = tonumber(extractXmlTag(block, "cooldown")) or tonumber(HERO_ABILITY_XML_DEFAULT_COOLDOWN_SECONDS) or 0

            activations = math.max(1, math.floor(activations))
            cooldownSeconds = math.max(0, cooldownSeconds)

            state.heroAbilityXmlRulesByName[name] = {
                activations = activations,
                cooldownTicks = math.floor(cooldownSeconds * (tonumber(HERO_ABILITY_XML_SECONDS_TO_TICKS) or 10))
            }

            loaded = loaded + 1
        end
    end

    logi("HERO_ABILITY_XML loaded | path=" .. tostring(usedPath) .. " | abilities=" .. tostring(loaded))
    return state.heroAbilityXmlRulesByName
end

local function getCharacterAbilityNameSafe(character)
    if not character then return nil end

    local ability = safeGet("character.ability", function()
        return character and character.ability or nil
    end, nil)

    ability = trimXmlValue(ability)
    if ability then return ability end

    local record = safeGet("character.characterRecord", function()
        return character and character.characterRecord or nil
    end, nil)

    local recordCharacter = safeGet("characterRecord.character", function()
        return record and record.character or nil
    end, nil)

    ability = safeGet("characterRecord.character.ability", function()
        return recordCharacter and recordCharacter.ability or nil
    end, nil)

    return trimXmlValue(ability)
end

local function getUnitInfoAbilityName(unitInfo)
    if type(unitInfo) ~= "table" then return nil end

    local un = unitInfo.unit
    local bUnit = unitInfo.battleUnit

    local directCharacter = safeGet("battleUnit.character", function()
        return bUnit and bUnit.character or nil
    end, nil)

    local ability = getCharacterAbilityNameSafe(directCharacter)
    if ability then return ability end

    directCharacter = safeGet("unit.character", function()
        return un and un.character or nil
    end, nil)

    ability = getCharacterAbilityNameSafe(directCharacter)
    if ability then return ability end

    -- Battle army leader ability is only applied to unitIndex 0 to avoid giving the leader ability to random units.
    if tonumber(unitInfo.unitIndex) == 0 then
        ability = getCharacterAbilityNameSafe(unitInfo.battleCharacter)
        if ability then return ability end
    end

    return nil
end

local function canUseHeroAbilityByXml(unitInfo, unitKey, nowTick)
    if HERO_ABILITY_XML_LIMITS_ENABLE ~= true then return true end

    local state = getState()
    local abilityName = getUnitInfoAbilityName(unitInfo)

    if not abilityName then
        logi("HERO_ABILITY blocked | reason=no character ability | unitType=" .. tostring(unitInfo and unitInfo.unitType))
        return false
    end

    local rules = loadHeroAbilityXmlRules()
    local rule = rules[abilityName]

    if type(rule) ~= "table" then
        logi("HERO_ABILITY blocked | reason=ability not found in xml | ability=" .. tostring(abilityName))
        return HERO_ABILITY_XML_BLOCK_IF_ABILITY_NOT_FOUND ~= true
    end

    local used = tonumber(state.heroAbilityUsesByUnitKey[unitKey]) or 0
    local maxUses = tonumber(rule.activations) or 1

    if used >= maxUses then
        logi("HERO_ABILITY blocked | reason=activations exhausted | ability=" .. tostring(abilityName) .. " | used=" .. tostring(used) .. " | max=" .. tostring(maxUses))
        return false
    end

    local lastUseTick = tonumber(state.heroAbilityLastUseTickByUnitKey[unitKey])
    local cooldownTicks = tonumber(rule.cooldownTicks) or 0

    if lastUseTick and cooldownTicks > 0 and nowTick < lastUseTick + cooldownTicks then
        logi("HERO_ABILITY blocked | reason=cooldown | ability=" .. tostring(abilityName) .. " | remainingTicks=" .. tostring((lastUseTick + cooldownTicks) - nowTick))
        return false
    end

    logi("HERO_ABILITY allowed | ability=" .. tostring(abilityName) .. " | used=" .. tostring(used) .. " | max=" .. tostring(maxUses) .. " | cooldownTicks=" .. tostring(cooldownTicks))
    return true
end

local function registerHeroAbilityUse(unitInfo, unitKey, nowTick)
    if HERO_ABILITY_XML_LIMITS_ENABLE ~= true then return end

    local state = getState()
    local abilityName = getUnitInfoAbilityName(unitInfo) or "unknown"

    state.heroAbilityUsesByUnitKey[unitKey] = (tonumber(state.heroAbilityUsesByUnitKey[unitKey]) or 0) + 1
    state.heroAbilityLastUseTickByUnitKey[unitKey] = tonumber(nowTick) or 0

    logi("HERO_ABILITY registered | ability=" .. tostring(abilityName) .. " | unitKey=" .. tostring(unitKey) .. " | used=" .. tostring(state.heroAbilityUsesByUnitKey[unitKey]))
end

local function processSpecialAbilitiesFromOriginal(battle, aiSide)
    if BATTLE_AI_ASSIST_SPECIAL_ABILITY_ENABLE ~= true then return end

    local state = getState()
    if state.specialAbilityArmed ~= true then return end

    local aiUnits = collectSideUnits(battle, aiSide)
    local maxUnits = tonumber(SPECIAL_ABILITY_MAX_UNITS) or 3
    local used = 0
    local nowTick = tonumber(state.battleTick) or 0

    for i = 1, math.min(maxUnits, #aiUnits) do
        local unitInfo = aiUnits[i]
        local un = unitInfo and unitInfo.unit or nil

        if un and unitIsEngaged(un) and hasMethod(un, "useSpecialAbility") then
            local unitKey = getUnitChoiceKey(un, unitInfo.battleArmyIndex, unitInfo.unitIndex)
            local counter = tonumber(state.specialAbilityCounterByUnitKey[unitKey]) or tonumber(SPECIAL_ABILITY_ARM_COUNTER_START) or 3

            counter = counter + 1
            state.specialAbilityCounterByUnitKey[unitKey] = counter

            if counter >= (tonumber(SPECIAL_ABILITY_USE_COUNTER) or 6) then
                if canUseHeroAbilityByXml(unitInfo, unitKey, nowTick) then
                    local okAbility, errAbility = safeMethod("unit:useSpecialAbility", un, "useSpecialAbility", true)

                    state.specialAbilityCounterByUnitKey[unitKey] = 0

                    if okAbility then
                        used = used + 1
                        registerHeroAbilityUse(unitInfo, unitKey, nowTick)
                    end

                    logi("SPECIAL_ABILITY action | slot=" .. tostring(i)
                        .. " | unitType=" .. tostring(unitInfo.unitType)
                        .. " | ok=" .. tostring(okAbility)
                        .. " | err=" .. tostring(errAbility))
                else
                    state.specialAbilityCounterByUnitKey[unitKey] = 0
                end
            end
        end
    end

    if used > 0 then
        state.specialAbilityArmed = false
        state.specialAbilityCounterByUnitKey = {}
    end

    logi("SPECIAL_ABILITY done | used=" .. tostring(used))
end

local function eventIsMeleeAttackOrUnknown(eventData)
    if type(M2TWEOP) ~= "table" or type(M2TWEOP.condition) ~= "function" then return true end
    local ok, result = safeCall("M2TWEOP.condition BattleIsMeleeAttack", function()
        return M2TWEOP.condition("BattleIsMeleeAttack", eventData)
    end)
    if not ok or result == nil then return true end
    return result == true or result == 1
end

local function armSpecialAbilitiesFromOriginal(reason)
    if BATTLE_AI_ASSIST_SPECIAL_ABILITY_ENABLE ~= true then return end
    local state = getState()
    state.specialAbilityArmed = true
    state.specialAbilityCounterByUnitKey = {}
    logi("SPECIAL_ABILITY armed | reason=" .. tostring(reason))
end

local function processGeneralDefenseFromOriginal(battle, aiSide, aiSideIndex, aiIsAttacker, isSiege, isSally, enemyUnits)
    if BATTLE_AI_ASSIST_GENERAL_DEFENSE_ENABLE ~= true then return end
    if aiIsAttacker ~= true then return end
    if type(unitCategory) ~= "table" or unitCategory.cavalry == nil then return end

    local state = getState()
    local sideKey = tostring(aiSideIndex or "?")
    local record = state.generalDefenseBySide[sideKey]
    local aiUnits = collectSideUnits(battle, aiSide)
    local generalInfo = getFirstUnitInfo(aiUnits)
    if not generalInfo or not generalInfo.unit then return end

    local now = tonumber(state.battleTick) or 0
    if record and record.active == true then
        local shouldRelease = false
        if now >= (tonumber(record.releaseTick) or 0) then shouldRelease = true end
        if getEnemyWithinRadius(generalInfo, enemyUnits, GENERAL_DEFENSE_RELEASE_ENEMY_RADIUS) then shouldRelease = true end
        if shouldRelease then
            local okRelease, errRelease = safeMethod("unit:releaseUnit", generalInfo.unit, "releaseUnit")
            record.active = false
            record.released = true
            logi("GENERAL_DEFENSE release | aiSide=" .. tostring(aiSideIndex) .. " | ok=" .. tostring(okRelease) .. " | err=" .. tostring(errRelease))
        end
        return
    end

    if record and record.released == true then return end
    local enemyHasCavalry = false
    for _, enemyInfo in ipairs(enemyUnits or {}) do
        local enemy = enemyInfo and enemyInfo.unit or nil
        local cat = getUnitCategoryValue(enemy)
        if type(unitCategory) == "table" and unitCategory.cavalry ~= nil and cat == unitCategory.cavalry then enemyHasCavalry = true end
        local text = string.lower(tostring(cat or ""))
        if text == "cavalry" or text:find("cavalry", 1, true) ~= nil then enemyHasCavalry = true end
    end
    if enemyHasCavalry ~= true then return end
    if unitIsMovingFast(generalInfo.unit) ~= true then return end

    local okHalt, errHalt = false, nil
    if hasMethod(generalInfo.unit, "halt") then
        okHalt, errHalt = safeMethod("unit:halt", generalInfo.unit, "halt")
    end
    local waitTicks = getGeneralHoldTicks(#enemyUnits)
    state.generalDefenseBySide[sideKey] = {
        active = true,
        released = false,
        startTick = now,
        releaseTick = now + waitTicks,
        unitKey = getUnitChoiceKey(generalInfo.unit, generalInfo.battleArmyIndex, generalInfo.unitIndex),
    }
    logi("GENERAL_DEFENSE halt | aiSide=" .. tostring(aiSideIndex) .. " | waitTicks=" .. tostring(waitTicks) .. " | ok=" .. tostring(okHalt) .. " | err=" .. tostring(errHalt))
end

local function issueScriptCommand(command, args)
    local ok, err = safeCall("M2TWEOP.scriptCommand " .. tostring(command), function()
        if type(M2TWEOP) ~= "table" or type(M2TWEOP.scriptCommand) ~= "function" then return nil end
        return M2TWEOP.scriptCommand(command, args)
    end)
    logi("SCRIPT_COMMAND | command=" .. tostring(command) .. " | args=" .. tostring(args) .. " | ok=" .. tostring(ok) .. " | err=" .. tostring(err))
    return ok
end

local function setGtaPlanFromOriginal(sideIndex, planName)
    if not canIssueGtaOrder(sideIndex, "plan_" .. tostring(planName)) then return end
    issueScriptCommand("ai_gta_plan_set", tostring(sideIndex) .. " " .. tostring(planName))
    issueScriptCommand("ai_active_set", "on")
end

local function addGtaObjectiveFromOriginal(sideIndex, objectiveName)
    if not canIssueGtaOrder(sideIndex, "objective_" .. tostring(objectiveName)) then return end
    issueScriptCommand("ai_gta_add_objective", tostring(sideIndex) .. " " .. tostring(objectiveName) .. " 999")
end

local function applyOriginalGtaSetup(sideIndex, aiSide, aiIsAttacker, isSiege, isSally, isOpenBattle)
    if not aiSide then return end

    -- Open battle generic attack behavior from the old conversion is intentionally not copied here.
    -- Only siege / sallyout plans that directly match the original battle-script commands are kept.
    if isSiege == true and isSally ~= true then
        if aiIsAttacker == true then
            setGtaPlanFromOriginal(sideIndex, "ATTACK_SETTLEMENT")
        else
            addGtaObjectiveFromOriginal(sideIndex, "DEFEND_LINE")
            setGtaPlanFromOriginal(sideIndex, "DEFEND_SETTLEMENT")
        end
    elseif isSally == true then
        if aiIsAttacker == true then
            setGtaPlanFromOriginal(sideIndex, "SALLY_OUT")
        else
            addGtaObjectiveFromOriginal(sideIndex, "DEFEND_LINE")
            setGtaPlanFromOriginal(sideIndex, "DEFEND_FEATURE")
        end
    end
end

local function runDeploymentOnly(eventData)
    local battle = getBattle()
    if not battle then logi("DEPLOYMENT stop | no battle"); return end
    local sides, sidesNum = getSides(battle)
    if not sides or sidesNum <= 0 then logi("DEPLOYMENT stop | no sides"); return end

    local playerSideIndex, aiSideIndexes = detectSides(battle, sides, sidesNum)
    if playerSideIndex == nil or not aiSideIndexes or #aiSideIndexes <= 0 then
        logi("DEPLOYMENT stop | sides unresolved")
        return
    end

    local playerSide = getSide(sides, playerSideIndex + 1)
    local isSiege, isSally = getBattleTypeFlags(battle)
    for _, aiSideIndex in ipairs(aiSideIndexes) do
        local aiSide = getSide(sides, aiSideIndex + 1)
        if aiSide then
            local aiIsAttacker = safeBool("aiSide.isDefender deploy", function() return aiSide.isDefender == false end, true)
            deployStakesFromOriginal(battle, playerSide, aiSide, aiSideIndex, aiIsAttacker, isSiege, isSally)
        end
    end
end

local function runBattleAiAssist(eventData, reason)
    local battle = getBattle()
    if not battle then logi("STOP no battle | reason=" .. tostring(reason)); return end
    local sides, sidesNum = getSides(battle)
    if not sides or sidesNum <= 0 then logi("STOP no sides | reason=" .. tostring(reason)); return end

    local playerSideIndex, aiSideIndexes = detectSides(battle, sides, sidesNum)
    if playerSideIndex == nil or not aiSideIndexes or #aiSideIndexes <= 0 then
        logi("STOP sides unresolved | playerSideIndex=" .. tostring(playerSideIndex))
        return
    end

    local playerSide = getSide(sides, playerSideIndex + 1)
    local enemyUnitsForAi = playerSide and collectSideUnits(battle, playerSide, true) or {}
    local isSiege, isSally, isOpenBattle = getBattleTypeFlags(battle)

    for _, aiSideIndex in ipairs(aiSideIndexes) do
        local aiSide = getSide(sides, aiSideIndex + 1)
        if aiSide then
            local aiIsAttacker = safeBool("aiSide.isDefender", function() return aiSide.isDefender == false end, true)
            logi("RUN | reason=" .. tostring(reason) .. " | aiSide=" .. tostring(aiSideIndex) .. " | aiIsAttacker=" .. tostring(aiIsAttacker) .. " | siege=" .. tostring(isSiege) .. " | sally=" .. tostring(isSally) .. " | open=" .. tostring(isOpenBattle))

            applyOriginalGtaSetup(aiSideIndex, aiSide, aiIsAttacker, isSiege, isSally, isOpenBattle)
            deployStakesFromOriginal(battle, playerSide, aiSide, aiSideIndex, aiIsAttacker, isSiege, isSally)
            forceForcedGateAttackUnitsRun(battle, aiSide)
            forceSettlementRuleHalts(battle, aiSide, aiIsAttacker, isSiege, isSally)
            processGeneralDefenseFromOriginal(battle, aiSide, aiSideIndex, aiIsAttacker, isSiege, isSally, enemyUnitsForAi)
            processSpecialAbilitiesFromOriginal(battle, aiSide)
            forceGateAttackUnitsMeleeAfterBreach(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnitsForAi)
            forceGateWallUnits(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnitsForAi)
            forceDefenderArtillery(battle, aiSide, aiIsAttacker, isSiege, isSally, enemyUnitsForAi, eventData)
            forceSallyOutAttackers(battle, aiSide, aiIsAttacker, isSally, enemyUnitsForAi)
            forceEmptyAmmoMeleeForGateAttackUnits(battle, aiSide, enemyUnitsForAi, not (isSiege == true or isSally == true))
        end
    end
end

local function processTick(eventData)
    local state = getState()
    local now = tonumber(state.battleTick) or 0
    local interval = tonumber(BATTLE_AI_ASSIST_TICK_INTERVAL) or 30
    if now - (tonumber(state.lastProcessTick) or -999999) < interval then return end
    state.lastProcessTick = now
    runBattleAiAssist(eventData or state.lastEventData, "tick")
end

function onBattleAiCommenced(eventData)
    local ok, err = pcall(function()
        local state = getState()
        state.lastEventData = eventData
        runBattleAiAssist(eventData, "battle_ai_commenced")
    end)
    if not ok then logi("FATAL onBattleAiCommenced | err=" .. tostring(err)) end
end

function onBattleDeploymentPhaseCommenced(eventData)
    --in_campaign_map = false
    disablePlayerSkirmishMode()
    resetState("battle_deployment")
    local state = getState()
    state.lastEventData = eventData
    runDeploymentOnly(eventData)
end

function onBattleDelayPhaseCommenced(eventData)
    local state = getState()
    state.lastEventData = eventData
end

function onBattleConflictPhaseCommenced(eventData)
    local ok, err = pcall(function()
        local state = getState()
        state.conflictStarted = true
        state.lastEventData = eventData
        runBattleAiAssist(eventData, "battle_conflict")
    end)
    if not ok then logi("FATAL onBattleConflictPhaseCommenced | err=" .. tostring(err)) end
end

function onBattleTick()
    local ok, err = pcall(function()
        local state = getState()
        state.battleTick = (tonumber(state.battleTick) or 0) + 1
        if state.conflictStarted == true then processTick(state.lastEventData) end
    end)
    if not ok then logi("FATAL onBattleTick | err=" .. tostring(err)) end
end

function onBattleReinforcementsArrive(eventData)
    local state = getState()
    state.lastEventData = eventData or state.lastEventData
    runBattleAiAssist(eventData or state.lastEventData, "reinforcements")
end

function onBattleArmyHalfDestroyed(eventData)
    local state = getState()
    state.lastEventData = eventData or state.lastEventData
    runBattleAiAssist(eventData or state.lastEventData, "army_half_destroyed")
end

function onBattlePlayerArmyHalfDestroyed(eventData)
    onBattleArmyHalfDestroyed(eventData)
end

function onBattnemyArmyHalfDestroyed(eventData)
    onBattleArmyHalfDestroyed(eventData)
end

function onBattleEnemyUnitAttacksPlayerUnit(eventData)
    local state = getState()
    state.lastEventData = eventData or state.lastEventData
    if eventIsMeleeAttackOrUnknown(eventData) then
        armSpecialAbilitiesFromOriginal("enemy_attacks_player")
    end
end

function onBattnemyUnitAttacksPlayerUnit(eventData)
    onBattleEnemyUnitAttacksPlayerUnit(eventData)
end

function onBattlePlayerUnitAttacksEnemyUnit(eventData)
    local state = getState()
    state.lastEventData = eventData or state.lastEventData
    if eventIsMeleeAttackOrUnknown(eventData) then
        armSpecialAbilitiesFromOriginal("player_attacks_enemy")
    end
end

function onBattleFinished(eventData)
    resetState("battle_finished")
end

function onBattleGatesDestroyedByEngine(eventData)
    local state = getState()
    state.lastEventData = eventData or state.lastEventData
    markGateWallBreachForMelee("gate_destroyed")
    runBattleAiAssist(eventData or state.lastEventData, "gate_destroyed")
end

function onBattleWallsBreachedByEngine(eventData)
    local state = getState()
    state.lastEventData = eventData or state.lastEventData
    markGateWallBreachForMelee("wall_breached")
    runBattleAiAssist(eventData or state.lastEventData, "wall_breached")
end

-- Kept only to avoid errors from older luaPluginScript hooks. It no longer activates generic fallback behavior.
function activateNearestEnemyAfterStructureBreach(eventData)
    local state = getState()
    state.lastEventData = eventData or state.lastEventData
    if state.gateWallBreachDetectedTick == nil then
        markGateWallBreachForMelee("structure_breach")
    end
    runBattleAiAssist(eventData or state.lastEventData, "structure_breach")
end


function disablePlayerSkirmishMode()
    if not game_options.disable_skirmish then return end
        local battle = getBattle()
        local sides, sidesNum = getSides(battle)
        local playerSideIndex, aiSideIndex, aiSideIndexes = detectSides(battle, sides, sidesNum)
        local playerSide = getSide(sides, playerSideIndex + 1)
    
        for a = 0, playerSide.battleArmyNum - 1 do
            local bArmy = playerSide:getBattleArmy(a)
            if bArmy and bArmy.army then
                local army = bArmy.army
                for u = 0, army.numOfUnits - 1 do
                    local un = army:getUnit(u)
                    if un:hasBattleProperty(unitBattleProperties.skirmish) then
                        un:setBattleProperty(unitBattleProperties.skirmish, false)
                    end
                end
            end
        end
    end