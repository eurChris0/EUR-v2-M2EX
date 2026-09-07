local BANNERS = [
    "banner_symbol_aztecs.tga",
    "banner_symbol_barb_rebel.tga",
    "banner_symbol_byzantium.tga",
    "banner_symbol_denmark.tga",
    "banner_symbol_egypt.tga",
    "banner_symbol_england.tga",
    "banner_symbol_ents.tga",
    "banner_symbol_france.tga",
    "banner_symbol_gundabad.tga",
    "banner_symbol_holy_roman_empire.tga",
    "banner_symbol_hungary.tga",
    "banner_symbol_ireland.tga",
    "banner_symbol_khand.tga",
    "banner_symbol_milan.tga",
    "banner_symbol_mongols.tga",
    "banner_symbol_moors.tga",
    "banner_symbol_normans.tga",
    "banner_symbol_norway.tga",
    "banner_symbol_papacy.tga",
    "banner_symbol_poland.tga",
    "banner_symbol_portugal.tga",
    "#banner_symbol_rebels.tga",
    "banner_symbol_russia.tga",
    "banner_symbol_saxons.tga",
    "banner_symbol_scotland.tga",
    "banner_symbol_sicily.tga",
    "banner_symbol_spain.tga",
    "banner_symbol_teutonic.tga",
    "banner_symbol_timurids.tga",
    "banner_symbol_turks.tga",
    "banner_symbol_venice.tga",
]

// rebel faction -> { banner tint r/g/b, symbol texture }
local REBEL_BANNERS = {
    Arthedain_Rebels = { r = 98, g = 79, b = 61, symbol = "banner_symbol_turks.tga" },
    Arulad_Rebels = { r = 103, g = 73, b = 37, symbol = "banner_symbol_rebels.tga" },
    Balchoth_Rebels = { r = 101, g = 39, b = 35, symbol = "banner_symbol_rebels.tga" },
    Bandit_Rebels = { r = 30, g = 37, b = 103, symbol = "banner_symbol_rebels.tga" },
    Baruun_Rebels = { r = 73, g = 82, b = 50, symbol = "banner_symbol_rebels.tga" },
    Beorning_Rebels = { r = 79, g = 34, b = 82, symbol = "banner_symbol_timurids.tga" },
    Breeland_Rebels = { r = 111, g = 70, b = 125, symbol = "banner_symbol_normans.tga" },
    Cardolan_Rebels = { r = 112, g = 77, b = 66, symbol = "banner_symbol_turks.tga" },
    Dorwinion_Rebels = { r = 45, g = 95, b = 112, symbol = "banner_symbol_byzantium.tga" },
    Dunland_Rebels = { r = 111, g = 64, b = 129, symbol = "banner_symbol_aztecs.tga" },
    Dwarven_Erebor_Rebels = { r = 53, g = 34, b = 71, symbol = "banner_symbol_moors.tga" },
    Dwarven_EredLuin_Rebels = { r = 55, g = 65, b = 84, symbol = "banner_symbol_hungary.tga" },
    Elven_Imladris_Rebels = { r = 124, g = 35, b = 79, symbol = "banner_symbol_saxons.tga" },
    Elven_Lindon_Rebels = { r = 61, g = 115, b = 122, symbol = "banner_symbol_denmark.tga" },
    Elven_Lothlorien_Rebels = { r = 96, g = 62, b = 108, symbol = "banner_symbol_ireland.tga" },
    Elven_Thranduil_Rebels = { r = 124, g = 80, b = 85, symbol = "banner_symbol_mongols.tga" },
    Enedwaith_Rebels = { r = 122, g = 46, b = 116, symbol = "banner_symbol_teutonic.tga" },
    Ent_Rebels = { r = 43, g = 78, b = 90, symbol = "banner_symbol_rebels.tga" },
    Evil_Looters = { r = 118, g = 119, b = 49, symbol = "banner_symbol_england.tga" },
    Evil_Rebels = { r = 58, g = 69, b = 108, symbol = "banner_symbol_england.tga" },
    Gondor_Rebels = { r = 59, g = 109, b = 114, symbol = "banner_symbol_sicily.tga" },
    Haerhun_Rebels = { r = 56, g = 101, b = 78, symbol = "banner_symbol_venice.tga" },
    Harad_Rebels = { r = 30, g = 107, b = 76, symbol = "banner_symbol_spain.tga" },
    Harondor_Rebels = { r = 43, g = 74, b = 45, symbol = "banner_symbol_sicily.tga" },
    Hobbit_Rebels = { r = 130, g = 123, b = 86, symbol = "banner_symbol_rebels.tga" },
    Human_Rebels = { r = 70, g = 98, b = 83, symbol = "banner_symbol_rebels.tga" },
    Ithilien_Rebels = { r = 67, g = 115, b = 95, symbol = "banner_symbol_sicily.tga" },
    Lest_Rebels = { r = 77, g = 58, b = 97, symbol = "banner_symbol_rebels.tga" },
    Mirkwood_Rebels = { r = 114, g = 93, b = 99, symbol = "banner_symbol_poland.tga" },
    No_Rebels = { r = 116, g = 65, b = 81, symbol = "banner_symbol_rebels.tga" },
    Rhovanion_Rebels = { r = 83, g = 78, b = 46, symbol = "banner_symbol_scotland.tga" },
    Rhudaur_Rebels = { r = 108, g = 111, b = 45, symbol = "banner_symbol_portugal.tga" },
    Rhun_Rebels = { r = 64, g = 37, b = 35, symbol = "banner_symbol_venice.tga" },
    Rohan_Rebels = { r = 84, g = 30, b = 51, symbol = "banner_symbol_milan.tga" },
    Saralainn_Rebels = { r = 66, g = 53, b = 33, symbol = "banner_symbol_rebels.tga" },
    Umbar_Rebels = { r = 40, g = 49, b = 122, symbol = "banner_symbol_russia.tga" },
    Varfest_Rebels = { r = 44, g = 119, b = 111, symbol = "banner_symbol_khand.tga" },
    Variag_Rebels = { r = 98, g = 31, b = 130, symbol = "banner_symbol_khand.tga" },
    Wildmen_Rebels = { r = 43, g = 47, b = 80, symbol = "banner_symbol_rebels.tga" },
}

::EUR.setCols <- function() {
    ::EUR.logHelper("setCols")
    local fullPath = ::game.modPath()
    local modsStart = fullPath.indexof("mods\\")
    if (modsStart != null) {
        local texturePath = ::EUR.string.gsub(fullPath.slice(modsStart), "\\", "/") + "/data/models_strat/textures/#"
        foreach (banner in BANNERS) {
            ::game.models.addBanner(banner, texturePath + banner, 0.0, 0.0, 1.0, 1.0)
        }
    }

    foreach (factionName, cfg in REBEL_BANNERS) {
        local rebel = ::rebels.styleByName(factionName)
        if (rebel == null) continue
        ::rebels.setBannerColour(rebel, cfg.r, cfg.g, cfg.b)
        ::rebels.setBannerEnabled(rebel, true)
        ::rebels.setBannerSymbol(rebel, cfg.symbol)
    }
    ::EUR.logHelper("setCols end")
}
