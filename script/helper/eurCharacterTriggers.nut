if (::EUR.EUR_EVENT_TRIGGERS.character) {

    ::events.on("CharacterSelected", function(eventData) {
        ::EUR.hud_show_units_tab_pressed = true
        ::EUR.show_replen_ui = true
        ::EUR.alias_text = ""
        ::EUR.alias_text_set = false
        local character = eventData.characterRecord.character
        if (character.typeId == 7) {
            ::EUR.temp_fort_char = character
            if (character.bodyguard != null) { ::EUR.sel_unit = character.bodyguard }
            else if (character.army != null) { ::EUR.sel_unit = character.army.unit(0) }
        } else if (character.typeId == 6) {
            ::EUR.temp_fort_char = null
            if (character.army != null) { ::EUR.sel_unit = character.army.unit(0) }
        } else {
            ::EUR.temp_fort_char = null
        }
        if (::EUR.options_sort == true) {
            ::EUR.eurSortStack.eurSortOnSelected(eventData.characterRecord)
        }
        if (::EUR.options_gen_upgrades) {
            ::EUR.setBGSize(eventData.faction, null, null)
        }
    })

    ::events.on("GeneralAssaultsGeneral", function(eventData) {
        ::EUR.logHelper("onGeneralAssaultsGeneral")
        if (::EUR.options_hardcore) {
            if (eventData.characterType == 3) {
                ::EUR.eur_campaign.restrictAutoResolve = 0
            } else {
                ::EUR.eur_campaign.restrictAutoResolve = 1
            }
        }
    })

    ::events.on("CharacterTurnStart", function(eventData) {
        ::EUR.logHelper("onCharacterTurnStart")
        if (eventData.characterRecord.character != null) {
            if (eventData.characterRecord.character.typeId == 7) {
                ::EUR.clampGarrison(eventData.characterRecord.character)
            }
        }
        if (eventData.characterType == 7) {
            if (eventData.faction.name == "sicily") {
                ::EUR.addGondorFiefTrait(eventData.characterRecord)
            }
        }
        ::EUR.fixCharUniqueName(eventData.characterRecord)
        ::EUR.logHelper("onCharacterTurnStart end")
    })

    ::events.on("CharacterComesOfAge", function(eventData) {
        ::EUR.logHelper("onCharacterComesOfAge")
        if (eventData.faction.name == "sicily") {
            ::EUR.addGondorFiefTrait(eventData.characterRecord)
        }
        ::EUR.fixCharUniqueName(eventData.characterRecord)
    })

    ::events.on("OfferedForAdoption", function(eventData) {
        if (eventData.faction.name == "sicily") {
            ::EUR.addGondorFiefTrait(eventData.characterRecord)
        }
    })

    ::events.on("LesserGeneralOfferedForAdoption", function(eventData) {
        if (eventData.faction.name == "sicily") {
            ::EUR.addGondorFiefTrait(eventData.characterRecord)
        }
        ::EUR.fixCharUniqueName(eventData.characterRecord)
    })

    ::events.on("OfferedForMarriage", function(eventData) {
        if (eventData.faction.name == "sicily") {
            ::EUR.addGondorFiefTrait(eventData.characterRecord)
        }
        ::EUR.fixCharUniqueName(eventData.characterRecord)
    })

    ::events.on("BrotherAdopted", function(eventData) {
        if (eventData.faction.name == "sicily") {
            ::EUR.addGondorFiefTrait(eventData.characterRecord)
        }
        ::EUR.fixCharUniqueName(eventData.characterRecord)
    })

    ::events.on("CharacterTurnEnd", function(eventData) {
        ::EUR.logHelper("onCharacterTurnEnd")
        ::EUR.logHelper("onCharacterTurnEnd end")
    })

    ::events.on("BecomesFactionLeader", function(eventData) {
        ::EUR.logHelper("onBecomesFactionLeader")
        if (eventData.faction == null) { return }
        if (eventData.faction.name == "slave") { return }
        if (::EUR.eur_turn_number > 5) {
            ::EUR.galadrielTitleCheck()
        }
        if (eventData.characterRecord != null) {
            if (eventData.characterRecord.character != null) {
                ::EUR.swapHierLeaderStuff(eventData.characterRecord.character, true)
            }
        }
    })

    ::events.on("BecomesFactionHeir", function(eventData) {
        ::EUR.logHelper("onBecomesFactionHeir")
        if (eventData.faction == null) { return }
        if (eventData.faction.name == "slave") { return }
        if (eventData.characterRecord != null) {
            if (eventData.characterRecord.character != null) {
                ::EUR.swapHierLeaderStuff(eventData.characterRecord.character, false)
            }
        }
    })

}
