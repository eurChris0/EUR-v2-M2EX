
function spawnGeneralLargeArmy(faction)
    if not options_general_large_army then return end
    if faction.name == "rebels" then return end
    local alliance = eur_campaign:checkDipStance(dipRelType.alliance, eur_player_faction, faction)
    if alliance then return end
    for i = 0, faction.armiesNum - 1 do
        if faction:getCharacterCountOfType(characterType.named_character) < (faction.settlementsNum + 2) then
            local army = faction:getArmy(i)
            if army ~= nil then
                if army.leader ~= nil then
                    if army.leader:getTypeID() ~= characterType.named_character then
                        if army.numOfUnits > 6 then
                            if army.numOfUnits < 20 then
                                local charmy = eurSpawnArmy(faction.name, "random_name", "large_army_", "", false, 31, default_general_units[faction.name].old, army.xCoord, army.yCoord, 2, 1, 0)
                                if charmy ~= nil then
                                    M2TWEOP.logGame("EUR SCRIPT check: "..army.leader.characterRecord.fullName);
                                    M2TWEOP.logGame("EUR SCRIPT check: "..faction.name);
                                    M2TWEOP.logGame(army.xCoord);
                                    M2TWEOP.logGame(army.yCoord);
                                    charmy.leader.characterRecord:addTrait("AIBoost", 1)
                                    charmy.leader.characterRecord:addTrait("BattleScarred", 2)
                                    charmy.leader.characterRecord:addTrait("GoodAmbusher", 2)
                                    charmy.leader.characterRecord:addTrait("GoodCommander", 3)
                                    charmy.leader.characterRecord:addTrait("LoyaltyStarter", 1)
                                    charmy.leader.characterRecord:addTrait("PietyStarter", 1)
                                    charmy:mergeArmies(army)
                                    --print("============================creating general", army.xCoord, army.yCoord, faction.name)
                                    setBGSize(faction, nil, nil)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
