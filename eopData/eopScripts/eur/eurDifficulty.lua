local FREE_UPKEEP_LIST = {
	["Tawar Areiniyr"] = true,
	["umunzahar Nobles"] = true,
	["Watch Shirriffs"] = true,
	["Erebor Infantry"] = true,
	["Nomad Warriors"] = true,
	["Claw-Guard"] = true,
	["Muhad Warriors"] = true,
	["Bandits"] = true,
	["Steppe Tribesmen"] = true,
	["Lorien Scouts"] = true,
	["Uruk-hai Raiders"] = true,
	["Dunedain Bodyguard"] = true,
	["Clan Axemen"] = true,
	["Warg Skirmishers"] = true,
	["Woodland Warriors"] = true,
	["Mordag Fishermen"] = true,
	["Orc Band"] = true,
	["Pinnath Gelin Footmen"] = true,
	["Anfalas Herdsmen"] = true,
	--["Heavy Falathrim Wavebreakers"] = true,
	["Lamedon Clansmen"] = true,
	["Uruk Bodyguard"] = true,
	["Blue Crag Goblin Slingers"] = true,
	["Goblin Bodyguards"] = true,
	["Mountain-Orc Hunters"] = true,
	["Lebennin Marines"] = true,
	["Blue Crag Blunt"] = true,
	["Warg Riders"] = true,
	["Gondor Bodyguard"] = true,
	["Lindon Rangers"] = true,
	["Seregil Riders"] = true,
	["Pharazim Nobles"] = true,
	["Lindon Bladesmen"] = true,
	["Uruk Reavers"] = true,
	["Dunedain Rangers"] = true,
	["Angmar Bodyguards"] = true,
	["Goblin Infantry"] = true,
	--["Shadowblades of Himring"] = true,
	["Orc Host"] = true,
	["Khandish Hunters"] = true,
	["Elbereths Sentinels"] = true,
	["Woodman Warriors"] = true,
	["Ered Luin Scouts"] = true,
	["Lindar Mariners"] = true,
	["Warband Host"] = true,
	["Snow-Orc Raiders"] = true,
	["Gathring Shieldbearers"] = true,
	["Haradrim Spearmen"] = true,
	["Sworn Defenders"] = true,
	["Warg Marauders"] = true,
	["Rivermen"] = true,
	["Lorien Sentries"] = true,
	["Mirkwood Archers"] = true,
	["Lindon Mounted Wardens"] = true,
	["Misty Mangonel"] = true,
	["Goblin Band"] = true,
	["Fylani Herders"] = true,
	["Clan Heralds"] = true,
	["Blue Crag Dual"] = true,
	["Loke Rim Bodyguard"] = true,
	["Woodman Trackers"] = true,
	["Warband Sentries"] = true,
	["Khazad Sentries"] = true,
	["Sworn Horsemen"] = true,
	["Mirkwood Spears"] = true,
	["Orc Raiders"] = true,
	--["Hirneryn Marchwardens"] = true,
	["Rohirrim Archers"] = true,
	["Orc Maulers"] = true,
	["Bandobras Archers"] = true,
	["Faolan Warriors"] = true,
	["Thorn Crossbowmen"] = true,
	["Liadan Billmen"] = true,
	["Daritai Clansmen"] = true,
	["Khandish Raiders"] = true,
	["Beorning Axemen"] = true,
	["Rhudaur Pikemen"] = true,
	["Peasant Militia"] = true,
	["Merchant Militia"] = true,
	["Archer Militia"] = true,
	["Isengard Ballista"] = true,
	["Hillmen"] = true,
	["Blue Crag Ballista"] = true,
	["Snaga Archers"] = true,
	["Skin-Changers"] = true,
	["Blue Crag Goblin Spears"] = true,
	["Blue Crag Goblin Axes"] = true,
	["Blue Crag Slingers"] = true,
	["Territorial Watchmen"] = true,
	["Falas Lords"] = true,
	["Thralls"] = true,
	--["Doross Archers"] = true,
	["Northmen Militia"] = true,
	["Beekeepers"] = true,
	["Lindon Coastal Wardens"] = true,
	["Lindon Infantry"] = true,
	["Nomad Horsemen"] = true,
	["Daerbor Archers"] = true,
	["Lindon Marines"] = true,
	["Mornhîth Warriors"] = true,
	["Aglon Defenders"] = true,
	["Clan Hunters"] = true,
	["Feanor BG"] = true,
	["Mochaini Touta"] = true,
	["Aglon Archers"] = true,
	["Dalian Swordsmen"] = true,
	["Lindon Longspears"] = true,
	["Blue Crag Skirmishers"] = true,
	["Fang-Guard"] = true,
	--["Helevorn Pikemen"] = true,
	["Noldorin Sword Bodyguard"] = true,
	["Belegaer Archers"] = true,
	["Noldorin Javelin Bodyguard"] = true,
	["Eregion Barad Skirmishers"] = true,
	["Southron Warband"] = true,
	["Thorn Riders"] = true,
	["Dubhshith Elders"] = true,
	["Sworn Archers"] = true,
	["Mounted Quendi"] = true,
	["Dalian Billmen"] = true,
	["Eregion Lindar Mariners"] = true,
	["Dale Cavalry"] = true,
	--["Orc-men spearguard"] = true,
	["Haradrim Archers"] = true,
	--["Eregion Mithrim Archers"] = true,
	["Dunedain Garrison"] = true,
	["Eregion Lindar Bowmen"] = true,
	["Lorien Warders"] = true,
	["Eregion Lindon Longspears"] = true,
	["Eregion Lindar Guards"] = true,
	["Woodman Defenders"] = true,
	["Brenin's Guard"] = true,
	["Zenith Guard"] = true,
	["Eregion Mounted Quendi"] = true,
	["Frekkalingir Hill-Riders"] = true,
	["Territorial Cavalry"] = true,
	["Eregion Sword Quendi"] = true,
	["Dunedain Wardens"] = true,
	["Lindar Guards"] = true,
	--["Barad Eithel Blademasters"] = true,
	["Rohirrim"] = true,
	["Liadan Spearmen"] = true,
	["Erebor Axethrowers"] = true,
	["Southron Archers"] = true,
	--["Eregion Mithrim Spearmen"] = true,
	["Angmarim Archers"] = true,
	--["Heavenly Arch Archers"] = true,
	--["Eotheod Cavalry"] = true,
	--["Sindar Riders"] = true,
	--["Barad Eithel Archers"] = true,
	["Thorn Bladesmen"] = true,
	["Goblin Archers"] = true,
	["Bow Quendi"] = true,
	["Snaga Catapult"] = true,
	["Blue Crag Goblin Dual"] = true,
	["Sword Quendi"] = true,
	--["Gondor Cavalry"] = true,
	["Thorn Guard"] = true,
	["Rhunnic Spears"] = true,
	["Lindon Pike Quendi"] = true,
	["Khazad Volunteers"] = true,
	["Firebeard Warriors"] = true,
	["Snow-Orc Scouts"] = true,
	["Goblin Stalkers"] = true,
	["Lumbermen"] = true,
	["Lindon Marines Quendi"] = true,
	["Orc Archers"] = true,
	["Lindon Scouts Quendi"] = true,
	--["Lindon Heavy Pikes"] = true,
	["Clan Spearmen"] = true,
	--["Northmen Garrison Elite"] = true,
	["Lindon Cavalry"] = true,
	["Dunlending Longspears"] = true,
	["Marauders"] = true,
	["Uruk-hai Archers"] = true,
	["Steppe Archers"] = true,
	["Spear Quendi"] = true,
	["Lorien Archers"] = true,
	["Snaga Skirmishers"] = true,
	["Mordag Skirmishers"] = true,
	["Regent Spearguard"] = true,
	["Westron Catapult"] = true,
	["Azrazair Archers"] = true,
	["Royal Guardsmen"] = true,
	["Raider Warband"] = true,
	["Woodland Hunters"] = true,
	["Dwarven Labourers"] = true,
	["Raider Skirmishers"] = true,
	["Druedain Hunters"] = true,
	["Woodland Wardens"] = true,
	["Eorling Archers"] = true,
	["Eored Axemen"] = true,
	["Eorling Spearmen"] = true,
	["Angmarim Infantry"] = true,
	["Dunedain Scouts"] = true,
	["Rhovanion Hunters"] = true,
	["Breeland Militia"] = true,
	["Beorning Spearmen"] = true,
	--["Variag Nobles"] = true,
	["Dol Guldur Host"] = true,
	["Territorial Swordsmen"] = true,
	["Woodman Wardens"] = true,
	["Goblin Striders"] = true,
	["Noldorin Bodyguards"] = true,
	["Thorn Patrolers"] = true,
	["Dunlending Raiders"] = true,
	["Fylani War Wagons"] = true,
	--["Carinquar Riders"] = true,
	--["Rhudaur Savages"] = true,
	--["Yavannas Chosen"] = true,
	["Eregion Spear Quendi"] = true,
	--["Black Pit Spears"] = true,
	["Snaga Stalkers"] = true,
	--["Merchant Cavalry"] = true,
	--["Frekkalingir Stalwarts"] = true,
	--["Gondor Infantry"] = true,
	["Rhovanion Riders"] = true,
	["Dol Guldur Archers"] = true,
	--["Greenway Riders"] = true,
	["Territorial Guardsmen"] = true,
	["Belegaer Footmen"] = true,
	["High Paladins"] = true,
	["Rohan Bodyguard"] = true,
	["Woodland Spearmen"] = true,
	["Southron Lancers"] = true,
	["Farmhand Pikemen"] = true,
	["Dourhand Catapult"] = true,
	["Rhunnic Bowmen"] = true,
	["Ered Luin Pikemen"] = true,
	["Blue Crag Warg Riders"] = true,
	--["Balaketh Axeguard"] = true,
	--["Regent Axeguard"] = true,
	["Rhovanion Spearmen"] = true,
	["Orc Raiders old"] = true,
	--["Athala Rangers"] = true,
	--["Wolf Pack"] = true,
	["Mount Gram Marauders"] = true,
	["Nomad Axemen"] = true,
	--["Rhudaur Huscarles"] = true,
	--["Dunhird Berserkers"] = true,
	["Orc Ballista"] = true,
	["Vale Archers"] = true,
	["Ered Luin Militia"] = true,
	["Ered Luin Militia Pikemen"] = true,
	--["Cardolan Sentinels"] = true,
	--["Riddermark Axemen"] = true,
	["Rhovanion Gadrauhts"] = true,
	["Eregion Bow Quendi"] = true,
	["Woodland Scouts"] = true,
	["Maethyr i-Thewair"] = true,
	["Frekkalingir Harriers"] = true,
	["Calaquendi Lords"] = true,
	["Beorning Defenders"] = true,
	["Morannon Guard"] = true,
	["Rhunnic Warriors"] = true,
	["Lindon Bow Quendi"] = true,
	--["Black Uruks"] = true,
	--["Iron Crown Warriors"] = true,
	["Southron Pikemen"] = true,
	["Azrazair Raiders"] = true,
	["Uruk-hai Bodyguards"] = true,
	["Faolan Borderguard"] = true,
	["Mountain Guard"] = true,
	["Mount Gram Raiders"] = true,
	["Woodman Hunters"] = true,
	["Dol Guldur Scouts"] = true,
	["Mirkwood Slayers"] = true,
	--["Black Pit Infantry"] = true,
	["Iron Hills Mattocks"] = true,
	["Snaga Ballista"] = true,
	["Lindar Bowmen"] = true,
	--["Blackshield Warband"] = true,
	["Mirkwood Bodyguard"] = true,
	--["Blackshield Halberds"] = true,
	["Keefei Huntsmen"] = true,

	["Realm Sentinels"] = true,
	["Eldarinwe Bodyguards"] = true,
	["Sindar Riders"] = true,

	["Mornhith Warriors"] = true,
}

TRAITS_MODIFY = {
    militaryAI = {
        name = "AIBoostMilitary",
        levels = {
            [0] = {
                [0] = 3, --Command
                [1] = 5, --HitPoints 
                [2] = 5, --LineOfSight 
                [3] = 5, --PersonalSecurity 
                [4] = 5, --BodyguardSize 
                [5] = 50, --SiegeEngineering 
                [6] = 4, --TroopMorale 
                [7] = 1, --NightBattle 
            },
            [1] = {
                [0] = 4, --Command 
                [1] = 7, --HitPoints 
                [2] = 5, --LineOfSight 
                [3] = 5, --PersonalSecurity 
                [4] = 5, --BodyguardSize 
                [5] = 60, --SiegeEngineering 
                [6] = 7, --TroopMorale 
                [7] = 1, --NightBattle 
            },
        },
    },
}

function editTrait()
	if not game_options.options_aiboost then return end
    if editTrait_on then return end
    for k, v in pairs(TRAITS_MODIFY) do
        local trait = M2TWEOP.getTrait(TRAITS_MODIFY[k].name);
        if trait ~= nil then
            print(trait.levelCount)
            for i = 0, trait.levelCount - 1 do
                local lvl = trait:getLevel(i);
                if lvl ~= nil then
                    print(lvl.name)
                    for j = 0, lvl.effectsCount -1 do
                        local effect = lvl:getTraitEffect(j);
                        if effect ~= nil then
                            effect = TRAITS_MODIFY[k].levels[i][j]
                            print(effect)
                        end
                    end
                end
            end
        end
    end
    editTrait_on = true
end

if eur_main_scripts then
    -- EUR Overrides, for compatibility - GOES AT END
    require('eur/eop_events/eurOverrides')
    --require('eur/overrides')
end


function legendaryDifficulty(faction)
    player_start_threshold = 8
    --[[if faction ~= nil then
        if faction.isPlayerControlled == 1 then
            for x = 0, eur_player_faction.settlementsNum - 1 do
                local sett = eur_player_faction:getSettlement(x)
                if sett ~= nil then
                    local income = (sett.settlementStats.TotalIncomeWithoutAdmin + sett.settlementStats.AdminIncome +
                    sett.settlementStats.BuildingsIncome -
                    sett.settlementStats.CorruptionExpense -
                    sett.settlementStats.RecruitmentExpense -
                    sett.settlementStats.DiplomaticExpense -
                    sett.settlementStats.EntertainmentExpense -
                    sett.settlementStats.DevastationExpense)
                    local deducted_income = math.ceil(income*0.7)
                    --stratmap.game.callConsole("add_money", "-" .. tostring(deducted_income))
                end
            end
        end
    end]]

    if faction ~= nil then
        if faction.isPlayerControlled == 0 then
            local isInWar = eur_campaign:checkDipStance(dipRelType.war, faction, eur_player_faction)
            if isInWar then
                if not PURSE_MODIFIED[faction.name] then
                    PURSE_MODIFIED[faction.name] = true
                    faction.kingsPurse = faction.kingsPurse + 1000
                    --[[if eur_turn_number == 0 then
                        if gen_units_list[faction.name] then
                            if faction.capital then
                                local army = eurSpawnArmy(faction.name, "random_name", "leg_", "", false, 18, gen_units_list[faction.name]["special"][1], faction.capital.xCoord, faction.capital.yCoord, 3, 1, 0)
                                if army then    
                                    for i = 1, 1 do
                                            local rand = math.random(0, #gen_units_list[faction.name]["T2"]-1)
                                            local new_unit = gen_units_list[faction.name]["T2"][rand]
                                            army:createUnit(new_unit, 0, 0, 0)
                                    end
                                    for i = 1, 2 do
                                        local rand = math.random(0, #gen_units_list[faction.name]["T1"]-1)
                                        local new_unit = gen_units_list[faction.name]["T1"][rand]
                                        army:createUnit(new_unit, 0, 0, 0)
                                    end
                                end
                            end
                        end
                    end]]
                end
            end
        end
    end
end

GREEN_BOOK_BU = {
    "hinterland_green_book_01",
    "hinterland_green_book_02",
    "hinterland_green_book_03",
    "hinterland_green_book_04",
    "hinterland_green_book_05",
    "hinterland_green_book_06",
    "hinterland_green_book_07",
    "hinterland_green_book_08",
}

function orderOffset()
	if not game_options.order_offset then return end
    if orderOffset_on then return end
    for x = 1, #GREEN_BOOK_BU do
        local building = EDB.getBuildingByName(GREEN_BOOK_BU[x])
        local bonus = -4
        for i = 0, building.buildingLevelCount -1 do
            bu = building:getBuildingLevel(i)
            bu:addCapability(buildingCapability.law_bonus, (bonus), true, "factions { "..eur_player_faction.name..", }")
        end
    end
    orderOffset_on = true
end

EDUOFFET_VARS = {
    threshold = 500,
    extragold = 0,
    extragold2 = 0,
    recruitTimeMult = 1,
    offset1 = 0,
    offset2 = 0,
    pooloffset1 = 0,
    pooloffset2 = 0,
	bu_time = 0,
	bu_cost = 0,
}

EDUOFFET_VARS_LEG = {
	threshold = 500,
	extragold = 0,
	extragold2 = 0,
	recruitTimeMult = 2,
	offset1 = 0,
	offset2 = 0,
	pooloffset1 = 60,
	pooloffset2 = 40,
	bu_time = 1,
	bu_cost = 10,
}

EDB_POOL_CUSTOM = {}

temp_unit_levels = {
    [0] = {},
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {},
    [11] = {},
}

default_edu_reset = {}
default_edb_reset = {}
default_edb_reset2 = {}

function defaultEDUEDBReset()
	for i = 1, #default_edu_reset do
		local eduEntry = M2TWEOPDU.getEduEntry(default_edu_reset[i].index);
        if eduEntry ~= nil then
			eduEntry.recruitTime = default_edu_reset[i].recruitTime
			eduEntry.recruitCost = default_edu_reset[i].recruitCost
			eduEntry.upkeepCost = default_edu_reset[i].upkeepCost
		end
	end
	for i = 1, #default_edb_reset do
        local edbEntry = EDB.getBuildingByID(default_edb_reset[i].id)
        if edbEntry ~= nil then
			local level = edbEntry:getBuildingLevel(default_edb_reset[i].level)
			if level ~= nil then
				level.buildCost = default_edb_reset[i].buildCost
				level.buildTime = default_edb_reset[i].buildTime
			end
		end
	end
	for i = 1, #default_edb_reset2 do
        local edbEntry = EDB.getBuildingByID(default_edb_reset2[i].id)
        if edbEntry ~= nil then
			local level = edbEntry:getBuildingLevel(default_edb_reset2[i].level)
			if level ~= nil then
				local pool = level:getRecruitPool(x)
				if pool ~= nil then
					pool.gainPerTurn = default_edb_reset2[i].gainPerTurn
				end
			end
		end
	end
	defaultEDUOffsetleg_on = false
	defaultEDUOffset_on = false
	defaultEDUOffsetSetts_on = false
end

function defaultEDUOffset()
	--if not game_options.options_usemods then return end
    local offset1 = percentIntToFloat(EDUOFFET_VARS.offset1)
    local offset2 = offset1
    local pooloffset1 = percentIntToFloat(EDUOFFET_VARS.pooloffset1)
    local pooloffset2 = pooloffset1
	local bu_cost = percentIntToFloat(EDUOFFET_VARS.bu_cost)
    if defaultEDUOffset_on then return end
	if defaultEDUOffset_faction == eur_player_faction.name then return end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."defaultEDUOffset");
	end
    for i = 0, 1500 do
        local eduEntry = M2TWEOPDU.getEduEntry(i)
        if eduEntry ~= nil then
			if game_options.playeronlymods then
				if eduEntry:hasOwnership(eur_playerFactionId) then
					table.insert(default_edu_reset, {index = eduEntry.index, recruitTime = eduEntry.recruitTime, recruitCost = eduEntry.recruitCost, upkeepCost = eduEntry.upkeepCost})
					if options_no_free_upkeep then
						if not FREE_UPKEEP_LIST[eduEntry.eduType] then
							eduEntry.freeUpkeepUnit = false
						end
					end
					eduEntry.recruitTime = math.ceil(eduEntry.recruitTime*EDUOFFET_VARS.recruitTimeMult)
					if eduEntry.recruitCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS.threshold then
						eduEntry.recruitCost = math.ceil(eduEntry.recruitCost*offset1)
					elseif eduEntry.recruitCost > 0 then
						eduEntry.recruitCost = math.ceil(eduEntry.recruitCost*offset2)
					end
					if eduEntry.upkeepCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS.threshold then
						eduEntry.upkeepCost = math.ceil(eduEntry.upkeepCost*offset1)
						eduEntry.upkeepCost = eduEntry.upkeepCost+EDUOFFET_VARS.extragold
					elseif eduEntry.upkeepCost > 0 then
						eduEntry.upkeepCost = math.ceil(eduEntry.upkeepCost*offset2)
						eduEntry.upkeepCost = eduEntry.upkeepCost+EDUOFFET_VARS.extragold2
					end
				end
			else
				table.insert(default_edu_reset, {index = eduEntry.index, recruitTime = eduEntry.recruitTime, recruitCost = eduEntry.recruitCost, upkeepCost = eduEntry.upkeepCost})
				if options_no_free_upkeep then
					if not FREE_UPKEEP_LIST[eduEntry.eduType] then
						eduEntry.freeUpkeepUnit = false
					end
				end
				eduEntry.recruitTime = math.ceil(eduEntry.recruitTime*EDUOFFET_VARS.recruitTimeMult)
				if eduEntry.recruitCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS.threshold then
					eduEntry.recruitCost = math.ceil(eduEntry.recruitCost*offset1)
				elseif eduEntry.recruitCost > 0 then
					eduEntry.recruitCost = math.ceil(eduEntry.recruitCost*offset2)
				end
				if eduEntry.upkeepCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS.threshold then
					eduEntry.upkeepCost = math.ceil(eduEntry.upkeepCost*offset1)
					eduEntry.upkeepCost = eduEntry.upkeepCost+EDUOFFET_VARS.extragold
				elseif eduEntry.upkeepCost > 0 then
					eduEntry.upkeepCost = math.ceil(eduEntry.upkeepCost*offset2)
					eduEntry.upkeepCost = eduEntry.upkeepCost+EDUOFFET_VARS.extragold2
				end
			end
        end
    end
    for i = 0, 200 do
        local edbEntry = EDB.getBuildingByID(i)
        if edbEntry ~= nil then
            for j = 0, edbEntry.buildingLevelCount -1 do
                local level = edbEntry:getBuildingLevel(j)
                if level ~= nil then
					table.insert(default_edb_reset, {id = i, level = j, buildCost = level.buildCost, buildTime = level.buildTime})
					level.buildCost = math.ceil(level.buildCost*bu_cost)
					level.buildTime = level.buildTime+EDUOFFET_VARS.bu_time
                    for x = 0, level.recruitPoolNum -1 do
                        local pool = level:getRecruitPool(x)
                        if pool ~= nil then
                            local eduEntry=M2TWEOPDU.getEduEntry(pool.unitID);
                            if eduEntry ~= nil then
                                --[[local index = 0
                                if j > 0 then
                                    index = 1
                                end
                                if not temp_unit_levels[index] then
                                    temp_unit_levels[index] = {}
                                end
                                if not temp_unit_levels[index][eduEntry.eduType] then
                                    if eduEntry.freeUpkeepUnit == true then
                                        temp_unit_levels[index][eduEntry.eduType] = true
                                    end
                                end]]
								if game_options.playeronlymods then
									if eduEntry:hasOwnership(eur_playerFactionId) then
										table.insert(default_edb_reset2, {id = i, level = level, pool = x, pool.gainPerTurn})
										--[[if not EDB_POOL_CUSTOM[edbEntry.name] then
											EDB_POOL_CUSTOM[edbEntry.name] = {}
											EDB_POOL_CUSTOM[edbEntry.name].localname = edbEntry.localizedName
										end
										if not EDB_POOL_CUSTOM[edbEntry.name][j] then
											EDB_POOL_CUSTOM[edbEntry.name][j] = {}
											EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId] = {}
											EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId].name = level:getLocalizedName(eur_playerFactionId)
											EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId]["units"] = {}
										end
										EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId]["units"][eduEntry.eduType] = {
											experience = pool.experience,
											eduType = eduEntry.eduType,
											unitCardTga = eduEntry.unitCardTga,
											initialSize = pool.initialSize,
											gainPerTurn = pool.gainPerTurn,
											maxSize = pool.maxSize, 
										}]]
										if pool.gainPerTurn > 0 then
											if eduEntry.upkeepCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS.threshold then
												pool.gainPerTurn = pool.gainPerTurn / pooloffset1
											else
												pool.gainPerTurn = pool.gainPerTurn / pooloffset2
											end
										end
									end
								else
									table.insert(default_edb_reset2, {id = i, level = level, pool = x, pool.gainPerTurn})
									--[[if not EDB_POOL_CUSTOM[edbEntry.name] then
										EDB_POOL_CUSTOM[edbEntry.name] = {}
										EDB_POOL_CUSTOM[edbEntry.name].localname = edbEntry.localizedName
									end
									if not EDB_POOL_CUSTOM[edbEntry.name][j] then
										EDB_POOL_CUSTOM[edbEntry.name][j] = {}
										EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId] = {}
										EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId].name = level:getLocalizedName(eur_playerFactionId)
										EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId]["units"] = {}
									end
									EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId]["units"][eduEntry.eduType] = {
										experience = pool.experience,
										eduType = eduEntry.eduType,
										unitCardTga = eduEntry.unitCardTga,
										initialSize = pool.initialSize,
										gainPerTurn = pool.gainPerTurn,
										maxSize = pool.maxSize, 
									}]]
									if pool.gainPerTurn > 0 then
										if eduEntry.upkeepCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS.threshold then
											pool.gainPerTurn = pool.gainPerTurn / pooloffset1
										else
											pool.gainPerTurn = pool.gainPerTurn / pooloffset2
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
    defaultEDUOffset_on = true
	defaultEDUOffset_faction = eur_player_faction.name
end

function defaultEDUOffset_leg()
    local offset1 = percentIntToFloat(EDUOFFET_VARS_LEG.offset1)
    local offset2 = offset1
    local pooloffset1 = percentIntToFloat(EDUOFFET_VARS_LEG.pooloffset1)
    local pooloffset2 = pooloffset1
	local bu_cost = percentIntToFloat(EDUOFFET_VARS_LEG.bu_cost)
    if defaultEDUOffsetleg_on then return end
	if defaultEDUOffset_factionleg == eur_player_faction.name then return end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."defaultEDUOffset_leg");
	end
    for i = 0, 1500 do
        local eduEntry = M2TWEOPDU.getEduEntry(i)
        if eduEntry ~= nil then
			if eduEntry:hasOwnership(eur_playerFactionId) then
				--table.insert(default_edu_reset, {index = eduEntry.index, recruitTime = eduEntry.recruitTime, recruitCost = eduEntry.recruitCost, upkeepCost = eduEntry.upkeepCost})
				if options_no_free_upkeep then
					if not FREE_UPKEEP_LIST[eduEntry.eduType] then
						eduEntry.freeUpkeepUnit = false
					end
				end
				eduEntry.recruitTime = math.ceil(eduEntry.recruitTime*EDUOFFET_VARS_LEG.recruitTimeMult)
				if eduEntry.recruitCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS_LEG.threshold then
					eduEntry.recruitCost = math.ceil(eduEntry.recruitCost*offset1)
				elseif eduEntry.recruitCost > 0 then
					eduEntry.recruitCost = math.ceil(eduEntry.recruitCost*offset2)
				end
				if eduEntry.upkeepCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS_LEG.threshold then
					eduEntry.upkeepCost = math.ceil(eduEntry.upkeepCost*offset1)
					eduEntry.upkeepCost = eduEntry.upkeepCost+EDUOFFET_VARS_LEG.extragold
				elseif eduEntry.upkeepCost > 0 then
					eduEntry.upkeepCost = math.ceil(eduEntry.upkeepCost*offset2)
					eduEntry.upkeepCost = eduEntry.upkeepCost+EDUOFFET_VARS_LEG.extragold2
				end
			end
        end
    end
    for i = 0, 200 do
        local edbEntry = EDB.getBuildingByID(i)
        if edbEntry ~= nil then
            for j = 0, edbEntry.buildingLevelCount -1 do
                local level = edbEntry:getBuildingLevel(j)
                if level ~= nil then
					--table.insert(default_edb_reset, {id = i, level = j, buildCost = level.buildCost, buildTime = level.buildTime})
					level.buildCost = math.ceil(level.buildCost*bu_cost)
					level.buildTime = level.buildTime+EDUOFFET_VARS_LEG.bu_time
                    for x = 0, level.recruitPoolNum -1 do
                        local pool = level:getRecruitPool(x)
                        if pool ~= nil then
                            local eduEntry=M2TWEOPDU.getEduEntry(pool.unitID);
                            if eduEntry ~= nil then
                                --[[local index = 0
                                if j > 0 then
                                    index = 1
                                end
                                if not temp_unit_levels[index] then
                                    temp_unit_levels[index] = {}
                                end
                                if not temp_unit_levels[index][eduEntry.eduType] then
                                    if eduEntry.freeUpkeepUnit == true then
                                        temp_unit_levels[index][eduEntry.eduType] = true
                                    end
                                end]]
								if eduEntry:hasOwnership(eur_playerFactionId) then
									--table.insert(default_edb_reset2, {id = i, level = level, pool = x, pool.gainPerTurn})
									--[[if not EDB_POOL_CUSTOM[edbEntry.name] then
										EDB_POOL_CUSTOM[edbEntry.name] = {}
										EDB_POOL_CUSTOM[edbEntry.name].localname = edbEntry.localizedName
									end
									if not EDB_POOL_CUSTOM[edbEntry.name][j] then
										EDB_POOL_CUSTOM[edbEntry.name][j] = {}
										EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId] = {}
										EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId].name = level:getLocalizedName(eur_playerFactionId)
										EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId]["units"] = {}
									end
									EDB_POOL_CUSTOM[edbEntry.name][j][eur_playerFactionId]["units"][eduEntry.eduType] = {
										experience = pool.experience,
										eduType = eduEntry.eduType,
										unitCardTga = eduEntry.unitCardTga,
										initialSize = pool.initialSize,
										gainPerTurn = pool.gainPerTurn,
										maxSize = pool.maxSize, 
									}]]
									if pool.gainPerTurn > 0 then
										if eduEntry.upkeepCost > 0 and eduEntry.upkeepCost < EDUOFFET_VARS_LEG.threshold then
											pool.gainPerTurn = pool.gainPerTurn / pooloffset1
										else
											pool.gainPerTurn = pool.gainPerTurn / pooloffset2
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
    defaultEDUOffsetleg_on = true
	defaultEDUOffset_factionleg = eur_player_faction.name
end

EDB_POOL_DEFAULT = {}

function defaultEDUGather()
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."defaultEDUGather");
	end
    for i = 0, 200 do
        local edbEntry = EDB.getBuildingByID(i)
        if edbEntry ~= nil then
            for j = 0, edbEntry.buildingLevelCount -1 do
                local level = edbEntry:getBuildingLevel(j)
                if level ~= nil then
                    for x = 0, level.recruitPoolNum -1 do
                        local pool = level:getRecruitPool(x)
                        if pool ~= nil then
                            local eduEntry=M2TWEOPDU.getEduEntry(pool.unitID);
                            if eduEntry ~= nil then
                                if eduEntry:hasOwnership(eur_playerFactionId) then
                                    if not EDB_POOL_DEFAULT[edbEntry.name] then
                                        EDB_POOL_DEFAULT[edbEntry.name] = {}
                                        EDB_POOL_DEFAULT[edbEntry.name].localname = edbEntry.localizedName
                                    end
                                    if not EDB_POOL_DEFAULT[edbEntry.name][j] then
                                        EDB_POOL_DEFAULT[edbEntry.name][j] = {}
                                        EDB_POOL_DEFAULT[edbEntry.name][j][eur_playerFactionId] = {}
                                        EDB_POOL_DEFAULT[edbEntry.name][j][eur_playerFactionId].name = level:getLocalizedName(eur_playerFactionId)
                                        EDB_POOL_DEFAULT[edbEntry.name][j][eur_playerFactionId]["units"] = {}
                                    end
                                    EDB_POOL_DEFAULT[edbEntry.name][j][eur_playerFactionId]["units"][eduEntry.eduType] = {
                                        experience = pool.experience,
                                        eduType = eduEntry.eduType,
                                        recruitCost = eduEntry.recruitCost,
                                        upkeepCost = eduEntry.upkeepCost,
                                        unitCardTga = eduEntry.unitCardTga,
                                        initialSize = pool.initialSize,
                                        gainPerTurn = pool.gainPerTurn,
                                        maxSize = pool.maxSize, 
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local faction_list = {
	"aztecs",
	"byzantium",
	"denmark",
	"england",
	"france",
	"gundabad",
	"hre",
	"hungary",
	"ireland",
	"khand",
	"milan",
	"mongols",
	"moors",
	"normans",
	"norway",
	"poland",
	"portugal",
	"russia",
	"saxons",
	"scotland",
	"sicily",
	"spain",
	"teutonic_order",
	"timurids",
	"turks",
	"venice",
}

diplo_removed = false

function setDiplomacyBulk(player_only, choice)
	local diplo_stance = dipRelType.war
	if choice == 1 then
		diplo_stance = dipRelType.peace
	else
		if not diplo_removed then
			disableDiplomats()
		end
	end
	if player_only then
		for i = 1, #faction_list do
			local fac1 = eur_player_faction
			local fac2 = eur_campaign:getFaction(faction_list[i])
			local stance = eur_campaign:checkDipStance(diplo_stance, fac1, fac2)
			if not stance then
				eur_campaign:setDipStance(diplo_stance, fac1, fac2)
			end
		end
	else
		for i = 1, #faction_list do
			for j = i + 1, #faction_list do
				local fac1 = eur_campaign:getFaction(faction_list[i])
				local fac2 = eur_campaign:getFaction(faction_list[j])
				local stance = eur_campaign:checkDipStance(diplo_stance, fac1, fac2)
				if not stance then
					eur_campaign:setDipStance(diplo_stance, fac1, fac2)
				end
			end
		end
	end
end

function disableDiplomats()
	for i = 1, #faction_list do
		local faction = eur_campaign:getFaction(faction_list[i])
		if faction ~= nil then
			for j = 0, faction.numOfCharacters - 1 do
				local char = faction:getCharacter(j)
				if char ~= nil then
					if char.characterType == 2 then
						char:kill()
					end
				end
			end
		end
	end
	for i = 0, 200 do
        local edbEntry = EDB.getBuildingByID(i)
        if edbEntry ~= nil then
            for j = 0, edbEntry.buildingLevelCount -1 do
                local level = edbEntry:getBuildingLevel(j)
                if level ~= nil then
                    for x = 0, level.recruitPoolNum -1 do
                        local pool = level:getRecruitPool(x)
                        if pool ~= nil then
							if pool.agentType == 2 then
								pool.maxSize = 0
								pool.initialSize = 0
							end
						end
					end
				end
			end
		end
	end
	diplo_removed = true
end

function getEOPModifiers()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."setEOPModifiers");
	end
	local campaignDiff1    = M2TWEOP.getCampaignDifficulty1()
	local campaignDiff2    = M2TWEOP.getCampaignDifficulty2()
	local EopAiConfig = M2TWEOP.getEopAiConfig()

		modifier_config.enabled = EopAiConfig.enabled
		modifier_config.aggressionFactor = EopAiConfig.aggressionFactor
		if M2TWEOP.getOptions2().campaignDifficulty == 3 then 
			modifier_config.aggressionFactor = 1.3
		else
			modifier_config.aggressionFactor = 1.25
		end
		modifier_config.nonBorderFactor = EopAiConfig.nonBorderFactor
		--
		modifier_config.nonBorderFactor = 0.05
		modifier_config.forceNavalInvasions = true
		--[[
		modifier_config.defenseFactor = EopAiConfig.defenseFactor
		modifier_config.residenceFactor = EopAiConfig.residenceFactor
		modifier_config.aidFactor = EopAiConfig.aidFactor
		modifier_config.moveCostFactor = EopAiConfig.moveCostFactor
		modifier_config.powerFactor = EopAiConfig.powerFactor
		modifier_config.invadePriorityFactor = EopAiConfig.invadePriorityFactor
	
		modifier_config.incomeModifierAi = campaignDiff1.incomeModifierAi
		modifier_config.incomeBonusAi = campaignDiff2.incomeBonusAi
		modifier_config.orderFromGrowth = campaignDiff1.orderFromGrowth
		modifier_config.aiHireMercenaries = campaignDiff1.aiHireMercenaries
		modifier_config.popGrowthBonusAi = campaignDiff2.popGrowthBonusAi
		modifier_config.publicOrderBonusAi = campaignDiff2.publicOrderBonusAi
		modifier_config.brigandChanceAi = campaignDiff1.brigandChanceAi
		modifier_config.experienceBonusAi = campaignDiff2.experienceBonusAi
		modifier_config.dontAttackAiDefenders = campaignDiff2.dontAttackAiDefenders
		--modifier_config.forceNavalInvasions = campaignDiff2.forceNavalInvasions
		modifier_config.brigandControllerTargetSettlements = campaignDiff2.brigandControllerTargetSettlements
	
		modifier_config.farmingIncomeModifierPlayer = campaignDiff1.farmingIncomeModifierPlayer
		modifier_config.taxIncomeModifierPlayer = campaignDiff1.taxIncomeModifierPlayer
		modifier_config.maxPlayerPeaceTurns = campaignDiff1.maxPlayerPeaceTurns
		modifier_config.brigandChancePlayer = campaignDiff1.brigandChancePlayer
		modifier_config.playerRegionValueModifier = campaignDiff1.playerRegionValueModifier
]]
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function setEOPModifiers()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."setEOPModifiers");
	end

	local campaignDiff1    = M2TWEOP.getCampaignDifficulty1()
	local campaignDiff2    = M2TWEOP.getCampaignDifficulty2()
	local EopAiConfig = M2TWEOP.getEopAiConfig()

		EopAiConfig.enabled = modifier_config.enabled
		EopAiConfig.aggressionFactor = modifier_config.aggressionFactor
		EopAiConfig.nonBorderFactor = modifier_config.nonBorderFactor
		campaignDiff2.forceNavalInvasions = modifier_config.forceNavalInvasions
		--[[
		EopAiConfig.defenseFactor = modifier_config.defenseFactor
		EopAiConfig.residenceFactor = modifier_config.residenceFactor
		EopAiConfig.aidFactor = modifier_config.aidFactor
		EopAiConfig.moveCostFactor = modifier_config.moveCostFactor
		EopAiConfig.powerFactor = modifier_config.powerFactor
		EopAiConfig.invadePriorityFactor = modifier_config.invadePriorityFactor

	
		campaignDiff1.incomeModifierAi = modifier_config.incomeModifierAi
		campaignDiff2.incomeBonusAi = modifier_config.incomeBonusAi
		campaignDiff1.orderFromGrowth = modifier_config.orderFromGrowth
		campaignDiff1.aiHireMercenaries = modifier_config.aiHireMercenaries
		campaignDiff2.popGrowthBonusAi = modifier_config.popGrowthBonusAi
		campaignDiff2.publicOrderBonusAi = modifier_config.publicOrderBonusAi
		campaignDiff1.brigandChanceAi = modifier_config.brigandChanceAi
		campaignDiff2.experienceBonusAi = modifier_config.experience_bexperienceBonusAionus_ai
		campaignDiff2.dontAttackAiDefenders = modifier_config.dontAttackAiDefenders
		campaignDiff2.brigandControllerTargetSettlements = modifier_config.brigandControllerTargetSettlements
		
		campaignDiff1.farmingIncomeModifierPlayer = modifier_config.farmingIncomeModifierPlayer
		campaignDiff1.taxIncomeModifierPlayer = modifier_config.taxIncomeModifierPlayer
		campaignDiff1.maxPlayerPeaceTurns = modifier_config.maxPlayerPeaceTurns
		campaignDiff1.brigandChancePlayer = modifier_config.brigandChancePlayer
		campaignDiff1.playerRegionValueModifier = modifier_config.playerRegionValueModifier
		]]

	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function economyModifiers()
	if ecomod_added then return end
	local options = M2TWEOP.getOptions2();
	local difficulty = options.campaignDifficulty*10
	local addition = 0
	addition = math.ceil(120-(difficulty*4))
	if addition > 0 then
		local building = EDB.getBuildingByName("hinterland_farms")
		for j = 0, building.buildingLevelCount - 1 do
			bu = building:getBuildingLevel(j)
			bu:addCapability(buildingCapability.income_bonus, (addition*(j+1)), true, "factions { all, }")
		end
	end
	ecomod_added = true
 end
 
 function legendaryToggle(bool)
	if bool then
		options_legendary = true
		options_hardcore = true
		options_no_free_upkeep = true
		game_options.options_aiboost = true
		game_options.order_offset = true
	else
		options_hardcore = false
		options_no_free_upkeep = false
		game_options.options_aiboost = false
		game_options.order_offset = false
	end
end

globalmoraleset = false

function globalMoraleIncrease(value)
	if globalmoraleset then return end
    for i = 0, 1500 do
        local eduEntry = M2TWEOPDU.getEduEntry(i)
        if eduEntry ~= nil then
			eduEntry.morale = eduEntry.morale+value
		end
	end
	globalmoraleset = true
end
