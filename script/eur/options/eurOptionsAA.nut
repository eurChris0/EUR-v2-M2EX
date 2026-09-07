// Ar-Adunaim alternate start. Ported from eurHistoricEventText.lua (the AA half, lines 1140-1421);
// the historic-event text half of that file is a separate port.
// Choice is 0-based here: 0 = Umbar, the descr_strat start, which repositions nothing.

::EUR.alt_startAA <- [
    {
        title = "Umbar",
        body = @"A haven of Corsairs on the southern coast. Black stone walls and timber docks shelter pirate fleets. Once Numenorean, now a den of outlaws and raiders, defiant against Gondor's rule. Salt, intrigue, and rebellion perfume the air of this enduring thorn in the Reunited Kingdom's side.",
        units1 = ["Rozadan Footmen", "Rozadan Halberdiers", "Rozadan Bowmen"],
        units2 = ["Castamirs Chosen"],
        units3 = ["Numenorean Marines"],
        multi = ["?", "?", "?"]
    },
    {
        title = "The Sea of Rhun",
        body = @"A vast expanse on the eastern shores of Middle-earth, cradles remnants of a forgotten age. Its shores are lined with crumbling stone docks and weather-beaten watchtowers, echoing the glories of an era when trade thrived and fleets commanded respect across the waters. Once a vibrant hub for merchants and seafarers, it now languishes under the weight of time.",
        units1 = ["Rozadan Footmen", "Rozadan Halberdiers", "Rozadan Bowmen"],
        units2 = ["Castamirs Chosen"],
        units3 = ["Numenorean Marines"],
        multi = ["?", "?", "?"]
    },
    {
        title = "Lond Daer",
        body = @"Ancient Numenorean port on the western shores of Middle-earth. Crumbling stone quays and weathered fortifications stand testament to faded glory. Once a bustling haven of trade and naval might, now a haunt of gulls and restless spirits. Salt-worn ruins whisper tales of Tar-Aldarion's ambition and the rise of Numenor's sea-power.",
        units1 = ["Rozadan Footmen", "Rozadan Halberdiers", "Rozadan Bowmen"],
        units2 = ["Castamirs Chosen"],
        units3 = ["Numenorean Marines"],
        multi = ["?", "?", "?"]
    },
    {
        title = "Forodwaith",
        body = @"A merciless expanse of ice and snow in Middle-earth's uttermost north. Howling winds sculpt endless white plains beneath a pale, unforgiving sky. The Ice Bay of Forochel's frozen fingers claw at the land. Here, the hardy Lossoth endure, defying nature's harshest whims. Bitter cold and isolation pervade this realm at the edge of the known world.",
        units1 = ["Rozadan Footmen", "Rozadan Halberdiers", "Rozadan Bowmen"],
        units2 = ["Castamirs Chosen"],
        units3 = ["Numenorean Marines"],
        multi = ["?", "?", "?"]
    }
]

::EUR.alt_startAA_choice <- 0

::EUR.ALT_START_AA_PLACEMENT <- {
    [1] = { cull = 7, at = [[455, 347], [454, 348], [456, 348], [472, 326], [454, 342], [456, 342]], camera = [455, 347] },
    [2] = { cull = 5, at = [[135, 289], [137, 285], [136, 285], [137, 277], [137, 277], [135, 277]], camera = [135, 289] },
    [3] = { cull = 5, at = [[162, 461], [159, 465], [162, 468], [156, 473], [156, 473], [154, 473]], camera = [162, 461] }
}

::EUR.repositionAA <- function() {
    if (!(::EUR.alt_startAA_choice in ::EUR.ALT_START_AA_PLACEMENT)) return

    local chars = []
    foreach (label in ["bn_army_1", "bn_army_2", "bn_army_3", "bn_army_4"]) {
        local rec = ::EUR.getnamedCharbyLabel(label)
        if (rec == null || rec.character == null) return
        chars.append(rec.character)
    }

    local faction = ::EUR.eur_player_faction
    if (faction == null) return
    local zagarakhor = null
    local indrazor = null
    for (local j = 0; j < faction.characterCount; j++) {
        local char = faction.character(j)
        if (char == null || char.record == null) continue
        if (char.record.shortName == "Zagarakhor") { zagarakhor = char }
        else if (char.record.shortName == "Indrazor") { indrazor = char }
    }
    if (zagarakhor == null || indrazor == null) return
    chars.append(zagarakhor)
    chars.append(indrazor)

    local plan = ::EUR.ALT_START_AA_PLACEMENT[::EUR.alt_startAA_choice]

    local army = chars[0].army
    if (army != null) {
        for (local i = army.unitCount - 1; i >= army.unitCount - plan.cull && i >= 0; i--) {
            local un = army.unit(i)
            if (un != null) { un.kill() }
        }
    }

    for (local i = 0; i < chars.len(); i++) {
        chars[i].relocate(plan.at[i][0], plan.at[i][1])
    }
    ::stratMap.jumpCamera(plan.camera[0], plan.camera[1])
}

::EUR.ALT_START_AA_SPOTS <- [
    [0.62, 0.86],   // Umbar
    [0.87, 0.55],   // Sea of Rhun
    [0.51, 0.62],   // Lond Daer
    [0.52, 0.34],   // Forodwaith
]

local aaTab = {
    w = 0, h = 0,
    showFn = function() {
        return ::EUR.eur_player_faction != null && ::EUR.eur_player_faction.name == "russia"
    }
}

aaTab.draw <- function() {
    local r = ::authored.rect(::UI.widgetRectGet(aaTab.canvas))
    if (r == null || r[2] < 64 || r[3] < 64) {
        local screen = ::authored.screen()
        r = [20, 60, screen[0] - 40, screen[1] - 80]
    }

    local panelW = 300
    local mapW = r[2] - panelW - 12
    local mapH = r[3]
    if (mapW < 64 || mapH < 64) return

    if (::EUR.map1 != null) { ::UI.image(::EUR.map1.img, mapW, mapH, r[0], r[1]) }

    local icon = 50
    for (local i = 0; i < ::EUR.alt_startAA.len(); i++) {
        local spot = ::EUR.ALT_START_AA_SPOTS[i]
        local ix = r[0] + (mapW * spot[0]).tointeger() - icon / 2
        local iy = r[1] + (mapH * spot[1]).tointeger() - icon / 2
        local tint = (i == ::EUR.alt_startAA_choice) ? 255 : 150

        if (::EUR.aa_icon != null && ::UI.imageButton(::EUR.aa_icon.img, icon, icon, ix, iy, 255, 255, 255, tint).clicked) {
            ::EUR.alt_startAA_choice = i
        }
        ::UI.tooltipAt(ix, iy, icon, icon)
        ::UI.tooltip(0, ::EUR.alt_startAA[i].title)
    }

    ::EUR.eurOptionsAA.sidePanel(r[0] + mapW + 12, r[1], panelW)
}

::EUR.EUR_OPTION_TABS.append({ title = "Alternate Start", sections = [[aaTab]],
                               showFn = function() {
                                   return ::EUR.eur_player_faction != null
                                          && ::EUR.eur_player_faction.name == "russia"
                               } })

class eurOptionsAA {
    cardCache = null

    function unitCard(eduType) {
        if (this.cardCache == null) { this.cardCache = {} }
        if (eduType in this.cardCache) return this.cardCache[eduType]
        local unitType = ::units.get(eduType)
        local faction = (::EUR.eur_player_faction != null) ? ::EUR.eur_player_faction.name : ""
        local texture = (unitType != null) ? ::UI.loadTexture(unitType.cardPath(faction)) : null
        this.cardCache[eduType] <- texture
        return texture
    }

    function portrait(shortName) {
        local faction = ::EUR.eur_player_faction
        if (faction == null) return null
        for (local i = 0; i < faction.characterCount; i++) {
            local char = faction.character(i)
            if (char == null || char.record == null) continue
            if (char.record.shortName == shortName) { return ::UI.loadTexture(char.record.portraitPath) }
        }
        return null
    }

    // one leader row: portrait, then that leader's unit cards, then the name and the tally
    function leaderRow(x, y, w, shortName, label, units, counts) {
        local card = 50
        local px = x
        local pic = this.portrait(shortName)
        if (pic != null) { ::UI.image(pic.img, card, card, px, y); px += card + 2 }

        foreach (name in units) {
            local uc = this.unitCard(name)
            if (uc != null) {
                if (px + card > x + w) { px = x; y += card + 2 }
                ::UI.image(uc.img, card, card, px, y)
                px += card + 2
            }
        }
        y += card + 4

        ::UI.layoutAt(x, y)
        ::UI.text(label)
        y += 18

        foreach (line in counts) {
            ::UI.layoutAt(x, y)
            ::UI.textColoured(line.n, line.r, line.g, line.b, 255)
            ::UI.layoutAt(x + 20, y)
            ::UI.text(line.what)
            y += 18
        }
        return y + 6
    }

    function sidePanel(x, y, w) {
        local choice = ::EUR.alt_startAA[::EUR.alt_startAA_choice]
        local ok = (::EUR.alt_startAA_choice == 0)

        ::UI.pushStyle({ [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = w })
        ::UI.layoutAt(x, y)
        ::UI.text(choice.title)
        ::UI.popStyle()
        y += 24

        ::UI.layoutAt(x, y)
        ::UI.textWrapped(choice.body, w)
        y += ::UI.textSize(choice.body, 0, 0, w)[1] + 8

        if (!ok) {
            ::UI.layoutAt(x, y)
            ::UI.textWrapped("(Some of our men may be lost undertaking this journey.)", w)
            y += 32
        }

        local r = ok ? 0 : 255
        local g = ok ? 255 : 0
        y = this.leaderRow(x, y, w, "Gimilkhad", "Ar-Gimilkhad", choice.units1, [
            { n = choice.multi[0], what = "x Belegaer Footmen", r = r, g = g, b = 0 },
            { n = choice.multi[1], what = "x Belegaer Pikemen", r = r, g = g, b = 0 },
            { n = choice.multi[2], what = "x Belegaer Archers", r = r, g = g, b = 0 },
        ])
        y = this.leaderRow(x, y, w, "Gimilzor", "Lord Gimilzor", choice.units2, [
            { n = "1", what = "x Naru n'Aru Sentinels", r = 0, g = 255, b = 0 },
        ])
        y = this.leaderRow(x, y, w, "Gimilthon", "Gimilthon", choice.units3, [
            { n = "1", what = "x Numenorean Cohort", r = 0, g = 255, b = 0 },
        ])
    }
}

::EUR.eurOptionsAA <- eurOptionsAA()
