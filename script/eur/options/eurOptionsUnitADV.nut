local format = require("string").format

local function oneDp(value) {
    return format("%.1f", value.tofloat())
}

::EUR.unit_adv_edu <- ""
::EUR.unit_adv_slot <- 0
::EUR.unit_adv_pick <- 0

// "" = neither right pane, "new" = the New entry pane, "edit" = the pane for a live entry. One or the
// other, never both: Add unit opens the first, clicking a card on the left opens the second.
::EUR.unit_adv_mode <- ""

// The New entry pane touches nothing live: these are the temp values Add unit commits in one go.
::EUR.unit_new_base <- 0
::EUR.unit_new_target <- 0
::EUR.unit_new_exp <- 2
::EUR.unit_new_cost <- 1.0

::EUR.unit_new_heading <- { text = "New entry" }

// Only units with no entry yet, so Add unit always creates one - and the empty case has a row to
// say so in rather than a dropdown that silently does nothing.
::EUR.unit_new_base_picker <- {
    select = "", options = [],
    onChange = function(i) { ::EUR.unit_new_base = i; ::EUR.eurOptionsUnitADV.pickNewTarget() },
}

::EUR.unit_new_target_picker <- {
    select = "", options = [],
    onChange = function(i) { ::EUR.unit_new_target = i },
}

::EUR.unit_new_exp_slider <- {
    slider = "Exp requirement", min = 0, max = 9, step = 1, fmt = "%d",
    bind = ["unit_new_exp"],
}

::EUR.unit_new_cost_slider <- {
    slider = "Cost multiplier", min = 0.0, max = 5.0, step = 0.1, fmt = "%.1f",
    bind = ["unit_new_cost"],
}

::EUR.unit_adv_picker <- {
    select = "", options = [],
    onChange = function(i) { ::EUR.unit_adv_pick = i },
}

// Both edit sliders are REBOUND to whichever slot is selected. buildSection pushes a value once at
// build time, so a bound row is the only way to track a target that moves.
::EUR.unit_adv_exp <- { slider = "Exp requirement", min = 0, max = 9, step = 1, fmt = "%d" }
::EUR.unit_adv_cost <- { slider = "Cost", min = 0.0, max = 5.0, step = 0.1, fmt = "%.1f" }

class eurOptionsUnitADV {
    layout = {
        cardW = 80, cardH = 80, cardGapX = 2, cardGapY = 2, perRow = 8,
        listLabelY = 0, listTopY = 18,
        lineH = 18,
        upgradeRowGapY = 6,
        maxUpgrades = 4,
        bodyFontSize = 12,
        textColour = [0, 0, 0, 255],
        warnColour = [204, 0, 0, 255],
        dimColour = [90, 90, 90, 255],
        selectedTint = [255, 255, 255, 255],
        idleTint = [255, 255, 255, 170],
    }

    cardCache = null
    pickerList = null
    freeNames = null
    boundSlot = -1
    boundEdu = ""
    boundEntry = null
    costLabel = ""

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

    function unitTip(eduType, extra) {
        local unitType = ::units.get(eduType)
        if (unitType == null) return eduType
        local tip = unitType.displayName
        if (extra != null && extra != "") { tip += "\n" + extra }
        return tip + "\n" + ::EUR.showEDUStats(eduType)
    }

    function entry() {
        if (::EUR.unit_adv_edu == "" || !(::EUR.unit_adv_edu in ::EUR.UNIT_UPGRADES)) return null
        return ::EUR.UNIT_UPGRADES[::EUR.unit_adv_edu]
    }

    function pickedUnit() {
        local names = ::EUR.player_units
        if (names == null || names.len() == 0) return null
        if (::EUR.unit_adv_pick >= names.len()) { ::EUR.unit_adv_pick = names.len() - 1 }
        if (::EUR.unit_adv_pick < 0) { ::EUR.unit_adv_pick = 0 }
        return names[::EUR.unit_adv_pick]
    }

    function newBaseType() {
        if (this.freeNames == null || this.freeNames.len() == 0) return null
        if (::EUR.unit_new_base >= this.freeNames.len()) { ::EUR.unit_new_base = 0 }
        if (::EUR.unit_new_base < 0) { ::EUR.unit_new_base = 0 }
        return this.freeNames[::EUR.unit_new_base]
    }

    function newTargetType() {
        local names = ::EUR.player_units
        if (names == null || names.len() == 0) return null
        if (::EUR.unit_new_target >= names.len()) { ::EUR.unit_new_target = 0 }
        if (::EUR.unit_new_target < 0) { ::EUR.unit_new_target = 0 }
        return names[::EUR.unit_new_target]
    }

    // The units the player may edit: owned, not cut, and carrying an upgrade entry.
    function editableList() {
        local out = []
        local faction = ::EUR.eur_player_faction
        if (faction == null) return out
        local cut = (faction.name in ::EUR.player_units_cut) ? ::EUR.player_units_cut[faction.name] : null
        foreach (eduType, upgrades in ::EUR.UNIT_UPGRADES) {
            local unitType = ::units.get(eduType)
            if (unitType == null) continue
            if (!unitType.hasOwnership(::EUR.eur_playerFactionId)) continue
            if (cut != null && ::EUR.tableContains(cut, eduType)) continue
            out.append(eduType)
        }
        out.sort()
        return out
    }

    function drawList(originX, originY) {
        ::UI.layoutAt(originX, originY + this.layout.listLabelY)
        ::UI.pushStyle({ [::UI.Colour.text] = this.layout.textColour })
        ::UI.text("Units with upgrades:")
        ::UI.popStyle()

        local x = originX
        local y = originY + this.layout.listTopY
        local column = 0
        foreach (eduType in this.editableList()) {
            local texture = this.card(eduType)
            if (texture == null || texture.img == 0) continue
            local selected = (eduType == ::EUR.unit_adv_edu)
            local tint = selected ? this.layout.selectedTint : this.layout.idleTint
            if (::UI.imageButton(texture.img, this.layout.cardW, this.layout.cardH, x, y,
                                 tint[0], tint[1], tint[2], tint[3]).clicked) {
                ::EUR.unit_adv_edu = eduType
                ::EUR.unit_adv_slot = 0
                ::EUR.unit_adv_mode = "edit"
                ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            }
            ::UI.tooltipAt(x, y, this.layout.cardW, this.layout.cardH)
            ::UI.tooltip(0, this.unitTip(eduType, null))

            column++
            if (column >= this.layout.perRow) {
                column = 0
                x = originX
                y += this.layout.cardH + this.layout.cardGapY
            } else {
                x += this.layout.cardW + this.layout.cardGapX
            }
        }
    }

    function line(x, y, text, colour) {
        ::UI.layoutAt(x, y)
        ::UI.pushStyle({ [::UI.Colour.text] = colour })
        ::UI.text(text)
        ::UI.popStyle()
        return y + this.layout.lineH
    }

    // Exp and cost are missing here on purpose: their sliders below carry both numbers now.
    function drawEditPane(x, y) {
        local upgrades = this.entry()
        if (upgrades == null) return

        local texture = this.card(::EUR.unit_adv_edu)
        if (texture != null && texture.img != 0) {
            ::UI.image(texture.img, this.layout.cardW, this.layout.cardH, x, y)
            ::UI.tooltipAt(x, y, this.layout.cardW, this.layout.cardH)
            ::UI.tooltip(0, this.unitTip(::EUR.unit_adv_edu, "Unit"))
        }
        y += this.layout.cardH + this.layout.upgradeRowGapY

        y = this.line(x, y, "Upgrades:", this.layout.textColour)
        local cardX = x
        for (local i = 0; i < upgrades.unit.len(); i++) {
            local upType = upgrades.unit[i]
            local upTexture = this.card(upType)
            if (upTexture == null || upTexture.img == 0) continue
            local owned = ::units.get(upType) != null && ::units.get(upType).hasOwnership(::EUR.eur_playerFactionId)
            local selected = (i == ::EUR.unit_adv_slot)
            local tint = selected ? this.layout.selectedTint : this.layout.idleTint
            if (::UI.imageButton(upTexture.img, this.layout.cardW, this.layout.cardH, cardX, y,
                                 tint[0], tint[1], tint[2], tint[3]).clicked) {
                ::EUR.unit_adv_slot = i
                ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            }
            ::UI.tooltipAt(cardX, y, this.layout.cardW, this.layout.cardH)
            ::UI.tooltip(0, this.unitTip(upType, "Cost: " + ::units.get(upType).recruitCost
                                                 + (owned ? "" : "\nUpgrade is for a different faction")))
            cardX += this.layout.cardW + this.layout.cardGapX
        }
        y += this.layout.cardH + this.layout.upgradeRowGapY

        if (::EUR.unit_adv_slot >= upgrades.unit.len()) { ::EUR.unit_adv_slot = 0 }
        if (upgrades.unit.len() == 0) return
        local slot = ::EUR.unit_adv_slot

        local slotUnit = ::units.get(upgrades.unit[slot])
        y = this.line(x, y, (slotUnit != null) ? slotUnit.displayName : upgrades.unit[slot], this.layout.textColour)

        local counter = upgrades.counter[slot]
        y = this.line(x, y, "Counter required: " + ((counter == "") ? "none" : counter), this.layout.textColour)

        local locked_to = "none"
        if (("faction" in upgrades) && upgrades.faction != null
            && upgrades.faction.len() > slot && upgrades.faction[slot] != "") {
            locked_to = upgrades.faction[slot]
        }
        y = this.line(x, y, "Faction locked: " + locked_to, this.layout.textColour)

        local replacement = this.pickedUnit()
        if (replacement == null) return
        if (replacement == upgrades.unit[slot]) {
            this.line(x, y, "Change to: same unit", this.layout.warnColour)
        } else {
            local into = ::units.get(replacement)
            this.line(x, y, "Change to: " + ((into != null) ? into.displayName : replacement), this.layout.textColour)
        }
    }

    // The left pane: every unit that already carries an upgrade entry. Every per-frame refresh hangs
    // off this one, because it is the draw that runs whatever the two right panes are showing.
    function draw() {
        if (!::EUR.in_campaign_map || ::EUR.eur_player_faction == null) return
        this.refreshPicker()
        this.refreshFreeList()
        this.refreshBindings()
        if (!("canvas" in ::EUR.unit_adv_section)) return
        local rect = ::UI.widgetRectGet(::EUR.unit_adv_section.canvas)
        if (rect == null) return

        ::UI.pushFont(::fonts.game.verdanaSml, false, this.layout.bodyFontSize)
        this.drawList(rect[0], rect[1])
        ::UI.popFont()
    }

    function drawTitle() {
        if (!::EUR.in_campaign_map || ::EUR.eur_player_faction == null) return
        if (!("canvas" in ::EUR.unit_adv_title)) return
        local rect = ::UI.widgetRectGet(::EUR.unit_adv_title.canvas)
        if (rect == null) return

        ::UI.pushFont(::fonts.game.verdanaSml, false, this.layout.bodyFontSize)
        local unitType = (::EUR.unit_adv_edu != "") ? ::units.get(::EUR.unit_adv_edu) : null
        if (unitType != null) {
            this.line(rect[0], rect[1], "Editing " + unitType.displayName, this.layout.textColour)
        } else {
            this.line(rect[0], rect[1], "Pick a unit on the left to edit its upgrades.", this.layout.dimColour)
        }
        ::UI.popFont()
    }

    function drawEdit() {
        if (!::EUR.in_campaign_map || ::EUR.eur_player_faction == null) return
        if (!("canvas" in ::EUR.unit_adv_edit)) return
        local rect = ::UI.widgetRectGet(::EUR.unit_adv_edit.canvas)
        if (rect == null) return

        ::UI.pushFont(::fonts.game.verdanaSml, false, this.layout.bodyFontSize)
        this.drawEditPane(rect[0], rect[1])
        ::UI.popFont()
    }

    function drawNewBaseCard() { this.drawTempCard(::EUR.unit_new_base_card, this.newBaseType()) }
    function drawNewTargetCard() { this.drawTempCard(::EUR.unit_new_target_card, this.newTargetType()) }

    function drawTempCard(section, eduType) {
        if (!::EUR.in_campaign_map || ::EUR.eur_player_faction == null) return
        if (eduType == null || !("canvas" in section)) return
        local rect = ::UI.widgetRectGet(section.canvas)
        if (rect == null) return
        local texture = this.card(eduType)
        if (texture == null || texture.img == 0) return
        ::UI.image(texture.img, this.layout.cardW, this.layout.cardH, rect[0], rect[1])
        ::UI.tooltipAt(rect[0], rect[1], this.layout.cardW, this.layout.cardH)
        ::UI.tooltip(0, this.unitTip(eduType, null))
    }

    // selectOptions CLEARS the selection, so refill only when the list actually changed - and the
    // test is the array's IDENTITY, because buildPlayerUnits replaces it wholesale and two different
    // factions can easily have the same number of units.
    function refreshPicker() {
        local names = ::EUR.player_units_local
        if (names == null || names.len() == 0) return
        if (names == this.pickerList) return
        this.pickerList = names
        if ("handle" in ::EUR.unit_adv_picker) {
            ::UI.selectOptions(::EUR.unit_adv_picker.handle, names)
            if (::EUR.unit_adv_pick >= names.len()) { ::EUR.unit_adv_pick = 0 }
            ::UI.selectSelected(::EUR.unit_adv_picker.handle, ::EUR.unit_adv_pick)
        }
        if ("handle" in ::EUR.unit_new_target_picker) {
            ::UI.selectOptions(::EUR.unit_new_target_picker.handle, names)
            if (::EUR.unit_new_target >= names.len()) { ::EUR.unit_new_target = 0 }
            ::UI.selectSelected(::EUR.unit_new_target_picker.handle, ::EUR.unit_new_target)
        }
    }

    // Rebuilt every frame - a couple of hundred string lookups - and compared element-wise, because
    // the count alone says nothing: Load defaults can hand back a different set of the same size, and
    // the dropdown's labels would then name units freeNames no longer holds at those indices.
    function refreshFreeList() {
        local names = ::EUR.player_units
        local shown = ::EUR.player_units_local
        if (names == null || shown == null || names.len() != shown.len()) return

        local free = []
        local freeShown = []
        for (local i = 0; i < names.len(); i++) {
            if (names[i] in ::EUR.UNIT_UPGRADES) continue
            free.append(names[i])
            freeShown.append(shown[i])
        }
        if (this.sameList(free, this.freeNames)) return
        this.freeNames = free

        if (!("handle" in ::EUR.unit_new_base_picker)) return
        if (free.len() == 0) {
            ::UI.selectOptions(::EUR.unit_new_base_picker.handle, ["All units have upgrades"])
            ::UI.selectSelected(::EUR.unit_new_base_picker.handle, 0)
            ::EUR.unit_new_base = 0
            return
        }
        ::UI.selectOptions(::EUR.unit_new_base_picker.handle, freeShown)
        if (::EUR.unit_new_base >= free.len()) { ::EUR.unit_new_base = 0 }
        ::UI.selectSelected(::EUR.unit_new_base_picker.handle, ::EUR.unit_new_base)
        this.pickNewTarget()
    }

    function sameList(a, b) {
        if (b == null || a.len() != b.len()) return false
        for (local i = 0; i < a.len(); i++) {
            if (a[i] != b[i]) return false
        }
        return true
    }

    // The upgrade target defaults to the first unit that is not the entry unit - upgrading a unit
    // into itself is the one pick that can never be right.
    function pickNewTarget() {
        local baseType = this.newBaseType()
        local names = ::EUR.player_units
        if (names == null || names.len() == 0) return
        for (local i = 0; i < names.len(); i++) {
            if (names[i] == baseType) continue
            ::EUR.unit_new_target = i
            if ("handle" in ::EUR.unit_new_target_picker) {
                ::UI.selectSelected(::EUR.unit_new_target_picker.handle, i)
            }
            return
        }
    }

    // Rebind rather than push a value: the sliders then read and write the live array elements. The
    // ENTRY TABLE is part of the key, not just its name and slot - ::UI.bind holds a reference to the
    // array itself, and rebuildUpgradeLists (the "Start with T2" checkbox, same tab) swaps every
    // entry for a fresh copy under the same name, which would otherwise leave both sliders driving
    // arrays nothing reads any more.
    function refreshBindings() {
        local upgrades = this.entry()
        local slot = ::EUR.unit_adv_slot
        // All four arrays are parallel in a well-formed entry, but the table is hand-maintained and a
        // short one here would throw INSIDE a canvas draw, which takes the rest of the frame with it.
        local live = (upgrades != null && slot >= 0 && slot < upgrades.unit.len()
                      && slot < upgrades.expRequirement.len() && slot < upgrades.cost_multi.len())

        if ("handle" in ::EUR.unit_adv_exp) { ::UI.setEnabled(::EUR.unit_adv_exp.handle, live) }
        if ("handle" in ::EUR.unit_adv_cost) { ::UI.setEnabled(::EUR.unit_adv_cost.handle, live) }

        if (!live) {
            this.boundSlot = -1
            this.boundEdu = ""
            this.boundEntry = null
            this.setCostLabel("Cost")
            return
        }
        if (slot != this.boundSlot || ::EUR.unit_adv_edu != this.boundEdu || upgrades != this.boundEntry) {
            this.boundSlot = slot
            this.boundEdu = ::EUR.unit_adv_edu
            this.boundEntry = upgrades
            if ("handle" in ::EUR.unit_adv_exp) { ::UI.bind(::EUR.unit_adv_exp.handle, upgrades.expRequirement, slot) }
            if ("handle" in ::EUR.unit_adv_cost) { ::UI.bind(::EUR.unit_adv_cost.handle, upgrades.cost_multi, slot) }
        }

        local multi = upgrades.cost_multi[slot]
        local target = ::units.get(upgrades.unit[slot])
        this.setCostLabel("Cost " + ((target != null) ? ::EUR.math.ceil(target.recruitCost * multi) : oneDp(multi)))
    }

    function setCostLabel(text) {
        if (text == this.costLabel || !("handle" in ::EUR.unit_adv_cost)) return
        this.costLabel = text
        ::UI.textSet(::EUR.unit_adv_cost.handle, text)
    }

    // One button, two jobs: it opens the New entry pane, and once that pane is up it is what commits
    // the entry. Nothing else writes to UNIT_UPGRADES.
    function startOrAddUnit() {
        if (::EUR.unit_adv_mode != "new") {
            ::EUR.unit_adv_mode = "new"
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            return
        }
        this.addNew()
    }

    // Commits the New entry pane in one go - nothing above it has touched UNIT_UPGRADES.
    function addNew() {
        local baseType = this.newBaseType()
        local target = this.newTargetType()
        if (baseType == null || target == null || baseType == target) return
        if (baseType in ::EUR.UNIT_UPGRADES) return

        ::EUR.UNIT_UPGRADES[baseType] <- {
            unit = [target],
            expRequirement = [::EUR.unit_new_exp],
            cost_multi = [::EUR.unit_new_cost],
            counter = [""],
        }
        ::EUR.unit_adv_edu = baseType
        ::EUR.unit_adv_slot = 0
        ::EUR.unit_adv_mode = "edit"
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }

    function newUpgrade() {
        local upgrades = this.entry()
        if (upgrades == null || upgrades.unit.len() >= this.layout.maxUpgrades) return
        local names = ::EUR.player_units
        if (names == null || names.len() == 0) return
        upgrades.unit.append(names[0])
        upgrades.expRequirement.append(2)
        upgrades.cost_multi.append(1)
        upgrades.counter.append("")
        // Some shipped entries carry a fifth parallel array, and eurUnitUpgrades indexes it by the
        // unit slot guarded only on presence - a short one throws inside that window's draw.
        if (("faction" in upgrades) && upgrades.faction != null) { upgrades.faction.append("") }
        ::EUR.unit_adv_slot = upgrades.unit.len() - 1
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }

    function replaceEntry() {
        local upgrades = this.entry()
        local replacement = this.pickedUnit()
        if (upgrades == null || replacement == null || upgrades.unit.len() == 0) return
        local slot = ::EUR.unit_adv_slot
        if (upgrades.unit[slot] == replacement) return
        upgrades.unit[slot] = replacement
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }

    // All four arrays are parallel, so a delete has to take the same index out of each - and an
    // entry with no upgrades left goes entirely, as the Lua did.
    function deleteUpgrade() {
        local upgrades = this.entry()
        if (upgrades == null || upgrades.unit.len() == 0) return
        local slot = ::EUR.unit_adv_slot
        upgrades.unit.remove(slot)
        upgrades.expRequirement.remove(slot)
        upgrades.cost_multi.remove(slot)
        upgrades.counter.remove(slot)
        if (("faction" in upgrades) && upgrades.faction != null && upgrades.faction.len() > slot) {
            upgrades.faction.remove(slot)
        }
        if (upgrades.unit.len() == 0) {
            ::EUR.UNIT_UPGRADES.rawdelete(::EUR.unit_adv_edu)
            ::EUR.unit_adv_edu = ""
            ::EUR.unit_adv_mode = ""
        }
        ::EUR.unit_adv_slot = 0
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }

    function loadFactory() {
        ::EUR.UNIT_UPGRADES = {}
        foreach (k, v in ::EUR.UNIT_UPGRADES_default_fr) { ::EUR.UNIT_UPGRADES[k] <- ::EUR.deepCopyValue(v) }
        ::EUR.unit_adv_edu = ""
        ::EUR.unit_adv_slot = 0
        ::EUR.unit_adv_mode = ""
        this.forgetCards()
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }
}

::EUR.eurOptionsUnitADV <- eurOptionsUnitADV()

::EUR.unit_adv_section <- {
    draw = function() { ::EUR.eurOptionsUnitADV.draw() },
    w = 660, h = 600,
}

::EUR.unit_new_base_card <- {
    draw = function() { ::EUR.eurOptionsUnitADV.drawNewBaseCard() },
    w = 84, h = 84,
}

::EUR.unit_new_target_card <- {
    draw = function() { ::EUR.eurOptionsUnitADV.drawNewTargetCard() },
    w = 84, h = 84,
}

::EUR.unit_adv_title <- {
    draw = function() { ::EUR.eurOptionsUnitADV.drawTitle() },
    w = 300, h = 20,
}

::EUR.unit_adv_edit <- {
    draw = function() { ::EUR.eurOptionsUnitADV.drawEdit() },
    w = 300, h = 290,
}
