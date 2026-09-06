if (::EUR.EUR_EVENT_TRIGGERS.battle) {

    ::events.on("PostBattle", function(eventData) {
        ::EUR.logHelper("onPostBattle")
        if (eventData.faction.name == "slave") { return }
        ::EUR.in_campaign_map = true
        // disabled (needs battle accessor): ::EUR.eurAddSpoils.getBattleOutcomeWin()
        if (eventData.faction.isPlayerControlled == 1) {
            ::EUR.show_alt_loot = true
            // disabled: ::EUR.eurAddSpoils.postBattleChecks(eventData.faction)
            //wait(restoreSplitUnits, 2, true)
        }
    })

    ::events.on("PreBattleWithdrawal", function(eventData) {
        ::EUR.logHelper("onPreBattleWithdrawal")
        ::EUR.resetPostBattleGarrison()
        if (eventData.faction.name == "slave") { return }
        ::EUR.in_campaign_map = true
        ::EUR.eur_pre_battle = false
        ::EUR.eur_pre_battle_window = false
        ::EUR.eur_already_saved = false
        ::EUR.losses_upkeep = 0
    })

    // The deployment phase has begun. Exports: faction, religion
    ::events.on("BattleDeploymentPhaseCommenced", function(eventData) {
        // removed host-global cache (::Battle.current() is the host API global)
    })

    // The conflict phase has begun. Exports: faction, religion
    ::events.on("BattleConflictPhaseCommenced", function(eventData) {
        // removed host-global cache (::Battle.current() is the host API global)
        // ::EUR.BATTLE_AI.initialize()
        // if (::EUR.game_options.disable_skirmish) {
            // ::EUR.BATTLE_AI.disablePlayerSkirmishMode()
        // }
        // ::EUR.BATTLE_AI.start()
    })

    ::events.on("battleTick", function() {
        // if (::Battle.current().ticksSinceBattleStart % 100 == 0) {   // TODO host: ::Battle.current()
            // ::EUR.BATTLE_AI.update()
        // }
        //BATTLE_GUI.updateRegionInfoFade()
    })

}
