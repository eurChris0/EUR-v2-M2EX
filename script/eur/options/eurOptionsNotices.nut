class eurOptionsNotices {
    layout = {
        noticeW = 610, noticeH = 310,
        panelInsetX = -75, panelInsetY = -50,
        panelOffsetX = 0, panelOffsetY = 0,
        panelWidthDelta = 0, panelHeightDelta = 0, textPadX = 16,
        buttonW = 80, buttonH = 50,
        buttonBottomInset = 90, buttonSpreadX = 40,
        bodyFontSize = 12, headingFontSize = 0,
        cardGapY = 8, cardW = 64, cardH = 64,
        textColour = [0, 0, 0, 255],
    }

    legScroll   = null
    legCanvas   = 0
    legYesBtn   = 0
    legNoBtn    = 0
    legRaised   = false

    genScroll   = null
    genCanvas   = 0
    genOkBtn    = 0
    genRaised   = false
    genCard     = null

    function ensure() {
        if (this.legScroll != null) return
        local self = this

        ::UI.pushFont(::fonts.game.verdanaSml, false, this.layout.bodyFontSize)
        ::UI.pushStyle(::EUR.eurStyles.basic_4)

        this.legScroll = ::EUR.scroll.create(this.layout.noticeW, this.layout.noticeH, 0, 0)
        this.legCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.legCanvas, function() { self.legendaryChoice() })

        this.legYesBtn = ::UI.button("Yes", this.layout.buttonW, this.layout.buttonH)
        ::UI.placeAbsolute(this.legYesBtn)
        ::UI.buttonClick(this.legYesBtn, function() {
            ::EUR.legendaryToggle(true)
            ::EUR.show_leg_notif = false
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        this.legNoBtn = ::UI.button("No", this.layout.buttonW, this.layout.buttonH)
        ::UI.placeAbsolute(this.legNoBtn)
        ::UI.buttonClick(this.legNoBtn, function() {
            ::EUR.show_leg_notif = false
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        this.genScroll = ::EUR.scroll.create(this.layout.noticeW, this.layout.noticeH, 0, 0)
        this.genCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.genCanvas, function() { self.generalEnabled() })

        this.genOkBtn = ::UI.button("Ok", this.layout.buttonW, this.layout.buttonH)
        ::UI.placeAbsolute(this.genOkBtn)
        ::UI.buttonClick(this.genOkBtn, function() {
            ::EUR.show_genenabled = false
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        ::UI.popStyle()
        ::UI.popFont()

        ::EUR.scroll.sealOnTop(this.legScroll)
        ::EUR.scroll.sealOnTop(this.genScroll)

        ::UI.setParent(0)
        ::UI.widgetVisible(this.legScroll.window, false)
        ::UI.widgetVisible(this.genScroll.window, false)
        ::UI.widgetVisible(this.legYesBtn, false)
        ::UI.widgetVisible(this.legNoBtn, false)
        ::UI.widgetVisible(this.genOkBtn, false)
    }

    function noticeArea(window) {
        local rect = ::UI.widgetRectGet(window)
        if (rect == null) return null
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) return null
        return { x = rect[0] + margins[0], y = rect[1] + margins[1],
                 width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }
    }

    function bodyguardCard() {
        if (this.genCard != null) return this.genCard
        local faction = (::EUR.eur_player_faction != null) ? ::EUR.eur_player_faction.name : null
        if (faction == null || !(faction in ::EUR.gen_units_list)) return null
        local tier = ::EUR.gen_units_list[faction]
        if (!("T1" in tier) || !(1 in tier["T1"])) return null
        local unitType = ::units.get(tier["T1"][1])
        if (unitType == null) return null
        this.genCard = ::UI.loadTexture(unitType.cardPath(faction))
        return this.genCard
    }

    // The inner panel the accept windows draw, 90% of the notice, plus where its buttons sit - the
    // text is centred between the two rather than pinned near the top.
    function noticePanel(area) {
        // Both insets are measured from the content AREA (the window minus the scroll set's
        // 9-slice margins), so an equal value on each axis puts the panel edge the same
        // distance inside on both. Negative grows it back out over the frame.
        local panelX = area.x + this.layout.panelInsetX + this.layout.panelOffsetX
        local panelW = area.width - this.layout.panelInsetX * 2 + this.layout.panelWidthDelta
        local panelY = area.y + this.layout.panelInsetY + this.layout.panelOffsetY
        local panelH = area.height - this.layout.panelInsetY * 2 + this.layout.panelHeightDelta
        ::EUR.scroll.drawSet("panel", panelX / ::virtualScale.x, panelY / ::virtualScale.y,
                             panelW / ::virtualScale.x, panelH / ::virtualScale.y)
        return { x = panelX, y = panelY, width = panelW, height = panelH,
                 buttonY = area.y + area.height - this.layout.buttonBottomInset }
    }

    // Heading face, WRAPPED rather than elided. blockExtraH lets a notice that also draws something
    // under the text centre the WHOLE block; returns the y the text ended at.
    function noticeText(panel, message, blockExtraH) {
        ::UI.pushFont(::fonts.game.verdana, false, this.layout.headingFontSize)
        local wrapW = panel.width - this.layout.textPadX * 2
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour,
                         [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = wrapW })
        local textH = ::UI.textSize(message, 0, 0, wrapW)[1]
        local top = panel.y + (panel.buttonY - panel.y - textH - blockExtraH) / 2
        ::UI.layoutAt(panel.x + this.layout.textPadX, top)
        ::UI.textWrapped(message, wrapW)
        ::UI.popStyle()
        ::UI.popFont()
        return top + textH
    }

    function legendaryChoice() {
        if (!::EUR.in_campaign_map) return
        local area = this.noticeArea(this.legScroll.window)
        if (area == null) return
        this.noticeText(this.noticePanel(area), "Enable Extra Difficulty Options?", 0)
    }

    function generalEnabled() {
        if (!::EUR.in_campaign_map) return
        local area = this.noticeArea(this.genScroll.window)
        if (area == null) return

        local panel = this.noticePanel(area)
        local card = this.bodyguardCard()
        local haveCard = card != null && card.img != 0
        local extra = haveCard ? (this.layout.cardGapY + this.layout.cardH) : 0
        local textBottom = this.noticeText(panel,
            "General Upgrades are enabled, any general using the generic faction bodyguard will be swapped for a T1 or T2 unit from the upgrade list, you may change this setting in the Upgrades tab.",
            extra)
        if (haveCard) {
            ::UI.image(card.img, this.layout.cardW, this.layout.cardH,
                       panel.x + (panel.width - this.layout.cardW) / 2, textBottom + this.layout.cardGapY)
        }
    }

    function placeNotice(scroll, buttons) {
        local screen = ::UI.screenSize()
        ::UI.widgetRect(scroll.window, (screen[0] - this.layout.noticeW) / 2,
                        (screen[1] - this.layout.noticeH) / 2, this.layout.noticeW, this.layout.noticeH)

        local area = this.noticeArea(scroll.window)
        if (area == null) return
        local half = (area.width - this.layout.buttonW) / 2
        local btnY = area.y + area.height - this.layout.buttonBottomInset
        local spread = (buttons.len() == 1) ? 0 : this.layout.buttonSpreadX
        foreach (i, btn in buttons) {
            local offset = (buttons.len() == 1) ? 0 : ((i == 0) ? -spread : spread)
            ::UI.widgetRect(btn, area.x + half + offset, btnY, this.layout.buttonW, this.layout.buttonH)
        }
    }

    function render() {
        this.ensure()

        local showLeg = ::EUR.show_leg_notif && ::EUR.in_campaign_map
        ::UI.widgetVisible(this.legScroll.window, showLeg)
        ::UI.widgetVisible(this.legYesBtn, showLeg)
        ::UI.widgetVisible(this.legNoBtn, showLeg)
        if (showLeg) {
            this.placeNotice(this.legScroll, [this.legYesBtn, this.legNoBtn])
            if (!this.legRaised) { ::UI.raise(this.legScroll.window) }
        }
        this.legRaised = showLeg

        local showGen = ::EUR.show_genenabled && ::EUR.in_campaign_map && !showLeg
        ::UI.widgetVisible(this.genScroll.window, showGen)
        ::UI.widgetVisible(this.genOkBtn, showGen)
        if (showGen) {
            this.placeNotice(this.genScroll, [this.genOkBtn])
            if (!this.genRaised) { ::UI.raise(this.genScroll.window) }
        }
        this.genRaised = showGen
    }
}

::EUR.eurOptionsNotices <- eurOptionsNotices()
::UI.onFrame(function() { ::EUR.eurOptionsNotices.render() })
