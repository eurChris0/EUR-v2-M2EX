class eurStatusIcons {
    layout = {
        cardW = 90, iconSize = 16, upgX = 74, upgY = 2, replenX = 72, replenY = 38,
        tipRows = 14,
    }

    canvas  = 0
    tipBody = 0
    tipRows = null
    built   = false

    function ensure() {
        if (this.built) return
        local self = this

        // Built ONCE and re-aimed every frame: a tooltip body is a widget subtree, and handles are
        // never recycled, so building it in the draw would leak one per row per frame. The rows are
        // a fixed pool - hidden ones fall out of the layout, so the line count varies and the
        // handle count does not.
        // A label draws in Font.body; the plain-string tooltip draws in Font.small. Match it, or the
        // coloured tooltips come out in a different face and size from every other EUR tooltip. The
        // box itself is drawn by the tooltip pass, so the body carries no chrome and no row gap.
        this.tipRows = []
        this.tipBody = ::UI.beginTooltip(0)
        ::UI.setWidgetStyle(this.tipBody, ::UI.Metric.gap, 0)
        // A font TOKEN reads 0 when the theme leaves it unset, and the plain tooltip's face comes
        // from a C++ fallback no token exposes - so pushing Font.small's value pushes 0, which means
        // "unset". The id has to come from UI.fonts() by name, the way eurOptions does it.
        local smallId = 0
        local faces = ::UI.fonts()
        if (faces != null) {
            foreach (f in faces) { if (f.name == ::fonts.game.verdanaSml) { smallId = f.id } }
        }
        for (local i = 0; i < this.layout.tipRows; i += 1) {
            local row = ::UI.labelColoured("", 255, 255, 255, 255)
            if (smallId != 0) { ::UI.setWidgetStyle(row, ::UI.Font.body, smallId) }
            // A label's own padding is added to its natural height, so the default 4 puts 8px
            // between lines on top of the flow gap - the plain tooltip steps by the line height flat.
            ::UI.setWidgetStyle(row, ::UI.Metric.padX, 0)
            ::UI.setWidgetStyle(row, ::UI.Metric.padY, 0)
            this.tipRows.append(row)
        }
        ::UI.endTooltip()

        ::UI.setParent(0)
        this.canvas = ::UI.canvas(0, 0, 0, 0)
        ::UI.setWidgetStyle(this.canvas, ::UI.Cap.autoScaleDraw, 0)
        ::UI.setWidgetStyle(this.canvas, ::UI.Cap.autoScalePos, 0)
        ::UI.canvasDraw(this.canvas, function() { self.drawIcons() })
        ::UI.setParent(0)

        this.built = true
    }

    function render() {
        this.ensure()
    }

    function drawIcons() {
        if (!::EUR.in_campaign_map) return
        local cards = ::ui.cardManager()
        if (cards == null || cards.cardDragging) return

        for (local i = 0; i < cards.unitCardCount; i += 1) {
            local r = cards.unitCardRect(i)
            if (r == null || r[2] <= 0) continue
            local u = cards.unitAt(i)
            if (u == null || u.general != null) continue

            this.drawUpgrade(u, r)
            this.drawReplen(u, r)
        }
    }

    function iconRect(r, offsetX, offsetY) {
        local s = r[2] / this.layout.cardW.tofloat()
        return [r[0] + (offsetX * s).tointeger(), r[1] + (offsetY * s).tointeger(),
                (this.layout.iconSize * s).tointeger(), (this.layout.iconSize * s).tointeger()]
    }

    function drawIcon(img, box) {
        if (img == null) return false
        ::UI.image(img, box[2], box[3], box[0], box[1])
        return true
    }

    function showTip(box, text) {
        ::UI.tooltipAt(box[0], box[1], box[2], box[3])
        ::UI.tooltip(0, text)
    }

    // lines are [text, green?] - anything not flagged takes the theme's own tooltip ink.
    function showLines(box, lines) {
        local ink = ::UI.getStyle(::UI.Colour.tooltipText)
        for (local i = 0; i < this.tipRows.len(); i += 1) {
            local on = i < lines.len()
            ::UI.widgetVisible(this.tipRows[i], on)
            if (!on) continue
            ::UI.textSet(this.tipRows[i], lines[i][0])
            if (lines[i][1]) { ::UI.textColour(this.tipRows[i], 0, 255, 0, 255) }
            else { ::UI.textColour(this.tipRows[i], ink[0], ink[1], ink[2], ink[3]) }
        }
        ::UI.tooltipAt(box[0], box[1], box[2], box[3])
        ::UI.tooltipContent(0, this.tipBody)
    }

    function drawUpgrade(u, r) {
        if (!::EUR.options_unit_upgrades) return
        local name = u.type.name
        if (!(name in ::EUR.UNIT_UPGRADES) || !::EUR.UNIT_UPGRADES[name]) return

        local entry = ::EUR.UNIT_UPGRADES[name]
        local upg = false, sdg = false
        for (local j = 0; j < entry.unit.len(); j += 1) {
            if (u.experience < entry.expRequirement[j] - ::EUR.unit_upgrades_multi) continue
            if (entry.expRequirement[j] > 2) { if (entry.cost_multi[j] >= 1) { upg = true } }
            else { sdg = true }
        }

        local box = this.iconRect(r, this.layout.upgX, this.layout.upgY)
        if (upg && ::EUR.game_options.display_upg) {
            if (this.drawIcon(::EUR.upg_icon.img, box)) { this.showTip(box, "Upgrades available") }
        } else if (sdg && ::EUR.game_options.display_sdg) {
            if (this.drawIcon(::EUR.sdg_icon.img, box)) { this.showTip(box, "Upgrades at same tier available") }
        }
    }

    function drawReplen(u, r) {
        if (u.soldiers >= u.soldiersMax) return
        if (u.type.category == 4) return
        if (u.name != null && u.name.indexof("Garrison") != null) return
        if (u.type.soldierCount <= 10 && u.type.soldierCount <= ::EUR.replen_beast_value) return
        if (::EUR.tableContains(::EUR.replen_exempt, u.type.name)) return

        local plan = ::EUR.eurReplenishment.armyPlan(u.army, ::EUR.eur_player_faction)
        if (plan == null) return

        local box = this.iconRect(r, this.layout.replenX, this.layout.replenY)
        if (!this.drawIcon(::EUR.replen.img, box)) return
        this.showLines(box, this.replenLines(u, plan))
    }

    function replenLines(u, plan) {
        local lines = []
        if (plan.isField) {
            lines.append(["Replenishment: " + plan.ratePct + "%", false])
            lines.append(["", false])
            lines.append([(plan.allied ? "Friendly" : "Foriegn") + " territory: " + plan.fieldPct + "%", false])
        } else {
            lines.append([u.type.displayName + "   " + u.soldiers + "/" + u.soldiersMax, false])
            lines.append(["Approx +" + ::EUR.math.ceil(u.soldiersMax * (plan.ratePct / 100.0) + 1), true])
            lines.append(["", false])
            lines.append(["Replenishment rate: " + plan.ratePct + "%", false])
            lines.append(["Base rate: " + plan.basePct + "%", false])
            if (plan.waystation) { lines.append(["Waystation bonus: " + plan.waystationPct + "%", false]) }
            if (plan.aquaduct) { lines.append(["Health bonus: " + plan.aquaductPct + "%", false]) }
        }

        if (plan.roadPct > 0) { lines.append(["Roads: " + plan.roadPct + "%", false]) }
        if (plan.globalBonus > 0) { lines.append(["Global bonus: " + plan.globalBonus + "%", false]) }
        if (plan.goblinPct > 0) { lines.append(["Goblin bonus: " + plan.goblinPct + "%", false]) }
        if (plan.menPct > 0) { lines.append(["Human bonus: " + plan.menPct + "%", false]) }
        if (u.type.soldierCount <= 10) { lines.append(["Max 1 per turn.", true]) }

        return lines
    }
}

::EUR.eurStatusIcons <- eurStatusIcons()
::UI.onFrame(function() { ::EUR.eurStatusIcons.render() })
