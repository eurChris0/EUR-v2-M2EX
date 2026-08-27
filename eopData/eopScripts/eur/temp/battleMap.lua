BATTLE_MAP_WINDOW = {
    ---@type battleUnit
    selectedUnit = nil,
    ---@type unit
    targetUnit = nil,
    mapType = "Height",
    heightColors = {

    },
    groundColors = {

    },
    zoneColors = {

    },
    ValidityColors = {

    },
    heightData = {

    },
    dataSet = false,
    ---@type buildingBattle
    selectedBuilding = nil,
    ---@type number
    mapScale = 1,
    panX = 0,
    panY = 0,
    zoom = 1.0,
}

LOGGER = {
    ---@type file*
    logFile = nil,
    
    ---@enum logLevel
    logLevel = {
        TRACE = 1,
        INFO = 2,
        WARNING = 3,
        ERROR = 4
    },

    logLevelStrings = {
        "TRACE",
        "INFO",
        "WARNING",
        "ERROR"
    },

    enabled = false,

    currentLevel = 2
}

function LOGGER:init()
    local modPath = M2TWEOP.getModPath()
    self.logFile = io.open(modPath .. "/M2TWEOP.log", "w")
    self.enabled = true
end

function LOGGER:log(message, level)
    if self.enabled and level >= self.currentLevel and self.logFile then
        local printText = "[" .. self.logLevelStrings[level] .. "]" .. "[" .. os.date() .. "] -> <" .. tostring(message) .. ">\n"
        self.logFile:write(printText)
        self.logFile:flush()
    end
end

function LOGGER:trace(message)
    self:log(message, self.logLevel.TRACE)
end

function LOGGER:info(message)
    self:log(message, self.logLevel.INFO)
end

function LOGGER:warning(message)
    self:log(message, self.logLevel.WARNING)
end

function LOGGER:error(message)
    self:log(message, self.logLevel.ERROR)
end

function LOGGER:close()
    self.logFile:close()
end

function LOGGER:setLogLevel(level)
    self.currentLevel = level
end



testCanvasOpen = true;
showBuildings = false;

---comment
---@param value any
---@param min any
---@param max any
---@return number
function clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    end
    return value * 1.0
end


maptypes = {
    "Height",
    "Ground",
    "Zone",
    "Validity",
}

function BATTLE_MAP_WINDOW:drawBattleMap()
    GAME_DATA = gameDataAll.get()
    BATTLE = GAME_DATA.battleStruct
    if not BATTLE then
        self.dataSet = false
        self.heightData = {}
        self.heightColors = {}
        return
    end
    if not BATTLE.inBattle then
        self.dataSet = false
        self.heightData = {}
        self.heightColors = {}
        return
    end
    if testCanvasOpen then
        local imageSizeX = BATTLE.mapWidth * self.mapScale
        local imageSizeY = BATTLE.mapHeight * self.mapScale
        if not self.dataSet then
            self:initHeightData()
            self.dataSet = true
            ImGui.SetNextWindowPos(25, 25, ImGuiCond.Always)
            ImGui.SetNextWindowSize(imageSizeX, imageSizeY, ImGuiCond.Always)
        end
        ImGui.SetNextWindowBgAlpha(0.0)
        ImGui.SetNextWindowPos(10*eurbackgroundWindowSizeRight, 10*eurbackgroundWindowSizeBottom)
        ImGui.SetNextWindowSize(1024, 1024)
        ImGui.Begin("mao_window_01", true, bit.bor(ImGuiWindowFlags.NoDecoration))
        eurStyle("basic_1", true)
        imageSizeX, imageSizeY = ImGui.GetWindowSize()
        --local io = ImGui.GetIO()
        --self.zoom = math.max(self.zoom + io.MouseWheel * 0.1, 0.1)
        if ImGui.IsMouseDragging(ImGuiMouseButton.Right, 0) then
            local dx, dy = ImGui.GetMouseDragDelta(ImGuiMouseButton.Right)
            self.panX = self.panX + dx
            self.panY = self.panY + dy
            ImGui.ResetMouseDragDelta(ImGuiMouseButton.Right)
        end
        local drawList = ImGui.GetWindowDrawList()
        local canvasX, canvasY = ImGui.GetWindowPos()
        for x = 0, imageSizeX, 24 do
            for y = 0, imageSizeY, 24 do
                local gameX, gameY = self:imageToGame(x, y)
                local color = self.heightColors[gameX][gameY]
                if color then
                    print(color)
                    ImDrawList:AddRectFilled(canvasX + x, canvasY + y, canvasX + x + 24, canvasY + y + 24, 0xFF2E552E)
                end
            end
        end
        self:drawUnits(drawList)
        --self:infoWindow()
        --:unitInfoWindow()
        --self:buildingsWindow()
        eurStyle("basic_1", false)
        ImGui.End()
    end
end

function BATTLE_MAP_WINDOW:buildingsWindow()
    if not BATTLE then
        return
    end
    if not BATTLE.inBattle then
        return
    end
    if not showBuildings then
        return
    end
    ImGui.SetNextWindowPos(1050, 25, ImGuiCond.Once)
    if testCanvasOpen then
        ImGui.Begin("BuildingsWindow", true)
        local boxSizeX, boxSizeY = ImGui.GetContentRegionAvail()
        if ImGui.BeginListBox("Buildings", boxSizeX, boxSizeY) then
            local battleSet = BATTLE:getBattleResidence()
            if battleSet then
                local battleBuildings = battleSet.battleBuildings
                for i = 0, battleBuildings.buildingCount - 1 do
                    local building = battleBuildings:getBuilding(i)
                    if building then
                        local text = "type: " .. building.type .. " | " .. "x: " .. building.posX .. " | " .. "y: " .. building.posY .. " | " .. "z: " .. building.posZ
                        ImGui.Selectable(text, false)
                        if ImGui.IsItemClicked() then
                            self.selectedBuilding = building
                        end
                    end
                end
            end
            ImGui.EndListBox()
        end
        ImGui.End()
    end
end

-- Function to convert game coordinates to image coordinates
function BATTLE_MAP_WINDOW:gameToImage(gameX, gameY)
    local imageCenterX = BATTLE.mapWidth / 2
    local imageCenterY = BATTLE.mapHeight / 2

    -- Apply zoom and scale to game coordinates
    local scaledX = gameX * self.mapScale * self.zoom
    local scaledY = -gameY * self.mapScale * self.zoom

    -- Translate coordinates to image system
    local imageX = scaledX + imageCenterX + self.panX
    local imageY = scaledY + imageCenterY + self.panY

    return math.floor(imageX), math.floor(imageY)
end

-- Function to convert image coordinates to game coordinates
function BATTLE_MAP_WINDOW:imageToGame(imageX, imageY)
    local imageCenterX = BATTLE.mapWidth / 2
    local imageCenterY = BATTLE.mapHeight / 2

    -- Translate image coordinates back to a centered system
    local translatedX = imageX - imageCenterX - self.panX
    local translatedY = imageY - imageCenterY - self.panY

    -- Apply inverse scale and zoom to get game coordinates
    local gameX = translatedX / (self.mapScale * self.zoom)
    local gameY = -translatedY / (self.mapScale * self.zoom)

    return math.floor(clamp(gameX, -imageCenterX, imageCenterX)), math.floor(clamp(gameY, -imageCenterY, imageCenterY))
end



function defineUnitGroup(name)
    if not BATTLE or BATTLE.inBattle == 0 then 
        LOGGER:info("No battle")
        return 
    end
    local unit = getSelectedUnit()
    if not unit then
        LOGGER:info("No Selected Unit")
        return
     end
    local army = unit.army
    if not army then 
        LOGGER:info("No Army")
        return
     end
    local group = army:defineUnitGroup(name, unit)

    LOGGER:info("Group defined")
    local unit2 = nil
    for i = 0, army.numOfUnits - 1 do
        unit2 = army:getUnit(i)
        if unit2 and unit2 ~= unit then
            LOGGER:info("Adding unit to group")
            group:addUnit(unit2)
            LOGGER:info("Unit added to group")
            break
        end
    end
    if unit2 then
        LOGGER:info("Removing unit from group")
        group:removeUnit(unit2)
        LOGGER:info("Unit removed from group")
    else
        LOGGER:info("No other unit found")
    end
    LOGGER:info("Getting group by label")
end

function undefineGroup(name)
    local group2 = BATTLE.getGroupByLabel(name)
    print(group2)
    if group2 then
        LOGGER:info("Group found")
        group2:undefine()
        LOGGER:info("group undefined")
    else
        LOGGER:info("Group not found")
    end
end


function BATTLE_MAP_WINDOW:getSideInfo(sideID)
    aiPlans = {
        [aiPlan.ambush] = "Ambush",
        [aiPlan.attackAll] = "attackAll",
        [aiPlan.attackSettlement] = "attackSettlement",
        [aiPlan.defend] = "defend",
        [aiPlan.defendFeature] = "defendFeature",
        [aiPlan.defendSettlement] = "defendSettlement",
        [aiPlan.doNothing] = "doNothing",
        [aiPlan.hide] = "hide",
        [aiPlan.sallyOut] = "sallyOut",
        [aiPlan.scout] = "scout",
        [aiPlan.withdraw] = "withdraw",
    }

    aiObjectives = {
        [aiObjective.invalid] = "invalid",
        [aiObjective.moveToPoint] = "moveToPoint";
        [aiObjective.attackEnemyBattleGroup] = "attackEnemyBattleGroup",
        [aiObjective.defendTerrainHill] = "defendTerrainHill",
        [aiObjective.defendTerrainForest] = "defendTerrainForest",
        [aiObjective.defendTerrainArea] = "defendTerrainArea",
        [aiObjective.defendCrossing] = "defendCrossing",
        [aiObjective.assaultCrossing] = "assaultCrossing",
        [aiObjective.defendLine] = "defendLine",
        [aiObjective.scout] = "scout",
        [aiObjective.withdraw] = "withdraw",
        [aiObjective.defendSettlement] = "defendSettlement",
        [aiObjective.supportDefendSettlement] = "supportDefendSettlement",
        [aiObjective.attackSettlement] = "attackSettlement",
        [aiObjective.skirmish] = "skirmish",
        [aiObjective.bombard] = "bombard",
        [aiObjective.attackModel] = "attackModel",
        [aiObjective.sallyOut] = "sallyOut",
        [aiObjective.ambush] = "ambush",
    }

    successTypes = {
        [battleSuccess.close] = "Close",
        [battleSuccess.average] = "Average",
        [battleSuccess.clear] = "Clear",
        [battleSuccess.crushing] = "Crushing",
        [4] = "None",
    }

    combatStatusStrings = { 
    
        [combatStatus.notInCombat] = "Not in combat",
        [combatStatus.victoryCertain] = "Victory Certain",
        [combatStatus.victoryAlmostCertain] = "Victory Almost Certain",
        [combatStatus.victoryDistinct] = "Victory Distinct",
        [combatStatus.balanced] = "Balanced",
        [combatStatus.defeatDistinct] = "Defeat Distinct",
        [combatStatus.defeatAlmostCertain] = "Defeat Almost Certain",
        [combatStatus.defeatCertain] = "Defeat Certain",
    
    }
    
    moraleStatusStrings = { 
    
        [moraleStatus.berserk] = "Berserk",
        [moraleStatus.impetuous] = "Impetuous",
        [moraleStatus.high] = "High",
        [moraleStatus.firm] = "Firm",
        [moraleStatus.shaken] = "Shaken",
        [moraleStatus.wavering] = "Wavering",
        [moraleStatus.routing] = "Routing",
    
    }

    local side = BATTLE.sides[sideID]
    if not side then
        return
    end
    local army = side.armies[1].army
    ImGui.Text("Alliance: " .. side.alliance)
    if side.isDefender == true then
        ImGui.Text("Is Defender: true")
    else
        ImGui.Text("Is Defender: false")
    end
    if army.faction.isPlayerControlled == 1 then
        ImGui.Text("Is Player: true")
    else
        ImGui.Text("Is Player: false")
    end
    ImGui.Text("Army size: " .. army.numOfUnits)
    ImGui.Text("Faction: " .. army.faction.localizedName)
    ImGui.Text("Soldier count start: " .. side.soldierCountStart)
    ImGui.Text("Battle Odds: " .. side.battleOdds)
    ImGui.Text("Battle Success: " .. successTypes[side.battleSuccess])
    ImGui.Text("Total strength: " .. side.totalStrength)
    local battleAi = side.battleAIPlan
    ImGui.Text("GTA plan: " .. aiPlans[battleAi.gtaPlan])
    local objCount = battleAi.objectiveCount
    ImGui.Text("Objectives count: " .. objCount)
    if objCount > 0 then
        local objective = battleAi:getObjective(0)
        if objective then
            local type = objective:getType()
            if type > -1 then
                ImGui.Text("GTA objective: " .. aiObjectives[type])
            end
        end
    end
    local battleArmy = side:getBattleArmy(0)
    ImGui.Text("generalHPRatioLost: " .. battleArmy.generalHPRatioLost)
    ImGui.Text("generalNumKillsBattle: " .. battleArmy.generalNumKillsBattle)
    local boxSizeX, boxSizeY = ImGui.GetContentRegionAvail()
    if ImGui.BeginListBox("Units ##" .. sideID, boxSizeX, boxSizeY) then
        for unitID = 0, battleArmy.unitCount - 1 do
            local bUnit = battleArmy:getBattleUnit(unitID)
            local unit = bUnit.unit
            local unitName = unit.eduEntry.eduType
            local unitStatus = unit:getActionStatus()
            local combatStatus = combatStatusStrings[unit.unitPositionData.combatStatus]
            ImGui.Selectable(unitName .. " | " .. unitStatus .. " | " .. combatStatus)
            if ImGui.IsItemClicked(ImGuiMouseButton.Left) then
                self.selectedUnit = bUnit
            end
            if ImGui.IsItemClicked(ImGuiMouseButton.Right) then
                self.targetUnit = bUnit.unit
            end
        end
        ImGui.EndListBox()
    end
    ImGui.Separator()
end

unitWindowOpen = false
infoWindowOpen = true

function BATTLE_MAP_WINDOW:initHeightData()
    local mapRadiusX = BATTLE.mapWidth / 2
    local mapRadiusY = BATTLE.mapHeight / 2
    for x = -mapRadiusX, mapRadiusX, 2 do
        BATTLE_MAP_WINDOW.heightData[x] = {}
        BATTLE_MAP_WINDOW.heightColors[x] = {}
        BATTLE_MAP_WINDOW.heightData[x + 1] = {}
        BATTLE_MAP_WINDOW.heightColors[x + 1] = {}
        BATTLE_MAP_WINDOW.groundColors[x] = {}
        BATTLE_MAP_WINDOW.groundColors[x + 1] = {}
        BATTLE_MAP_WINDOW.ValidityColors[x] = {}
        BATTLE_MAP_WINDOW.ValidityColors[x + 1] = {}
        BATTLE_MAP_WINDOW.zoneColors[x] = {}
        BATTLE_MAP_WINDOW.zoneColors[x + 1] = {}
        for y = -mapRadiusY, mapRadiusY, 2 do
            local height = BATTLE.getBattleMapHeight(x, y)
            local color = math.floor(ImGui.GetColorU32(clamp(0.002 * height, 0, 1), clamp(0.002 * height, 0, 1), clamp(0.002 * height, 0, 1), 1.0))
            BATTLE_MAP_WINDOW.heightData[x][y] = height
            BATTLE_MAP_WINDOW.heightData[x][y + 1] = height
            BATTLE_MAP_WINDOW.heightData[x + 1][y + 1] = height
            BATTLE_MAP_WINDOW.heightData[x + 1][y] = height
            BATTLE_MAP_WINDOW.heightColors[x][y + 1] = color
            BATTLE_MAP_WINDOW.heightColors[x][y] = color
            BATTLE_MAP_WINDOW.heightColors[x + 1][y] = color
            BATTLE_MAP_WINDOW.heightColors[x + 1][y + 1] = color
            local tile = BATTLE.getBattleTile(x, y)
            local ground = tile.physicalGroundType
            color = groundTypes[ground].color
            BATTLE_MAP_WINDOW.groundColors[x][y + 1] = color
            BATTLE_MAP_WINDOW.groundColors[x][y] = color
            BATTLE_MAP_WINDOW.groundColors[x + 1][y] = color
            BATTLE_MAP_WINDOW.groundColors[x + 1][y + 1] = color
            local zoneID = BATTLE.getZoneID(x, y)
            color = math.floor(ImGui.GetColorU32(clamp(0.25 * zoneID, 0, 1), clamp(0.25 * zoneID, 0, 1), clamp(0.25 * zoneID, 0, 1), 1.0))
            BATTLE_MAP_WINDOW.zoneColors[x][y + 1] = color
            BATTLE_MAP_WINDOW.zoneColors[x][y] = color
            BATTLE_MAP_WINDOW.zoneColors[x + 1][y] = color
            BATTLE_MAP_WINDOW.zoneColors[x + 1][y + 1] = color
            local zoneValid = BATTLE.isZoneValid(zoneID)
            if zoneValid then
                color = 0xFF00FF00
            else
                color = 0xFF0000FF
            end
            BATTLE_MAP_WINDOW.ValidityColors[x][y + 1] = color
            BATTLE_MAP_WINDOW.ValidityColors[x][y] = color
            BATTLE_MAP_WINDOW.ValidityColors[x + 1][y] = color
            BATTLE_MAP_WINDOW.ValidityColors[x + 1][y + 1] = color
        end
    end
end

function BATTLE_MAP_WINDOW:unitInfoWindow()
    if self.selectedUnit == nil or not unitWindowOpen then
        return
    end

    combatStatusStrings = { 
    
        [combatStatus.notInCombat] = "Not in combat",
        [combatStatus.victoryCertain] = "Victory Certain",
        [combatStatus.victoryAlmostCertain] = "Victory Almost Certain",
        [combatStatus.victoryDistinct] = "Victory Distinct",
        [combatStatus.balanced] = "Balanced",
        [combatStatus.defeatDistinct] = "Defeat Distinct",
        [combatStatus.defeatAlmostCertain] = "Defeat Almost Certain",
        [combatStatus.defeatCertain] = "Defeat Certain",
    
    }
    
    moraleStatusStrings = { 
    
        [moraleStatus.berserk] = "Berserk",
        [moraleStatus.impetuous] = "Impetuous",
        [moraleStatus.high] = "High",
        [moraleStatus.firm] = "Firm",
        [moraleStatus.shaken] = "Shaken",
        [moraleStatus.wavering] = "Wavering",
        [moraleStatus.routing] = "Routing",
    
    }

    ImGui.SetNextWindowPos(1300, 75, ImGuiCond.Once)
    if testCanvasOpen then
        ImGui.Begin("UnitInfoWindow", unitWindowOpen)
        local battleUnit = self.selectedUnit
        local unit = battleUnit.unit
        local unitPosData = unit.unitPositionData
        ImGui.Text("Unit Name: " .. unit.eduEntry.eduType)
        ImGui.Text("Faction: " .. unit.army.faction.localizedName)
        ImGui.Text("X: " .. unit.battlePosX .. " Y: " .. unit.battlePosY)
        ImGui.Text("Soldiers: " .. unit.soldierCountBattleMap)
        ImGui.Text("Unit Value (Per Soldier): " .. battleUnit.valuePerSoldier)
        ImGui.Text("Action status: " .. unit:getActionStatus())
        ImGui.Text("Morale: " .. moraleStatusStrings[unit.moraleLevel])
        ImGui.Text("Combat Status: " .. combatStatusStrings[unitPosData.combatStatus])
        ImGui.Text("Fatigue: " .. unit.fatigue)
        ImGui.Text("AI active set: " .. unit.aiActiveSet)
        ImGui.Text("Current Ammo: " .. unit.currentAmmo)
        if unitPosData:getTargetUnit() then
            ImGui.Text("Target Unit: " .. unitPosData:getTargetUnit().eduEntry.eduType)
        end
        if unitPosData.engagedUnitsNum > 0 then
            ImGui.Text("Engaged Units: " .. unitPosData.engagedUnitsNum)
            for i = 0, unitPosData.engagedUnitsNum - 1 do
                local engagedUnit = unitPosData:getEngagedUnit(i)
                if engagedUnit then
                    ImGui.Text("Engaged Unit: " .. engagedUnit.eduEntry.eduType)
                end
            end
        end
        if unitPosData.unitsUnderFireFromCount > 0 then
            ImGui.Text("Units under fire from: " .. unitPosData.unitsUnderFireFromCount)
            for i = 0, unitPosData.unitsUnderFireFromCount - 1 do
                local underFireUnit = unitPosData:getUnitUnderFireFrom(i)
                if underFireUnit then
                    ImGui.Text("Under fire from: " .. underFireUnit.eduEntry.eduType)
                end
            end
        end
        ImGui.Text("Soldiers Killed: " .. battleUnit.soldiersKilled)
        ImGui.Text("Soldiers Lost: " .. battleUnit.soldiersLost)
        ImGui.Text("Experience Gained: " .. battleUnit.expGained)
        ImGui.Text("Prisoners Caught: " .. battleUnit.prisonersCaught)
        ImGui.Text("Taken Prisoner: " .. battleUnit.takenPrisoner)
        ImGui.Text("Friendly fire deaths: " .. battleUnit.friendlyFireCasualties)
        if ImGui.Button("Attack closest unit") then
            self:attackClosestUnit()
        end
        ImGui.SameLine()
        if ImGui.Button("Attack target unit") then
            self:attackUnit()
        end
        ImGui.End()
    end
end

function BATTLE_MAP_WINDOW:infoWindow()
    ImGui.SetNextWindowPos(1050, 25, ImGuiCond.Once)
    if testCanvasOpen then
        ImGui.Begin("InfoWindow", infoWindowOpen)
        if (ImGui.Button("Unit Info")) then
            unitWindowOpen = not unitWindowOpen
        end
        ImGui.SameLine()
        if (ImGui.Button("Show Buildings")) then
            showBuildings = not showBuildings
        end
        ImGui.Separator()
        if ImGui.BeginCombo("Map Type", maptypes[1]) then
            for i = 1, #maptypes do
                if ImGui.Selectable(maptypes[i], self.mapType == maptypes[i]) then
                    self.mapType = maptypes[i]
                end
            end
            ImGui.EndCombo()
        end
        if self.selectedUnit then
            ImGui.Text("Selected Unit: " .. self.selectedUnit.unit.eduEntry.eduType)
        else
            ImGui.Text("No unit selected")
        end
        ImGui.Separator()
        if self.targetUnit then
            ImGui.Text("Target Unit: " .. self.targetUnit.eduEntry.eduType)
        else
            ImGui.Text("No target unit selected")
        end
        ImGui.Separator()
        if self.selectedBuilding then
            ImGui.Text("Selected building: " .. self.selectedBuilding.type .. " | " .. "x: " .. self.selectedBuilding.posX .. " | " .. "y: " .. self.selectedBuilding.posY)
        else
            ImGui.Text("No building selected")
        end
        ImGui.Separator()
        if ImGui.BeginTabBar("BattleInfo") then
            if ImGui.BeginTabItem("Side 1") then
                self:getSideInfo(1)
                ImGui.EndTabItem()
            end
            if ImGui.BeginTabItem("Side 2") then
                self:getSideInfo(2)
                ImGui.EndTabItem()
            end
            ImGui.EndTabBar()
        end
        ImGui.End()
    end
end

function printEngines()
    local engines = BATTLE:getBattlefieldEngines()
    for i = 0, engines.engineNum - 1 do
        local engine = engines:getEngine(i)
        print(engine:getType())
    end

end

---comment
---@param drawList ImDrawList
function BATTLE_MAP_WINDOW:drawUnits(drawList)
    GAME_DATA = gameDataAll.get()
    BATTLE = GAME_DATA.battleStruct
    if not BATTLE then
        return
    end
    if BATTLE.inBattle == 0 then
        return
    end
    local colorGate = 0xFFDFFF0F
    local colorTower = 0xFF0FFF00
    local colorWall = 0xFF00FFFF
    local posX, posY = ImGui.GetWindowPos()
    local battleSet = BATTLE:getBattleResidence()
    if battleSet then
        local battleBuildings = battleSet.battleBuildings
        for i = 0, battleBuildings.buildingCount - 1 do
            local build = battleBuildings:getBuilding(i)
            local x, y = build.posX, build.posY
            local imageX, imageY = self:gameToImage(x, y)
            local points = getSquarePoints(imageX, imageY, 10)
            ImGui.SetCursorPos(imageX, imageY)
            ImGui.BeginChild("Building" .. i, 10, 10, 0, ImGuiWindowFlags.NoScrollbar)
            if ImGui.IsMouseHoveringRect(posX + imageX, posY + imageY, posX + imageX + 10, posY + imageY + 10) then
                if ImGui.BeginTooltip() then
                    ImGui.Text("Type: " .. build.type)
                    ImGui.Text("Health: " .. build.currentHealth)
                    ImGui.Text("HealthRatio: " .. build.currentHealth / build.startHealth)
                    ImGui.EndTooltip()
                end
                if ImGui.IsMouseClicked(ImGuiMouseButton.Left) then
                    self.selectedBuilding = build
                end
            end
            local imagePoints = getSquarePoints(posX + imageX, posY + imageY, 5)
            if build == self.selectedBuilding then
                drawList:AddQuadFilled(imagePoints[1][1], imagePoints[1][2], imagePoints[2][1], imagePoints[2][2], imagePoints[3][1], imagePoints[3][2], imagePoints[4][1], imagePoints[4][2], 0xFFFFFFFF)
            elseif build.type == 3 then
                drawList:AddQuadFilled(imagePoints[1][1], imagePoints[1][2], imagePoints[2][1], imagePoints[2][2], imagePoints[3][1], imagePoints[3][2], imagePoints[4][1], imagePoints[4][2], colorGate)
            elseif build.type == 9 then
                drawList:AddQuadFilled(imagePoints[1][1], imagePoints[1][2], imagePoints[2][1], imagePoints[2][2], imagePoints[3][1], imagePoints[3][2], imagePoints[4][1], imagePoints[4][2], colorTower)
            elseif build.type == 10 then
                drawList:AddQuadFilled(imagePoints[1][1], imagePoints[1][2], imagePoints[2][1], imagePoints[2][2], imagePoints[3][1], imagePoints[3][2], imagePoints[4][1], imagePoints[4][2], colorWall)
            end
            ImGui.EndChild()
        end
        local streetCount = battleSet.streetPositionCount
        for i = 0, streetCount - 1 do
            local node = battleSet:getStreetPosition(i)
            local x, y = node.xCoord, node.yCoord
            local imageXStart, imageYStart = self:gameToImage(x, y)
            drawList:AddCircleFilled(posX + imageXStart, posY + imageYStart, 7,  0xFFFFFF00)
        end
    end
    local color = 0xFF0000FF
    for sideID = 1, BATTLE.sidesNum do
        local side = BATTLE.sides[sideID]
        for armyID = 1, side.armiesNum do
            if BATTLE.battleState >= battleState.deployment
            and BATTLE.battleState < battleState.victoryScroll
            then
                local area = side.armies[armyID]:getDeployArea(0)
                local lastLinePointX, lastLinePointY = -999, -999
                local firstLinePointX, firstLinePointY = -999, -999
                for da = 0, area.coordsNum - 1 do
                    if da == 0 then
                        firstLinePointX, firstLinePointY = area:getCoordPair(da).xCoord, area:getCoordPair(da).yCoord
                    end
                    local pos = area:getCoordPair(da)
                    local imageXStart, imageYStart = self:gameToImage(pos.xCoord, pos.yCoord)
                    drawList:AddCircleFilled(posX + imageXStart, posY + imageYStart, 7,  0xFF0000FF)
                    if lastLinePointX ~= -999 then
                        local imageXEnd, imageYEnd = self:gameToImage(lastLinePointX, lastLinePointY)
                        drawList:AddLine(posX + imageXStart, posY + imageYStart, posX + imageXEnd, posY + imageYEnd, 0xFF0000FF)
                    end
                    lastLinePointX, lastLinePointY = pos.xCoord, pos.yCoord
                end
                local imageXStart, imageYStart = self:gameToImage(firstLinePointX, firstLinePointY)
                local imageXEnd, imageYEnd = self:gameToImage(lastLinePointX, lastLinePointY)
                drawList:AddLine(posX + imageXStart, posY + imageYStart, posX + imageXEnd, posY + imageYEnd, 0xFF0000FF)
                
            end
            local army = side.armies[armyID].army
            for unitID = 0, army.numOfUnits - 1 do
                if sideID == 1 then
                    color = 0xFF0000FF
                else
                    color = 0xFF00FF00
                end
                local unit = army:getUnit(unitID)
                local x, y = unit.battlePosX, unit.battlePosY
                local imageX, imageY = self:gameToImage(x, y)
                local borderColor = 0xFFFFFFFF
                if (unit.eduEntry.class == unitClass.missile) then
                    borderColor = 0xFF00FFFF
                elseif (unit.eduEntry.class == unitClass.heavy) then
                    borderColor = 0xFFff00FF
                elseif (unit.eduEntry.class == unitClass.light) then
                    borderColor = 0xFFFFFF00
                end
                if unit.unitPositionData.hasTargets
                and unit:getActionStatus() ~= "routing"
                and unit:getActionStatus() ~= "leaving_battle"
                and unit:getActionStatus() ~= "dead"
                and unit:getActionStatus() ~= "left_battle"
                then
                    local targetX, targetY = unit.unitPositionData.lastTargetCoordX, unit.unitPositionData.lastTargetCoordY
                    local targetImageX, targetImageY = self:gameToImage(targetX, targetY)
                    drawList:AddLine(posX + imageX, posY + imageY, posX + targetImageX, posY + targetImageY, color)
                end
                if self.selectedUnit and self.selectedUnit.unit and unit == self.selectedUnit.unit then
                    color = 0xFFFF0000
                end
                if self.targetUnit and unit == self.targetUnit then
                    color = 0xFF00FFFF
                end
                if (unit.eduEntry.category == unitCategory.infantry) then
                    drawList:AddCircleFilled(posX + imageX, posY + imageY, 7, color)
                    drawList:AddCircle(posX + imageX, posY + imageY, 7, borderColor)
                elseif (unit.eduEntry.category == unitCategory.cavalry) then
                    local points = getTrianglePoints(posX + imageX, posY + imageY, 10)
                    drawList:AddTriangleFilled(points[1][1], points[1][2], points[2][1], points[2][2], points[3][1], points[3][2], color)
                    drawList:AddTriangle(points[1][1], points[1][2], points[2][1], points[2][2], points[3][1], points[3][2], borderColor)
                elseif (unit.eduEntry.category == unitCategory.siege) then
                    local points = getSquarePoints(posX + imageX, posY + imageY, 10)
                    drawList:AddQuadFilled(points[1][1], points[1][2], points[2][1], points[2][2], points[3][1], points[3][2], points[4][1], points[4][2], color)
                    drawList:AddQuad(points[1][1], points[1][2], points[2][1], points[2][2], points[3][1], points[3][2], points[4][1], points[4][2], borderColor)
                end
            end
        end
    end
end

function getTrianglePoints(x, y, size)
    local points = {}
    local halfSize = size / 2
    points[1] = {x - halfSize, y + halfSize}
    points[2] = {x, y - halfSize}
    points[3] = {x + halfSize, y + halfSize}
    return points
end

function getSquarePoints(x, y, size)
    local points = {}
    local halfSize = size / 2
    points[1] = {x - halfSize, y + halfSize}
    points[2] = {x + halfSize, y + halfSize}
    points[3] = {x + halfSize, y - halfSize}
    points[4] = {x - halfSize, y - halfSize}
    return points
end

function getSelectedUnit()
    GAME_DATA = gameDataAll.get()
    UI_MANAGER = GAME_DATA.uiCardManager
    if UI_MANAGER.selectedUnitCardsCount > 0 then
        return UI_MANAGER:getSelectedUnitCard(0)
    end
    return nil
end

function moveUnit(xPos, yPos)
    local unit = getSelectedUnit()
    if unit then
        unit:moveToPosition(xPos, yPos, true)
    end
end

function BATTLE_MAP_WINDOW:moveUnit(xPos, yPos)
    if not self.selectedUnit then
        return
    end
    local unit = self.selectedUnit.unit
    if unit then
        unit:moveToPosition(xPos, yPos, true)
    end
end

function BATTLE_MAP_WINDOW:haltUnit()
    local unit = self.selectedUnit.unit
    if unit then
        unit:halt()
    end
end

function BATTLE_MAP_WINDOW:attackGate()
    local unit = self.selectedUnit.unit
    local gate = self.selectedBuilding
    if unit and gate then
        unit:attackBuilding(gate)
    end
end

function BATTLE_MAP_WINDOW:placeUnit(xPos, yPos)
    local unit = self.selectedUnit.unit
    if unit then
        unit:immediatePlace(xPos, yPos, 0, 0)
    end
end

function BATTLE_MAP_WINDOW:attackClosestUnit()
    local unit = self.selectedUnit.unit
    if unit then
        unit:attackClosestUnit(180, true)
    end
end

function BATTLE_MAP_WINDOW:attackUnit()
    local unit = self.selectedUnit.unit
    local targetUnit = self.targetUnit
    if unit and targetUnit then
        unit:attackUnit(targetUnit, true)
    end
end

function placeUnit(xPos, yPos)
    GAME_DATA = gameDataAll.get()
    UI_MANAGER = GAME_DATA.uiCardManager
    if UI_MANAGER.selectedUnitCardsCount > 0 then
        local myUnit = UI_MANAGER:getSelectedUnitCard(0)
        if myUnit then
            myUnit:immediatePlace(xPos, yPos, 0, 0)
        end
    end
end

function placeUnitManual(rotation)
    GAME_DATA = gameDataAll.get()
    UI_MANAGER = GAME_DATA.uiCardManager
    if UI_MANAGER.selectedUnitCardsCount > 0 then
        local myUnit = UI_MANAGER:getSelectedUnitCard(0)
        if myUnit then
            myUnit:immediatePlace(myUnit.battlePosX, myUnit.battlePosY, rotation, 0)
        end
    end
end

function attackClosest()
    local unit = getSelectedUnit()
    if unit then
        unit:attackClosestUnit(0, true)
    end
end

function attackClosest2()
    local unit = getSelectedUnit()
    if unit then
        unit:attackClosestUnit(180, true)
    end
end


groundTypes = {
    [0] = {
        name = "Grass short",
        color = 0xFF00000F
    },
    [1] = {
        name = "Grass long",
        color = 0xFF0000F0
    },
    [2] = {
        name = "Sand",
        color = 0xFF000F00
    },
    [3] = {
        name = "Rock",
        color = 0xFF00F000
    },
    [4] = {
        name = "Forest Dense",
        color = 0xFF0F0000
    },
    [5] = {
        name = "Scrub Dense",
        color = 0xFFF00000
    },
    [6] = {
        name = "Swamp",
        color = 0xFFF0000F
    },
    [7] = {
        name = "Mud",
        color = 0xFFF000F0
    },
    [8] = {
        name = "Mud Road",
        color = 0xFFF00F00
    },
    [9] = {
        name = "Stone Road",
        color = 0xFFF0F000
    },
    [10] = {
        name = "Water",
        color = 0xFFFF0000
    },
    [11] = {
        name = "Ice",
        color = 0xFFFF000F
    },
    [12] = {
        name = "Snow",
        color = 0xFFFF00F0
    },
    [13] = {
        name = "Wood",
        color = 0xFFFF0F00
    },
    [14] = {
        name = "Dirt",
        color = 0xFFFFF000
    },
    [15] = {
        name = "Unknown",
        color = 0xFFFFF00F
    }
}