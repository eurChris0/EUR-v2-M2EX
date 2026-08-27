--[[
    Post-Battle Loot Module
    ======================
    This module handles the calculation and distribution of loot after battles.
    It supports two calculation methods:
    1. Unit-cost based: Calculates loot based on the value of lost units
    2. Fixed-amount based: Uses a base amount defined in settings

    Features:
    - Small army penalty: Reduces loot for armies with less than 11 units
    - Victory type modifiers: Adjusts loot based on victory type (Close/Average/Clear/Crushing)
    - Unit cost calculation: Considers recruitment cost, armor, and weapon upgrades

    Settings (controlled via UI):
    - Enabled: Master toggle for the feature
    - UseUnitCosts: Whether to use unit costs or base amount
    - SmallArmyPenalty: Whether to reduce loot for small armies
    - BaseAmount: Fixed amount when not using unit costs
    - VictoryTypeModifier: Whether to modify loot based on victory type
]]

-- Import text resources
local TextRes = require('eur/EurTextResources').Events.PostBattleLoot

-- Constants
local EVENT_TYPE = "post_battle_loot"

-- Module for handling post-battle loot calculations and rewards
PostBattleLoot = {}

-- Handles successful loot acquisition
-- @param finalLoot number The final calculated loot amount
local function handlePositiveLoot(finalLoot)
    -- Add money to player's treasury using console command
    print("POST BATTLE LOOT GIVEN")
    print("Adding " .. finalLoot .. " gold")
    stratmap.game.callConsole("add_money", tostring(finalLoot))

    -- Create historic event notification to inform player
    stratmap.game.historicEvent(EVENT_TYPE, TextRes.PositiveLoot.Title,
        string.format(TextRes.PositiveLoot.Message, finalLoot))
end

-- Handles unsuccessful loot scenarios (when losses are more than loot)
-- Called when no valuable loot was found or losses exceeded gains
local function handleNegativeLoot()
    stratmap.game.historicEvent(EVENT_TYPE, TextRes.NegativeLoot.Title,
        TextRes.NegativeLoot.Message)
end

--[[
    Main post-battle check function
    Calculates and awards loot after a battle based on:
    - Unit losses on both sides
    - Army sizes
    - Victory type
    - Settings configuration

    Process:
    1. Verify player faction and victory
    2. Count units and calculate losses
    3. Apply modifiers (small army penalty, victory type)
    4. Award final loot amount

    ]]
---@param faction factionStruct -- The faction that fought in the battle
function PostBattleLoot.postBattleCheck(faction)
    if CAMPAIGN == nil then
        return
    end
    -- Only process for player-controlled faction
    if faction.isPlayerControlled == 0 then
        return
    end

    -- Track battle statistics
    local totalPlayerAndAlliedUnitCount = 0 -- Total units in player's army and allied armies
    local totalPlayerAndAlliedGoldLoss = 0  -- Value of player's losses
    local totalEnemyGoldLoss = 0            -- Value of enemy's losses
    local isPlayerSideWon = false           -- Whether player's side won
    local victoryType                       -- Type of victory achieved

    -- Iterate through all sides in the battle
    for s = 1, BATTLE.sidesNum do -- 1-indexed
        local isPlayer = false
        local side = BATTLE.sides[s]

        -- Figure out which side is the player
        for f = 0, side.factionCount - 1 do
            local fac = side:getFaction(f)
            if fac.isPlayerControlled == 1 then
                isPlayer = true
                break
            end
        end

        -- Record victory status and type if player's side
        if isPlayer then
            isPlayerSideWon = side.wonBattle == 2
        end
        if isPlayerSideWon then
            victoryType = side.battleSuccess
        end

        -- Process each army in the battle
        for a = 0, side.battleArmyNum - 1 do
            local battleArmy = side:getBattleArmy(a)

            -- Safety check for valid army
            if battleArmy == nil then
                print("ERROR: No battle army found")
                M2TWEOP.logGame("[ERROR] PostBattleLoot: No battle army found")
                return
            end

            -- Count units for small army penalty calculation
            local unitCount = battleArmy.unitCount
            if isPlayer then
                totalPlayerAndAlliedUnitCount = totalPlayerAndAlliedUnitCount + unitCount
            end

            -- Calculate unit-based losses if enabled
            if CampaignState.Settings.PostBattleLoot.UseUnitCosts then
                for u = 0, unitCount - 1 do
                    local battleUnit = battleArmy:getBattleUnit(u)
                    if battleUnit == nil then
                        print("ERROR: No previous battle player unit found")
                        M2TWEOP.logGame("[ERROR] PostBattleLoot: No previous battle player unit found")
                        return
                    end

                    -- Calculate unit value based on:
                    -- 1. Base recruitment cost
                    -- 2. Armor upgrades
                    -- 3. Weapon upgrades
                    local unitSoldiersBeforeBattle = battleUnit.soldiersStart
                    local unitSoldiersAfterBattle = battleUnit.soldiersEnd
                    local maxUnitSoldiers = battleUnit.unit.soldierCountStratMapMax

                    local unitRecruitCost = battleUnit.unit.eduEntry.recruitCost
                    local unitArmorCost = battleUnit.unit.armourLVL * battleUnit.unit.eduEntry.armourCost
                    local unitWeaponCost = battleUnit.unit.weaponLVL * battleUnit.unit.eduEntry.weaponCost

                    -- Calculate total unit value and per-soldier cost
                    local unitMaxCost = unitRecruitCost + unitArmorCost + unitWeaponCost
                    local unitCostPerSoldier = unitMaxCost / maxUnitSoldiers

                    -- Calculate value before and after battle
                    local unitCostBeforeBattle = unitCostPerSoldier * unitSoldiersBeforeBattle
                    local unitCostAfterBattle = unitCostPerSoldier * unitSoldiersAfterBattle

                    -- Track losses for appropriate side
                    local unitGoldLoss = unitCostBeforeBattle - unitCostAfterBattle
                    if isPlayer then
                        totalPlayerAndAlliedGoldLoss = totalPlayerAndAlliedGoldLoss + unitGoldLoss
                    else
                        totalEnemyGoldLoss = totalEnemyGoldLoss + unitGoldLoss
                    end
                end
            end
        end
    end

    -- Only proceed if player won
    if not isPlayerSideWon then
        return
    end

    -- Calculate final loot amount
    local finalGoldDifference = 0

    -- Use either unit-based calculation or base amount
    if CampaignState.Settings.PostBattleLoot.UseUnitCosts then
        finalGoldDifference = totalEnemyGoldLoss - totalPlayerAndAlliedGoldLoss
    else
        finalGoldDifference = CampaignState.Settings.PostBattleLoot.BaseAmount
    end

    if finalGoldDifference > 0 then
        -- Apply small army penalty if enabled
        if CampaignState.Settings.PostBattleLoot.SmallArmyPenalty then
            if totalPlayerAndAlliedUnitCount < 11 then
                finalGoldDifference = finalGoldDifference * 0.7 -- 30% penalty
            end
        end

        -- Apply victory type modifiers if enabled
        if CampaignState.Settings.PostBattleLoot.VictoryTypeModifier then
            -- Victory type modifiers:
            -- 0 (Close Victory): 70% of base loot
            -- 1 (Average Victory): 100% of base loot
            -- 2 (Clear Victory): 120% of base loot
            -- 3 (Crushing Victory): 150% of base loot
            if victoryType == 0 then
                finalGoldDifference = finalGoldDifference * 0.35
            elseif victoryType == 1 then
                finalGoldDifference = finalGoldDifference * 0.5
            elseif victoryType == 2 then
                finalGoldDifference = finalGoldDifference * 0.6
            elseif victoryType == 3 then
                finalGoldDifference = finalGoldDifference * 0.75
            end
        end

        -- Round down to nearest integer
        finalGoldDifference = math.floor(finalGoldDifference)

        handlePositiveLoot(finalGoldDifference)
    else
        handleNegativeLoot()
    end
end

return PostBattleLoot
