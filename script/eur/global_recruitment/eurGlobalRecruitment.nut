::EUR.global_settlement <- null
::EUR.global_recruit_current <- 0
::EUR.global_range <- 2500
::EUR.global_cost_mod <- 1.5
::EUR.UNIT_FILTER <- {}
::EUR.UNIT_FILTER_notif <- {}
::EUR.notif_count <- 0
::EUR.sett_info <- {}
::EUR.sett_list <- []
::EUR.sett_list_outrange <- []
::EUR.sett_distance_list <- {}

class eurGlobalRecruitment {
    layout = {
        windowX = 0, windowY = 0, windowW = 960, windowH = 835,
        bgInsetX = -55, bgInsetY = 25,
        bgOffsetX = 0, bgOffsetY = -10,
        bgWidthDelta = 0, bgHeightDelta = 64,
        headingOffsetY = -40, headingFontSize = 0, bodyFontSize = 12,
        contentInsetX = 20,
        sectionOffsetX = -40, sectionOffsetY = 20, sectionWidthDelta = 60,

        optionsX = 40, optionsY = 35,
        optionRowStepY = 22,
        filterRowY = 40, filterRowGapX = 12,
        listScrollStep = 30, scrollBarW = 12, scrollBarMinH = 24,
        scrollTrack = [0, 0, 0, 60],
        scrollGrab = [90, 90, 90, 200], scrollGrabHover = [130, 130, 130, 220],
        scrollGrabHeld = [170, 170, 170, 235],

        filterCardW = 64, filterCardH = 64, filterCardGapX = 0, filterCardGapY = 0,
        filterGapY = -20, filterMaxRows = 4,
        filterLit = [255, 255, 255, 26], filterDim = [0, 0, 0, 102],
        filterHoverLift = 38, filterHeldLift = 76,
        notifLit = [255, 255, 255, 13], notifDim = [0, 0, 0, 140],
        notifHoverLift = 20, notifHeldLift = 40,

        queueLabelGapY = 10, queueLabelRowH = 22,
        queueCardW = 64, queueCardH = 64, queueCardGapX = 0, queueCardGapY = 0, queueRowGapY = 10,
        queueTint = [255, 255, 255, 26],
        queueHoverLift = 38, queueHeldLift = 76,
        settlementsGapY = 10, contentBottomInset = 16,
        settlementNameW = 170, settlementNameH = 66, settlementColumnGapX = 10, settlementRowGapY = 0,
        settlementNameTextY = 6, settlementCountY = 30,
        separatorGapY = 0,
        cardW = 64, cardH = 64, cardGapX = 0, cardGapY = 0, cardRowPadY = 2, dimCardAlpha = 110,
        cardPoolOffsetX = 46, cardPoolOffsetY = 5,

        chevronW = 10, chevronH = 5, chevronX = 1, chevronY = 18, chevronStepY = 4,
        pipW = 11, pipH = 8, pipX = 0, swordMissileY = 27, swordMeleeY = 29, shieldY = 38,
        toggleButtonX = 980, toggleButtonY = 590, toggleButtonW = 50, toggleButtonH = 50,
        toggleButtonLift = 60,
    }

    scroll = null
    canvas = 0
    buttonCanvas = 0
    sortAzCheck = 0
    sortDistanceCheck = 0
    hideEmptyCheck = 0
    filterCheck = 0
    notifCheck = 0
    cardCache = null
    statsCache = null
    creating = false
    checking = false
    raised = false
    filterOpen = false
    notifOpen = false
    singleFilter = false
    singleFilterTarget = ""
    listScroll = 0
    listHeight = 0
    scrollGrabOffset = -1
    scrollDragging = false
    shownLast = false
    fontSet = false
    pendingRefresh = false

    function checkSettRange(remoteX, remoteY, centralX, centralY) {
        if (remoteX == null || remoteY == null || centralX == null || centralY == null) {
            return false
        }
        local deltaX = remoteX - centralX
        local deltaY = remoteY - centralY
        return deltaX < ::EUR.global_range && deltaX > -::EUR.global_range
            && deltaY < ::EUR.global_range && deltaY > -::EUR.global_range
    }

    function armourFor(unit, requestedArmour) {
        local best = 0
        local levelCount = unit.armourTierCount()
        if (levelCount == null) {
            return best
        }
        for (local level = 0; level < levelCount; level++) {
            local threshold = unit.armourLevel(level)
            if (threshold != null && requestedArmour >= threshold) {
                best = level
            }
        }
        return best
    }

    function freeQueueSlot(localName, eduType) {
        for (local slot = 0; slot <= 100; slot++) {
            if (!((localName + eduType + slot) in ::EUR.global_recruits)) {
                return slot
            }
        }
        return 0
    }

    function globalRecruitment(localSett, remoteSett, unit, poolIndex, time, cost, exp, armour, weaponBlade, weaponMech) {
        local isMissile = unit.hasProjectile(0)
        local isMelee = !unit.hasProjectile(0)

        local weapon = 0
        if (isMelee && weaponBlade > 0) {
            weapon = weaponBlade
        } else if (isMissile && weaponMech > 0) {
            weapon = weaponMech
        }

        local slot = this.freeQueueSlot(localSett.name, unit.name)
        ::EUR.global_recruits[localSett.name + unit.name + slot] <- {
            local_sett = localSett.name,
            remote_sett = remoteSett.name,
            eduEntry = unit.name,
            cost = cost,
            time = time,
            exp = exp,
            weapon = weapon,
            armour = this.armourFor(unit, armour),
        }

        local pool = this.poolFor(remoteSett, poolIndex)
        local left = ((pool != null) ? pool.available : 0.0) - 1.0
        if (left < 0.0) { left = 0.0 }
        remoteSett.setRecruitPool(poolIndex, left)

        ::game.runConsoleCommand("add_money", "-" + cost)
        this.recruitCheckGlobal()
    }

    function globalClearLostSett(sett) {
        if (sett == null) {
            return
        }
        local toRemove = []
        foreach (key, entry in ::EUR.global_recruits) {
            if (entry != null && sett.name == entry.remote_sett) {
                toRemove.append(key)
            }
        }
        foreach (key in toRemove) {
            ::EUR.global_recruits.rawdelete(key)
        }
    }

    function refundToPool(sett, eduEntry, cost) {
        local capability = null
        for (local capIndex = 0; capIndex < sett.recruitCapabilityCount; capIndex++) {
            local candidate = sett.recruitCapability(capIndex)
            if (candidate != null && candidate.unitTypeIndex == eduEntry.index) {
                capability = candidate
            }
        }
        if (capability == null) {
            return
        }

        local pool = this.poolFor(sett, eduEntry.index)
        local restored = ((pool != null) ? pool.available : 0.0) + 1.0
        local ceiling = capability.maxSize.tofloat()
        if (restored > ceiling) { restored = ceiling }
        sett.setRecruitPool(eduEntry.index, restored)

        ::game.runConsoleCommand("add_money", "+" + cost)
    }

    function findNearbySettlement(sett) {
        local best = null
        local bestDistance = 0
        local faction = sett.owner
        for (local index = 0; index < faction.settlementCount; index++) {
            local candidate = faction.settlement(index)
            if (candidate.name == sett.name) {
                continue
            }
            if (candidate.army && candidate.army.unitCount >= 20) {
                continue
            }
            local distance = ::EUR.getDistance(sett.tileX, sett.tileY, candidate.tileX, candidate.tileY)
            if (best == null || distance < bestDistance) {
                best = candidate
                bestDistance = distance
            }
        }
        return best
    }

    function deliverRecruit(entry, homeSett, sourceSett, unitType) {
        local army = null
        local redirected = false
        if (homeSett.siegeCount == 0 && homeSett.army && homeSett.army.unitCount < 20) {
            army = homeSett.army
        } else if (homeSett.siegeCount == 0 && !homeSett.army) {
            army = homeSett.createGarrisonArmy()
        } else {
            local nearby = this.findNearbySettlement(homeSett)
            if (nearby != null) {
                army = nearby.army ? nearby.army : nearby.createGarrisonArmy()
                redirected = true
            }
        }

        if (army == null) {
            this.refundToPool(sourceSett, unitType, entry.cost)
            return null
        }

        local created = army.createUnit(unitType.name, entry.exp, entry.armour, entry.weapon, -1)
        if (created == null) {
            return null
        }
        local deliverySett = army.inSettlement()
        local deliveryName = deliverySett ? deliverySett.displayName : homeSett.displayName
        return "\n" + deliveryName + (redirected ? "(redirected) - " : " - ") + unitType.name
    }

    function globalRecruitmentTurnCheck() {
        local delivered = ""
        local keys = []
        foreach (key, entry in ::EUR.global_recruits) {
            keys.append(key)
        }

        foreach (key in keys) {
            if (!(key in ::EUR.global_recruits) || ::EUR.global_recruits[key] == null) {
                continue
            }
            local entry = ::EUR.global_recruits[key]
            local homeSett = ::EUR.eur_sMap.findSettlement(entry.local_sett)
            local sourceSett = ::EUR.eur_sMap.findSettlement(entry.remote_sett)

            if (entry.time > 1) {
                if (sourceSett.owner.id != ::EUR.eur_playerFactionId) {
                    ::EUR.global_recruits.rawdelete(key)
                } else if (sourceSett.siegeCount <= 0) {
                    entry.time = entry.time - 1
                }
                continue
            }

            local playerOwnsBoth = sourceSett.owner.id == ::EUR.eur_playerFactionId
                && homeSett.owner.id == ::EUR.eur_playerFactionId
            if (!playerOwnsBoth) {
                ::EUR.global_recruits.rawdelete(key)
                continue
            }

            local line = this.deliverRecruit(entry, homeSett, sourceSett, ::units.get(entry.eduEntry))
            if (line != null) {
                delivered += line
            }
            ::EUR.global_recruits.rawdelete(key)
        }

        if (delivered != "") {
            ::game.showHistoricEvent("battle_reinforcement", "Global Recruitment", "Units recruited \n" + delivered)
        }
    }

    function addToLocalQueue(optionIndex, settname) {
        this.creating = true
        local settlement = ::EUR.eur_sMap.findSettlement(settname)
        if (settlement != null) {
            local items = settlement.recruitmentOptions()
            if (items != null) {
                local unit = settlement.recruitmentOption(optionIndex)
                if (unit != null && unit.unitType != null) {
                    settlement.queueRecruitmentOption(optionIndex)
                }
            }
        }
        this.creating = false
        this.recruitCheckGlobal()
    }

    function globalSortOnDistance() {
        if (::EUR.global_settlement == null) {
            return
        }
        local distanceOf = function(sett) {
            if (!(sett.name in ::EUR.sett_info)) {
                return 1.0e30
            }
            return ::EUR.getDistance(::EUR.global_settlement.tileX, ::EUR.global_settlement.tileY,
                ::EUR.sett_info[sett.name].xCoord, ::EUR.sett_info[sett.name].yCoord)
        }
        this.sortPinned(function(a, b) {
            return (distanceOf(a) < distanceOf(b)) ? -1 : 1
        })
    }

    function sortPinned(cmp) {
        local head = null
        if (::EUR.sett_list.len() > 0 && ::EUR.sett_list[0] == ::EUR.global_settlement) {
            head = ::EUR.sett_list.remove(0)
        }
        ::EUR.sett_list.sort(cmp)
        if (head != null) { ::EUR.sett_list.insert(0, head) }
    }

    function recruitCheckGlobal() {
        if (this.creating || this.checking) {
            return
        }
        this.checking = true
        if (::EUR.global_settlement == null) {
            this.checking = false
            return
        }

        ::EUR.sett_list = []
        ::EUR.sett_list_outrange = []
        ::EUR.sett_distance_list = {}
        local centralX = ::EUR.global_settlement.tileX
        local centralY = ::EUR.global_settlement.tileY
        local faction = ::EUR.eur_player_faction

        if (faction != null && faction.settlementCount > 0) {
            for (local index = 0; index < faction.settlementCount; index++) {
                local settlement = faction.settlement(index)
                if (settlement == null) {
                    continue
                }
                if (this.checkSettRange(settlement.tileX, settlement.tileY, centralX, centralY)) {
                    if (::EUR.global_settlement == settlement && ::EUR.sett_list.len() > 0) {
                        ::EUR.sett_list.insert(0, settlement)
                    } else {
                        ::EUR.sett_list.append(settlement)
                    }
                } else {
                    ::EUR.sett_list_outrange.append(settlement)
                }
            }

            if (::EUR.game_options.global_sort_aphabetically) {
                this.sortPinned(function(a, b) {
                    return (a.displayName < b.displayName) ? -1 : 1
                })
            } else if (::EUR.game_options.global_sort_distance) {
                this.globalSortOnDistance()
            }
            this.fillSetInfo()
        }
        this.checking = false
    }

    function poolFor(sett, eduIndex) {
        for (local poolIndex = 0; poolIndex < sett.recruitPoolCount; poolIndex++) {
            local pool = sett.recruitPool(poolIndex)
            if (pool != null && pool.unitTypeIndex == eduIndex) {
                return pool
            }
        }
        return null
    }

    function capFor(sett, eduIndex) {
        for (local capIndex = 0; capIndex < sett.recruitCapabilityCount; capIndex++) {
            local capability = sett.recruitCapability(capIndex)
            if (capability != null && capability.unitTypeIndex == eduIndex) {
                return capability
            }
        }
        return null
    }

    function fillSetInfo() {
        ::EUR.sett_info = {}
        ::EUR.notif_count = 0
        ::EUR.global_recruit_limit = ::EUR.game_options.global_recruit_start

        for (local index = 0; index < ::EUR.eur_player_faction.settlementCount; index++) {
            local sett = ::EUR.eur_player_faction.settlement(index)
            if (sett == null) {
                continue
            }

            if (::EUR.game_options.global_waystation_inc_max) {
                if (sett.hasBuildingLevel("military_academy", true) && ::EUR.global_recruit_limit < ::EUR.game_options.global_recruit_max) {
                    ::EUR.global_recruit_limit = ::EUR.global_recruit_limit + 1
                }
            } else {
                ::EUR.global_recruit_limit = ::EUR.game_options.global_recruit_max
            }

            local info = {
                seiged = sett.siegeCount > 0,
                hidden = ::EUR.game_options.global_recruitment_hidenounits ? true : false,
                waystation = false,
                localizedName = sett.displayName,
                isCastle = sett.isCastle,
                xCoord = sett.tileX,
                yCoord = sett.tileY,
                unitInQueueCount = sett.recruitmentQueueCount,
                armourlvl = sett.capability(::Enum.BuildingCapability.armour).value,
                weapon_melee_simple = sett.capability(::Enum.BuildingCapability.weaponMeleeSimple).value,
                weapon_melee_blade = sett.capability(::Enum.BuildingCapability.weaponMeleeBlade).value,
                weapon_missile_mechanical = sett.capability(::Enum.BuildingCapability.weaponMissileMechanical).value,
                recruit_slots = sett.capability(::Enum.BuildingCapability.recruitmentSlots).value,
                unit = [],
            }
            ::EUR.sett_info[sett.name] <- info

            local items = sett.recruitmentOptions()
            if (items == null) {
                continue
            }
            for (local optionIndex = 0; optionIndex < items.count; optionIndex++) {
                local option = sett.recruitmentOption(optionIndex)
                if (option.recruitType != 0 || option.cost <= 0 || option.unitType == null) {
                    continue
                }
                local pool = this.poolFor(sett, option.unitType.index)
                local capability = this.capFor(sett, option.unitType.index)
                if (capability == null) {
                    continue
                }

                info.unit.append({
                    getRecruitmentOption = optionIndex,
                    xp = capability.experience,
                    maxSize = capability.maxSize,
                    replenishRate = capability.replenishRate,
                    eduType = option.unitType.name,
                    localizedName = option.unitType.displayName,
                    unitCardTga = option.unitType.cardImage,
                    availablePool = (pool != null) ? pool.available : 0.0,
                    eduIndex = option.unitType.index,
                    cost = option.cost,
                    recruitTime = option.recruitTime,
                    active = true,
                })

                info.waystation = ::EUR.game_options.global_waystation_req
                    ? sett.hasBuildingLevel("military_academy", false)
                    : true

                if (!(option.unitType.name in ::EUR.UNIT_FILTER)) {
                    ::EUR.UNIT_FILTER[option.unitType.name] <- {
                        active = true,
                        eduType = option.unitType.name,
                        localizedName = option.unitType.displayName,
                        unitCardTga = option.unitType.cardImage,
                    }
                }
                if (!(option.unitType.name in ::EUR.UNIT_FILTER_notif)) {
                    ::EUR.UNIT_FILTER_notif[option.unitType.name] <- {
                        active = true,
                        eduType = option.unitType.name,
                        localizedName = option.unitType.displayName,
                        unitCardTga = option.unitType.cardImage,
                    }
                }

                local passes = this.filterPasses(option.unitType.name)
                info.unit[info.unit.len() - 1].active = passes
                if (passes && capability.maxSize >= 1) {
                    info.hidden = false
                }

                if ((option.unitType.name in ::EUR.UNIT_FILTER_notif)
                    && !::EUR.UNIT_FILTER_notif[option.unitType.name].active
                    && pool.available >= 1) {
                    ::EUR.notif_count += 1
                }
            }
        }
    }

    function filterPasses(eduType) {
        if (this.singleFilter) { return eduType == this.singleFilterTarget }
        return (eduType in ::EUR.UNIT_FILTER) && ::EUR.UNIT_FILTER[eduType].active
    }

    function costModFor(settname) {
        if (!(settname in ::EUR.sett_distance_list)) {
            local distance = ::EUR.getDistance(::EUR.global_settlement.tileX, ::EUR.global_settlement.tileY,
                ::EUR.sett_info[settname].xCoord, ::EUR.sett_info[settname].yCoord)
            ::EUR.sett_distance_list[settname] <- ::EUR.math.ceil(distance / 70)
        }
        local steps = ::EUR.sett_distance_list[settname]
        return steps == 1 ? 1.5 : ::EUR.global_cost_mod + (steps / 10.0)
    }

    function cardLayer(settname, unit, isSelected) {
        local info = ::EUR.sett_info[settname]
        local baseCost = unit.cost
        local baseTime = unit.recruitTime

        if (info.seiged) {
            return { action = null, status = "Settlement under siege.", cost = baseCost, time = baseTime }
        }
        if (unit.availablePool < 1) {
            local turns = ::EUR.floatToWhole(unit.replenishRate, 1 - unit.availablePool)
            local waitText = (turns == null) ? "Not replenishing." : turns + " Turns until available."
            return { action = null, status = waitText, cost = baseCost, time = baseTime }
        }

        local money = ::EUR.eur_player_faction.money
        local queueOpen = info.unitInQueueCount < 9

        if (isSelected) {
            if (money < baseCost) {
                return { action = null, status = "Not Enough Gold", cost = baseCost, time = baseTime }
            }
            if (!queueOpen) {
                return { action = null, status = "Local queue full.", cost = baseCost, time = baseTime }
            }
            return { action = "local", status = "Local recruitment.", cost = baseCost, time = baseTime }
        }

        local costMultiplier = this.costModFor(settname)
        local globalCost = ::EUR.math.ceil(baseCost * costMultiplier)
        local globalTime = baseTime + ::EUR.sett_distance_list[settname]

        if (::EUR.global_recruit_current >= ::EUR.global_recruit_limit) {
            if (!queueOpen) {
                return { action = null, status = "Global Recruitment Queue Full, Local Queue Full.", cost = globalCost, time = baseTime }
            }
            if (money < baseCost) {
                return { action = null, status = "Global Queue Full, Not Enough Gold for Local Recruitment.", cost = baseCost, time = baseTime }
            }
            return { action = "local", status = "Global Queue Full, Local Recruitment.", cost = baseCost, time = baseTime }
        }

        if (money < baseCost * costMultiplier) {
            if (!queueOpen) {
                return { action = null, status = "Not Enough Gold, Local Queue Full.", cost = globalCost, time = baseTime }
            }
            if (money < baseCost) {
                return { action = null, status = "Not Enough Gold for Local or Global Recruitment.", cost = baseCost, time = baseTime }
            }
            return { action = "local", status = "Not Enough Gold, Local Recruitment.", cost = baseCost, time = baseTime }
        }

        local factionName = ::EUR.eur_player_faction.name
        local isGeneralUnit = (factionName in ::EUR.default_general_units)
            && ::EUR.default_general_units[factionName].old == unit.eduType
        if (isGeneralUnit) {
            if (!queueOpen) {
                return { action = null, status = "Local Queue Full.", cost = baseCost, time = baseTime }
            }
            return { action = "local", status = "General Unit - Local Recruitment.", cost = baseCost, time = baseTime }
        }

        local homeName = ::EUR.global_settlement.name
        local waystationOk = !::EUR.game_options.global_recruitment_localonly
            && (!::EUR.game_options.global_waystation_req
                || ((homeName in ::EUR.sett_info) && ::EUR.sett_info[homeName].waystation))
        if (waystationOk) {
            return { action = "global", status = "Global Recruitment.", cost = globalCost, time = globalTime }
        }
        if (!queueOpen) {
            return { action = null, status = "Local Queue Full.", cost = baseCost, time = baseTime }
        }
        local localText = ::EUR.game_options.global_waystation_req
            ? "No Waystation at " + ::EUR.global_settlement.displayName + ", Local Recruitment."
            : "Local Recruitment."
        return { action = "local", status = localText, cost = baseCost, time = baseTime }
    }

    function cardTex(eduType) {
        if (this.cardCache == null) {
            this.cardCache = {}
        }
        if (eduType in this.cardCache) {
            return this.cardCache[eduType]
        }
        local unitType = ::units.get(eduType)
        local texture = unitType != null ? ::UI.loadTexture(unitType.cardPath(::EUR.eur_player_faction.name)) : null
        this.cardCache[eduType] <- texture
        return texture
    }

    function cardStats(eduType) {
        if (this.statsCache == null) {
            this.statsCache = {}
        }
        if (eduType in this.statsCache) {
            return this.statsCache[eduType]
        }
        local stats = ::EUR.showEDUStats(eduType)
        this.statsCache[eduType] <- stats
        return stats
    }

    function cardStatsAdjusted(eduType, info, xp) {
        if (this.statsCache == null) {
            this.statsCache = {}
        }
        local key = eduType + "|" + xp + "|" + info.armourlvl + "|"
                    + info.weapon_melee_blade + "|" + info.weapon_missile_mechanical
        if (key in this.statsCache) {
            return this.statsCache[key]
        }
        local stats = ::EUR.showEDUStatsAdjusted(eduType, xp, info.armourlvl,
                                                 info.weapon_melee_blade,
                                                 info.weapon_missile_mechanical)
        this.statsCache[key] <- stats
        return stats
    }

    function ensure() {
        if (this.scroll != null) {
            return
        }
        local self = this
        ::UI.pushStyle(::EUR.eurStyles.basic_4)
        this.scroll = ::EUR.scroll.create(this.layout.windowW, this.layout.windowH, 0, 0, function() {
            ::EUR.window_states.show_globalrecruit_window = false
        })
        this.canvas = ::UI.canvas(0, 0)
        ::UI.placeAbsolute(this.canvas)
        ::UI.canvasDraw(this.canvas, function() { self.drawWindow() })

        this.sortAzCheck = ::UI.checkbox("A-Z")
        ::UI.placeAbsolute(this.sortAzCheck)
        ::UI.checkboxChange(this.sortAzCheck, function(value) {
            ::EUR.game_options.global_sort_aphabetically = (value != 0)
            if (value != 0) { ::EUR.game_options.global_sort_distance = false }
            self.recruitCheckGlobal()
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })
        this.sortDistanceCheck = ::UI.checkbox("Distance")
        ::UI.placeAbsolute(this.sortDistanceCheck)
        ::UI.checkboxChange(this.sortDistanceCheck, function(value) {
            ::EUR.game_options.global_sort_distance = (value != 0)
            if (value != 0) { ::EUR.game_options.global_sort_aphabetically = false }
            self.recruitCheckGlobal()
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })
        this.hideEmptyCheck = ::UI.checkbox("Hide empty")
        ::UI.placeAbsolute(this.hideEmptyCheck)
        ::UI.checkboxChange(this.hideEmptyCheck, function(value) {
            ::EUR.game_options.global_recruitment_hidenounits = (value != 0)
            self.recruitCheckGlobal()
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })
        this.filterCheck = ::UI.checkbox("Filter Units")
        ::UI.placeAbsolute(this.filterCheck)
        ::UI.checkboxChange(this.filterCheck, function(value) {
            self.filterOpen = (value != 0)
            if (self.filterOpen) { self.notifOpen = false }
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })
        this.notifCheck = ::UI.checkbox("Notification")
        ::UI.placeAbsolute(this.notifCheck)
        ::UI.checkboxChange(this.notifCheck, function(value) {
            self.notifOpen = (value != 0)
            if (self.notifOpen) { self.filterOpen = false }
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
        })

        ::EUR.scroll.sealOnTop(this.scroll)

        ::UI.setParent(0)
        this.buttonCanvas = ::UI.canvas(this.layout.toggleButtonW, this.layout.toggleButtonH,
                                        this.layout.toggleButtonX, this.layout.toggleButtonY)
        ::UI.setWidgetStyle(this.buttonCanvas, ::UI.Cap.autoScaleDraw, 1)   // built outside the sheet push
        ::UI.setWidgetStyle(this.buttonCanvas, ::UI.Cap.autoScalePos, 1)
        ::UI.canvasDraw(this.buttonCanvas, function() { self.drawButton() })
        ::UI.popStyle()
        ::UI.widgetVisible(this.scroll.window, false)
        ::UI.widgetVisible(this.sortAzCheck, false)
        ::UI.widgetVisible(this.sortDistanceCheck, false)
        ::UI.widgetVisible(this.hideEmptyCheck, false)
        ::UI.widgetVisible(this.filterCheck, false)
        ::UI.widgetVisible(this.notifCheck, false)
        if ("gamePanelWindow" in ::UI) { ::UI.gamePanelWindow(this.scroll.window, 0) }
        ::EUR.registerLeftWindow("show_globalrecruit_window", this.scroll.window)
    }

    function contentArea() {
        local rect = ::authored.gameRect(::UI.widgetRectGet(this.scroll.window))
        if (rect == null) {
            return null
        }
        local margins = ::EUR.scroll.setMargins("scroll")
        if (margins == null) {
            return null
        }
        return { x = rect[0] + margins[0], y = rect[1] + margins[1],
                 width = rect[2] - margins[0] - margins[2], height = rect[3] - margins[1] - margins[3] }
    }

    function queueCount() {
        local count = 0
        foreach (key, entry in ::EUR.global_recruits) {
            if (entry != null) {
                count += 1
            }
        }
        return count
    }

    function render() {
        this.ensure()
        local show = ::EUR.window_states.show_globalrecruit_window && ::EUR.in_campaign_map && ::EUR.game_options.global_recruitment
        show = ::EUR.panelFollow(this.scroll.window, ::EUR.window_states, "show_globalrecruit_window",
                                 show, this.shownLast)
        this.shownLast = show
        ::UI.widgetVisible(this.sortAzCheck, show)
        ::UI.widgetVisible(this.sortDistanceCheck, show)
        ::UI.widgetVisible(this.hideEmptyCheck, show)
        ::UI.widgetVisible(this.filterCheck, show)
        ::UI.widgetVisible(this.notifCheck, show)
        if (!show) {
            this.raised = false
            return
        }
        if (this.pendingRefresh) {
            this.pendingRefresh = false
            this.recruitCheckGlobal()
        }
        ::EUR.scroll.placeGame(this.scroll.window, this.layout.windowX, this.layout.windowY,
                        this.layout.windowW, this.layout.windowH)
        if (!this.raised) {
            ::UI.raise(this.scroll.window)
        }
        this.raised = true

        local win = ::authored.gameRect(::UI.widgetRectGet(this.scroll.window))
        if (win != null) {
            local sortX = win[0] + this.layout.optionsX
            local sortY = win[1] + this.layout.optionsY
            local stack = [this.sortAzCheck, this.sortDistanceCheck, this.hideEmptyCheck]
            foreach (i, w in stack) {
                ::UI.widgetRect(w, sortX, sortY + this.layout.optionRowStepY * i, 0, 0)
            }
        }

        local area = this.contentArea()
        if (area != null) {
            local filterX = area.x + this.layout.contentInsetX + this.layout.sectionOffsetX
            local filterY = area.y + this.layout.filterRowY
            ::UI.widgetRect(this.filterCheck, filterX, filterY, 0, 0)
            local span = ::UI.naturalSize(this.filterCheck)
            local notifX = filterX + ((span != null) ? span[0] : 0) + this.layout.filterRowGapX
            ::UI.widgetRect(this.notifCheck, notifX, filterY, 0, 0)
        }

        this.syncCheck(this.sortAzCheck, ::EUR.game_options.global_sort_aphabetically)
        this.syncCheck(this.sortDistanceCheck, ::EUR.game_options.global_sort_distance)
        this.syncCheck(this.hideEmptyCheck, ::EUR.game_options.global_recruitment_hidenounits)
        this.syncCheck(this.filterCheck, this.filterOpen)
        this.syncCheck(this.notifCheck, this.notifOpen)

        local infoScroll = ::ui.settlementScroll()
        if (infoScroll != null && infoScroll.settlement != null && ::EUR.global_settlement != infoScroll.settlement) {
            ::EUR.global_settlement = infoScroll.settlement
            this.recruitCheckGlobal()
        }
    }

    function syncCheck(handle, on) {
        local wanted = on ? 1 : 0
        if (::UI.checkboxValueGet(handle) != wanted) {
            ::UI.checkboxValue(handle, wanted)
        }
    }

    function drawButton() {
        if (!::EUR.in_campaign_map || ::EUR.icon_unit == null) { return }
        if (::ui.settlementScroll() == null) { return }

        // Sits ON the game HUD, so it takes the game's factor rather than our layout's.
        local bx = ::authored.hudX(this.layout.toggleButtonX)
        local by = ::authored.hudY(this.layout.toggleButtonY)
        local bw = ::authored.hudX(this.layout.toggleButtonW)
        local bh = ::authored.hudY(this.layout.toggleButtonH)

        local icon = (::EUR.notif_count > 0 && ::EUR.icon_unit2 != null) ? ::EUR.icon_unit2 : ::EUR.icon_unit
        local hit = ::UI.imageButton(icon.img, bw, bh, bx, by)
        ::UI.tooltipAt(bx, by, bw, bh)
        ::UI.tooltip(0, (::EUR.notif_count > 0) ? "Show Global Recruitment - Units available"
                                                : "Show Global Recruitment")
        if (this.layout.toggleButtonLift > 0) {
            ::UI.pushBlend(1)
            ::UI.image(icon.img, bw, bh, bx, by, 255, 255, 255, this.layout.toggleButtonLift)
            ::UI.popBlend()
        }
        if (!hit.clicked) { return }

        local opening = !::EUR.window_states.show_globalrecruit_window
        ::EUR.set_active_left_window(opening ? "show_globalrecruit_window" : "")
        if (opening) {
            local infoScroll = ::ui.settlementScroll()
            if (infoScroll != null && infoScroll.settlement != null) {
                ::EUR.global_settlement = infoScroll.settlement
                this.recruitCheckGlobal()
            }
        }
        ::game.runScriptCommand("play_sound_event", opening ? "STRAT_SCROLL_OPENS" : "STRAT_SCROLL_CLOSES")
    }

    function drawWindow() {
        // GAME SPACE: this panel sits in the game's own scroll slot, so its content stretches on x
        // exactly as the frame does. Composes with Cap.autoScaleDraw's uniform scale to give the
        // engine's W/1920; 1.0 on 16:9, so nothing moves there. Scoped form - closes on every path.
        return ::UI.pushTransform(0, 0, ::authored.hudStretch(), 0, 1.0, function() {
            this.drawWindowBody()
        }.bindenv(this))
    }

    function drawWindowBody() {
        if (!::EUR.window_states.show_globalrecruit_window || !::EUR.in_campaign_map || !::EUR.game_options.global_recruitment) {
            return
        }
        local area = this.contentArea()
        if (area == null) {
            return
        }

        ::EUR.scroll.drawSet("panel",
                             (area.x + this.layout.bgInsetX + this.layout.bgOffsetX),
                             (area.y + this.layout.bgInsetY + this.layout.bgOffsetY),
                             (area.width - this.layout.bgInsetX * 2 + this.layout.bgWidthDelta),
                             (area.height - this.layout.bgInsetY * 2 + this.layout.bgHeightDelta))

        ::UI.pushStyle({ [::UI.Colour.text] = [0, 0, 0, 255] })

        ::UI.layoutAt(area.x, area.y + this.layout.headingOffsetY)
        ::UI.pushFont(::fonts.body, false, this.layout.headingFontSize)
        ::UI.pushStyle({ [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = area.width })
        ::UI.text("Global Recruitment")
        ::UI.popStyle()
        ::UI.popFont()

        ::UI.pushFont(::fonts.body, false, this.layout.bodyFontSize)
        this.styleCheckFont()

        ::EUR.global_recruit_current = this.queueCount()
        local contentX = area.x + this.layout.contentInsetX + this.layout.sectionOffsetX
        local contentWidth = area.width - this.layout.contentInsetX * 2
                             + this.layout.sectionWidthDelta

        local cursorY = this.optionsBottom(area.y)
        if (this.filterOpen) {
            cursorY = this.drawFilterGrid(::EUR.UNIT_FILTER, contentX,
                                          cursorY + this.layout.filterGapY, contentWidth, false)
        } else if (this.notifOpen) {
            cursorY = this.drawFilterGrid(::EUR.UNIT_FILTER_notif, contentX,
                                          cursorY + this.layout.filterGapY, contentWidth, true)
        }

        local queueLabel = ::EUR.game_options.global_recruitment_localonly
            ? "Global Recruitment Queue (disabled): " : "Global Recruitment Queue: "
        local queueText = queueLabel + ::EUR.global_recruit_current + "/" + ::EUR.global_recruit_limit
        ::UI.layoutAt(contentX, cursorY + this.layout.queueLabelGapY)
        if (::EUR.global_recruit_current >= ::EUR.global_recruit_limit) {
            ::UI.textColoured(queueText, 204, 0, 0, 255)
        } else {
            ::UI.text(queueText)
        }

        cursorY += this.layout.queueLabelGapY + this.layout.queueLabelRowH
        if (!::EUR.game_options.global_recruitment_localonly) {
            cursorY = this.drawQueue(contentX, cursorY, contentWidth)
        }

        if (::EUR.global_settlement != null) {
            local self = this
            local listTop = cursorY + this.layout.settlementsGapY
            local listBottom = area.y + area.height - this.layout.contentBottomInset
            this.scrollList(contentX, listTop, contentWidth, listBottom)
            ::UI.pushClip(contentX, listTop, contentWidth, listBottom - listTop, function() {
                self.drawSettlements(contentX, listTop - self.listScroll, contentWidth)
            })
            this.drawListScrollbar(contentX, listTop, contentWidth, listBottom - listTop)
        }

        ::UI.popFont()
        ::UI.popStyle()
    }

    function optionsBottom(areaY) {
        return areaY + this.layout.filterRowY + this.layout.optionRowStepY
               + this.layout.sectionOffsetY
    }

    function drawListScrollbar(originX, topY, width, viewH) {
        if (this.listHeight <= viewH || viewH <= 0) {
            this.scrollGrabOffset = -1
            this.scrollDragging = false
            return
        }
        local barX = originX + width - this.layout.scrollBarW
        local barW = this.layout.scrollBarW
        local over = this.listHeight - viewH
        local grabH = (viewH * viewH) / this.listHeight
        if (grabH < this.layout.scrollBarMinH) { grabH = this.layout.scrollBarMinH }
        local travel = viewH - grabH
        local grabY = topY + ((over > 0 && travel > 0) ? (travel * this.listScroll) / over : 0)

        local hit = ::UI.hitRect(barX, topY, barW, viewH)
        if (hit.held) { this.scrollDragging = true }
        if (this.scrollDragging && !::UI.mouse.down(::UI.mouse.left)) {
            this.scrollDragging = false
            this.scrollGrabOffset = -1
        }
        if (this.scrollDragging && travel > 0) {
            local my = ::UI.mouse.pos()[1]
            if (this.scrollGrabOffset < 0) {
                this.scrollGrabOffset = (my >= grabY && my < grabY + grabH) ? (my - grabY) : grabH / 2
            }
            local want = my - topY - this.scrollGrabOffset
            if (want < 0) { want = 0 }
            if (want > travel) { want = travel }
            this.listScroll = (over * want) / travel
            grabY = topY + want
        }

        local shade = this.scrollDragging ? this.layout.scrollGrabHeld
                    : (hit.hovered ? this.layout.scrollGrabHover : this.layout.scrollGrab)
        ::UI.drawRect(barX, topY, barW, viewH, this.layout.scrollTrack[0], this.layout.scrollTrack[1],
                      this.layout.scrollTrack[2], this.layout.scrollTrack[3])
        ::UI.drawRect(barX, grabY, barW, grabH, shade[0], shade[1], shade[2], shade[3])
    }

    function styleCheckFont() {
        if (this.fontSet) { return }
        this.fontSet = true
        local id = 0
        local rows = ::UI.fonts()
        if (rows != null) {
            foreach (f in rows) {
                if (f.name == ::fonts.game.verdanaSml) { id = f.id }
            }
        }
        if (id == 0) { return }
        local stack = [this.sortAzCheck, this.sortDistanceCheck, this.hideEmptyCheck,
                       this.filterCheck, this.notifCheck]
        foreach (w in stack) {
            ::UI.setWidgetStyle(w, ::UI.Font.body, id)
            ::UI.setWidgetStyle(w, ::UI.Metric.fontSize, this.layout.bodyFontSize)
        }
    }

    function tintedCard(img, w, h, x, y, tint, hoverLift, heldLift) {
        local hit = ::UI.hitRect(x, y, w, h)
        local lift = hit.held ? heldLift : (hit.hovered ? hoverLift : 0)
        local alpha = tint[3] + lift
        if (alpha > 255) { alpha = 255 }
        if (alpha < 0) { alpha = 0 }
        ::UI.drawRect(x, y, w, h, tint[0], tint[1], tint[2], alpha)
        ::UI.image(img, w, h, x, y)
        return hit
    }

    function drawFilterGrid(sheet, originX, cursorY, width, invert) {
        local cardW = this.layout.filterCardW
        local cardH = this.layout.filterCardH
        local cursorX = originX
        local rows = 1
        foreach (key, entry in sheet) {
            local texture = this.cardTex(entry.eduType)
            if (texture == null) {
                continue
            }
            local lit = invert ? !entry.active : entry.active
            if (this.singleFilter && !invert) {
                lit = (entry.eduType == this.singleFilterTarget)
            }
            local shade = invert ? (lit ? this.layout.notifLit : this.layout.notifDim)
                                 : (lit ? this.layout.filterLit : this.layout.filterDim)
            local hoverLift = invert ? this.layout.notifHoverLift : this.layout.filterHoverLift
            local heldLift = invert ? this.layout.notifHeldLift : this.layout.filterHeldLift
            if (this.tintedCard(texture.img, cardW, cardH, cursorX, cursorY, shade, hoverLift, heldLift).clicked) {
                ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
                this.filterClicked(entry, invert)
                this.pendingRefresh = true
            }
            ::UI.tooltipAt(cursorX, cursorY, cardW, cardH)
            local tip = entry.eduType + "\n" + this.cardStats(entry.eduType)
            if (!invert) {
                tip += "\n\n" + "Hold shift to filter on this unit only."
            }
            ::UI.tooltip(0, tip)

            cursorX += cardW + this.layout.filterCardGapX
            if (cursorX > originX + width - cardW) {
                cursorX = originX
                rows += 1
                if (rows > this.layout.filterMaxRows) {
                    break
                }
                cursorY += cardH + this.layout.filterCardGapY
            }
        }
        return cursorY + cardH
    }

    function filterClicked(entry, invert) {
        if (invert) {
            entry.active = !entry.active
            return
        }
        local shift = (::UI.keyboard.mods() & ::UI.Mod.shift) != 0
        if (!this.singleFilter) {
            if (shift) {
                this.singleFilter = true
                this.singleFilterTarget = entry.eduType
            } else {
                entry.active = !entry.active
            }
            return
        }
        if (!shift) {
            this.singleFilter = false
            return
        }
        if (this.singleFilterTarget == entry.eduType) {
            this.singleFilter = false
            this.singleFilterTarget = ""
        } else {
            this.singleFilterTarget = entry.eduType
        }
    }

    function pipImage(kind, tier) {
        local name = kind + ((tier >= 3) ? "_gold" : ((tier == 2) ? "_silver" : "_bronze"))
        return (name in ::EUR) ? ::EUR[name] : null
    }

    function drawPip(img, x, y, w, h, alpha) {
        if (img == null || img.img == 0) {
            return
        }
        ::UI.image(img.img, w, h, x, y, 255, 255, 255, alpha)
    }

    function drawCardPips(originX, originY, unit, info, alpha) {
        local unitType = ::units.get(unit.eduType)
        if (unitType == null) {
            return
        }
        local pipX = originX + this.layout.pipX

        if (unit.xp > 0) {
            local img = this.pipImage("chevron", (unit.xp >= 7) ? 3 : ((unit.xp >= 4) ? 2 : 1))
            local y = originY + this.layout.chevronY
            for (local i = 0; i < unit.xp && i < 9; i++) {
                this.drawPip(img, originX + this.layout.chevronX, y,
                             this.layout.chevronW, this.layout.chevronH, alpha)
                y += this.layout.chevronStepY
            }
        }

        local isMissile = unitType.hasProjectile(0)
        if (isMissile && info.weapon_missile_mechanical > 0) {
            this.drawPip(this.pipImage("sword", info.weapon_missile_mechanical),
                         pipX, originY + this.layout.swordMissileY,
                         this.layout.pipW, this.layout.pipH, alpha)
        } else if (!isMissile && info.weapon_melee_blade > 0) {
            this.drawPip(this.pipImage("sword", info.weapon_melee_blade),
                         pipX, originY + this.layout.swordMeleeY,
                         this.layout.pipW, this.layout.pipH, alpha)
        }

        local armour = this.armourFor(unitType, info.armourlvl)
        if (armour > 0) {
            this.drawPip(this.pipImage("shield", armour), pipX, originY + this.layout.shieldY,
                         this.layout.pipW, this.layout.pipH, alpha)
        }
    }

    function drawQueue(originX, cursorY, width) {
        local cardW = this.layout.queueCardW
        local cardH = this.layout.queueCardH
        local cursorX = originX
        local emitted = false
        foreach (key, entry in ::EUR.global_recruits) {
            if (entry == null) {
                continue
            }
            local texture = this.cardTex(entry.eduEntry)
            if (texture == null) {
                continue
            }

            if (this.tintedCard(texture.img, cardW, cardH, cursorX, cursorY, this.layout.queueTint,
                                this.layout.queueHoverLift, this.layout.queueHeldLift).clicked) {
                local sourceSett = ::EUR.eur_sMap.findSettlement(entry.remote_sett)
                local unitType = ::units.get(entry.eduEntry)
                if (sourceSett != null && unitType != null) {
                    this.refundToPool(sourceSett, unitType, entry.cost)
                }
                ::EUR.global_recruits.rawdelete(key)
                this.recruitCheckGlobal()
                ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
                return cursorY + cardH + this.layout.queueRowGapY
            }

            ::UI.tooltipAt(cursorX, cursorY, cardW, cardH)
            local fromName = (entry.remote_sett in ::EUR.sett_info) ? ::EUR.sett_info[entry.remote_sett].localizedName : entry.remote_sett
            local toName = (entry.local_sett in ::EUR.sett_info) ? ::EUR.sett_info[entry.local_sett].localizedName : entry.local_sett
            local tip = entry.eduEntry
            tip += "\n" + "From: " + fromName
            tip += "\n" + "To: " + toName
            tip += "\n" + "Recruitment Cost: " + entry.cost + " Gold."
            tip += "\n" + "Recruitment Time: " + entry.time + " Turns."
            ::UI.tooltip(0, tip)

            emitted = true
            cursorX += cardW + this.layout.queueCardGapX
            if (cursorX > originX + width - cardW) {
                cursorX = originX
                cursorY += cardH + this.layout.queueCardGapY
            }
        }
        if (!emitted) {
            return cursorY
        }
        return cursorY + cardH + this.layout.queueRowGapY
    }

    function drawUnitCard(settname, sett, unit, originX, originY, isSelected) {
        local texture = this.cardTex(unit.eduType)
        if (texture == null) {
            return
        }
        local layer = this.cardLayer(settname, unit, isSelected)
        local cardW = this.layout.cardW
        local cardH = this.layout.cardH

        local info = ::EUR.sett_info[settname]
        local acted = false
        local actedRight = false
        if (layer.action == null) {
            ::UI.image(texture.img, cardW, cardH, originX, originY, 255, 255, 255, this.layout.dimCardAlpha)
        } else {
            local hit = ::UI.imageButton(texture.img, cardW, cardH, originX, originY)
            acted = hit.clicked
            actedRight = hit.clickedRight
        }

        local textAlpha = (layer.action == null) ? this.layout.dimCardAlpha : 255
        this.drawCardPips(originX, originY, unit, info, textAlpha)
        ::UI.pushStyle({ [::UI.Colour.text] = [0, 0, 0, textAlpha] })
        ::UI.layoutAt(originX + this.layout.cardPoolOffsetX, originY + this.layout.cardPoolOffsetY)
        ::UI.text("" + unit.availablePool.tointeger())
        ::UI.popStyle()

        ::UI.tooltipAt(originX, originY, cardW, cardH)
        local tip = unit.localizedName
        tip += "\n" + this.cardStatsAdjusted(unit.eduType, info, unit.xp)
        tip += "\n"
        if (layer.action != null) {
            tip += "\n" + "Recruitment cost: " + layer.cost + " gold."
            tip += "\n" + "Recruitment time: " + layer.time + " turns."
        }
        tip += "\n" + layer.status
        if (layer.action == "global") {
            tip += "\n" + "Right click to add unit to local queue. Cost: " + unit.cost
                 + " gold. Time: " + unit.recruitTime + " turns."
        }
        ::UI.tooltip(0, tip)

        if (actedRight && layer.action != null) {
            this.addToLocalQueue(unit.getRecruitmentOption, settname)
            ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
            return
        }
        if (!acted) {
            return
        }
        if (layer.action == "global") {
            local unitType = ::units.get(unit.eduType)
            if (unitType == null) {
                return
            }
            this.globalRecruitment(::EUR.global_settlement, sett, unitType, unit.eduIndex,
                layer.time, layer.cost, unit.xp, info.armourlvl,
                info.weapon_melee_blade, info.weapon_missile_mechanical)
        } else {
            this.addToLocalQueue(unit.getRecruitmentOption, settname)
        }
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }

    function settlementTint(isSelected) {
        if (isSelected) {
            return { idle = [61, 153, 56, 38], hover = [61, 204, 56, 64], held = [61, 204, 56, 89] }
        }
        local homeName = (::EUR.global_settlement != null) ? ::EUR.global_settlement.name : ""
        local homeNoWaystation = ::EUR.game_options.global_waystation_req
            && (homeName in ::EUR.sett_info) && !::EUR.sett_info[homeName].waystation
        if (::EUR.game_options.global_recruitment_localonly || homeNoWaystation) {
            return { idle = [61, 153, 56, 26], hover = [61, 204, 56, 64], held = [61, 204, 56, 89] }
        }
        return { idle = [61, 61, 153, 26], hover = [61, 61, 153, 51], held = [61, 61, 153, 77] }
    }

    function drawSettlementButton(settlement, info, settname, isSelected, originX, cursorY) {
        local w = this.layout.settlementNameW
        local h = this.layout.settlementNameH
        local hit = ::UI.hitRect(originX, cursorY, w, h)
        local tint = this.settlementTint(isSelected)
        local fill = hit.held ? tint.held : (hit.hovered ? tint.hover : tint.idle)
        ::UI.drawRect(originX, cursorY, w, h, fill[0], fill[1], fill[2], fill[3])

        local nameText = info.localizedName
        if (::EUR.game_options.global_waystation_req && info.waystation) {
            nameText += "(w)"
        }
        local countText = info.unitInQueueCount + "/" + info.recruit_slots
        ::UI.pushStyle({ [::UI.Metric.alignX] = 1, [::UI.Metric.elideWidth] = w })
        ::UI.layoutAt(originX, cursorY + this.layout.settlementNameTextY)
        ::UI.textWrapped(nameText, w)
        ::UI.layoutAt(originX, cursorY + this.layout.settlementCountY)
        if (info.unitInQueueCount > 0 && info.unitInQueueCount >= info.recruit_slots) {
            ::UI.textColoured(countText, 204, 0, 0, 255)
        } else {
            ::UI.text(countText)
        }
        ::UI.popStyle()

        ::UI.tooltipAt(originX, cursorY, w, h)
        local tip = "Go to " + info.localizedName
        if (::EUR.game_options.global_waystation_req && info.waystation) {
            tip += "\n" + "Waystation present"
        }
        tip += "\n\n" + countText + " units in local queue"
        ::UI.tooltip(0, tip)

        if (!hit.clicked) {
            return
        }
        settlement.select()
        ::stratMap.jumpCamera(info.xCoord - 10, info.yCoord)
        ::EUR.global_settlement = settlement
        this.pendingRefresh = true
        ::game.runScriptCommand("play_sound_event", "BUTTON_DOWN")
    }

    function scrollList(originX, topY, width, bottomY) {
        local view = bottomY - topY
        local over = this.listHeight - view
        if (over < 0) { over = 0 }
        if (::UI.hoverRect(originX, topY, width, view).hovered) {
            local notches = ::UI.mouse.wheel()
            if (notches != 0) {
                ::UI.mouse.captureWheel()
                this.listScroll -= notches * this.layout.listScrollStep
            }
        }
        if (this.listScroll > over) { this.listScroll = over }
        if (this.listScroll < 0) { this.listScroll = 0 }
    }

    function drawSettlements(originX, cursorY, width) {
        local startY = cursorY
        local cardsX = originX + this.layout.settlementNameW + this.layout.settlementColumnGapX
        local cardStepX = this.layout.cardW + this.layout.cardGapX
        local cardStepY = this.layout.cardH + this.layout.cardGapY
        local drawn = 0

        foreach (settlement in ::EUR.sett_list) {
            local settname = settlement.name
            local info = (settname in ::EUR.sett_info) ? ::EUR.sett_info[settname] : null
            if (info == null || info.hidden) {
                continue
            }
            local isSelected = (settlement == ::EUR.global_settlement)

            if (drawn > 0) {
                ::UI.drawRect(originX, cursorY - this.layout.separatorGapY, width, 1, 148, 148, 148, 255)
            }
            drawn += 1
            this.drawSettlementButton(settlement, info, settname, isSelected, originX, cursorY)

            local cursorX = cardsX
            foreach (unit in info.unit) {
                if (unit.maxSize < 1) {
                    continue
                }
                if (!this.filterPasses(unit.eduType)) {
                    continue
                }
                this.drawUnitCard(settname, settlement, unit, cursorX, cursorY + this.layout.cardRowPadY, isSelected)
                cursorX += cardStepX
                if (cursorX > originX + width - this.layout.cardW) {
                    cursorX = cardsX
                    cursorY += cardStepY
                }
            }
            local rowH = this.layout.cardH + this.layout.cardRowPadY
            if (this.layout.settlementNameH > rowH) {
                rowH = this.layout.settlementNameH
            }
            cursorY += rowH + this.layout.settlementRowGapY
        }
        this.listHeight = cursorY - startY
    }
}

::EUR.eurGlobalRecruitment <- eurGlobalRecruitment()
::UI.onFrame(function() { ::EUR.eurGlobalRecruitment.render() })
