local ElvenPassing = {}

-- Import text resources
local TextRes = require('eur/EurTextResources').Events.ElvenPassing

---@class EurElvenPassing.EnemyMapping
---@field [integer] string

---@type table<string, string[]>
MAIN_ENEMIES_FOR_FACTION = {
    -- hre - Moria
    -- portugal - Angmar
    -- gundabad - Gundabad
    -- france - Isengard
    -- poland - DG
    -- normans - Blue Crag

    ["saxons"] = { -- Imladris
        "hre",
        "portugal",
    },
    ["denmark"] = { -- Lindon
        "portugal",
        "normans",
    },
    ["mongols"] = { -- WR
        "gundabad",
        "poland",
    },
    ["ireland"] = { -- Lothlorien
        "france",
        "poland",
    },
}

---@class EurElvenPassing.CoreSettlements
---@field [integer] string

---@type table<string, string[]>
local CORE_SETTLEMENTS_FOR_FACTION = {
    -- Imladris (saxons)
    ["saxons"] = {
        "Imladris", -- Imladris (Hidden Valley)
        "Eregion",  -- Ost-en-Edhil (Eregion)
    },

    -- Woodland Realm (mongols)
    ["mongols"] = {
        "Elven_Mirkwood",       -- Thranduil's Hall (Woodland Realm)
        "South_Elven_Mirkwood", -- Taur Philinn (Elven Acres)
        "West_Mirkwood",        -- Emyn-nu-Fuin (Mountains of Mirkwood)
        "Central_Mirkwood",     -- Dol Guldur (Old Forest Road)
        "Deep_Mirkwood",        -- Dol Guldur (Naked Hill)
    },

    -- Lothlorien (ireland)
    ["ireland"] = {
        "Celebrant",     -- Caras Galadhon (Lothlórien)
        "Lothlorien",    -- Linhir (Limlight Fields)
        "Border",        -- Edraicharn (Field of Celebrant)
        "Deep_Mirkwood", -- Dol Guldur (Naked Hill)
    },

    -- Lindon (denmark)
    ["denmark"] = {
        "Mithlond",    -- Mithlond (Grey Havens)
        "Emyn_Beraid", -- Undertowers (Emyn Beraid)
        "Evendim",     -- Ost Gelon (Eastern Numeriador)
    },

    -- Gundabad (gundabad)
    ["gundabad"] = {
        "Mt_Gundabad",    -- Mount Gundabad
        "Lune",           -- Buzrakûl
        "Grey_Mountains", -- Dáin's Halls
    },

    -- Dol Guldur (poland)
    ["poland"] = {
        "Deep_Mirkwood",      -- Dol Guldur
        "New_Mirkwood",       -- Ost-in-Geil
        "East_Deep_Mirkwood", -- Dor Lhingvar
    },

    -- Moria (hre)
    ["hre"] = {
        "East_Moria",        -- Khazad-dûm
        "West_Moria",        -- Khazad-dûm West
        "Central_Mountains", -- Zagh Kala
        "High_Pass",         -- Goblin-town
    },

    -- Angmar (portugal)
    ["portugal"] = {
        "Carn_Dum",   -- Carn Dûm
        "Angsul",     -- Angsûl
        "Litash",     -- Litash
        "Ettenmoors", -- Morva Tarth
    },

    -- Blue Crag (normans)
    ["normans"] = {
        "Shire_South",     -- Rath Teraig
        "South_Ered_Luin", -- Buzra-dûm
        "Shire_North",     -- Orodost
    },
}

-- Settlements that are exempt from population decline
-- Usually representing sacred or protected Elven realms
---@type table<string, boolean>
local EXCLUDED_SETTLEMENTS = {
    ["Eregion"] = true,
}

---@class EurElvenPassing.StageEffects
---@field populationLossPercent integer
---@field goldPerElf integer

---@class EurElvenPassing.EventStage
---@field minProgress integer
---@field maxProgress integer
---@field title string
---@field description string
---@field effects EurElvenPassing.StageEffects

---@type EurElvenPassing.EventStage[]
local EVENT_STAGES = {
    {
        -- So this stage is active when event progress is between 0 and 25, etc.
        minProgress = 0,
        maxProgress = 24,
        title = TextRes.Stages[1].Title, -- Critical
        description = TextRes.Stages[1].Description,
        effects = {
            populationLossPercent = 15,
            goldPerElf = 15,
        }
    },
    {
        minProgress = 25,
        maxProgress = 49,
        title = TextRes.Stages[2].Title, -- Strong
        description = TextRes.Stages[2].Description,
        effects = {
            populationLossPercent = 10,
            goldPerElf = 10,
        }
    },
    {
        minProgress = 50,
        maxProgress = 74,
        title = TextRes.Stages[3].Title, -- Moderate
        description = TextRes.Stages[3].Description,
        effects = {
            populationLossPercent = 7,
            goldPerElf = 7,
        }
    },
    {
        minProgress = 75,
        maxProgress = 99,
        title = TextRes.Stages[4].Title, -- Weakening
        description = TextRes.Stages[4].Description,
        effects = {
            populationLossPercent = 5,
            goldPerElf = 5,
        }
    },
    {
        minProgress = 100,
        maxProgress = 100,
        title = TextRes.Stages[5].Title, -- Resisted
        description = TextRes.Stages[5].Description,
        effects = {
            populationLossPercent = 0,
            goldPerElf = 0,
        }
    }
}

-- Helper function to check if a settlement is a core settlement for a faction
---@param settlement settlementStruct
---@param faction factionStruct
---@return boolean
local function isCoreSettlementForFaction(settlement, faction)
    local coreSettlements = CORE_SETTLEMENTS_FOR_FACTION[faction.name]
    if not coreSettlements then
        return false
    end

    for _, coreName in ipairs(coreSettlements) do
        if coreName == settlement.name then
            return true
        end
    end
    return false
end

---@param settlement settlementStruct
---@param faction factionStruct
---@return boolean
local function isCoreSettlementForMainEnemy(settlement, faction)
    local enemyNames = MAIN_ENEMIES_FOR_FACTION[faction.name]
    if not enemyNames then
        return false
    end

    for _, enemyName in ipairs(enemyNames) do
        local enemyFaction = getFactionbyName(enemyName)
        if not enemyFaction then
            print("Enemy faction not found: " .. enemyName)
            M2TWEOP.logGame("Enemy faction not found: " .. enemyName)
            goto continue
        end

        if isCoreSettlementForFaction(settlement, enemyFaction) then
            return true
        end

        ::continue::
    end

    return false
end

---@param elvenFaction string
---@return string[]
function ElvenPassing.getMainEnemiesForElvenFaction(elvenFaction)
    return MAIN_ENEMIES_FOR_FACTION[elvenFaction] or {}
end

-- Helper function to apply stage effects
---@param faction factionStruct The faction to apply effects to
---@param stage EurElvenPassing.EventStage The current stage data
local function applyStageEffects(faction, stage)
    local stageEffects = stage.effects

    local totalPopulationLoss = 0
    local totalGoldLoss = 0

    -- Calculate population loss
    if stageEffects.populationLossPercent > 0 then
        local settlementsNum = faction.settlementsNum

        local randomSettlementIndex = math.random(0, settlementsNum - 1)
        for i = 0, settlementsNum - 1 do
            local settlement = faction:getSettlement(i)

            if EXCLUDED_SETTLEMENTS[settlement.name] then
                goto continue
            end

            if settlement.populationSize < 500 then
                goto continue
            end

            if not isCoreSettlementForFaction(settlement, faction) then
                if stage == EVENT_STAGES[1] then
                    if randomSettlementIndex == i then
                        local slaveFaction = getFactionbyName('slave')
                        if not slaveFaction then
                            print("Slave faction not found")
                            goto continue
                        end

                        settlement:changeOwner(slaveFaction, false)
                        goto continue
                    end
                end
            end

            local numElvesLeaving = math.floor(settlement.populationSize * stageEffects.populationLossPercent / 100)
            settlement.populationSize = settlement.populationSize - numElvesLeaving

            totalPopulationLoss = totalPopulationLoss + numElvesLeaving
            totalGoldLoss = totalGoldLoss + numElvesLeaving * stageEffects.goldPerElf
            ::continue::
        end
    end

    stratmap.game.callConsole("add_money", tostring(-totalGoldLoss))

    -- Show event notification with both population and wealth loss
    stratmap.game.historicEvent("elven_passing", stage.title,
        string.format("%s\n\n%s\n%s",
            stage.description,
            string.format(TextRes.Effects.PopulationLoss, totalPopulationLoss),
            string.format(TextRes.Effects.WealthLoss, totalGoldLoss)
        )
    )
end

---@param faction factionStruct
local function applyEventFinishedRewards(faction)
    print("Elven Passing event finished for " .. faction.name)
    faction.kingsPurse = faction.kingsPurse + 1500
    stratmap.game.historicEvent("elven_passing", TextRes.Effects.Rewards.Header, TextRes.Effects.Rewards.Description)
end

---@return boolean shouldHappen, string reason
local function shouldEventHappenThisTurn()
    local currentTurn = GetTurnNumber()
    local lastEventTurn = CampaignState.ElvenPassing.PreviousTurnWhenEventHappened
    local settings = CampaignState.Settings.ElvenPassing

    -- Calculate turns since last event
    local turnsSinceLastEvent = currentTurn - lastEventTurn

    if currentTurn == 0 then
        return false, "First turn"
    end

    -- If this is the first event (lastEventTurn is 0), we want it to happen
    if lastEventTurn == 0 then
        return true, "First event trigger"
    end

    if settings.UseRandomTiming then
        -- Check if we've waited at least MinTurns
        if turnsSinceLastEvent < settings.MinTurns then
            return false, string.format("Too soon - need to wait at least %d turns (current: %d)",
                settings.MinTurns, turnsSinceLastEvent)
        end

        -- If we've waited more than MaxTurns, event should happen
        if turnsSinceLastEvent >= settings.MaxTurns then
            return true, string.format("Maximum wait time reached (%d turns)", settings.MaxTurns)
        end

        -- Between MinTurns and MaxTurns, random chance each turn
        local range = settings.MaxTurns - settings.MinTurns
        local randomChance = 1 / range -- probability increases as we get closer to MaxTurns
        local roll = math.random()

        return roll < randomChance, string.format("Random check: rolled %.2f vs %.2f chance", roll, randomChance)
    else
        -- Fixed timing - event happens exactly every MaxTurns
        local shouldHappen = turnsSinceLastEvent >= settings.MaxTurns
        return shouldHappen, string.format("Fixed timing check: %d/%d turns passed",
            turnsSinceLastEvent, settings.MaxTurns)
    end
end

---@param faction factionStruct
---@param amount integer
local function changeEventProgress(faction, amount)
    local currentProgress = CampaignState.ElvenPassing.CurrentProgress

    if not currentProgress then
        print("Elven Passing progress not set for " .. faction.name)
        M2TWEOP.logGame("Elven Passing progress not set for " .. faction.name)
        return
    end

    local newProgress = currentProgress + amount
    if newProgress > 100 then
        newProgress = 100
    elseif newProgress < 0 then
        newProgress = 0
    end

    -- Check for defeat condition
    if newProgress == 0 then
        UIState.ElvenPassingUI.IsDefeatWindowOpen = true
        return
    end

    -- Only allow progress to go up if the required conditions are met
    if newProgress > currentProgress then
        if not CampaignState.ElvenPassing.IsFirstMainEnemyDefeated and newProgress >= 75 and currentProgress < 75 then
            newProgress = 74
        end

        if not CampaignState.ElvenPassing.IsSecondMainEnemyDefeated and newProgress >= 100 and currentProgress < 100 then
            newProgress = 99
        end
    end

    -- Check if we're changing stages
    local currentStage = ElvenPassing.getCurrentEventStage(currentProgress)
    local newStage = ElvenPassing.getCurrentEventStage(newProgress)

    if currentStage ~= newStage then
        -- Determine if we're improving or worsening
        if newProgress > currentProgress then
            -- Improving
            local message = ""
            if newProgress >= 75 then
                message = TextRes.Effects.StageTransitions.Improving.ToWeakening
            elseif newProgress >= 50 then
                message = TextRes.Effects.StageTransitions.Improving.ToModerate
            elseif newProgress >= 25 and currentProgress <= 24 then
                message = TextRes.Effects.StageTransitions.Improving.FromCritical
            end

            if message ~= "" then
                stratmap.game.historicEvent("elven_passing", TextRes.Effects.StageTransitions.Improving.Title, message)
            end
        else
            -- Worsening
            local message = ""
            if newProgress <= 24 then
                message = TextRes.Effects.StageTransitions.Worsening.ToCritical
            elseif newProgress <= 49 then
                message = TextRes.Effects.StageTransitions.Worsening.ToStrong
            elseif newProgress <= 74 then
                message = TextRes.Effects.StageTransitions.Worsening.ToModerate
            end

            if message ~= "" then
                stratmap.game.historicEvent("elven_passing", TextRes.Effects.StageTransitions.Worsening.Title, message)
            end
        end
    end

    CampaignState.ElvenPassing.CurrentProgress = newProgress
end

-- Main update function to be called each turn
---@param faction factionStruct The faction to update
local function processElvenPassingForFaction(faction)
    if not CampaignState.Settings.ElvenPassing.Enabled then
        return
    end

    if CampaignState.ElvenPassing.IsEventFinished then
        return
    end

    local progress = CampaignState.ElvenPassing.CurrentProgress

    if not progress then
        print("Elven Passing progress not set for " .. faction.name)
        M2TWEOP.logGame("Elven Passing progress not set for " .. faction.name)
        return
    end

    if progress >= 100 then
        CampaignState.ElvenPassing.IsEventFinished = true
        applyEventFinishedRewards(faction)
        return
    end

    -- Get current stage
    local currentStage = ElvenPassing.getCurrentEventStage(progress)

    -- Apply effects
    applyStageEffects(faction, currentStage)
    CampaignState.ElvenPassing.PreviousTurnWhenEventHappened = GetTurnNumber()
end

-- Helper function to get the custom victory type based on the battle results
-- 2 - Heroic victory - if cost of enemy soldiers killed/captured after battle is >200% higher than cost of your killed soldiers AND initial cost of enemy army was >=100% higher than yours
-- 1 - Average victory - if cost of enemy soldiers killed/captured after battle is higher than the cost of your killed soldiers
-- 0 - Skill issue victory - if cost of enemy soldiers killed/captured after battle is lower than the cost of your killed soldiers
---@param playerUnitCost integer
---@param enemyUnitCost integer
---@param playerGoldLoss integer
---@param enemyGoldLoss integer
---@return integer customVictoryType
local function getCustomVictoryType(playerUnitCost, enemyUnitCost, playerGoldLoss, enemyGoldLoss)
    if enemyGoldLoss > playerGoldLoss * 2 and enemyUnitCost > playerUnitCost * 2 then
        return 2
    elseif enemyGoldLoss > playerGoldLoss then
        return 1
    else
        return 0
    end
end

---@param elvenFaction string
---@param enemyFactions table<string>
---@return boolean
local function wasMainEnemyInBattle(elvenFaction, enemyFactions)
    local mainEnemies = MAIN_ENEMIES_FOR_FACTION[elvenFaction]
    if not mainEnemies then
        return false
    end

    for _, enemyFaction in ipairs(enemyFactions) do
        for _, mainEnemy in ipairs(mainEnemies) do
            if enemyFaction == mainEnemy then
                return true
            end
        end
    end
    return false
end

---@param faction factionStruct
local function handlePostBattleResults(faction)
    local totalPlayerAndAlliedUnitCount = 0 -- Total units in player's army and allied armies
    local totalEnemyUnitCount = 0           -- Total units in enemy's army
    local totalPlayerAndAlliedGoldLoss = 0  -- Value of player's losses
    local totalEnemyGoldLoss = 0            -- Value of enemy's losses
    local totalPlayerStartingUnitCost = 0   -- Value of player's starting units
    local totalEnemyStartingUnitCost = 0    -- Value of enemy's starting units
    local isPlayerSideWon = false           -- Whether player's side won
    local victoryType = nil                 -- Type of victory achieved (according to game rules)
    local lossType = nil                    -- Type of loss (according to game rules)
    local customVictoryType = nil           -- Custom victory type (according to losses, unit count, etc.)
    local enemyFactionNames = {}            -- Reference to enemy factions

    -- Iterate through all sides in the battle
    for s = 1, BATTLE.sidesNum do -- 1-indexed
        local isPlayerSide = false
        local side = BATTLE.sides[s]

        -- Figure out which side is the player
        for f = 0, side.factionCount - 1 do
            local fac = side:getFaction(f)
            if fac.isPlayerControlled == 1 then
                isPlayerSide = true
            else
                -- add enemy faction to list
                enemyFactionNames[#enemyFactionNames + 1] = fac.name
            end
        end

        -- Record victory or loss status and type if player's side
        if isPlayerSide then
            isPlayerSideWon = side.wonBattle == 2

            if isPlayerSideWon then
                victoryType = side.battleSuccess
            else
                lossType = side.battleSuccess
            end
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
            if isPlayerSide then
                totalPlayerAndAlliedUnitCount = totalPlayerAndAlliedUnitCount + unitCount
            else
                totalEnemyUnitCount = totalEnemyUnitCount + unitCount
            end

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
                if isPlayerSide then
                    totalPlayerStartingUnitCost = totalPlayerStartingUnitCost + unitCostBeforeBattle
                    totalPlayerAndAlliedGoldLoss = totalPlayerAndAlliedGoldLoss + unitGoldLoss
                else
                    totalEnemyStartingUnitCost = totalEnemyStartingUnitCost + unitCostBeforeBattle
                    totalEnemyGoldLoss = totalEnemyGoldLoss + unitGoldLoss
                end
            end
        end
    end

    if isPlayerSideWon then
        customVictoryType = getCustomVictoryType(totalPlayerStartingUnitCost, totalEnemyStartingUnitCost,
            totalPlayerAndAlliedGoldLoss, totalEnemyGoldLoss)
        if wasMainEnemyInBattle(faction.name, enemyFactionNames) then
            if customVictoryType == 2 then
                changeEventProgress(faction, 5)
            elseif customVictoryType == 1 then
                changeEventProgress(faction, 3)
            end
        end

        if customVictoryType == 0 then
            changeEventProgress(faction, -5)
        end
    else
        if lossType == 0 or lossType == 1 or lossType == 2 then
            changeEventProgress(faction, -5)
        elseif lossType == 3 then
            changeEventProgress(faction, -10)
        end
        print("[DEBUG] Elven Passing: Loss type: " .. tostring(lossType))
        M2TWEOP.logGame("[DEBUG] Elven Passing: Loss type: " .. tostring(lossType))
    end
end

-- returns 2 lists: settlements that were lost and settlements that were gained
---@param faction factionStruct
---@return table<settlementStruct> settlementsLost, table<settlementStruct> settlementsGained
local function compareSettlementsList(faction)
    local settlements = EurHelpers.getListOfFactionSettlements(faction)
    local previousSettlements = CampaignState.ElvenPassing.SettlementsHeldList

    if not settlements then
        print("ERROR: No settlements found for " .. faction.name)
        M2TWEOP.logGame("[ERROR] Elven Passing: No settlements found for " .. faction.name)
        return {}, {}
    end

    if not previousSettlements then
        print("ERROR: No previous settlements found for " .. faction.name)
        M2TWEOP.logGame("[ERROR] Elven Passing: No previous settlements found for " .. faction.name)
        return {}, settlements
    end


    local settlementsLost = {}
    local settlementsGained = {}

    for _, settlement in ipairs(previousSettlements) do
        if not tableContains(settlements, settlement) then
            table.insert(settlementsLost, settlement)
        end
    end

    for _, settlement in ipairs(settlements) do
        if not tableContains(previousSettlements, settlement) then
            table.insert(settlementsGained, settlement)
        end
    end

    return settlementsLost, settlementsGained
end

---@param faction factionStruct
local function checkAliveEnemies(faction)
    print("Checking alive enemies for " .. faction.name)
    local enemiesForFaction = MAIN_ENEMIES_FOR_FACTION[faction.name]
    if not enemiesForFaction then
        return
    end

    local aliveEnemies = 0

    for _, enemy in ipairs(enemiesForFaction) do
        print("Checking enemy " .. enemy)
        local enemyFaction = getFactionbyName(enemy)
        if enemyFaction and enemyFaction.deadStatus == 0 then
            print("Enemy " .. enemy .. " is alive")
            aliveEnemies = aliveEnemies + 1
        end
    end

    if aliveEnemies == 2 then
        CampaignState.ElvenPassing.IsFirstMainEnemyDefeated = false
        CampaignState.ElvenPassing.IsSecondMainEnemyDefeated = false
    elseif aliveEnemies == 1 then
        -- means that first main enemy is defeated after this check, and was not defeated before
        if CampaignState.ElvenPassing.IsFirstMainEnemyDefeated == false then
            changeEventProgress(faction, 5)
        end

        CampaignState.ElvenPassing.IsFirstMainEnemyDefeated = true
        CampaignState.ElvenPassing.IsSecondMainEnemyDefeated = false
    elseif aliveEnemies == 0 then
        -- means that second main enemy is defeated after this check, and was not defeated before
        if CampaignState.ElvenPassing.IsSecondMainEnemyDefeated == false then
            changeEventProgress(faction, 5)
        end

        CampaignState.ElvenPassing.IsFirstMainEnemyDefeated = true
        CampaignState.ElvenPassing.IsSecondMainEnemyDefeated = true
    end
end

---@param faction factionStruct
function ElvenPassing.initFactionSettlementsList(faction)
    local settlements = EurHelpers.getListOfFactionSettlements(faction)
    CampaignState.ElvenPassing.SettlementsHeldList = settlements
end

-- Helper function to get current stage based on progress
---@param progress number Current progress value (0-100)
---@return EurElvenPassing.EventStage stage The current stage data
function ElvenPassing.getCurrentEventStage(progress)
    for _, stage in ipairs(EVENT_STAGES) do
        if progress >= stage.minProgress and progress <= stage.maxProgress then
            return stage
        end
    end
    -- Fallback to final stage if no match (shouldn't happen with proper progress values)
    return EVENT_STAGES[#EVENT_STAGES]
end

---@param faction factionStruct
function ElvenPassing.onFactionTurnEnd(faction)
    if faction.isPlayerControlled == 0 then
        return
    end

    if not ELVEN_FACTIONS[faction.name] then
        return
    end

    if CampaignState.ElvenPassing.IsEventFinished then
        return
    end

    checkAliveEnemies(faction)

    -- if wasn't in battle for at least 10 turns
    if GetTurnNumber() - CampaignState.ElvenPassing.PreviousTurnWhenBattleHappened >= 10 then
        changeEventProgress(faction, -5)
    end

    -- Process settlements only after first turn
    if GetTurnNumber() > 0 then
        print("[DEBUG] Elven Passing: Processing settlements for " .. faction.name)
        print("[DEBUG] Elven Passing: Turn number: " .. tostring(GetTurnNumber()))
        -- process difference in settlements
        local settlementsLost, settlementsGained = compareSettlementsList(faction)
        if #settlementsLost > 0 then
            -- iterate through settlements lost
            ---@param settlement settlementStruct
            for _, settlement in ipairs(settlementsLost) do
                if isCoreSettlementForFaction(settlement, faction) then
                    changeEventProgress(faction, -20)
                else
                    changeEventProgress(faction, -10)
                end
            end
        end

        if #settlementsGained > 0 then
            -- iterate through settlements gained
            ---@param settlement settlementStruct
            for _, settlement in ipairs(settlementsGained) do
                if isCoreSettlementForFaction(settlement, faction) then
                    changeEventProgress(faction, 20)
                elseif isCoreSettlementForMainEnemy(settlement, faction) then
                    changeEventProgress(faction, 10)
                end
            end
        end
    end

    local shouldHappen, reason = shouldEventHappenThisTurn()
    if shouldHappen then
        processElvenPassingForFaction(faction)
        print("Elven Passing for " .. faction.name .. " happened this turn: " .. reason)
        M2TWEOP.logGame("Elven Passing for " .. faction.name .. " happened this turn: " .. reason)
    end
end

---@param eventData eventTrigger
function ElvenPassing.onCeasedFactionLeader(eventData)
    print("[DEBUG] Elven Passing: onCeasedFactionLeader for " .. eventData.faction.name)
    print("[DEBUG] Elven Passing: Faction Leader: " .. eventData.faction.leader.fullName)
    if not CampaignState.Settings.ElvenPassing.Enabled then
        return
    end

    if eventData.faction.isPlayerControlled == 0 then
        return
    end

    changeEventProgress(eventData.faction, -20)
end

---@param faction factionStruct
function ElvenPassing.onPostBattle(faction)
    if not CampaignState.Settings.ElvenPassing.Enabled then
        return
    end

    if CampaignState.ElvenPassing.IsEventFinished then
        return
    end

    if faction.isPlayerControlled == 0 then
        return
    end

    checkAliveEnemies(faction)

    print("[DEBUG] Elven Passing: onPostBattle for " .. faction.name)

    CampaignState.ElvenPassing.PreviousTurnWhenBattleHappened = GetTurnNumber()

    handlePostBattleResults(faction)
end

return ElvenPassing
