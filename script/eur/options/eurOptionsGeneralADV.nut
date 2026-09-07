::EUR.gen_adv_tier <- "T1"
::EUR.gen_adv_slot <- 0
::EUR.gen_adv_pick <- 0

::EUR.gen_adv_picker <- {
    select = "",
    options = [],
    onChange = function(i) { ::EUR.gen_adv_pick = i },
}

class eurOptionsGeneralADV {
    layout = {
        gridLabelY = 0, gridTopY = 18,
        rowLabelW = 60, rowGapY = 4,
        cardW = 80, cardH = 80, cardGapX = 2, perRow = 5,
        previewGapX = 8, arrowW = 24, previewLabelY = 0, previewTopY = 18,
        nameY = 6, nameW = 300,
        selectedTint = [255, 255, 255, 255],
        idleTint = [255, 255, 255, 170],
        bodyFontSize = 12,
        textColour = [0, 0, 0, 255],
    }

    cardCache = null
    pickerCount = -1

    function tierTable(tier) {
        local faction = (::EUR.eur_player_faction != null) ? ::EUR.eur_player_faction.name : null
        if (faction == null || !(faction in ::EUR.gen_units_list)) return null
        local rosters = ::EUR.gen_units_list[faction]
        if (!(tier in rosters)) return null
        return rosters[tier]
    }

    function card(eduType) {
        if (this.cardCache == null) { this.cardCache = {} }
        if (eduType in this.cardCache) return this.cardCache[eduType]
        local unitType = ::units.get(eduType)
        local faction = (::EUR.eur_player_faction != null) ? ::EUR.eur_player_faction.name : null
        local texture = (unitType != null && faction != null) ? ::UI.loadTexture(unitType.cardPath(faction)) : null
        this.cardCache[eduType] <- texture
        return texture
    }

    function forgetCards() {
        this.cardCache = {}
    }

    function unitTip(eduType) {
        local unitType = ::units.get(eduType)
        if (unitType == null) return eduType
        return unitType.displayName + "\n" + ::EUR.showEDUStats(eduType)
    }

    function drawCard(eduType, x, y, selected) {
        local texture = this.card(eduType)
        if (texture == null || texture.img == 0) return false
        local tint = selected ? this.layout.selectedTint : this.layout.idleTint
        local hit = ::UI.imageButton(texture.img, this.layout.cardW, this.layout.cardH, x, y,
                                     tint[0], tint[1], tint[2], tint[3])
        ::UI.tooltipAt(x, y, this.layout.cardW, this.layout.cardH)
        ::UI.tooltip(0, this.unitTip(eduType))
        return hit.clicked
    }

    // Same array-vs-table split as drawTierRow: "special" is an array, the tiers are keyed tables.
    function slotExists(roster, slot) {
        if (roster == null) return false
        if (typeof(roster) == "array") return slot >= 0 && slot < roster.len()
        return (slot in roster)
    }

    function drawTierRow(tier, originX, y) {
        local roster = this.tierTable(tier)
        if (roster == null) return y

        ::UI.layoutAt(originX, y + (this.layout.cardH - 12) / 2)
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour })
        ::UI.text(tier + ":")
        ::UI.popStyle()

        // T1/T2/T3 are integer-KEYED TABLES, "special" is an ARRAY - and `in` does not test an
        // array index, which is why special drew nothing.
        local slots = []
        if (typeof(roster) == "array") {
            for (local i = 0; i < roster.len(); i++) { slots.append(i) }
        } else {
            for (local i = 0; (i in roster); i++) { slots.append(i) }
        }

        // Wraps rather than running on: a canvas is not clipped to its own rect, so a long tier would
        // paint straight over the pane beside it.
        local x = originX + this.layout.rowLabelW
        local column = 0
        foreach (i in slots) {
            local selected = (::EUR.gen_adv_tier == tier && ::EUR.gen_adv_slot == i)
            if (this.drawCard(roster[i], x, y, selected)) {
                ::EUR.gen_adv_tier = tier
                ::EUR.gen_adv_slot = i
                ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            }
            column++
            if (column >= this.layout.perRow) {
                column = 0
                x = originX + this.layout.rowLabelW
                y += this.layout.cardH + this.layout.rowGapY
            } else {
                x += this.layout.cardW + this.layout.cardGapX
            }
        }
        return y + this.layout.cardH + this.layout.rowGapY
    }

    // The right pane: the slot as it stands now, an arrow, and what the dropdown would put there.
    function drawPreview() {
        if (!::EUR.in_campaign_map || ::EUR.eur_player_faction == null) return
        if (!("canvas" in ::EUR.gen_adv_preview)) return
        local rect = ::authored.rect(::UI.widgetRectGet(::EUR.gen_adv_preview.canvas))
        if (rect == null) return

        ::UI.pushFont(::fonts.body, false, this.layout.bodyFontSize)
        this.previewBody(rect[0], rect[1])
        ::UI.popFont()
    }

    function previewBody(originX, top) {
        local roster = this.tierTable(::EUR.gen_adv_tier)
        local currentType = this.slotExists(roster, ::EUR.gen_adv_slot) ? roster[::EUR.gen_adv_slot] : null
        local currentUnit = (currentType != null) ? ::units.get(currentType) : null
        local currentName = (currentUnit != null) ? currentUnit.displayName : null

        ::UI.layoutAt(originX, top + this.layout.previewLabelY)
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour })
        ::UI.text((currentName != null) ? ("Editing " + currentName) : "Selected slot")
        ::UI.popStyle()
        local y = top + this.layout.previewTopY

        local names = ::EUR.player_units
        local count = (names != null) ? names.len() : 0
        if (count > 0) {
            if (::EUR.gen_adv_pick >= count) { ::EUR.gen_adv_pick = count - 1 }
            if (::EUR.gen_adv_pick < 0) { ::EUR.gen_adv_pick = 0 }
        }

        if (currentType == null) return

        local texture = this.card(currentType)
        if (texture != null && texture.img != 0) {
            ::UI.image(texture.img, this.layout.cardW, this.layout.cardH, originX, y)
            ::UI.tooltipAt(originX, y, this.layout.cardW, this.layout.cardH)
            ::UI.tooltip(0, this.unitTip(currentType))
        }

        local arrowX = originX + this.layout.cardW + this.layout.previewGapX
        ::UI.layoutAt(arrowX, y + (this.layout.cardH - 12) / 2)
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour })
        ::UI.text(">")
        ::UI.popStyle()

        if (count == 0) return
        local newType = names[::EUR.gen_adv_pick]
        local newTexture = this.card(newType)
        local newX = arrowX + this.layout.arrowW + this.layout.previewGapX
        if (newTexture != null && newTexture.img != 0) {
            ::UI.image(newTexture.img, this.layout.cardW, this.layout.cardH, newX, y)
            ::UI.tooltipAt(newX, y, this.layout.cardW, this.layout.cardH)
            ::UI.tooltip(0, this.unitTip(newType))
        }
    }

    // The left pane: the tier grid. Every BUTTON in this editor is a def-table row in the section below,
    // because ::UI.button mints a root widget and calling it from a canvas draw would build a fresh
    // one every frame; imageButton is the immediate form and is what the cards use.
    function draw() {
        if (!::EUR.in_campaign_map || ::EUR.eur_player_faction == null) return
        this.refreshPicker()
        if (!("canvas" in ::EUR.gen_adv_section)) return
        local rect = ::authored.rect(::UI.widgetRectGet(::EUR.gen_adv_section.canvas))
        if (rect == null) return

        ::UI.pushFont(::fonts.body, false, this.layout.bodyFontSize)
        local originX = rect[0]
        local y = rect[1]

        ::UI.layoutAt(originX, y + this.layout.gridLabelY)
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour })
        ::UI.text("Bodyguard roster:")
        ::UI.popStyle()

        local gridY = y + this.layout.gridTopY
        gridY = this.drawTierRow("T1", originX, gridY)
        gridY = this.drawTierRow("T2", originX, gridY)
        gridY = this.drawTierRow("T3", originX, gridY)
        gridY = this.drawTierRow("special", originX, gridY)
        ::UI.popFont()
    }

    // selectOptions CLEARS the selection, so this runs on the event that changes the list, never
    // per frame - and the index is restored behind it.
    function refreshPicker() {
        if (!("handle" in ::EUR.gen_adv_picker)) return
        local names = ::EUR.player_units_local
        if (names == null || names.len() == 0) return
        if (names.len() == this.pickerCount) return
        this.pickerCount = names.len()
        ::UI.selectOptions(::EUR.gen_adv_picker.handle, names)
        if (::EUR.gen_adv_pick >= names.len()) { ::EUR.gen_adv_pick = 0 }
        ::UI.selectSelected(::EUR.gen_adv_picker.handle, ::EUR.gen_adv_pick)
    }

    function swap() {
        local roster = this.tierTable(::EUR.gen_adv_tier)
        local names = ::EUR.player_units
        if (!this.slotExists(roster, ::EUR.gen_adv_slot) || names == null || names.len() == 0) return
        roster[::EUR.gen_adv_slot] = names[::EUR.gen_adv_pick]
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }
}

::EUR.eurOptionsGeneralADV <- eurOptionsGeneralADV()

// The factory-reset tables, distinct from the *_default tables the campaign seeds from - the editor
// is allowed to overwrite those, so "Load defaults" has to come from somewhere it cannot reach.
::EUR.loadFactoryBodyguards <- function() {
    local source = ::EUR.game_options.BG_T2 ? ::EUR.gen_units_list_default_fr2 : ::EUR.gen_units_list_default_fr
    ::EUR.gen_units_list = {}
    foreach (k, v in source) { ::EUR.gen_units_list[k] <- ::EUR.deepCopyValue(v) }
    ::EUR.eurOptionsGeneralADV.forgetCards()
}
