BATTLE_AI = {
    aiSide = 0,
    playerSide = 0,
    isOpenBattle = true,
    aiIsAttacker = true,
    stakesDeployed = false,
    abilityTimer = 0,
    idleTimer = 0,
    initialized = false,
    battleStarted = false,
    unstucked = false,
}

function BATTLE_AI:resetState()
    self.aiSide = 0
    self.playerSide = 0
    self.isOpenBattle = true
    self.aiIsAttacker = true
    self.stakesDeployed = false
    self.abilityTimer = 0
    self.idleTimer = 0
    self.initialized = false
    self.battleStarted = false
    self.unstucked = false
end

function BATTLE_AI:initialize()
    if self.initialized then return end
    BATTLE_AI:resetState()
    for s = 1, BATTLE.sidesNum do -- 1-indexed
        local isPlayer = false
        local side = BATTLE.sides[s]

        -- Figure out which side is the player
        for f = 0, side.factionCount - 1 do
            local fac = side:getFaction(f)
            if fac.isPlayerControlled == 1 then
                isPlayer = true
                self.playerSide = s - 1
            elseif not isPlayer then
                self.aiSide = s - 1
            end
        end
        if not isPlayer then
            for r = 0, side.reinforceArmyCount - 1 do
                local rArmy = side:getReinforcementArmy(r)
                if rArmy.faction.isPlayerControlled == 1 then
                    isPlayer = true
                    self.playerSide = s - 1
                    break
                end
            end
        end
    end

    local aiSide = BATTLE.sides[self.aiSide + 1]

    self.aiIsAttacker = aiSide.isDefender == false

    if BATTLE.battleType ~= battleType.siege and BATTLE.battleType ~= battleType.sally
    then
        self.isOpenBattle = true
    else
        self.isOpenBattle = false
    end
    self.initialized = true
end

function BATTLE_AI:start()
    if not self.initialized then return end

    self.battleStarted = true
    local aiSide = self:getAiSide()

    if self.aiIsAttacker then
        if BATTLE.battleType == battleType.sally then
            aiSide.battleAIPlan.gtaPlan = aiPlan.sallyOut
        elseif self.isOpenBattle then
            self:addAttackAllObjective()
        end
    end

end

function BATTLE_AI:deployStakes()
    if self.aiIsAttacker or self.stakesDeployed then return end
    if BATTLE.battleType == battleType.siege then return end
    self.stakesDeployed = true

    local aiSide = self:getAiSide()

    for b = 0, aiSide.battleArmyNum - 1 do
        local bArmy = aiSide:getBattleArmy(b)
        if bArmy and bArmy.army then
            local army = bArmy.army
            if army:getNumberOfCategory(unitCategory.cavalry) > 0
            then
                return
            end
        end
    end

    for b = 0, aiSide.battleArmyNum - 1 do
        local bArmy = aiSide:getBattleArmy(b)
        if bArmy and bArmy.army then
            local army = bArmy.army
            for u = 0, army.numOfUnits - 1 do
                local un = army:getUnit(u)
                if un.eduEntry.stakes then
                    un:deployStakes()
                    --log("AI: " .. self.aiSide .. " deployed stakes", logLevel.TRACE)
                end
            end
        end
    end
end

---comment
---@param missileUnit unit
function BATTLE_AI:getUnitFirePower(missileUnit)
    local stats = missileUnit.eduEntry.primaryStats
    local firePower = stats.attack
    if stats.isAP then
        firePower = firePower * 1.5
    end
    local missile = stats.projectile
    if missile then
        firePower = firePower * (1.5 - (missile.accuracy * 10))
    end

    return firePower * missileUnit.soldierCountBattleMap
end

---comment
---@param side battleSide
---@return number
---@return number
---@return number
function BATTLE_AI:getSideActiveFiringPower(side)
    local firePower = 0
    local engagedPower = 0
    local unitCount = 0
    local engagedCount = 0
    for a = 0, side.battleArmyNum - 1 do
        local bArmy = side:getBattleArmy(a)
        if bArmy and bArmy.army then
            local army = bArmy.army
            for u = 0, army.numOfUnits - 1 do
                local un = army:getUnit(u)
                unitCount = unitCount + 1
                if un:isFiring() and un.eduEntry.category ~= unitCategory.siege
                then
                    firePower = firePower + self:getUnitFirePower(un)
                    engagedCount = engagedCount + 1
                elseif un:getActionStatusInt() == unitStatus.fighting
                    or un:getActionStatusInt() == unitStatus.charging
                then
                    engagedPower = engagedPower + (un.eduEntry.aiUnitValuePerSoldier * un.soldierCountBattleMap)
                    engagedCount = engagedCount + 1
                elseif un.unitPositionData:getActionType() == unitAction.attackUnit then
                    engagedCount = engagedCount + 1
                end
            end
        end
    end
    if unitCount == 0 then
        unitCount = 1
    end
    return firePower + 1, engagedPower + 1, engagedCount / unitCount
end

function getAiPercentageLost()
    local aiSide = BATTLE_AI:getAiSide()
    local totalStart = 0
    local totalCurrent = 0
    for i = 0, aiSide.battleArmyNum - 1 do
        local bArmy = aiSide:getBattleArmy(i)
        if bArmy then
            for j = 0, bArmy.unitCount - 1 do
                local un = bArmy:getBattleUnit(j)
                if un then
                    totalStart = totalStart + un.soldiersStart
                    totalCurrent = totalCurrent + (un.soldiersStart - un.soldiersLost)
                end
            end
        end
    end
    return (1 - (totalCurrent / totalStart)) * 100
end

---comment
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function battleDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

---comment
---@param attacker unit
---@param enemySide battleSide
function BATTLE_AI:attackClosestUnit(attacker, enemySide)
    local closestUnit = nil
    local closestDistance = 9999999
    local closestBackupUnit = nil
    local closestBackupDistance = 9999999
    local attackerX, attackerY = attacker.battlePosX, attacker.battlePosY
    for i = 0, enemySide.battleArmyNum - 1 do
        local bArmy = enemySide:getBattleArmy(i)
        if bArmy then
            for j = 0, bArmy.unitCount - 1 do
                local battleUn = bArmy:getBattleUnit(j)
                local defender = battleUn.unit
                if defender and defender.moraleLevel ~= moraleStatus.routing then
                    local defenderX, defenderY = defender.battlePosX, defender.battlePosY
                    local distance = battleDistance(attackerX, attackerY, defenderX, defenderY)
                    if defender:isOnWalls() then
                        if distance < closestBackupDistance then
                            closestBackupDistance = distance
                            closestBackupUnit = defender
                        end
                    elseif defender.eduEntry.category == unitCategory.cavalry then
                        if attacker.eduEntry.category == unitCategory.cavalry then
                            if distance < closestDistance then
                                closestDistance = distance
                                closestUnit = defender
                            end
                        else
                            if distance < closestBackupDistance then
                                closestBackupDistance = distance
                                closestBackupUnit = defender
                            end
                        end
                    elseif attacker.eduEntry.category == unitCategory.cavalry then
                        if defender.eduEntry.class == unitClass.spearmen then
                            if distance < closestBackupDistance then
                                closestBackupDistance = distance
                                closestBackupUnit = defender
                            end
                        else
                            if distance < closestDistance then
                                closestDistance = distance
                                closestUnit = defender
                            end
                        end
                    elseif BATTLE.battleType == battleType.siege and not self.aiIsAttacker then
                        local res = BATTLE.getBattleResidence()
                        if res and res.plazaData.capturing then
                            local plazaDistance = battleDistance(res.plazaData.xCoord, res.plazaData.yCoord, defenderX, defenderY)
                            if plazaDistance < closestDistance then
                                closestDistance = plazaDistance
                                closestUnit = defender
                            elseif distance < closestBackupDistance then
                                closestBackupDistance = distance
                                closestBackupUnit = defender
                            end
                        elseif distance < closestDistance then
                            closestDistance = distance
                            closestUnit = defender
                        end
                    elseif distance < closestDistance then
                        closestDistance = distance
                        closestUnit = defender
                    end
                end
            end
        end
    end
    if closestUnit then
        attacker:attackUnit(closestUnit, true)
    elseif closestBackupUnit then
        attacker:attackUnit(closestBackupUnit, true)
    else
        attacker.aiActiveSet = 1
    end
end

---comment
---@param engageMoving boolean
function BATTLE_AI:checkForIdlingUnits(engageMoving)
    engageMoving = engageMoving or false
    if not self.battleStarted then return end
    --log("AI: checking for idling units", logLevel.TRACE)
    local aiSide = BATTLE_AI:getAiSide()
    for i = 0, aiSide.battleArmyNum - 1 do
        local bArmy = aiSide:getBattleArmy(i)
        if bArmy and bArmy.army.faction.isPlayerControlled == 0 then
            for j = 0, bArmy.unitCount - 1 do
                local un = bArmy:getBattleUnit(j)
                if un and un.unit then
                    if un.unit:isIdle() and un.unit.siegeEngineNum == 0 and un.unit.unitPositionData:getActionType() ~= unitAction.attackUnit then
                        --log("unit is idle, commanded to attack", logLevel.TRACE)
                        self:attackClosestUnit(un.unit, self:getPlayerSide())
                    elseif engageMoving and (un.unit:getActionStatusInt() == unitStatus.moving or un.unit:getActionStatusInt() == unitStatus.reforming)
                    then
                        if un.unit.unitPositionData:getActionType() ~= unitAction.attackUnit and un.unit.siegeEngineNum == 0 then
                            --log("unit is moving, commanded to attack", logLevel.TRACE)
                            self:attackClosestUnit(un.unit, self:getPlayerSide())
                        end
                    else
                        un.unit.aiActiveSet = 1
                    end
                end
            end
        end
    end
end

function BATTLE_AI:update()
    if not self.initialized then return end
    local bType = BATTLE.battleType
    local playerSide = self:getPlayerSide()
    local aiSide = self:getAiSide()

    local playerFirePower, playerEngagedPower, playerEngagedRatio = BATTLE_AI:getSideActiveFiringPower(playerSide)
    local aiFirePower, aiEngagedPower, aiEngagedRatio = BATTLE_AI:getSideActiveFiringPower(aiSide)
    local playerFirePowerRatio = playerFirePower / aiFirePower
    local percentageLost = getAiPercentageLost()
    if self.battleStarted then
        self.idleTimer = self.idleTimer + 1
    end

    if self.isOpenBattle then
        if aiSide.battleAIPlan.gtaPlan ~= aiPlan.attackAll then
            if self.aiIsAttacker or playerFirePowerRatio > 1.2 then
                self:addAttackAllObjective()
            end
        elseif self.idleTimer > 10 then
            self:checkForIdlingUnits(aiEngagedRatio > 0.5)
            self.idleTimer = 0
        end
    else
        if bType == battleType.siege then
            local res = BATTLE.getBattleResidence()
            if res then
                if not self.aiIsAttacker then
                    -- ai defending village
                    if res.settlement and res.settlement.level == 0 and res.settlement.isCastle == 0 then
                        if playerFirePowerRatio > 1.2 or aiEngagedPower > 1 then
                            self:addAttackAllObjective()
                            if percentageLost > 5 then
                                self:checkForIdlingUnits(true)
                            end
                        end
                    end
                end
                if res.settlementGateDestroyed > 0 or res.settlementWallsBreached > 0 or aiEngagedRatio > 0.5 then
                    if percentageLost > 5 and self.idleTimer > 100 and aiEngagedRatio > 0.5 then
                        self:checkForIdlingUnits(aiEngagedRatio > 0.75)
                        self.idleTimer = 0
                    end
                end
            end
        elseif bType == battleType.sally then
            if not self.aiIsAttacker then
                if playerFirePowerRatio > 1.2 or aiEngagedPower > 1 then
                    self:addAttackAllObjective()
                    if percentageLost > 5 then
                        self:checkForIdlingUnits(true)
                    end
                end
            else
                if percentageLost > 10 then
                    self:checkForIdlingUnits(true)
                end
            end
        end
    end

    self.abilityTimer = self.abilityTimer + 1

    if aiEngagedPower > 100 and self.abilityTimer > 1000 then
        self:useSpecialAbilities()
        self.abilityTimer = 0
    end
end

function unstuckAi(idleOnly)
    idleOnly = idleOnly or false
    --[[
    if not idleOnly and not BATTLE_AI.unstucked then
        --log("AI: unstucking all", logLevel.TRACE)
        unstuck()
        BATTLE_AI.unstucked = true
        return
    end
    ]]

    --log("AI: unstucking idle", logLevel.TRACE)

    local aiSide = BATTLE_AI:getAiSide()
    for i = 0, aiSide.battleArmyNum - 1 do
        local bArmy = aiSide:getBattleArmy(i)
        if bArmy then
            for j = 0, bArmy.unitCount - 1 do
                local un = bArmy:getBattleUnit(j)
                if un and un.unit then
                    if un.unit:isIdle() and un.unit.siegeEngineNum == 0 then
                        BATTLE_AI:attackClosestUnit(un.unit, BATTLE_AI:getPlayerSide())
                    end
                end
            end
        end
    end
end

function fixRamAttack()
    local aiSide = BATTLE_AI:getAiSide()
    if not aiSide then return end
    for i = 0, aiSide.battleArmyNum - 1 do
        local bArmy = aiSide:getBattleArmy(i)
        if bArmy then
            for j = 0, bArmy.unitCount - 1 do
                local un = bArmy:getBattleUnit(j)
                if un and un.unit then
                    if un.unit.siegeEngineNum > 0 then
                        local residence = BATTLE.getBattleResidence()
                        local buildings = residence.battleBuildings
                        for i = 0, buildings.buildingCount - 1 do
                            local building = buildings:getBuilding(i)
                            if building and building.type == battleBuildingType.gate then
                                un.unit:attackBuilding(building)
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end

function BATTLE_AI:useSpecialAbilities()
    local aiSide = self:getAiSide()


    for a = 0, aiSide.battleArmyNum - 1 do
        local bArmy = aiSide:getBattleArmy(a)
        if bArmy and bArmy.army then
            local army = bArmy.army
            for u = 0, army.numOfUnits - 1 do
                local un = army:getUnit(u)
                if un.character and un.character.ability then
                    un:useSpecialAbility(true)
                    if un.character.characterRecord and un.character.characterRecord.localizedDisplayName then
                        --log("AI: " .. un.character.characterRecord.localizedDisplayName .. " used special ability", logLevel.TRACE)
                    end
                end
            end
        end
    end
end

-- Turns off skirmish mode for player's units at the beginning of a battle
-- Gated by a config value ion AGO.cfg
function BATTLE_AI:disablePlayerSkirmishMode()
    local playerSide = self:getPlayerSide()
    if not playerSide then return end

    local armyNum = tonumber(playerSide.battleArmyNum) or 0
    for a = 0, armyNum - 1 do
        local bArmy = playerSide.getBattleArmy and playerSide:getBattleArmy(a) or nil
        if bArmy and bArmy.army then
            local army = bArmy.army
            local unitNum = tonumber(army.numOfUnits) or 0
            for u = 0, unitNum - 1 do
                local un = army.getUnit and army:getUnit(u) or nil
                if un
                    and un.hasBattleProperty
                    and un:hasBattleProperty(unitBattleProperties.skirmish)
                    and un.setBattleProperty
                then
                    un:setBattleProperty(unitBattleProperties.skirmish, false)
                end
            end
        end
    end
end

function BATTLE_AI:addAttackAllObjective()
    if BATTLE:isRiverBattle() then
        M2TWEOP.scriptCommand("ai_gta_add_objective", self.aiSide .. " ASSAULT_CROSSING 999")
    else
        M2TWEOP.scriptCommand("ai_gta_add_objective", self.aiSide .. " ATTACK_ENEMY_BATTLEGROUP 999")
    end
    self:getAiSide().battleAIPlan.gtaPlan = aiPlan.attackAll
    --log("AI: " .. self.aiSide .. " is attacking all", logLevel.TRACE)
end

function BATTLE_AI:getPlayerSide()
    if not BATTLE or not BATTLE.sides then return nil end
    local idx = (tonumber(self.playerSide) or 0) + 1
    return BATTLE.sides[idx]
end

function BATTLE_AI:getAiSide()
    if not BATTLE or not BATTLE.sides then return nil end
    local idx = (tonumber(self.aiSide) or 0) + 1
    return BATTLE.sides[idx]
end
