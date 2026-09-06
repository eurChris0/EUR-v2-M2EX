::EUR.replen_exempt <- [
    "Sauron",
    "Moria Balrog",
    "Armored Balrog",
    "Goblin King",
]

class eurReplenishment {

    function replenishUnits(faction) {
        local bonus = 0
        if (faction.isPlayerControlled == 1) { bonus = bonus + ::EUR.replen_bonus }
        if (faction.isPlayerControlled == 0) { bonus = 8 }

        for (local x = 0; x < faction.fortCount; x++) {
            local fort = faction.fort(x)
            if (fort.army != null && fort.siegeCount == 0) {
                this.replenishArmy(fort.army, faction, bonus, false, false, false)
            }
        }
        for (local x = 0; x < faction.settlementCount; x++) {
            local settlement = faction.settlement(x)
            if (settlement.army != null && settlement.siegeCount == 0) {
                local waystation = settlement.hasBuildingLevel("military_academy", false)
                local aquaduct   = settlement.hasBuildingLevel("aqueduct", true)
                this.replenishArmy(settlement.army, faction, bonus, waystation, aquaduct, false)
            }
        }
        if (::EUR.replen_always) {
            for (local x = 0; x < faction.armyCount; x++) {
                local army = faction.army(x)
                if (army != null && !(army.inSettlement() || army.inFort())) {
                    this.replenishArmy(army, faction, bonus, false, false, true)
                }
            }
        }
    }

    // one army's units. isField selects the field rate (own/allied/other) instead of the garrison rate.
    function replenishArmy(army, faction, bonus, waystation, aquaduct, isField) {
        local goblin = ::EUR.tableContains(::EUR.goblin_factions, faction.name)
        local men    = ::EUR.tableContains(::EUR.men_factions, faction.name)

        local road = ::EUR.replenRoadLevel(army.regionId)   // [road_level, owner]
        local road_level = road[0]
        local owner = road[1]
        local roadDivisor = (road_level != 0 && ::EUR.replen_values.replen_road_level[road_level] != 0)
                            ? ::EUR.replen_values.replen_road_level[road_level] : 0

        local fieldDivisor = 0
        if (isField) {
            fieldDivisor = ::EUR.replen_values.replen_field_other
            if (owner != null) {
                if (owner == faction) { fieldDivisor = ::EUR.replen_values.replen_field_own }
                else if (::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.alliance, faction, owner)) { fieldDivisor = ::EUR.replen_values.replen_field_own }
            }
        }

        for (local i = 0; i < army.unitCount; i++) {
            local stack_unit = army.unit(i)
            if (stack_unit == null) continue
            if (stack_unit.name != null && stack_unit.name.indexof("Garrison") != null) continue
            if (stack_unit.type.category == 4) continue

            // pre-bonus divisors, in source order
            local pre = []
            if (roadDivisor != 0) pre.append(roadDivisor)
            if (!isField && ::EUR.replen_values.replen_multi != 0) pre.append(::EUR.replen_values.replen_multi)
            if (goblin && ::EUR.replen_values.goblin_bonus != null && ::EUR.replen_values.goblin_bonus > 0) pre.append(::EUR.replen_values.goblin_bonus)
            if (men    && ::EUR.replen_values.men_bonus    != null && ::EUR.replen_values.men_bonus    > 0) pre.append(::EUR.replen_values.men_bonus)
            if (isField && fieldDivisor != 0) pre.append(fieldDivisor)

            // post-bonus divisors (settlements only)
            local post = []
            if (!isField) {
                if (waystation && ::EUR.replen_values.waystation_bonus != 0) post.append(::EUR.replen_values.waystation_bonus)
                if (aquaduct   && ::EUR.replen_values.aquaduct_bonus   != 0) post.append(::EUR.replen_values.aquaduct_bonus)
            }

            this.replenUnit(stack_unit, faction, bonus, pre, post)
        }
    }

    function replenUnit(stack_unit, faction, bonus, pre, post) {
        local maxCount = stack_unit.soldiersMax
        local random_value = ::EUR.math.random(::EUR.replen_values.replen_randmin, ::EUR.replen_values.replen_randmax)

        foreach (d in pre)  { random_value = ::EUR.math.ceil(maxCount / d + random_value) }
        random_value = random_value + bonus
        foreach (d in post) { random_value = ::EUR.math.ceil(maxCount / d + random_value) }
        if (::EUR.replen_values.replen_bonus != null && ::EUR.replen_values.replen_bonus > 0) {
            random_value = ::EUR.math.floor(random_value * (1 + (::EUR.replen_values.replen_bonus / 100.0)))
        }
        if (stack_unit.type.category == 1) {
            random_value = ::EUR.math.random(1, 2)
            random_value = ::EUR.math.ceil(maxCount / 50 + random_value)
        }
        if (stack_unit.type.soldierCount <= 10) { random_value = 1 }

        this.applyReplen(stack_unit, faction, random_value)
    }

    // the clamp + player-cost block that was identical across all three loops
    function applyReplen(stack_unit, faction, random_value) {
        local edu = stack_unit.type
        if (edu != null && edu.soldierCount > ::EUR.replen_beast_value) {
            local unit_soldier_max = stack_unit.soldiersMax
            local unit_soldier = stack_unit.soldiers
            local exempt = ::EUR.tableContains(::EUR.replen_exempt, edu.name)

            if (unit_soldier + random_value < unit_soldier_max) {
                stack_unit.soldiers = exempt ? 1 : (unit_soldier + random_value)
                if (faction == ::EUR.eur_player_faction && !exempt) {
                    local cost = ::EUR.math.floor(edu.recruitCost / stack_unit.soldiers) * random_value
                    ::EUR.replen_totals = ::EUR.replen_totals + cost
                    ::EUR.replenished_over_turn = true
                }
            }
            if (unit_soldier_max - (unit_soldier + random_value) < 2) {
                local diff = unit_soldier_max - stack_unit.soldiers
                stack_unit.soldiers = exempt ? 1 : unit_soldier_max
                if (faction == ::EUR.eur_player_faction && !exempt) {
                    local cost = ::EUR.math.floor(edu.recruitCost / stack_unit.soldiers) * diff
                    ::EUR.replen_totals = ::EUR.replen_totals + cost
                    ::EUR.replenished_over_turn = true
                }
            }
        }
        if (::EUR.tableContains(::EUR.replen_exempt, stack_unit.type.name)) { stack_unit.soldiers = 1 }
    }

    function deductReplen() {
        if (!::EUR.replenished_over_turn) return
        local multi = ::EUR.replen_cost_multi / 100.0
        if (multi == null || multi == 0) return
        if (::EUR.replen_totals != null && ::EUR.replen_totals > 1) {
            ::EUR.replen_totals = ::EUR.math.floor(::EUR.replen_totals * multi)
            ::game.runConsoleCommand("add_money", "-" + ("" + ::EUR.replen_totals))
            println("===================== deducted replenishment costs " + ::EUR.replen_totals)
        }
        ::EUR.replen_totals = 0
        ::EUR.replenished_over_turn = false
    }
}

::EUR.eurReplenishment <- eurReplenishment()

::EUR.setRadagastLevel <- function() {
    local named = ::EUR.getnamedCharbyLabel("radagast")
    if (named == null || named.character == null) return
    local char = named.character
    if (char.markedForDeath) return
    if (char.bodyguard == null) return
    if (char.bodyguard.soldiers < 21) {
        char.bodyguard.soldiers = char.bodyguard.soldiers + 2
        if (char.bodyguard.soldiers > 20) { char.bodyguard.soldiers = 20 }
    }
}
