temp_target = 0
temp_edu = ""
local curr_item = "T1"

player_units_target = 1
units_target = 1
units_target_new = 1
units_target_change = 1
up_temp_unit_choice = 1

show_add_unit_up = false

local expreq = 2
local new_unit_cost = 1


player_units_cut = {
    ["egypt"] = {
        "Heavy Falathrim Wavebreakers",
        "Heavy Falathrim Spears",
    },
    ["poland"] = {
        "Sauron",
        "Troll Drummers",
        "Mirkwood Trolls",
        "Forest Trolls",
        "Olog-hai",
        "Giant Spiders",
        "Mirkwood Catapult",
        "Mirkwood Ballista",
        "Mordor Catapult",
        "Orc Garrison Elite",
        "Guldur Heavy Swords Garrison",
        "Khamuls Shadow Rangers Garrison",
        "Khamul's Chosen Garrison",
        "Bolgs Champions Garrison"
    },
    ["teutonic_order"] = {
        "Fylani War Wagons",
        "Westron Ballista",
        "Westron Catapult",
        "Wildmen Garrison Elite",
        "Tir Croicoill Cosantoiri Garrison",
        "Enedwaith Marksmen Garrison",
        "Liadan Billmen Garrison",
        "Warband Blades Garrison",
        "Human Boat"
    },
    ["norway"] = {
        "Beorning Axemen",
        "Beekeepers",
        "Eotheod Horsemen",
        "Dwarven Ballista",
        "Dwarven Catapult",
        "Axeguard of Erebor Garrison",
        "Kings Warriors Garrison",
        "Legion Deeping Guard Garrison",
        "Legion Crossbows Garrison",
        "Khazad-dum Guardians Garrison",
        "Khazad-dum Reclaimers Garrison"
    },
    ["ireland"] = {
        "Ents",
        "Elven Ballista",
        "Elven Catapult",
        "Ent Catapult",
        "Elvenking's Swordguard Garrison",
        "Hin e-Daur Garrison",
        "Elvenking's Palace Guard Garrison",
        "Galadhrim Archers Garrison",
        "Galadhrim Swordsmen Garrison",
        "Galadhrim Guards Garrison",
        "Human Boat"
    },
    ["france"] = {
        "Troll Drummers",
        --"Warg Marauders",
        "Bolgs Champions",
        "Lego Uruk-hai Infantry",
        "Lego Berserkers",
        "Trolls of the White Hand",
        "Trolls",
        "Olog-hai",
        "Isengard Ballista",
        "Snaga Catapult",
        "Orc Garrison Elite",
        "Uruk-hai Crossbow Garrison",
        "Uruk-hai Infantry Garrison",
        "Uruk-hai Spearguard Garrison",
        "Bolgs Champions Garrison"
    },
    ["normans"] = {
        "Goblin King",
        "Wolf Pack",
        "Dourhand Crossbows",
        "Beleriand Wolves",
        "Cave Troll Drummers",
        "White Wolves",
        "Moria Balrog",
        "Warg Pack",
        "Trolls",
        "Armored Balrog",
        "Crag Trolls",
        "Armoured Crag Trolls",
        "Blue Crag Troll Hurlers",
        "Cave Trolls",
        "Blue Crag Catapult",
        "Dourhand Catapult",
        "Dourhand Barrel Thrower",
        "Crag Siege Trolls",
        "Blue Crag Ballista Tower",
        "Snaga Ballista",
        "Snaga Catapult",
        "Blue Crag Ballista",
        "Blue Crag Orc Javs Garrison",
        "Crag Trolls Garrison",
        "Blue Crag Berserkers Garrison",
        "Blue Crag Goblin Axes Garrison",
        "Blue Crag Goblin Slingers Garrison"
    },
    ["denmark"] = {
        "Dunedain Bodyguard Twins",
        "Lindon Chariot",
        "Noldor Chariot",
        "Elven Ballista",
        "Elven Catapult",
        "Noldorin Veterans Garrison",
        "Elderinwe Tirno Garrison",
        "Heavy Falathrim Archers Garrison",
        "Heavy Falathrim Wavebreakers Garrison",
        "Mithlond Nobles Garrison",
        "Elven Ship",
        "Elven Boat"
    },
    ["portugal"] = {
        "Black Trolls of Angmar",
        "Snow Trolls",
        "Angmar Ballista",
        "Angmar Catapult",
        "Orc Garrison Elite",
        "Blackshield Archers Garrison",
        "Iron Crown Warriors Garrison",
        "Iron Crown Longbowmen Garrison",
        "Northguard Garrison",
        "Blackshield Warriors Garrison",
        "Human Boat"
    },
    ["turks"] = {
        "Riders of the Green Hills2",
        "Anfalas Bodyguard2",
        "Lossarnach Household Guard2",
        "The White Company2",
        "Ringlo House Guards2",
        "Dunedain Bodyguard Twins",
        "Azrazair Raiders",
        "Peasant Militia",
        "Eorling Archers",
        "Rohirrim",
        "Lego Rohirrim",
        "Rohirrim Archers",
        "Riddermark Axemen",
        "Eored Lancers",
        "Eored Skirmishers",
        "Riders of the Fold",
        "Golden Hall Spearmen",
        "Royal Guard",
        "Northmen Militia",
        "Dalian Billmen",
        "Dalian Longbowmen",
        "Lake-town Pikemen",
        "Barding Marksmen",
        "Barding Hird",
        "Aihwothiuda Horseguards",
        "Thorn Bladesmen",
        "Thorn Guard",
        "Thorn Crossbowmen",
        "Regent Axeguard",
        "Regent Spearguard",
        "Regent Bowguard",
        "Beorning Axemen",
        "Vale Archers",
        "Beekeepers",
        "Woodman Warriors",
        "Woodman Hunters",
        "Woodman Wardens",
        "Eotheod Archers",
        "Greenwood Foresters",
        "Rhudaur Savages",
        "Hillmen",
        "Rhudaur Huscarles",
        "Ettenmoors Troll-Hunters",
        "Rhudaur Spearmen",
        "Rhudaur Warriors",
        "Angmarim Warriors",
        "Angmarim Pikes",
        "Dreadguard",
        "Clan Axemen",
        "Clan Spearmen",
        "Clan Hunters",
        "Frekkalingir Hill-Riders",
        "Dunhird Berserkers",
        "Dunlending Longspears",
        "Dunhird Warriors",
        "Warband Sentries",
        "Wulfguard Axemen",
        "Wulfguard Pikes",
        "Orthanc Warden",
        "Orthanc Guard",
        "Mordag Fishermen",
        "Mochaini Touta",
        "Keefei Huntsmen",
        "Liadan Billmen",
        "Mordag Skirmishers",
        "Fylani Herders",
        "Enedwaith Guardsmen",
        "Enedwaith Marksmen",
        "Haradrim Spearmen",
        "Haradrim Archers",
        "Southron Warband",
        "Southron Pikemen",
        "Southron Archers",
        "Muhad Tribesmen",
        "Muhad Beastmasters",
        "Troll-men Warriors",
        "Troll-men Hunters",
        "Steppe Tribesmen",
        "Steppe Archers",
        "Nomad Axemen",
        "Khandish Raiders",
        "Nomad Horsemen",
        "Daritai Clansmen",
        "Rhunnic Spears",
        "Rhunnic Warriors",
        "Claw-Guard",
        "Loke-Rim Swordsmen",
        "Loke-Rim Spearmen",
        "Kar's Chosen",
        --"Merchant Cavalry",
        "Amanyar Swordmasters",
        "Oathbreakers",
        --"Greenway Spearmen",
        --"Journeymen",
        --"Woodland Hunters",
        "Saralainn Mercenaries",
        "Harondor Mercenaries",
        "Farrhun Mercenaries",
        "Eriador Ballista",
        "Eriador Catapult",
        "Eriador Trebuchet",
        "Hobbit Ranchers Garrison",
        "Bandobras Archers Garrison",
        "Hobbit Infantry Garrison",
        "Watch Shirriffs Garrison",
        "Watchmen Swordguard Garrison",
        "Watchmen Axeguard Garrison",
        "Watchmen Bowguard Garrison",
        "Greenway Spearmen Garrison",
        "Journeymen Garrison",
        "Dunedain Garrison",
        "Enedwaith Marksmen Garrison",
        "Liadan Billmen Garrison",
        "Warband Sentries Garrison",
        "Wulfguard Axemen Garrison",
        "Regent Axeguard Garrison",
        "Regent Bowguard Garrison",
        "Lake-town Pikemen Garrison",
        "Golden Hall Spearmen Garrison",
        "Dunedain Axemen Garrison",
        "Dunedain Rangers Garrison",
        "Southron Pikemen Garrison",
        "Southron Archers Garrison",
        "Fountain Guard Garrison",
        "Lossarnach Axemen Garrison",
        "Guards of Osgiliath Garrison",
        "Osgiliath Veterans Garrison",
        "Raven Helms of Cair Andros Garrison",
        "Gondor Garrison Infantry",
        "Gondor Garrison Archers",
        "Gondor Boat",
        "Gondor Ship"
    },
    ["england"] = {
        "Sauron",
        "Mordor Trolls",
        "Mirkwood Trolls",
        "Forest Trolls",
        "Olog-hai",
        "Great Beasts",
        "Giant Spiders",
        "Farrhun Mercenaries",
        "Orc Catapult",
        "Orc Ballista",
        "Mordor Catapult",
        "Orc Garrison Elite",
        "Loke-Rim Pikemen Garrison",
        "Variag Swordsmen Garrison",
        "Bolgs Champions Garrison",
        "Temple Marksmen Garrison",
        "Temple Wards Garrison",
        "Barad-dur Wardens Garrison",
        "Morgul Durburz Garrison",
        "Morannon Gathrak Garrison",
        "Black Uruks Garrison",
        "Black Uruk Halberd Garrison"
    },
    ["hre"] = {
        "Goblin King",
        "Cave Troll Drummers",
        "Moria Balrog",
        "Warg Pack",
        "Trolls",
        "Armored Balrog",
        "Crag Trolls",
        "Armoured Crag Trolls",
        "Blue Crag Troll Hurlers",
        "Cave Trolls",
        "Dourhand Catapult",
        "Dourhand Barrel Thrower",
        "Crag Siege Trolls",
        "Blue Crag Ballista Tower",
        "Snaga Ballista",
        "Snaga Catapult",
        "Mordor Catapult",
        "Misty Mangonel",
        "Blue Crag Ballista",
        "Blue Crag Orc Javs Garrison",
        "Crag Trolls Garrison",
        "Orc Garrison Elite",
        "Blue Crag Berserkers Garrison",
        "Blue Crag Goblin Axes Garrison",
        "Blue Crag Goblin Slingers Garrison",
        "Black Pit Infantry Garrison",
        "Black Pit Crossbows Garrison",
        "Mountain Uruks Garrison",
        "Bolgs Champions Garrison"
    },
    ["gundabad"] = {
        "Cave Troll Drummers",
        "White Wolves",
        "Lego Berserkers",
        "Troll Avengers",
        "Black Trolls of Angmar",
        "Snow Trolls",
        "Great Beasts",
        "Crag Trolls",
        "Armoured Crag Trolls",
        "Blue Crag Troll Hurlers",
        "Dourhand Catapult",
        "Dourhand Barrel Thrower",
        "Crag Siege Trolls",
        "Blue Crag Ballista Tower",
        "Snaga Ballista",
        "Snaga Catapult",
        "Blue Crag Ballista",
        "Blue Crag Orc Javs Garrison",
        "Crag Trolls Garrison",
        "Orc Garrison Elite",
        "Blackshield Archers Garrison",
        "Blue Crag Berserkers Garrison",
        "Blue Crag Goblin Axes Garrison",
        "Blue Crag Goblin Slingers Garrison",
        "Guldur Heavy Swords Garrison",
        "Black Pit Crossbows Garrison",
        "Mountain Uruks Garrison",
        "Bolgs Champions Garrison",
        "Orc Avengers Garrison",
        "Blackshield Warriors Garrison",
        "Morgul Durburz Garrison",
        "Morannon Gathrak Garrison",
        "Black Uruks Garrison",
        "Black Uruk Halberd Garrison"
    },
    ["timurids"] = {
        "Ents",
        "Beorning Bears",
        "Westron Ballista",
        "Westron Catapult",
        "Ent Catapult",
        "Wildmen Garrison Elite",
        "Bear Warriors Garrison",
        "Framsguard Dismounted Axemen Garrison",
        "Framsguard Dismounted Spearmen Garrison",
        "Human Boat"
    },
    ["byzantium"] = {
        "Privateer Cavalry",
        "Westron Ballista",
        "Westron Catapult",
        "Northmen Garrison Elite",
        "Moriquendi Protectors Garrison",
        "Moriquendi Glademasters Garrison",
        "Moriquendi Sentinels Garrison",
        "Regent Axeguard Garrison",
        "Regent Bowguard Garrison",
        "Vintner-Court Knights Garrison",
        "Human Boat"
    },
    ["spain"] = {
        "War Beasts of Harad",
        "Mumakil",
        "Harondor Mercenaries",
        "Farrhun Mercenaries",
        "Westron Ballista",
        "Westron Catapult",
        "Variag Swordsmen Garrison",
        "Southron Pikemen Garrison",
        "Serpent Bladesmen Garrison",
        "Southron Archers Garrison",
        "Human Boat",
        "Adunaim Boat"
    },
    ["khand"] = {
        "Khand Heavy Crossbow Chariots",
        "Great Beasts",
        "Harondor Mercenaries",
        "Farrhun Mercenaries",
        "Westron Ballista",
        "Westron Catapult",
        "Dwarven Catapult",
        "Legionaries of Erebor Garrison",
        "Khand Elite Axemen Garrison",
        "Variag Bowmen Garrison",
        "Variag Swordsmen Garrison",
        "Temple Marksmen Garrison",
        "Temple Wards Garrison",
        "Human Boat"
    },
    ["scotland"] = {
        "Westron Ballista",
        "Westron Catapult",
        "Northmen Garrison Elite",
        "Dalian Swordsmen Garrison",
        "Lake-town Pikemen Garrison",
        "Dalian Paladins Garrison",
        "Hearthguard Garrison",
        "Human Boat"
    },
    ["milan"] = {
        "Lego Rohirrim",
        "Lego Spearmen",
        "Dwarven Travellers",
        "Westron Ballista",
        "Westron Catapult",
        "Northmen Garrison Elite",
        "Helm's Hammers Garrison",
        "Eored Footmen Garrison",
        "Eored Swordsmen Garrison",
        "Golden Hall Spearmen Garrison"
    },
    ["sicily"] = {
        "Riders of the Green Hills2",
        "Anfalas Bodyguard2",
        "Lossarnach Household Guard2",
        "The White Company2",
        "Ringlo House Guards2",
        "Hobbit Infantry",
        "Bandobras Archers",
        "Watch Shirriffs",
        "Hobbit Ranchers",
        "Breeland Militia",
        "Ruffians",
        "Lumbermen",
        "Archer Militia",
        "Greenway Riders",
        "Merchant Militia",
        "Dunedain Volunteers",
        "Dunedain Wardens",
        "Tharbad Thieves",
        "Sworn Spearmen",
        "Sworn Defenders",
        "Watchmen Swordguard",
        "Watchmen Axeguard",
        "Cardolan Men-at-Arms",
        "Tharbad Tollkeepers",
        "Dunedain Rangers",
        "Watchmen Bowguard",
        "Sworn Archers",
        "Cardolan Sentinels",
        "Dunedain Scouts",
        "Sworn Horsemen",
        "Cardolan Riders",
        "Merchant Infantry",
        "Dunedain Armsmen",
        "Dunedain Blademasters",
        "Gate Keepers",
        "Dunedain Axemen",
        "Dismounted Fornost-Erain Knights",
        "Arthedain Pikemen",
        "Eriador Protectors",
        "Dunedain Troll Slayers",
        "Cardolan Sharpshooters",
        "Eriador Marksmen",
        "Fornost-Erain Knights",
        "Tharbad Riders",
        "tharbad_warhammer",
        "Arthedain Knights",
        "Sons of Numenor",
        "Annuminas Gateguards",
        "Dunedain Steelbowmen",
        "Arthedain Royal Guard",
        "Harondor Mercenaries",
        "Farrhun Mercenaries",
        "Gondor Ballista",
        "Gondor Catapult",
        "Gondor Trebuchet",
        "Eriador Trebuchet",
        "Gondor Garrison Elite",
        "Fountain Guard Garrison",
        "Lossarnach Axemen Garrison",
        "Guards of Osgiliath Garrison",
        "Osgiliath Veterans Garrison",
        "Raven Helms of Cair Andros Garrison",
        "Gondor Garrison Infantry",
        "Gondor Garrison Archers",
        "Gondor Boat",
        "Gondor Ship"
    },
    ["saxons"] = {
        "Dunedain Bodyguard Twins",
        "Dunedain Wardens",
        "Dunedain Scouts",
        "Dunedain Troll Slayers",
        "Lindar Guards",
        "Lindar Mariners",
        "Lindon Longspears",
        "Lindar Bowmen",
        "Sindar Spearmen",
        "Sindar Axemen",
        "Sindar Archers",
        "Sindar Riders",
        "Heavy Falathrim Axeguard",
        "Heavy Falathrim Shipwrights",
        "Heavy Falathrim Archers",
        "Heavy Falathrim Skirmishers",
        "Mithlond Nobles",
        "Lindon Chariot",
        "Noldor Chariot",
        "Elven Ballista",
        "Elven Catapult",
        "Ent Catapult",
        "Sword Quendi Garrison",
        "Noldorin Veterans Garrison",
        "Elderinwe Tirno Garrison",
        "Heavy Falathrim Archers Garrison",
        "Mithlond Nobles Garrison",
        "Elven Ship",
        "Elven Boat"
    },
    ["hungary"] = {
        "Merchant Cavalry",
        "War-goat Chariot",
        "Lindar Mariners",
        "Dwarven Ballista",
        "Ered Luin Ballista",
        "Ered Luin Catapult",
        "Dwarven Catapult",
        "Longbeard Swordsmen Garrison",
        "Longbeard Crossbows Garrison",
        "Gabilgathol Guard Garrison",
        "Khazad-dum Guardians Garrison",
        "Khazad-dum Reclaimers Garrison",
        "Human Boat",
        "Elven Boat"
    },
    ["moors"] = {
        "Dale Cavalry",
        "War-goat Chariot",
        "Dwarven Ballista",
        "Dwarven Catapult",
        "Axeguard of Erebor Garrison",
        "Kings Warriors Garrison",
        "Iron Crossbowmen Garrison",
        "Legionaries of Erebor Garrison",
        "Khazad-dum Guardians Garrison"
    },
    ["mongols"] = {
        "Ents",
        "Elven Ballista",
        "Elven Catapult",
        "Ent Catapult",
        "Elvenking's Swordguard Garrison",
        "Elvenkings Bowguard Garrison",
        "Hin e-Daur Garrison",
        "Elvenking's Palace Guard Garrison",
        "Galadhrim Archers Garrison",
        "Galadhrim Swordsmen Garrison",
        "Galadhrim Guards Garrison",
        "Human Boat"
    },
    ["russia"] = {
        "Territorial Swordsmen",
        "Territorial Guardsmen",
        "Lebennin Marines",
        "Territorial Watchmen",
        "Territorial Cavalry",
        "Gondor Pikemen",
        "Gondor Infantry",
        "Gondor Spearmen",
        "Gondor Archers",
        "Lamedon Champions",
        "Lossarnach Household Guard",
        "Lossarnach Household Guard2",
        "Talon Knights",
        "Osgiliath Veterans",
        "Knights of the Silver Swan",
        "Breeland Militia",
        "Lumbermen",
        "Archer Militia",
        "Merchant Militia",
        "Dunedain Wardens",
        "Sworn Spearmen",
        "Sworn Defenders",
        "Watchmen Swordguard",
        "Watchmen Bowguard",
        "Dunedain Scouts",
        "Sworn Horsemen",
        "Gate Keepers",
        "Dunedain Axemen",

        "Peasant Militia",
        "Eorling Spearmen",
        "Eorling Archers",
        "Rohirrim",
        "Lego Rohirrim",
        "Lego Spearmen",
        "Rohirrim Archers",
        "Eored Swordsmen",
        "Eored Lancers",
        "Eored Skirmishers",
        "Rivermen",
        "Dalian Swordsmen",
        "Dalian Billmen",
        "Dalian Longbowmen",
        "Dale Cavalry",
        "Lake-town Pikemen",
        "Barding Marksmen",
        "Aihwothiuda Horseguards",
        "Thorn Bladesmen",
        "Thorn Guard",
        "Thorn Crossbowmen",
        "Thorn Patrolers",
        "Regent Spearguard",
        "Regent Bowguard",
        "Vintner-Court Knights",
        "Beorning Axemen",
        "Woodman Warriors",
        "Woodman Defenders",
        "Woodman Hunters",
        "Beorning Defenders",
        "Woodman Wardens",
        "Eotheod Horsemen",
        "Eotheod Archers",
        "Framsguard Dismounted Spearmen",
        "Angmarim Levies",
        "Rhudaur Savages",
        "Hillmen",
        "Rhudaur Huscarles",
        "Rhudaur Bodyguards",
        "Rhudaur Spearmen",
        "Angmarim Warriors",
        "Angmarim Pikes",
        "Morholt Chosen",
        "Dreadguard",
        "Darkblades",
        "Clan Axemen",
        "Clan Spearmen",
        "Frekkalingir Hill-Riders",
        "Dunhird Berserkers",
        "Frekkalingir Harriers",
        "Warband Blades",
        "Dunhird Slayers",
        "Warband Sentries",
        "Wulfguard Axemen",
        "Faolan Borderguard",
        "Mordag Fishermen",
        "Keefei Huntsmen",
        "Liadan Billmen",
        "Faolan Warriors",
        "Fylani Herders",
        "Mochaini Ambaxtoi",
        "Enedwaith Guardsmen",
        "Haradrim Archers",
        "Southron Warband",
        "Southron Pikemen",
        "Southron Lancers",
        "Muhad Tribesmen",
        "Hasharii Blades",
        "Serpent Bladesmen",
        "Hasharii Shadows",
        "Steppe Tribesmen",
        "Nomad Axemen",
        "Marauders",
        "Khandish Raiders",
        "Nomad Horsemen",
        "Variag Bowmen",
        "Variag Horse Archers",
        "Rhunnic Spears",
        "Rhunnic Warriors",
        "Fang-Guard",
        "Rhunnic Bowmen",
        "Claw-Guard",
        "Fire-Guard",
        "Loke-Rim Poleaxemen",
        "Loke-Rim Pikemen",
        "Loke-Rim Swordsmen",
        "Loke-Rim Spearmen",
        "Loke-Rim Archers",
        "Loke-Rim Cavalry",
        "Loke-Scion Rim",
        "Loke-Nar Rim",
        "Suriut Chariots",
        "Dragon-Wrath Shields",
        "Dragon-Wrath Swiftblades",
        "Dragons Wrath Guardians",
        "Dragon-Wrath Kataphracts",
        "Merchant Cavalry",
        "Greenway Spearmen",
        "Journeymen",
        "Saralainn Mercenaries",
        "Harondor Mercenaries",
        "Farrhun Mercenaries",
        "Westron Ballista",
        "Westron Catapult",
        "Gondor Trebuchet",
        "Watchmen Swordguard Garrison",
        "Watchmen Bowguard Garrison",
        "Greenway Spearmen Garrison",
        "Journeymen Garrison",
        "Royal Legion of Armenelos Garrison",
        "Liadan Billmen Garrison",
        "Warband Blades Garrison",
        "Warband Sentries Garrison",
        "Wulfguard Axemen Garrison",
        "Iron Crown Warriors Garrison",
        "Loke-Rim Pikemen Garrison",
        "Dragon-Wrath Shields Garrison",
        "Loke-Rim Archers Garrison",
        "Regent Bowguard Garrison",
        "Vintner-Court Knights Garrison",
        "Dalian Swordsmen Garrison",
        "Lake-town Pikemen Garrison",
        "Eored Swordsmen Garrison",
        "Dunedain Axemen Garrison",
        "Variag Bowmen Garrison",
        "Numenorean Marksmen Garrison",
        "Numenorean Cohort Garrison",
        "Southron Pikemen Garrison",
        "Serpent Bladesmen Garrison",
        "Fountain Guard Garrison",
        "Raven Helms of Cair Andros Garrison",
        "Gondor Garrison Infantry",
        "Gondor Garrison Archers",
        "Adunaim Boat",
        "Adunaim Ship"
    },
    ["venice"] = {
        "Suriut Chariots",
        "Khamuls Shadowguard",
        "Khamuls Shadow Rangers",
        "Khamul's Chosen",
        "Khamuls Shadowknights",
        "Farrhun Mercenaries",
        "Rhunnic Catapult",
        "Rhunnic Ballista",
        "Dragons Breath",
        "Loke-Rim Pikemen Garrison",
        "Loke-Rim Macemen Garrison",
        "Dragon-Wrath Shields Garrison",
        "Loke-Rim Archers Garrison",
        "Khamuls Shadow Rangers Garrison",
        "Khamul's Chosen Garrison",
        "Variag Swordsmen Garrison",
        "Human Boat"
    },
    ["aztecs"] = {
        "Rohirrim",
        "Lego Rohirrim",
        "Rohirrim Archers",
        "Lurtz's Hunting Pack",
        "Uruk-hai Raiders",
        "Uruk-hai Archers",
        "Berserkers",
        "Lego Uruk-hai Infantry",
        "Lego Berserkers",
        "Uruk-hai Infantry",
        "Uruk-hai Crossbow",
        "Saralainn Mercenaries",
        "Westron Ballista",
        "Westron Catapult",
        "Wildmen Garrison Elite",
        "Warband Blades Garrison",
        "Warband Sentries Garrison",
        "Wulfguard Axemen Garrison",
        "Human Boat"
    },
}

function optionsUpgrades()
    --ImGui.NewLine()
    ImGui.BeginGroup()
    ImGui.Image(gu_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
    ImGui.EndGroup()
    local hovered = ImGui.IsItemHovered()
    if hovered then
        eurStyle("tooltip", true)
        ImGui.BeginTooltip()
        ImGui.Text("General upgrades swaps all generic bodyguard units for a random lower tier unit, the general can then upgrade their bodyguard to a variety of units based on their level. Custom bodyguard are not affected.")
        ImGui.NewLine()
        ImGui.BulletText("Player and AI.")
        ImGui.BulletText("Multiple tiers of units available to unlock.")
        ImGui.BulletText("General's level based on command and loyalty, along with number of battles won and number of kills for the bodyguard unit.")

        ImGui.EndTooltip()
        eurStyle("tooltip", false)
    end
        ImGui.PushItemWidth(500)
            options_gen_upgrades, genuppressed = ImGui.Checkbox("Enabled##gen01", options_gen_upgrades)
            hoveredSimple("Enable general upgrades.")
            game_options.BG_T2, genupt2pressed = ImGui.Checkbox("Start with T2##gen01", game_options.BG_T2)
            hoveredSimple("Enables the first level of bodyguard units to be T2 rather than T1 level.")
            if genupt2pressed then
                gen_units_list = {}
                if game_options.BG_T2 then
                    for k, v in pairs(gen_units_list_default2) do
                        gen_units_list[k] = v
                    end
                else
                    for k, v in pairs(gen_units_list_default) do
                        gen_units_list[k] = v
                    end
                end
            end
            if not options_first_run then
                ImGui.Text("Disabling general upgrades during the campaign requires a restart.")
                --[[if genuppressed then
                    if game_options.bg_swapped then
                        swapBGForReal()
                    else
                        swapBGForGeneric()
                    end
                end]]
            end
            --[[if genuppressed then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if options_gen_upgrades then
                    show_genenabled = true
                end
            end]]
            --ImGui.TextColored(0,1,0,1,"Cannot be reverted during campaign.")
            --options_gennotif, pressed = ImGui.Checkbox("Notifications", options_gennotif)
            show_gen_unit_card, show_gen_unit_cardpressed = ImGui.Checkbox("Show Unit Card", show_gen_unit_card)
            hoveredSimple("Display the bodyguard unit card rather than a generic icon in the UI.")
            bg_t2_rank = ImGui.SliderInt("Advanced Rank##1", bg_t2_rank, 0, 20)
            hoveredSimple("Set the rank for T2 units to be unlocked.")
            bg_t3_rank = ImGui.SliderInt("Elite Rank##1", bg_t3_rank, 0, 20)
            hoveredSimple("Set the rank for T3 units to be unlocked.")
            ImGui.BeginGroup()
            ImGui.Text("Cooldown:")
            if (ImGui.Button("-##062", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if bg_swap_cooldown > 4 then
                    bg_swap_cooldown=bg_swap_cooldown-5
                end
            end
            ImGui.SameLine()
            ImGui.Text(tostring(bg_swap_cooldown).." Turns")
            ImGui.SameLine()
            if (ImGui.Button("+##062", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if bg_swap_cooldown < 30 then
                    bg_swap_cooldown=bg_swap_cooldown+5
                end
            end
            ImGui.EndGroup()
            hoveredSimple("Cooldown between bodyguard changes.")
            --personal_guard_limit = ImGui.InputInt("Personal guard limit", personal_guard_limit)
            options_gen_bg_size, bg_size_pressed = ImGui.Checkbox("Dynamic Bodyguard Size##2", options_gen_bg_size)
            hoveredSimple("Enable variable bodyguard size, bodyguard unit size caculated based on general's command stars.")
            if not options_gen_bg_size then 
                if bg_size_pressed then
                    for i = 1, #mod_general_units_list do
                        local eduEntry = M2TWEOPDU.getEduEntryByType(mod_general_units_list[i].name)
                        if eduEntry ~= nil then
                            if eduEntry.soldierCount == mod_general_units_list[i].size then
                                if original_general_units_list[eduEntry.eduType] then
                                    eduEntry.soldierCount = original_general_units_list[eduEntry.eduType]
                                    print("reverting")
                                end
                            end
                        end
                    end
                end
            else
                if bg_size_pressed then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    for i = 1, #mod_general_units_list do
                        local eduEntry = M2TWEOPDU.getEduEntryByType(mod_general_units_list[i].name)
                        if eduEntry ~= nil then
                            if not original_general_units_list[eduEntry.eduType] then
                                original_general_units_list[eduEntry.eduType] = eduEntry.soldierCount
                            end
                            eduEntry.soldierCount = mod_general_units_list[i].size
                            print("increasing")
                        end
                    end
                end
            end
            ImGui.Text("Minimum bodyguard size:")
            bg_min_size_multi = ImGui.SliderInt("##1", bg_min_size_multi, 25, 75, "%d%%")
            generalADV()
    
            --ImGui.NewLine()
            ImGui.Separator()
            ImGui.NewLine()
            ImGui.BeginGroup()
            ImGui.Image(u_text.img,400*eurbackgroundWindowSizeRight,50*eurbackgroundWindowSizeBottom)
            ImGui.EndGroup()
            local hovered = ImGui.IsItemHovered()
            if hovered then
                eurStyle("tooltip", true)
                ImGui.BeginTooltip()
                ImGui.Text("Unit Upgrades allow for certain units to be upgraded to the next tier once a minimun experience requirement is met, most but not all units have upgrade paths.")
                ImGui.BulletText("Player and AI.")
                ImGui.EndTooltip()
                eurStyle("tooltip", false)
            end
            options_unit_upgrades, options_unit_upgradespressed = ImGui.Checkbox("Enabled##unit01", options_unit_upgrades)
            hoveredSimple("Enable unit upgrades.")
            game_options.display_upg, upg_unit_upgradespressed = ImGui.Checkbox("Display upgrade mini icon##unit01", game_options.display_upg)
            hoveredSimple("Show an icon on the unit card when upgrades are available.")
            game_options.display_sdg, sdg_unit_upgradespressed = ImGui.Checkbox("Display sidegrade mini icon##unit01", game_options.display_sdg)
            hoveredSimple("Show an icon on the unit card when upgrades of the same tier are available.")
            ImGui.Text("Experience requirement reduction:")
            hoveredSimple("Reduce the experience requirement for unit upgrades, player only.")
            if (ImGui.Button("-##032", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if unit_upgrades_multi > 0 then
                    unit_upgrades_multi=unit_upgrades_multi-1
                end
            end
            ImGui.SameLine()
            ImGui.Text(tostring(unit_upgrades_multi))
            ImGui.SameLine()
            if (ImGui.Button("+##023", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                if unit_upgrades_multi < 2 then
                    unit_upgrades_multi=unit_upgrades_multi+1
                end
            end
            restricted_upgrades, restricted_upgradespressed = ImGui.Checkbox("Restrict upgrades", restricted_upgrades)
            hoveredSimple("Only allow upgrades if the upgrade option is available to recruit somewhere within the realm.")
            if restricted_upgradespressed then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                list_edu_recruitable()
            end
            ai_unit_upgrades, ai_unit_upgradespressed = ImGui.Checkbox("AI Upgrades", ai_unit_upgrades)
            hoveredSimple("Enable unit upgrades for the AI.")
            unitADV()
            ImGui.PopItemWidth()
    
end

function generalADV()
    if (ImGui.CollapsingHeader("Advanced Options##gen02")) then
        ImGui.SetNextWindowBgAlpha(0)
            ImGui.BeginChild("swap_bg_child_sub_1_test", 400*eurbackgroundWindowSizeRight, 500*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
            --ImGui.Separator()
            if ImGui.Button("Load defaults") then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                gen_units_list = {}
                if game_options.BG_T2 then
                    for k, v in pairs(gen_units_list_default_fr2) do
                        gen_units_list[k] = v
                    end
                else
                    for k, v in pairs(gen_units_list_default_fr) do
                        gen_units_list[k] = v
                    end
                end
            end
            ImGui.SameLine()
            if ImGui.Button("Save in files") then
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                generalWriteDefault()
            end
            ImGui.Text("T1:")
            for i = 0, #gen_units_list[eur_player_faction.name]["T1"] do
                local eduEntry = M2TWEOPDU.getEduEntryByType(gen_units_list[eur_player_faction.name]["T1"][i])
                if eduEntry ~= nil then
                    local unit_tga = eduEntry.unitCardTga
                    if eur_tga_table[unit_tga] ~= nil then
                        image_tga = eur_tga_table[unit_tga]
                    else
                        image_tga = test1
                    end
                    if ImGui.ImageButton("swapBGButton_button_t1_0"..tostring(i),image_tga.img,img_x, img_y) then
                        temp_target = i
                        curr_item = "T1"
                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    end
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        eurStyle("tooltip", true)
                        ImGui.BeginTooltip()
                        ImGui.Text(eduEntry.localizedName)
                        showEDUStats(eduEntry.eduType)
                        ImGui.EndTooltip()
                        eurStyle("tooltip", false)
                    end
                    if i == 4 then
                        ImGui.SameLine()
                    else
                        ImGui.SameLine()
                    end
                end
            end
            ImGui.NewLine()
            --ImGui.Separator()
            ImGui.Text("T2:")
            for i = 0, #gen_units_list[eur_player_faction.name]["T2"] do
                local eduEntry = M2TWEOPDU.getEduEntryByType(gen_units_list[eur_player_faction.name]["T2"][i])
                if eduEntry ~= nil then
                    local unit_tga = eduEntry.unitCardTga
                    if eur_tga_table[unit_tga] ~= nil then
                        image_tga = eur_tga_table[unit_tga]
                    else
                        image_tga = test1
                    end
                    if ImGui.ImageButton("swapBGButton_button_t2_0"..tostring(i),image_tga.img,img_x, img_y) then
                        temp_target = i
                        curr_item = "T2"
                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    end
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        eurStyle("tooltip", true)
                        ImGui.BeginTooltip()
                        ImGui.Text(eduEntry.localizedName)
                        showEDUStats(eduEntry.eduType)
                        ImGui.EndTooltip()
                        eurStyle("tooltip", false)
                    end
                    if i == 4 then
                        ImGui.SameLine()
                    else
                        ImGui.SameLine()
                    end
                end
            end
            ImGui.NewLine()                --ImGui.Separator()
            ImGui.Text("T3:")
            for i = 0, #gen_units_list[eur_player_faction.name]["T3"] do
                local eduEntry = M2TWEOPDU.getEduEntryByType(gen_units_list[eur_player_faction.name]["T3"][i])
                if eduEntry ~= nil then
                    local unit_tga = eduEntry.unitCardTga
                    if eur_tga_table[unit_tga] ~= nil then
                        image_tga = eur_tga_table[unit_tga]
                    else
                        image_tga = test1
                    end
                    if ImGui.ImageButton("swapBGButton_button_t3_0"..tostring(i),image_tga.img,img_x, img_y) then
                        temp_target = i
                        curr_item = "T3"
                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    end
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        eurStyle("tooltip", true)
                        ImGui.BeginTooltip()
                        ImGui.Text(eduEntry.localizedName)
                        showEDUStats(eduEntry.eduType)
                        ImGui.EndTooltip()
                        eurStyle("tooltip", false)
                    end
                    if i == 4 then
                        ImGui.SameLine()
                    else
                        ImGui.SameLine()
                    end
                end
            end
            ImGui.NewLine()                
            --ImGui.Separator()
            ImGui.Text("Special:")
            for i = 1, #gen_units_list[eur_player_faction.name]["special"] do
                local eduEntry = M2TWEOPDU.getEduEntryByType(gen_units_list[eur_player_faction.name]["special"][i])
                if eduEntry ~= nil then
                    local unit_tga = eduEntry.unitCardTga
                    if eur_tga_table[unit_tga] ~= nil then
                        image_tga = eur_tga_table[unit_tga]
                    else
                        image_tga = test1
                    end
                    if ImGui.ImageButton("swapBGButton_button_s_0"..tostring(i),image_tga.img,img_x, img_y) then
                        temp_target = i
                        curr_item = "special"
                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    end
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        eurStyle("tooltip", true)
                        ImGui.BeginTooltip()
                        ImGui.Text(eduEntry.localizedName)
                        showEDUStats(eduEntry.eduType)
                        ImGui.EndTooltip()
                        eurStyle("tooltip", false)
                    end
                    if i == 4 then
                        ImGui.SameLine()
                    else
                        ImGui.SameLine()
                    end
                end
            end
            ImGui.EndChild()
            ImGui.SameLine()
            ImGui.SetNextWindowBgAlpha(0)
            ImGui.BeginChild("swap_bg_child_sub_2_test"..temp_target, 350*eurbackgroundWindowSizeRight, 500*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
            player_units_target, player_clicked = ImGui.Combo("", player_units_target, player_units_local, #player_units_local, #player_units_local+1)
            local eduEntry = M2TWEOPDU.getEduEntryByType(gen_units_list[eur_player_faction.name][curr_item][temp_target])
            if eduEntry ~= nil then
                local unit_tga = eduEntry.unitCardTga
                if eur_tga_table[unit_tga] ~= nil then
                    image_tga = eur_tga_table[unit_tga]
                else
                    image_tga = test1
                end
                ImGui.Image(image_tga.img,img_x, img_y)
                local hovered = ImGui.IsItemHovered()
                if hovered then
                    eurStyle("tooltip", true)
                    ImGui.BeginTooltip()
                    ImGui.Text(eduEntry.localizedName)
                    showEDUStats(eduEntry.eduType)
                    ImGui.EndTooltip()
                    eurStyle("tooltip", false)
                end
                ImGui.SameLine()
                ImGui.Dummy(0,32*eurbackgroundWindowSizeRight)
                ImGui.SameLine()
                ImGui.Text(" > ")
                ImGui.SameLine()
                local newEdu = M2TWEOPDU.getEduEntryByType(player_units[player_units_target+1])
                if newEdu ~= nil then
                local unit_tga = newEdu.unitCardTga
                    if eur_tga_table[unit_tga] ~= nil then
                        image_tga = eur_tga_table[unit_tga]
                    else
                        image_tga = test1
                    end
                    ImGui.Image(image_tga.img,img_x, img_y)
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        eurStyle("tooltip", true)
                        ImGui.BeginTooltip()
                        ImGui.Text(newEdu.localizedName)
                        showEDUStats(newEdu.eduType)
                        ImGui.EndTooltip()
                        eurStyle("tooltip", false)
                    end
                end
            end
            if ImGui.Button("Swap##1") then
                gen_units_list[eur_player_faction.name][curr_item][temp_target] = player_units[player_units_target+1]
                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
            end
            ImGui.EndChild()
        end
    end

    function unitADV()
        if (ImGui.CollapsingHeader("Advanced Options##unit02")) then
            ImGui.SetNextWindowBgAlpha(0)
                ImGui.BeginChild("swap_unit_child_sub_1_test", 590*eurbackgroundWindowSizeRight, 500*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
                --ImGui.Separator()
                if ImGui.Button("Load defaults##2") then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    UNIT_UPGRADES = {}
                    for k, v in pairs(UNIT_UPGRADES_default_fr) do
                        UNIT_UPGRADES[k] = v
                    end
                end
                ImGui.SameLine()
                if ImGui.Button("Save in files##2") then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    unitWriteDefault()
                end
                ImGui.SameLine()
                if ImGui.Button("Add unit") then
                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                    show_add_unit_up = true
                end
                ImGui.Text("Units with upgrades:")
                local index = 0
                for k, v in pairs(UNIT_UPGRADES) do
                    local eduEntry = M2TWEOPDU.getEduEntryByType(k)
                    if eduEntry ~= nil then
                        local unit_tga = eduEntry.unitCardTga
                        if eur_tga_table[unit_tga] ~= nil then
                            image_tga = eur_tga_table[unit_tga]
                        else
                            image_tga = test1
                        end
                        if eduEntry:hasOwnership(eur_player_faction.factionID) then
                            if not tableContains(player_units_cut[eur_player_faction.name],eduEntry.eduType) then
                                if eur_tga_table[eduEntry.unitCardTga] then
                                    if ImGui.ImageButton("swapunitButton_button_t1_0"..tostring(k),image_tga.img,img_x, img_y) then
                                        temp_edu = k
                                        up_temp_unit_choice=1
                                        show_add_unit_up = false
                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                    end
                                end
                                local hovered = ImGui.IsItemHovered()
                                if hovered then
                                    eurStyle("tooltip", true)
                                    ImGui.BeginTooltip()
                                    ImGui.Text(eduEntry.localizedName)
                                    showEDUStats(eduEntry.eduType)
                                    ImGui.EndTooltip()
                                    eurStyle("tooltip", false)
                                end
                                if (index % 5 == 0) then
                                    ImGui.NewLine()
                                else
                                    ImGui.SameLine()
                                end
                                index = index + 1
                            end
                        end
                    end
                end
                
                ImGui.EndChild()
                ImGui.SameLine()
                if show_add_unit_up then
                    ImGui.SameLine()
                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.BeginChild("add_unit_child_sub_1_test", 500*eurbackgroundWindowSizeRight, 650*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
                    ImGui.Text("New entry")
                    units_target, units_target_clicked = ImGui.Combo("##unitadd1", units_target, player_units_local, #player_units_local, #player_units_local+1)
                    local eduEntry = M2TWEOPDU.getEduEntryByType(player_units[units_target+1])
                    if eduEntry ~= nil then
                        local unit_tga = eduEntry.unitCardTga
                        if eur_tga_table[unit_tga] ~= nil then
                            image_tga = eur_tga_table[unit_tga]
                        else
                            image_tga = test1
                        end
                        if not UNIT_UPGRADES[eduEntry.eduType] then
                            ImGui.Image(image_tga.img,img_x, img_y)
                            local hovered = ImGui.IsItemHovered()
                            if hovered then
                                eurStyle("tooltip", true)
                                ImGui.BeginTooltip()
                                ImGui.Text("Unit")
                                ImGui.Text(eduEntry.localizedName)
                                showEDUStats(eduEntry.eduType)
                                ImGui.EndTooltip()
                                eurStyle("tooltip", false)
                            end
                            units_target_new, units_target_new_clicked = ImGui.Combo("##unitadd2", units_target_new, player_units_local, #player_units_local, #player_units_local+1)
                            local newEntry = M2TWEOPDU.getEduEntryByType(player_units[units_target_new+1])
                            if newEntry ~= nil then
                                local unit_tga = newEntry.unitCardTga
                                if eur_tga_table[unit_tga] ~= nil then
                                    image_tga = eur_tga_table[unit_tga]
                                else
                                    image_tga = test1
                                end
                                if eduEntry.eduType == newEntry.eduType then
                                    ImGui.TextColored(255,0,0,1,"Same unit")
                                else
                                    ImGui.Image(image_tga.img,img_x, img_y)
                                    local hovered = ImGui.IsItemHovered()
                                    if hovered then
                                        eurStyle("tooltip", true)
                                        ImGui.BeginTooltip()
                                        ImGui.Text("Upgrade")
                                        ImGui.Text(newEntry.localizedName)
                                        showEDUStats(newEntry.eduType)
                                        ImGui.EndTooltip()
                                        eurStyle("tooltip", false)
                                    end
                                    ImGui.NewLine()
                                    ImGui.Text("Exp requirement: ")
                                    ImGui.SameLine()
                                    expreq = ImGui.SliderInt("##upadd", expreq, 0, 9, "%d")
                                    ImGui.Text("Cost multiplier: ")
                                    ImGui.SameLine()
                                    if (ImGui.Button("-##02", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                        if new_unit_cost >= 1 then
                                            new_unit_cost=new_unit_cost-0.5
                                        elseif new_unit_cost == 1 then
                                            new_unit_cost=0.5
                                        end
                                    end
                                    ImGui.SameLine()
                                    ImGui.Text(string.format("%.1f", new_unit_cost))
                                    ImGui.SameLine()
                                    if (ImGui.Button("+##02", 25*eurbackgroundWindowSizeRight, 25*eurbackgroundWindowSizeBottom)) then
                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                        if new_unit_cost < 5 then
                                            new_unit_cost=new_unit_cost+0.5
                                        end
                                    end
                                    ImGui.SameLine()
                                    ImGui.Text(" = "..tostring(math.ceil(newEntry.recruitCost * new_unit_cost)))
                                    ImGui.NewLine()
                                    ImGui.Separator()
                                    ImGui.NewLine()
                                    if ImGui.Button("Add unit") then
                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                        UNIT_UPGRADES[eduEntry.eduType] = { unit = { newEntry.eduType }, expRequirement = { expreq }, cost_multi = { new_unit_cost }, counter = { "" } }
                                        show_add_unit_up = false
                                    end
                                end
                            end
                        else
                            ImGui.TextColored(255,0,0,1,"Unit already exists")
                        end
                        ImGui.EndChild()                      
                    end
                else
                    ImGui.SameLine()
                    ImGui.SetNextWindowBgAlpha(0)
                    ImGui.BeginChild("add_unit_child_sub_2_test", 500*eurbackgroundWindowSizeRight, 650*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
                    local eduEntry = M2TWEOPDU.getEduEntryByType(temp_edu)
                    if eduEntry ~= nil then
                        local unit_tga = eduEntry.unitCardTga
                        if eur_tga_table[unit_tga] ~= nil then
                            image_tga = eur_tga_table[unit_tga]
                        else
                            image_tga = test1
                        end
                        if UNIT_UPGRADES[eduEntry.eduType] then
                            ImGui.Text("Editing "..eduEntry.eduType)
                            if #UNIT_UPGRADES[eduEntry.eduType].unit < 4 then
                                if ImGui.Button("New upgrade") then
                                    M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                    local newindex = #UNIT_UPGRADES[eduEntry.eduType].unit+1
                                    UNIT_UPGRADES[eduEntry.eduType].unit[newindex] = player_units[1]
                                    UNIT_UPGRADES[eduEntry.eduType].expRequirement[newindex] = 2
                                    UNIT_UPGRADES[eduEntry.eduType].cost_multi[newindex] = 1
                                    UNIT_UPGRADES[eduEntry.eduType].counter[newindex] = ""
                                end
                                local hovered = ImGui.IsItemHovered()
                                if hovered then
                                    eurStyle("tooltip", true)
                                    ImGui.BeginTooltip()
                                    ImGui.Text("Add new upgrade entry for "..eduEntry.localizedName)
                                    ImGui.EndTooltip()
                                    eurStyle("tooltip", false)
                                end
                            end
                            ImGui.Image(image_tga.img,img_x, img_y)
                            local hovered = ImGui.IsItemHovered()
                            if hovered then
                                eurStyle("tooltip", true)
                                ImGui.BeginTooltip()
                                ImGui.Text("Unit")
                                ImGui.Text(eduEntry.localizedName)
                                showEDUStats(eduEntry.eduType)
                                ImGui.EndTooltip()
                                eurStyle("tooltip", false)
                            end
                            ImGui.Text("Upgrades:")
                            for i = 1, #UNIT_UPGRADES[eduEntry.eduType].unit do
                                if UNIT_UPGRADES[eduEntry.eduType].unit[i] ~= nil then
                                    local eduEntry = M2TWEOPDU.getEduEntryByType(UNIT_UPGRADES[eduEntry.eduType].unit[i])
                                    if eduEntry ~= nil then
                                        local unit_tga = eduEntry.unitCardTga
                                        if eur_tga_table[unit_tga] ~= nil then
                                            image_tga = eur_tga_table[unit_tga]
                                        else
                                            image_tga = test1
                                        end
                                        if eduEntry:hasOwnership(eur_player_faction.factionID) then
                                            local upgrade_clicked = ImGui.ImageButton("upgrade_button_0"..tostring(i),image_tga.img, img_x, img_y)
                                            if (upgrade_clicked == true) then
                                                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                up_temp_unit_choice=i
                                            end
                                            local hovered = ImGui.IsItemHovered()
                                            if hovered then
                                                eurStyle("tooltip", true)
                                                ImGui.BeginTooltip()
                                                ImGui.Text(eduEntry.localizedName)
                                                ImGui.Text("Cost :"..tostring(eduEntry.recruitCost))
                                                showEDUStats(eduEntry.eduType)
                                                ImGui.EndTooltip()
                                                eurStyle("tooltip", false)
                                            end
                                        else
                                            local upgrade_clicked = ImGui.ImageButton("upgrade_button_0"..tostring(i),image_tga.img, img_x, img_y)
                                            if (upgrade_clicked == true) then
                                                M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                                up_temp_unit_choice=i
                                            end
                                            local hovered = ImGui.IsItemHovered()
                                            if hovered then
                                                eurStyle("tooltip", true)
                                                ImGui.BeginTooltip()
                                                ImGui.Text(eduEntry.localizedName)
                                                ImGui.Text("Cost :"..tostring(eduEntry.recruitCost))
                                                showEDUStats(eduEntry.eduType)
                                                ImGui.TextColored(0.8, 0.8, 0.8, 1, "Upgrade is for a different faction")
                                                ImGui.EndTooltip()
                                                eurStyle("tooltip", false)
                                            end
                                        end
                                    end
                                    ImGui.SameLine()
                                end
                            end
                            ImGui.NewLine()
                            if UNIT_UPGRADES[eduEntry.eduType].unit[up_temp_unit_choice] ~= nil then
                                ImGui.Text(UNIT_UPGRADES[eduEntry.eduType].unit[up_temp_unit_choice])
                                ImGui.Text("Exp requirement: ")
                                ImGui.SameLine()
                                UNIT_UPGRADES[eduEntry.eduType].expRequirement[up_temp_unit_choice] = ImGui.SliderInt("##upchange", UNIT_UPGRADES[eduEntry.eduType].expRequirement[up_temp_unit_choice], 0, 9, "%d")
                                if UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice] == 0.1 then
                                    ImGui.Text("Cost multiplier(cannot change): ")
                                    ImGui.SameLine()
                                    ImGui.Text(string.format("%.1f", UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice]))
                                    local entry = M2TWEOPDU.getEduEntryByType(UNIT_UPGRADES[eduEntry.eduType].unit[up_temp_unit_choice])
                                    if entry then
                                        ImGui.SameLine()
                                        ImGui.Text(" = "..tostring(math.ceil(entry.recruitCost * UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice])))
                                    end
                                else
                                    ImGui.Text("Cost multiplier: ")
                                    ImGui.SameLine()
                                    if (ImGui.Button("-##02", 25, 25)) then
                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                        if UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice] >= 1 then
                                            UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice]=UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice]-0.5
                                        elseif UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice] == 1 then
                                            UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice]=0.5
                                        end
                                    end
                                    ImGui.SameLine()
                                    ImGui.Text(string.format("%.1f", UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice]))
                                    ImGui.SameLine()
                                    if (ImGui.Button("+##02", 25, 25)) then
                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                        if UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice] < 5 then
                                            UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice]=UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice]+0.5
                                        end
                                    end
                                    local entry = M2TWEOPDU.getEduEntryByType(UNIT_UPGRADES[eduEntry.eduType].unit[up_temp_unit_choice])
                                    if entry then
                                        ImGui.SameLine()
                                        ImGui.Text(" = "..tostring(math.ceil(entry.recruitCost * UNIT_UPGRADES[eduEntry.eduType].cost_multi[up_temp_unit_choice])))
                                    end
                                end
                                if UNIT_UPGRADES[eduEntry.eduType].counter[up_temp_unit_choice] == "" then
                                     ImGui.Text("Counter required: none")
                                else
                                    ImGui.Text("Counter required: "..UNIT_UPGRADES[eduEntry.eduType].counter[up_temp_unit_choice])
                                end
                                if UNIT_UPGRADES[eduEntry.eduType].faction == nil then
                                    ImGui.Text("Faction required: none")
                               else
                                    if UNIT_UPGRADES[eduEntry.eduType].faction[up_temp_unit_choice] == nil or UNIT_UPGRADES[eduEntry.eduType].faction[up_temp_unit_choice] == "" then
                                        ImGui.Text("Faction locked: none")
                                    else
                                        ImGui.Text("Faction locked: "..UNIT_UPGRADES[eduEntry.eduType].faction[up_temp_unit_choice])
                                    end
                               end
                                ImGui.Text("Change to ")
                                ImGui.SameLine()
                                units_target_change, units_target_change_clicked = ImGui.Combo("##unitadd3", units_target_change, player_units_local, #player_units_local, #player_units_local+1)
                                local newEntry = M2TWEOPDU.getEduEntryByType(player_units[units_target_change+1])
                                if newEntry ~= nil then
                                    local unit_tga = newEntry.unitCardTga
                                    if eur_tga_table[unit_tga] ~= nil then
                                        image_tga = eur_tga_table[unit_tga]
                                    else
                                        image_tga = test1
                                    end
                                    if UNIT_UPGRADES[eduEntry.eduType].unit[up_temp_unit_choice] == newEntry.eduType then
                                        ImGui.TextColored(255,0,0,1,"Same unit")
                                    else
                                        ImGui.Image(image_tga.img,img_x, img_y)
                                        local hovered = ImGui.IsItemHovered()
                                        if hovered then
                                            eurStyle("tooltip", true)
                                            ImGui.BeginTooltip()
                                            ImGui.Text(newEntry.localizedName)
                                            showEDUStats(newEntry.eduType)
                                            ImGui.EndTooltip()
                                            eurStyle("tooltip", false)
                                        end
                                        if ImGui.Button("Replace entry") then
                                            UNIT_UPGRADES[eduEntry.eduType].unit[up_temp_unit_choice] = newEntry.eduType
                                            M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                        end
                                        local hovered = ImGui.IsItemHovered()
                                        if hovered then
                                            eurStyle("tooltip", true)
                                            ImGui.BeginTooltip()
                                            ImGui.Text("Change to "..newEntry.localizedName)
                                            ImGui.EndTooltip()
                                            eurStyle("tooltip", false)
                                        end
                                    end
                                end
                                --ImGui.NewLine()
                                ImGui.Separator()
                                ImGui.NewLine()
                                local newEntry = M2TWEOPDU.getEduEntryByType(UNIT_UPGRADES[eduEntry.eduType].unit[up_temp_unit_choice])
                                if newEntry ~= nil then
                                    if ImGui.Button("Delete upgrade") then
                                        M2TWEOP.scriptCommand("play_sound_event", "BUTTON_DOWN")
                                        table.remove(UNIT_UPGRADES[eduEntry.eduType].unit, up_temp_unit_choice)
                                        table.remove(UNIT_UPGRADES[eduEntry.eduType].expRequirement, up_temp_unit_choice)
                                        table.remove(UNIT_UPGRADES[eduEntry.eduType].cost_multi, up_temp_unit_choice)
                                        table.remove(UNIT_UPGRADES[eduEntry.eduType].counter, up_temp_unit_choice)
                                        if UNIT_UPGRADES[eduEntry.eduType].unit[1] == {} or UNIT_UPGRADES[eduEntry.eduType].unit[1] == nil then
                                            UNIT_UPGRADES[eduEntry.eduType] = nil
                                        end
                                    end
                                    local hovered = ImGui.IsItemHovered()
                                    if hovered then
                                        eurStyle("tooltip", true)
                                        ImGui.BeginTooltip()
                                        ImGui.Text("Delete upgrade "..newEntry.localizedName)
                                        ImGui.EndTooltip()
                                        eurStyle("tooltip", false)
                                    end
                                end
                            end
                        end
                    end
                    ImGui.EndChild()
                end
                --[[ImGui.SameLine()
                ImGui.SetNextWindowBgAlpha(0)
                ImGui.BeginChild("swap_unit_child_sub_2_test"..temp_edu, 350*eurbackgroundWindowSizeRight, 500*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoDecoration)
                player_units_target, player_clicked = ImGui.Combo("", player_units_target, player_units_local, #player_units_local, #player_units_local+1)
                local eduEntry = M2TWEOPDU.getEduEntryByType(gen_units_list[eur_player_faction.name][curr_item][temp_target])
                if eduEntry ~= nil then
                    if eur_tga_table[eduEntry.unitCardTga] then
                        ImGui.Image(eur_tga_table[eduEntry.unitCardTga].img,img_x, img_y)
                        local hovered = ImGui.IsItemHovered()
                        if hovered then
                            eurStyle("tooltip", true)
                            ImGui.BeginTooltip()
                            ImGui.Text(eduEntry.localizedName)
                            showEDUStats(eduEntry.eduType)
                            ImGui.EndTooltip()
                            eurStyle("tooltip", false)
                        end
                        ImGui.SameLine()
                        ImGui.Dummy(0,32*eurbackgroundWindowSizeRight)
                        ImGui.SameLine()
                        ImGui.Text(" > ")
                        ImGui.SameLine()
                        local newEdu = M2TWEOPDU.getEduEntryByType(player_units[player_units_target+1])
                        ImGui.Image(eur_tga_table[newEdu.unitCardTga].img,img_x, img_y)
                        local hovered = ImGui.IsItemHovered()
                        if hovered then
                            eurStyle("tooltip", true)
                            ImGui.BeginTooltip()
                            ImGui.Text(newEdu.localizedName)
                            showEDUStats(newEdu.eduType)
                            ImGui.EndTooltip()
                            eurStyle("tooltip", false)
                        end
                    end
                end
                if ImGui.Button("Swap##1") then
                    gen_units_list[eur_player_faction.name][curr_item][temp_target] = player_units[player_units_target+1]
                end
                ImGui.EndChild()]]
            end
        end

local function serializeTable(tbl, indent)
    indent = indent or 1
    local indentStr = string.rep("    ", indent)
    local closingStr = string.rep("    ", indent - 1)
    local result = "{\n"
    
    for key, value in pairs(tbl) do
        -- Format the key
        local keyStr
        if type(key) == "string" then
            keyStr = string.format("[\"%s\"]", key)
        else
            keyStr = string.format("[%d]", key)
        end
        
        -- Format the value
        local valueStr
        if type(value) == "table" then
            valueStr = serializeTable(value, indent + 1)
        elseif type(value) == "string" then
            valueStr = string.format("\"%s\"", value)
        elseif type(value) == "number" then
            valueStr = tostring(value)
        elseif type(value) == "boolean" then
            valueStr = tostring(value)
        else
            valueStr = string.format("\"%s\"", tostring(value))
        end
        
        result = result .. indentStr .. keyStr .. " = " .. valueStr .. ",\n"
    end
    
    return result .. closingStr .. "}"
end

function generalWriteDefault()
    local path = M2TWEOP.getModPath()
    if game_options.BG_T2 then
        local filename = path .. "\\eopData\\eopScripts\\eur\\upgrades\\eurGeneralBGSwapDefault2.lua"
        local file = io.open(filename, "w")
        if not file then return end
        file:write("gen_units_list_default2 = " .. serializeTable(gen_units_list) .. "\n")
        file:close()
    else
        local filename = path .. "\\eopData\\eopScripts\\eur\\upgrades\\eurGeneralBGSwapDefault.lua"
        local file = io.open(filename, "w")
        if not file then return end
        file:write("gen_units_list_default = " .. serializeTable(gen_units_list) .. "\n")
        file:close()
    end
    
end

function unitWriteDefault()
    local path = M2TWEOP.getModPath()
    local filename = path .. "\\eopData\\eopScripts\\eur\\upgrades\\eurUnitUpgradeList.lua"
    local file = io.open(filename, "w")
    if not file then return end
    
    file:write("UNIT_UPGRADES_default = " .. serializeTable(UNIT_UPGRADES) .. "\n")
    
    file:close()
end