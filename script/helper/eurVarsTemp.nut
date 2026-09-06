::EUR.in_campaign_map <- false   // non-persistent: are we on the campaign map
::EUR.img_x <- 80
::EUR.img_y <- 80
::EUR.eur_campaign <- null
::EUR.eur_sMap <- null
::EUR.eur_numberOfFactions <- 0
::EUR.eur_playerFactionId <- 0
::EUR.eur_player_faction <- null
::EUR.eur_campaign_options <- null
::EUR.eur_localculture <- null
::EUR.eur_localFactionName <- null
::EUR.eur_turn_number <- 0
::EUR.loc_set <- false

::EUR.goblin_factions <- [
    "gundabad",
    "england",
    "hre",
    "normans",
    "poland",
]

::EUR.men_factions <- [
    "turks",
    "sicily",
    "milan",
    "scotland",
    "byzantium",
    "harad",
    "russia",
    "khand",
    "spain",
    "teutonic_order",
    "timurids",
    "aztecs",
]

::EUR.campaign_diff_text <- ["Easy", "Medium", "Hard", "Very hard", "Legendary"]   // was [0]..[4]
::EUR.battlediff_text <- ["Easy", "Medium", "Hard", "Very hard"]                    // was [0]..[3]

::EUR.show_leg_notif <- false
::EUR.defaultEDUOffset_faction <- ""

::EUR.curr_faction <- ""

::EUR.show_ug_accept <- false
::EUR.replen_totals <- 0
::EUR.replenished_over_turn <- false
::EUR.options_replen_costs <- false
::EUR.show_adv_replen <- true
::EUR.hud_show_units_tab_pressed <- false
::EUR.show_replen_ui <- false
::EUR.show_kon_choice <- false
::EUR.show_eregion_choice <- false
::EUR.hud_show_agents_tab <- false
::EUR.temp_fort_char <- null
::EUR.setts_player_expansion <- false

::EUR.cutdown_setts <- true
::EUR.add_setts <- false
::EUR.editTrait_on <- false
::EUR.orderOffset_on <- false
::EUR.defaultEDUOffset_on <- false
::EUR.defaultEDUOffsetSetts_on <- false
::EUR.ecomod_added <- false

::EUR.temp_units <- {}
::EUR.temp_unit_nu <- 0
::EUR.player_units <- {}
::EUR.player_units_local <- {}

::EUR.char_unlocks <- {}

::EUR.font_choice <- 2

::EUR.persistent_gen_list <- {}
::EUR.persistent_gen_list_reset <- {}

::EUR.change_faction <- false
::EUR.pause_disband <- false

::EUR.show_revive_choice <- false

::EUR.eur_tga_table <- {}

::EUR.sort_order <- { a = 5, b = 0, c = 3 }

::EUR.upgradeWindowAlways <- false

::EUR.eur_already_saved <- false

::EUR.total_spoils_loot <- 0
::EUR.battles_lost <- 0
::EUR.losses_upkeep <- 0
::EUR.total_losses_upkeep <- 0

::EUR.poe_end_condition <- false

::EUR.eurEventsData <- {}

::EUR.UNIT_ORIGINAL <- {}

::EUR.eur_turn_number <- 0

::EUR.ai_config_nbf <- 0
::EUR.ai_config_af <- 0

::EUR.eurTilecheck <- false

::EUR.fact_inner_colour <- {
    turks = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    milan = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    sicily = { r = 0.75, g = 0.76, b = 0.78, a = 1.0 },
    russia = { r = 0.76, g = 0.68, b = 0.55, a = 1.0 },
    scotland = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    byzantium = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    timurids = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    portugal = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    aztecs = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    teutonic_order = { r = 0.82, g = 0.73, b = 0.58, a = 1.0 },
    spain = { r = 0.76, g = 0.68, b = 0.55, a = 1.0 },
    khand = { r = 0.76, g = 0.68, b = 0.55, a = 1.0 },
    venice = { r = 0.76, g = 0.68, b = 0.55, a = 1.0 },
    norway = { r = 0.73, g = 0.74, b = 0.76, a = 1.0 },
    hungary = { r = 0.73, g = 0.74, b = 0.76, a = 1.0 },
    moors = { r = 0.73, g = 0.74, b = 0.76, a = 1.0 },
    mongols = { r = 0.80, g = 0.72, b = 0.58, a = 1.0 },
    ireland = { r = 0.80, g = 0.72, b = 0.58, a = 1.0 },
    denmark = { r = 0.80, g = 0.72, b = 0.58, a = 1.0 },
    england = { r = 0.75, g = 0.70, b = 0.59, a = 1.0 },
    poland = { r = 0.75, g = 0.70, b = 0.59, a = 1.0 },
    hre = { r = 0.75, g = 0.70, b = 0.59, a = 1.0 },
    gundabad = { r = 0.75, g = 0.70, b = 0.59, a = 1.0 },
    france = { r = 0.75, g = 0.70, b = 0.59, a = 1.0 },
    saxons = { r = 0.80, g = 0.72, b = 0.58, a = 1.0 },
    papal_states = { r = 0.80, g = 0.72, b = 0.58, a = 1.0 },
    egypt = { r = 0.80, g = 0.72, b = 0.58, a = 1.0 },
    normans = { r = 0.75, g = 0.70, b = 0.59, a = 1.0 },
}

::EUR.FACTION_COLOURS <- {
    saxons = {
        primaryColorRed = 100,
        primaryColorGreen = 100,
        primaryColorBlue = 100,
        secondaryColorRed = 100,
        secondaryColorGreen = 100,
        secondaryColorBlue = 100,
        standardIndex = 8,
        logoIndex = 185,
        smallLogoIndex = 205,
    },
}

::EUR.text_colour <- {
    r = 0.1,
    g = 0.1,
    b = 0.1,
    a = 1,
}

::EUR.gen_set <- false

::EUR.custom_cas <- {
    tauriel = false,
    galadriel = false,
    sharku = false,
    noldor_general = false,
    noldor_captain = false,
}

::EUR.show_unitscroll_tooltip <- false
::EUR.EDUDescSet <- false

::EUR.faction_id_list <- {
    hungary = 11,
    denmark = 25,
    milan = 7,
    normans = 6,
    turks = 2,
    scotland = 8,
    timurids = 9,
    byzantium = 27,
    moors = 10,
    sicily = 1,
    norway = 12,
    saxons = 22,
    ireland = 26,
    mongols = 24,
    teutonic_order = 4,
    venice = 15,
    england = 16,
    poland = 17,
    france = 19,
    aztecs = 5,
    hre = 18,
    gundabad = 20,
    portugal = 21,
    spain = 13,
    khand = 14,
    russia = 3,
    papal_states = 28,
    scripts = 0,
    united = 29,
    slave = 30,
}

::EUR.faction_bg_name_list <- {
    hungary = { t1 = "Militia", t2 = "Army", t3 = "Guard" },
    denmark = { t1 = "Sentries", t2 = "Veterans", t3 = "Eldar" },
    milan = { t1 = "Fyrd", t2 = "Muster", t3 = "Eored" },
    normans = { t1 = "Rabble", t2 = "Warband", t3 = "Black Guard" },
    turks = { t1 = "Recruits", t2 = "Rangers", t3 = "Elite" },
    scotland = { t1 = "Militia", t2 = "Professional", t3 = "Elite" },
    timurids = { t1 = "Woodsmen", t2 = "Warriors", t3 = "Guardian" },
    byzantium = { t1 = "Militia", t2 = "Professional", t3 = "Elite" },
    moors = { t1 = "Levies", t2 = "Army", t3 = "Guard" },
    sicily = { t1 = "Militia", t2 = "Professional", t3 = "Elite" },
    norway = { t1 = "Levies", t2 = "Army", t3 = "Guard" },
    saxons = { t1 = "Sentries", t2 = "Veterans", t3 = "Eldar" },
    ireland = { t1 = "Sentries", t2 = "Veterans", t3 = "Eldar" },
    mongols = { t1 = "Sentries", t2 = "Veterans", t3 = "Eldar" },
    teutonic_order = { t1 = "Clansmen", t2 = "Heralds", t3 = "Elders" },
    venice = { t1 = "Tribesmen", t2 = "Warriors", t3 = "Warlords" },
    england = { t1 = "Rabble", t2 = "Warband", t3 = "Black Guard" },
    poland = { t1 = "Rabble", t2 = "Warband", t3 = "Black Guard" },
    france = { t1 = "Raiders", t2 = "Uruk", t3 = "White Hand" },
    aztecs = { t1 = "Wildmen", t2 = "Warband", t3 = "Wulfguard" },
    hre = { t1 = "Rabble", t2 = "Warband", t3 = "Black Guard" },
    gundabad = { t1 = "Snow Orcs", t2 = "Mountain Orcs", t3 = "Champions" },
    portugal = { t1 = "Angmarim", t2 = "Iron Crown", t3 = "Fellhost" },
    spain = { t1 = "Tribesmen", t2 = "Warriors", t3 = "Warlords" },
    khand = { t1 = "Tribesmen", t2 = "Warriors", t3 = "Warlords" },
    russia = { t1 = "Footmen", t2 = "Legion", t3 = "Naru n'Aru" },
    papal_states = { t1 = "Militia", t2 = "Professional", t3 = "Elite" },
    scripts = { t1 = "Militia", t2 = "Professional", t3 = "Elite" },
    united = { t1 = "Militia", t2 = "Professional", t3 = "Elite" },
    slave = { t1 = "Militia", t2 = "Professional", t3 = "Elite" },
    egypt = { t1 = "Sentries", t2 = "Veterans", t3 = "Eldar" },
}

::EUR.left_panels <- [
    "combined_listview_scroll",
    "combined_scroll_agents_tab",
    "combined_scroll_armies_tab",
    "combined_scroll_settlements_tab",
    "faction_ranking_scroll",
    "family_tree_scroll",
    "advanced_settlement_info_scroll",
    "trade_summary_scroll",
    "building_info_scroll",
    "unit_info_scroll",
    "agent_info_scroll",
]

::EUR.defaultEDUOffsetleg_on <- false
::EUR.defaultEDUOffset_factionleg <- null

::EUR.elven_faction <- false

::EUR.ship_1_added <- false
::EUR.ship_2_added <- false
::EUR.ship_3_added <- false
::EUR.ship_4_added <- false
::EUR.king_1_added <- false
::EUR.king_2_added <- false
::EUR.king_3_added <- false
::EUR.stew_1_added <- false
::EUR.stew_2_added <- false
::EUR.stew_3_added <- false

::EUR.show_options_button <- false
::EUR.show_events_window <- false
::EUR.show_options_accept <- false

::EUR.show_settUI <- false


::EUR.traits_temp <- {}

::EUR.font_list <- {}
::EUR.font_list_names <- {}
::EUR.alt_loot_units <- {}
::EUR.alt_loot_anc <- {}
::EUR.alt_loot_player_gen <- {}
::EUR.alt_loot_enemy_gen <- {}

::EUR.alt_loot <- false

::EUR.alt_loot_remove_stuff <- [null, null, false]   // was {}; [0]=nil, [1]=nil, [2]=false

::EUR.window_states <- {
    swap_bg_window = false,
    show_upgrade_window = false,
    show_globalrecruit_window = false,
}
::EUR.left_windows <- {}
::EUR.show_genenabled <- false
::EUR.temp_char_stuff <- null
::EUR.show_temp_char_stuff <- false

::EUR.temp_player_army <- null
::EUR.temp_temp_player_army_target <- 0
::EUR.temp_value <- 20
::EUR.eur_pre_battle <- false
::EUR.eur_pre_battle_window <- false
::EUR.show_alt_loot <- false

::EUR.dorwinion_bg_check <- false
::EUR.kon_bg_check <- false
