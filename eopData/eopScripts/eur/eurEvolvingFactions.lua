

local FACTION_EVO = {
    ["milan"] = { --Rohan
        capital = "Edoras",
        names = {"Rohirrim","Riders of the Mark","The Riddermark","Kingdom of Rohan","Realm of the Eorlingas"},
    },
    ["sicily"] = { --Gondor
        capital = "Minas Tirith",
        names = {"Broken Remnants of Gondor","Remnants of Gondor","Fiefdoms of Gondor","Great Fiefdoms of Gondor","Kingdom of Gondor"},
    },
    ["turks"] = { --Dunedain
        capital = "Fornost",
        names = {"Rangers of the North","Wandering Dúnedain","Wardens of Eriador","Dúnedain of the North Kingdom","Reunited Arnorian Realms"},
    },
    ["russia"] = { --Ar-adunaim
        capital = "Armenelos",
        names = {"King's Men Remnants","Ar-Adûnâim","Dominion of the King’s Men","True Sons of Númenor","Númenor Reborn"},
    },
    ["scotland"] = { --Dale
        capital = "Dale",
        names = {"City of Dale","Survivors of Dale","Men of Dale","Kingdom of Dale","Kingdom of Rhovanion"},
    },
    ["byzantium"] = { --Dorwinion
        capital = "Dorwinion",
        names = {"Merchants of Dorwinion","Wanderers of Dorwinion","Wine Lords","Kingdom of Dorwinion","Kingdom of Vine and Vale"},
    },
    ["timurids"] = { --Anduin Vale
        capital = "Cair Andros",
        names = {"River Folk","River Wanderers","Men of the Carrock","The Vale of Anduin","Kingdom of the Éothéod"},
    },
    ["portugal"] = { --Angmar
        capital = "Carn Dûm",
        names = {"Shadows of Angmar","Remnants of Angmar","Dominion of Carn Dûm","Witch-Realm of Angmar","The Iron Crown"},
    },
    ["aztecs"] = { --Dunland
        capital = "Dunharrow",
        names = {"Hillmen of Dunland","Broken Tribes","Clans of Dunland","Clanholds of Dunland","Dunlending Confederacy"},
    },
    ["teutonic_order"] = { --Clans of Enedwaith
        capital = "Tharbad",
        names = {"Wild Men of Enedwaith","Shattered Clans","Tribe of the Middlemen","Clans of Enedwaith","Confederacy of Gwathuirim"},
    },
    ["spain"] = { --Harad
        capital = "Umbar",
        names = {"Southrons","Southrons Remnants","Tribes of Harad","Kingdoms of The Sands","Empire of Haradwaith"},
    },
    ["khand"] = { --Khand
        capital = "Variag City",
        names = {"Variags of Khand","Variag Nomads","Warlords of Khand","Lords of the Flailing Wind","Great Khaganate of The East"},
    },
    ["venice"] = { --Rhun
        capital = "Rhûn",
        names = {"Easterlings Tribes","Exiled Easterlings","Lands of Rhûn","Wainriders of the Far East","Dragonlords of Rhûn"},
    },
    ["norway"] = { --Khazad-dum
        capital = "Khazad-dûm",
        names = {"Balin's Expedition","Exiles of Khazad-dûm","Halls of Dwarrowdelf","Guardians of the Mirrormere","Kingdom of Khazad-dûm"},
    },
    ["hungary"] = { --Ered Luin
        capital = "Belegost",
        names = {"Delves of Ered Luin","Scattered Longbeards","Wardens of the Blue Mountains","Kingdom of Ered Luin","Heirs of Durin"},
    },
    ["moors"] = { --Erebor
        capital = "Erebor",
        names = {"The Lonely Mountain","Exiles of Erebor","Kingdom under the Mountain","Kingdom of the Iron Hills","Crown of Erebor"},
    },
    ["mongols"] = { --Woodland Realm
        capital = "Thranduil's Halls",
        names = {"Wood-elves","Wanderers of Greenwood","Elves of Greenwood","The Woodland Realm","Realm of Eryn Lasgalen"},
    },
    ["ireland"] = { --Lothlorien
        capital = "Caras Galadhon",
        names = {"Elves of Lórien","Wandering Galadhrim","Elves of the Golden Wood","Realm of Lórien","Realm of the Galadhrim"},
    },
    ["denmark"] = { --Lindon
        capital = "Mithlond",
        names = {"Grey Havens","Wayfarers of Lindon","Mariners of Lindon","High Havens of Lindon","Kingdom of Lindon"},
    },
    ["england"] = { --Mordor
        capital = "Barad-dûr",
        names = {"Orcs of Mordor","Ashes of Mordor","The Black Land","The Black Realm of Mordor","Dominion of the Dark Lord"},
    },
    ["poland"] = { --Dol Guldur
        capital = "Dol Guldur",
        names = {"Servants of Darkness","Fleeing Orcs","Domain of Spiders","Shadow of Mirkwood","Realm of the Necromancer"},
    },
    ["hre"] = { --Goblins of the Misty Mountains
        capital = "Goblin-town",
        names = {"Feral Goblins","Scattered Tribes of Moria","Hordes of the Misty Mountains","Chiefdoms of Moria","Empire of Shadow and Flame"},
    },
    ["gundabad"] = { --Gundabad
        capital = "Mount Gundabad",
        names = {"War-host of Gundabad","Remnants of Gundabad","Pale Orcs of Gundabad","Stronghold of Gundabad","Snow Kingdom of Gundabad"},
    },
    ["france"] = { --Isengard
        capital = "Isengard",
        names = {"Tower of Orthanc","Sharkey's Band","Host of Isengard","Dominion of the White Hand","Dominion of Saruman the Wise"},
    },
    ["saxons"] = { --Imladris
        capital = "Imladris",
        names = {"Last Homely House","Hidden Valley of Imladris","Household of Elrond","Lordship of Imladris","Realm of Imladris"},
    },
    ["egypt"] = { --Eregion
        capital = "Ost-in-Edhil",
        names = {"Oathsworn of Maernil","Remnants of Eregion","Principality of Eregion","Kingdom of Eregion","High Kingdom of the Fëanorians"},
    },
}

function checkEvolvingFaction(faction)
    if FACTION_EVO[faction.name] ~= nil then
        --local capital=eur_campaign:getSettlementByName(FACTION_EVO[faction.name].capital)
        --if capital.ownerFaction.name == faction.name then
            if faction.settlementsNum >= 15 then
                faction.localizedName = FACTION_EVO[faction.name].names[5]
            elseif faction.settlementsNum >= 10 then
                faction.localizedName = FACTION_EVO[faction.name].names[4]
            elseif faction.settlementsNum >= 5 then
                faction.localizedName = FACTION_EVO[faction.name].names[3]
            elseif faction.settlementsNum >= 1 then
                faction.localizedName = FACTION_EVO[faction.name].names[1]
            end
        --else
            --faction.localizedName = FACTION_EVO[faction.name].names[5]
        --end
    end
end

function checkEvoCounters()
    if checkCounter("arnor_restored") and checkCounter("reunited_kingdom") then
        FACTION_EVO["turks"].names = {"Reunited Kingdoms","Realms in Exile","Reunited Kingdoms","Reunited Kingdoms","Reunited Kingdoms"}
    elseif checkCounter("arnor_restored") then
        FACTION_EVO["turks"].names = {"Kingdom of Arnor","Shattered Dúnedain of the North","Kingdom of Arnor","Kingdom of Arnor","High Kingdom of Arnor"}
    end
    if checkCounter("kon_council_choice_accepted") then
        FACTION_EVO["denmark"].names = {"Kingdom of the Ñoldor","Exiles of the Ñoldor","Kingdom of the Ñoldor","Kingdom of the Ñoldor","High Kingdom of the Ñoldor"}
        FACTION_EVO["saxons"].names = {"Kingdom of the Ñoldor","Exiles of the Ñoldor","Kingdom of the Ñoldor","Kingdom of the Ñoldor","High Kingdom of the Ñoldor"}
    end
    if checkCounter("elven_union") then
        FACTION_EVO["mongols"].names = {"Union of the Silvan Elves","Sundered Woods of the Eldar","Union of the Silvan Elves","Union of the Silvan Elves","Union of the Silvan Elves"}
        FACTION_EVO["ireland"].names = {"Union of the Silvan Elves","Sundered Woods of the Eldar","Union of the Silvan Elves","Union of the Silvan Elves","Union of the Silvan Elves"}
    end
    if checkCounter("durin_king_end") then
        FACTION_EVO["moors"].names = {"Kingdom of Durin the Reclaimer","Sundered Houses of Durin","Kingdom of Durin the Reclaimer","Kingdom of Durin the Reclaimer","Kingdom of Durin the Reclaimer"}
        FACTION_EVO["hungary"].names = {"Kingdom of Durin the Reclaimer","Sundered Houses of Durin","Kingdom of Durin the Reclaimer","Kingdom of Durin the Reclaimer","Kingdom of Durin the Reclaimer"}
    end
    if checkCounter("sauron_ai") then
        FACTION_EVO["england"].names = {"Dominion of the One Ring","Remnants of the Shadow","Dominion of the One Ring","Dominion of the One Ring","Dominion of the One Ring"}
        FACTION_EVO["poland"].names = {"Dominion of the One Ring","Remnants of the Shadow","Dominion of the One Ring","Dominion of the One Ring","Dominion of the One Ring"}
    end
    if checkCounter("keep_ring_maernil") then
        FACTION_EVO["egypt"].names = {"High Kingdom of the Ringlords","Remnants of Eregion","High Kingdom of the Ringlords","High Kingdom of the Ringlords","High Kingdom of the Ringlords"}
    end
    if checkCounter("keep_ring_mazog") then
        FACTION_EVO["gondabad"].names = {"Legacy of the First Darkness","Remnants of Gundabad","Legacy of the First Darkness","Legacy of the First Darkness","Legacy of the First Darkness"}
    end
    if checkCounter("keep_ring_galadriel") then
        FACTION_EVO["lorien"].names = {"Queendom of Yavanna's Chosen","Wandering Galadhrim","Queendom of Yavanna's Chosen","Queendom of Yavanna's Chosen","Queendom of Yavanna's Chosen"}
    end
    if checkCounter("keep_ring_isengard") then
        FACTION_EVO["france"].names = {"Empire of Many Colors","Sharkey's Band","Empire of Many Colors","Empire of Many Colors","Empire of Many Colors"}
    end
    if checkCounter("keep_ring_agandaur") then
        FACTION_EVO["portugal"].names = {"Faithful of Agandaûr the Great","Remnants of Angmar","Faithful of Agandaûr the Great","Faithful of Agandaûr the Great","Faithful of Agandaûr the Great"}
    end
    if checkCounter("keep_ring_rhukar") then
        FACTION_EVO["venice"].names = {"Dragon Empire of Rhûn","Exiled Easterlings","Dragon Empire of Rhûn","Dragon Empire of Rhûn","Dragon Empire of Rhûn"}
    end
end