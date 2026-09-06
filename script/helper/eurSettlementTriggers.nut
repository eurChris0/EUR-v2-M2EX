if (::EUR.EUR_EVENT_TRIGGERS.settlement) {

    ::events.on("GiveSettlement", function(eventData) {
        ::EUR.logHelper("onGiveSettlement")
        local name = eventData.settlement.name
        ::EUR.eurSwapUnitsOnTrade(name)
    })

    ::events.on("GeneralCaptureSettlement", function(eventData) {
        ::EUR.logHelper("onGeneralCaptureSettlement")
        if (::EUR.game_options.global_recruitment) {
            ::EUR.eurGlobalRecruitment.globalClearLostSett(eventData.settlement)
        }
    })

    ::events.on("SettlementTurnStart", function(eventData) {
        if (::EUR.to_log) { println("EUR SCRIPT: " + "onSettlementTurnStart") }
        ::EUR.clampGarrisonSett(eventData.settlement)
        if (::EUR.game_options.convert_buildings) {
            ::EUR.eurfixBuildingPics(eventData.settlement)
        }
        if (eventData.settlement.name in ::EUR.strat_cas_setts) {
            if (!(eventData.settlement.name in ::EUR.cas_set_already)) {
                ::EUR.setCasSett(eventData.settlement)
                ::EUR.cas_set_already[eventData.settlement.name] <- true
            }
        }
        if (::EUR.eur_player_faction.name == "milan" || ::EUR.eur_player_faction.name == "france") {
            //eurHelmsBrick.checkForBrick(eventData)
        }
        if (::EUR.to_log) { println("EUR SCRIPT END: " + "onSettlementTurnStart") }
    })

    ::events.on("SettlementSelected", function(eventData) {
        if (::EUR.hud_show_units_tab_pressed) {
            ::EUR.show_replen_ui = true
        } else {
            ::EUR.show_replen_ui = false
        }
        ::EUR.alias_text = ""
        ::EUR.alias_text_set = false
        local governor = eventData.settlement.governor
        local army = eventData.settlement.army
        if (governor != null && governor.typeId == 7) {
            ::EUR.temp_fort_char = governor
            if (governor.bodyguard != null) { ::EUR.sel_unit = governor.bodyguard }
            else if (army != null && army.unitCount > 0) { ::EUR.sel_unit = army.unit(0) }
        } else {
            ::EUR.temp_fort_char = null
            if (army != null && army.unitCount > 0) { ::EUR.sel_unit = army.unit(0) }
        }
        if (::EUR.options_gen_upgrades) {
            ::EUR.setBGSize(eventData.settlement.owner, null, null)
        }
    })

    ::events.on("GuildUpgraded", function(eventData) {
        ::EUR.logHelper("onGuildUpgraded")
        if (eventData.faction == ::EUR.eur_player_faction) {
            if (eventData.guildId == 7) {
                ::EUR.checkEngineerGuild()
            }
        }
    })

    ::events.on("BuildingDestroyed", function(eventData) {
        ::EUR.logHelper("onBuildingDestroyed")
        if (eventData.faction == ::EUR.eur_player_faction) {
            //if (eventData.guildId == 7) {
                ::EUR.checkEngineerGuild()
            //}
        }
    })

    ::events.on("AddedToTrainingQueue", function(eventData) {
        ::EUR.logHelper("onAddedToTrainingQueue")
        if (::EUR.game_options.global_recruitment) {
            ::EUR.eurGlobalRecruitment.recruitCheckGlobal()
        }
    })

    ::events.on("removeFromUnitQueue", function(eventData) {
        ::EUR.logHelper("onRemoveFromUnitQueue")
        if (::EUR.game_options.global_recruitment) {
            ::EUR.eurGlobalRecruitment.recruitCheckGlobal()
        }
    })

    ::events.on("UnitTrained", function(eventData) {
        ::EUR.logHelper("onUnitTrained")
        if (eventData.faction.name == "slave") { return }
        if (::EUR.options_gen_upgrades) {
            ::EUR.setBGSize(null, null, eventData.playerUnit)
        }
        if (eventData.faction == ::EUR.eur_player_faction) {
            ::EUR.tulkasCheck(eventData.faction.id, eventData.playerUnit, true)
        }
    })

    ::events.on("GovernorUnitTrained", function(eventData) {
        ::EUR.logHelper("onGovernorUnitTrained")
        if (::EUR.options_gen_upgrades) {
            ::EUR.setBGSize(eventData.faction, null, null)
        }
    })

    ::events.on("UnitDisbanded", function(eventData) {
        ::EUR.sel_unit = null
    })

}
