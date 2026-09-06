class eurMergeArmies {
    MAX_MERGE_DISTANCE = 7    // furthest apart (in tiles) two armies can be and still merge
    MAX_COMBINED_UNITS = 20   // a merged army can't exceed a full stack

    // leader type IDs
    LEADER_ADMIRAL = 3        // fleet commander
    LEADER_GENERAL = 6        // land army general
    LEADER_CAPTAIN = 7        // secondary commander

    function currentTurn() {
        return ::EUR.eur_turn_number
    }

    function distanceBetween(army, targetArmy) {
        if (army == null || targetArmy == null) return 1.0e30
        local dx = army.tileX - targetArmy.tileX
        local dy = army.tileY - targetArmy.tileY
        return ::EUR.math.sqrt(dx * dx + dy * dy)
    }

    // fold every compatible nearby same-faction army into targetArmy; returns whether anything merged.
    function mergeNearbyArmies(targetArmy) {
        if (targetArmy == null || targetArmy.faction == null) return false
        local didMerge = false
        for (local i = 0; i < targetArmy.faction.armyCount; i++) {
            local army = targetArmy.faction.army(i)
            if (army == null || army.leader == null) continue
            if (army == targetArmy) continue
            if (army.siege) continue
            if (this.distanceBetween(army, targetArmy) > this.MAX_MERGE_DISTANCE) continue
            if (army.unitCount + targetArmy.unitCount >= this.MAX_COMBINED_UNITS) continue

            local armyLeader = army.leader.typeId
            local targetLeader = targetArmy.leader.typeId

            // only general+general or general+captain (never captain+captain, never mixed sea/land)
            local compatible = (armyLeader == this.LEADER_GENERAL && targetLeader == this.LEADER_GENERAL)
                            || (armyLeader == this.LEADER_GENERAL && targetLeader == this.LEADER_CAPTAIN)
                            || (armyLeader == this.LEADER_CAPTAIN && targetLeader == this.LEADER_GENERAL)
            if (!compatible) continue

            if (targetLeader != this.LEADER_ADMIRAL) {
                try { army.mergeInto(targetArmy, true); didMerge = true } catch (e) {}
            } else {
                // fleets: merge empty ones, or fleets whose transported armies also fit together
                if (!targetArmy.transportedArmy && !army.transportedArmy) {
                    try { army.mergeInto(targetArmy, true); didMerge = true } catch (e) {}
                } else if (army.transportedArmy && targetArmy.transportedArmy
                        && army.transportedArmy.unitCount + targetArmy.transportedArmy.unitCount <= this.MAX_COMBINED_UNITS) {
                    try {
                        army.transportedArmy.mergeInto(targetArmy.transportedArmy, true)
                        army.mergeInto(targetArmy, true)
                        didMerge = true
                    } catch (e) {}
                }
            }
        }
        return didMerge
    }

    function mergeFactionArmies(faction) {
        ::EUR.logHelper("mergeFactionArmies")
        if (faction == null) return false
        if (faction.isPlayerControlled == 1) return false
        if (this.currentTurn() % 20 == 0) return false   // take every 20th turn off

        local didMerge = false
        for (local a = 0; a < faction.armyCount; a++) {
            local targetArmy = faction.army(a)
            if (targetArmy != null && targetArmy.leader) {
                didMerge = this.mergeNearbyArmies(targetArmy) || didMerge
            }
        }
        ::EUR.logHelper("mergeFactionArmies end")
        return didMerge
    }
}

::EUR.eurMergeArmies <- eurMergeArmies()
