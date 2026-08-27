
CUSTOM_UNIT_ADD = {
    [1] = {
        faction = "turks",
        eduType = "Grey Company",
        newMax = 35,
        newUpkeep = 600,
        bu = "hinterland_unique6",
        level = 2,
        scope = {0.8, 0.036, 1.0, 2,},
        extra = "factions { turks, }",
    },
    [2] = {
        faction = "saxons",
        eduType = "GilGalads Company",
        newMax = 35,
        newUpkeep = 775,
        bu = "hinterland_tharbad_bridge",
        level = 2,
        scope = {0.8, 0.036, 1.0, 2,},
        extra = "factions { saxons, }",
    },
    [3] = {
        faction = "france",
        eduType = "Guard of the Hand",
        newMax = 35,
        newUpkeep = 500,
        bu = "castle_hall",
        level = nil,
        scope = {0.8, 0.036, 1.0, 2,},
        extra = "factions { france, }  and hidden_resource Rohan and hidden_resource ResA",
    },
    [4] = {
        faction = "denmark",
        eduType = "Falas Lords",
        newMax = 48,
        newUpkeep = 775,
        bu = "city_hall",
        level = nil,
        scope = {0.8, 0.036, 1.0, 2,},
        extra = "factions { denmark, }  and hidden_resource Lindon and hidden_resource ResE",
    },
    [5] = {
        faction = "norway",
        eduType = "Balins Guard",
        newMax = 35,
        newUpkeep = 775,
        bu = "city_hall",
        level = nil,
        scope = {0.8, 0.036, 1.0, 2,},
        extra = "factions { norway, }  and hidden_resource Eregion and hidden_resource ResI",
    },
    [6] = {
        faction = "sicily",
        eduType = "The White Company",
        newMax = 48,
        newUpkeep = 600,
        bu = "hinterland_unique1",
        level = 0,
        scope = {0.8, 0.036, 1.0, 2,},
        extra = "factions { turks, sicily }",
    },
}

function addCustomBGToPool()
    for i = 1, #CUSTOM_UNIT_ADD do
        local unit = M2TWEOPDU.addEopEduEntryFromEDUID(M2TWEOPDU.getEduIndexByType(CUSTOM_UNIT_ADD[i].eduType),5000+i);
        if unit then
            unit:setOwnership(faction_id_list[CUSTOM_UNIT_ADD[i].faction], true)
            unit.soldierCount = CUSTOM_UNIT_ADD[i].newMax
            unit.upkeepCost = CUSTOM_UNIT_ADD[i].newUpkeep
        end
    end
end

function enableExtraBG()
    for i = 1, #CUSTOM_UNIT_ADD do
        local building = EDB.getBuildingByName(CUSTOM_UNIT_ADD[i].bu)
        if building then
            if CUSTOM_UNIT_ADD[i].level == nil then
                for j = 0, building.buildingLevelCount -1 do
                    local bu = building:getBuildingLevel(j)
                    if bu then
                        EDB.addBuildingPool(building, j, 5000+i, CUSTOM_UNIT_ADD[i].scope[1], CUSTOM_UNIT_ADD[i].scope[2], CUSTOM_UNIT_ADD[i].scope[3], CUSTOM_UNIT_ADD[i].scope[4], CUSTOM_UNIT_ADD[i].extra);
                    end
                end
            else
                local bu = building:getBuildingLevel(CUSTOM_UNIT_ADD[i].level)
                if bu then
                    EDB.addBuildingPool(building, CUSTOM_UNIT_ADD[i].level, 5000+i, CUSTOM_UNIT_ADD[i].scope[1], CUSTOM_UNIT_ADD[i].scope[2], CUSTOM_UNIT_ADD[i].scope[3], CUSTOM_UNIT_ADD[i].scope[4], CUSTOM_UNIT_ADD[i].extra);
                end
            end
        end
    end
end

function removeCustomBGFromPool()
    for i = 1, #CUSTOM_UNIT_ADD do
        local unit = M2TWEOPDU.getEopEduEntryByID(5000+i);
        if unit then
            local building = EDB.getBuildingByName(CUSTOM_UNIT_ADD[i].bu)
            if building then
                if CUSTOM_UNIT_ADD[i].level == nil then
                    local bu = building:getBuildingLevel(CUSTOM_UNIT_ADD[i].level)
                    if bu then
                        for x = 0, bu.recruitPoolNum - 1 do
                            local pool = bu:getRecruitPool(x)
                            if pool then
                                if pool.unitID == 5000+i then
                                    bu:removeRecruitPool(x)
                                end
                            end
                        end
                    end
                else
                    for j = 0, building.buildingLevelCount -1 do
                        local bu = building:getBuildingLevel(j)
                        if bu then
                            for x = 0, bu.recruitPoolNum - 1 do
                                local pool = bu:getRecruitPool(x)
                                if pool then
                                    if pool.unitID == 5000+i then
                                        bu:removeRecruitPool(x)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

