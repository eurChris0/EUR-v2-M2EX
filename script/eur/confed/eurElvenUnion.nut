class eurElvenUnion {
    function fixWoodElvesUnion() {
        local tauriel = ::EUR.getnamedCharbyLabel("tauriel_1")
        if (tauriel != null) {
            ::EUR.setBodyguard(tauriel.character, "Aredhirith", 4, 0, 0, "")
        }
        if (::EUR.eur_player_faction.name != "mongols") return
        if (::EUR.eur_sMap.findSettlement("Celebrant").owner.name != "mongols") return

        local sett = ::EUR.eur_sMap.findSettlement("Celebrant")
        local army = ::EUR.eurSpawnCustomGeneral("mongols", "Artanis", "galadriel_1", "galadriel", true, 28,
            "Berio I Ngelaidh", sett.tileX - 1, sett.tileY, 5, 0, 0, "galadriel", "galadriel")
        ::EUR.anorien_swap.galadriel_spawned = true
        if (::EUR.eur_sMap != null) {
            ::game.showHistoricEvent("galadriel_spawned", ::EUR.galadriel_spawn_title, ::EUR.galadriel_spawn_body)
        }
        if (army.leader == null) return
        local char = army.leader.record
        if (char == null) return

        char.addTrait("Hero", 1)
        char.addTrait("ElvenRace", 1)
        char.addTrait("Noldor", 1)
        char.addTrait("IsFamily", 1)
        char.addTrait("Galadriel", 1)
        char.addTrait("ElvesBattleSurgery", 1)
        char.addTrait("Loyal", 1)
        char.addTrait("Just", 2)
        char.addTrait("LoyaltyStarter", 1)
        char.addTrait("LivedAges", 1)
        char.addTrait("Hatesengland", 1)
        char.addTrait("GoodCommander", 2)
        char.addTrait("TacticalSkill", 2)
        char.addTrait("GoodAdministrator", 3)
        char.addTrait("NaturalManagementSkill", 3)
        char.addTrait("NaturalMilitarySkill", 2)
        char.addTrait("KindRuler", 2)
        char.addTrait("FathersLegacy", 1)
        char.addTrait("Handsome", 3)
        char.addAncillary("nenya")
        char.character.heroAbility = "Light_of_the_Faith"
    }
}

::EUR.eurElvenUnion <- eurElvenUnion()
