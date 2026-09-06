::EUR.bg_target_edu <- ""
::EUR.basic_rank_check <- {}
::EUR.char_rank <- 0
::EUR.gen_units_char <- null
::EUR.gen_rank_char <- null
::EUR.temp_com_inf <- 0
::EUR.temp_gen_units <- []
::EUR.temp_gen_units_target <- 0
::EUR.temp_gen_units_target_clicked <- false
::EUR.temp_used <- false
::EUR.guard_add <- 0
::EUR.cost <- 0
::EUR.temp_char_stuff <- null
::EUR.gen_pool_info <- {}
::EUR.gen_pool_reset <- false
::EUR.player_start_threshold <- 5

::EUR.BG_LEVELS <- [
    { card = "faction_upgrade_card_bw",     tier = null,     tint = [255, 255, 255, 255] },
    { card = "faction_upgrade_card_bronze", tier = "t1",     tint = [204, 128,  51, 255] },
    { card = "faction_upgrade_card_silver", tier = "t2",     tint = [191, 191, 191, 255] },
    { card = "faction_upgrade_card_gold",   tier = "t3",     tint = [255, 214,   0, 255] },
    { card = "faction_upgrade_card_blue",   tier = "Unique", tint = [135, 207, 235, 255] },
]

class generalBGSwap {
    layout = {
        windowX = 0, windowY = 0, windowW = 960, windowH = 835,
        acceptW = 610, acceptH = 310,
        panelInsetX = -55, panelInsetY = 25,
        panelOffsetX = 0, panelOffsetY = -10,
        panelWidthDelta = 0, panelHeightDelta = 64,
        acceptPanelInsetX = -75, acceptPanelInsetY = -50, acceptTextPadX = 16,
        acceptPanelOffsetX = 0, acceptPanelOffsetY = 0,
        acceptPanelWidthDelta = 0, acceptPanelHeightDelta = 0,

        headingFontSize = 0, bodyFontSize = 12,
        headingY = -40,
        textColour = [0, 0, 0, 255],
        messageColour = [255, 0, 0, 255],
        disabledCardTint = [255, 255, 255, 110],
        cardLiftHover = 51, cardLiftHeld = 77,

        hudCardX = 362, hudCardY = 830, hudCardSize = 68,

        contentX = -25, contentY = 40,
        nameY = 0, nameFontSize = 16,

        rankBarW = 300, rankBarH = 25,
        rankBarBack = [0, 0, 0, 0],
        rankBarFillT1 = [205, 127, 50, 200],
        rankBarFillT2 = [192, 192, 192, 200],
        rankBarFillT3 = [212, 175, 55, 200],
        rankBarTextColour = [0, 0, 0, 255],
        rankBarTextX = 6, rankBarTextY = 4,
        rankBarMaxRank = 20.0,
        rankBarAdvance = 30,

        aliasInputW = 200, aliasInputH = 20,
        aliasUpdateGapX = 8, aliasUpdateH = 20,
        aliasAdvance = 26,

        portraitSize = 112, portraitAdvance = 134,
        bodyguardCardX = 132, bodyguardCardSize = 88,

        guardButtonGapX = 8, guardAdvance = 28,
        guardCost = 500,
        guardBoxW = 60, guardBoxH = 20, guardBoxTextY = 2,
        guardCoinSize = 16, guardCoinX = 4, guardCostX = 24,
        guardAddGapX = 6,
        guardFill = [255, 255, 255, 180], guardFillHover = [255, 255, 255, 215], guardFillHeld = [255, 255, 255, 240],
        guardBorder = [70, 70, 70, 255],

        tierGridX = 400, tierGridY = 40,
        tierLabelAdvance = 20,
        tierCardGapX = 2, tierRowGapY = 4,

        messageY = 540, messagePadX = 20,
        coinSize = 20, costTextX = 24,
        targetCardY = 24,

        acceptButtonW = 80, acceptButtonH = 50,
        acceptButtonBottomGap = 90, acceptButtonSpreadX = 40,
    }

    swapScroll    = null
    swapCanvas    = 0
    acceptScroll  = null
    acceptCanvas  = 0
    cardCanvas    = 0
    aliasInput    = 0
    aliasFontSet  = false
    updateButton  = 0
    yesButton     = 0
    noButton      = 0
    cardCache     = null
    portraitCache = null
    swapRaised    = false
    shownLast     = false
    acceptRaised  = false

    function ensure() {
        if (this.swapScroll != null) return
        local self = this
        this.cardCache = {}
        this.portraitCache = {}

        ::UI.pushStyle(::EUR.eurStyles.basic_4)

        this.swapScroll = ::EUR.scroll.create(this.layout.windowW, this.layout.windowH, 0, 0, function() {
            ::EUR.window_states.swap_bg_window = false
        })
        this.swapCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.swapCanvas, function() { self.swapBGWindow() })

        this.aliasInput = ::UI.input("")
        ::UI.setWidgetStyle(this.aliasInput, ::EUR.eurStyles.basic_types.input)
        ::UI.placeAbsolute(this.aliasInput)
        this.updateButton = ::UI.button("Update")
        ::UI.placeAbsolute(this.updateButton)
        ::UI.buttonClick(this.updateButton, function() {
            local text = ::UI.inputTextGet(self.aliasInput)
            if (text != null && text != "" && ::EUR.temp_char_stuff != null) {
                ::EUR.temp_char_stuff.bodyguard.name = text
            }
        })

        this.acceptScroll = ::EUR.scroll.create(this.layout.acceptW, this.layout.acceptH, 0, 0)
        this.acceptCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.acceptCanvas, function() { self.bgSwapAccept() })

        this.yesButton = ::UI.button("Yes", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.yesButton)
        ::UI.buttonClick(this.yesButton, function() {
            local char = ::EUR.temp_char_stuff
            if (char == null) { return }
            local rec = char.record
            if (rec == null || char.bodyguard == null) { return }
            if (::EUR.bg_target_edu == "") { return }
            local name = rec.shortName + ("" + rec.label)
            if (!(name in ::EUR.persistent_gen_list) || ::EUR.persistent_gen_list[name] == null) { return }
            ::EUR.persistent_gen_list[name].cooldown = ::EUR.bg_swap_cooldown
            ::game.runConsoleCommand("add_money", "-" + ("" + ::EUR.cost))
            ::EUR.setBodyguard(char, ::EUR.bg_target_edu, char.bodyguard.experience, char.bodyguard.weaponLevel, 0, "")
            ::EUR.window_states.swap_bg_window = false
            ::EUR.show_bg_accept = false
            ::EUR.temp_gen_units_target = 0
            ::EUR.bg_target_edu = ""
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        this.noButton = ::UI.button("No", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.noButton)
        ::UI.buttonClick(this.noButton, function() {
            ::EUR.window_states.swap_bg_window = true
            ::EUR.show_bg_accept = false
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        ::UI.popStyle()

        ::EUR.scroll.sealOnTop(this.swapScroll)
        ::EUR.scroll.sealOnTop(this.acceptScroll)

        ::UI.setParent(0)
        this.cardCanvas = ::UI.canvas(this.layout.hudCardSize, this.layout.hudCardSize, this.layout.hudCardX, this.layout.hudCardY)
        ::UI.canvasDraw(this.cardCanvas, function() { self.checkcard() })

        ::UI.setParent(0)
        ::UI.widgetVisible(this.swapScroll.window, false)
        ::UI.widgetVisible(this.acceptScroll.window, false)
        ::UI.widgetVisible(this.aliasInput, false)
        ::UI.widgetVisible(this.updateButton, false)
        ::UI.widgetVisible(this.yesButton, false)
        ::UI.widgetVisible(this.noButton, false)
        if ("gamePanelWindow" in ::UI) { ::UI.gamePanelWindow(this.swapScroll.window, 0) }
        ::EUR.registerLeftWindow("swap_bg_window", this.swapScroll.window)
    }

    function swapArea() {
        local rect = ::UI.widgetRectGet(this.swapScroll.window)
        if (rect == null) { return null }
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) { return null }
        return { x = rect[0] + margins[0], y = rect[1] + margins[1],
                 width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }
    }

    function acceptArea() {
        local rect = ::UI.widgetRectGet(this.acceptScroll.window)
        if (rect == null) { return null }
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) { return null }
        return { x = rect[0] + margins[0], y = rect[1] + margins[1],
                 width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }
    }

    function unitCard(eduType, faction) {
        if (eduType in this.cardCache) return this.cardCache[eduType]
        local unitType = ::units.get(eduType)
        local texture = (unitType != null) ? ::UI.loadTexture(unitType.cardPath(faction)) : null
        this.cardCache[eduType] <- texture
        return texture
    }

    function cardButton(img, w, h, x, y, r = 255, g = 255, b = 255, a = 255) {
        local hit = ::UI.imageButton(img, w, h, x, y, r, g, b, a)
        if (hit.hovered) {
            ::UI.pushBlend(1)
            ::UI.drawRect(hit.x, hit.y, hit.w, hit.h, 255, 255, 255,
                          hit.held ? this.layout.cardLiftHeld : this.layout.cardLiftHover)
            ::UI.popBlend()
        }
        return hit.clicked
    }

    // The price tag IS the button: coins + the cost inside a drawn box, with the word after it. A
    // drawn control rather than a ::UI.button because this row is laid out inside the canvas pass,
    // and a retained widget here would need its own rect + visibility bookkeeping every frame.
    function guardAddButton(x, y, rec) {
        local w = this.layout.guardBoxW
        local h = this.layout.guardBoxH
        local hit = ::UI.hitRect(x, y, w, h)
        local fill = hit.held ? this.layout.guardFillHeld : (hit.hovered ? this.layout.guardFillHover : this.layout.guardFill)
        ::UI.drawRect(x, y, w, h, fill[0], fill[1], fill[2], fill[3])

        // Four edges, not a bigger rect behind: a translucent fill over a solid backing rect takes
        // the backing colour across the whole interior instead of leaving a border.
        local edge = this.layout.guardBorder
        ::UI.drawRect(x, y, w, 1, edge[0], edge[1], edge[2], edge[3])
        ::UI.drawRect(x, y + h - 1, w, 1, edge[0], edge[1], edge[2], edge[3])
        ::UI.drawRect(x, y, 1, h, edge[0], edge[1], edge[2], edge[3])
        ::UI.drawRect(x + w - 1, y, 1, h, edge[0], edge[1], edge[2], edge[3])

        if (::EUR.coins != null && ::EUR.coins.img != 0) {
            ::UI.image(::EUR.coins.img, this.layout.guardCoinSize, this.layout.guardCoinSize,
                       x + this.layout.guardCoinX, y + (h - this.layout.guardCoinSize) / 2)
        }
        ::UI.layoutAt(x + this.layout.guardCostX, y + this.layout.guardBoxTextY)
        ::UI.text("" + this.layout.guardCost)
        ::UI.layoutAt(x + w + this.layout.guardAddGapX, y + this.layout.guardBoxTextY)
        ::UI.text("Add")

        ::UI.tooltipAt(x, y, w, h)
        ::UI.tooltip(0, "Add one man to this general's personal guard for " + this.layout.guardCost + " gold.")

        if (hit.clicked) {
            rec.personalSecurity = rec.personalSecurity + 1
            ::game.runConsoleCommand("add_money", "-" + this.layout.guardCost)
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        }
    }

    // The red status line. Centred on the window and WRAPPED: it used to be drawn at a fixed x with
    // no wrap, so the longest reason ("...not garrisoned in a fort or settlement.") ran off the panel.
    function statusMessage(area, y, message) {
        local wrapW = area.width - this.layout.messagePadX * 2
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.messageColour,
                         [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = wrapW })
        ::UI.layoutAt(area.x + this.layout.messagePadX, y)
        ::UI.textWrapped(message, wrapW)
        ::UI.popStyle()
    }

    function portrait(path) {
        if (path in this.portraitCache) return this.portraitCache[path]
        local texture = ::UI.loadTexture(path)
        this.portraitCache[path] <- texture
        return texture
    }

    function checkcard() {
        ::EUR.syncLeftWindows()

        local cm = ::ui.cardManager()
        if (cm == null) { return }
        local windowOpen = ::EUR.window_states.swap_bg_window || ::EUR.window_states.show_upgrade_window
        local live = cm.selectedUnit(0) != null || cm.selectedCharacter != null
                     || cm.selectedSettlement != null || cm.selectedFort != null
        if (!live && !windowOpen) { return }
        if (::EUR.sel_unit == null) { return }

        local army = ::EUR.sel_unit.army
        if (army == null || ::EUR.UNIT_UPGRADES == null) { return }

        local faction = ::EUR.eur_player_faction.name
        local inGarrison = army.inFort() || army.inSettlement()
        local cardX = this.layout.hudCardX, cardY = this.layout.hudCardY, size = this.layout.hudCardSize

        if (::EUR.can_bg_swap) {
            local rec = ::EUR.temp_fort_char.record
            ::EUR.char_rank = ::EUR.genRankCheck(null, rec)
            if (::EUR.char_rank) { ::EUR.genUnitCheck(rec, ::EUR.char_rank) }
            local key = rec.shortName + ("" + rec.label)
            if ((key in ::EUR.persistent_gen_list) && ::EUR.persistent_gen_list[key]) { ::EUR.char_rank = ::EUR.math.floor(::EUR.char_rank * 5 / ::EUR.persistent_gen_list[key].turns) }
            ::EUR.genUnitCheck(rec, ::EUR.char_rank)

            local level = ((rec.label in ::EUR.basic_rank_check) && ::EUR.basic_rank_check[rec.label]) ? ::EUR.basic_rank_check[rec.label] : 1
            local lv = ::EUR.BG_LEVELS[level]
            local card = ::EUR.show_gen_unit_card ? this.unitCard(::EUR.temp_fort_char.bodyguard.type.name, faction)
                                            : ((faction in ::EUR[lv.card]) ? ::EUR[lv.card][faction] : null)
            local tier = (lv.tier == null) ? ::EUR.faction_bg_name_list[faction].t1
                       : (lv.tier == "Unique") ? "Unique" : ::EUR.faction_bg_name_list[faction][lv.tier]

            if (card != null) {
                ::UI.pushHitMode(::UI.Hit.alpha)
                local hit = ::UI.imageButton(card.img, size, size, cardX, cardY)
                ::UI.popHitMode()
                if (hit.clicked) {
                    local opening = !::EUR.window_states.swap_bg_window
                    ::EUR.set_active_left_window(opening ? "swap_bg_window" : "")
                    ::game.runScriptCommand("play_sound_event", opening ? "STRAT_SCROLL_OPENS" : "STRAT_SCROLL_CLOSES")
                }
                ::UI.tooltipAt(cardX, cardY, size, size)
                local tip = ""
                tip += (tip == "" ? "" : "\n") + rec.displayName
                tip += (tip == "" ? "" : "\n") + tier
                tip += (tip == "" ? "" : "\n") + "Bodyguard: " + ::EUR.temp_fort_char.bodyguard.type.displayName
                local bg = ::EUR.temp_fort_char.bodyguard
                tip += (tip == "" ? "" : "\n") + "Upkeep " + ("" + ::EUR.math.ceil((bg.type.upkeep / bg.soldiersMax) * bg.soldiers))
                if (!inGarrison) { tip += (tip == "" ? "" : "\n") + "Move to fort or settlement to change bodyguard." }
                ::UI.tooltip(0, tip)
            }
        } else if (::EUR.sel_unit.type != null) {
            local upgradeable = ::EUR.can_unit_upgrade
            local card = upgradeable ? ((faction in ::EUR.faction_upgrade_card_silver) ? ::EUR.faction_upgrade_card_silver[faction] : null)
                                     : ((faction in ::EUR.faction_upgrade_card_bw) ? ::EUR.faction_upgrade_card_bw[faction] : null)
            if (card != null) {
                if (upgradeable) {
                    ::UI.pushHitMode(::UI.Hit.alpha)
                    local hit = ::UI.imageButton(card.img, size, size, cardX, cardY)
                    ::UI.popHitMode()
                    if (hit.clicked) {
                        ::EUR.alias_text = ""; ::EUR.alias_text_set = false
                        local opening = !::EUR.window_states.show_upgrade_window
                        ::EUR.set_active_left_window(opening ? "show_upgrade_window" : "")
                        ::game.runScriptCommand("play_sound_event", opening ? "STRAT_SCROLL_OPENS" : "STRAT_SCROLL_CLOSES")
                    }
                } else {
                    local tint = this.layout.disabledCardTint
                    ::UI.image(card.img, size, size, cardX, cardY, tint[0], tint[1], tint[2], tint[3])
                }
                ::UI.tooltipAt(cardX, cardY, size, size)
                local tip = ""
                tip += (tip == "" ? "" : "\n") + ::EUR.sel_unit.type.displayName
                if (!upgradeable) { tip += (tip == "" ? "" : "\n") + "No upgrades for this unit." }
                else if (!inGarrison) { tip += (tip == "" ? "" : "\n") + "Move to fort or settlement to upgrade." }
                ::UI.tooltip(0, tip)
            }
        }
    }

    function tierMatch(tier, edu, faction, label) {
        if (tier.list != null) {
            if (::EUR.tableContains(::EUR.gen_units_list[faction][tier.list], edu)) return true
            if (tier.list == "T3" && (label in ::EUR.bgunlock_units_list) && ::EUR.bgunlock_units_list[label] == edu) return true
            return false
        }
        if (::EUR.tableContains(::EUR.gen_units_list[faction]["T1"], edu)) return false
        if (::EUR.tableContains(::EUR.gen_units_list[faction]["T2"], edu)) return false
        if (::EUR.tableContains(::EUR.gen_units_list[faction]["T3"], edu)) return false
        if ((label in ::EUR.bgunlock_units_list) && ::EUR.bgunlock_units_list[label] == edu) return false
        return true
    }

    function styleAliasFont() {
        if (this.aliasFontSet) { return }
        this.aliasFontSet = true
        local id = 0
        local rows = ::UI.fonts()
        if (rows != null) {
            foreach (f in rows) {
                if (f.name == ::fonts.game.verdanaSml) { id = f.id }
            }
        }
        if (id != 0) { ::UI.setWidgetStyle(this.aliasInput, ::UI.Font.body, id) }
        ::UI.setWidgetStyle(this.aliasInput, ::UI.Metric.fontSize, this.layout.bodyFontSize)

        if (id != 0) { ::UI.setWidgetStyle(this.updateButton, ::UI.Font.body, id) }
        ::UI.setWidgetStyle(this.updateButton, ::UI.Metric.fontSize, this.layout.bodyFontSize)
    }

    function swapBGWindow() {
        if (!::EUR.in_campaign_map) { return }
        if (!::EUR.options_gen_upgrades) { return }
        local cm = ::ui.cardManager()
        if (cm.selectedCharacter == null && cm.selectedFort == null && cm.selectedSettlement == null) {
            ::EUR.window_states.swap_bg_window = false
            ::EUR.temp_fort_char = null
            return
        }
        if (::EUR.temp_fort_char == null) { ::EUR.window_states.swap_bg_window = false; return }

        if (::EUR.temp_char_stuff == null) { ::EUR.temp_char_stuff = ::EUR.temp_fort_char }
        if (::EUR.gen_units_char != null && ::EUR.temp_char_stuff != null && ::EUR.gen_units_char != ::EUR.temp_char_stuff) {
            ::EUR.temp_gen_units_target = 0; ::EUR.temp_gen_units = []; ::EUR.guard_add = 0
        }
        if (::EUR.temp_char_stuff == null) { return }
        if (::EUR.temp_char_stuff != ::EUR.temp_fort_char) {
            ::EUR.temp_char_stuff = ::EUR.temp_fort_char
            ::EUR.temp_gen_units_target = 0; ::EUR.temp_gen_units = []; ::EUR.guard_add = 0
        }
        if (::EUR.temp_char_stuff.typeId != 7) { return }

        ::EUR.cost = 0
        local faction = ::EUR.eur_player_faction.name
        local rec = ::EUR.temp_char_stuff.record

        local area = this.swapArea()
        if (area == null) { return }

        ::EUR.scroll.drawSet("panel",
                             (area.x + this.layout.panelInsetX + this.layout.panelOffsetX) / ::virtualScale.x,
                             (area.y + this.layout.panelInsetY + this.layout.panelOffsetY) / ::virtualScale.y,
                             (area.width - this.layout.panelInsetX * 2 + this.layout.panelWidthDelta) / ::virtualScale.x,
                             (area.height - this.layout.panelInsetY * 2 + this.layout.panelHeightDelta) / ::virtualScale.y)

        ::UI.layoutAt(area.x, area.y + this.layout.headingY)
        ::UI.pushFont(::fonts.game.verdana, false, this.layout.headingFontSize)
        ::UI.pushStyle({ [::UI.Metric.alignX] = 1,
                         [::UI.Metric.elideWidth] = area.width, [::UI.Colour.text] = this.layout.textColour })
        ::UI.text("General Upgrades")
        ::UI.popStyle()
        ::UI.popFont()

        ::UI.pushFont(::fonts.game.verdanaSml, false, this.layout.bodyFontSize)
        this.styleAliasFont()
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour })

        local leftX = area.x + this.layout.contentX
        local y = area.y + this.layout.contentY

        ::UI.layoutAt(area.x, area.y + this.layout.nameY)
        ::UI.pushStyle({ [::UI.Metric.fontSize] = this.layout.nameFontSize, [::UI.Metric.alignX] = 1,
                         [::UI.Metric.elideWidth] = area.width })
        ::UI.text(rec.displayName)
        ::UI.popStyle()

        if (::EUR.char_rank) {
            local rank = ::EUR.math.floor(::EUR.char_rank / 10)
            local tierText = "Rank: " + rank + " - " + ::EUR.faction_bg_name_list[faction].t1
            if (::EUR.char_rank >= (::EUR.bg_t3_rank * 10)) {
                tierText = "Rank: " + rank + " - " + ::EUR.faction_bg_name_list[faction].t3
            } else if (::EUR.char_rank >= (::EUR.bg_t2_rank * 10)) {
                tierText = "Rank: " + rank + " - " + ::EUR.faction_bg_name_list[faction].t2
            }
            local frac = rank / this.layout.rankBarMaxRank
            if (frac < 0.0) { frac = 0.0 }
            if (frac > 1.0) { frac = 1.0 }
            local fill = this.layout.rankBarFillT1
            if (::EUR.char_rank >= (::EUR.bg_t3_rank * 10)) { fill = this.layout.rankBarFillT3 }
            else if (::EUR.char_rank >= (::EUR.bg_t2_rank * 10)) { fill = this.layout.rankBarFillT2 }
            local back = this.layout.rankBarBack
            ::UI.drawRect(leftX, y, this.layout.rankBarW, this.layout.rankBarH, back[0], back[1], back[2], back[3])
            ::UI.drawRect(leftX, y, ::EUR.math.floor(this.layout.rankBarW * frac), this.layout.rankBarH, fill[0], fill[1], fill[2], fill[3])
            ::UI.layoutAt(leftX + this.layout.rankBarTextX, y + this.layout.rankBarTextY)
            ::UI.pushStyle({ [::UI.Metric.alignX] = 0,
                             [::UI.Metric.elideWidth] = this.layout.rankBarW - this.layout.rankBarTextX * 2,
                             [::UI.Colour.text] = this.layout.rankBarTextColour })
            ::UI.text(tierText)
            ::UI.popStyle()
            y += this.layout.rankBarAdvance
        }

        if (!::EUR.alias_text_set) {
            ::EUR.alias_text = ::EUR.temp_char_stuff.bodyguard.name
            ::EUR.alias_text_set = true
            ::UI.textSet(this.aliasInput, ::EUR.alias_text)
        }
        ::UI.widgetRect(this.aliasInput, leftX, y, this.layout.aliasInputW, this.layout.aliasInputH)
        ::UI.widgetRect(this.updateButton, leftX + this.layout.aliasInputW + this.layout.aliasUpdateGapX, y,
                        0, this.layout.aliasUpdateH)
        ::EUR.alias_text = ::UI.inputTextGet(this.aliasInput)
        local focused = (::UI.focusedWidget() == this.aliasInput)
        if (focused != ::EUR.INPUT_TEXT_FOCUSED) {
            ::game.runScriptCommand("disable_shortcuts", (focused ? "true" : "false"))
            ::EUR.INPUT_TEXT_FOCUSED = focused
        }
        y += this.layout.aliasAdvance

        local portrait = this.portrait(rec.portraitPath)
        if (portrait != null && portrait.img != 0) {
            ::UI.image(portrait.img, this.layout.portraitSize, this.layout.portraitSize, leftX, y)
            local bgCard = this.unitCard(::EUR.temp_char_stuff.bodyguard.type.name, faction)
            if (bgCard != null) {
                local bgx = leftX + this.layout.bodyguardCardX
                local bgSize = this.layout.bodyguardCardSize
                ::UI.image(bgCard.img, bgSize, bgSize, bgx, y)
                ::UI.tooltipAt(bgx, y, bgSize, bgSize)
                ::UI.tooltip(0, ::units.get(::EUR.temp_char_stuff.bodyguard.type.name).displayName + "\n" + ::EUR.showEDUStats(::EUR.temp_char_stuff.bodyguard.type.name))
            }
        }
        y += this.layout.portraitAdvance

        ::EUR.char_rank = ::EUR.genRankCheck(null, rec)
        local name = rec.shortName + ("" + rec.label)
        if ((name in ::EUR.persistent_gen_list) && ::EUR.persistent_gen_list[name]) { ::EUR.char_rank = ::EUR.math.floor(::EUR.char_rank * 5 / ::EUR.persistent_gen_list[name].turns) }
        if (::EUR.char_rank >= 200) { ::EUR.char_rank = 200 }
        ::EUR.genUnitCheck(rec, ::EUR.char_rank)
        ::EUR.temp_gen_units = ::EUR.removeDuplicates(::EUR.temp_gen_units)
        if (::EUR.temp_gen_units.len() > ::EUR.temp_gen_units_target && ::EUR.temp_gen_units[::EUR.temp_gen_units_target]) {
            local edu = ::units.get(::EUR.temp_gen_units[::EUR.temp_gen_units_target])
            if (edu != null) { ::EUR.cost = edu.recruitCost }
        }

        local guardText = "Personal Guard: " + ("" + rec.personalSecurity)
        ::UI.layoutAt(leftX, y)
        ::UI.text(guardText)
        if (!::EUR.tableContains(::EUR.not_increase_guard, rec.label) && rec.personalSecurity < ::EUR.personal_guard_limit
            && ::EUR.eur_player_faction.money >= this.layout.guardCost) {
            this.guardAddButton(leftX + ::UI.textSize(guardText)[0] + this.layout.guardButtonGapX, y, rec)
        }
        y += this.layout.guardAdvance

        local BG_TIERS = [
            { label = ::EUR.faction_bg_name_list[faction].t1, list = "T1", threshold = 0,               sound = "7"  },
            { label = ::EUR.faction_bg_name_list[faction].t2, list = "T2", threshold = ::EUR.bg_t2_rank * 10,  sound = "8"  },
            { label = ::EUR.faction_bg_name_list[faction].t3, list = "T3", threshold = ::EUR.bg_t3_rank * 10,  sound = "10" },
            { label = "Unique",                         list = null, threshold = 0,               sound = "12" },
        ]
        local gridX = area.x + this.layout.tierGridX
        local gy = area.y + this.layout.tierGridY
        foreach (tier in BG_TIERS) {
            ::UI.layoutAt(gridX, gy); ::UI.text(tier.label); gy += this.layout.tierLabelAdvance
            local cursorX = gridX
            for (local i = 0; i < ::EUR.temp_gen_units.len(); i++) {
                local edu = ::EUR.temp_gen_units[i]
                if (edu == null || !this.tierMatch(tier, edu, faction, rec.label)) continue
                local card = this.unitCard(edu, faction)
                if (card == null) continue
                local unlocked = ::EUR.char_rank >= tier.threshold
                if (unlocked) {
                    if (this.cardButton(card.img, ::EUR.img_x, ::EUR.img_y, cursorX, gy)) {
                        ::EUR.temp_gen_units_target = i
                        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
                    }
                } else {
                    local tint = this.layout.disabledCardTint
                    ::UI.image(card.img, ::EUR.img_x, ::EUR.img_y, cursorX, gy, tint[0], tint[1], tint[2], tint[3])
                }
                ::UI.tooltipAt(cursorX, gy, ::EUR.img_x, ::EUR.img_y)
                ::UI.tooltip(0, ::units.get(edu).displayName + (unlocked ? "" : " Locked.") + "\n" + ::EUR.showEDUStats(edu))
                cursorX += ::EUR.img_x + this.layout.tierCardGapX
            }
            gy += ::EUR.img_y + this.layout.tierRowGapY
        }

        local charArmy = null
        if (::EUR.temp_char_stuff.settlement) { charArmy = ::EUR.temp_char_stuff.settlement.army }
        else if (::EUR.temp_char_stuff.fort) { charArmy = ::EUR.temp_char_stuff.fort.army }
        else if (::EUR.temp_char_stuff.army != null) { charArmy = ::EUR.temp_char_stuff.army }

        local msgY = area.y + this.layout.messageY
        if (::EUR.tableContains(::EUR.not_increase_guard, rec.label)) {
            this.statusMessage(area, msgY, "Cannot change this general.")
        } else if (charArmy != null) {
            if (!(name in ::EUR.persistent_gen_list) || ::EUR.persistent_gen_list[name] == null) {
                this.statusMessage(area, msgY, "New general, cannot change yet.")
            } else if (::EUR.persistent_gen_list[name].cooldown != 0) {
                this.statusMessage(area, msgY, "Cannot change for: " + ::EUR.persistent_gen_list[name].cooldown + " turns.")
            } else if (charArmy.unitCount > 19) {
                this.statusMessage(area, msgY, "Cannot swap with full army.")
            } else if (::EUR.temp_gen_units.len() > ::EUR.temp_gen_units_target && ::EUR.temp_gen_units[::EUR.temp_gen_units_target] && ::EUR.temp_gen_units[::EUR.temp_gen_units_target] == ::EUR.temp_char_stuff.bodyguard.type.name) {
                this.statusMessage(area, msgY, "Same as current bodyguard.")
            } else if (::EUR.temp_gen_units.len() > ::EUR.temp_gen_units_target && ::EUR.temp_gen_units[::EUR.temp_gen_units_target]) {
                if (::EUR.temp_char_stuff.faction.money < ::EUR.cost) {
                    this.statusMessage(area, msgY, "Not enough gold.")
                } else if (!(charArmy.inSettlement() || charArmy.inFort())) {
                    this.statusMessage(area, msgY, "Cannot change as not garrisoned in a fort or settlement.")
                } else {
                    local target = this.unitCard(::EUR.temp_gen_units[::EUR.temp_gen_units_target], faction)
                    local cardX = area.x + (area.width - ::EUR.img_x) / 2
                    local cardY = msgY + this.layout.targetCardY
                    if (::EUR.coins != null) {
                        ::UI.image(::EUR.coins.img, this.layout.coinSize, this.layout.coinSize, cardX, msgY)
                    }
                    ::UI.layoutAt(cardX + this.layout.costTextX, msgY); ::UI.text("" + ::EUR.cost)
                    if (target != null) {
                        if (this.cardButton(target.img, ::EUR.img_x, ::EUR.img_y, cardX, cardY)) {
                            ::EUR.bg_target_edu = ::EUR.temp_gen_units[::EUR.temp_gen_units_target]
                            ::EUR.show_bg_accept = true
                            ::EUR.window_states.swap_bg_window = false
                            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
                        }
                        ::UI.tooltipAt(cardX, cardY, ::EUR.img_x, ::EUR.img_y)
                        ::UI.tooltip(0, ::units.get(::EUR.temp_gen_units[::EUR.temp_gen_units_target]).displayName + "\n" + ::EUR.showEDUStats(::EUR.temp_gen_units[::EUR.temp_gen_units_target]))
                    }
                }
            }
        }

        ::UI.popStyle()
        ::UI.popFont()

        ::EUR.gen_units_char = ::EUR.temp_char_stuff
    }

    function bgSwapAccept() {
        if (::EUR.temp_gen_units.len() <= ::EUR.temp_gen_units_target || ::EUR.temp_gen_units[::EUR.temp_gen_units_target] == null || ::EUR.bg_target_edu == "") {
            ::EUR.window_states.swap_bg_window = true
            ::EUR.show_bg_accept = false
        }
        local area = this.acceptArea()
        if (area == null) { return }

        // Both insets are measured from the content AREA (the window minus the scroll set's
        // 9-slice margins), so an equal value on each axis puts the panel edge the same
        // distance inside on both. Negative grows it back out over the frame.
        local panelX = area.x + this.layout.acceptPanelInsetX + this.layout.acceptPanelOffsetX
        local panelW = area.width - this.layout.acceptPanelInsetX * 2 + this.layout.acceptPanelWidthDelta
        local panelY = area.y + this.layout.acceptPanelInsetY + this.layout.acceptPanelOffsetY
        local panelH = area.height - this.layout.acceptPanelInsetY * 2 + this.layout.acceptPanelHeightDelta
        ::EUR.scroll.drawSet("panel", panelX / ::virtualScale.x, panelY / ::virtualScale.y,
                             panelW / ::virtualScale.x, panelH / ::virtualScale.y)

        this.acceptText(panelX, panelY, panelW,
                        area.y + area.height - this.layout.acceptButtonBottomGap,
                        "Swap bodyguard to " + ::EUR.bg_target_edu + "?")
    }

    // Heading face, WRAPPED rather than elided, sat at the midpoint between the panel top and the
    // buttons instead of pinned near the top. textSize measures inside the pushed font scope, and
    // with a wrap width it answers the wrapped height, so a two-line message still centres.
    function acceptText(panelX, panelY, panelW, buttonY, message) {
        ::UI.pushFont(::fonts.game.verdana, false, this.layout.headingFontSize)
        local wrapW = panelW - this.layout.acceptTextPadX * 2
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour,
                         [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = wrapW })
        local textH = ::UI.textSize(message, 0, 0, wrapW)[1]
        ::UI.layoutAt(panelX + this.layout.acceptTextPadX, panelY + (buttonY - panelY - textH) / 2)
        ::UI.textWrapped(message, wrapW)
        ::UI.popStyle()
        ::UI.popFont()
    }

    function render() {
        this.ensure()
        ::EUR.syncLeftWindows()

        local showSwap = ::EUR.window_states.swap_bg_window && ::EUR.in_campaign_map
                         && !::EUR.show_bg_accept && ::EUR.can_bg_swap
        showSwap = ::EUR.panelFollow(this.swapScroll.window, ::EUR.window_states, "swap_bg_window",
                                     showSwap, this.shownLast)
        this.shownLast = showSwap
        ::UI.widgetVisible(this.aliasInput, showSwap)
        ::UI.widgetVisible(this.updateButton, showSwap)
        if (showSwap) {
            local screen = ::UI.screenSize()
            ::UI.widgetRect(this.swapScroll.window, this.layout.windowX, this.layout.windowY, this.layout.windowW, this.layout.windowH)
            if (!this.swapRaised) { ::UI.raise(this.swapScroll.window) }
        }
        this.swapRaised = showSwap

        local showAccept = ::EUR.show_bg_accept && ::EUR.in_campaign_map
        ::UI.widgetVisible(this.acceptScroll.window, showAccept)
        if (showAccept) {
            local screen = ::UI.screenSize()
            ::UI.widgetRect(this.acceptScroll.window, (screen[0] - this.layout.acceptW) / 2, (screen[1] - this.layout.acceptH) / 2, this.layout.acceptW, this.layout.acceptH)
            if (!this.acceptRaised) { ::UI.raise(this.acceptScroll.window) }
        }
        this.acceptRaised = showAccept

        local acceptArea = this.acceptArea()
        if (acceptArea != null) {
            local half = (acceptArea.width - this.layout.acceptButtonW) / 2
            local btnY = acceptArea.y + acceptArea.height - this.layout.acceptButtonBottomGap
            ::UI.widgetRect(this.yesButton, acceptArea.x + half - this.layout.acceptButtonSpreadX, btnY, this.layout.acceptButtonW, this.layout.acceptButtonH)
            ::UI.widgetRect(this.noButton, acceptArea.x + half + this.layout.acceptButtonSpreadX, btnY, this.layout.acceptButtonW, this.layout.acceptButtonH)
        }
        ::UI.widgetVisible(this.yesButton, showAccept)
        ::UI.widgetVisible(this.noButton, showAccept)
    }
}

::EUR.generalBGSwap <- generalBGSwap()
::UI.onFrame(function() { ::EUR.generalBGSwap.render() })

::EUR.genUnitCheck <- function(char, char_rank) {
    if (char == null) { return }
    if (::EUR.gen_units_char == char) { return }
    local faction = char.character.faction.name
    ::EUR.temp_gen_units = []
    for (local i = 0; i < ::EUR.gen_units_list[faction]["T1"].len(); i++) {
        local eduEntry = ::units.get(::EUR.gen_units_list[faction]["T1"][i])
        if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
            if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.gen_units_list[faction]["T1"][i])) {
                ::EUR.temp_gen_units.append(::EUR.gen_units_list[faction]["T1"][i])
            }
        }
    }
    if (char_rank >= 0) {
        for (local i = 0; i < ::EUR.gen_units_list[faction]["T2"].len(); i++) {
            local eduEntry = ::units.get(::EUR.gen_units_list[faction]["T2"][i])
            if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
                if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.gen_units_list[faction]["T2"][i])) {
                    ::EUR.temp_gen_units.append(::EUR.gen_units_list[faction]["T2"][i])
                }
                if (char_rank >= (::EUR.bg_t2_rank * 10)) {
                    if (!(char.label in ::EUR.basic_rank_check) || ::EUR.basic_rank_check[char.label] < 2) {
                        ::EUR.basic_rank_check[char.label] <- 2
                    }
                }
            }
        }
    }
    if (char_rank >= 0) {
        for (local i = 0; i < ::EUR.gen_units_list[faction]["T3"].len(); i++) {
            local eduEntry = ::units.get(::EUR.gen_units_list[faction]["T3"][i])
            if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
                if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.gen_units_list[faction]["T3"][i])) {
                    ::EUR.temp_gen_units.append(::EUR.gen_units_list[faction]["T3"][i])
                }
                if (char_rank >= (::EUR.bg_t3_rank * 10)) {
                    if (!(char.label in ::EUR.basic_rank_check) || ::EUR.basic_rank_check[char.label] < 3) {
                        ::EUR.basic_rank_check[char.label] <- 3
                    }
                }
            }
        }
    }
    ::EUR.traits_temp = []
    foreach (k, v in ::EUR.labtrait_units_list) {
        if (char.traitLevel(k) > 0) {
            local eduEntry = ::units.get(v)
            if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
                ::EUR.temp_gen_units.append(v)
            }
        }
    }
    foreach (k, v in ::EUR.conquer_traits) {
        if (char.traitLevel(k) > v) {
            for (local i = 0; i < ::EUR.gen_units_list[faction]["special"].len(); i++) {
                local eduEntry = ::units.get(::EUR.gen_units_list[faction]["special"][i])
                if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
                    if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.gen_units_list[faction]["special"][i])) {
                        ::EUR.temp_gen_units.append(::EUR.gen_units_list[faction]["special"][i])
                    }
                    if (!(char.label in ::EUR.basic_rank_check) || ::EUR.basic_rank_check[char.label] < 4) {
                        ::EUR.basic_rank_check[char.label] <- 4
                    }
                }
            }
        }
    }
    if ((char.label in ::EUR.labtrait_units_list) && ::EUR.labtrait_units_list[char.label]) {
        local eduEntry = ::units.get(::EUR.labtrait_units_list[char.label])
        if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
            if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.labtrait_units_list[char.label])) {
                ::EUR.temp_gen_units.append(::EUR.labtrait_units_list[char.label])
            }
        }
    }
    if ((char.label in ::EUR.bgunlock_units_list) && ::EUR.bgunlock_units_list[char.label]) {
        local eduEntry = ::units.get(::EUR.bgunlock_units_list[char.label])
        if (eduEntry != null && eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
            if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.bgunlock_units_list[char.label])) {
                ::EUR.temp_gen_units.append(::EUR.bgunlock_units_list[char.label])
            }
        }
    }
    if (char.traitLevel("FactionLeader") > 0 || char.traitLevel("FactionLeaderCustom") > 0) {
        if ((char.character.faction.name in ::EUR.leaderheir_combi_list) && ::EUR.leaderheir_combi_list[char.character.faction.name]) {
            local eduEntry = ::units.get(::EUR.leaderheir_combi_list[char.character.faction.name].leader.unit)
            if (eduEntry != null && eduEntry.hasOwnership(char.character.faction.id)) {
                if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.leaderheir_combi_list[char.character.faction.name].leader.unit)) {
                    ::EUR.temp_gen_units.append(::EUR.leaderheir_combi_list[char.character.faction.name].leader.unit)
                }
                if (!(char.label in ::EUR.basic_rank_check) || ::EUR.basic_rank_check[char.label] < 4) {
                    ::EUR.basic_rank_check[char.label] <- 4
                }
            }
        }
    }
    if (::EUR.current_heir_check.len() == 0 || ::EUR.current_heir_check[0] == null) {
        ::EUR.swapHierStuffCheck(::EUR.eur_player_faction)
    }
    if (::EUR.current_heir_check.len() > 0 && ::EUR.current_heir_check[0] == char) {
        if (char.traitLevel("FactionHeir") > 0 || char.traitLevel("FactionHeirCustom") > 0) {
            if ((char.character.faction.name in ::EUR.leaderheir_combi_list) && ::EUR.leaderheir_combi_list[char.character.faction.name]) {
                local eduEntry = ::units.get(::EUR.leaderheir_combi_list[char.character.faction.name].heir.unit)
                if (eduEntry != null && eduEntry.hasOwnership(char.character.faction.id)) {
                    if (!::EUR.tableContains(::EUR.temp_gen_units, ::EUR.leaderheir_combi_list[char.character.faction.name].heir.unit)) {
                        ::EUR.temp_gen_units.append(::EUR.leaderheir_combi_list[char.character.faction.name].heir.unit)
                    }
                    if (!(char.label in ::EUR.basic_rank_check) || ::EUR.basic_rank_check[char.label] < 4) {
                        ::EUR.basic_rank_check[char.label] <- 4
                    }
                }
            }
        }
    }
    ::EUR.gen_units_char = char.character
}

::EUR.genRankCheck <- function(faction, char) {
    ::EUR.temp_com_inf = 0
    if (faction != null) {
        if (faction.isPlayerControlled == 0) { return }
        for (local i = 0; i <= faction.characterCount - 1; i++) {
            local c = faction.character(i)
            if (c.typeId == 7) {
                if (c.bodyguard != null) {
                    local record = c.record
                    if (record.label == "") { record.ensureLabel() }
                    local name = record.shortName + ("" + record.label)
                    if (!(name in ::EUR.persistent_gen_list)) {
                        ::EUR.persistent_gen_list[name] <- {}
                        ::EUR.persistent_gen_list[name].turns <- 1
                        ::EUR.persistent_gen_list[name].cooldown <- 0
                        ::EUR.persistent_gen_list[name].command <- {}
                        ::EUR.persistent_gen_list[name].loyalty <- {}
                        ::EUR.persistent_gen_list[name].authority <- {}
                        ::EUR.persistent_gen_list[name].battle_kills <- 0
                        ::EUR.persistent_gen_list[name].battle_won <- 0
                        ::EUR.persistent_gen_list[name].command[::EUR.persistent_gen_list[name].turns] <- ::EUR.math.min(record.command, 10)
                        ::EUR.persistent_gen_list[name].authority[::EUR.persistent_gen_list[name].turns] <- record.isLeader() ? ::EUR.math.min(record.authority, 10) : 0
                        ::EUR.persistent_gen_list[name].loyalty[::EUR.persistent_gen_list[name].turns] <- record.isLeader() ? 0 : ::EUR.math.min(record.loyalty, 10)
                    } else {
                        ::EUR.persistent_gen_list[name].turns = (::EUR.persistent_gen_list[name].turns > 4) ? 1 : ::EUR.persistent_gen_list[name].turns + 1
                        if (::EUR.persistent_gen_list[name].cooldown > 0) { ::EUR.persistent_gen_list[name].cooldown = ::EUR.persistent_gen_list[name].cooldown - 1 }
                        ::EUR.persistent_gen_list[name].command[::EUR.persistent_gen_list[name].turns] <- ::EUR.math.min(record.command, 10)
                        ::EUR.persistent_gen_list[name].authority[::EUR.persistent_gen_list[name].turns] <- record.isLeader() ? ::EUR.math.min(record.authority, 10) : 0
                        ::EUR.persistent_gen_list[name].loyalty[::EUR.persistent_gen_list[name].turns] <- record.isLeader() ? 0 : ::EUR.math.min(record.loyalty, 10)
                    }
                }
            }
        }
    }
    if (char != null) {
        if (::EUR.gen_rank_char != char) {
            local name = char.shortName + ("" + char.label)
            if ((name in ::EUR.persistent_gen_list) && ::EUR.persistent_gen_list[name] != null) {
                for (local i = 1; i <= ::EUR.persistent_gen_list[name].turns; i++) {
                    if ((i in ::EUR.persistent_gen_list[name].command) && ::EUR.persistent_gen_list[name].command[i] != null
                        && (i in ::EUR.persistent_gen_list[name].loyalty) && (i in ::EUR.persistent_gen_list[name].authority)) {
                        ::EUR.temp_com_inf = ::EUR.temp_com_inf + ((::EUR.persistent_gen_list[name].command[i] + ::EUR.persistent_gen_list[name].loyalty[i] + ::EUR.persistent_gen_list[name].authority[i]) * 2)
                        ::EUR.temp_com_inf = ::EUR.temp_com_inf + ::EUR.math.floor(::EUR.persistent_gen_list[name].battle_kills / 100) + ::EUR.math.floor(::EUR.persistent_gen_list[name].battle_won / 2)
                    }
                }
                return ::EUR.temp_com_inf
            } else {
                return 0
            }
        } else {
            return ::EUR.temp_com_inf
        }
    }
}

::EUR.getArmyForCharacter <- function(char) {
    local army = char.army
    if (army == null) {
        if (char.settlement != null) { army = char.settlement.army }
        else if (char.fort != null) { army = char.fort.army }
        else if (char.visitingArmy != null) { army = char.visitingArmy }
    }
    return army
}

::EUR.resizeBodyguard <- function(char) {
    if (!::EUR.options_gen_bg_size) { return }
    local maxSize = char.bodyguard.soldiersMax
    local minSize = maxSize * (::EUR.bg_min_size_multi / 100.0)
    local multi = (maxSize - minSize) / 10
    local command_add = 0
    if (char.record.command > 0) { command_add = multi * char.record.command }
    local additional = 0
    local guardSum = char.record.personalSecurity + char.record.bodyguardSize
    if (guardSum > 0) { additional = guardSum * 2.5 }
    local new_max = ::EUR.math.floor(minSize + command_add + additional)
    if (char.bodyguard.soldiers > new_max) {
        char.bodyguard.soldiers = new_max
    }
}

::EUR.processGeneralBodyguard <- function(char) {
    if (char == null) { return }
    if (char.typeId != 7) { return }
    if (char.bodyguard == null) { return }
    local faction = char.faction
    if (char.record.label == "") { char.record.ensureLabel() }

    if (!(char.record.label in ::EUR.persistent_gen_list_reset) || ::EUR.persistent_gen_list_reset[char.record.label] == null) {
        local default_unit = (faction.name in ::EUR.default_general_units) ? ::EUR.default_general_units[faction.name] : null
        if (default_unit != null) {
            if (default_unit.old == char.bodyguard.type.name) {
                local army = ::EUR.getArmyForCharacter(char)
                if (army == null) { return }
                if (army.unitCount < 20) {
                    local level = char.record.command + char.record.loyalty
                    local new_bg = null
                    if (faction.isPlayerControlled == 1) {
                        if (level > ::EUR.player_start_threshold) {
                            new_bg = ::EUR.gen_units_list[faction.name]["T2"][::EUR.random_no_repeat(0, ::EUR.gen_units_list[faction.name]["T2"].len() - 1)]
                        } else {
                            new_bg = ::EUR.gen_units_list[faction.name]["T1"][::EUR.random_no_repeat(0, ::EUR.gen_units_list[faction.name]["T1"].len() - 1)]
                        }
                        if (new_bg != null) {
                            ::EUR.persistent_gen_list_reset[char.record.label] <- true
                            ::EUR.setBodyguard(char, new_bg, char.bodyguard.experience, char.bodyguard.weaponLevel, 0, "")
                        }
                    } else {
                        if (level > 7) {
                            if (::EUR.random_no_repeat(1, 100) > 75) {
                                new_bg = ::EUR.gen_units_list[faction.name]["special"][::EUR.random_no_repeat(0, ::EUR.gen_units_list[faction.name]["special"].len() - 1)]
                            } else {
                                new_bg = ::EUR.gen_units_list[faction.name]["T3"][::EUR.random_no_repeat(0, ::EUR.gen_units_list[faction.name]["T3"].len() - 1)]
                            }
                        } else {
                            new_bg = ::EUR.gen_units_list[faction.name]["T2"][::EUR.random_no_repeat(0, ::EUR.gen_units_list[faction.name]["T2"].len() - 1)]
                        }
                        if (new_bg != null && (army.faction.name in ::EUR.default_general_units) && ::EUR.default_general_units[army.faction.name]) {
                            if (new_bg != ::EUR.default_general_units[army.faction.name].old) {
                                ::EUR.persistent_gen_list_reset[char.record.label] <- true
                                ::EUR.setBodyguard(char, new_bg, char.bodyguard.experience, char.bodyguard.weaponLevel, 0, "")
                            }
                        }
                    }
                }
            } else {
                ::EUR.persistent_gen_list_reset[char.record.label] <- true
                if (!(char.record.label in ::EUR.labtrait_units_list) || !::EUR.labtrait_units_list[char.record.label]) {
                    ::EUR.labtrait_units_list[char.record.label] <- char.bodyguard.type.name
                }
            }
        }
    }
    ::EUR.resizeBodyguard(char)
}

::EUR.setBGSize <- function(faction, character, unit) {
    if (!::EUR.options_gen_upgrades) { return }
    if (faction != null && faction.name == "slave") { return }
    if (::EUR.options_first_run) { return }
    if (faction != null) {
        for (local i = 0; i <= faction.characterCount - 1; i++) {
            ::EUR.processGeneralBodyguard(faction.character(i))
        }
    }
    if (character != null) { ::EUR.processGeneralBodyguard(character) }
    if (unit != null) { ::EUR.processGeneralBodyguard(unit.general) }
}

::EUR.genPoolReset <- function() {
    if (!::EUR.gen_pool_reset) { return }
    local reset = false
    foreach (k, v in ::EUR.gen_pool_info) {
        local sett = ::stratMap.findSettlement(::EUR.gen_pool_info[k].name)
        for (local i = 0; i <= sett.recruitPoolCount - 1; i++) {
            local pool = sett.recruitPool(i)
            if (pool.unitTypeIndex == ::EUR.gen_pool_info[k].eduIndex) {
                if (pool.available != ::EUR.gen_pool_info[k].availablePool) {
                    sett.setRecruitPool(pool.unitTypeIndex, ::EUR.gen_pool_info[k].availablePool)
                    reset = true
                }
            }
        }
    }
    if (reset) {
        ::EUR.gen_pool_reset = false
        ::EUR.gen_pool_info = {}
    }
}

::EUR.setBodyguard <- function(character, newBodyguardType, expLvl, weaponLvl, armourLvl, bgAlias) {
    if (character.bodyguard == null) { return }
    local edu = ::units.get(newBodyguardType)
    if (edu == null) { return }
    local default_unit = (character.faction.name in ::EUR.default_general_units) ? ::EUR.default_general_units[character.faction.name] : null
    character.faction.record.disbandToPools = false
    ::EUR.pause_disband = true
    if (expLvl == null) { expLvl = 0 }
    if (armourLvl == null) { armourLvl = 0 }
    if (weaponLvl == null) { weaponLvl = 0 }

    local originalBodyguard = character.bodyguard
    local pool_check = originalBodyguard
    if (default_unit != null && pool_check.type.name == default_unit.old) {
        local sett = character.settlement
        if (sett) {
            for (local i = 0; i <= sett.recruitPoolCount - 1; i++) {
                local pool = sett.recruitPool(i)
                if (pool.unitTypeIndex == pool_check.type.index) {
                    if (!(sett.name in ::EUR.gen_pool_info) || !::EUR.gen_pool_info[sett.name]) {
                        ::EUR.gen_pool_info[sett.name] <- {}
                        ::EUR.gen_pool_info[sett.name].set_already <- false
                    }
                    if (::EUR.gen_pool_info[sett.name].set_already == false) {
                        ::EUR.gen_pool_info[sett.name].availablePool <- pool.available
                        ::EUR.gen_pool_info[sett.name].eduIndex <- pool.unitTypeIndex
                        ::EUR.gen_pool_info[sett.name].name <- sett.name
                        ::EUR.gen_pool_info[sett.name].set_already = true
                        ::EUR.gen_pool_reset = true
                    }
                }
            }
        }
    }

    character.swapBodyguard(newBodyguardType, expLvl, weaponLvl, 0)

    character.faction.record.disbandToPools = true
    ::EUR.pause_disband = false
}

::EUR.dorwinionGeneralBGCheck <- function() {
    if (!::EUR.kon_bg_check) {
        if (::EUR.checkCounter("kon_council_choice_accepted")) {
            ::EUR.gen_units_list["denmark"] <- {
                ["T1"] = ["Eregion Lindar Guards", "Eregion Lindar Mariners", "Eregion Lindar Bowmen"],
                ["T2"] = ["Eregion Mithrim Spearmen", "Eregion Mithrim Swordsmen", "Eregion Mithrim Archers"],
                ["T3"] = ["Eregion Barad Bladesmen", "Eregion Barad Marines", "Eregion Barad Archers"],
                ["special"] = ["Mithlond Nobles"],
            }
            ::EUR.gen_units_list["saxons"] <- {
                ["T1"] = ["Eregion Sword Quendi", "Eregion Spear Quendi", "Eregion Bow Quendi"],
                ["T2"] = ["Eregion Mithrim Spearmen", "Eregion Mithrim Swordsmen", "Eregion Mithrim Archers"],
                ["T3"] = ["Eregion Barad Bladesmen", "Eregion Barad Marines", "Eregion Barad Archers"],
                ["special"] = ["Elderinwe Roquen"],
            }
            ::EUR.kon_bg_check = true
        }
    }
    if (!::EUR.dorwinion_bg_check) {
        if (::EUR.checkCounter("dorwinion_elf")) {
            ::EUR.gen_units_list["byzantium"]["T3"][0] = "Moriquendi Sentinels"
            ::EUR.gen_units_list["byzantium"]["special"][0] = "Moriquendi Gladelords"
            ::EUR.dorwinion_bg_check = true
        }
        if (::EUR.checkCounter("dorwinion_men")) {
            ::EUR.gen_units_list["byzantium"]["T3"][0] = "Vintner-Court Paladins"
            ::EUR.gen_units_list["byzantium"]["special"][0] = "Elvellyn Hammerguard"
            ::EUR.dorwinion_bg_check = true
        }
    }
}
