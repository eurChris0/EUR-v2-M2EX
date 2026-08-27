local MergingArmies = {}

-- Constants for army merging
local MAX_MERGE_DISTANCE = 7  -- Maximum distance between armies to allow merging
local MAX_COMBINED_UNITS = 20 -- Maximum number of units in merged army

-- Leader type IDs
local LEADER_TYPES = {
    ADMIRAL = 3, -- Naval commander
    GENERAL = 6, -- Land army general
    CAPTAIN = 7  -- Secondary commander
}

-- Get current turn number from campaign
-- @return number Current turn number or 0 if campaign is not loaded
local function getCurrentTurn()
    if not CAMPAIGN then
        M2TWEOP.logGame("[ERROR] MergingArmies: CAMPAIGN is nil")
        return 0
    end
    return CAMPAIGN.turnNumber
end

-- Calculate distance between a character and a point
--- @param army armyStruct -- The army to measure from
--- @param targetArmy armyStruct -- The target army to measure to
--- @return number -- The distance between the points
local function distanceFromPoint(army, targetArmy)
    if not army or not targetArmy then
        M2TWEOP.logGame("[ERROR] MergingArmies: Invalid army for distance calculation")
        return math.huge
    end

    local xFrom, yFrom = army.xCoord, army.yCoord
    local xTo, yTo = targetArmy.xCoord, targetArmy.yCoord
    local xMax, xMin = math.max(xFrom, xTo), math.min(xFrom, xTo)
    local yMax, yMin = math.max(yFrom, yTo), math.min(yFrom, yTo)
    local xSegment, ySegment = xMax - xMin, yMax - yMin
    local hypotenuse = math.sqrt(xSegment ^ 2 + ySegment ^ 2)
    return hypotenuse
end

-- Log army merging events
--- @param targetStack armyStruct -- The stack being merged into
--- @param mergeType string -- The type of merge being performed ("army", "fleet", or "fleet+army")
local function mergeLogPrint(targetStack, mergeType)
    local message = string.format("[INFO] mergeAiArmies %s: %s, %s, coords: %d, %d",
        mergeType,
        targetStack.faction.name,
        targetStack.leader.characterRecord.fullName,
        targetStack.leader.xCoord,
        targetStack.leader.yCoord)
   -- print(message)
    M2TWEOP.logGame(message)
end

-- Attempt to merge nearby armies with the target stack
-- @param targetStack The stack to merge other armies into
-- @return boolean True if any armies were merged, false otherwise
---@param targetArmy armyStruct
local function mergeAiArmies(targetArmy)
    if not targetArmy or not targetArmy.faction then
        M2TWEOP.logGame("[ERROR] MergingArmies: Invalid target stack or faction")
        return false
    end

    local didMerge = false
    for i = 0, targetArmy.faction.armiesNum - 1 do
        local army = targetArmy.faction:getArmy(i)

        -- Early safety checks
        if not army then
            M2TWEOP.logGame("[ERROR] MergingArmies: Failed to get army " .. i)
            goto continue
        end

        if not army.leader then
            goto continue
        end

        if targetArmy == army then
            goto continue
        end

        if army.siege then
            goto continue
        end

        -- Check distance between armies
        local distance = distanceFromPoint(army, targetArmy)
        if distance > MAX_MERGE_DISTANCE then
            goto continue
        end

        -- Check leader types
        local armyLeaderType = army.leader:getTypeID()
        local targetArmyLeaderType = targetArmy.leader:getTypeID()

        if not armyLeaderType or not targetArmyLeaderType then
            M2TWEOP.logGame("[ERROR] MergingArmies: Invalid leader type - stack: " ..
                tostring(armyLeaderType) .. ", target: " .. tostring(targetArmyLeaderType))
            goto continue
        end

        -- Check combined army size
        local totalUnits = army.numOfUnits + targetArmy.numOfUnits
        if totalUnits >= MAX_COMBINED_UNITS then
            goto continue
        end

        -- Check leader type compatibility
        -- Only merge if both are generals, or one is a general and one is a captain
        local isCompatible = (armyLeaderType == LEADER_TYPES.GENERAL and targetArmyLeaderType == LEADER_TYPES.GENERAL) or
            (armyLeaderType == LEADER_TYPES.GENERAL and targetArmyLeaderType == LEADER_TYPES.CAPTAIN) or
            (armyLeaderType == LEADER_TYPES.CAPTAIN and targetArmyLeaderType == LEADER_TYPES.GENERAL)

        if not isCompatible then
            goto continue
        end

        -- Perform merging based on army type
        if targetArmyLeaderType ~= LEADER_TYPES.ADMIRAL then
            -- Land armies
            local success, error = pcall(function()
                army:mergeArmies(targetArmy)
            end)
            if not success then
                M2TWEOP.logGame("[ERROR] MergingArmies: Failed to merge armies: " .. tostring(error))
            else
                didMerge = true
                mergeLogPrint(targetArmy, "army")
            end
        elseif targetArmyLeaderType == LEADER_TYPES.ADMIRAL then
            -- Naval armies - handle both fleets and transported armies
            if not targetArmy.boardedArmy and not army.boardedArmy then
                -- Merge empty fleets
                local success, error = pcall(function()
                    army:mergeArmies(targetArmy)
                end)
                if not success then
                    M2TWEOP.logGame("[ERROR] MergingArmies: Failed to merge fleets: " .. tostring(error))
                else
                    didMerge = true
                    mergeLogPrint(targetArmy, "fleet")
                end
            elseif army.boardedArmy and targetArmy.boardedArmy
                and army.boardedArmy.numOfUnits + targetArmy.boardedArmy.numOfUnits <= MAX_COMBINED_UNITS then
                -- Merge fleets with transported armies
                local success, error = pcall(function()
                    army.boardedArmy:mergeArmies(targetArmy.boardedArmy)
                    army:mergeArmies(targetArmy)
                end)
                if not success then
                    M2TWEOP.logGame("[ERROR] MergingArmies: Failed to merge fleets with armies: " .. tostring(error))
                else
                    didMerge = true
                    mergeLogPrint(targetArmy, "fleet+army")
                end
            end
        end

        ::continue::
    end
    return didMerge
end


-- Merge AI armies that are close to each other for a specific faction
--- @param faction factionStruct -- The faction whose armies should be merged
--- @return boolean -- True if any armies were merged, false otherwise
function MergingArmies.mergeFactionArmies(faction)
    -- Safety checks with logging
    if not faction then
        M2TWEOP.logGame("[ERROR] MergingArmies: faction is nil")
        return false
    end

    if faction.isPlayerControlled == 1 then
        return false
    end

    if not faction.armiesNum then
        M2TWEOP.logGame("[ERROR] MergingArmies: faction.armiesNum is nil for faction: " .. faction.name)
        return false
    end

    local currentTurn = getCurrentTurn()
    -- Skip if not on cooldown turn
    if currentTurn % CampaignState.Settings.MergingArmies.Cooldown ~= 0 then
        return false
    end

    local didMerge = false

    -- Process each stack in the faction
    for a = 0, faction.armiesNum - 1 do
        local targetArmy = faction:getArmy(a)
        if not targetArmy then
            M2TWEOP.logGame("[ERROR] MergingArmies: Failed to get army " ..
                a .. " for faction: " .. faction.name)
        elseif targetArmy.leader then
            -- To check if any armies were merged at this turn
            didMerge = mergeAiArmies(targetArmy) or didMerge
        end
    end

    return didMerge
end

return MergingArmies
