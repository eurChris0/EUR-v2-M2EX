local SETT_NAME = "Helms_Deep"     // internal descr_strat name
local LEGO_NAME = "Helm's Brick"   // localizedName that fires the egg
local ATTACK_X = 231, ATTACK_Y = 260   // besieging army tile
local REINF_X  = 231, REINF_Y  = 259   // friendly reinforcement tile

// each entry is { type = EDU name, exp, armor, weapon }; the bodyguard unit is passed to eurSpawnArmy.
local ATTACK_VS_ROHAN = [
    { type = "Lego Uruk-hai Infantry",          exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry",          exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 5, armor = 1, weapon = 1 },
    { type = "Berserker",                       exp = 5, armor = 0, weapon = 0 },
]
local REINF_FOR_ROHAN = [
    { type = "Lego Rohirrim", exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Rohirrim", exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
]
local ATTACK_VS_ISENGARD = [
    { type = "Lego Rohirrim", exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Rohirrim", exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Spearmen", exp = 5, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 5, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 5, armor = 1, weapon = 0 },
]
local REINF_FOR_ISENGARD = [
    { type = "Lego Uruk-hai Infantry",          exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry",          exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 4, armor = 1, weapon = 1 },
    { type = "Berserker",                       exp = 4, armor = 0, weapon = 0 },
    { type = "Berserker",                       exp = 4, armor = 0, weapon = 0 },
]

class eurHelmsBrick {
    // traits so the AI commands the general well and script cleanup can't remove it (Locked)
    function applyLegoGeneralTraits(namedChar) {
        if (namedChar == null) return
        namedChar.addTrait("AIBoost", 1)
        namedChar.addTrait("Locked", 1)
        namedChar.addTrait("GoodCommander", 3)
        namedChar.addTrait("BattleScarred", 2)
        namedChar.addTrait("NightBattleCapable", 1)
    }

    // spawn a LEGO army at (x, y), fill it from unitList, and return it (or null).
    function spawnLegoArmy(factionName, shortName, label, bgUnit, x, y, unitList) {
        local army = ::EUR.eurSpawnArmy(factionName, shortName, label, "", false, 35, bgUnit, x, y, 4, 1, 1)
        if (army == null) {
            ::EUR.logHelper("HelmsBrick: eurSpawnArmy returned null for '" + label + "'")
            return null
        }
        foreach (u in unitList) {
            army.createUnit(u.type, u.exp, u.armor, u.weapon, -1)
        }
        if (army.leader != null) {
            this.applyLegoGeneralTraits(army.leader.record)
        }
        return army
    }

    // player is Rohan: Isengard besieges, Rohan relief arrives.
    function spawnForRohan() {
        local sett = ::EUR.eur_sMap.findSettlement(SETT_NAME)
        if (sett == null) return
        local attArmy = this.spawnLegoArmy("france", "Uruk Commander", "helmsbrick_att_r",
            "Lego Uruk-hai Infantry", ATTACK_X, ATTACK_Y, ATTACK_VS_ROHAN)
        this.spawnLegoArmy("milan", "Rohirrim Marshal", "helmsbrick_rei_r",
            "Lego Rohirrim", REINF_X, REINF_Y, REINF_FOR_ROHAN)
        if (attArmy != null) { attArmy.besiegeSettlement(sett, true) }
    }

    // player is Isengard: Rohan besieges, Isengard relief arrives.
    function spawnForIsengard() {
        local sett = ::EUR.eur_sMap.findSettlement(SETT_NAME)
        if (sett == null) return
        local attArmy = this.spawnLegoArmy("milan", "Rohan General", "helmsbrick_att_i",
            "Lego Rohirrim", ATTACK_X, ATTACK_Y, ATTACK_VS_ISENGARD)
        this.spawnLegoArmy("france", "Uruk Vanguard", "helmsbrick_rei_i",
            "Lego Uruk-hai Infantry", REINF_X, REINF_Y, REINF_FOR_ISENGARD)
        if (attArmy != null) { attArmy.besiegeSettlement(sett, true) }
    }

    // onSettlementTurnStart hook: detect the rename and arm the counter, one-shot.
    function checkForBrick(eventData) {
        local sett = eventData.settlement
        if (sett == null) return
        if (sett.displayName != LEGO_NAME) return
        if (::EUR.eur_player_faction == null) return
        local fName = ::EUR.eur_player_faction.name
        if (fName != "milan" && fName != "france") return
        if (sett.owner == null || sett.owner.name != fName) return
        if (::EUR.game_options.helm_bricked) return

        ::game.campaign().setEventCounter("brick_me", 1)
        ::EUR.game_options.helm_bricked = true
    }

    // onFactionTurnStart hook: on the player's turn, if armed, spawn the battle (once).
    function triggerIfReady(eventData) {
        if (eventData.faction.isPlayerControlled != 1) return
        if (::game.campaign().getEventCounter("brick_me") != 1) return
        ::game.campaign().setEventCounter("brick_me", 0)

        local fName = ::EUR.eur_player_faction.name
        if (fName == "milan") { this.spawnForRohan() }
        else if (fName == "france") { this.spawnForIsengard() }
    }
}

::EUR.eurHelmsBrick <- eurHelmsBrick()
