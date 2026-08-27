


function swapRKBarracks()
    local faction = eur_player_faction
    for i = 0, faction.settlementsNum - 1 do
        local sett = faction:getSettlement(i)
        if sett ~= nil then
            if eur_player_faction.name == "turks" then
                if sett.isCastle == 0 then
                    local replace = false
                    if sett:buildingPresent("barracks") then
                        sett:destroyBuilding("barracks",false);
                        replace = true
                    end
                    if sett:buildingPresent("equestrian") then
                        sett:destroyBuilding("equestrian",false);
                    end
                    if sett:buildingPresent("missiles") then
                        sett:destroyBuilding("missiles",false);
                    end
                    if replace then
                        if not sett:buildingPresent("dunedain_barracks") then
                            --make new barracks t1
                            sett:createBuilding("dunedain_warcamp")
                        end
                    end
                else
                    local replace = false
                    if sett:buildingPresent("castle_barracks") then
                        sett:destroyBuilding("castle_barracks",false);
                        replace = true
                    end
                    if sett:buildingPresent("c_equestrian") then
                        sett:destroyBuilding("c_equestrian",false);
                    end
                    if sett:buildingPresent("c_missiles") then
                        sett:destroyBuilding("c_missiles",false);
                    end
                    if replace then
                        if not sett:buildingPresent("c_dunedain_barracks") then
                            --make new barracks t1
                            sett:createBuilding("c_dunedain_warcamp")
                        end
                    end
                end
            elseif eur_player_faction.name == "sicily" then
                if sett.isCastle == 0 then
                    local replace = false
                    if sett:buildingPresent("dunedain_barracks") then
                        sett:destroyBuilding("dunedain_barracks",false);
                        replace = true
                    end
                    if replace then
                        if not sett:buildingPresent("barracks") then
                            --make new barracks t1
                            sett:createBuilding("town_guard")
                        end
                        if not sett:buildingPresent("equestrian") then
                            --make new barracks t1
                            sett:createBuilding("stables")
                        end
                        if not sett:buildingPresent("missiles") then
                            --make new barracks t1
                            sett:createBuilding("practice_range")
                        end
                    end
                else
                    local replace = false
                    if sett:buildingPresent("c_dunedain_barracks") then
                        sett:destroyBuilding("c_dunedain_barracks",false);
                        replace = true
                    end
                    if replace then
                        if not sett:buildingPresent("castle_barracks") then
                            --make new barracks t1
                            sett:createBuilding("garrison_quarters")
                        end
                        if not sett:buildingPresent("c_missiles") then
                            --make new barracks t1
                            sett:createBuilding("c_practice_range")
                        end
                        if not sett:buildingPresent("c_equestrian") then
                            --make new barracks t1
                            sett:createBuilding("c_stables")
                        end
                    end
                end
            end
        end
    end
    game_options.eurRKcomplete = true
end