class eurEregion {
    textColour = [0, 0, 0, 255]
    koeScroll = null
    konScroll = null
    koeCanvas = 0
    konCanvas = 0
    built     = false

    function lindon_invasion_0() {
        local army = ::EUR.eurSpawnArmy("normans", "Azog", "noldor_invasion_0", "", false, 18, "Blue Crag Berserkers", ::EUR.eur_sMap.findSettlement("Mithlond").tileX, ::EUR.eur_sMap.findSettlement("Mithlond").tileY, 2, 1, 1)
        if (army) {
            army.createUnit("Blue Crag Berserkers", 7, 1, 1, -1)
            army.createUnit("Blue Crag Berserkers", 7, 1, 1, -1)
            army.createUnit("Blue Crag Orc Javs", 5, 1, 0, -1)
            army.createUnit("Blue Crag Orc Javs", 5, 0, 0, -1)
            army.createUnit("Teraig Halberds", 5, 1, 0, -1)
            army.createUnit("Teraig Halberds", 5, 0, 0, -1)
            army.createUnit("Teraig Infantry", 3, 0, 0, -1)
            army.createUnit("Teraig Infantry", 3, 0, 0, -1)
            army.createUnit("Swords of Rath", 3, 0, 0, -1)
            army.createUnit("Swords of Rath", 3, 0, 0, -1)
            army.createUnit("Spears of Rath", 3, 0, 0, -1)
            army.createUnit("Spears of Rath", 3, 0, 0, -1)
            army.createUnit("Teraig Slingers", 1, 0, 1, -1)
            army.createUnit("Teraig Slingers", 2, 0, 1, -1)
            army.createUnit("Teraig Slingers", 2, 0, 1, -1)
            army.createUnit("Teraig Slingers", 2, 0, 1, -1)
            army.createUnit("Blue Crag Catapult", 1, 0, 0, -1)
            army.createUnit("Blue Crag Catapult", 1, 0, 0, -1)
            army.createUnit("Blue Crag Catapult", 1, 0, 0, -1)
            if (army.leader != null) {
                local char = army.leader.record
                if (char != null) {
                    char.addTrait("OrcRace", 1)
                    char.addTrait("AIBoost", 1)
                    char.addTrait("Locked", 1)
                    char.addTrait("BattleChivalryEvil", 2)
                    char.addTrait("BattleScarred", 2)
                    char.addTrait("GoodAmbusher", 2)
                    char.addTrait("GoodCommander", 3)
                    char.addTrait("LoyaltyStarter", 1)
                    char.addTrait("NightBattleCapable", 1)
                    char.addTrait("PietyStarter", 1)
                }
            }
            army.besiegeSettlement(::EUR.eur_sMap.findSettlement("Mithlond"), false)
        }
    }

    function imladris_invasion_0() {
        local army = ::EUR.eurSpawnArmy("hre", "Orcobal", "noldor_invasion_0", "", false, 18, "Mountain Uruks", ::EUR.eur_sMap.findSettlement("Imladris").tileX, ::EUR.eur_sMap.findSettlement("Imladris").tileY, 2, 1, 1)
        if (army) {
            army.createUnit("Mountain Uruks", 7, 1, 1, -1)
            army.createUnit("Mountain Uruks", 7, 1, 1, -1)
            army.createUnit("Black Pit Berserkers", 7, 1, 1, -1)
            army.createUnit("Black Pit Berserkers", 7, 1, 1, -1)
            army.createUnit("Black Pit Halberd", 5, 1, 0, -1)
            army.createUnit("Black Pit Halberd", 5, 0, 0, -1)
            army.createUnit("Black Pit Halberd", 5, 1, 0, -1)
            army.createUnit("Black Pit Halberd", 5, 0, 0, -1)
            army.createUnit("Black Pit Infantry", 3, 0, 0, -1)
            army.createUnit("Black Pit Infantry", 3, 0, 0, -1)
            army.createUnit("Black Pit Spears", 3, 0, 0, -1)
            army.createUnit("Black Pit Spears", 3, 0, 0, -1)
            army.createUnit("Uruk Overseers", 1, 0, 1, -1)
            army.createUnit("Uruk Overseers", 2, 0, 1, -1)
            army.createUnit("Black Pit Archers", 2, 0, 1, -1)
            army.createUnit("Black Pit Archers", 2, 0, 1, -1)
            army.createUnit("Snaga Catapult", 1, 0, 0, -1)
            army.createUnit("Snaga Catapult", 1, 0, 0, -1)
            army.createUnit("Snaga Catapult", 1, 0, 0, -1)
            if (army.leader != null) {
                local char = army.leader.record
                if (char != null) {
                    char.addTrait("OrcRace", 1)
                    char.addTrait("AIBoost", 1)
                    char.addTrait("Locked", 1)
                    char.addTrait("BattleChivalryEvil", 2)
                    char.addTrait("BattleScarred", 2)
                    char.addTrait("GoodAmbusher", 2)
                    char.addTrait("GoodCommander", 3)
                    char.addTrait("LoyaltyStarter", 1)
                    char.addTrait("NightBattleCapable", 1)
                    char.addTrait("PietyStarter", 1)
                }
            }
            army.besiegeSettlement(::EUR.eur_sMap.findSettlement("Imladris"), false)
        }
    }

    function UIFlashStop() { ::game.runScriptCommand("ui_flash_stop", "") }
    function jumpCamera(x, y) { ::stratMap.jumpCamera(x, y) }
    function hideTiles() { ::game.runScriptCommand("hide_all_revealed_tiles", "") }

    function eregionStoryCheck() {
        if (::EUR.eregion_realms_start == 0) {
            if (::EUR.eur_turn_number > 2) {
                ::EUR.eur_eregion_active = true
                local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett)
                this.jumpCamera(sett.tileX, sett.tileY)
                ::game.runScriptCommand("point_at_settlement", ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett)
                ::game.runScriptCommand("reveal_tile", sett.tileX + " " + sett.tileY)
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][0].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][0].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][0].text)
                ::EUR.eregion_realms_start = 1
            }
        } else if (::EUR.eregion_realms_start == 1) {
            this.UIFlashStop()
            this.hideTiles()
            ::EUR.eregion_realms_start = 2
        } else if (::EUR.eregion_realms_start == 2) {
            local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett)
            if (sett.owner.name == ::EUR.eur_localFactionName) {
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].text)
                ::EUR.eregion_realms_sett_taken = ::EUR.eur_turn_number
                ::EUR.eregion_realms_start = 3
            }
        } else if (::EUR.eregion_realms_start == 3) {
            local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].capital)
            if (sett.owner.name == ::EUR.eur_localFactionName) {
                if (::EUR.eur_campaign.factionByName(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].enemy).characterCount == 0) {
                    ::EUR.eregion_realms_start = 7
                    ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].text)
                } else if (::EUR.eur_turn_number == (::EUR.eregion_realms_sett_taken + 1)) {
                    ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][1].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][1].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][1].text)
                } else if (::EUR.eur_turn_number == (::EUR.eregion_realms_sett_taken + 4)) {
                    ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][2].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][2].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][2].text)
                } else if (::EUR.eur_turn_number == (::EUR.eregion_realms_sett_taken + 8)) {
                    ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][3].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][3].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][3].text)
                } else if (::EUR.eur_turn_number == (::EUR.eregion_realms_sett_taken + 9)) {
                    ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][0]()
                } else if (::EUR.eur_turn_number >= (::EUR.eregion_realms_sett_taken + 10)) {
                    local invasion = ::EUR.getnamedCharbyLabel("noldor_invasion_0")
                    if (invasion != null && invasion.character != null && invasion.character.army != null) {
                        if (invasion.character.army.canAssault(sett)) {
                            invasion.character.army.besiegeSettlement(sett, true)
                            ::EUR.eregion_realms_start = 4
                        }
                    }
                    ::EUR.eregion_realms_start = 4
                }
            } else {
                if (!::EUR.cap_lost_event) {
                    ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][17].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][17].text)
                    ::EUR.cap_lost_event = true
                    ::EUR.eregion_realms_sett_taken = ::EUR.eregion_realms_sett_taken + 1
                } else {
                    ::EUR.eregion_realms_sett_taken = ::EUR.eregion_realms_sett_taken + 1
                }
            }
        } else if (::EUR.eregion_realms_start == 4) {
            local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].capital)
            if (::EUR.eur_campaign.factionByName(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].enemy).characterCount == 0) {
                ::EUR.eregion_realms_start = 7
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].text)
            } else if (sett.owner.name == ::EUR.eur_localFactionName) {
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].text)
                ::EUR.eregion_realms_start = 5
            } else {
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][17].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][17].text)
                ::EUR.eregion_realms_start = 6
            }
        } else if (::EUR.eregion_realms_start == 5) {
            ::EUR.eregion_realms_start = 7
        } else if (::EUR.eregion_realms_start == 6) {
            local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].capital)
            if (sett.owner.name == ::EUR.eur_localFactionName) {
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][18].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][18].text)
                ::EUR.eregion_realms_start = 7
            }
        } else if (::EUR.eregion_realms_start == 7) {
            if (::EUR.eur_turn_number > 30 && ::EUR.eur_player_faction.settlementCount > 5) {
                local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett)
                sett.population = sett.population + 500
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].text)
                ::EUR.eregion_realms_start = 8
            }
        } else if (::EUR.eregion_realms_start == 8) {
            local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett)
            if (sett.owner.name == ::EUR.eur_localFactionName && sett.level >= 1) {
                sett.population = sett.population + 1000
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][6].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][6].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][6].text)
                ::EUR.eregion_realms_start = 9
            }
        } else if (::EUR.eregion_realms_start == 9) {
            local sett = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett)
            if (sett.owner.name == ::EUR.eur_localFactionName && sett.level >= 2) {
                ::EUR.show_eregion_choice = true
            }
        } else if (::EUR.eregion_realms_start == 10) {
            local faction = ::EUR.eur_campaign.factionByName("egypt")
            local settlement = ::EUR.eur_sMap.findSettlement("Forodwaith")
            if (faction != null) {
                faction.record.canHorde = true
                if (settlement.owner.name == "egypt") {
                    settlement.changeOwner(::EUR.eur_campaign.factionByName("slave"), false)
                }
            }
            if (settlement.owner.name == "slave") {
                ::EUR.eregion_realms_start = 11
            }
        } else if (::EUR.eregion_realms_start == 11) {
            local faction = ::EUR.eur_campaign.factionByName("egypt")
            if (faction.characterCount == 0) {
                ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][11].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][11].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][11].text)
                ::EUR.eregion_realms_start = 12
            } else {
                for (local i = 0; i < ::EUR.eur_player_faction.settlementCount; i++) {
                    local sett = ::EUR.eur_player_faction.settlement(i)
                    if (sett != null && sett.turmoil <= 5) {
                        sett.turmoil = 5
                    }
                }
            }
        } else if (::EUR.eregion_realms_start == 12) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][12].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][12].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][12].text)
            ::EUR.eregion_realms_start = 18
            for (local i = 0; i < ::EUR.eur_player_faction.settlementCount; i++) {
                local sett = ::EUR.eur_player_faction.settlement(i)
                if (sett != null) { sett.turmoil = 0 }
            }
        } else if (::EUR.eregion_realms_start == 13) {
            ::EUR.eregion_realms_start = 14
        } else if (::EUR.eregion_realms_start == 14) {
            if (!::EUR.misc_options.KD_Alliance_msg_1) {
                ::game.showHistoricEvent("EREGION_KHAZAD", ::EUR.EREGION_KD_NOTIF_TITLE, ::EUR.EREGION_KD_NOTIF_BODY)
                ::EUR.misc_options.KD_Alliance_msg_1 = true
            }
            if ((::EUR.eur_campaign.factionByName("denmark").characterCount == 0) || (::EUR.eur_campaign.factionByName("saxons").characterCount == 0)) {
                if (!::EUR.checkCounter("kon_part_1")) {
                    ::game.campaign().setEventCounter("kon_part_1", 1)
                    ::game.showHistoricEvent("KOE_PART_1", ::EUR.KOE_PART_1_TITLE, ::EUR.KOE_PART_1_BODY)
                }
            }
            if ((::EUR.eur_campaign.factionByName("denmark").characterCount == 0) && (::EUR.eur_campaign.factionByName("saxons").characterCount == 0)) {
                if (!::EUR.checkCounter("kon_part_1")) {
                    ::game.campaign().setEventCounter("kon_part_1", 1)
                    ::game.showHistoricEvent("KOE_PART_1", ::EUR.KOE_PART_1_TITLE, ::EUR.KOE_PART_1_BODY)
                }
                if (!::EUR.checkCounter("kon_part_2")) {
                    ::game.campaign().setEventCounter("kon_part_2", 1)
                    ::game.showHistoricEvent("KOE_PART_2", ::EUR.KOE_PART_2_TITLE, ::EUR.KOE_PART_2_BODY)
                    ::EUR.eregion_realms_start = 21
                }
            }
        } else if (::EUR.eregion_realms_start == 18) {
            if (::EUR.eur_turn_number > 50) {
                ::EUR.show_kon_choice = true
            }
        } else if (::EUR.eregion_realms_start == 19) {
            this.formKoN()
            ::EUR.eur_eregion_active = false
            ::EUR.eregion_realms_start = 20
            ::EUR.options_poe = false
        } else if (::EUR.eregion_realms_start == 21) {
            local settlement = ::EUR.eur_sMap.findSettlement("Eregion")
            if (settlement != null && settlement.hasBuildingLevel("high_king_throne", true)) {
                local name = ::EUR.eur_campaign.factionByName("egypt").leader.displayName
                name = ::EUR.string.gsub(name, "High Prince ", "")
                name = ::EUR.string.gsub(name, "High King ", "")
                ::game.showHistoricEvent("KOE_FORM", "The Lord of the West", ::EUR.KOE_FORM_BODY_1 + name + ::EUR.KOE_FORM_BODY_2)
                if (!::EUR.checkCounter("kon_form")) {
                    ::game.campaign().setEventCounter("kon_form", 1)
                }
                this.fixEregionStrings()
                ::EUR.eregion_realms_start = 22
                ::EUR.eur_eregion_active = false
            }
        }
    }

    function ensure() {
        if (this.built) return
        this.built = true
        local self = this
        ::UI.pushStyle(::EUR.eurStyles.basic_4)
        this.koeScroll = ::EUR.scroll.create(800, 740, 112, 14, function() { ::EUR.show_eregion_choice = false })
        this.koeCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.koeCanvas, function() { self.drawKoE() })
        this.konScroll = ::EUR.scroll.create(800, 740, 112, 14, function() { ::EUR.show_kon_choice = false })
        this.konCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.konCanvas, function() { self.drawKoN() })
        ::UI.popStyle()
        ::UI.setParent(0)
        ::UI.widgetVisible(this.koeScroll.window, false)
        ::UI.widgetVisible(this.konScroll.window, false)
    }

    function render() {
        this.ensure()
        local onMap = ::EUR.in_campaign_map
        ::UI.widgetVisible(this.koeScroll.window, ::EUR.show_eregion_choice && onMap)
        ::UI.widgetVisible(this.konScroll.window, ::EUR.show_kon_choice && onMap)
    }

    function area(scr) {
        local rect = ::UI.widgetRectGet(scr.window)
        if (rect == null) return null
        local m = ::EUR.scroll.setMargins("scroll")
        if (m == null) return null
        return { x = rect[0] + m[0], y = rect[1] + m[1], w = rect[2] - m[0] - m[2], h = rect[3] - m[1] - m[3] }
    }

    function drawKoE() {
        if (!::EUR.show_eregion_choice) return
        local a = this.area(this.koeScroll)
        if (a == null) return
        local titleArt = ::EUR.koe_title
        if (typeof(titleArt) == "table" && ("img" in titleArt) && titleArt.img != null && titleArt.img != 0) { ::UI.image(titleArt.img, 720, 72, a.x + (a.w - 720) / 2, a.y + 8) }
        local choiceArt = ::EUR.eregion_rebellion_choice
        if (typeof(choiceArt) == "table" && ("img" in choiceArt) && choiceArt.img != null && choiceArt.img != 0) { ::UI.image(choiceArt.img, 458, 185, a.x + (a.w - 458) / 2, a.y + 92) }
        ::UI.layoutAt(a.x + 30, a.y + 292)
        ::UI.pushStyle({ [::UI.Colour.text] = this.textColour })
        ::UI.textWrapped(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][7].text, a.w - 60)
        ::UI.popStyle()
        local iconArt = (::EUR.eur_player_faction.name == "saxons") ? ::EUR.imladris_icon : ::EUR.lindon_icon
        local eregionArt = ::EUR.eregion_icon
        if (typeof(iconArt) != "table" || !("img" in iconArt) || iconArt.img == null || iconArt.img == 0) return
        if (typeof(eregionArt) != "table" || !("img" in eregionArt) || eregionArt.img == null || eregionArt.img == 0) return
        local icon = iconArt.img
        local by = a.y + a.h - 130
        local x1 = a.x + a.w / 4 - 50
        local x2 = a.x + a.w * 3 / 4 - 50
        ::UI.pushHitMode(::UI.Hit.alpha)
        local hit1 = ::UI.imageButton(eregionArt.img, 100, 100, x1, by).clicked
        local hit2 = ::UI.imageButton(icon, 100, 100, x2, by).clicked
        ::UI.popHitMode()
        if (hit1) {
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            ::EUR.show_eregion_choice = false
            ::EUR.eregion_realms_start = 13
            ::EUR.eregion_maernil_choice = true
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][9].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][9].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][9].text)
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][14].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][14].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][14].text)
            ::game.campaign().setEventCounter("eregion_rebellion_choice_accepted", 1)
            this.spawnEregionHorde(true)
            this.controlEregion()
        }
        if (hit2) {
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            ::EUR.show_eregion_choice = false
            ::EUR.eregion_realms_start = 11
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][8].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][8].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][8].text)
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][10].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][10].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][10].text)
            ::game.campaign().setEventCounter("eregion_rebellion_choice_declined", 1)
            this.reducePop()
            this.spawnEregionHorde(false)
        }
    }

    function drawKoN() {
        if (!::EUR.show_kon_choice) return
        local a = this.area(this.konScroll)
        if (a == null) return
        local titleArt = ::EUR.kon_title
        if (typeof(titleArt) == "table" && ("img" in titleArt) && titleArt.img != null && titleArt.img != 0) { ::UI.image(titleArt.img, 720, 72, a.x + (a.w - 720) / 2, a.y + 8) }
        local choiceArt = ::EUR.kon_council_choice
        if (typeof(choiceArt) == "table" && ("img" in choiceArt) && choiceArt.img != null && choiceArt.img != 0) { ::UI.image(choiceArt.img, 458, 185, a.x + (a.w - 458) / 2, a.y + 92) }
        ::UI.layoutAt(a.x + 30, a.y + 292)
        ::UI.pushStyle({ [::UI.Colour.text] = this.textColour })
        ::UI.textWrapped(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][13].text, a.w - 60)
        ::UI.popStyle()
        local iconArt = (::EUR.eur_player_faction.name == "saxons") ? ::EUR.imladris_icon : ::EUR.lindon_icon
        local konArt = (::EUR.eur_player_faction.name == "saxons") ? ::EUR.imladris_kon_icon : ::EUR.lindon_kon_icon
        if (typeof(iconArt) != "table" || !("img" in iconArt) || iconArt.img == null || iconArt.img == 0) return
        if (typeof(konArt) != "table" || !("img" in konArt) || konArt.img == null || konArt.img == 0) return
        local icon = iconArt.img
        local kon_icon = konArt.img
        local by = a.y + a.h - 130
        local x1 = a.x + a.w / 4 - 50
        local x2 = a.x + a.w * 3 / 4 - 50
        ::UI.pushHitMode(::UI.Hit.alpha)
        local hit1 = ::UI.imageButton(kon_icon, 100, 100, x1, by).clicked
        local hit2 = ::UI.imageButton(icon, 100, 100, x2, by).clicked
        ::UI.popHitMode()
        if (hit1) {
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            ::EUR.show_kon_choice = false
            ::EUR.eregion_realms_start = 19
            ::game.campaign().setEventCounter("konkoe_union", 1)
            ::game.campaign().setEventCounter("kon_council_choice_accepted", 1)
            if (!::EUR.checkCounter("glorfindel_spawned")) { this.spawnGlorfindel() }
            local gildor = ::EUR.getnamedCharbyLabel("gildor_1")
            if (gildor != null) { gildor.character.kill(); this.spawnGildor() }
            ::units.get("Calaquendi Lords").generalUnit = false
            ::units.get("Noldorin Bodyguards").generalUnit = false
        }
        if (hit2) {
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            ::EUR.show_kon_choice = false
            ::EUR.eur_eregion_active = false
            ::EUR.eregion_realms_start = 20
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][16].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][16].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][16].text)
            ::game.campaign().setEventCounter("kon_council_choice_declined", 1)
        }
    }

    function fixKoNRecuits() {
        for (local i = 0; i < ::EUR.eur_player_faction.settlementCount; i++) {
            local sett = ::EUR.eur_player_faction.settlement(i)
            if (sett == null) continue
            for (local x = 0; x < sett.recruitPoolCount; x++) {
                local unit_pool = sett.recruitPool(x)
                if (unit_pool != null && unit_pool.available < 1) {
                    sett.setRecruitPool(unit_pool.unitTypeIndex, 1)
                }
            }
            if (sett.name == "Imladris" && ::EUR.eur_player_faction.name == "denmark" && sett.army != null) {
                sett.army.createUnit("Eregion Bow Quendi", 2, 0, 0, -1)
                sett.army.createUnit("Eregion Bow Quendi", 2, 0, 0, -1)
                sett.army.createUnit("Eregion Bow Quendi", 2, 0, 0, -1)
                sett.army.createUnit("Eregion Spear Quendi", 2, 0, 0, -1)
                sett.army.createUnit("Eregion Spear Quendi", 2, 0, 0, -1)
                sett.army.createUnit("Eregion Barad Bladesmen", 2, 0, 0, -1)
            }
            if (sett.name == "Rhudaur" && ::EUR.eur_player_faction.name == "denmark" && sett.army != null) {
                sett.army.createUnit("Eregion Bow Quendi", 2, 0, 0, -1)
                sett.army.createUnit("Eregion Spear Quendi", 2, 0, 0, -1)
                sett.army.createUnit("Eregion Spear Quendi", 2, 0, 0, -1)
            }
        }
    }

    function formKoN() {
        if (::EUR.eur_player_faction.name == "saxons") {
            ::game.runScriptCommand("give_everything_to_faction", "denmark saxons false")
        } else {
            ::game.runScriptCommand("give_everything_to_faction", "saxons denmark false")
        }
        ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][15].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][15].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][15].text)
        this.removeConfedGarrison()
        this.fixKoNGenerals()
        ::EUR.dorwinionGeneralBGCheck()
        this.swapKoNBarracks()
        this.fixKoNRecuits()
        this.fixKonStrings()
    }

    function reducePop() {
        for (local i = 0; i < ::EUR.eur_player_faction.settlementCount; i++) {
            local sett = ::EUR.eur_player_faction.settlement(i)
            if (sett != null) {
                sett.population = (sett.population * 0.8).tointeger()
            }
        }
    }

    function swapKoNBarracks() {
        local faction = ::EUR.eur_player_faction
        for (local i = 0; i < faction.settlementCount; i++) {
            local sett = faction.settlement(i)
            if (sett == null) continue
            local replace = false
            if (::EUR.eur_player_faction.name == "saxons") {
                if (!sett.isCastle) {
                    if (sett.buildingOfChain("teleri_barracks")) { sett.destroyBuilding("teleri_barracks", false); replace = true }
                    if (replace && !sett.buildingOfChain("noldor_barracks")) { sett.createBuilding("noldor_barracks") }
                } else {
                    if (sett.buildingOfChain("teleri_barracks_castle")) { sett.destroyBuilding("teleri_barracks_castle", false); replace = true }
                    if (replace && !sett.buildingOfChain("noldor_barracks_castle")) { sett.createBuilding("c_noldor_barracks") }
                }
            } else {
                if (!sett.isCastle) {
                    if (sett.buildingOfChain("noldor_barracks")) { sett.destroyBuilding("noldor_barracks", false); replace = true }
                    if (replace && !sett.buildingOfChain("teleri_barracks")) { sett.createBuilding("teleri_barracks") }
                } else {
                    if (sett.buildingOfChain("noldor_barracks_castle")) { sett.destroyBuilding("noldor_barracks_castle", false); replace = true }
                    if (replace && !sett.buildingOfChain("teleri_barracks_castle")) { sett.createBuilding("c_teleri_barracks") }
                }
            }
        }
    }

    function fixKoNGenerals() {
        if (::EUR.eur_player_faction.name == "denmark") {
            ::EUR.eur_player_faction.record.setStratModel("noldor_captain", ::Enum.CharacterType.general, 0)
            ::EUR.eur_player_faction.record.setStratModel("noldor_general", ::Enum.CharacterType.namedCharacter, 0)
            ::EUR.eur_player_faction.record.setBattleModel("noldor_general", ::Enum.CharacterType.general)
            ::EUR.eur_player_faction.setColour(10, 10, 100)
            ::EUR.eur_player_faction.setSecondaryColour(150, 150, 150)
            ::EUR.eur_player_faction.displayName = "Kingdom of the Ñoldor"
            local leader = ::EUR.eur_player_faction.leader
            if (leader != null) {
                leader.displayName = ::EUR.string.gsub(leader.displayName, "High Lord ", "High King ")
            }
            local glorfindel = ::EUR.getnamedCharbyLabel("glorfindel_1")
            local elrond = ::EUR.getnamedCharbyLabel("elrond_1")
            local elladan = ::EUR.getnamedCharbyLabel("elladan_1")
            local elrohir = ::EUR.getnamedCharbyLabel("elrohir_1")
            if (glorfindel != null) {
                glorfindel.character.setStratModel("glorfin")
                ::EUR.setBodyguard(glorfindel.character, "Eldarinwe Bodyguards", 7, 1, 1, "")
            }
            if (elrond != null) {
                elrond.removeTrait("FactionLeaderCustom")
                elrond.removeTrait("Elrond")
                elrond.addTrait("ElrondUnion", 1)
                ::EUR.setBodyguard(elrond.character, "GilGalads Company", 5, 1, 1, "")
            }
            if (elrohir != null) {
                elrohir.removeTrait("FactionHeirCustom")
                elrohir.removeTrait("Elrohir")
                elrohir.addTrait("ElrohirUnion", 1)
                ::EUR.setBodyguard(elrohir.character, "Dunedain Troll Slayers", 2, 1, 1, "")
            }
            if (elladan != null) {
                elladan.removeTrait("Elladan")
                elladan.addTrait("ElladanUnion", 1)
                ::EUR.setBodyguard(elladan.character, "Dunedain Bodyguard Twins", 2, 1, 1, "")
            }
        } else {
            ::EUR.eur_player_faction.record.setStratModel("noldor_captain", ::Enum.CharacterType.general, 0)
            ::EUR.eur_player_faction.record.setStratModel("noldor_general", ::Enum.CharacterType.namedCharacter, 0)
            ::EUR.eur_player_faction.record.setBattleModel("noldor_general", ::Enum.CharacterType.general)
            local leader = ::EUR.eur_player_faction.leader
            if (leader != null) {
                leader.displayName = ::EUR.string.gsub(leader.displayName, "Prince ", "High King ")
            }
            ::EUR.eur_player_faction.setColour(0, 0, 90)
            ::EUR.eur_player_faction.setSecondaryColour(192, 192, 192)
            ::EUR.eur_player_faction.displayName = "Kingdom of the Ñoldor"
            local cirdan = ::EUR.getnamedCharbyLabel("cirdan_1")
            local thingol = ::EUR.getnamedCharbyLabel("thingol_1")
            local galdor = ::EUR.getnamedCharbyLabel("galdor_1")
            if (cirdan != null) {
                cirdan.removeTrait("Cirdan")
                cirdan.removeTrait("FactionLeaderCustom")
                cirdan.addTrait("CirdanUnion", 1)
                ::EUR.setBodyguard(cirdan.character, "Falas Lords", 5, 1, 1, "")
            }
            if (thingol != null) {
                thingol.removeTrait("FactionHeirCustom")
                thingol.removeTrait("Thingol")
                thingol.addTrait("ThingolUnion", 1)
                ::EUR.setBodyguard(thingol.character, "Heavy Falathrim Axeguard", 5, 1, 1, "")
            }
            if (galdor != null) {
                galdor.removeTrait("Galdor")
                galdor.addTrait("GaldornUnion", 1)
                ::EUR.setBodyguard(galdor.character, "Heavy Falathrim Wavebreakers", 5, 1, 1, "")
            }
        }
    }

    function removeConfedGarrison() {
        local GARRISON_KILL_confed = []
        local faction = ::EUR.eur_player_faction
        if (faction.armyCount > 0) {
            for (local j = 0; j < faction.armyCount; j++) {
                local army = faction.army(j)
                if (army == null) continue
                for (local i = 0; i < army.unitCount; i++) {
                    local stack_unit = army.unit(i)
                    if (stack_unit != null && stack_unit.name == "Garrison") {
                        if (!::EUR.tableContains(GARRISON_KILL_confed, stack_unit)) {
                            GARRISON_KILL_confed.append(stack_unit)
                        }
                    }
                }
            }
        }
        for (local k = 0; k < GARRISON_KILL_confed.len(); k++) {
            if (GARRISON_KILL_confed[k] != null && !GARRISON_KILL_confed[k].isDead) {
                GARRISON_KILL_confed[k].kill()
            }
        }
    }

    function spawnGildor() {
        if (::EUR.eur_campaign.factionByName("saxons").characterCount == 0) return
        local army = ::EUR.eurSpawnArmy("saxons", "Gildor", "gildor_1_kon", "Gildor", true, 22, "Noldorin Archers",
            ::EUR.eur_campaign.factionByName("saxons").capital.tileX, ::EUR.eur_campaign.factionByName("saxons").capital.tileY, 7, 1, 1)
        if (army != null && army.leader != null) {
            local char = army.leader.record
            if (char != null) {
                char.addTrait("Gildor", 1)
                char.addTrait("Hero", 1)
                char.addTrait("ElvenRace", 1)
                char.addTrait("Noldor", 1)
                char.addTrait("HouseFinarfin", 1)
                char.addTrait("HeroAbilityElf", 1)
                char.addTrait("BattleChivalryGood", 2)
                char.addTrait("Brave", 3)
                char.addTrait("Handsome", 3)
                char.addTrait("GoodCommander", 3)
                char.addTrait("Loyal", 3)
                char.addTrait("LoyaltyStarter", 1)
                char.addTrait("Xenophilia", 1)
                char.addTrait("TacticalSkill", 2)
                char.addTrait("PietyStarter", 1)
                char.addAncillary("noldor_shield")
                char.addAncillary("noldor_sword")
                char.character.heroAbility = "Light_of_the_Faith"
            }
        }
    }

    function killWitchKing() {
        for (local i = 0; i < ::EUR.unique_names["Nazgula"].len(); i++) {
            local wking = ::EUR.getnamedCharbyLabel(::EUR.unique_names["Nazgula"][i])
            if (wking != null) {
                wking.character.kill()
            }
        }
    }

    function spawnGlorfindel() {
        if (::EUR.checkCounter("glorfindel_spawned")) return
        local existing = ::EUR.getnamedCharbyLabel("glorfindel_1")
        if (existing != null) {
            ::game.campaign().setEventCounter("glorfindel_spawned", 1)
            return
        }
        if (::EUR.eur_campaign.factionByName("saxons").characterCount == 0) return
        local army = ::EUR.eurSpawnArmy("saxons", "Glorfindel", "glorfindel_1", "Glorfindel", true, 22, "Eldarinwe Bodyguards",
            ::EUR.eur_campaign.factionByName("saxons").capital.tileX, ::EUR.eur_campaign.factionByName("saxons").capital.tileY, 7, 1, 1)
        if (army != null && army.leader != null) {
            local char = army.leader.record
            if (char != null) {
                char.battleModel = "glorfin"
                char.addTrait("Glorfindel", 1)
                char.addTrait("CustomBG", 1)
                char.addTrait("Hero", 1)
                char.addTrait("ElvenRace", 1)
                char.addTrait("Noldor", 1)
                char.addTrait("HouseGoldenFlower", 1)
                char.addTrait("HeroAbilityElf", 1)
                char.addTrait("BattleChivalryGood", 2)
                char.addTrait("Brave", 3)
                char.addTrait("Handsome", 3)
                char.addTrait("BattleOfFornost", 1)
                char.addTrait("FallOfGondolin", 1)
                char.addTrait("KilledBalrog", 1)
                char.addTrait("GoodAttacker", 1)
                char.addTrait("GoodCommander", 3)
                char.addTrait("Just", 1)
                char.addTrait("LivedAges", 1)
                char.addTrait("Loyal", 3)
                char.addTrait("LoyaltyStarter", 1)
                char.addTrait("Reincarnated", 1)
                char.addTrait("NaturalMilitarySkill", 1)
                char.addTrait("PietyStarter", 1)
                char.addAncillary("troops_helf")
                char.addAncillary("asfaloth")
                char.addAncillary("glorfindel_armour")
                char.character.heroAbility = "Light_of_the_Faith"
            }
        }
        ::game.campaign().setEventCounter("glorfindel_spawned", 1)
        if (::EUR.eur_player_faction.name == "saxons") {
            ::game.showHistoricEvent("glorfindel", "Glorfindel Returns!", "After some years, Glorfindel has finally completed his task and returns to us now. He brings grim news and sad tales of the rising power of Sauron and his growing dominion in Middle-earth: stretching from the furthest east, to the deepest south and slowly claiming Mirkwood and eastern Gondor. Knowing that only the strength of the Elves can save the Free Peoples, Glorfindel has mustered an elite unit of cavalry and will lead them, wherever you command! Astride Asfaloth there will be few who can stand up to this First Age hero!")
        }
    }

    function maernilRingCheck() {
        local leader = ::EUR.eur_campaign.factionByName("egypt").leader
        if (leader != null && leader.hasAncillaryType("relic_ring")) {
            ::game.campaign().setEventCounter("maernil_ring_keep", 1)
            ::EUR.misc_options.maernil_ring = true
        }
    }

    function fixEregionStrings() {
        ::game.setText("EMT_EGYPT_FACTION_LEADER_NAME", "High King %S")
        local leader = ::EUR.eur_campaign.factionByName("egypt").leader
        if (leader != null) {
            leader.displayName = ::EUR.string.gsub(leader.displayName, "High Prince ", "High King ")
            ::EUR.setBodyguard(leader.character, "Vanda Etyangoldi", 5, 0, 0, "")
            ::EUR.bgunlock_units_list["maernil_1_eregion00"] <- "Vanda Etyangoldi"
        }
    }

    function controlEregion() {
        ::EUR.eur_player_faction = ::EUR.eur_campaign.factionByName("egypt")
        ::EUR.eur_player_faction.money = 15000
        ::game.runConsoleCommand("control", "egypt")
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
        ::EUR.loadImages()
        ::game.campaign().setEventCounter("faction_ID_egypt", 1)
        ::game.campaign().setEventCounter("faction_ID_denmark", 0)
        ::game.campaign().setEventCounter("faction_ID_saxons", 0)
    }

    function spawnEregionHorde(bool) {
        ::game.campaign().setEventCounter("faction_spawning", 1)
        ::game.campaign().setEventCounter("eregion_is_spawning", 1)
        local faction = ::EUR.eur_campaign.factionByName("egypt")
        local KD_Faction = ::EUR.eur_campaign.factionByName("norway")
        local IM_Faction = ::EUR.eur_campaign.factionByName("saxons")
        local LI_Faction = ::EUR.eur_campaign.factionByName("denmark")
        if (!bool) {
            faction.kingsPurse = 60000
            ::game.campaign().setEventCounter("kon_part_1", 1)
            ::game.campaign().setEventCounter("kon_part_2", 1)
            ::game.campaign().setEventCounter("kon_form", 1)
            if (KD_Faction.characterCount > 0) {
                if (IM_Faction.characterCount > 0) {
                    if (::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.alliance, KD_Faction, IM_Faction)) {
                        ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.peace, KD_Faction, IM_Faction)
                    }
                }
                if (LI_Faction.characterCount > 0) {
                    if (::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.alliance, KD_Faction, LI_Faction)) {
                        ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.peace, KD_Faction, LI_Faction)
                    }
                }
                if (::EUR.randomChance(50)) {
                    ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.alliance, KD_Faction, faction)
                }
            }
        } else {
            if (KD_Faction.characterCount > 0) {
                if (IM_Faction.characterCount > 0) {
                    if (::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.alliance, KD_Faction, IM_Faction)) {
                        ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.peace, KD_Faction, IM_Faction)
                    }
                }
                if (LI_Faction.characterCount > 0) {
                    if (::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.alliance, KD_Faction, LI_Faction)) {
                        ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.peace, KD_Faction, LI_Faction)
                    }
                }
            }
            faction.kingsPurse = ::EUR.add_setts ? 10000 : 5000
        }
        local settlement = null
        if (::EUR.eur_player_faction.name == "saxons" || ::EUR.eur_player_faction.name == "denmark") {
            settlement = ::EUR.eur_sMap.findSettlement(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett)
            if (::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].sett == "Enedwaith") {
                ::EUR.eur_sMap.findSettlement("Enedwaith").displayName = "Ost-in-Ñoldor"
            }
        } else {
            if (::EUR.math.random(1, 100) > 50) {
                settlement = ::EUR.eur_sMap.findSettlement("Eregion")
            } else {
                settlement = ::EUR.eur_sMap.findSettlement("Enedwaith")
                ::EUR.eur_sMap.findSettlement("Enedwaith").displayName = "Ost-in-Ñoldor"
            }
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS["denmark"][3][8].event, ::EUR.CONFED_EVENTS["denmark"][3][8].title, ::EUR.CONFED_EVENTS["denmark"][3][8].text)
        }
        if (faction != null) {
            if (bool) {
                faction.record.canHorde = true
                faction.isHorde = true
            }
            if (settlement != null) {
                settlement.changeOwner(faction, false)
                settlement.createBuilding("ereg_barracks")
                if (!bool) {
                    ::game.runScriptCommand("reveal_tile", settlement.tileX + " " + settlement.tileY)
                }
                local army = ::EUR.eurSpawnArmy("egypt", "Maernil", "maernil_1_eregion00", "Maernil", true, 30, "Feanorian Lancers", settlement.tileX, settlement.tileY, 4, 0, 0)
                if (army != null) {
                    if (!bool) {
                        army.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
                        army.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
                        army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army.createUnit("Alqualonde Accursed", 7, 1, 1, -1)
                        army.createUnit("Alqualonde Accursed", 7, 1, 1, -1)
                        army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army.createUnit("Feanorian Lancers", 2, 0, 0, -1)
                        army.createUnit("Feanorian Lancers", 2, 0, 0, -1)
                        if (::EUR.eur_turn_number < 70) {
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                            army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        } else {
                            army.createUnit("Noldorinwe Spearmen", 2, 1, 0, -1)
                            army.createUnit("Noldorinwe Spearmen", 2, 1, 0, -1)
                            army.createUnit("Noldorinwe Guardians", 2, 1, 0, -1)
                            army.createUnit("Noldorinwe Wardens", 2, 0, 0, -1)
                            army.createUnit("Noldorinwe Wardens", 2, 0, 0, -1)
                        }
                    } else {
                        army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army.createUnit("Daerbor Archers", 2, 0, 0, -1)
                    }
                    if (army.leader != null) {
                        local char = army.leader.record
                        if (char != null) {
                            char.battleModel = "maernil"
                            char.addTrait("Maernil", 1)
                            char.addTrait("CustomBG", 1)
                            char.addTrait("Hero", 1)
                            char.addTrait("ElvenRace", 1)
                            char.addTrait("Noldor", 1)
                            char.addTrait("FactionLeaderCustom", 1)
                            char.addTrait("HouseFeanor", 1)
                            char.addTrait("HeroAbilityMaernil", 1)
                            char.addTrait("Brave", 2)
                            char.addTrait("Handsome", 1)
                            char.addTrait("RenownLegacy", 2)
                            char.addTrait("GoodAmbusher", 1)
                            char.addTrait("GoodCommander", 3)
                            char.addTrait("Loyal", 1)
                            char.addTrait("LoyaltyStarter", 1)
                            char.addTrait("PietyStarter", 1)
                            char.addTrait("ElvesSauronWar", 1)
                            char.addTrait("LastAllianceWar", 1)
                            char.addTrait("FallOfGondolin", 1)
                            char.addTrait("KilledBalrog", 1)
                            char.addTrait("KindRuler", 2)
                            char.addTrait("NaturalMilitarySkill", 1)
                            char.addTrait("NaturalManagementSkill", 1)
                            char.addTrait("LivedAges", 1)
                            char.addAncillary("orma")
                            char.addAncillary("house_feanor")
                            char.addAncillary("crown_celebrimbor")
                            char.addAncillary("lord_ostinedhil")
                            char.character.heroAbility = "FEANORIAN"
                        }
                    }
                }
                if (settlement.level < 2) { settlement.upgrade() }
                if (settlement.level < 2) { settlement.upgrade() }
                for (local i = 0; i <= 9; i++) {
                    if (i == 5) { settlement.setReligion(i, 0.9) }
                    else { settlement.setReligion(i, 0.0) }
                }
                ::EUR.eur_sMap.findSettlement("Eregion").createBuilding("edhil")
                ::EUR.eur_sMap.findSettlement("Enedwaith").createBuilding("edhil")
                this.spawnEregionGarrison(settlement, bool)

                local army3 = ::EUR.eurSpawnArmy("egypt", "Ecthellion", "Ecthellion_1_eregion", "Ecthellion", true, 30, "Eregion Avengers", settlement.tileX, settlement.tileY + 2, 4, 0, 0)
                if (army3 != null) {
                    if (!bool) {
                        army3.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
                        army3.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
                        army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army3.createUnit("Alqualonde Accursed", 7, 1, 1, -1)
                        army3.createUnit("Alqualonde Accursed", 7, 1, 1, -1)
                        army3.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army3.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army3.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army3.createUnit("Eregion Moon Guard", 2, 0, 0, -1)
                        army3.createUnit("Eregion Moon Guard", 2, 0, 0, -1)
                        if (::EUR.eur_turn_number < 70) {
                            army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army3.createUnit("Daerbor Archers", 2, 0, 0, -1)
                            army3.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        } else {
                            army3.createUnit("Noldorinwe Spearmen", 2, 1, 0, -1)
                            army3.createUnit("Noldorinwe Spearmen", 2, 1, 0, -1)
                            army3.createUnit("Noldorinwe Guardians", 2, 1, 0, -1)
                            army3.createUnit("Noldorinwe Wardens", 2, 0, 0, -1)
                            army3.createUnit("Noldorinwe Wardens", 2, 0, 0, -1)
                        }
                    } else {
                        army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army3.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army3.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army3.createUnit("Daerbor Archers", 2, 0, 0, -1)
                    }
                    if (army3.leader != null) {
                        local char = army3.leader.record
                        if (char != null) {
                            char.battleModel = "ecthellion"
                            char.addTrait("Ecthellion", 1)
                            char.addTrait("CustomBG", 1)
                            char.addTrait("Hero", 1)
                            char.addTrait("ElvenRace", 1)
                            char.addTrait("Noldor", 1)
                            char.addTrait("FactionHeirCustom", 1)
                            char.addTrait("HeroAbilityElf", 1)
                            char.addTrait("Brave", 2)
                            char.addTrait("Handsome", 1)
                            char.addTrait("HouseFeanor", 1)
                            char.addTrait("RenownLegacy", 1)
                            char.addTrait("GoodAmbusher", 1)
                            char.addTrait("GoodCommander", 2)
                            char.addTrait("Loyal", 1)
                            char.addTrait("LoyaltyStarter", 1)
                            char.addTrait("PietyStarter", 1)
                            char.character.heroAbility = "Light_of_the_Faith"
                            char.addAncillary("elven_hunter")
                            char.addAncillary("light_earendil")
                            char.addAncillary("hound_huan")
                        }
                    }
                    army3.mergeInto(army, true)
                }
                local army2 = ::EUR.eurSpawnArmy("egypt", "Ciryatan", "Ciryatan_1_eregion", "Ciryatan", true, 30, "Storm Guard", settlement.tileX + 2, settlement.tileY, 4, 0, 0)
                if (army2 != null) {
                    if (!bool) {
                        army2.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
                        army2.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
                        army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army2.createUnit("Alqualonde Accursed", 7, 1, 1, -1)
                        army2.createUnit("Alqualonde Accursed", 7, 1, 1, -1)
                        army2.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army2.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army2.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army2.createUnit("Carnil Sharpshooters", 2, 0, 0, -1)
                        army2.createUnit("Carnil Sharpshooters", 2, 0, 0, -1)
                        if (::EUR.eur_turn_number < 70) {
                            army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army2.createUnit("Daerbor Archers", 2, 0, 0, -1)
                            army2.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        } else {
                            army2.createUnit("Noldorinwe Spearmen", 2, 1, 0, -1)
                            army2.createUnit("Noldorinwe Spearmen", 2, 1, 0, -1)
                            army2.createUnit("Noldorinwe Guardians", 2, 1, 0, -1)
                            army2.createUnit("Noldorinwe Wardens", 2, 0, 0, -1)
                            army2.createUnit("Noldorinwe Wardens", 2, 0, 0, -1)
                        }
                    } else {
                        army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army2.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        army2.createUnit("Daerbor Archers", 2, 0, 0, -1)
                        army2.createUnit("Daerbor Archers", 2, 0, 0, -1)
                    }
                    if (army2.leader != null) {
                        local char = army2.leader.record
                        if (char != null) {
                            char.battleModel = "eregion_lord"
                            char.addTrait("Ciryatan", 1)
                            char.addTrait("Hero", 1)
                            char.addTrait("ElvenRace", 1)
                            char.addTrait("CustomBG", 1)
                            char.addTrait("Noldor", 1)
                            char.addTrait("KindRuler", 2)
                            char.addTrait("EregionPrince", 1)
                            char.addTrait("Handsome", 1)
                            char.addTrait("NaturalManagementSkill", 2)
                            char.addTrait("HeroAbilityElf", 1)
                            char.addTrait("Just", 1)
                            char.addTrait("Loyal", 3)
                            char.addTrait("HouseFeanor", 1)
                            char.addTrait("GoodCommander", 2)
                            char.addTrait("LoyaltyStarter", 1)
                            char.addTrait("Brave", 2)
                            char.character.heroAbility = "Light_of_the_Faith"
                            char.addAncillary("elven_e_counsellor")
                            char.addAncillary("hound_huan")
                            char.addAncillary("storm_glaive")
                        }
                    }
                }
                army2.mergeInto(army, true)
                army.moveTo(settlement.tileX, settlement.tileY, false)
                this.jumpCamera(settlement.tileX, settlement.tileY)
                local spy = faction.createCharacter("spy", 18, "random_name", "", 31, "", settlement.tileX + 2, settlement.tileY + 5)
                if (spy != null) {
                    spy.record.addTrait("NoldorSpy", 1)
                    spy.record.addTrait("NaturalSpySkill", 2)
                    spy.record.addTrait("SpySkill", 5)
                }
                local HE = ::EUR.eur_campaign.factionByName("saxons")
                local LINDON = ::EUR.eur_campaign.factionByName("denmark")
                local BC = ::EUR.eur_campaign.factionByName("normans")
                ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.war, faction, HE)
                ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.war, faction, LINDON)
                ::EUR.eur_campaign.setStance(::Enum.DiplomaticRelation.war, faction, BC)
            }
        }

        if (::EUR.add_setts) {
            local sett_list = ["chrissett_99"]
            for (local i = 0; i < sett_list.len(); i++) {
                local settTile = ::EUR.eur_sMap.findSettlement(sett_list[i])
                if (settTile != null) {
                    settTile.changeOwner(faction, false)
                    for (local j = 0; j <= 9; j++) {
                        if (j == 5) { settTile.setReligion(j, 0.9) }
                        else { settTile.setReligion(j, 0.0) }
                    }
                    if (settTile.level < 1) { settTile.upgrade() }
                    local army = settTile.createGarrisonArmy()
                    if (army != null) {
                        if (!bool) {
                            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
                            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
                            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
                            army.createUnit("Hirneryn Marchwardens", 3, 0, 0, -1)
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                        } else {
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
                            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
                            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
                            if (::EUR.eur_turn_number > 30) {
                                army.createUnit("Dagnir Swordmasters", 2, 1, 0, -1)
                                army.createUnit("Doross Archers", 2, 0, 0, -1)
                                army.createUnit("Doross Archers", 2, 0, 0, -1)
                            } else if (::EUR.eur_turn_number > 60) {
                                army.createUnit("Guardians of Eregion", 2, 1, 0, -1)
                                army.createUnit("Guardians of Eregion", 2, 1, 0, -1)
                                army.createUnit("Hirneryn Marchwardens", 2, 0, 0, -1)
                            }
                        }
                    }
                }
            }
        }
        ::EUR.eregion_spawned = true
        ::game.campaign().setEventCounter("faction_spawning", 0)
        ::game.campaign().setEventCounter("eregion_is_spawning", 0)
    }

    function spawnEregionGarrison(settlement, bool) {
        local army = settlement.createGarrisonArmy()
        if (army == null) return
        if (!bool) {
            army.createUnit("Storm Guard", 5, 1, 0, -1)
            army.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
            army.createUnit("Reavers of the Dark Coast", 5, 1, 0, -1)
            army.createUnit("Eregion Pikemen", 5, 1, 0, -1)
            army.createUnit("Eregion Pikemen", 5, 1, 0, -1)
            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
            army.createUnit("Daerbor Archers", 3, 0, 0, -1)
            army.createUnit("Hirneryn Marchwardens", 3, 0, 0, -1)
            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
        } else {
            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
            army.createUnit("Gathring Shieldbearers", 2, 1, 0, -1)
            army.createUnit("Hirneryn Marchwardens", 3, 0, 0, -1)
            army.createUnit("Elven Catapult", 2, 0, 0, -1)
            army.createUnit("Ost-in-Edhil Rangers", 2, 0, 0, -1)
            if (::EUR.eur_turn_number > 30) {
                army.createUnit("Dagnir Swordmasters", 2, 1, 0, -1)
                army.createUnit("Dagnir Swordmasters", 2, 1, 0, -1)
                army.createUnit("Doross Archers", 2, 1, 0, -1)
                army.createUnit("Doross Archers", 2, 0, 0, -1)
                army.createUnit("Doross Archers", 2, 0, 0, -1)
            } else if (::EUR.eur_turn_number > 60) {
                army.createUnit("Guardians of Eregion", 2, 1, 0, -1)
                army.createUnit("Guardians of Eregion", 2, 1, 0, -1)
                army.createUnit("Ost-in-Edhil Champions", 2, 1, 0, -1)
                army.createUnit("Hirneryn Marchwardens", 2, 0, 0, -1)
                army.createUnit("Hirneryn Marchwardens", 2, 0, 0, -1)
            }
        }
    }

    function fixKonStrings() {
        ::game.setText("EMT_DENMARK_SPY", "Ñoldorin Spy")
        ::game.setText("EMT_DENMARK_ASSASSIN", "Ñoldorin Assassin")
        ::game.setText("EMT_DENMARK_DIPLOMAT", "Ñoldorin Diplomat")
        ::game.setText("EMT_DENMARK_ADMIRAL", "Ñoldorin Navy")
        ::game.setText("EMT_DENMARK_GENERAL", "Ñoldorin Army")
        ::game.setText("EMT_DENMARK_NAMED_CHARACTER", "Ñoldorin Family Member")
        ::game.setText("EMT_DENMARK_NAMED_GENERAL", "Ñoldorin General")
        ::game.setText("EMT_DENMARK_FACTION_LEADER", "Ñoldorin Faction Leader")
        ::game.setText("EMT_DENMARK_FACTION_HEIR", "Ñoldorin Faction Faction Heir")
        ::game.setText("EMT_DENMARK_FACTION_LEADER_NAME", "High King %S")
        ::game.setText("EMT_DENMARK_FACTION_HEIR_NAME", "Lord %S")
        ::game.setText("EMT_DENMARK_FACTION_LEADER_TITLE", "High King")
        ::game.setText("EMT_DENMARK_VILLAGE", "Ñoldorin Village")
        ::game.setText("EMT_DENMARK_TOWN", "Ñoldorin Town")
        ::game.setText("EMT_DENMARK_LARGE_TOWN", "Ñoldorin Large Town")
        ::game.setText("EMT_DENMARK_CITY", "Ñoldorin City")
        ::game.setText("EMT_DENMARK_LARGE_CITY", "Ñoldorin Large City")
        ::game.setText("EMT_DENMARK_HUGE_CITY", "Ñoldorin Huge City")
        ::game.setText("EMT_DENMARK_WOODEN_CASTLE", "Ñoldorin Keep")
        ::game.setText("EMT_DENMARK_STONE_KEEP", "Ñoldorin Castle")
        ::game.setText("EMT_DENMARK_CASTLE", "Ñoldorin Stronghold")
        ::game.setText("EMT_DENMARK_LARGE_CASTLE", "Ñoldorin Fortress")
        ::game.setText("EMT_DENMARK_FORTRESS", "Ñoldorin Citadel")
        ::game.setText("EMT_DENMARK_STAR_FORT", "Ñoldorin Star Fort")
        ::game.setText("EMT_DENMARK_CAPITAL", "Ñoldorin Capital")
        ::game.setText("EMT_DENMARK_FORT", "Ñoldorin Fort")
        ::game.setText("EMT_DENMARK_DOCK", "Ñoldorin Docks")
        ::game.setText("EMT_DENMARK_WATCHTOWER", "Ñoldorin Watchtower")
        ::game.setText("EMT_DENMARK_FISHING_VILLAGE", "Ñoldorin Fishing Village")
        ::game.setText("EMT_SAXONS_SPY", "Ñoldorin Scout")
        ::game.setText("EMT_SAXONS_ASSASSIN", "Ñoldorin Assassin")
        ::game.setText("EMT_SAXONS_DIPLOMAT", "Ñoldorin Diplomat")
        ::game.setText("EMT_SAXONS_ADMIRAL", "Ñoldorin Navy")
        ::game.setText("EMT_SAXONS_GENERAL", "Ñoldorin Army")
        ::game.setText("EMT_SAXONS_NAMED_CHARACTER_3", "Ñoldorin Family Member")
        ::game.setText("EMT_SAXONS_NAMED_CHARACTER_4", "Ñoldorin Family Member")
        ::game.setText("EMT_SAXONS_NAMED_CHARACTER_5", "Ñoldorin Family Member")
        ::game.setText("EMT_SAXONS_NAMED_CHARACTER", "Ñoldorin Family Member")
        ::game.setText("EMT_SAXONS_NAMED_GENERAL", "Ñoldorin General")
        ::game.setText("EMT_SAXONS_PRINCESS", "Ñoldorin Princess")
        ::game.setText("EMT_SAXONS_MERCHANT", "Ñoldorin Merchant")
        ::game.setText("EMT_SAXONS_PRIEST", "Ñoldorin Imam")
        ::game.setText("EMT_SAXONS_PRIEST_1", "Ñoldorin Great Imam")
        ::game.setText("EMT_SAXONS_PRIEST_2", "Ñoldorin Grand Imam")
        ::game.setText("EMT_SAXONS_VILLAGE", "Ñoldorin Village")
        ::game.setText("EMT_SAXONS_TOWN", "Ñoldorin Town")
        ::game.setText("EMT_SAXONS_LARGE_TOWN", "Ñoldorin Large Town")
        ::game.setText("EMT_SAXONS_CITY", "Ñoldorin City")
        ::game.setText("EMT_SAXONS_LARGE_CITY", "Ñoldorin Large City")
        ::game.setText("EMT_SAXONS_HUGE_CITY", "Ñoldorin Huge City")
        ::game.setText("EMT_SAXONS_WOODEN_CASTLE", "Ñoldorin Keep")
        ::game.setText("EMT_SAXONS_STONE_KEEP", "Ñoldorin Castle")
        ::game.setText("EMT_SAXONS_CASTLE", "Ñoldorin Stronghold")
        ::game.setText("EMT_SAXONS_LARGE_CASTLE", "Ñoldorin Fortress")
        ::game.setText("EMT_SAXONS_FORTRESS", "Ñoldorin Citadel")
        ::game.setText("EMT_SAXONS_STAR_FORT", "Ñoldorin Star Fort")
        ::game.setText("EMT_SAXONS_CAPITAL", "Ñoldorin Capital")
        ::game.setText("EMT_SAXONS_FORT", "Ñoldorin Fort")
        ::game.setText("EMT_SAXONS_PORT", "Ñoldorin Port")
        ::game.setText("EMT_SAXONS_DOCK", "Ñoldorin Docks")
        ::game.setText("EMT_SAXONS_FISHING_VILLAGE", "Ñoldorin Fishing Village")
        ::game.setText("EMT_SAXONS_WATCHTOWER", "Ñoldorin Watchtower")
        ::game.setText("EMT_SAXONS_FACTION_LEADER", "Ñoldorin Faction Leader")
        ::game.setText("EMT_SAXONS_FACTION_HEIR", "Ñoldorin Faction Heir")
        ::game.setText("EMT_SAXONS_FACTION_LEADER_TITLE", "High King")
        ::game.setText("EMT_SAXONS_FACTION_HEIR_TITLE", "Lord")
        ::game.setText("EMT_SAXONS_FACTION_LEADER_NAME", "High King %S")
        ::game.setText("EMT_SAXONS_FACTION_HEIR_NAME", "Lord %S")
        ::game.setText("EMT_SAXONS_FORMER_FACTION_LEADER_TITLE", "High Lord")
    }

    function eregionStoryText() {
        if (::EUR.eur_player_faction.name == "egypt") {
            ::game.showHistoricEvent("faction_info_eregion", "Faction Info: Realm of Eregion", "Faction Info: Led by High Prince Maernil, and Crown Prince Ecthellion, we are the true heirs of Finwe and Feanor. We must embrace the wrath of our ancestral bloodline to carve out our restored kingdom, and establish a new homeland for the Noldor of Middle Earth, in memory of those lost in the Sinking of Belerian. To claim this heritage, we must first defeat both Lindon and Imladris. Once we have been firmly established, we can rebuild Celebrimbor’s Palace, forge a seat for our restored kingdom, and elevate High Prince Maernil to the seat of the High King of the Noldor. The coming days will be difficult, and we may find that by the time we have vanquished the pretenders of Imladris & Mithlond, the forces of Evil have driven the forces of Good to the brink of collapse. Before us stand two choices. To either save Middle-Earth from the Shadow of Melkor, or to conquer it, and rule it as the new Lord of the Rings.\n\nStrategic Breakdown: My Lord, we begin with a substantial fighting force  and, alongside High Prince Maernil, two powerful generals stand ready to lead our troops into battle. After Securing Ost-in-Noldor (if starting as Lindon) or Ost-in-Edhil (if starting as Imladris), our highest priorities should be expanding to the North. Additionally, we may benefit by securing alliances with our Neighbors to stand alongside us as we secure our homeland. While we are initially not at war with the Forces of Evil in the region, both Lindon and Imladris are still beset by the wars that predated our revolution. Our initial turns will revolve around repelling the invasions of our former kin and gradually entrenching your homelands. Once we’ve begun gaining ground, our focus can expand to the invasions of Lindon & Imladris. To gain access to our Tier Three Soldiers we must defeat the Elven Kingdom at our borders, and for tier Four soldiers we must defeat the remaining realm, be it Lindon or Imladris, as well as acquire the Capitals of both Kingdoms. This both advances the script, and setting us on the path of forming the Kingdom of Eregion.\n\nUnique Mechanics: The Noldor of Eregion can rebuild many powerful and ancient sanctums of the Noldor. The Moon Temple of Mithlond, and Maernil’s Fortress & Celebrimbor’s Palace in Ost-in-Edhil, and the High King’s Throne in Amon. If it has not already been so we can also rebuild the Gwaith-I-Mirdain, enlisting the aid of Dornornoston, chief of the Gwaith-I-Mirdain, and begin fielding members of the Smiths of Eregion.\n\nThe Rings of Power: As the True Heirs of Feanor, the Rings of Power are the birthright of our bloodline. Once we have seized Imladris & Mithlond, place a general within the cities for 6+ Turns and they will acquire the Rings of Power Vilya and Narya respectively, providing their powers to your chosen Generals.\n\nThe One Ring: The Noldor of Eregion are one of the select factions that have a unique script focused around the Ruling Ring. As the heirs of Feanor the Rings of Power are our birthright. Upon capturing the town where it is held, Maernil can choose either to destroy the One Ring, or to claim it for his own, unlocking powerful new units and strengthening Maernil’s power on the battlefield.\n\nCulture: Elven\nThe firstborn of Arda, the Elves are among the eldest of the races still inhabiting Middle-Earth. With many carrying the combined experience of multiple Ages of the Earth, Elves are likely Masters of any Skill they have pursued, and in battle both female and male elves are equally deadly and beautiful. However, they are easily moved to wrathfulness, and to melancholy. Of the Three Great Kindreds of Elves that remain in Middle-Earth, the Noldor and Sindar 'High Elves' of Eriador are rapidly dwindling in number as they depart into the Uttermost West, with the Silvan Elves of the Woodland Realm being by far the most numerous, though there are also those among the Silvan Elves who answer the Call of the Sea, leaving Middle-Earth a darker place. Yet, those who remain are among the most stalwart in defiance of the Enemy. There is one kindred, however, that does not feel the Call of the Sea that their kin do... The Avari, or Dark Elves, of the far East; for they refused the Valar long ago, and are reputed in legend to be both cruel and kind, friendly and isolationist. The Avari are most represented among the Realm of Dorwinion, living in an unsteady union with the Men of that Land as 'kin'.")
        }
        if (::EUR.eregion_realms_start == 0) {
        } else if (::EUR.eregion_realms_start == 2) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][0].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][0].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][0].text)
        } else if (::EUR.eregion_realms_start == 3) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][1].text)
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][1].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][1].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][1].text)
        } else if (::EUR.eregion_realms_start == 5) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].text)
        } else if (::EUR.eregion_realms_start == 6) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][18].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][18].text)
        } else if (::EUR.eregion_realms_start == 7) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][4].text)
        } else if (::EUR.eregion_realms_start == 8) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][5].text)
        } else if (::EUR.eregion_realms_start == 9) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][6].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][6].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][6].text)
        } else if (::EUR.eregion_realms_start == 10) {
        } else if (::EUR.eregion_realms_start == 11) {
        } else if (::EUR.eregion_realms_start == 12) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][11].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][11].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][11].text)
        } else if (::EUR.eregion_realms_start == 13) {
        } else if (::EUR.eregion_realms_start == 18) {
            ::game.showHistoricEvent(::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][12].event, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][12].title, ::EUR.CONFED_EVENTS[::EUR.eur_localFactionName][3][12].text)
        } else if (::EUR.eregion_realms_start == 14) {
            ::game.showHistoricEvent("EREGION_KHAZAD", ::EUR.EREGION_KD_NOTIF_TITLE, ::EUR.EREGION_KD_NOTIF_BODY)
            if ((::EUR.eur_campaign.factionByName("denmark").characterCount == 0) || (::EUR.eur_campaign.factionByName("saxons").characterCount == 0)) {
                ::game.showHistoricEvent("KOE_PART_1", ::EUR.KOE_PART_1_TITLE, ::EUR.KOE_PART_1_BODY)
            }
        } else if (::EUR.eregion_realms_start == 21) {
            if ((::EUR.eur_campaign.factionByName("denmark").characterCount == 0) && (::EUR.eur_campaign.factionByName("saxons").characterCount == 0)) {
                ::game.showHistoricEvent("KOE_PART_2", ::EUR.KOE_PART_2_TITLE, ::EUR.KOE_PART_2_BODY)
            }
        } else if (::EUR.eregion_realms_start == 22) {
            local settlement = ::EUR.eur_sMap.findSettlement("Eregion")
            if (settlement != null && settlement.hasBuildingLevel("high_king_throne", true)) {
                local name = ::EUR.eur_campaign.factionByName("egypt").leader.displayName
                ::game.showHistoricEvent("KOE_FORM", "The Lord of the West", ::EUR.KOE_FORM_BODY_1 + name + ::EUR.KOE_FORM_BODY_2)
            }
        }
    }
}

::EUR.eurEregion <- eurEregion()
::UI.onFrame(function() { ::EUR.eurEregion.render() })

::EUR.CONFED_EVENTS <- {
    denmark = {
        [0] = { x = 81, y = 382, event = "reached_ost_en_noldor", title = ::EUR.REACHED_OST_EN_NOLDOR_TITLE, text = ::EUR.REACHED_OST_EN_NOLDOR_BODY },
        [1] = { sett = "Enedwaith", capital = "Mithlond", enemy = "hre", event = "captured_ost_en_noldor", title = ::EUR.CAPTURED_OST_EN_NOLDOR_TITLE, text = ::EUR.CAPTURED_OST_EN_NOLDOR_BODY },
        [3] = {
            [0] = function() { ::EUR.eurEregion.lindon_invasion_0() },
            [1] = { event = "l_eregion_goblin_invasion_start", title = ::EUR.L_EREGION_GOBLIN_INVASION_START_TITLE, text = ::EUR.L_EREGION_GOBLIN_INVASION_START_BODY },
            [2] = { event = "l_eregion_goblin_invasion_halfway", title = ::EUR.L_EREGION_GOBLIN_INVASION_HALFWAY_TITLE, text = ::EUR.L_EREGION_GOBLIN_INVASION_HALFWAY_BODY },
            [3] = { event = "l_eregion_goblin_invasion_arrive", title = ::EUR.L_EREGION_GOBLIN_INVASION_ARRIVE_TITLE, text = ::EUR.L_EREGION_GOBLIN_INVASION_ARRIVE_BODY },
            [4] = { event = "l_eregion_realms_start", title = ::EUR.L_EREGION_REALMS_START_TITLE, text = ::EUR.L_EREGION_REALMS_START_BODY },
            [5] = { event = "eregion_maernil_recover", title = ::EUR.EREGION_MAERNIL_RECOVER_TITLE, text = ::EUR.EREGION_MAERNIL_RECOVER_BODY },
            [6] = { event = "eregion_rebellion_start", title = ::EUR.EREGION_REBELLION_START_TITLE, text = ::EUR.EREGION_REBELLION_START_BODY },
            [7] = { event = "eregion_rebellion_choice", title = ::EUR.EREGION_REBELLION_CHOICE_TITLE, text = ::EUR.EREGION_REBELLION_CHOICE_BODY },
            [8] = { event = "eregion_rebellion_choice_r", title = ::EUR.EREGION_REBELLION_CHOICE_R_TITLE, text = ::EUR.EREGION_REBELLION_CHOICE_R_BODY },
            [9] = { event = "eregion_rebellion_choice_a", title = ::EUR.EREGION_REBELLION_CHOICE_A_TITLE, text = ::EUR.EREGION_REBELLION_CHOICE_A_BODY },
            [10] = { event = "kon_kinslaying", title = ::EUR.KON_KINSLAYING_TITLE, text = ::EUR.KON_KINSLAYING_BODY },
            [11] = { event = "kon_eregion_destroy", title = ::EUR.KON_EREGION_DESTROY_TITLE, text = ::EUR.KON_EREGION_DESTROY_BODY },
            [12] = { event = "kon_call", title = ::EUR.KON_CALL_TITLE, text = ::EUR.KON_CALL_BODY },
            [13] = { event = "kon_council_choice", title = ::EUR.KON_COUNCIL_CHOICE_TITLE, text = ::EUR.KON_COUNCIL_CHOICE_BODY },
            [14] = { event = "koe_kinslaying", title = ::EUR.KOE_KINSLAYING_TITLE, text = ::EUR.KOE_KINSLAYING_BODY },
            [15] = { event = "kon_council_choice_a", title = ::EUR.KON_COUNCIL_CHOICE_A_TITLE, text = ::EUR.KON_COUNCIL_CHOICE_A_BODY },
            [16] = { event = "kon_council_choice_r", title = ::EUR.KON_COUNCIL_CHOICE_R_TITLE, text = ::EUR.KON_COUNCIL_CHOICE_R_BODY },
            [17] = { event = "l_eregion_goblin_invasion_arrive", title = ::EUR.L_CAP_LOST_TITLE, text = ::EUR.L_CAP_LOST_BODY },
            [18] = { event = "l_eregion_goblin_invasion_arrive", title = ::EUR.L_CAP_UNLOST_TITLE, text = ::EUR.L_CAP_UNLOST_BODY },
        }
    },
    saxons = {
        [0] = { x = 214, y = 311, event = "reached_ost_in_edhil", title = ::EUR.REACHED_OST_IN_EDHIL_TITLE, text = ::EUR.REACHED_OST_IN_EDHIL_BODY },
        [1] = { sett = "Eregion", capital = "Imladris", enemy = "hre", event = "captured_ost_in_edhil", title = ::EUR.CAPTURED_OST_IN_EDHIL_TITLE, text = ::EUR.CAPTURED_OST_IN_EDHIL_BODY },
        [3] = {
            [0] = function() { ::EUR.eurEregion.imladris_invasion_0() },
            [1] = { event = "i_eregion_goblin_invasion_start", title = ::EUR.I_EREGION_GOBLIN_INVASION_START_TITLE, text = ::EUR.I_EREGION_GOBLIN_INVASION_START_BODY },
            [2] = { event = "i_eregion_goblin_invasion_halfway", title = ::EUR.I_EREGION_GOBLIN_INVASION_HALFWAY_TITLE, text = ::EUR.I_EREGION_GOBLIN_INVASION_HALFWAY_BODY },
            [3] = { event = "i_eregion_goblin_invasion_arrive", title = ::EUR.I_EREGION_GOBLIN_INVASION_ARRIVE_TITLE, text = ::EUR.I_EREGION_GOBLIN_INVASION_ARRIVE_BODY },
            [4] = { event = "i_eregion_realms_start", title = ::EUR.I_EREGION_REALMS_START_TITLE, text = ::EUR.I_EREGION_REALMS_START_BODY },
            [5] = { event = "eregion_maernil_recover", title = ::EUR.EREGION_MAERNIL_RECOVER_TITLE, text = ::EUR.EREGION_MAERNIL_RECOVER_BODY },
            [6] = { event = "eregion_rebellion_start", title = ::EUR.EREGION_REBELLION_START_TITLE, text = ::EUR.EREGION_REBELLION_START_BODY },
            [7] = { event = "eregion_rebellion_choice", title = ::EUR.EREGION_REBELLION_CHOICE_TITLE, text = ::EUR.EREGION_REBELLION_CHOICE_BODY },
            [8] = { event = "eregion_rebellion_choice_r", title = ::EUR.EREGION_REBELLION_CHOICE_R_TITLE, text = ::EUR.EREGION_REBELLION_CHOICE_R_BODY },
            [9] = { event = "eregion_rebellion_choice_a", title = ::EUR.EREGION_REBELLION_CHOICE_A_TITLE, text = ::EUR.EREGION_REBELLION_CHOICE_A_BODY },
            [10] = { event = "koe_kinslaying", title = ::EUR.KON_KINSLAYING_TITLE, text = ::EUR.KON_KINSLAYING_BODY },
            [11] = { event = "kon_eregion_destroy", title = ::EUR.KON_EREGION_DESTROY_TITLE, text = ::EUR.KON_EREGION_DESTROY_BODY },
            [12] = { event = "kon_call", title = ::EUR.KON_CALL_TITLE, text = ::EUR.KON_CALL_BODY },
            [13] = { event = "kon_council_choice", title = ::EUR.KON_COUNCIL_CHOICE_TITLE, text = ::EUR.KON_COUNCIL_CHOICE_BODY },
            [14] = { event = "koe_kinslaying", title = ::EUR.KON_KINSLAYING_TITLE, text = ::EUR.KON_KINSLAYING_BODY },
            [15] = { event = "kon_council_choice_a", title = ::EUR.KON_COUNCIL_CHOICE_A_TITLE, text = ::EUR.KON_COUNCIL_CHOICE_A_BODY },
            [16] = { event = "kon_council_choice_r", title = ::EUR.KON_COUNCIL_CHOICE_R_TITLE, text = ::EUR.KON_COUNCIL_CHOICE_R_BODY },
            [17] = { event = "l_eregion_goblin_invasion_arrive", title = ::EUR.I_CAP_LOST_TITLE, text = ::EUR.I_CAP_LOST_BODY },
            [18] = { event = "l_eregion_goblin_invasion_arrive", title = ::EUR.I_CAP_UNLOST_TITLE, text = ::EUR.I_CAP_UNLOST_BODY },
        }
    },
}

::EUR.cap_lost_event <- false

