local Replenishment = {}

-- Constants for replenishment calculations
local FIELD_REPLENISHMENT_DIVISOR = 2 -- Divides replenishment rate when not in settlement/fort
local replen_beast_value = 120 -- Units with this exact number or less than 8 will not replenish
local replen_min_value = 8 -- Minimum threshold for replenishment

-- Check if army can replenish in current position
-- Considers territory ownership and settings
---@param army armyStruct -- The army to check
---@param faction factionStruct -- The faction that owns the army
---@return boolean -- Whether the army can replenish in its current position
local function canReplenishHere(army, faction)
    -- Skip if army is invalid
    if not army then
        M2TWEOP.logGame("[ERROR] Replenishment: Invalid army")
        return false
    end

    -- Skip if faction is invalid
    if not faction then
        M2TWEOP.logGame("[ERROR] Replenishment: Invalid faction")
        return false
    end

    -- Check if army is in a settlement
    local settlement = army:findInSettlement()
    if settlement then
        -- Check if settlement has a valid faction
        if not settlement.ownerFaction then
            M2TWEOP.logGame("[ERROR] Replenishment: Settlement has no faction")
            return false
        end

        -- Always allow replenishment in own settlements
        if settlement.ownerFaction == faction then
            return true
        end

        -- Check diplomatic standing for foreign settlements
        local standing = settlement.ownerFaction:getFactionStanding(faction)
        return standing == "ally" or standing == "protector" or standing == "vassal"
    end

    -- If territory-only setting is enabled, require settlement/fort
    if CampaignState.Settings.Replenishment.OnlyInOwnTerritory then
        local fort = army:findInFort()
        if not fort then
            M2TWEOP.logGame("[INFO] Replenishment: Army not in settlement/fort, territory-only enabled")
            return false
        end
        -- Check if fort has a valid faction
        if not fort.ownerFaction then
            M2TWEOP.logGame("[ERROR] Replenishment: Fort has no faction")
            return false
        end
        -- Check fort ownership
        return fort.ownerFaction == faction
    end

    -- Allow replenishment in the field if territory-only is disabled
    return true
end

-- Process replenishment for a faction's armies
---@param faction factionStruct -- The faction whose armies should be replenished
function Replenishment.replenishArmies(faction)
    -- Skip if feature is disabled
    if not CampaignState.Settings.Replenishment.Enabled then
        return
    end

    -- Skip if AI and AI replenishment is disabled
    if faction.isPlayerControlled == 0 and not CampaignState.Settings.Replenishment.EnableForAI then
        return
    end

    -- Skip rebel faction
    if faction.name == 'slave' then
        return
    end

    -- Process each stack in the faction
    for a = 0, faction.armiesNum - 1 do
        local army = faction:getArmy(a)

        -- Skip if army is on a ship (either as cargo or the ship itself)
        if army and
            army.boardedArmy == nil and
            army.shipArmy == nil and
            canReplenishHere(army, faction) then
            -- Process each unit in the stack
            for u = 0, army.numOfUnits - 1 do
                local unit = army:getUnit(u)
                if unit and unit.eduEntry then
                    local soldierCount = unit.eduEntry.soldierCount
                    -- Calculate replenishment amount based on percentage
                    local soldierCount = unit.eduEntry.soldierCount
                    
                    -- Restrict replenishment for units with soldier count < 8 or exactly 120
                    if soldierCount < replen_min_value or soldierCount == replen_beast_value then
                        M2TWEOP.logGame("[INFO] Replenishment: Skipping " .. unit.eduEntry.eduType .. " (restriction)")
                        goto continue
                    end   					   
					
                    local maxSoldiers = unit.soldierCountStratMapMax
                    local currentSoldiers = unit.soldierCountStratMap
                    local baseReplenishAmount = math.floor(maxSoldiers *
                        (CampaignState.Settings.Replenishment.ReplenishmentPercent / 100))

                    -- Reduce amount by half if not in settlement/fort
                    local inSettlement = army:findInSettlement() ~= nil
                    local inFort = army:findInFort() ~= nil
                    local replenishAmount = (inSettlement or inFort) and baseReplenishAmount or
                        math.floor(baseReplenishAmount / FIELD_REPLENISHMENT_DIVISOR)

                    -- Apply replenishment without exceeding max unit size
                    if (currentSoldiers + replenishAmount < maxSoldiers) then
                        unit.soldierCountStratMap = currentSoldiers + replenishAmount
                        M2TWEOP.logGame("[INFO] Replenishment: Added " .. replenishAmount ..
                            " soldiers to " .. unit.eduEntry.eduType)
                    else
                        local actualIncrease = maxSoldiers - currentSoldiers
                        unit.soldierCountStratMap = maxSoldiers
                        if actualIncrease > 0 then
                            M2TWEOP.logGame("[INFO] Replenishment: Added " .. actualIncrease ..
                                " soldiers to " .. unit.eduEntry.eduType .. " (max reached)")
                        end
                    end
                end
                ::continue::
            end
        end
    end
end

-- Export the module
return Replenishment
