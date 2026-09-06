::EUR.battleDistance <- function(x1, y1, x2, y2) {
    return ::EUR.math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
}

::EUR.getAiPercentageLost <- function() {
    local aiSide = ::EUR.BATTLE_AI.getAiSide()
    local totalStart = 0
    local totalCurrent = 0
    for (local i = 0; i < aiSide.armyCount; i++) {
        local bArmy = aiSide.armyStats(i)
        if (bArmy == null) continue
        for (local j = 0; j < bArmy.unitCount; j++) {
            local battleUnit = bArmy.unitStats(j)
            if (battleUnit == null) continue
            totalStart += battleUnit.soldiersStart
            totalCurrent += (battleUnit.soldiersStart - battleUnit.soldiersLost)
        }
    }
    return (1 - (totalCurrent / totalStart.tofloat())) * 100
}

::EUR.unstuckAi <- function(idleOnly = false) {
    local aiSide = ::EUR.BATTLE_AI.getAiSide()
    for (local i = 0; i < aiSide.armyCount; i++) {
        local bArmy = aiSide.armyStats(i)
        if (bArmy == null) continue
        for (local j = 0; j < bArmy.unitCount; j++) {
            local battleUnit = bArmy.unitStats(j)
            if (battleUnit != null && battleUnit.unit != null && battleUnit.unit.isIdle && battleUnit.unit.siegeEngineCount == 0) {
                ::EUR.BATTLE_AI.attackClosestUnit(battleUnit.unit, ::EUR.BATTLE_AI.getPlayerSide())
            }
        }
    }
}

::EUR.fixRamAttack <- function() {
    local aiSide = ::EUR.BATTLE_AI.getAiSide()
    if (!aiSide) return
    for (local i = 0; i < aiSide.armyCount; i++) {
        local bArmy = aiSide.armyStats(i)
        if (bArmy == null) continue
        for (local j = 0; j < bArmy.unitCount; j++) {
            local battleUnit = bArmy.unitStats(j)
            if (battleUnit == null || battleUnit.unit == null || battleUnit.unit.siegeEngineCount <= 0) continue
            local buildings = ::battle.current().residence()
            for (local b = 0; b < buildings.buildingCount; b++) {
                local building = buildings.building(b)
                if (building && building.type == ::Enum.BattleBuildingType.gate) {
                    battleUnit.unit.attackBuilding(building)
                    return
                }
            }
        }
    }
}

class BattleAi {
    aiSide = 0
    playerSide = 0
    isOpenBattle = true
    aiIsAttacker = true
    stakesDeployed = false
    abilityTimer = 0
    idleTimer = 0
    initialized = false
    battleStarted = false
    unstucked = false

    function resetState() {
        this.aiSide = 0
        this.playerSide = 0
        this.isOpenBattle = true
        this.aiIsAttacker = true
        this.stakesDeployed = false
        this.abilityTimer = 0
        this.idleTimer = 0
        this.initialized = false
        this.battleStarted = false
        this.unstucked = false
    }

    function getPlayerSide() {
        if (!::battle.current()) return null
        return ::battle.current().side(this.playerSide)
    }

    function getAiSide() {
        if (!::battle.current()) return null
        return ::battle.current().side(this.aiSide)
    }

    function initialize() {
        if (this.initialized) return
        this.resetState()
        for (local s = 0; s < ::battle.current().sideCount; s++) {
            local isPlayer = false
            local side = ::battle.current().side(s)
            for (local f = 0; f < side.factionCount; f++) {
                local fac = side.faction(f)
                if (fac.isPlayerControlled == 1) {
                    isPlayer = true
                    this.playerSide = s
                } else if (!isPlayer) {
                    this.aiSide = s
                }
            }
            if (!isPlayer) {
                for (local r = 0; r < side.pendingReinforcementCount; r++) {
                    if (side.reinforcement(r).faction.isPlayerControlled == 1) {
                        isPlayer = true
                        this.playerSide = s
                        break
                    }
                }
            }
        }

        local aiSide = ::battle.current().side(this.aiSide)
        this.aiIsAttacker = (aiSide.isDefender == false)
        this.isOpenBattle = !(::battle.current().conflictType == ::Enum.BattleType.siege || ::battle.current().conflictType == ::Enum.BattleType.sally)
        this.initialized = true
    }

    function start() {
        if (!this.initialized) return
        this.battleStarted = true
        local aiSide = this.getAiSide()
        if (this.aiIsAttacker) {
            if (::battle.current().conflictType == ::Enum.BattleType.sally) {
                aiSide.ai.plan = ::Enum.BattleAiPlan.sallyOut
            } else if (this.isOpenBattle) {
                this.addAttackAllObjective()
            }
        }
    }

    function deployStakes() {
        if (this.aiIsAttacker || this.stakesDeployed) return
        if (::battle.current().conflictType == ::Enum.BattleType.siege) return
        this.stakesDeployed = true
        local aiSide = this.getAiSide()

        // any cavalry present? then don't plant stakes (they'd block our own charge)
        for (local b = 0; b < aiSide.armyCount; b++) {
            local bArmy = aiSide.armyStats(b)
            if (bArmy && bArmy.army && bArmy.army.countUnitsOfCategory(::Enum.UnitCategory.cavalry) > 0) return
        }
        for (local b = 0; b < aiSide.armyCount; b++) {
            local bArmy = aiSide.armyStats(b)
            if (bArmy == null || bArmy.army == null) continue
            for (local u = 0; u < bArmy.army.unitCount; u++) {
                local battleUnit = bArmy.army.unit(u)
                // PORT: eduEntry.stakes has no house equivalent - UnitType registers no stakes flag
                //if (battleUnit.type.stakes) { battleUnit.deployStakes() }
            }
        }
    }

    function getUnitFirePower(missileUnit) {
        local stats = missileUnit.type
        local firePower = stats.attack(0)
        if (stats.isArmourPiercing(0)) { firePower = firePower * 1.5 }
        if (stats.hasProjectile(0)) { firePower = firePower * (1.5 - (stats.projectileAccuracy(0) * 10)) }
        return firePower * missileUnit.soldiersInBattle
    }

    // returns [firePower, engagedPower, engagedRatio] (the Lua returned three values)
    function getSideActiveFiringPower(side) {
        local firePower = 0
        local engagedPower = 0
        local unitCount = 0
        local engagedCount = 0
        for (local a = 0; a < side.armyCount; a++) {
            local bArmy = side.armyStats(a)
            if (bArmy == null || bArmy.army == null) continue
            for (local u = 0; u < bArmy.army.unitCount; u++) {
                local battleUnit = bArmy.army.unit(u)
                unitCount += 1
                if (battleUnit.isFiring && battleUnit.type.category != ::Enum.UnitCategory.siege) {
                    firePower += this.getUnitFirePower(battleUnit)
                    engagedCount += 1
                } else if (battleUnit.actionStatus == ::Enum.UnitActionStatus.fighting || battleUnit.actionStatus == ::Enum.UnitActionStatus.charging) {
                    engagedPower += (battleUnit.type.roughPowerPerMan * battleUnit.soldiersInBattle)
                    engagedCount += 1
                } else if (battleUnit.actionType == ::Enum.UnitOrder.attackUnit) {
                    engagedCount += 1
                }
            }
        }
        if (unitCount == 0) { unitCount = 1 }
        return [firePower + 1, engagedPower + 1, engagedCount / unitCount.tofloat()]
    }

    function attackClosestUnit(attacker, enemySide) {
        local closestUnit = null
        local closestDistance = 9999999
        local closestBackupUnit = null
        local closestBackupDistance = 9999999
        local attackerX = attacker.x
        local attackerY = attacker.y
        for (local i = 0; i < enemySide.armyCount; i++) {
            local bArmy = enemySide.armyStats(i)
            if (bArmy == null) continue
            for (local j = 0; j < bArmy.unitCount; j++) {
                local defender = bArmy.unitStats(j).unit
                if (defender == null || defender.morale == ::Enum.UnitMorale.routing) continue
                local distance = ::EUR.battleDistance(attackerX, attackerY, defender.x, defender.y)

                if (defender.isOnWalls) {
                    if (distance < closestBackupDistance) { closestBackupDistance = distance; closestBackupUnit = defender }
                } else if (defender.type.category == ::Enum.UnitCategory.cavalry) {
                    if (attacker.type.category == ::Enum.UnitCategory.cavalry) {
                        if (distance < closestDistance) { closestDistance = distance; closestUnit = defender }
                    } else if (distance < closestBackupDistance) {
                        closestBackupDistance = distance; closestBackupUnit = defender
                    }
                } else if (attacker.type.category == ::Enum.UnitCategory.cavalry) {
                    if (defender.type.unitClass == ::Enum.UnitClass.spearmen) {
                        if (distance < closestBackupDistance) { closestBackupDistance = distance; closestBackupUnit = defender }
                    } else if (distance < closestDistance) {
                        closestDistance = distance; closestUnit = defender
                    }
                } else if (::battle.current().conflictType == ::Enum.BattleType.siege && !this.aiIsAttacker) {
                    local residence = ::battle.current().residence()
                    if (residence && residence.plaza.isContested) {
                        local plazaDistance = ::EUR.battleDistance(residence.plaza.x, residence.plaza.y, defender.x, defender.y)
                        if (plazaDistance < closestDistance) { closestDistance = plazaDistance; closestUnit = defender }
                        else if (distance < closestBackupDistance) { closestBackupDistance = distance; closestBackupUnit = defender }
                    } else if (distance < closestDistance) {
                        closestDistance = distance; closestUnit = defender
                    }
                } else if (distance < closestDistance) {
                    closestDistance = distance; closestUnit = defender
                }
            }
        }
        if (closestUnit) { attacker.attackUnit(closestUnit, true) }
        else if (closestBackupUnit) { attacker.attackUnit(closestBackupUnit, true) }
        else { attacker.controlStatus = 1 }
    }

    function checkForIdlingUnits(engageMoving = false) {
        if (!this.battleStarted) return
        local aiSide = this.getAiSide()
        for (local i = 0; i < aiSide.armyCount; i++) {
            local bArmy = aiSide.armyStats(i)
            if (bArmy == null || bArmy.army.faction.isPlayerControlled != 0) continue
            for (local j = 0; j < bArmy.unitCount; j++) {
                local battleUnit = bArmy.unitStats(j)
                if (battleUnit == null || battleUnit.unit == null) continue
                if (battleUnit.unit.isIdle && battleUnit.unit.siegeEngineCount == 0 && battleUnit.unit.actionType != ::Enum.UnitOrder.attackUnit) {
                    this.attackClosestUnit(battleUnit.unit, this.getPlayerSide())
                } else if (engageMoving && (battleUnit.unit.actionStatus == ::Enum.UnitActionStatus.moving || battleUnit.unit.actionStatus == ::Enum.UnitActionStatus.reforming)) {
                    if (battleUnit.unit.actionType != ::Enum.UnitOrder.attackUnit && battleUnit.unit.siegeEngineCount == 0) {
                        this.attackClosestUnit(battleUnit.unit, this.getPlayerSide())
                    }
                } else {
                    battleUnit.unit.controlStatus = 1
                }
            }
        }
    }

    function useSpecialAbilities() {
        local aiSide = this.getAiSide()
        for (local a = 0; a < aiSide.armyCount; a++) {
            local bArmy = aiSide.armyStats(a)
            if (bArmy == null || bArmy.army == null) continue
            for (local u = 0; u < bArmy.army.unitCount; u++) {
                local battleUnit = bArmy.army.unit(u)
                if (battleUnit.general && battleUnit.general.heroAbility) { battleUnit.useSpecialAbility(true) }
            }
        }
    }

    // turn off skirmish for the player's units at battle start (gated in AGO.cfg by the caller)
    function disablePlayerSkirmishMode() {
        local playerSide = this.getPlayerSide()
        if (!playerSide) return
        for (local a = 0; a < playerSide.armyCount; a++) {
            local bArmy = playerSide.armyStats(a)
            if (bArmy == null || bArmy.army == null) continue
            for (local u = 0; u < bArmy.army.unitCount; u++) {
                local battleUnit = bArmy.army.unit(u)
                if (battleUnit && battleUnit.hasBattleProperty(::Enum.UnitBattleProperty.skirmish)) {
                    battleUnit.setBattleProperty(::Enum.UnitBattleProperty.skirmish, false)
                }
            }
        }
    }

    function addAttackAllObjective() {
        if (::battle.current().isRiverBattle) {
            ::game.runScriptCommand("ai_gta_add_objective", this.aiSide + " ASSAULT_CROSSING 999")
        } else {
            ::game.runScriptCommand("ai_gta_add_objective", this.aiSide + " ATTACK_ENEMY_BATTLEGROUP 999")
        }
        this.getAiSide().ai.plan = ::Enum.BattleAiPlan.attackAll
    }

    function update() {
        if (!this.initialized) return
        local bType = ::battle.current().conflictType
        local playerSide = this.getPlayerSide()
        local aiSide = this.getAiSide()

        local playerPower = this.getSideActiveFiringPower(playerSide)
        local aiPower = this.getSideActiveFiringPower(aiSide)
        local playerFirePower = playerPower[0]
        local aiFirePower = aiPower[0]
        local aiEngagedPower = aiPower[1]
        local aiEngagedRatio = aiPower[2]
        local playerFirePowerRatio = playerFirePower / aiFirePower.tofloat()
        local percentageLost = ::EUR.getAiPercentageLost()

        if (this.battleStarted) { this.idleTimer += 1 }

        if (this.isOpenBattle) {
            if (aiSide.ai.plan != ::Enum.BattleAiPlan.attackAll) {
                if (this.aiIsAttacker || playerFirePowerRatio > 1.2) { this.addAttackAllObjective() }
            } else if (this.idleTimer > 10) {
                this.checkForIdlingUnits(aiEngagedRatio > 0.5)
                this.idleTimer = 0
            }
        } else if (bType == ::Enum.BattleType.siege) {
            local residence = ::battle.current().residence()
            if (residence) {
                if (!this.aiIsAttacker && residence.settlement && residence.settlement.level == 0 && !residence.settlement.isCastle) {
                    if (playerFirePowerRatio > 1.2 || aiEngagedPower > 1) {
                        this.addAttackAllObjective()
                        if (percentageLost > 5) { this.checkForIdlingUnits(true) }
                    }
                }
                if (residence.gateDestroyed > 0 || residence.wallsBreached > 0 || aiEngagedRatio > 0.5) {
                    if (percentageLost > 5 && this.idleTimer > 100 && aiEngagedRatio > 0.5) {
                        this.checkForIdlingUnits(aiEngagedRatio > 0.75)
                        this.idleTimer = 0
                    }
                }
            }
        } else if (bType == ::Enum.BattleType.sally) {
            if (!this.aiIsAttacker) {
                if (playerFirePowerRatio > 1.2 || aiEngagedPower > 1) {
                    this.addAttackAllObjective()
                    if (percentageLost > 5) { this.checkForIdlingUnits(true) }
                }
            } else if (percentageLost > 10) {
                this.checkForIdlingUnits(true)
            }
        }

        this.abilityTimer += 1
        if (aiEngagedPower > 100 && this.abilityTimer > 1000) {
            this.useSpecialAbilities()
            this.abilityTimer = 0
        }
    }
}

::EUR.BATTLE_AI <- BattleAi()
