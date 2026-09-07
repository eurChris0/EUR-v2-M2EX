class eurBuildFort {
    layout = {
        boxX = 595, boxY = 400, boxW = 130, boxH = 86,
        boxPad = 6, boxBorder = 2, textGap = 20,
        headingSize = 20, bodySize = 14,
        headingOffsetY = 6, bodyOffsetY = 40, costOffsetY = 64,

        acceptW = 610, acceptH = 310,
        acceptPanelInsetX = -75, acceptPanelInsetY = -50, acceptTextPadX = 16,
        acceptButtonW = 80, acceptButtonH = 50,
        acceptButtonBottomInset = 90, acceptButtonSpreadX = 40,

        headingColour = [0, 0, 0, 255],
        refusedColour = [140, 20, 20, 255],
        boxColour = [255, 255, 255, 128],
        boxBorderColour = [70, 70, 70, 255],
    }

    baseCost  = 7500
    maxForts  = 3
    extraCost = 500

    buttonCanvas    = 0
    acceptScroll    = null
    acceptCanvas    = 0
    yesButton       = 0
    noButton        = 0
    built           = false
    show_fortaccept = false
    fortcost        = 7500

    function ensure() {
        if (this.built) return
        local self = this
        ::UI.pushFont(::fonts.body, false, 12)
        ::UI.pushStyle(::EUR.eurStyles.basic_4)

        this.acceptScroll = ::EUR.scroll.create(this.layout.acceptW, this.layout.acceptH, 0, 0)

        this.acceptCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.acceptCanvas, function() { self.drawAccept() })

        this.yesButton = ::UI.button("Yes", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.yesButton)
        ::UI.buttonClick(this.yesButton, function() { self.construct() })

        this.noButton = ::UI.button("No", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.noButton)
        ::UI.buttonClick(this.noButton, function() {
            self.show_fortaccept = false
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        ::UI.popStyle()
        ::UI.popFont()
        ::UI.setParent(0)

        ::UI.pushStyle(::EUR.eurStyles.fort_button)
        this.buttonCanvas = ::UI.canvas(this.layout.boxW * 3, this.layout.boxH,
                                        this.layout.boxX, this.layout.boxY)
        ::UI.canvasDraw(this.buttonCanvas, function() { self.drawRow() })
        ::UI.popStyle()

        ::UI.setParent(0)
        ::UI.widgetVisible(this.acceptScroll.window, false)
        ::UI.widgetVisible(this.yesButton, false)
        ::UI.widgetVisible(this.noButton, false)
        this.built = true
    }

    function render() {
        this.ensure()
        if (!this.built) return

        local open = this.show_fortaccept && ::EUR.build_forts && ::EUR.in_campaign_map
        ::UI.widgetVisible(this.acceptScroll.window, open)
        if (open) {
            local screen = ::authored.screen()
            ::EUR.scroll.place(this.acceptScroll.window, (screen[0] - this.layout.acceptW) / 2,
                               (screen[1] - this.layout.acceptH) / 2,
                               this.layout.acceptW, this.layout.acceptH)
        }

        local area = this.scrollArea(this.acceptScroll.window)
        if (area != null) {
            local half = (area.width - this.layout.acceptButtonW) / 2
            local btnY = area.y + area.height - this.layout.acceptButtonBottomInset
            ::UI.widgetRect(this.yesButton, area.x + half - this.layout.acceptButtonSpreadX, btnY,
                            this.layout.acceptButtonW, this.layout.acceptButtonH)
            ::UI.widgetRect(this.noButton, area.x + half + this.layout.acceptButtonSpreadX, btnY,
                            this.layout.acceptButtonW, this.layout.acceptButtonH)
        }
        ::UI.widgetVisible(this.yesButton, open && area != null)
        ::UI.widgetVisible(this.noButton, open && area != null)

        if (open) { ::UI.raise(this.acceptScroll.window) }
    }

    function scrollArea(window) {
        local rect = ::authored.rect(::UI.widgetRectGet(window))
        if (rect == null) return null
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) return null
        return { x = rect[0] + margins[0], y = rect[1] + margins[1],
                 width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }
    }

    function subject() {
        if (!::EUR.build_forts || !::EUR.show_buildfort || !::EUR.in_campaign_map) return null
        return ::EUR.temp_fort_char
    }

    function regionForts(char) {
        local region = ::stratMap.region(char.regionId)
        return region == null ? 0 : region.fortCount
    }

    function price(forts) { return this.baseCost * (forts + 1) + this.extraCost }

    function buildable(char) {
        local tile = ::stratMap.tile(char.x, char.y)
        if (tile == null) return false
        return !tile.hasWatchtower && tile.resource == null
    }

    function drawRow() {
        local char = this.subject()
        if (char == null) return
        if (!this.buildable(char)) return
        if (::EUR.fort.img == null) return

        local forts = this.regionForts(char)
        local total = this.price(forts)
        local capped = forts >= this.maxForts
        local afford = ::EUR.eur_player_faction != null && ::EUR.eur_player_faction.money >= total

        local bx = ::authored.hudX(this.layout.boxX), by = ::authored.hudY(this.layout.boxY)
        local bw = ::authored.hudX(this.layout.boxW), bh = ::authored.hudY(this.layout.boxH)
        local pad = ::authored.hudX(this.layout.boxPad), edge = ::authored.hudX(this.layout.boxBorder)

        this.drawBox(bx - pad, by - pad, bw + pad * 2, bh + pad * 2, edge)
        local hit = ::UI.imageButton(::EUR.fort.img, bw, bh, bx, by)

        local line = capped ? "Maximum number of forts reached in this region."
                            : (afford ? "Cost: " + total + " gold."
                                      : "Not enough gold, requires: " + total + " gold.")
        this.drawText(this.layout.boxX + this.layout.boxW + this.layout.boxPad + this.layout.textGap,
                      this.layout.boxY - this.layout.boxPad, line, capped || !afford)

        ::UI.tooltipAt(bx - pad, by - pad, bw + pad * 2, bh + pad * 2)
        ::UI.tooltip(0, "" + forts + " Forts in this region.")

        if (!hit.clicked || capped || !afford || this.show_fortaccept) return

        this.fortcost = total
        this.show_fortaccept = true
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }

    function drawBox(x, y, w, h, edge) {
        local c = this.layout.boxBorderColour, f = this.layout.boxColour
        ::UI.drawRect(x, y, w, h, f[0], f[1], f[2], f[3])
        ::UI.drawRect(x - edge, y - edge, w + edge * 2, edge, c[0], c[1], c[2], c[3])
        ::UI.drawRect(x - edge, y + h, w + edge * 2, edge, c[0], c[1], c[2], c[3])
        ::UI.drawRect(x - edge, y, edge, h, c[0], c[1], c[2], c[3])
        ::UI.drawRect(x + w, y, edge, h, c[0], c[1], c[2], c[3])
    }

    // Game space: the row sits on the game's own scroll art, so the text carries the engine's
    // horizontal stretch on top of the canvas's uniform scale. Authored coords inside the scope.
    function drawText(x, y, line, refused) {
        local self = this
        local head = this.layout.headingColour, cost = refused ? this.layout.refusedColour : head

        ::UI.pushTransform(0, 0, ::authored.hudStretch(), 0, 1.0, function() {
            ::UI.pushFont(::fonts.game.verdana, false, self.layout.headingSize)
            ::UI.pushStyle({ [::UI.Colour.text] = head })
            ::UI.layoutAt(x, y + self.layout.headingOffsetY)
            ::UI.text("Fort")
            ::UI.popStyle()
            ::UI.popFont()

            ::UI.pushFont(::fonts.body, false, self.layout.bodySize)
            ::UI.pushStyle({ [::UI.Colour.text] = head })
            ::UI.layoutAt(x, y + self.layout.bodyOffsetY)
            ::UI.text("Construct a permanent fort.")
            ::UI.popStyle()

            ::UI.pushStyle({ [::UI.Colour.text] = cost })
            ::UI.layoutAt(x, y + self.layout.costOffsetY)
            ::UI.text(line)
            ::UI.popStyle()
            ::UI.popFont()
        })
    }

    function drawAccept() {
        if (!this.show_fortaccept) return
        local area = this.scrollArea(this.acceptScroll.window)
        if (area == null) return

        local panelX = area.x + this.layout.acceptPanelInsetX
        local panelW = area.width - this.layout.acceptPanelInsetX * 2
        local panelY = area.y + this.layout.acceptPanelInsetY
        local panelH = area.height - this.layout.acceptPanelInsetY * 2
        ::EUR.scroll.drawSet("panel", panelX, panelY, panelW, panelH)

        this.acceptText(panelX, panelY, panelW,
                        area.y + area.height - this.layout.acceptButtonBottomInset,
                        "Construct Fort for " + this.fortcost + " gold.")
    }

    function acceptText(panelX, panelY, panelW, buttonY, message) {
        ::UI.pushFont(::fonts.body, false, 0)
        local wrapW = panelW - this.layout.acceptTextPadX * 2
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.headingColour,
                         [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = wrapW })
        local textH = ::UI.textSize(message, 0, 0, wrapW)[1]
        ::UI.layoutAt(panelX + this.layout.acceptTextPadX, panelY + (buttonY - panelY - textH) / 2)
        ::UI.textWrapped(message, wrapW)
        ::UI.popStyle()
        ::UI.popFont()
    }

    function construct() {
        this.show_fortaccept = false
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")

        local scroll = ::ui.element("field_construction_scroll")
        if (scroll != null) { scroll.close() }

        local char = this.subject()
        if (char == null) return
        if (char.createFort() == null) return

        // The army route charges the culture's own fort cost, which is the extraCost half of the
        // price on screen - so the script only takes the rest.
        ::game.runConsoleCommand("add_money", "-" + (this.fortcost - this.extraCost))
    }
}

::EUR.eurBuildFort <- eurBuildFort()
::UI.onFrame(function() { ::EUR.eurBuildFort.render() })
