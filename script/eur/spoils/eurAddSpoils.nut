::EUR.won_battle <- false
::EUR.won_battle_alt <- false
::EUR.pre_battle_garrison <- []
::EUR.pre_battle_faction <- ""

class eurAddSpoils {
    spoils_loot   = 0
    our_num_units = 0
    victory_type  = 0
    lost_battle   = false

    function matchGarrisonSlot(facName, settName, unit, unitIndex, matchedSlots, checkedAlready, apply) {
        if (!(facName in ::EUR.GARRISON_TRACK)) return
        local scope = null
        if (settName != null && settName in ::EUR.GARRISON_TRACK[facName]) {
            scope = { [settName] = ::EUR.GARRISON_TRACK[facName][settName] }
        } else {
            scope = ::EUR.GARRISON_TRACK[facName]
        }
        foreach (sName, settData in scope) {
            foreach (tierIndex, tierData in settData) {
                foreach (copyNumber, entry in tierData) {
                    local slotKey = tierIndex + "_" + copyNumber
                    if ((slotKey in matchedSlots) || (unitIndex in checkedAlready)) continue
                    if (unit.type == null) continue
                    if (entry.alias == unit.name) {
                        apply(entry)
                        matchedSlots[slotKey] <- true
                        checkedAlready[unitIndex] <- true
                    }
                }
            }
        }
    }

    function postBattleChecks(faction) {
        ::EUR.logHelper("postBattleChecks")
        this.getBattleOutcomeWin()
        if (this.lost_battle) {
            this.lost_battle = false
            ::EUR.logHelper("postBattleChecks end")
            return
        }
        local victoryMulti = (this.victory_type == 3) ? 0.8 : 0.4
        if (::EUR.won_battle && this.spoils_loot != 0) {
            this.spoils_loot = ::EUR.math.ceil(this.spoils_loot * victoryMulti)
            if (this.our_num_units < 11) {
                this.our_num_units = this.our_num_units / 10.0
                this.spoils_loot = ::EUR.math.ceil(this.spoils_loot * this.our_num_units)
            }
            ::EUR.total_spoils_loot = ::EUR.total_spoils_loot + this.spoils_loot
            if (!::EUR.options_addspoils) {
                this.spoils_loot = (400 * victoryMulti).tointeger()
            }
            ::game.runConsoleCommand("add_money", "" + this.spoils_loot)
            ::game.showHistoricEvent("spoils_of_war_ai", "Enemy Camp Sacked",
                "Good tidings! Our men have found the enemy camp and claimed anything of worth. We should be able to make some coin out of this victory!\n\nGold taken: " + this.spoils_loot)
            this.spoils_loot = 0
        }
        if (::EUR.eur_playerFactionId == faction.id) {
            if (this.getBattleOutcome()) {
                ::EUR.total_losses_upkeep = ::EUR.total_losses_upkeep + ::EUR.losses_upkeep
            }
        }
        this.victory_type = 0
        ::EUR.won_battle = false
        ::EUR.logHelper("postBattleChecks end")
    }

    function getBattlePreInfo() {
        ::EUR.pre_battle_faction = ""
        ::EUR.pre_battle_garrison = []
        ::EUR.logHelper("getBattlePreInfo")
        this.spoils_loot = 0
        this.our_num_units = 0
        local thisBattle = null
        try { thisBattle = ::battle.current() } catch (err) { return }   // TODO: correct battle accessor for this host
        if (thisBattle == null) return

        for (local i = 0; i < thisBattle.sideCount; i++) {
            local thisSide = thisBattle.side(i)
            if (thisSide.armySlot(0) == null) continue
            local k = 0
            do {
                local thisArmy = thisSide.armySlot(k).army
                if (thisArmy != null) {
                    if (thisArmy.faction.isPlayerControlled == 1) {
                        this.our_num_units = this.our_num_units + thisArmy.unitCount
                        ::EUR.temp_player_army = thisArmy
                        if (thisArmy.leader != null && thisArmy.leader.record != null) {
                            ::EUR.alt_loot_player_gen = thisArmy.leader.record
                        }
                        for (local u = 0; u < thisArmy.unitCount; u++) {
                            local unit = thisArmy.unit(u)
                            ::EUR.losses_upkeep = ::EUR.losses_upkeep + unit.type.upkeep
                        }
                    } else if (::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.war, thisArmy.faction, ::EUR.eur_player_faction)) {
                        this.collectEnemyPreBattle(thisArmy, thisBattle)
                    }
                }
                k = k + 1
            } while (thisSide.armySlot(k) != null)
        }
    }

    function collectEnemyPreBattle(thisArmy, thisBattle) {
        local matchedSlots = {}
        local checkedAlready = {}
        for (local j = 0; j < thisArmy.unitCount; j++) {
            local un = thisArmy.unit(j)
            if (un.type.category == 4) continue
            this.spoils_loot = this.spoils_loot + un.type.upkeep
            this.matchGarrisonSlot(thisArmy.faction.name, null, un, j, matchedSlots, checkedAlready, function(entry) {
                entry.pre_battle = true
                ::EUR.pre_battle_faction = thisArmy.faction.name
                if (!::EUR.tableContains(::EUR.pre_battle_garrison, un.name)) { ::EUR.pre_battle_garrison.append(un.name) }
            })
        }
        if (thisBattle.conflictType == 5) { this.spoils_loot = 0 }
        if (thisArmy.leader == null) return
        if (::EUR.math.random(1, 100) > 10) { ::EUR.alt_loot = true }
        if (thisArmy.leader.record == null) return
        ::EUR.alt_loot_anc = []
        ::EUR.alt_loot_enemy_gen = thisArmy.leader.record
        for (local x = 0; x < thisArmy.leader.record.ancillaryCount; x++) {
            local anc = thisArmy.leader.record.getAncillary(x)
            if (anc != null && anc.isTransferable == true && anc.isUnique == false) {
                ::EUR.alt_loot_anc.append(anc)
            }
        }
    }

    // returns true if the player lost this battle (recording the loss), else records victory type.
    function getBattleOutcome() {
        ::EUR.logHelper("getBattleOutcome")
        local thisBattle = ::battle.current()
        if (thisBattle == null) return false
        for (local i = 0; i < thisBattle.sideCount; i++) {
            local thisSide = thisBattle.side(i)
            if (thisSide.armySlot(0) == null) continue
            local k = 0
            do {
                local thisArmy = thisSide.armySlot(k).army
                if (thisArmy != null && thisArmy.faction.isPlayerControlled == 1) {
                    if (thisSide.result == 0) {
                        ::EUR.battles_lost = ::EUR.battles_lost + 1
                        this.lost_battle = true
                        return true
                    } else {
                        this.victory_type = thisSide.success
                    }
                }
                k = k + 1
            } while (thisSide.armySlot(k) != null)
        }
        return false
    }

    function getBattleOutcomeWin() {
        ::EUR.logHelper("getBattleOutcomeWin")
        local thisBattle = null
        try { thisBattle = ::battle.current() } catch (err) { return }   // TODO: correct battle accessor for this host
        if (thisBattle == null) return

        for (local i = 0; i < thisBattle.sideCount; i++) {
            local thisSide = thisBattle.side(i)
            if (thisSide.armySlot(0) == null) continue
            local k = 0
            do {
                local thisArmy = thisSide.armySlot(k).army
                if (thisArmy != null) {
                    if (thisArmy.faction.isPlayerControlled == 1) {
                        this.awardPlayerExperience(thisSide)
                        if (!thisSide.isDefender && thisSide.result == 2) {
                            this.recordPlayerVictory(thisSide)
                        }
                    } else {
                        this.reconcileEnemyGarrison(thisArmy)
                    }
                }
                k = k + 1
            } while (thisSide.armySlot(k) != null)
        }
        ::EUR.pre_battle_faction = ""
        ::EUR.pre_battle_garrison = []
    }

    // nudge surviving player cavalry (category 1) that gained experience up one chevron.
    function awardPlayerExperience(thisSide) {
        for (local y = 0; y < thisSide.armyCount; y++) {
            local battleArmy = thisSide.armyStats(y)
            if (battleArmy.army.faction != ::EUR.eur_player_faction) continue
            for (local x = 0; x < battleArmy.unitCount; x++) {
                local battleUnit = battleArmy.unitStats(x)
                if (battleUnit == null || battleUnit.unit == null) continue
                if (battleUnit.isGeneralUnit != 0) continue
                if (battleUnit.unit.isDead) continue
                if (battleUnit.unit.type == null || battleUnit.unit.type.category != 1) continue
                if (battleUnit.experienceGained == null) continue
                local newExp = (battleUnit.experienceGained > 0) ? battleUnit.experienceStart + 1 : battleUnit.experienceStart
                battleUnit.unit.setParams(newExp, battleUnit.unit.armourLevel, battleUnit.unit.weaponLevel)
            }
        }
    }

    function recordPlayerVictory(thisSide) {
        this.victory_type = thisSide.success
        ::EUR.won_battle = true
        ::EUR.won_battle_alt = true
        local battleArmy = thisSide.armyStats(0)
        if (battleArmy == null) return

        if (battleArmy.general != null && battleArmy.general.typeId == 7
            && battleArmy.general.record != null) {
            local record = battleArmy.general.record
            local name = record.shortName + ("" + record.label)
            if (name in ::EUR.persistent_gen_list) {
                local killsClamped = (battleArmy.generalKills > 200) ? 200 : battleArmy.generalKills
                ::EUR.persistent_gen_list[name].battle_kills = ::EUR.persistent_gen_list[name].battle_kills + killsClamped
                ::EUR.persistent_gen_list[name].battle_won = ::EUR.persistent_gen_list[name].battle_won + 1
            }
        }

        ::EUR.alt_loot_units = []
        for (local x = 0; x < battleArmy.unitCount; x++) {
            local battleUnit = battleArmy.unitStats(x)
            if (battleUnit == null) continue
            if (battleUnit.isGeneralUnit == 0) {
                if (battleUnit.unit.type != null && battleUnit.unit.type.category == 0) {
                    ::EUR.alt_loot_units.append({
                        unit = battleUnit.unit,
                        kills = battleUnit.soldiersKilled,
                        caught = battleUnit.prisonersCaught,
                        expgain = battleUnit.experienceGained,
                    })
                }
            } else if (battleUnit.unit != null && battleUnit.unit.general != null
                    && battleUnit.unit.general.record != null) {
                local record = battleUnit.unit.general.record
                local name = record.shortName + ("" + record.label)
                if (name in ::EUR.persistent_gen_list) {
                    local killsClamped = (battleUnit.soldiersKilled > 200) ? 200 : battleUnit.soldiersKilled
                    ::EUR.persistent_gen_list[name].battle_kills = ::EUR.persistent_gen_list[name].battle_kills + killsClamped
                }
            }
        }
    }

    function reconcileEnemyGarrison(thisArmy) {
        local matchedSlots = {}
        local checkedAlready = {}
        for (local j = 0; j < thisArmy.unitCount; j++) {
            local un = thisArmy.unit(j)
            if (un == null) continue
            if (un.name.indexof("Garrison") == null) continue
            if (!un.isDead) { un.movePoints = 0 }
            local settlement = thisArmy.inSettlement()
            local settName = (settlement != null) ? settlement.name : null
            this.matchGarrisonSlot(thisArmy.faction.name, settName, un, j, matchedSlots, checkedAlready, function(entry) {
                entry.count = un.soldiers
                entry.post_battle = true
            })
        }
    }
}

::EUR.eurAddSpoils <- eurAddSpoils()
