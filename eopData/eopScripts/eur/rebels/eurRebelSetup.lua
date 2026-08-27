

local BANNERS = {
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
}

function setCols()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."setCols");
	end

    local full_path = M2TWEOP.getModPath()
    local mods_start = full_path:find("mods\\")
    local texture_path = mods_start and full_path:sub(mods_start):gsub("\\", "/") .. "/data/models_strat/textures/#" or nil

    for i = 1, #BANNERS do 
        M2TWEOP.addBanner(BANNERS[i], texture_path..BANNERS[i], 0.0, 0.0, 1, 1)
    end


    local Arthedain_Rebels = M2TWEOP.getRebelFaction("Arthedain_Rebels")
    Arthedain_Rebels.bannerRed = 98
    Arthedain_Rebels.bannerGreen = 79
    Arthedain_Rebels.bannerBlue = 61
    Arthedain_Rebels.bannerSet = true
    Arthedain_Rebels:setBannerSymbol("banner_symbol_turks.tga")
    
    local Arulad_Rebels = M2TWEOP.getRebelFaction("Arulad_Rebels")
    Arulad_Rebels.bannerRed = 103
    Arulad_Rebels.bannerGreen = 73
    Arulad_Rebels.bannerBlue = 37
    Arulad_Rebels.bannerSet = true
    Arulad_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Balchoth_Rebels = M2TWEOP.getRebelFaction("Balchoth_Rebels")
    Balchoth_Rebels.bannerRed = 101
    Balchoth_Rebels.bannerGreen = 39
    Balchoth_Rebels.bannerBlue = 35
    Balchoth_Rebels.bannerSet = true
    Balchoth_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Bandit_Rebels = M2TWEOP.getRebelFaction("Bandit_Rebels")
    Bandit_Rebels.bannerRed = 30
    Bandit_Rebels.bannerGreen = 37
    Bandit_Rebels.bannerBlue = 103
    Bandit_Rebels.bannerSet = true
    Bandit_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Baruun_Rebels = M2TWEOP.getRebelFaction("Baruun_Rebels")
    Baruun_Rebels.bannerRed = 73
    Baruun_Rebels.bannerGreen = 82
    Baruun_Rebels.bannerBlue = 50
    Baruun_Rebels.bannerSet = true
    Baruun_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Beorning_Rebels = M2TWEOP.getRebelFaction("Beorning_Rebels")
    Beorning_Rebels.bannerRed = 79
    Beorning_Rebels.bannerGreen = 34
    Beorning_Rebels.bannerBlue = 82
    Beorning_Rebels.bannerSet = true
    Beorning_Rebels:setBannerSymbol("banner_symbol_timurids.tga")
    
    local Breeland_Rebels = M2TWEOP.getRebelFaction("Breeland_Rebels")
    Breeland_Rebels.bannerRed = 111
    Breeland_Rebels.bannerGreen = 70
    Breeland_Rebels.bannerBlue = 125
    Breeland_Rebels.bannerSet = true
    Breeland_Rebels:setBannerSymbol("banner_symbol_normans.tga")
    
    local Cardolan_Rebels = M2TWEOP.getRebelFaction("Cardolan_Rebels")
    Cardolan_Rebels.bannerRed = 112
    Cardolan_Rebels.bannerGreen = 77
    Cardolan_Rebels.bannerBlue = 66
    Cardolan_Rebels.bannerSet = true
    Cardolan_Rebels:setBannerSymbol("banner_symbol_turks.tga")
    
    local Dorwinion_Rebels = M2TWEOP.getRebelFaction("Dorwinion_Rebels")
    Dorwinion_Rebels.bannerRed = 45
    Dorwinion_Rebels.bannerGreen = 95
    Dorwinion_Rebels.bannerBlue = 112
    Dorwinion_Rebels.bannerSet = true
    Dorwinion_Rebels:setBannerSymbol("banner_symbol_byzantium.tga")
    
    local Dunland_Rebels = M2TWEOP.getRebelFaction("Dunland_Rebels")
    Dunland_Rebels.bannerRed = 111
    Dunland_Rebels.bannerGreen = 64
    Dunland_Rebels.bannerBlue = 129
    Dunland_Rebels.bannerSet = true
    Dunland_Rebels:setBannerSymbol("banner_symbol_aztecs.tga")
    
    local Dwarven_Erebor_Rebels = M2TWEOP.getRebelFaction("Dwarven_Erebor_Rebels")
    Dwarven_Erebor_Rebels.bannerRed = 53
    Dwarven_Erebor_Rebels.bannerGreen = 34
    Dwarven_Erebor_Rebels.bannerBlue = 71
    Dwarven_Erebor_Rebels.bannerSet = true
    Dwarven_Erebor_Rebels:setBannerSymbol("banner_symbol_moors.tga")
    
    local Dwarven_EredLuin_Rebels = M2TWEOP.getRebelFaction("Dwarven_EredLuin_Rebels")
    Dwarven_EredLuin_Rebels.bannerRed = 55
    Dwarven_EredLuin_Rebels.bannerGreen = 65
    Dwarven_EredLuin_Rebels.bannerBlue = 84
    Dwarven_EredLuin_Rebels.bannerSet = true
    Dwarven_EredLuin_Rebels:setBannerSymbol("banner_symbol_hungary.tga")
    
    local Elven_Imladris_Rebels = M2TWEOP.getRebelFaction("Elven_Imladris_Rebels")
    Elven_Imladris_Rebels.bannerRed = 124
    Elven_Imladris_Rebels.bannerGreen = 35
    Elven_Imladris_Rebels.bannerBlue = 79
    Elven_Imladris_Rebels.bannerSet = true
    Elven_Imladris_Rebels:setBannerSymbol("banner_symbol_saxons.tga")
    
    local Elven_Lindon_Rebels = M2TWEOP.getRebelFaction("Elven_Lindon_Rebels")
    Elven_Lindon_Rebels.bannerRed = 61
    Elven_Lindon_Rebels.bannerGreen = 115
    Elven_Lindon_Rebels.bannerBlue = 122
    Elven_Lindon_Rebels.bannerSet = true
    Elven_Lindon_Rebels:setBannerSymbol("banner_symbol_denmark.tga")
    
    local Elven_Lothlorien_Rebels = M2TWEOP.getRebelFaction("Elven_Lothlorien_Rebels")
    Elven_Lothlorien_Rebels.bannerRed = 96
    Elven_Lothlorien_Rebels.bannerGreen = 62
    Elven_Lothlorien_Rebels.bannerBlue = 108
    Elven_Lothlorien_Rebels.bannerSet = true
    Elven_Lothlorien_Rebels:setBannerSymbol("banner_symbol_ireland.tga")
    
    local Elven_Thranduil_Rebels = M2TWEOP.getRebelFaction("Elven_Thranduil_Rebels")
    Elven_Thranduil_Rebels.bannerRed = 124
    Elven_Thranduil_Rebels.bannerGreen = 80
    Elven_Thranduil_Rebels.bannerBlue = 85
    Elven_Thranduil_Rebels.bannerSet = true
    Elven_Thranduil_Rebels:setBannerSymbol("banner_symbol_mongols.tga")
    
    local Enedwaith_Rebels = M2TWEOP.getRebelFaction("Enedwaith_Rebels")
    Enedwaith_Rebels.bannerRed = 122
    Enedwaith_Rebels.bannerGreen = 46
    Enedwaith_Rebels.bannerBlue = 116
    Enedwaith_Rebels.bannerSet = true
    Enedwaith_Rebels:setBannerSymbol("banner_symbol_teutonic.tga")
    
    local Ent_Rebels = M2TWEOP.getRebelFaction("Ent_Rebels")
    Ent_Rebels.bannerRed = 43
    Ent_Rebels.bannerGreen = 78
    Ent_Rebels.bannerBlue = 90
    Ent_Rebels.bannerSet = true
    Ent_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Evil_Looters = M2TWEOP.getRebelFaction("Evil_Looters")
    Evil_Looters.bannerRed = 118
    Evil_Looters.bannerGreen = 119
    Evil_Looters.bannerBlue = 49
    Evil_Looters.bannerSet = true
    Evil_Looters:setBannerSymbol("banner_symbol_england.tga")
    
    local Evil_Rebels = M2TWEOP.getRebelFaction("Evil_Rebels")
    Evil_Rebels.bannerRed = 58
    Evil_Rebels.bannerGreen = 69
    Evil_Rebels.bannerBlue = 108
    Evil_Rebels.bannerSet = true
    Evil_Rebels:setBannerSymbol("banner_symbol_england.tga")
    
    local Gondor_Rebels = M2TWEOP.getRebelFaction("Gondor_Rebels")
    Gondor_Rebels.bannerRed = 59
    Gondor_Rebels.bannerGreen = 109
    Gondor_Rebels.bannerBlue = 114
    Gondor_Rebels.bannerSet = true
    Gondor_Rebels:setBannerSymbol("banner_symbol_sicily.tga")
    
    local Haerhun_Rebels = M2TWEOP.getRebelFaction("Haerhun_Rebels")
    Haerhun_Rebels.bannerRed = 56
    Haerhun_Rebels.bannerGreen = 101
    Haerhun_Rebels.bannerBlue = 78
    Haerhun_Rebels.bannerSet = true
    Haerhun_Rebels:setBannerSymbol("banner_symbol_venice.tga")
    
    local Harad_Rebels = M2TWEOP.getRebelFaction("Harad_Rebels")
    Harad_Rebels.bannerRed = 30
    Harad_Rebels.bannerGreen = 107
    Harad_Rebels.bannerBlue = 76
    Harad_Rebels.bannerSet = true
    Harad_Rebels:setBannerSymbol("banner_symbol_spain.tga")
    
    local Harondor_Rebels = M2TWEOP.getRebelFaction("Harondor_Rebels")
    Harondor_Rebels.bannerRed = 43
    Harondor_Rebels.bannerGreen = 74
    Harondor_Rebels.bannerBlue = 45
    Harondor_Rebels.bannerSet = true
    Harondor_Rebels:setBannerSymbol("banner_symbol_sicily.tga")
    
    local Hobbit_Rebels = M2TWEOP.getRebelFaction("Hobbit_Rebels")
    Hobbit_Rebels.bannerRed = 130
    Hobbit_Rebels.bannerGreen = 123
    Hobbit_Rebels.bannerBlue = 86
    Hobbit_Rebels.bannerSet = true
    Hobbit_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Human_Rebels = M2TWEOP.getRebelFaction("Human_Rebels")
    Human_Rebels.bannerRed = 70
    Human_Rebels.bannerGreen = 98
    Human_Rebels.bannerBlue = 83
    Human_Rebels.bannerSet = true
    Human_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Ithilien_Rebels = M2TWEOP.getRebelFaction("Ithilien_Rebels")
    Ithilien_Rebels.bannerRed = 67
    Ithilien_Rebels.bannerGreen = 115
    Ithilien_Rebels.bannerBlue = 95
    Ithilien_Rebels.bannerSet = true
    Ithilien_Rebels:setBannerSymbol("banner_symbol_sicily.tga")
    
    local Lest_Rebels = M2TWEOP.getRebelFaction("Lest_Rebels")
    Lest_Rebels.bannerRed = 77
    Lest_Rebels.bannerGreen = 58
    Lest_Rebels.bannerBlue = 97
    Lest_Rebels.bannerSet = true
    Lest_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Mirkwood_Rebels = M2TWEOP.getRebelFaction("Mirkwood_Rebels")
    Mirkwood_Rebels.bannerRed = 114
    Mirkwood_Rebels.bannerGreen = 93
    Mirkwood_Rebels.bannerBlue = 99
    Mirkwood_Rebels.bannerSet = true
    Mirkwood_Rebels:setBannerSymbol("banner_symbol_poland.tga")
    
    local No_Rebels = M2TWEOP.getRebelFaction("No_Rebels")
    No_Rebels.bannerRed = 116
    No_Rebels.bannerGreen = 65
    No_Rebels.bannerBlue = 81
    No_Rebels.bannerSet = true
    No_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Rhovanion_Rebels = M2TWEOP.getRebelFaction("Rhovanion_Rebels")
    Rhovanion_Rebels.bannerRed = 83
    Rhovanion_Rebels.bannerGreen = 78
    Rhovanion_Rebels.bannerBlue = 46
    Rhovanion_Rebels.bannerSet = true
    Rhovanion_Rebels:setBannerSymbol("banner_symbol_scotland.tga")
    
    local Rhudaur_Rebels = M2TWEOP.getRebelFaction("Rhudaur_Rebels")
    Rhudaur_Rebels.bannerRed = 108
    Rhudaur_Rebels.bannerGreen = 111
    Rhudaur_Rebels.bannerBlue = 45
    Rhudaur_Rebels.bannerSet = true
    Rhudaur_Rebels:setBannerSymbol("banner_symbol_portugal.tga")
    
    local Rhun_Rebels = M2TWEOP.getRebelFaction("Rhun_Rebels")
    Rhun_Rebels.bannerRed = 64
    Rhun_Rebels.bannerGreen = 37
    Rhun_Rebels.bannerBlue = 35
    Rhun_Rebels.bannerSet = true
    Rhun_Rebels:setBannerSymbol("banner_symbol_venice.tga")
    
    local Rohan_Rebels = M2TWEOP.getRebelFaction("Rohan_Rebels")
    Rohan_Rebels.bannerRed = 84
    Rohan_Rebels.bannerGreen = 30
    Rohan_Rebels.bannerBlue = 51
    Rohan_Rebels.bannerSet = true
    Rohan_Rebels:setBannerSymbol("banner_symbol_milan.tga")
    
    local Saralainn_Rebels = M2TWEOP.getRebelFaction("Saralainn_Rebels")
    Saralainn_Rebels.bannerRed = 66
    Saralainn_Rebels.bannerGreen = 53
    Saralainn_Rebels.bannerBlue = 33
    Saralainn_Rebels.bannerSet = true
    Saralainn_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    
    local Umbar_Rebels = M2TWEOP.getRebelFaction("Umbar_Rebels")
    Umbar_Rebels.bannerRed = 40
    Umbar_Rebels.bannerGreen = 49
    Umbar_Rebels.bannerBlue = 122
    Umbar_Rebels.bannerSet = true
    Umbar_Rebels:setBannerSymbol("banner_symbol_russia.tga")
    
    local Varfest_Rebels = M2TWEOP.getRebelFaction("Varfest_Rebels")
    Varfest_Rebels.bannerRed = 44
    Varfest_Rebels.bannerGreen = 119
    Varfest_Rebels.bannerBlue = 111
    Varfest_Rebels.bannerSet = true
    Varfest_Rebels:setBannerSymbol("banner_symbol_khand.tga")
    
    local Variag_Rebels = M2TWEOP.getRebelFaction("Variag_Rebels")
    Variag_Rebels.bannerRed = 98
    Variag_Rebels.bannerGreen = 31
    Variag_Rebels.bannerBlue = 130
    Variag_Rebels.bannerSet = true
    Variag_Rebels:setBannerSymbol("banner_symbol_khand.tga")
    
    local Wildmen_Rebels = M2TWEOP.getRebelFaction("Wildmen_Rebels")
    Wildmen_Rebels.bannerRed = 43
    Wildmen_Rebels.bannerGreen = 47
    Wildmen_Rebels.bannerBlue = 80
    Wildmen_Rebels.bannerSet = true
    Wildmen_Rebels:setBannerSymbol("banner_symbol_rebels.tga")
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end
