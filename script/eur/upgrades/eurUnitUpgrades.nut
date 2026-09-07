
::EUR.temp_unit_choice <- 0
::EUR.upgrade_message <- ""
::EUR.unit_cost <- 0
::EUR.temp_upgrade_unit <- null

::EUR.unit_names <- {}

::EUR.alias_text_set <- false
::EUR.alias_text <- ""

::EUR.upgradeName <- ""
::EUR.old_unit_army <- null
::EUR.old_unit_exp <- 0
::EUR.old_unit_sol <- 0
::EUR.old_unit_solmax <- 0

::EUR.old_unit_edu <- ""
::EUR.old_unit_weapon <- 0

class unitUpgrades {
    layout = {
        windowX = 0, windowY = 0, windowW = 960, windowH = 835,
        bgInsetX = -55, bgInsetY = 25,
        bgOffsetX = 0, bgOffsetY = -10,
        bgWidthDelta = 0, bgHeightDelta = 64,
        headingOffsetY = -40, headingFontSize = 0, bodyFontSize = 12,
        nameY = 0, nameFontSize = 16,
        contentInsetX = -25, contentTopY = 40,
        aliasInputW = 200, aliasInputH = 20,
        updateButtonGapX = 8, updateButtonH = 20,
        aliasRowH = 26, experienceRowH = 20,
        cardW = ::EUR.img_x, cardH = ::EUR.img_y, cardGapX = 2,
        textColour = [0, 0, 0, 255], messageColour = [255, 0, 0, 255],
        messageOffsetY = 540, messagePadX = 20,
        disabledCardTint = [255, 255, 255, 110],
        currentCardGapY = 6, upgradesLabelRowH = 20,
        previewOffsetX = 400, previewOffsetY = 0, previewPathRowOffsetY = 0,
        costOffsetY = 540, coinIconW = 20, coinIconH = 20,
        costTextOffsetX = 24, costCardOffsetY = 24,
        cardLiftHover = 51, cardLiftHeld = 77,
        acceptW = 610, acceptH = 310,
        acceptBgInsetX = -75, acceptBgInsetY = -50,
        acceptBgOffsetX = 0, acceptBgOffsetY = 0,
        acceptBgWidthDelta = 0, acceptBgHeightDelta = 0, acceptTextPadX = 16,
        acceptButtonW = 80, acceptButtonH = 50,
        acceptButtonGapX = 40, acceptButtonBottomInset = 90,
    }

    upgradeScroll = null
    upgradeCanvas = 0
    acceptScroll  = null
    acceptCanvas  = 0
    aliasInput    = 0
    aliasFontSet  = false
    updateButton  = 0
    ugYesBtn      = 0
    ugNoBtn       = 0
    cardCache     = null
    upgradeRaised = false
    shownLast     = false
    acceptRaised  = false

    function ensure() {
        if (this.upgradeScroll != null) return
        local self = this
        this.cardCache = {}

        ::UI.pushStyle(::EUR.eurStyles.basic_4)

        this.upgradeScroll = ::EUR.scroll.create(this.layout.windowW, this.layout.windowH, 0, 0, function() {
            ::EUR.window_states.show_upgrade_window = false
            ::EUR.alias_text = ""
            ::EUR.alias_text_set = false
        })
        this.upgradeCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.upgradeCanvas, function() { self.upgradeWindow() })

        this.aliasInput = ::UI.input("")
        ::UI.setWidgetStyle(this.aliasInput, ::EUR.eurStyles.basic_types.input)
        ::UI.placeAbsolute(this.aliasInput)
        this.updateButton = ::UI.button("Update")
        ::UI.placeAbsolute(this.updateButton)
        ::UI.buttonClick(this.updateButton, function() {
            local text = ::UI.inputTextGet(self.aliasInput)
            if (text != null && text != "" && ::EUR.sel_unit != null) {
                ::EUR.sel_unit.name = text
                ::EUR.alias_text_set = false
                ::EUR.alias_text = ""
            }
        })

        this.acceptScroll = ::EUR.scroll.create(this.layout.acceptW, this.layout.acceptH, 0, 0)
        this.acceptCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.acceptCanvas, function() { self.ugSwapAccept() })

        ::UI.setParent(this.acceptScroll.window)
        this.ugYesBtn = ::UI.button("Yes", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.ugYesBtn)
        ::UI.buttonClick(this.ugYesBtn, function() {
            ::EUR.pause_disband = true
            ::EUR.eur_player_faction.record.disbandToPools = false
            ::EUR.sel_unit = null
            if (::EUR.temp_upgrade_unit != null) {
                ::EUR.temp_upgrade_unit.kill()
                ::EUR.temp_upgrade_unit = null
            }
            local upgradeUnit =
                ::EUR.old_unit_army.createUnit(
                ::EUR.upgradeName,
                (::EUR.old_unit_exp - (::EUR.UNIT_UPGRADES[::EUR.old_unit_edu].expRequirement[::EUR.temp_unit_choice]-::EUR.unit_upgrades_multi)),
                0,
                ::EUR.old_unit_weapon,
                -1
            )
            if (::EUR.old_unit_sol < ::EUR.old_unit_solmax) {
                upgradeUnit.soldiers =
                    ::EUR.math.min(upgradeUnit.soldiersMax, ::EUR.old_unit_sol)
            }
            if (upgradeUnit != null) {
                ::EUR.sel_unit = upgradeUnit
            }
            /*unit.eduEntry = ::units.get(UNIT_UPGRADES[unit.eduEntry.eduType].unit[::EUR.temp_unit_choice])
            if unit.soldierCountStratMap > old_unit_solmax then
                unit.soldierCountStratMap = old_unit_solmax
            end
            --unit.armourLVL = 0
            unit.exp = unit.exp - (UNIT_UPGRADES[old_unit_edu].expRequirement[temp_unit_choice]-unit_upgrades_multi)*/

            ::game.runConsoleCommand("add_money", "-" + ("" + ::EUR.unit_cost))
            ::EUR.window_states.show_upgrade_window = false
            ::EUR.alias_text = ""
            ::EUR.alias_text_set = false
            ::EUR.show_ug_accept = false
            ::EUR.pause_disband = false
            ::EUR.eur_player_faction.record.disbandToPools = true

            ::EUR.upgradeName = ""
            ::EUR.old_unit_army = null
            ::EUR.old_unit_exp = 0
            ::EUR.old_unit_sol = 0
            ::EUR.old_unit_solmax = 0

            ::EUR.old_unit_edu = ""
            ::EUR.old_unit_weapon = 0
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        this.ugNoBtn = ::UI.button("No", this.layout.acceptButtonW, this.layout.acceptButtonH)
        ::UI.placeAbsolute(this.ugNoBtn)
        ::UI.buttonClick(this.ugNoBtn, function() {
            ::EUR.show_ug_accept = false
            ::EUR.window_states.show_upgrade_window = true
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        ::UI.popStyle()

        ::EUR.scroll.sealOnTop(this.upgradeScroll)
        ::EUR.scroll.sealOnTop(this.acceptScroll)

        ::UI.setParent(0)
        ::UI.widgetVisible(this.upgradeScroll.window, false)
        ::UI.widgetVisible(this.acceptScroll.window, false)
        ::UI.widgetVisible(this.aliasInput, false)
        ::UI.widgetVisible(this.updateButton, false)
        ::UI.widgetVisible(this.ugYesBtn, false)
        ::UI.widgetVisible(this.ugNoBtn, false)
        if ("gamePanelWindow" in ::UI) { ::UI.gamePanelWindow(this.upgradeScroll.window, 0) }
        ::EUR.registerLeftWindow("show_upgrade_window", this.upgradeScroll.window)
    }

    function unitCard(eduType, faction) {
        if (eduType in this.cardCache) return this.cardCache[eduType]
        local unitType = ::units.get(eduType)
        local texture = (unitType != null) ? ::UI.loadTexture(unitType.cardPath(faction)) : null
        this.cardCache[eduType] <- texture
        return texture
    }

    // The general-upgrades card lift, same numbers: an additive white wash on hover, brighter while
    // held. Additive rather than a plain alpha fill so a dark card brightens instead of greying out.
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
    }

    function upgradeWindow() {
        // GAME SPACE: this panel sits in the game's own scroll slot, so its content stretches on x
        // exactly as the frame does. Composes with Cap.autoScaleDraw's uniform scale to give the
        // engine's W/1920; 1.0 on 16:9, so nothing moves there. Scoped form - closes on every path.
        return ::UI.pushTransform(0, 0, ::authored.hudStretch(), 0, 1.0, function() {
            this.upgradeWindowBody()
        }.bindenv(this))
    }

    function upgradeWindowBody() {
        if (!::EUR.in_campaign_map) { return }
        ::EUR.unit_cost = 0
        local faction_id = ::game.localFactionId()
        if (::EUR.sel_unit == null) { return }
        ::EUR.scroll_unit = ::EUR.sel_unit
        if (::EUR.scroll_unit == null) { return }
        if (!::EUR.unit_only) { return }
        if (::EUR.scroll_unit == null) { return }

        local unit = ::EUR.scroll_unit
        if (unit == null) { return }
        if (unit != ::EUR.temp_upgrade_unit) {
            ::EUR.temp_unit_choice = 0
        }
        if (unit.army == null) { return }
        if (unit.army.faction.id != faction_id) {
            ::EUR.window_states.show_upgrade_window = false
            ::EUR.alias_text = ""
            ::EUR.alias_text_set = false
            return
        }
        if (unit.type == null) { return }
        if (!(unit.type.name in ::EUR.UNIT_UPGRADES) || !::EUR.UNIT_UPGRADES[unit.type.name]) { return }

        local rect = ::authored.gameRect(::UI.widgetRectGet(this.upgradeScroll.window))
        if (rect == null) { return }
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) { return }
        local area = { x = rect[0] + margins[0], y = rect[1] + margins[1],
                       width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }

        ::EUR.scroll.drawSet("panel",
                             (area.x + this.layout.bgInsetX + this.layout.bgOffsetX),
                             (area.y + this.layout.bgInsetY + this.layout.bgOffsetY),
                             (area.width - this.layout.bgInsetX * 2 + this.layout.bgWidthDelta),
                             (area.height - this.layout.bgInsetY * 2 + this.layout.bgHeightDelta))

        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour })

        ::UI.layoutAt(area.x, area.y + this.layout.headingOffsetY)
        ::UI.pushFont(::fonts.body, false, this.layout.headingFontSize)
        ::UI.pushStyle({ [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = area.width })
        ::UI.text("Unit Upgrades")
        ::UI.popStyle()
        ::UI.popFont()

        ::UI.pushFont(::fonts.body, false, this.layout.bodyFontSize)
        this.styleAliasFont()

        local contentX = area.x + this.layout.contentInsetX
        local y = area.y + this.layout.contentTopY

        ::UI.layoutAt(area.x, area.y + this.layout.nameY)
        ::UI.pushStyle({ [::UI.Metric.fontSize] = this.layout.nameFontSize, [::UI.Metric.alignX] = 1,
                         [::UI.Metric.elideWidth] = area.width })
        ::UI.text(unit.type.displayName)
        ::UI.popStyle()

        if (!::EUR.alias_text_set) {
            ::EUR.alias_text = unit.name
            ::EUR.alias_text_set = true
            ::UI.textSet(this.aliasInput, unit.name)
        }

        ::UI.widgetRect(this.aliasInput, contentX, y, this.layout.aliasInputW, this.layout.aliasInputH)
        ::UI.widgetRect(this.updateButton, contentX + this.layout.aliasInputW + this.layout.updateButtonGapX, y,
                        0, this.layout.updateButtonH)

        ::EUR.alias_text = ::UI.inputTextGet(this.aliasInput)
        local isInputFocused = (::UI.focusedWidget() == this.aliasInput)
        if (isInputFocused != ::EUR.INPUT_TEXT_FOCUSED) {
            ::game.runScriptCommand("disable_shortcuts", (isInputFocused ? "true" : "false"))
            ::EUR.INPUT_TEXT_FOCUSED = isInputFocused
        }
        y += this.layout.aliasRowH

        ::UI.layoutAt(contentX, y)
        ::UI.text("Experience: " + ("" + unit.experience))
        y += this.layout.experienceRowH

        local uCard = this.unitCard(unit.type.name, ::EUR.eur_player_faction.name)
        if (uCard != null && uCard.img != 0) {
            ::UI.image(uCard.img, this.layout.cardW, this.layout.cardH, contentX, y)
            ::UI.tooltipAt(contentX, y, this.layout.cardW, this.layout.cardH)
            ::UI.tooltip(0, ::units.get(unit.type.name).displayName + "\n" + ::EUR.showEDUStats(unit.type.name))
        }
        y += this.layout.cardH + this.layout.currentCardGapY

        ::UI.layoutAt(contentX, y)
        ::UI.text("Upgrades:")
        y += this.layout.upgradesLabelRowH

        local cardX = contentX
        local cardY = y
        for (local i = 0; i < ::EUR.UNIT_UPGRADES[unit.type.name].unit.len(); i++) {
            if (unit.general != null) {
                ::UI.popFont()
                ::UI.popStyle()
                return
            }
            if (::EUR.UNIT_UPGRADES[unit.type.name].unit[i] != null) {
                local eduEntry = ::units.get(::EUR.UNIT_UPGRADES[unit.type.name].unit[i])
                if (eduEntry == null) {
                    cardX += this.layout.cardW + this.layout.cardGapX
                    continue
                }

                local owned = eduEntry.hasOwnership(faction_id)
                local eligible = false
                local reason = null
                if (owned) {
                    if (!((!("faction" in ::EUR.UNIT_UPGRADES[unit.type.name]) || ::EUR.UNIT_UPGRADES[unit.type.name].faction == null) || ( ("faction" in ::EUR.UNIT_UPGRADES[unit.type.name]) && ::EUR.UNIT_UPGRADES[unit.type.name].faction != null && ::EUR.UNIT_UPGRADES[unit.type.name].faction[i] == ::EUR.eur_player_faction.name))) {
                        reason = "Upgrade is for a different faction."
                    } else if (!::EUR.checkCounter(::EUR.UNIT_UPGRADES[unit.type.name].counter[i])) {
                        reason = "Upgrade unlocked after special event."
                    } else if (!::EUR.tableContains(::EUR.list_edu_table, eduEntry.index)) {
                        reason = "Building not present, a recruitment building for this unit must be present somewhere within the realm."
                    } else {
                        ::EUR.unit_cost = ::EUR.math.ceil((eduEntry.recruitCost * ::EUR.UNIT_UPGRADES[unit.type.name].cost_multi[i]))
                        if (unit.army.faction.money < ::EUR.unit_cost) {
                            reason = "Not enough gold."
                        } else if (unit.experience < (::EUR.UNIT_UPGRADES[unit.type.name].expRequirement[i]-::EUR.unit_upgrades_multi)) {
                            reason = "Experience too low."
                        } else {
                            eligible = true
                        }
                    }
                }

                local optCard = this.unitCard(eduEntry.name, ::EUR.eur_player_faction.name)
                if (optCard != null && optCard.img != 0) {
                    if (eligible) {
                        if (this.cardButton(optCard.img, this.layout.cardW, this.layout.cardH, cardX, cardY)) {
                            ::EUR.temp_unit_choice = i
                            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
                        }
                    } else {
                        local optTint = this.layout.disabledCardTint
                        ::UI.image(optCard.img, this.layout.cardW, this.layout.cardH, cardX, cardY, optTint[0], optTint[1], optTint[2], optTint[3])
                    }

                    if (owned) {
                        local tip = eduEntry.displayName + "\n" +
                            "Experience required: " + ("" + (::EUR.UNIT_UPGRADES[unit.type.name].expRequirement[i]-::EUR.unit_upgrades_multi)) + "\n" +
                            "Gold: " + ("" + ::EUR.math.ceil((eduEntry.recruitCost * ::EUR.UNIT_UPGRADES[unit.type.name].cost_multi[i])))
                        if (reason != null) {
                            tip += "\n" + reason
                        }
                        tip += "\n" + ::EUR.showEDUStats(eduEntry.name)
                        ::UI.tooltipAt(cardX, cardY, this.layout.cardW, this.layout.cardH)
                        ::UI.tooltip(0, tip)
                    }
                }
                cardX += this.layout.cardW + this.layout.cardGapX
            }
        }

        local exp_req = (::EUR.UNIT_UPGRADES[unit.type.name].expRequirement[::EUR.temp_unit_choice]-::EUR.unit_upgrades_multi)
        local eduEntry = ::units.get(::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice])
        if (eduEntry != null && eduEntry.hasOwnership(faction_id)) {
            if (unit.experience >= exp_req) {
                ::EUR.unit_cost = ::EUR.math.ceil((eduEntry.recruitCost * ::EUR.UNIT_UPGRADES[unit.type.name].cost_multi[::EUR.temp_unit_choice]))
            }
        }
        ::EUR.temp_upgrade_unit = unit

        // Locked to the left column rather than carrying its own absolute y: the heading sits on the
        // "Experience:" row and its cards on the unit card below it, so the two columns stay level if
        // either row height changes. The two offsets are nudges on top of that, not the base.
        local previewX = area.x + this.layout.previewOffsetX
        local previewY = area.y + this.layout.contentTopY + this.layout.aliasRowH + this.layout.previewOffsetY

        if (unit.experience >= exp_req) {
            if ((!("faction" in ::EUR.UNIT_UPGRADES[unit.type.name]) || ::EUR.UNIT_UPGRADES[unit.type.name].faction == null) || ( ("faction" in ::EUR.UNIT_UPGRADES[unit.type.name]) && ::EUR.UNIT_UPGRADES[unit.type.name].faction != null && ::EUR.UNIT_UPGRADES[unit.type.name].faction[::EUR.temp_unit_choice] == ::EUR.eur_player_faction.name)) {
                if (::EUR.checkCounter(::EUR.UNIT_UPGRADES[unit.type.name].counter[::EUR.temp_unit_choice])) {
                    if (::EUR.tableContains(::EUR.list_edu_table, eduEntry.index)) {
                        if (unit.army != null) {
                            if (unit.army.faction.money >= ::EUR.unit_cost) {
                                if (!(unit.army.inSettlement() || unit.army.inFort())) {
                                    // Bottom of the window, same slot as the general-upgrades messages -
                                    // previewY put it over the current unit card near the top.
                                    this.statusMessage(area, area.y + this.layout.messageOffsetY,
                                                       "Cannot change as not garrisoned in a fort or settlement.")
                                } else {
                                    ::EUR.unit_cost = ::EUR.math.ceil((eduEntry.recruitCost * ::EUR.UNIT_UPGRADES[unit.type.name].cost_multi[::EUR.temp_unit_choice]))
                                    ::EUR.upgradeName = ::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]
                                    ::EUR.old_unit_army = unit.army
                                    ::EUR.old_unit_exp = unit.experience
                                    ::EUR.old_unit_sol = unit.soldiers
                                    ::EUR.old_unit_solmax = unit.soldiersMax
                                    if (unit.type != null) {
                                        if (eduEntry.hasOwnership(faction_id)) {
                                            ::EUR.old_unit_edu = unit.type.name
                                            ::EUR.old_unit_weapon = unit.weaponLevel
                                            if (::EUR.old_unit_army != null) {
                                                if (::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice] != null) {
                                                    ::UI.layoutAt(previewX, previewY)
                                                    if ((::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice] in ::EUR.UNIT_UPGRADES) && ::EUR.UNIT_UPGRADES[::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]] != null) {
                                                        ::UI.text("Upgrade Path for " + (::units.get(::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]).displayName))
                                                        local pathX = previewX
                                                        local pathY = previewY + this.layout.experienceRowH + this.layout.previewPathRowOffsetY
                                                        for (local yy = 0; yy < ::EUR.UNIT_UPGRADES[::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]].unit.len(); yy++) {
                                                            if (::EUR.UNIT_UPGRADES[::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]].unit[yy] != null) {
                                                                local edu = ::units.get(::EUR.UNIT_UPGRADES[::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]].unit[yy])
                                                                if (edu != null) {
                                                                    local pCard = this.unitCard(edu.name, ::EUR.eur_player_faction.name)
                                                                    if (pCard != null && pCard.img != 0) {
                                                                        ::UI.image(pCard.img, this.layout.cardW, this.layout.cardH, pathX, pathY)
                                                                        ::UI.tooltipAt(pathX, pathY, this.layout.cardW, this.layout.cardH)
                                                                        ::UI.tooltip(0, edu.displayName + "\n" + ::EUR.showEDUStats(edu.name))
                                                                    }
                                                                }
                                                                pathX += this.layout.cardW + this.layout.cardGapX
                                                            }
                                                        }
                                                    } else {
                                                        ::UI.text("No further upgrades.")
                                                    }
                                                }

                                                // Centred on the content area, coin at the card's left edge - the same
                                                // three lines eurGeneralBGSwap places its confirm card with.
                                                local costY = area.y + this.layout.costOffsetY
                                                local targetX = area.x + (area.width - this.layout.cardW) / 2
                                                if (::EUR.coins != null && ::EUR.coins.img != 0) { ::UI.image(::EUR.coins.img, this.layout.coinIconW, this.layout.coinIconH, targetX, costY) }
                                                ::UI.layoutAt(targetX + this.layout.costTextOffsetX, costY)
                                                ::UI.text(("" + ::EUR.unit_cost))
                                                local targetY = costY + this.layout.costCardOffsetY
                                                local tCard = this.unitCard(::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice], ::EUR.eur_player_faction.name)
                                                local haveTCard = tCard != null && tCard.img != 0
                                                local confirmed = haveTCard
                                                    ? this.cardButton(tCard.img, this.layout.cardW, this.layout.cardH, targetX, targetY)
                                                    : ::UI.hitRect(targetX, targetY, this.layout.cardW, this.layout.cardH).clicked
                                                if (haveTCard) {
                                                    ::UI.tooltipAt(targetX, targetY, this.layout.cardW, this.layout.cardH)
                                                    ::UI.tooltip(0, ::units.get(::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]).displayName + "\n" + ::EUR.showEDUStats(::EUR.UNIT_UPGRADES[unit.type.name].unit[::EUR.temp_unit_choice]))
                                                }
                                                if (confirmed) {
                                                    ::EUR.show_ug_accept = true
                                                    ::EUR.window_states.show_upgrade_window = false
                                                    ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        ::UI.popFont()
        ::UI.popStyle()
    }

    function acceptArea() {
        local rect = ::authored.rect(::UI.widgetRectGet(this.acceptScroll.window))
        if (rect == null) { return null }
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) { return null }
        return { x = rect[0] + margins[0], y = rect[1] + margins[1],
                 width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }
    }

    function ugSwapAccept() {
        local area = this.acceptArea()
        if (area == null) { return }
        if (::EUR.temp_upgrade_unit == null) { return }
        if (::EUR.temp_upgrade_unit.type == null) { return }
        if (!(::EUR.temp_upgrade_unit.type.name in ::EUR.UNIT_UPGRADES)) { return }

        // Both insets are measured from the content AREA (the window minus the scroll set's
        // 9-slice margins), so an equal value on each axis puts the panel edge the same
        // distance inside on both. Negative grows it back out over the frame.
        local panelX = area.x + this.layout.acceptBgInsetX + this.layout.acceptBgOffsetX
        local panelW = area.width - this.layout.acceptBgInsetX * 2 + this.layout.acceptBgWidthDelta
        local panelY = area.y + this.layout.acceptBgInsetY + this.layout.acceptBgOffsetY
        local panelH = area.height - this.layout.acceptBgInsetY * 2 + this.layout.acceptBgHeightDelta
        ::EUR.scroll.drawSet("panel", panelX, panelY,
                             panelW, panelH)

        this.acceptText(panelX, panelY, panelW,
                        area.y + area.height - this.layout.acceptButtonBottomInset,
                        "Upgrade to " + ::EUR.UNIT_UPGRADES[::EUR.temp_upgrade_unit.type.name].unit[::EUR.temp_unit_choice])
    }

    // Heading face, WRAPPED rather than elided, sat at the midpoint between the panel top and the
    // buttons instead of pinned near the top. textSize measures inside the pushed font scope, and
    // with a wrap width it answers the wrapped height, so a two-line message still centres.
    function acceptText(panelX, panelY, panelW, buttonY, message) {
        ::UI.pushFont(::fonts.body, false, this.layout.headingFontSize)
        local wrapW = panelW - this.layout.acceptTextPadX * 2
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour,
                         [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = wrapW })
        local textH = ::UI.textSize(message, 0, 0, wrapW)[1]
        ::UI.layoutAt(panelX + this.layout.acceptTextPadX, panelY + (buttonY - panelY - textH) / 2)
        ::UI.textWrapped(message, wrapW)
        ::UI.popStyle()
        ::UI.popFont()
    }

    function checkAIUpgrades(faction) {
        if (::EUR.to_log) {
            println("EUR SCRIPT: " + "checkAIUpgrades");
        }
        if (!::EUR.ai_unit_upgrades) { return }
        if (!::EUR.options_legendary && ::EUR.eur_turn_number < 50) { return }
        if (faction.isPlayerControlled == 1) { return }
        faction.record.disbandToPools = false
        for (local j = 0; j <= faction.armyCount - 1; j++) {
            local stack = faction.army(j);
            if (stack != null) {
                for (local x = 0; x <= stack.unitCount - 1; x++) {
                    local unit = stack.unit(x)
                    if (unit != null) {
                        if (!unit.isDead) {
                            if ((unit.type.name in ::EUR.UNIT_UPGRADES) && ::EUR.UNIT_UPGRADES[unit.type.name]) {
                                for (local i = 0; i < ::EUR.UNIT_UPGRADES[unit.type.name].unit.len(); i++) {
                                    if (unit.general == null) {
                                        if (::EUR.UNIT_UPGRADES[unit.type.name].unit[i] != null) {
                                            local eduEntry = ::units.get(::EUR.UNIT_UPGRADES[unit.type.name].unit[i])
                                            if (eduEntry != null) {
                                                if (eduEntry.hasOwnership(faction.id)) {
                                                    if (::EUR.UNIT_UPGRADES[unit.type.name].cost_multi[i] >= 1) {
                                                        if ((!("faction" in ::EUR.UNIT_UPGRADES[unit.type.name]) || ::EUR.UNIT_UPGRADES[unit.type.name].faction == null) || ( ("faction" in ::EUR.UNIT_UPGRADES[unit.type.name]) && ::EUR.UNIT_UPGRADES[unit.type.name].faction != null && ::EUR.UNIT_UPGRADES[unit.type.name].faction[i] == faction.name)) {
                                                            if (::EUR.checkCounter(::EUR.UNIT_UPGRADES[unit.type.name].counter[i])) {
                                                                local exp_offset = 1
                                                                local random_threshold = 40
                                                                if (::EUR.eur_turn_number < 70) {
                                                                    random_threshold = 60
                                                                }
                                                                if (::EUR.options_legendary) {
                                                                    exp_offset = 3
                                                                    random_threshold = 20
                                                                }
                                                                local requiredExp = ::EUR.math.max(::EUR.UNIT_UPGRADES[unit.type.name].expRequirement[i] - exp_offset, 0)
                                                                if (unit.experience >= requiredExp) {
                                                                    if (::EUR.math.random(1, 100) > random_threshold) {
                                                                        println("AI unit upgraded :" + unit.type.name + " to " + ::EUR.UNIT_UPGRADES[unit.type.name].unit[i])
                                                                        local unitSize = ::EUR.getUnitSizeMult()
                                                                        local old_edu = unit.type.name
                                                                        unit.type = eduEntry
                                                                        println("new edu check " + unit.type.name)
                                                                        unit.soldiers = ::EUR.math.min(unit.soldiers, unit.type.soldierCount * unitSize)
                                                                        if (unit.experience - ::EUR.UNIT_UPGRADES[old_edu].expRequirement[i] >= 0) {
                                                                            unit.experience = unit.experience-::EUR.UNIT_UPGRADES[old_edu].expRequirement[i]
                                                                        } else {
                                                                            unit.experience = 0
                                                                        }
                                                                        break
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        faction.record.disbandToPools = true
        if (::EUR.to_log) {
            println("EUR SCRIPT: " + "Script end");
        }
    }

    function list_edu_recruitable() {
        if (::EUR.eur_turn_number == 0) {
            for (local i = 0; i <= 1500; i++) {
                local eduEntry = ::units.at(i)
                if (eduEntry != null) {
                    if (eduEntry.hasOwnership(::EUR.eur_playerFactionId)) {
                        ::EUR.list_edu_table_default.append(eduEntry.index)
                    }
                }
            }
        }
        if (::EUR.restricted_upgrades) {
            ::EUR.list_edu_table = []
            for (local i = 0; i <= ::EUR.eur_player_faction.settlementCount - 1; i++) {
                local sett = ::EUR.eur_player_faction.settlement(i)
                if (sett != null) {
                    local capabilitynum = sett.recruitCapabilityCount
                    for (local y = 0; y <= capabilitynum -1; y++) {
                        local temp_capability = sett.recruitCapability(y)
                        if (temp_capability != null) {
                            if (temp_capability.maxSize >= 1) {
                                if (temp_capability.unitTypeIndex != null) {
                                    if (!::EUR.tableContains(::EUR.list_edu_table, temp_capability.unitTypeIndex)) {
                                        ::EUR.list_edu_table.append(temp_capability.unitTypeIndex)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            ::EUR.list_edu_table = ::EUR.list_edu_table_default
        }
    }

    function render() {
        this.ensure()
        ::EUR.syncLeftWindows()

        local showUpgrade = ::EUR.window_states.show_upgrade_window && ::EUR.in_campaign_map
                            && !::EUR.diplo_open && !::EUR.show_ug_accept && ::EUR.can_unit_upgrade
        showUpgrade = ::EUR.panelFollow(this.upgradeScroll.window, ::EUR.window_states, "show_upgrade_window",
                                        showUpgrade, this.shownLast)
        this.shownLast = showUpgrade
        ::UI.widgetVisible(this.aliasInput, showUpgrade)
        ::UI.widgetVisible(this.updateButton, showUpgrade)
        if (showUpgrade) {
            ::EUR.scroll.placeGame(this.upgradeScroll.window, this.layout.windowX, this.layout.windowY, this.layout.windowW, this.layout.windowH)
            if (!this.upgradeRaised) { ::UI.raise(this.upgradeScroll.window) }
        }
        this.upgradeRaised = showUpgrade

        local showAccept = ::EUR.show_ug_accept && ::EUR.in_campaign_map && !::EUR.diplo_open
        ::UI.widgetVisible(this.acceptScroll.window, showAccept)
        if (showAccept) {
            local screen = ::authored.screen()
            ::EUR.scroll.place(this.acceptScroll.window, (screen[0] - this.layout.acceptW) / 2, (screen[1] - this.layout.acceptH) / 2, this.layout.acceptW, this.layout.acceptH)
            if (!this.acceptRaised) { ::UI.raise(this.acceptScroll.window) }
        }
        this.acceptRaised = showAccept

        local area = this.acceptArea()
        local showAcceptButtons = showAccept && area != null
        if (showAcceptButtons) {
            local half = (area.width - this.layout.acceptButtonW) / 2
            local btnY = area.y + area.height - this.layout.acceptButtonBottomInset
            ::UI.widgetRect(this.ugYesBtn, area.x + half - this.layout.acceptButtonGapX, btnY, this.layout.acceptButtonW, this.layout.acceptButtonH)
            ::UI.widgetRect(this.ugNoBtn, area.x + half + this.layout.acceptButtonGapX, btnY, this.layout.acceptButtonW, this.layout.acceptButtonH)
        }
        ::UI.widgetVisible(this.ugYesBtn, showAcceptButtons)
        ::UI.widgetVisible(this.ugNoBtn, showAcceptButtons)
    }
}

::EUR.unitUpgrades <- unitUpgrades()
::UI.onFrame(function() { ::EUR.unitUpgrades.render() })
