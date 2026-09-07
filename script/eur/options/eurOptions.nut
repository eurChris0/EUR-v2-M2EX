::EUR.EUR_OPTION_TABS <- []

class eurOptions {
    layout = {
        windowX = 0, windowY = 0,
        windowW = 0, windowH = 0,
        windowMarginX = 0, windowMarginY = 0,
        windowCreateW = 600, windowCreateH = 400,

        panelInsetX = 60, panelInsetY = 80,
        panelOffsetX = 0, panelOffsetY = 0,
        panelWidthDelta = 0, panelHeightDelta = 0,

        panelPadX = 20, panelPadY = 20,
        tabOffsetX = 12, tabOffsetY = 0,
        tabWidthDelta = 0, tabHeightDelta = 0,
        tabContentPadX = 25, tabContentPadY = 10,

        closeButtonW = 156, closeButtonH = 48, closeButtonBelowPanel = -4,
        acceptW = 610, acceptH = 310,
        acceptPanelInsetX = -75, acceptPanelInsetY = -50,
        acceptPanelOffsetX = 0, acceptPanelOffsetY = 0,
        acceptPanelWidthDelta = 0, acceptPanelHeightDelta = 0, acceptTextPadX = 16,
        acceptButtonW = 80, acceptButtonH = 50,
        acceptButtonBottomInset = 90, acceptButtonSpreadX = 40,
        openerX = 1170, openerY = 90, openerSize = 50,
        headingOffsetY = -54, headingFontSize = 0,
        headingColour = [0, 0, 0, 255],
        bodyFontSize = 12,
        controlLabelSlack = 8,
    }
    headingFontId = 0
    bodyFontId = 0
    typeStyles = "options_types"
    controlStyles = "options_control"
    types = null
    controls = null
    scroll = null
    tabbar = 0
    pages  = null
    rows   = null
    buttonCanvas = 0
    contentBgCanvas = 0
    tabRect = null
    acceptScroll = null
    acceptCanvas = 0
    optionsRaised = false
    shownLast = false
    acceptRaised = false
    closeBtn = 0
    yesBtn = 0
    noBtn = 0
    constructor() {
        this.types = ::EUR.eurStyles[this.typeStyles]
        this.controls = ::EUR.eurStyles[this.controlStyles]
    }

    function ensure() {
        if (this.scroll != null) return
        local self = this
        this.pages = []
        this.rows = []

        ::UI.pushFont(::fonts.body, false, this.layout.bodyFontSize)
        ::UI.pushStyle(::EUR.eurStyles.options_1)

        this.scroll = ::EUR.scroll.create(this.layout.windowCreateW, this.layout.windowCreateH,
                                          this.layout.windowX, this.layout.windowY)

        this.contentBgCanvas = ::UI.canvas(0, 0)
        ::UI.placeAbsolute(this.contentBgCanvas)
        ::UI.canvasDraw(this.contentBgCanvas, function() { self.drawContentBackground(); self.optionsHeading() })

        local rows = ::UI.fonts()
        if (rows != null) {
            foreach (f in rows) {
                if (f.name == ::fonts.game.verdana) { this.headingFontId = f.id }
                if (f.name == ::fonts.game.verdanaSml) { this.bodyFontId = f.id }
            }
        }

        local titles = []
        this.tabbar = ::UI.tabs()
        ::UI.placeAbsolute(this.tabbar)
        foreach (tab in ::EUR.EUR_OPTION_TABS) {
            if (("showFn" in tab) && !tab.showFn()) { continue }
            if (("showIf" in tab) && !::EUR[tab.showIf]) { continue }
            titles.append(tab.title)
            local page = ::UI.panel()
            this.stylePage(page)
            foreach (sec in tab.sections) { this.buildSection(page, sec) }
            ::UI.addChild(this.tabbar, page)
            this.pages.append({ page = page, showIf = ("showIf" in tab) ? tab.showIf : null })
        }
        ::UI.tabsTitles(this.tabbar, titles)
        ::UI.setWidgetStyle(this.tabbar, ::UI.Surface.tabBar, [0, 0, 0, 0])

        // This window is the one on options_1, and its pages and tab bar are deliberately invisible -
        // a palette repaint walks every widget under the root, so those have to be put back after.
        ::EUR.registerStyled(this.scroll.window, "options_1", function() {
            ::EUR.scroll.windowChrome(self.scroll.window)
            self.styleTabs()
        })

        ::UI.setParent(this.scroll.window)
        this.closeBtn = ::UI.button("Close me", this.layout.closeButtonW, this.layout.closeButtonH)
        ::UI.placeAbsolute(this.closeBtn)
        ::UI.buttonClick(this.closeBtn, function() {
            if (::EUR.options_first_run) {
                ::EUR.show_options_accept = true
                ::EUR.saveOptions()
            } else {
                ::EUR.show_options_window = false
                ::EUR.setGameOptions()
            }
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        ::UI.popStyle()
        ::UI.popFont()

        ::EUR.scroll.sealOnTop(this.scroll)
        ::UI.addChild(this.scroll.window, this.closeBtn)

        ::UI.setParent(0)
        this.buttonCanvas = ::UI.canvas(this.layout.openerSize, this.layout.openerSize,
                                        this.layout.openerX, this.layout.openerY)
        ::UI.setWidgetStyle(this.buttonCanvas, ::UI.Cap.autoScaleDraw, 1)   // built outside the sheet push
        ::UI.setWidgetStyle(this.buttonCanvas, ::UI.Cap.autoScalePos, 1)
        ::UI.canvasDraw(this.buttonCanvas, function() { self.optionsButton() })

        ::UI.pushFont(::fonts.body, false, this.layout.bodyFontSize)
        ::UI.pushStyle(::EUR.eurStyles.basic_4)
        this.acceptScroll = ::EUR.scroll.create(this.layout.acceptW, this.layout.acceptH, 0, 0)
        this.acceptCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.acceptCanvas, function() { self.optionsAccept() })
        ::EUR.scroll.sealOnTop(this.acceptScroll)

        this.yesBtn = ::UI.button("Yes", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.yesBtn)
        ::UI.buttonClick(this.yesBtn, function() {
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            ::EUR.correctCoords()
            ::EUR.show_options_accept = false
            ::EUR.show_options_window = false
            ::EUR.options_first_run = false
            ::EUR.setBGSize(::EUR.eur_player_faction, null, null)
            ::EUR.genEDUcheck()
            ::EUR.setGameOptions()
            if (::EUR.game_options.supplies) { ::game.campaign().setEventCounter("supplies_eur", 1) }
            if (::EUR.game_options.global_morale_boost) { ::EUR.globalMoraleIncrease(::EUR.game_options.morale_value) }
            ::EUR.EDU_MODIFIERS.updateDescriptions()
            local camdifficulty = ::game.options.campaignDifficulty()
            if (camdifficulty == 0) {
                ::EUR.eur_player_faction.kingsPurse = ::EUR.eur_player_faction.kingsPurse + 750
                ::game.runConsoleCommand("add_money", "-3000")
                ::game.campaign().setEventCounter("game_easy", 1)
            } else if (camdifficulty == 1) {
                ::EUR.eur_player_faction.kingsPurse = ::EUR.eur_player_faction.kingsPurse + 500
                ::game.runConsoleCommand("add_money", "-1500")
                ::game.campaign().setEventCounter("game_medium", 1)
            } else if (camdifficulty == 2) {
                ::EUR.eur_player_faction.kingsPurse = ::EUR.eur_player_faction.kingsPurse + 250
                ::game.campaign().setEventCounter("game_hard", 1)
            } else {
                ::game.campaign().setEventCounter("game_very_hard", 1)
            }
            ::game.setWatchtowerRange(::EUR.watchtower_range)
            if (::EUR.eur_player_faction.name == "russia") { ::EUR.repositionAA() }
            if (::EUR.game_options.options_usemods) { ::EUR.defaultEDUOffset() } // possible lag
            if (::EUR.options_legendary) {
                ::EUR.editTrait()
                ::EUR.orderOffset()
                ::EUR.defaultEDUOffset_leg()
                ::EUR.legendaryGarrisons()
                ::EUR.player_start_threshold = 8
            }
            if (!::EUR.options_extrabu) { ::EUR.economyModifiers() }
            else { ::game.campaign().setEventCounter("options_extrabu", 1) }
            if (::EUR.game_options.siege_messages) { ::game.campaign().setEventCounter("sieged_messages", 1) }
            else { ::game.campaign().setEventCounter("sieged_messages", 0) }
            if (::EUR.misc_options.eregion_start) { ::EUR.show_eregion_choice = true; ::EUR.clearMSG() }
            if (::EUR.misc_options.kon_start) { ::EUR.show_kon_choice = true }
            if (::EUR.eur_player_faction.name == "egypt") {
                ::EUR.eurEregion.spawnEregionHorde(false)
                ::game.runConsoleCommand("kill_faction", "egypt")
            }
        })

        this.noBtn = ::UI.button("No", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.noBtn)
        ::UI.buttonClick(this.noBtn, function() {
            ::EUR.show_options_window = true
            ::EUR.show_options_accept = false
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        ::UI.popStyle()
        ::UI.popFont()

        ::UI.setParent(0)
        ::EUR.eurOptionsHandles <- "scrollWindow=" + this.scroll.window + " tabbar=" + this.tabbar
            + " acceptWindow=" + this.acceptScroll.window + " buttonCanvas=" + this.buttonCanvas
            + " closeBtn=" + this.closeBtn + " yesBtn=" + this.yesBtn + " noBtn=" + this.noBtn
            + " pages=" + this.pages.len()
        ::UI.widgetVisible(this.scroll.window, false)
        ::UI.widgetVisible(this.acceptScroll.window, false)
        if ("gamePanelWindow" in ::UI) { ::UI.gamePanelWindow(this.scroll.window, 2) }
    }

    // The page panel draws nothing itself: the parchment behind it is the scroll's own 9-slice, and
    // the tab bar is invisible so the tabs sit straight on it.
    function stylePage(page) {
        ::UI.setWidgetStyle(page, ::UI.Surface.panel, [0, 0, 0, 0])
        ::UI.setWidgetStyle(page, ::UI.Surface.panelAlt, [0, 0, 0, 0])
        ::UI.setWidgetStyle(page, ::UI.Colour.border, [0, 0, 0, 0])
        ::UI.setWidgetStyle(page, ::UI.Metric.borderFrame, 0)
        ::UI.setWidgetStyle(page, ::UI.Metric.windowPadX, this.layout.tabContentPadX)
        ::UI.setWidgetStyle(page, ::UI.Metric.windowPadY, this.layout.tabContentPadY)
    }

    function styleTabs() {
        if (this.pages == null) { return }
        foreach (entry in this.pages) { this.stylePage(entry.page) }
        ::UI.setWidgetStyle(this.tabbar, ::UI.Surface.tabBar, [0, 0, 0, 0])
    }

    function scrollArea(window) {
        local rect = ::authored.rect(::UI.widgetRectGet(window))
        if (rect == null) return null
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) return null
        return { x = rect[0] + margins[0], y = rect[1] + margins[1],
                 width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }
    }

    function drawContentBackground() {
        if (this.tabRect == null) return

        // tabRect comes from UI.contentRect, which answers PHYSICAL px.
        ::EUR.scroll.drawSet("panel",
                             this.tabRect[0], this.tabRect[1],
                             this.tabRect[2], this.tabRect[3])
    }

    function optionsHeading() {
        local area = this.scrollArea(this.scroll.window)
        if (area == null) return

        ::UI.layoutAt(area.x, area.y + this.layout.headingOffsetY)
        ::UI.pushFont(::fonts.body, false, this.layout.headingFontSize)
        ::UI.pushStyle({ [::UI.Metric.alignX] = 1,
                         [::UI.Metric.elideWidth] = area.width, [::UI.Colour.text] = this.layout.headingColour })
        ::UI.text(::EUR.options_first_run ? "Welcome to EUR" : "Options")
        ::UI.popStyle()
        ::UI.popFont()
    }

    function optionsAccept() {
        local area = this.scrollArea(this.acceptScroll.window)
        if (area == null) return

        // Both insets are measured from the content AREA (the window minus the scroll set's
        // 9-slice margins), so an equal value on each axis puts the panel edge the same
        // distance inside on both. Negative grows it back out over the frame.
        local panelX = area.x + this.layout.acceptPanelInsetX + this.layout.acceptPanelOffsetX
        local panelW = area.width - this.layout.acceptPanelInsetX * 2 + this.layout.acceptPanelWidthDelta
        local panelY = area.y + this.layout.acceptPanelInsetY + this.layout.acceptPanelOffsetY
        local panelH = area.height - this.layout.acceptPanelInsetY * 2 + this.layout.acceptPanelHeightDelta
        ::EUR.scroll.drawSet("panel", panelX, panelY,
                             panelW, panelH)

        this.acceptText(panelX, panelY, panelW,
                        area.y + area.height - this.layout.acceptButtonBottomInset,
                        "Accept and start campaign?")
    }

    // Heading face, WRAPPED rather than elided, sat at the midpoint between the panel top and the
    // buttons instead of pinned near the top. textSize measures inside the pushed font scope, and
    // with a wrap width it answers the wrapped height, so a two-line message still centres.
    function acceptText(panelX, panelY, panelW, buttonY, message) {
        ::UI.pushFont(::fonts.body, false, this.layout.headingFontSize)
        local wrapW = panelW - this.layout.acceptTextPadX * 2
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.headingColour,
                         [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = wrapW })
        local textH = ::UI.textSize(message, 0, 0, wrapW)[1]
        ::UI.layoutAt(panelX + this.layout.acceptTextPadX, panelY + (buttonY - panelY - textH) / 2)
        ::UI.textWrapped(message, wrapW)
        ::UI.popStyle()
        ::UI.popFont()
    }

    function optionsButton() {
        if (!::EUR.in_campaign_map || !::EUR.show_options_button || ::EUR.icon_options == null) return
        // Sits ON the game HUD, so it takes the game's factor rather than our layout's.
        local x = ::authored.hudX(this.layout.openerX)
        local y = ::authored.hudY(this.layout.openerY)
        local size = ::authored.hudX(this.layout.openerSize)
        if (::UI.imageButton(::EUR.icon_options.img, size, size, x, y).clicked) {
            local opening = !::EUR.show_options_window
            ::EUR.show_options_window = opening
            ::game.runScriptCommand("play_sound_event", opening ? "STRAT_SCROLL_OPENS" : "STRAT_SCROLL_CLOSES")
        }
        ::UI.tooltipAt(x, y, size, size)
        ::UI.tooltip(0, "EUR Options")
    }

    function sizeControl(w, controlW, text) {
        if (controlW <= 0) { return }
        local extra = 0
        if (text != null && text != "") {
            extra = ::UI.textSize(text)[0] + this.layout.controlLabelSlack
            local inner = ::UI.getStyle(::UI.Metric.gapInner)
            if (typeof(inner) == "integer" && inner > 0) { extra += inner }
        }
        ::UI.setWidgetStyle(w, ::UI.Metric.maxW, controlW + extra)
    }

    function buildSection(parent, defs) {
        foreach (o in defs) {
            local w = null
            local kind = null
            local text = null

            // Rows are stamped at CREATION and survive the addChild below, and the page is a flow
            // panel, so one call before the widget exists is the whole of same-line support.
            if ("sameLine" in o) { ::UI.sameLine() }

            // A LAYOUT group OWNS its members and takes ONE box in the page flow, so a second group
            // marked sameLine sits BESIDE the first - the two-pane editors. Members auto-parent into
            // the open group, which is why the recursive call passes a null parent.
            if ("group" in o) {
                local self = this
                local body = o.group
                local box = ::UI.beginGroup([::UI.GroupFlag.layout], function() {
                    self.buildSection(null, body)
                    if ("w" in o) { ::UI.spacer(o.w, 1) }
                })
                if (parent != null) { ::UI.addChild(parent, box) }
                o.handle <- box
                this.rows.append({ w = box,
                                   showIf = ("showIf" in o) ? o.showIf : null,
                                   showFn = ("showFn" in o) ? o.showFn : null })
                continue
            }

            // An expander is FLAT, like ImGui's CollapsingHeader: the header is an ordinary row and
            // its body entries stay siblings, hidden by the visibility registry below. Nesting them
            // INSIDE a Collapse would break same-line rows, which Collapse::measure never reads.
            if ("expand" in o) {
                local header = ::UI.collapse(o.expand)
                ::UI.collapseOpen(header, false)
                if (this.bodyFontId != 0) { ::UI.setWidgetStyle(header, ::UI.Font.heading, this.bodyFontId) }
                ::UI.setWidgetStyle(header, ::UI.Metric.fontSize, this.layout.bodyFontSize)
                if ("tip" in o) { ::UI.tooltip(header, o.tip) }
                if (parent != null) { ::UI.addChild(parent, header) }
                o.handle <- header
                this.rows.append({ w = header,
                                   showIf = ("showIf" in o) ? o.showIf : null,
                                   showFn = ("showFn" in o) ? o.showFn : null })
                local shown = function() { return ::UI.collapseOpenGet(o.handle) }
                foreach (child in o.body) {
                    if ("showFn" in child) {
                        local own = child.showFn
                        child.showFn = function() { return ::UI.collapseOpenGet(o.handle) && own() }
                    } else {
                        child.showFn <- shown
                    }
                }
                this.buildSection(parent, o.body)
                continue
            }

            if ("check" in o)        { w = ::UI.checkbox(o.check); kind = "check"; text = o.check }
            else if ("toggle" in o)  { w = ::UI.toggle(o.toggle);  kind = "check"; text = o.toggle }
            else if ("stepper" in o) {
                w = ::UI.stepper(o.stepper); kind = "stepper"; text = o.stepper
                ::UI.stepperRange(w, o.min, o.max)
                ::UI.stepperStep(w, ("step" in o) ? o.step : 1)
            }
            else if ("slider" in o)  {
                w = ::UI.slider(o.slider, o.min, o.max, ("step" in o) ? o.step : 0); kind = "slider"; text = o.slider
                if ("fmt" in o) { ::UI.sliderFormat(w, o.fmt) }
            }
            else if ("select" in o)  { w = ::UI.select(o.select); ::UI.selectOptions(w, o.options); kind = "select"; text = o.select }
            else if ("button" in o)  { w = ::UI.button(o.button); if ("onClick" in o) ::UI.buttonClick(w, o.onClick); kind = "button" }
            else if ("label" in o)   {
                w = ::UI.labelWrapped(o.label)
                if (this.headingFontId != 0) { ::UI.setWidgetStyle(w, ::UI.Font.body, this.headingFontId) }
                ::UI.setWidgetStyle(w, ::UI.Metric.fontSize, this.layout.headingFontSize)
            }
            else if ("text" in o)    { w = ::UI.label(o.text) }
            else if ("desc" in o)    { w = ::UI.bullet(o.desc) }
            else if ("sep" in o)     { w = ::UI.separator(); kind = "sep" }
            else if ("draw" in o)    { w = ::UI.canvas(("w" in o) ? o.w : 0, ("h" in o) ? o.h : 0); ::UI.canvasDraw(w, o.draw); o.canvas <- w }
            if (w == null) continue
            if (kind != null && (kind in this.types)) { ::UI.setWidgetStyle(w, this.types[kind]) }
            if (kind != null && (kind in this.controls)) { this.sizeControl(w, this.controls[kind], text) }

            if ("bind" in o) {
                local c = (o.bind.len() == 1) ? ::EUR : ::EUR[o.bind[0]]
                ::UI.bind(w, c, o.bind[o.bind.len() - 1])
            } else if ("get" in o) {
                local setter = o.set
                if (kind == "slider")       { ::UI.sliderValue(w, o.get());  ::UI.sliderChange(w, function(v) { setter(v) }) }
                else if (kind == "stepper") { ::UI.stepperValue(w, o.get()); ::UI.stepperChange(w, function(v) { setter(v) }) }
                else if (kind == "check")   { ::UI.checkboxValue(w, o.get() ? 1 : 0); ::UI.checkboxChange(w, function(v) { setter(v) }) }
            }
            if (kind == "check" && !("onChange" in o)) {
                ::UI.checkboxChange(w, function(v) { ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN") })
            }
            if ("tip" in o) { ::UI.tooltip(w, o.tip) }
            if ("onChange" in o) {
                local cb = o.onChange
                if (kind == "check")        { ::UI.checkboxChange(w, cb) }
                else if (kind == "stepper") { ::UI.stepperChange(w, cb) }
                else if (kind == "slider")  { ::UI.sliderChange(w, cb) }
                else if (kind == "select")  { ::UI.selectChange(w, cb) }
            }
            if (parent != null) { ::UI.addChild(parent, w) }   // null = inside an open group, which auto-parents
            o.handle <- w
            this.rows.append({ w = w,
                               showIf = ("showIf" in o) ? o.showIf : null,
                               showFn = ("showFn" in o) ? o.showFn : null })
        }
    }

    function render() {
        this.ensure()

        local showAccept = ::EUR.show_options_accept && ::EUR.in_campaign_map
        ::UI.widgetVisible(this.acceptScroll.window, showAccept)
        if (showAccept) {
            local screen = ::authored.screen()
            ::EUR.scroll.place(this.acceptScroll.window, (screen[0] - this.layout.acceptW) / 2,
                            (screen[1] - this.layout.acceptH) / 2, this.layout.acceptW, this.layout.acceptH)
        }
        this.acceptRaised = showAccept

        local accept = this.scrollArea(this.acceptScroll.window)
        if (accept != null) {
            local half = (accept.width - this.layout.acceptButtonW) / 2
            local btnY = accept.y + accept.height - this.layout.acceptButtonBottomInset
            ::UI.widgetRect(this.yesBtn, accept.x + half - this.layout.acceptButtonSpreadX, btnY,
                            this.layout.acceptButtonW, this.layout.acceptButtonH)
            ::UI.widgetRect(this.noBtn, accept.x + half + this.layout.acceptButtonSpreadX, btnY,
                            this.layout.acceptButtonW, this.layout.acceptButtonH)
        }
        ::UI.widgetVisible(this.yesBtn, accept != null && ::EUR.show_options_accept && ::EUR.in_campaign_map)
        ::UI.widgetVisible(this.noBtn, accept != null && ::EUR.show_options_accept && ::EUR.in_campaign_map)

        local showOptions = ::EUR.show_options_window && ::EUR.in_campaign_map
        showOptions = ::EUR.panelFollow(this.scroll.window, ::EUR, "show_options_window",
                                        showOptions, this.shownLast)
        this.shownLast = showOptions
        if (!showOptions) {
            ::UI.widgetVisible(this.closeBtn, false)
            this.tabRect = null
            this.optionsRaised = false
            return
        }

        local screen = ::authored.screen()
        local windowW = (this.layout.windowW > 0) ? this.layout.windowW : screen[0] - this.layout.windowMarginX
        local windowH = (this.layout.windowH > 0) ? this.layout.windowH : screen[1] - this.layout.windowMarginY
        ::EUR.scroll.place(this.scroll.window, this.layout.windowX, this.layout.windowY, windowW, windowH)

        ::UI.widgetVisible(this.closeBtn, true)

        foreach (row in this.rows) {
            if (row.showFn != null) { ::UI.widgetVisible(row.w, row.showFn() ? true : false) }
            else if (row.showIf != null) { ::UI.widgetVisible(row.w, ::EUR[row.showIf] ? true : false) }
        }

        local body = ::authored.rect(::UI.contentRect(this.scroll.window))
        if (body != null) {
            local panelX = body[0] + this.layout.panelInsetX + this.layout.panelOffsetX
            local panelY = body[1] + this.layout.panelInsetY + this.layout.panelOffsetY
            local panelW = body[2] - this.layout.panelInsetX * 2 + this.layout.panelWidthDelta
            local panelH = body[3] - this.layout.panelInsetY * 2 + this.layout.panelHeightDelta
            this.tabRect = [panelX, panelY, panelW, panelH]
            local innerX = panelX + this.layout.panelPadX
            local innerY = panelY + this.layout.panelPadY
            local innerW = panelW - this.layout.panelPadX * 2
            local innerH = panelH - this.layout.panelPadY * 2
            ::UI.widgetRect(this.tabbar, innerX + this.layout.tabOffsetX, innerY + this.layout.tabOffsetY,
                            innerW + this.layout.tabWidthDelta, innerH + this.layout.tabHeightDelta)
            ::UI.widgetRect(this.closeBtn,
                            panelX + (panelW - this.layout.closeButtonW) / 2,
                            panelY + panelH + this.layout.closeButtonBelowPanel,
                            this.layout.closeButtonW, this.layout.closeButtonH)
        }
        if (!this.optionsRaised) { ::UI.raise(this.scroll.window) }
        this.optionsRaised = true

        if (showAccept) { ::UI.raise(this.acceptScroll.window) }
    }
}

local eurOptionsWindow = eurOptions()
::UI.onFrame(function() { eurOptionsWindow.render() })

::EUR.eurOptionsWindow <- eurOptionsWindow
