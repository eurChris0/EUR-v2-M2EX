local optionsFileName = "\\eur_options.dat"

::EUR.saveOptions <- function() {
    local io = require("io")
    local filename = ::game.modPath() + optionsFileName
    local vars = {
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
        game_options = ::EUR.game_options,
    }
    try {
        local f = io.file(filename, "wb")
        f.writeobject(vars)
        f.close()
    } catch (e) {
        println("eur: saveOptions failed: " + e)
    }
}

::EUR.loadOptions <- function() {
    local io = require("io")
    local filename = ::game.modPath() + optionsFileName
    local data = null
    try {
        local f = io.file(filename, "rb")   // throws if the file does not exist (first run)
        data = f.readobject()
        f.close()
    } catch (e) {
        return
    }
    if (data == null) return

    if ("watchtower_range" in data) ::EUR.watchtower_range = data.watchtower_range
    //if ("options_general_large_army" in data) options_general_large_army = data.options_general_large_army
    if ("options_replen_costs" in data) ::EUR.options_replen_costs = data.options_replen_costs
    if ("replen_cost_multi" in data) ::EUR.replen_cost_multi = data.replen_cost_multi
    if ("restricted_upgrades" in data) ::EUR.restricted_upgrades = data.restricted_upgrades
    if ("ai_unit_upgrades" in data) ::EUR.ai_unit_upgrades = data.ai_unit_upgrades
    if ("replen_values" in data) ::EUR.replen_values = data.replen_values
    if ("bg_t2_rank" in data) ::EUR.bg_t2_rank = data.bg_t2_rank
    if ("bg_t3_rank" in data) ::EUR.bg_t3_rank = data.bg_t3_rank
    if ("show_gen_unit_card" in data) ::EUR.show_gen_unit_card = data.show_gen_unit_card
    if ("set_mods" in data) ::EUR.set_mods = data.set_mods
    if ("personal_guard_limit" in data) ::EUR.personal_guard_limit = data.personal_guard_limit
    if ("modifier_config" in data) ::EUR.modifier_config = data.modifier_config
    if ("waystation_bonus" in data) ::EUR.waystation_bonus = data.waystation_bonus
    if ("options_evolvingnames" in data) ::EUR.options_evolvingnames = data.options_evolvingnames
    if ("options_extrabu" in data) ::EUR.options_extrabu = data.options_extrabu
    if ("EDUOFFET_SETT_VARS" in data) ::EUR.EDUOFFET_SETT_VARS = data.EDUOFFET_SETT_VARS
    if ("EDUOFFET_VARS" in data) ::EUR.EDUOFFET_VARS = data.EDUOFFET_VARS
    if ("EDUOFFET_VARS_LEG" in data) ::EUR.EDUOFFET_VARS_LEG = data.EDUOFFET_VARS_LEG
    if ("options_no_free_upkeep" in data) ::EUR.options_no_free_upkeep = data.options_no_free_upkeep
    if ("build_forts" in data) ::EUR.build_forts = data.build_forts
    //if ("options_legendary" in data) options_legendary = data.options_legendary
    if ("bg_min_size_multi" in data) ::EUR.bg_min_size_multi = data.bg_min_size_multi
    if ("merge_turn_multi" in data) ::EUR.merge_turn_multi = data.merge_turn_multi
    if ("bg_swap_cooldown" in data) ::EUR.bg_swap_cooldown = data.bg_swap_cooldown
    //if ("options_hardcore" in data) options_hardcore = data.options_hardcore
    if ("options_gen_upgrades" in data) ::EUR.options_gen_upgrades = data.options_gen_upgrades
    if ("options_gen_bg_size" in data) ::EUR.options_gen_bg_size = data.options_gen_bg_size
    if ("replen_always" in data) ::EUR.replen_always = data.replen_always
    if ("options_unit_upgrades" in data) ::EUR.options_unit_upgrades = data.options_unit_upgrades
    if ("options_addspoils" in data) ::EUR.options_addspoils = data.options_addspoils
    if ("options_replen_beast" in data) ::EUR.options_replen_beast = data.options_replen_beast
    if ("replen_randmax" in data) ::EUR.replen_randmax = data.replen_randmax
    if ("replen_multi" in data) ::EUR.replen_multi = data.replen_multi
    if ("replen_beast_value" in data) ::EUR.replen_beast_value = data.replen_beast_value
    if ("options_replen" in data) ::EUR.options_replen = data.options_replen
    if ("options_merge" in data) ::EUR.options_merge = data.options_merge
    if ("options_sort" in data) ::EUR.options_sort = data.options_sort
    if ("sort_order" in data) ::EUR.sort_order = data.sort_order
    if ("replen_bonus" in data) ::EUR.replen_bonus = data.replen_bonus
    if ("game_options" in data) {
        foreach (key, value in data.game_options) {
            ::EUR.game_options[key] = value
        }
    }
}
