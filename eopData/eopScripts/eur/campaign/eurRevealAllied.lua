function revealAllied()
    if game_options.reveal_allied then
        for i = 0, eur_campaign.numberOfFactions - 1 do
            local faction = eur_campaign:getFactionByOrder(i)
            if faction ~= eur_player_faction then
                local alliance = eur_campaign:checkDipStance(dipRelType.alliance, eur_player_faction, faction)
                if alliance then
                    for x = 0, faction.numOfCharacters - 1 do
                        local char = faction:getCharacter(x)
                        if char ~= nil then
                            if (char.characterType == 6) or (char.characterType == 7) then
                                if not (char.settlement or char.fort) then
                                    --if char.characterRecord.fullName ~= "Durin" then
                                        local tile = M2TW.stratMap.getTile(char.xCoord, char.yCoord)
                                        if tile ~= nil then
                                            if not tile.fort and not tile.settlement then
                                                if char.xCoord ~= nil and char.yCoord ~= nil then
                                                    revealTilesAround(char.xCoord, char.yCoord)
                                                end
                                            end
                                        end
                                    --end
                                end
                            end
                        end
                    end
                    for y = 0, faction.settlementsNum - 1 do
                        local sett = faction:getSettlement(y)
                        if sett ~= nil then
                            revealTilesAround(sett.xCoord, sett.yCoord)
                        end
                    end
                end
            end
        end
    end
    if eur_event_active then
        mirrorCheck()
        anorStoneCheck()
    end
end