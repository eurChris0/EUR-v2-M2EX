// Dev scratchpad, ported from eopData/eopScripts/eur/dev/chrisDev.lua.
// Test scripts only - nothing here is load-bearing. What the Lua had commented out stays commented.

::EUR.map_x <- 0
::EUR.map_y <- 0
::EUR.extra_window <- false
::EUR.dev_castle <- false
::EUR.dev_level <- 0
::EUR.dev_max <- 5
::EUR.setttext <- "Lothlolien"
::EUR.sett_names <- []
::EUR.free_upkeep_list <- {}
::EUR.selectedUnit <- null
::EUR.deploy_garrison <- true
::EUR.TILES <- []

::EUR.settlement_names <- [
    "Saxonville", "Elandore", "Lindorlin", "Earendur", "Calenfeanor", "Tirithil", "Amarathorn",
    "Ilmarinor", "Alqualmire", "Galadhrim", "Ithildor", "Lothenel", "Aldawen", "Tirnanor",
    "Nimrothal", "Silmarion", "Elenithil", "Feanoldea", "Noldorinost", "Alcarinde", "Elenloth",
    "Calaquendi", "Vanyare", "Mithlondir", "Elensul", "Alduinor", "Fingolost", "Teleriand",
    "Gilthirin", "Tirionde", "Eledhion", "Calenlome", "Nimbrethil", "Taurea", "Lothendor",
    "Lindirion", "Aranlome", "Feanarel", "Lomethil", "Elentirmo", "Anoron", "Lothilion",
    "Laurefinde", "Menelluin", "Galadhrel", "Minlaurea", "Earquendi", "Celebost", "Lauremel",
    "Nimlothion", "Calenfirin",
]

::EUR.GROUND_TYPES <- {
    [0] = [85, 107, 47], [1] = [46, 85, 46], [2] = [210, 180, 140], [3] = [105, 105, 105],
    [4] = [34, 60, 34], [5] = [119, 136, 85], [6] = [60, 70, 65], [7] = [90, 60, 45],
    [8] = [110, 70, 50], [9] = [96, 105, 115], [10] = [70, 110, 130], [11] = [180, 210, 220],
    [12] = [240, 240, 240], [13] = [120, 80, 50], [14] = [139, 90, 60], [15] = [100, 100, 100],
}

::EUR.deleteItem <- function(list, index) {
    if (index < 0 || index >= list.len()) { return }
    list.remove(index)
}

::EUR.devClickAtTile <- function(x, y) {
    println(x + " " + y)
    local tile = ::stratMap.tile(x, y)
    if (tile == null) { return }
    local region = ::stratMap.region(tile.regionId)
    if (region != null) { println(region.name) }
}

// the body was entirely commented out in the Lua original; kept as the hook it was
::EUR.onSettlementSelected2 <- function(eventData) {
}

::EUR.testBu <- function() {
    local campaign = ::game.campaign()
    for (local i = 0; i < campaign.factionCount; i++) {
        local faction = campaign.factionByOrder(i)
        if (faction == null) { continue }
        for (local j = 0; j < faction.armyCount; j++) {
            local army = faction.army(j)
            if (army == null) { continue }
            for (local u = 0; u < army.unitCount; u++) {
                local unit = army.unit(u)
                if (unit != null && unit.type != null && unit.type.name == "Dunedain Wardens") {
                    unit.setParams(4, 4, 1)
                }
            }
        }
    }
}

::EUR.convertCoordinates <- function(x, y, scale, offsetX, offsetY) {
    return [x * scale + offsetX, y * scale + offsetY]
}

::EUR.getBattleTiles <- function(thisBattle) {
    println("filling tiles")
    ::EUR.TILES = []
    if (thisBattle == null) { return }
    for (local i = 0; i <= thisBattle.mapWidth; i++) {
        for (local j = 0; j <= thisBattle.mapWidth; j++) {
            if ((i % 25 == 0) && (j % 25 == 0)) {
                local tile = thisBattle.tileAt(i, j)
                if (tile != null) { ::EUR.TILES.append([i, j, tile.groundType]) }
            }
        }
    }
}

// the whole body was already commented out in the Lua; mapImageStruct has no squ equivalent
::EUR.importMap <- function(thisBattle) {
}

::EUR.freeUp <- function() {
    ::EUR.free_upkeep_list = { free = {}, not_free = {} }
    local playerId = ::game.localFactionId()
    for (local i = 0; i < ::units.count(); i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry == null) { continue }
        if (!eduEntry.hasOwnership(playerId)) { continue }
        if (eduEntry.upkeep > 0 && eduEntry.upkeep < 400) {
            ::EUR.free_upkeep_list.free[eduEntry.name] <- eduEntry.upkeep
        } else if (eduEntry.upkeep > 0) {
            ::EUR.free_upkeep_list.not_free[eduEntry.name] <- eduEntry.upkeep
        }
    }
}

::EUR.cardtest <- function() {
    local cardManager = ::ui.cardManager()
    ::game.log("cardManager ok")
    if (cardManager == null) { return }
    ::game.log("selectedUnitCount " + cardManager.selectedUnitCount)
    ::EUR.selectedUnit = cardManager.selectedUnit(0)
    if (::EUR.selectedUnit != null) { ::game.log("selectedUnit ok") }
}

::EUR.dev_groups <- [
    { name = "group1", list = ["Dunedain Wardens", "Dunedain Wardens", "Dunedain Wardens"] },
    { name = "group2", list = ["Dunedain Rangers", "Dunedain Rangers"] },
]
::EUR.groups_set <- false

::EUR.groupTest <- function() {
    local thisBattle = ::battle.current()
    if (thisBattle == null) { return }
    if (thisBattle.phase != 5) { return }
    local playerArmy = thisBattle.playerArmy(0)
    if (playerArmy == null) { return }
    if (::EUR.groups_set) { return }

    local gathered = []
    for (local i = 0; i < playerArmy.unitCount; i++) {
        local unit = playerArmy.unit(i)
        if (unit != null && unit.group == null && unit.type != null) {
            gathered.append({ name = unit.type.name, set = false, index = i })
        }
    }

    local created = {}
    foreach (gi, group in ::EUR.dev_groups) {
        foreach (targetName in group.list) {
            foreach (entry in gathered) {
                if (entry.set || entry.name != targetName) { continue }
                entry.set = true
                local playerUnit = playerArmy.unit(entry.index)
                if (playerUnit == null) { break }
                if (!(gi in created)) {
                    created[gi] <- playerArmy.defineUnitGroup(group.name, playerUnit)
                } else {
                    created[gi].addUnit(playerUnit)
                }
                break
            }
        }
    }
    ::EUR.groups_set = true
}

::EUR.testje <- function() {
    local campaign = ::game.campaign()
    for (local i = 0; i < campaign.settlementCount; i++) {
        local sett = campaign.settlement(i)
        if (sett != null && sett.owner != null && sett.owner.name == "normans") {
            ::game.models.setOnTile(sett.tileX, sett.tileY, 1, 1)
        }
    }
}

::EUR.clearGarrison <- function(sett) {
    if (sett == null || sett.army == null) { return }
    for (local i = sett.army.unitCount - 1; i >= 0; i--) {
        local unit = sett.army.unit(i)
        if (unit != null && unit.name == "test") {
            ::EUR.deploy_garrison = false
            unit.kill()
        }
    }
    ::EUR.dep_gar_switch()
}

::EUR.dep_gar_switch <- function() {
    ::EUR.deploy_garrison = true
}

// noAttack / checkGarrison read the live selection (M2TW.selectionInfo). ui.cardManager() does expose
// selectedCharacter / hoveredSettlement, but the house rule is that the game-UI accessors answer
// "is a panel open", never supply state - so these stay off until that call is made.
// ::EUR.noAttack <- function() { ... }
// ::EUR.checkGarrison <- function() { ... }

::EUR.testexpand <- function() {
    local settlement = ::stratMap.findSettlement("South_Enedwaith")
    if (settlement == null || settlement.owner == null) { return }
    if (settlement.owner.name != "slave") { return }
    local army = ::EUR.eurSpawnArmy("teutonic_order", "random_name", "enedwaith_attackers_5", "", true, 31, "Mountain Uruks", 179, 256, 2, 1, 1)
    if (army == null) { return }
    army.createUnit("Clan Heralds", 3, 0, 0)
    army.createUnit("Liadan Spearmen", 2, 0, 0)
    army.createUnit("Dubhshith Foresters", 2, 0, 0)
    if (army.leader == null || army.leader.record == null) { return }
    local rec = army.leader.record
    foreach (t in [["MiddleManRace", 1], ["EnedwaithClansman", 1], ["AIBoost", 1], ["Berserker", 1],
                   ["GoodAmbusher", 2], ["GoodCommander", 2], ["Loyal", 2], ["LoyaltyStarter", 1],
                   ["NightBattleCapable", 1], ["PietyStarter", 1]]) {
        rec.addTrait(t[0], t[1])
    }
}

::EUR.setEMT <- function(sett) {
    if (sett == null) { return }
    if (sett.name == "Weather_Hills") {
        ::game.setText("EMT_TURKS_FACTION_LEADER", "High King")
    } else {
        ::game.setText("EMT_TURKS_FACTION_LEADER", "Dudejemans")
    }
}

::EUR.gondor_fiefs <- {
    Lossarnach   = { ids = [180], r = 140, g = 80,  b = 100 },
    Lebennin     = { ids = [178, 191, 194, 188], r = 60, g = 110, b = 50 },
    Belfalas     = { ids = [193, 186], r = 20, g = 50, b = 100 },
    Lamedon      = { ids = [176], r = 120, g = 100, b = 70 },
    Anfalas      = { ids = [185, 163], r = 160, g = 140, b = 110 },
    Morothond    = { ids = [174, 157], r = 50, g = 55, b = 60 },
    RingloVale   = { ids = [165], r = 55, g = 100, b = 70 },
    PinnathGelin = { ids = [173], r = 40, g = 90, b = 50 },
}

::EUR.regionID_to_fief <- {}
foreach (fief, data in ::EUR.gondor_fiefs) {
    foreach (id in data.ids) { ::EUR.regionID_to_fief[id] <- fief }
}

::EUR.setBannerColors <- function(faction) {
    if (faction == null) { return }
    for (local i = 0; i < faction.settlementCount; i++) {
        local settlement = faction.settlement(i)
        if (settlement == null || settlement.army == null) { continue }
        if (!(settlement.regionId in ::EUR.regionID_to_fief)) { continue }
        local colour = ::EUR.gondor_fiefs[::EUR.regionID_to_fief[settlement.regionId]]
        settlement.army.bannerRed = colour.r
        settlement.army.bannerGreen = colour.g
        settlement.army.bannerBlue = colour.b
        settlement.army.usesOwnBannerColour = true
    }
}

// checks every unit name in the mod's unit lists against the EDU
::EUR.validateAllUnits <- function() {
    println("=== Starting Unit Validation ===")
    local counts = { total = 0, notFound = 0 }

    local checkName = function(unitName, where) {
        counts.total++
        if (::units.get(unitName) == null) {
            println("  " + unitName + " - not found" + where)
            counts.notFound++
        }
    }

    foreach (listName in ["gen_units_list_default", "gen_units_list_default2"]) {
        println("--- Validating " + listName + " ---")
        foreach (faction, tiers in ::EUR[listName]) {
            foreach (tier, units in tiers) {
                foreach (unitName in units) { checkName(unitName, "") }
            }
        }
    }

    println("--- Validating leaderheir_combi_list ---")
    foreach (faction, roles in ::EUR.leaderheir_combi_list) {
        checkName(roles.leader.unit, " (leader)")
        checkName(roles.heir.unit, " (heir)")
    }

    println("--- Validating SWAP_GARRISON ---")
    foreach (faction, data in ::EUR.SWAP_GARRISON) {
        foreach (unitName in data["new"]) { checkName(unitName, "") }
    }

    println("--- Validating SETT_GARRISONS ---")
    foreach (faction, settlements in ::EUR.SETT_GARRISONS) {
        foreach (settlement, enemyFactions in settlements) {
            foreach (enemyFaction, garrisonUnits in enemyFactions) {
                foreach (unitEntry in garrisonUnits) {
                    checkName(unitEntry[0], " (settlement: " + settlement + ", vs: " + enemyFaction + ")")
                }
            }
        }
    }

    println("=== Validation Complete ===")
    println("Total units checked: " + counts.total)
    println("Units not found: " + counts.notFound)
    println("Units valid: " + (counts.total - counts.notFound))
}

::EUR.addStacks <- function() {
    local faction_list = [
        "aztecs", "byzantium", "denmark", "england", "france", "gundabad", "hre", "hungary",
        "ireland", "khand", "milan", "mongols", "moors", "normans", "norway", "poland",
        "portugal", "russia", "saxons", "scotland", "sicily", "spain", "teutonic_order",
        "timurids", "turks", "venice",
    ]
    local campaign = ::game.campaign()
    for (local i = 5; i < faction_list.len(); i++) {
        local faction = campaign.factionByName(faction_list[i])
        if (faction == null || faction == ::EUR.eur_player_faction) { continue }
        if (faction.capital == null) { continue }
        local pool = ::EUR.gen_units_list[faction.name]
        local army = ::EUR.eurSpawnArmy(faction.name, "random_name", "leg_", "", false, 18,
                                        pool["special"][0], faction.capital.tileX, faction.capital.tileY, 3, 1, 0)
        if (army == null) { continue }
        for (local n = 0; n < 5; n++) {
            army.createUnit(pool["T2"][::EUR.math.random(0, pool["T2"].len() - 1)], 0, 0, 0)
        }
        for (local n = 0; n < 10; n++) {
            army.createUnit(pool["T1"][::EUR.math.random(0, pool["T1"].len() - 1)], 0, 0, 0)
        }
    }
}

::EUR.dev_unique_names <- []
::EUR.dev_unique_labels <- []

::EUR.devFixCharUniqueName <- function(char) {
    if (char == null || char.record == null) { return }
    if (!::EUR.tableContains(::EUR.dev_unique_names, char.record.shortName)) { return }
    if (::EUR.tableContains(::EUR.dev_unique_labels, char.record.label)) { return }
    char.record.randomiseName()
}

::EUR.charsOff <- function() {
    local faction = ::EUR.eur_player_faction
    if (faction == null) { return }
    for (local i = 0; i < faction.characterCount; i++) {
        local char = faction.character(i)
        if (char == null || char.record == null) { continue }
        println(char.record.fullName)
        println("" + char.typeId)
        if (char.typeId != ::Enum.CharacterType.namedCharacter) { continue }
        if (char.record.isHeir()) {
            //
        } else if (char.record.isLeader()) {
            //
        } else {
            // char.sendOffMap()
        }
    }
}

// deferred callbacks counted in campaign ticks; execute() is driven from a per-turn hook
::EUR.CAMPAIGN_WAIT <- { tick = 0, callbacks = [] }

::EUR.CAMPAIGN_WAIT.wait <- function(duration, callback) {
    ::EUR.CAMPAIGN_WAIT.callbacks.append({
        tick = ::EUR.CAMPAIGN_WAIT.tick + duration,
        callback = callback,
        hasFired = false,
    })
}

::EUR.CAMPAIGN_WAIT.waitSeconds <- function(duration, callback) {
    ::EUR.CAMPAIGN_WAIT.wait(duration * 10, callback)
}

::EUR.CAMPAIGN_WAIT.execute <- function() {
    ::EUR.CAMPAIGN_WAIT.tick++
    local live = []
    foreach (element in ::EUR.CAMPAIGN_WAIT.callbacks) {
        if (::EUR.CAMPAIGN_WAIT.tick >= element.tick && !element.hasFired) {
            element.hasFired = true
            if (element.callback != null) { element.callback() }
        } else {
            live.append(element)
        }
    }
    ::EUR.CAMPAIGN_WAIT.callbacks = live
}

// ============================================================================
// The dev window: a button strip bottom-left, and a panel behind the Window button.
// ============================================================================
class chrisDev {
    windowScroll = null
    windowCanvas = 0
    buttons = null
    shown = false

    function ensure() {
        if (this.windowScroll != null) return
        local self = this

        ::UI.pushStyle(::EUR.eurStyles.basic_4)

        this.windowScroll = ::EUR.scroll.create(700, 500, 0, 0, function() { ::EUR.extra_window = false })
        this.windowCanvas = ::UI.canvas(0, 0)
        ::UI.canvasDraw(this.windowCanvas, function() { self.devWindow() })

        ::UI.setParent(0)
        this.buttons = {}
        this.buttons.console <- ::UI.button("console", 80, 80)
        ::UI.buttonClick(this.buttons.console, function() { ::game.toggleConsole() })

        this.buttons.window <- ::UI.button("Window", 80, 80)
        ::UI.buttonClick(this.buttons.window, function() { ::EUR.extra_window = !::EUR.extra_window })

        this.buttons.reset <- ::UI.button("reset", 80, 80)
        ::UI.buttonClick(this.buttons.reset, function() {
            ::game.reloadScripts()
            println("----script reload----")
        })

        this.buttons.icm <- ::UI.button("ICM", 80, 80)
        ::UI.buttonClick(this.buttons.icm, function() {
            ::EUR.in_campaign_map = true
            ::EUR.eurGlobalVars()
            ::EUR.startLog(::game.modPath())
            ::EUR.loadImages()
            ::EUR.loadSounds()
        })

        this.buttons.validate <- ::UI.button("Validate units", 140, 24)
        ::UI.buttonClick(this.buttons.validate, function() { ::EUR.validateAllUnits() })

        this.buttons.freeUp <- ::UI.button("Free upkeep", 140, 24)
        ::UI.buttonClick(this.buttons.freeUp, function() { ::EUR.freeUp() })

        this.buttons.stacks <- ::UI.button("Add stacks", 140, 24)
        ::UI.buttonClick(this.buttons.stacks, function() { ::EUR.addStacks() })

        this.buttons.charsOff <- ::UI.button("Chars off", 140, 24)
        ::UI.buttonClick(this.buttons.charsOff, function() { ::EUR.charsOff() })

        this.buttons.addSett <- ::UI.button("Add Sett", 100, 24)
        ::UI.buttonClick(this.buttons.addSett, function() { self.addSett() })

        this.buttons.rand <- ::UI.button("Rand", 100, 24)
        ::UI.buttonClick(this.buttons.rand, function() {
            ::EUR.setttext = ::EUR.settlement_names[::EUR.math.random(0, ::EUR.settlement_names.len() - 1)]
        })

        ::UI.popStyle()

        ::UI.setParent(0)
        ::UI.widgetVisible(this.windowScroll.window, false)
        foreach (k, b in this.buttons) { ::UI.widgetVisible(b, false) }
    }

    // the panel body: tile readout and the settlement-spawn controls
    function devWindow() {
        local rect = ::UI.widgetRectGet(this.windowScroll.window)
        if (rect == null) { return }
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) { return }
        local x = rect[0] + margins[0]
        local y = rect[1] + margins[1]

        local tile = ::stratMap.tile(::EUR.map_x, ::EUR.map_y)
        if (tile != null && tile.resource != null) {
            ::UI.layoutAt(x, y); ::UI.text("resource " + tile.resource.type); y += 18
        }
        if (!::EUR.checkTileEmpty(::EUR.map_x, ::EUR.map_y)) {
            ::UI.layoutAt(x, y); ::UI.textColoured("Invalid Tile", 255, 0, 0, 255); y += 18
        }
        ::UI.layoutAt(x, y); ::UI.text("x " + ::EUR.map_x); y += 18
        ::UI.layoutAt(x, y); ::UI.text("y " + ::EUR.map_y); y += 18

        ::EUR.dev_max = ::EUR.dev_castle ? 4 : 5
        ::UI.layoutAt(x, y); ::UI.text("Level " + ::EUR.dev_level + " / " + ::EUR.dev_max); y += 22

        ::UI.layoutAt(x + 110, y + 4); ::UI.text(::EUR.setttext)
        if (::EUR.tableContains(::EUR.sett_names, ::EUR.setttext)) {
            ::UI.layoutAt(x + 110, y + 22); ::UI.textColoured("Name Taken", 255, 0, 0, 255)
        }

        ::UI.widgetRect(this.buttons.rand, x, y, 100, 24)
        ::UI.widgetRect(this.buttons.addSett, x, y + 44, 100, 24)
        ::UI.widgetRect(this.buttons.validate, x, y + 78, 140, 24)
        ::UI.widgetRect(this.buttons.freeUp, x + 150, y + 78, 140, 24)
        ::UI.widgetRect(this.buttons.stacks, x, y + 108, 140, 24)
        ::UI.widgetRect(this.buttons.charsOff, x + 150, y + 108, 140, 24)
    }

    function addSett() {
        if (!::EUR.checkTileEmpty(::EUR.map_x, ::EUR.map_y)) { return }
        if (::EUR.tableContains(::EUR.sett_names, ::EUR.setttext)) { return }
        local rebels = ::game.campaign().factionByName("sicily")
        if (rebels == null) { return }
        local sett = rebels.foundSettlement(::EUR.map_x, ::EUR.map_y, ::EUR.setttext, ::EUR.dev_level, ::EUR.dev_castle)
        if (sett == null) { println("Adding sett failed: " + ::EUR.map_x + " " + ::EUR.map_y); return }
        ::EUR.sett_names.append(::EUR.setttext)
        ::EUR.setttext = ::EUR.settlement_names[::EUR.math.random(0, ::EUR.settlement_names.len() - 1)]
    }

    // battle overview: one letter per player unit, at its battlefield position
    function battleOverview() {
        local thisBattle = ::battle.current()
        if (thisBattle == null) { return }
        local player = thisBattle.playerArmy(0)
        if (player == null) { return }

        local screen = ::UI.screenSize()
        local targetW = screen[0] - 400
        local targetH = screen[1] - 100
        local scale = ::EUR.math.min(targetW.tofloat() / thisBattle.mapWidth, targetH.tofloat() / thisBattle.mapHeight)
        local originX = 200 + (targetW - thisBattle.mapWidth * scale) / 2
        local originY = 10 + (targetH - thisBattle.mapHeight * scale) / 2

        for (local i = 0; i < player.unitCount; i++) {
            local unit = player.unit(i)
            if (unit == null || unit.type == null) { continue }
            local mark = "O"
            if (unit.type.unitClass == ::Enum.UnitClass.missile) { mark = "M" }
            else if (unit.type.unitClass == ::Enum.UnitClass.light) { mark = "L" }
            else if (unit.type.unitClass == ::Enum.UnitClass.heavy) { mark = "H" }
            else if (unit.type.unitClass == ::Enum.UnitClass.spearmen) { mark = "S" }

            ::UI.layoutAt((originX + targetW / 2 + unit.x * scale).tointeger(),
                          (originY + targetH / 2 + unit.y * scale).tointeger())
            ::UI.text(mark)
        }
    }

    function render() {
        if (!::EUR.chris_stuff) { return }
        this.ensure()

        local screen = ::UI.screenSize()
        local bx = 10
        local by = screen[1] - 190
        ::UI.widgetRect(this.buttons.console, bx, by, 80, 80)
        ::UI.widgetRect(this.buttons.window, bx + 86, by, 80, 80)
        ::UI.widgetRect(this.buttons.reset, bx, by + 86, 80, 80)
        ::UI.widgetRect(this.buttons.icm, bx + 86, by + 86, 80, 80)
        foreach (k, b in ["console", "window", "reset", "icm"]) { ::UI.widgetVisible(this.buttons[b], true) }

        if (::EUR.extra_window != this.shown) {
            ::UI.widgetVisible(this.windowScroll.window, ::EUR.extra_window)
            foreach (b in ["rand", "addSett", "validate", "freeUp", "stacks", "charsOff"]) {
                ::UI.widgetVisible(this.buttons[b], ::EUR.extra_window)
            }
            this.shown = ::EUR.extra_window
        }
        if (::EUR.extra_window) {
            ::UI.widgetRect(this.windowScroll.window, (screen[0] - 700) / 2, (screen[1] - 500) / 2, 700, 500)
            ::UI.raise(this.windowScroll.window)
        }
    }
}

::EUR.chrisDev <- chrisDev()
::UI.onFrame(function() { ::EUR.chrisDev.render() })
