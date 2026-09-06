::EUR.spawnGeneralLargeArmy <- function(faction) {
    ::EUR.logHelper("spawnGeneralLargeArmy")
    if (!::EUR.options_general_large_army) return
    if (faction.name == "rebels") return
    if (::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.alliance, ::EUR.eur_player_faction, faction)) return

    for (local i = 0; i < faction.armyCount; i++) {
        // re-checked each pass: spawning adds a family member, so stop once the faction has enough
        if (faction.countCharactersOfType(::Enum.CharacterType.namedCharacter) >= (faction.settlementCount + 2)) continue

        local army = faction.army(i)
        if (army == null || army.leader == null) continue
        if (army.leader.typeId == ::Enum.CharacterType.namedCharacter) continue
        if (army.unitCount <= 6 || army.unitCount >= 20) continue

        local charmy = ::EUR.eurSpawnArmy(faction.name, "random_name", "large_army_", "", false, 31,
            ::EUR.default_general_units[faction.name].old, army.tileX, army.tileY, 2, 1, 0)
        if (charmy == null) continue

        charmy.leader.record.addTrait("AIBoost", 1)
        charmy.leader.record.addTrait("BattleScarred", 2)
        charmy.leader.record.addTrait("GoodAmbusher", 2)
        charmy.leader.record.addTrait("GoodCommander", 3)
        charmy.leader.record.addTrait("LoyaltyStarter", 1)
        charmy.leader.record.addTrait("PietyStarter", 1)
        charmy.mergeInto(army, true)
        ::EUR.setBGSize(faction, null, null)
    }
    ::EUR.logHelper("spawnGeneralLargeArmy end")
}
