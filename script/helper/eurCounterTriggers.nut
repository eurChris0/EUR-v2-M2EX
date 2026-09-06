if (::EUR.EUR_EVENT_TRIGGERS.counter) {

    ::events.on("EventCounter", function(eventData) {
        ::EUR.logHelper("onEventCounter")
        if (eventData.eventCounter == "elven_union") {
            ::EUR.removeAiGarrison(::EUR.eur_player_faction, false)
            ::EUR.eurElvenUnion.fixWoodElvesUnion()
        }
        if (eventData.eventCounter == "WKcangotoCD") {
            ::EUR.removeAiGarrison(::EUR.eur_player_faction, false)
            ::EUR.eurEregion.killWitchKing()
        }

        if (eventData.eventCounter == "reunited_kingdom_gondor_side") {
            ::EUR.removeAiGarrison(::EUR.eur_player_faction, false)
            ::EUR.eurReunitedKingdom.fixRKGondor()
        }
        if (eventData.eventCounter == "reunited_kingdom") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_revival["sicily"].revived_already = true
                ::EUR.faction_revival["sicily"].revived_already_ai = true
            }
        }
        if (eventData.eventCounter == "blue_wizards_arrive") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_disposition["khand"] = "good"
            }
        }
        if (eventData.eventCounter == "dunland_traitor") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_disposition["aztecs"] = "neutral"
            }
        }
        if (eventData.eventCounter == "kon_council_choice_accepted") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_revival["denmark"].revived_already = true
                ::EUR.faction_revival["saxons"].revived_already = true
                ::EUR.faction_revival["denmark"].revived_already_ai = true
                ::EUR.faction_revival["saxons"].revived_already_ai = true
            }
        }
        if (eventData.eventCounter == "elven_union") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_revival["mongols"].revived_already = true
                ::EUR.faction_revival["ireland"].revived_already = true
                ::EUR.faction_revival["mongols"].revived_already_ai = true
                ::EUR.faction_revival["ireland"].revived_already_ai = true
            }
        }
        if (eventData.eventCounter == "durin_stop_7") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_revival["hungary"].revived_already = true
                ::EUR.faction_revival["moors"].revived_already = true
                ::EUR.faction_revival["hungary"].revived_already_ai = true
                ::EUR.faction_revival["moors"].revived_already_ai = true
            }
        }
        if (eventData.eventCounter == "durin_kh_ok") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_revival["hungary"].revived_already = true
                ::EUR.faction_revival["norway"].revived_already = true
                ::EUR.faction_revival["hungary"].revived_already_ai = true
                ::EUR.faction_revival["norway"].revived_already_ai = true
            }
        }
        if (eventData.eventCounter == "fusion_bc_accepted") {
            if (::EUR.checkCounter(eventData.eventCounter)) {
                ::EUR.faction_revival["normans"].revived_already = true
                ::EUR.faction_revival["hre"].revived_already = true
                ::EUR.faction_revival["normans"].revived_already_ai = true
                ::EUR.faction_revival["hre"].revived_already_ai = true
            }
        }
    })

}
