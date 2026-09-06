class eurReunitedKingdom {
    function fixRKGondor() {
        // unlockGameConsoleCommands removed — console always available
        ::EUR.eur_player_faction = ::EUR.eur_campaign.factionByName("turks")
        ::EUR.eur_playerFactionId = ::EUR.eur_player_faction.id

        ::EUR.defaultEDUEDBReset()
        ::EUR.eurGlobalVars()
        ::EUR.defaultEDUOffset()
        if (::EUR.options_legendary) { ::EUR.defaultEDUOffset_leg() }
        if (::EUR.chris_stuff && ::EUR.add_setts) { ::EUR.defaultEDUOffsetSetts() }

        ::EUR.list_edu_table_default = []
        for (local i = 0; i < 1500; i++) {
            local eduEntry = ::units.at(i)
            if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_player_faction.id)) {
                ::EUR.list_edu_table_default.append(eduEntry.index)
            }
        }

        ::game.campaign().setEventCounter("arnor_restored", 1)
        ::game.campaign().setEventCounter("nd_choose_arnor", 1)
        ::EUR.loadImages()
        ::game.campaign().setEventCounter("faction_ID_turks", 1)
        ::game.campaign().setEventCounter("faction_ID_sicily", 0)

        local faramir_1 = ::EUR.getnamedCharbyLabel("faramir_1")
        if (faramir_1 != null) { faramir_1.character.sendOffMap() }
    }
}

::EUR.eurReunitedKingdom <- eurReunitedKingdom()
