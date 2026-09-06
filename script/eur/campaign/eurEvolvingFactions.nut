// Faction display names that evolve with empire size. Each faction's `names`
// list is [tier1, tier2, tier3, tier4, tier5]; tiers are chosen by settlement
// count in checkEvolvingFaction. checkEvoCounters swaps whole name lists when a
// story event counter fires.

::EUR.FACTION_EVO <- {
    milan          = { capital = "Edoras",           names = ["Rohirrim", "Riders of the Mark", "The Riddermark", "Kingdom of Rohan", "Realm of the Eorlingas"] },                                  // Rohan
    sicily         = { capital = "Minas Tirith",      names = ["Broken Remnants of Gondor", "Remnants of Gondor", "Fiefdoms of Gondor", "Great Fiefdoms of Gondor", "Kingdom of Gondor"] },          // Gondor
    turks          = { capital = "Fornost",           names = ["Rangers of the North", "Wandering Dúnedain", "Wardens of Eriador", "Dúnedain of the North Kingdom", "Reunited Arnorian Realms"] },   // Dunedain
    russia         = { capital = "Armenelos",         names = ["King's Men Remnants", "Ar-Adûnâim", "Dominion of the King’s Men", "True Sons of Númenor", "Númenor Reborn"] },                       // Ar-adunaim
    scotland       = { capital = "Dale",              names = ["City of Dale", "Survivors of Dale", "Men of Dale", "Kingdom of Dale", "Kingdom of Rhovanion"] },                                     // Dale
    byzantium      = { capital = "Dorwinion",         names = ["Merchants of Dorwinion", "Wanderers of Dorwinion", "Wine Lords", "Kingdom of Dorwinion", "Kingdom of Vine and Vale"] },              // Dorwinion
    timurids       = { capital = "Cair Andros",       names = ["River Folk", "River Wanderers", "Men of the Carrock", "The Vale of Anduin", "Kingdom of the Éothéod"] },                             // Anduin Vale
    portugal       = { capital = "Carn Dûm",          names = ["Shadows of Angmar", "Remnants of Angmar", "Dominion of Carn Dûm", "Witch-Realm of Angmar", "The Iron Crown"] },                      // Angmar
    aztecs         = { capital = "Dunharrow",         names = ["Hillmen of Dunland", "Broken Tribes", "Clans of Dunland", "Clanholds of Dunland", "Dunlending Confederacy"] },                       // Dunland
    teutonic_order = { capital = "Tharbad",           names = ["Wild Men of Enedwaith", "Shattered Clans", "Tribe of the Middlemen", "Clans of Enedwaith", "Confederacy of Gwathuirim"] },           // Clans of Enedwaith
    spain          = { capital = "Umbar",             names = ["Southrons", "Southrons Remnants", "Tribes of Harad", "Kingdoms of The Sands", "Empire of Haradwaith"] },                             // Harad
    khand          = { capital = "Variag City",       names = ["Variags of Khand", "Variag Nomads", "Warlords of Khand", "Lords of the Flailing Wind", "Great Khaganate of The East"] },             // Khand
    venice         = { capital = "Rhûn",              names = ["Easterlings Tribes", "Exiled Easterlings", "Lands of Rhûn", "Wainriders of the Far East", "Dragonlords of Rhûn"] },                   // Rhun
    norway         = { capital = "Khazad-dûm",        names = ["Balin's Expedition", "Exiles of Khazad-dûm", "Halls of Dwarrowdelf", "Guardians of the Mirrormere", "Kingdom of Khazad-dûm"] },      // Khazad-dum
    hungary        = { capital = "Belegost",          names = ["Delves of Ered Luin", "Scattered Longbeards", "Wardens of the Blue Mountains", "Kingdom of Ered Luin", "Heirs of Durin"] },          // Ered Luin
    moors          = { capital = "Erebor",            names = ["The Lonely Mountain", "Exiles of Erebor", "Kingdom under the Mountain", "Kingdom of the Iron Hills", "Crown of Erebor"] },            // Erebor
    mongols        = { capital = "Thranduil's Halls", names = ["Wood-elves", "Wanderers of Greenwood", "Elves of Greenwood", "The Woodland Realm", "Realm of Eryn Lasgalen"] },                      // Woodland Realm
    ireland        = { capital = "Caras Galadhon",    names = ["Elves of Lórien", "Wandering Galadhrim", "Elves of the Golden Wood", "Realm of Lórien", "Realm of the Galadhrim"] },                  // Lothlorien
    denmark        = { capital = "Mithlond",          names = ["Grey Havens", "Wayfarers of Lindon", "Mariners of Lindon", "High Havens of Lindon", "Kingdom of Lindon"] },                          // Lindon
    england        = { capital = "Barad-dûr",         names = ["Orcs of Mordor", "Ashes of Mordor", "The Black Land", "The Black Realm of Mordor", "Dominion of the Dark Lord"] },                   // Mordor
    poland         = { capital = "Dol Guldur",        names = ["Servants of Darkness", "Fleeing Orcs", "Domain of Spiders", "Shadow of Mirkwood", "Realm of the Necromancer"] },                     // Dol Guldur
    hre            = { capital = "Goblin-town",       names = ["Feral Goblins", "Scattered Tribes of Moria", "Hordes of the Misty Mountains", "Chiefdoms of Moria", "Empire of Shadow and Flame"] }, // Goblins of the Misty Mountains
    gundabad       = { capital = "Mount Gundabad",    names = ["War-host of Gundabad", "Remnants of Gundabad", "Pale Orcs of Gundabad", "Stronghold of Gundabad", "Snow Kingdom of Gundabad"] },      // Gundabad
    france         = { capital = "Isengard",          names = ["Tower of Orthanc", "Sharkey's Band", "Host of Isengard", "Dominion of the White Hand", "Dominion of Saruman the Wise"] },            // Isengard
    saxons         = { capital = "Imladris",          names = ["Last Homely House", "Hidden Valley of Imladris", "Household of Elrond", "Lordship of Imladris", "Realm of Imladris"] },               // Imladris
    egypt          = { capital = "Ost-in-Edhil",      names = ["Oathsworn of Maernil", "Remnants of Eregion", "Principality of Eregion", "Kingdom of Eregion", "High Kingdom of the Fëanorians"] },   // Eregion
}

::EUR.checkEvolvingFaction <- function(faction) {
    if (!(faction.name in ::EUR.FACTION_EVO)) { return }

    local names = ::EUR.FACTION_EVO[faction.name].names
    if (faction.settlementCount >= 15) {
        faction.displayName = names[4]
    } else if (faction.settlementCount >= 10) {
        faction.displayName = names[3]
    } else if (faction.settlementCount >= 5) {
        faction.displayName = names[2]
    } else if (faction.settlementCount >= 1) {
        faction.displayName = names[0]
    }
}

::EUR.checkEvoCounters <- function() {
    if (::EUR.checkCounter("arnor_restored") && ::EUR.checkCounter("reunited_kingdom")) {
        ::EUR.FACTION_EVO.turks.names = ["Reunited Kingdoms", "Realms in Exile", "Reunited Kingdoms", "Reunited Kingdoms", "Reunited Kingdoms"]
    } else if (::EUR.checkCounter("arnor_restored")) {
        ::EUR.FACTION_EVO.turks.names = ["Kingdom of Arnor", "Shattered Dúnedain of the North", "Kingdom of Arnor", "Kingdom of Arnor", "High Kingdom of Arnor"]
    }

    if (::EUR.checkCounter("kon_council_choice_accepted")) {
        ::EUR.FACTION_EVO.denmark.names = ["Kingdom of the Ñoldor", "Exiles of the Ñoldor", "Kingdom of the Ñoldor", "Kingdom of the Ñoldor", "High Kingdom of the Ñoldor"]
        ::EUR.FACTION_EVO.saxons.names  = ["Kingdom of the Ñoldor", "Exiles of the Ñoldor", "Kingdom of the Ñoldor", "Kingdom of the Ñoldor", "High Kingdom of the Ñoldor"]
    }

    if (::EUR.checkCounter("elven_union")) {
        ::EUR.FACTION_EVO.mongols.names = ["Union of the Silvan Elves", "Sundered Woods of the Eldar", "Union of the Silvan Elves", "Union of the Silvan Elves", "Union of the Silvan Elves"]
        ::EUR.FACTION_EVO.ireland.names = ["Union of the Silvan Elves", "Sundered Woods of the Eldar", "Union of the Silvan Elves", "Union of the Silvan Elves", "Union of the Silvan Elves"]
    }

    if (::EUR.checkCounter("durin_king_end")) {
        ::EUR.FACTION_EVO.moors.names   = ["Kingdom of Durin the Reclaimer", "Sundered Houses of Durin", "Kingdom of Durin the Reclaimer", "Kingdom of Durin the Reclaimer", "Kingdom of Durin the Reclaimer"]
        ::EUR.FACTION_EVO.hungary.names = ["Kingdom of Durin the Reclaimer", "Sundered Houses of Durin", "Kingdom of Durin the Reclaimer", "Kingdom of Durin the Reclaimer", "Kingdom of Durin the Reclaimer"]
    }

    if (::EUR.checkCounter("sauron_ai")) {
        ::EUR.FACTION_EVO.england.names = ["Dominion of the One Ring", "Remnants of the Shadow", "Dominion of the One Ring", "Dominion of the One Ring", "Dominion of the One Ring"]
        ::EUR.FACTION_EVO.poland.names  = ["Dominion of the One Ring", "Remnants of the Shadow", "Dominion of the One Ring", "Dominion of the One Ring", "Dominion of the One Ring"]
    }

    if (::EUR.checkCounter("keep_ring_maernil")) {
        ::EUR.FACTION_EVO.egypt.names = ["High Kingdom of the Ringlords", "Remnants of Eregion", "High Kingdom of the Ringlords", "High Kingdom of the Ringlords", "High Kingdom of the Ringlords"]
    }

    if (::EUR.checkCounter("keep_ring_mazog")) {
        ::EUR.FACTION_EVO.gundabad.names = ["Legacy of the First Darkness", "Remnants of Gundabad", "Legacy of the First Darkness", "Legacy of the First Darkness", "Legacy of the First Darkness"]  // was "gondabad" in source (undefined key)
    }

    if (::EUR.checkCounter("keep_ring_galadriel")) {
        ::EUR.FACTION_EVO.ireland.names = ["Queendom of Yavanna's Chosen", "Wandering Galadhrim", "Queendom of Yavanna's Chosen", "Queendom of Yavanna's Chosen", "Queendom of Yavanna's Chosen"]  // was "lorien" in source (undefined key); Lothlórien = ireland
    }

    if (::EUR.checkCounter("keep_ring_isengard")) {
        ::EUR.FACTION_EVO.france.names = ["Empire of Many Colors", "Sharkey's Band", "Empire of Many Colors", "Empire of Many Colors", "Empire of Many Colors"]
    }

    if (::EUR.checkCounter("keep_ring_agandaur")) {
        ::EUR.FACTION_EVO.portugal.names = ["Faithful of Agandaûr the Great", "Remnants of Angmar", "Faithful of Agandaûr the Great", "Faithful of Agandaûr the Great", "Faithful of Agandaûr the Great"]
    }

    if (::EUR.checkCounter("keep_ring_rhukar")) {
        ::EUR.FACTION_EVO.venice.names = ["Dragon Empire of Rhûn", "Exiled Easterlings", "Dragon Empire of Rhûn", "Dragon Empire of Rhûn", "Dragon Empire of Rhûn"]
    }
}
