::EUR.default_settings <- {}

::EUR.saveDefaultSettings <- function() {
    ::EUR.default_settings = {
        watchtower_range = ::EUR.watchtower_range,
        //options_general_large_army = options_general_large_army,
        options_replen_costs = ::EUR.options_replen_costs,
        replen_cost_multi = ::EUR.replen_cost_multi,
        restricted_upgrades = ::EUR.restricted_upgrades,
        ai_unit_upgrades = ::EUR.ai_unit_upgrades,
        replen_values = ::EUR.replen_values,
        bg_t2_rank = ::EUR.bg_t2_rank,
        bg_t3_rank = ::EUR.bg_t3_rank,
        show_gen_unit_card = ::EUR.show_gen_unit_card,
        set_mods = ::EUR.set_mods,
        personal_guard_limit = ::EUR.personal_guard_limit,
        modifier_config = ::EUR.modifier_config,
        waystation_bonus = ::EUR.waystation_bonus,
        options_evolvingnames = ::EUR.options_evolvingnames,
        options_extrabu = ::EUR.options_extrabu,
        EDUOFFET_SETT_VARS = ::EUR.EDUOFFET_SETT_VARS,
        EDUOFFET_VARS = ::EUR.EDUOFFET_VARS,
        EDUOFFET_VARS_LEG = ::EUR.EDUOFFET_VARS_LEG,
        options_no_free_upkeep = ::EUR.options_no_free_upkeep,
        build_forts = ::EUR.build_forts,
        //options_legendary = options_legendary,
        bg_min_size_multi = ::EUR.bg_min_size_multi,
        merge_turn_multi = ::EUR.merge_turn_multi,
        bg_swap_cooldown = ::EUR.bg_swap_cooldown,
        //options_hardcore = options_hardcore,
        options_gen_upgrades = ::EUR.options_gen_upgrades,
        options_gen_bg_size = ::EUR.options_gen_bg_size,
        replen_always = ::EUR.replen_always,
        options_unit_upgrades = ::EUR.options_unit_upgrades,
        options_addspoils = ::EUR.options_addspoils,
        options_replen_beast = ::EUR.options_replen_beast,
        replen_randmax = ::EUR.replen_randmax,
        replen_multi = ::EUR.replen_multi,
        replen_beast_value = ::EUR.replen_beast_value,
        options_replen = ::EUR.options_replen,
        options_merge = ::EUR.options_merge,
        options_sort = ::EUR.options_sort,
        sort_order = ::EUR.sort_order,
        replen_bonus = ::EUR.replen_bonus,
    }
    ::EUR.default_settings.game_options <- {}
    foreach (key, value in ::EUR.game_options) {
        ::EUR.default_settings.game_options[key] <- value
    }
}

::EUR.restoreDefaultSettings <- function() {
    if ("watchtower_range" in ::EUR.default_settings) ::EUR.watchtower_range = ::EUR.default_settings.watchtower_range
    //if ("options_general_large_army" in default_settings) options_general_large_army = default_settings.options_general_large_army
    if ("options_replen_costs" in ::EUR.default_settings) ::EUR.options_replen_costs = ::EUR.default_settings.options_replen_costs
    if ("replen_cost_multi" in ::EUR.default_settings) ::EUR.replen_cost_multi = ::EUR.default_settings.replen_cost_multi
    if ("restricted_upgrades" in ::EUR.default_settings) ::EUR.restricted_upgrades = ::EUR.default_settings.restricted_upgrades
    if ("ai_unit_upgrades" in ::EUR.default_settings) ::EUR.ai_unit_upgrades = ::EUR.default_settings.ai_unit_upgrades
    if ("replen_values" in ::EUR.default_settings) ::EUR.replen_values = ::EUR.default_settings.replen_values
    if ("bg_t2_rank" in ::EUR.default_settings) ::EUR.bg_t2_rank = ::EUR.default_settings.bg_t2_rank
    if ("bg_t3_rank" in ::EUR.default_settings) ::EUR.bg_t3_rank = ::EUR.default_settings.bg_t3_rank
    if ("show_gen_unit_card" in ::EUR.default_settings) ::EUR.show_gen_unit_card = ::EUR.default_settings.show_gen_unit_card
    if ("set_mods" in ::EUR.default_settings) ::EUR.set_mods = ::EUR.default_settings.set_mods
    if ("personal_guard_limit" in ::EUR.default_settings) ::EUR.personal_guard_limit = ::EUR.default_settings.personal_guard_limit
    if ("modifier_config" in ::EUR.default_settings) ::EUR.modifier_config = ::EUR.default_settings.modifier_config
    if ("waystation_bonus" in ::EUR.default_settings) ::EUR.waystation_bonus = ::EUR.default_settings.waystation_bonus
    if ("options_evolvingnames" in ::EUR.default_settings) ::EUR.options_evolvingnames = ::EUR.default_settings.options_evolvingnames
    if ("options_extrabu" in ::EUR.default_settings) ::EUR.options_extrabu = ::EUR.default_settings.options_extrabu
    if ("EDUOFFET_SETT_VARS" in ::EUR.default_settings) ::EUR.EDUOFFET_SETT_VARS = ::EUR.default_settings.EDUOFFET_SETT_VARS
    if ("EDUOFFET_VARS" in ::EUR.default_settings) ::EUR.EDUOFFET_VARS = ::EUR.default_settings.EDUOFFET_VARS
    if ("EDUOFFET_VARS_LEG" in ::EUR.default_settings) ::EUR.EDUOFFET_VARS_LEG = ::EUR.default_settings.EDUOFFET_VARS_LEG
    if ("options_no_free_upkeep" in ::EUR.default_settings) ::EUR.options_no_free_upkeep = ::EUR.default_settings.options_no_free_upkeep
    if ("build_forts" in ::EUR.default_settings) ::EUR.build_forts = ::EUR.default_settings.build_forts
    //if ("options_legendary" in default_settings) options_legendary = default_settings.options_legendary
    if ("bg_min_size_multi" in ::EUR.default_settings) ::EUR.bg_min_size_multi = ::EUR.default_settings.bg_min_size_multi
    if ("merge_turn_multi" in ::EUR.default_settings) ::EUR.merge_turn_multi = ::EUR.default_settings.merge_turn_multi
    if ("bg_swap_cooldown" in ::EUR.default_settings) ::EUR.bg_swap_cooldown = ::EUR.default_settings.bg_swap_cooldown
    //if ("options_hardcore" in default_settings) options_hardcore = default_settings.options_hardcore
    if ("options_gen_upgrades" in ::EUR.default_settings) ::EUR.options_gen_upgrades = ::EUR.default_settings.options_gen_upgrades
    if ("options_gen_bg_size" in ::EUR.default_settings) ::EUR.options_gen_bg_size = ::EUR.default_settings.options_gen_bg_size
    if ("replen_always" in ::EUR.default_settings) ::EUR.replen_always = ::EUR.default_settings.replen_always
    if ("options_unit_upgrades" in ::EUR.default_settings) ::EUR.options_unit_upgrades = ::EUR.default_settings.options_unit_upgrades
    if ("options_addspoils" in ::EUR.default_settings) ::EUR.options_addspoils = ::EUR.default_settings.options_addspoils
    if ("options_replen_beast" in ::EUR.default_settings) ::EUR.options_replen_beast = ::EUR.default_settings.options_replen_beast
    if ("replen_randmax" in ::EUR.default_settings) ::EUR.replen_randmax = ::EUR.default_settings.replen_randmax
    if ("replen_multi" in ::EUR.default_settings) ::EUR.replen_multi = ::EUR.default_settings.replen_multi
    if ("replen_beast_value" in ::EUR.default_settings) ::EUR.replen_beast_value = ::EUR.default_settings.replen_beast_value
    if ("options_replen" in ::EUR.default_settings) ::EUR.options_replen = ::EUR.default_settings.options_replen
    if ("options_merge" in ::EUR.default_settings) ::EUR.options_merge = ::EUR.default_settings.options_merge
    if ("options_sort" in ::EUR.default_settings) ::EUR.options_sort = ::EUR.default_settings.options_sort
    if ("sort_order" in ::EUR.default_settings) ::EUR.sort_order = ::EUR.default_settings.sort_order
    if ("replen_bonus" in ::EUR.default_settings) ::EUR.replen_bonus = ::EUR.default_settings.replen_bonus
    if ("game_options" in ::EUR.default_settings) {
        foreach (key, value in ::EUR.default_settings.game_options) {
            ::EUR.game_options[key] = value
        }
    }
}
