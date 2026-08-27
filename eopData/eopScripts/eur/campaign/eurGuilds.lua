engineer_boost_set = false

faction_artillery_list = {
    ["moors"] = {"Dwarven Catapult", "Dwarven Ballista"},
    ["hungary"] = {"Ered Luin Catapult", "Ered Luin Ballista"},
    ["norway"] = {"Dwarven Catapult", "Dwarven Ballista"},
    ["sicily"] = {"Gondor Catapult", "Gondor Ballista", "Gondor Trebuchet"},
    ["turks"] = {"Eriador Catapult", "Eriador Ballista", "Eriador Trebuchet"},
    ["byzantium"] = {"Westron Catapult", "Westron Ballista"},
    ["scotland"] = {"Westron Catapult", "Westron Ballista"},
    ["milan"] = {"Westron Catapult", "Westron Ballista"},
}

function checkEngineerGuild()
    if not faction_artillery_list[eur_player_faction.name] then return end
    local guild_present = false
    for x = 0, eur_player_faction.settlementsNum - 1 do
        local sett = eur_player_faction:getSettlement(x)
        if sett ~= nil then
            if sett:buildingPresentMinLevel("m_engineer_guild", false) then
                guild_present = true
            end
        end
    end
    if guild_present then
        if not engineer_boost_set then
            setEngineerGuildBoost(true)
        end
    else
        if engineer_boost_set then
            setEngineerGuildBoost(false)
        end
    end
end

function setEngineerGuildBoost(bool)
    if not faction_artillery_list[eur_player_faction.name] then return end
    if bool then
        for i = 0, #faction_artillery_list[eur_player_faction.name] do
            local eduEntry=M2TWEOPDU.getEduEntryByType(faction_artillery_list[eur_player_faction.name][i]);
            if eduEntry ~= nil then
                if eduEntry.engineStats ~= nil then
                    eduEntry.engineStats.ammo = eduEntry.engineStats.ammo + 4
                end
            end
        end
        engineer_boost_set = true
    else
        for i = 0, #faction_artillery_list[eur_player_faction.name] do
            local eduEntry=M2TWEOPDU.getEduEntryByType(faction_artillery_list[eur_player_faction.name][i]);
            if eduEntry ~= nil then
                if eduEntry.engineStats ~= nil then
                    eduEntry.engineStats.ammo = eduEntry.engineStats.ammo - 4
                end
            end
        end
        engineer_boost_set = false
    end
end