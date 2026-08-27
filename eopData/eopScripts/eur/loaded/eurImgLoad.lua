



char_portraits = {}

event_backgrounds = {
    ["milan"] = nil,
    ["sicily"] = nil,
    ["turks"] = nil,
    ["russia"] = nil,
    ["scotland"] = nil,
    ["byzantium"] = nil,
    ["timurids"] = nil,
    ["portugal"] = nil,
    ["aztecs"] = nil,
    ["teutonic_order"] = nil,
    ["spain"] = nil,
    ["khand"] = nil,
    ["venice"] = nil,
    ["norway"] = nil,
    ["hungary"] = nil,
    ["moors"] = nil,
    ["mongols"] = nil,
    ["ireland"] = nil,
    ["denmark"] = nil,
    ["england"] = nil,
    ["poland"] = nil,
    ["hre"] = nil,
    ["gundabad"] = nil,
    ["france"] = nil,
    ["saxons"] = nil,
}

function turnImageCheck(faction)
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."turnImageCheck");
	end
    if faction.isPlayerControlled == 0 then return end
    for i = 0, faction.numOfCharacters - 1 do
        local char = faction:getCharacter(i)
        if char:getTypeID() == 7 then
            if char.characterRecord.portrait_custom ~= "" then
                local portrait = char.characterRecord.portrait_custom
                if not char_portraits[portrait] then
                    if file_exists(M2TWEOP.getModPath().."\\data\\ui\\custom_portraits\\"..portrait.."\\portrait_young.dds") then
                        char_portraits[portrait] = { x = 0, y = 0, img = nil }
                        char_portraits[portrait].x, char_portraits[portrait].y, char_portraits[portrait].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\custom_portraits\\"..portrait.."\\portrait_young.dds")
                    elseif file_exists(M2TWEOP.getModPath().."\\data\\ui\\custom_portraits\\"..portrait.."\\portrait_young.tga") then
                        char_portraits[portrait] = { x = 0, y = 0, img = nil }
                        char_portraits[portrait].x, char_portraits[portrait].y, char_portraits[portrait].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\custom_portraits\\"..portrait.."\\portrait_young.tga")
                    
                    end
                end
            else
                if eur_localculture then
                    if char.characterRecord.portrait ~= "" then
                        local portrait = char.characterRecord.portrait
                        local portrait_rec = char.characterRecord.portrait
                        portrait = string.gsub(portrait, ".*/", "")
                        print(portrait)
                        if eur_player_faction.name == "turks" then
                            if not char_portraits[portrait_rec] then
                                if file_exists(M2TWEOP.getModPath().."\\data\\ui\\"..eur_localculture.."\\portraits\\portraits\\young\\islam_generals\\"..portrait) then
                                    char_portraits[portrait_rec] = { x = 0, y = 0, img = nil }
                                    char_portraits[portrait_rec].x, char_portraits[portrait_rec].y, char_portraits[portrait_rec].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\"..eur_localculture.."\\portraits\\portraits\\young\\islam_generals\\"..portrait)
                                end
                            end
                        elseif eur_player_faction.name == "teutonic_order" then
                            if not char_portraits[portrait_rec] then
                                if file_exists(M2TWEOP.getModPath().."\\data\\ui\\"..eur_localculture.."\\portraits\\portraits\\young\\wildmen_generals\\"..portrait) then
                                    char_portraits[portrait_rec] = { x = 0, y = 0, img = nil }
                                    char_portraits[portrait_rec].x, char_portraits[portrait_rec].y, char_portraits[portrait_rec].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\"..eur_localculture.."\\portraits\\portraits\\young\\wildmen_generals\\"..portrait)
                                end
                            end
                        else
                            if not char_portraits[portrait_rec] then
                                if file_exists(M2TWEOP.getModPath().."\\data\\ui\\"..eur_localculture.."\\portraits\\portraits\\young\\generals\\"..portrait) then
                                    char_portraits[portrait_rec] = { x = 0, y = 0, img = nil }
                                    char_portraits[portrait_rec].x, char_portraits[portrait_rec].y, char_portraits[portrait_rec].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\"..eur_localculture.."\\portraits\\portraits\\young\\generals\\"..portrait)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

minus = { x = 0, y = 0, img = nil }
plus = { x = 0, y = 0, img = nil }
leg_text = { x = 0, y = 0, img = nil }
battle_text = { x = 0, y = 0, img = nil }
revival_text = { x = 0, y = 0, img = nil }
chrisset_text = { x = 0, y = 0, img = nil }
sort_text = { x = 0, y = 0, img = nil }
misc_text = { x = 0, y = 0, img = nil }
rep_text = { x = 0, y = 0, img = nil }
u_text = { x = 0, y = 0, img = nil }
gu_text = { x = 0, y = 0, img = nil }
global_text = { x = 0, y = 0, img = nil }
welcome_beta = { x = 0, y = 0, img = nil }

pip_dwarves = { x = 0, y = 0, img = nil }
pip_elvish = { x = 0, y = 0, img = nil }
pip_evil = { x = 0, y = 0, img = nil }
pip_kings = { x = 0, y = 0, img = nil }
pip_middlemen = { x = 0, y = 0, img = nil }
pip_nomadic = { x = 0, y = 0, img = nil }
pip_northmen = { x = 0, y = 0, img = nil }
pip_numenorian = { x = 0, y = 0, img = nil }
pip_religious_unrest = { x = 0, y = 0, img = nil }
pip_rohirrim = { x = 0, y = 0, img = nil }
pip_uruk = { x = 0, y = 0, img = nil }
pip_wicked = { x = 0, y = 0, img = nil }
pip_wicked2 = { x = 0, y = 0, img = nil }

eregion_rebellion_choice = { x = 0, y = 0, img = nil }
kon_council_choice = { x = 0, y = 0, img = nil }
imladris_icon = { x = 0, y = 0, img = nil }
lindon_icon = { x = 0, y = 0, img = nil }
imladris_kon_icon = { x = 0, y = 0, img = nil }
lindon_kon_icon = { x = 0, y = 0, img = nil }
coins = { x = 0, y = 0, img = nil }
siege = { x = 0, y = 0, img = nil }
sword = { x = 0, y = 0, img = nil }
hammer = { x = 0, y = 0, img = nil }
unrest = { x = 0, y = 0, img = nil }
poblue = { x = 0, y = 0, img = nil }
pored = { x = 0, y = 0, img = nil }
pogreen = { x = 0, y = 0, img = nil }
poyellow = { x = 0, y = 0, img = nil }
sett_upgrade = { x = 0, y = 0, img = nil }
plague = { x = 0, y = 0, img = nil }
gov = { x = 0, y = 0, img = nil }
replen = { x = 0, y = 0, img = nil }
upg_icon = { x = 0, y = 0, img = nil }
sdg_icon = { x = 0, y = 0, img = nil }

koe_title = { x = 0, y = 0, img = nil }
kon_title = { x = 0, y = 0, img = nil }

test1 = { x = 0, y = 0, img = nil }
ent1 = { x = 0, y = 0, img = nil }
eldarlight = { x = 0, y = 0, img = nil }
mirror1 = { x = 0, y = 0, img = nil }
mirror2 = { x = 0, y = 0, img = nil }
mirror3 = { x = 0, y = 0, img = nil }
yavanna = { x = 0, y = 0, img = nil }
orome = { x = 0, y = 0, img = nil }
tulkas = { x = 0, y = 0, img = nil }
ulmo = { x = 0, y = 0, img = nil }
button1 = { x = 0, y = 0, img = nil }
icon_unit = { x = 0, y = 0, img = nil }
icon_unit2 = { x = 0, y = 0, img = nil }
icon_save = { x = 0, y = 0, img = nil }
icon_options = { x = 0, y = 0, img = nil }
aa_icon = { x = 0, y = 0, img = nil }
eregion_icon = { x = 0, y = 0, img = nil }
revive_yes = { x = 0, y = 0, img = nil }
welcome_text = { x = 0, y = 0, img = nil }
speed_text = { x = 0, y = 0, img = nil }
credits_text = { x = 0, y = 0, img = nil }
revive_no = { x = 0, y = 0, img = nil }
fort = { x = 0, y = 0, img = nil }
fort_text = { x = 0, y = 0, img = nil }
fort_text_no = { x = 0, y = 0, img = nil }
crown1 = { x = 0, y = 0, img = nil }
stew1 = { x = 0, y = 0, img = nil }
ship1 = { x = 0, y = 0, img = nil }
crown1locked = { x = 0, y = 0, img = nil }
stew1locked = { x = 0, y = 0, img = nil }
ship1locked = { x = 0, y = 0, img = nil }
anor = { x = 0, y = 0, img = nil }
mengood_pic_0 = { x = 0, y = 0, img = nil }
oatheorl = { x = 0, y = 0, img = nil }
lordsgondor = { x = 0, y = 0, img = nil }
bg_test = { x = 0, y = 0, img = nil }
bg_test2 = { x = 0, y = 0, img = nil }

sword_gold   = { x = 0, y = 0, img = nil }
sword_silver = { x = 0, y = 0, img = nil }
sword_bronze = { x = 0, y = 0, img = nil }
shield_gold   = { x = 0, y = 0, img = nil }
shield_silver = { x = 0, y = 0, img = nil }
shield_bronze = { x = 0, y = 0, img = nil }
chevron_gold   = { x = 0, y = 0, img = nil }
chevron_silver = { x = 0, y = 0, img = nil }
chevron_bronze = { x = 0, y = 0, img = nil }

bg_small_1 = { x = 0, y = 0, img = nil }
bg_1 = { x = 0, y = 0, img = nil }
bg_1_new = { x = 0, y = 0, img = nil }
bg_2 = { x = 0, y = 0, img = nil }
bg_3_elven = { x = 0, y = 0, img = nil }
bg_gondor_1 = { x = 0, y = 0, img = nil }
scroll_bg = { x = 0, y = 0, img = nil }
button_01 = { x = 0, y = 0, img = nil }
button_02 = { x = 0, y = 0, img = nil }
sortstack1 = { x = 0, y = 0, img = nil }
map1 = { x = 0, y = 0, img = nil }
seperator = { x = 0, y = 0, img = nil }

faction_info_aa = { x = 0, y = 0, img = nil }
faction_info_anduin = { x = 0, y = 0, img = nil }
faction_info_angmar = { x = 0, y = 0, img = nil }
faction_info_bree = { x = 0, y = 0, img = nil }
faction_info_da = { x = 0, y = 0, img = nil }
faction_info_dale_sa = { x = 0, y = 0, img = nil }
faction_info_dg = { x = 0, y = 0, img = nil }
faction_info_dorwinion = { x = 0, y = 0, img = nil }
faction_info_dunland = { x = 0, y = 0, img = nil }
faction_info_el = { x = 0, y = 0, img = nil }
faction_info_enedwaith = { x = 0, y = 0, img = nil }
faction_info_erebor = { x = 0, y = 0, img = nil }
faction_info_gondor = { x = 0, y = 0, img = nil }
faction_info_gundabad = { x = 0, y = 0, img = nil }
faction_info_harad = { x = 0, y = 0, img = nil }
faction_info_he = { x = 0, y = 0, img = nil }
faction_info_isengard = { x = 0, y = 0, img = nil }
faction_info_kd = { x = 0, y = 0, img = nil }
faction_info_khand = { x = 0, y = 0, img = nil }
faction_info_lorien = { x = 0, y = 0, img = nil }
faction_info_mordor = { x = 0, y = 0, img = nil }
faction_info_moria = { x = 0, y = 0, img = nil }
faction_info_nd = { x = 0, y = 0, img = nil }
faction_info_rhun = { x = 0, y = 0, img = nil }
faction_info_rohan = { x = 0, y = 0, img = nil }
faction_info_wr = { x = 0, y = 0, img = nil }

faction_bg = {
    ["northern_european"] = { x = 0, y = 0, img = nil },
    ["eastern_european"] = { x = 0, y = 0, img = nil },
    ["gondor"] = { x = 0, y = 0, img = nil },
    ["greek"] = { x = 0, y = 0, img = nil },
    ["noldor"] = { x = 0, y = 0, img = nil },
    ["mesoamerican"] = { x = 0, y = 0, img = nil },
    ["middle_eastern"] = { x = 0, y = 0, img = nil },
    ["southern_european"] = { x = 0, y = 0, img = nil },
    ["crags"] = { x = 0, y = 0, img = nil },
}

faction_accept = {
    ["northern_european"] = { x = 0, y = 0, img = nil },
    ["eastern_european"] = { x = 0, y = 0, img = nil },
    ["gondor"] = { x = 0, y = 0, img = nil },
    ["greek"] = { x = 0, y = 0, img = nil },
    ["noldor"] = { x = 0, y = 0, img = nil },
    ["mesoamerican"] = { x = 0, y = 0, img = nil },
    ["middle_eastern"] = { x = 0, y = 0, img = nil },
    ["southern_european"] = { x = 0, y = 0, img = nil },
    ["crags"] = { x = 0, y = 0, img = nil },
}

faction_upgrade_card_bw = {
    ["hungary"] = { x = 0, y = 0, img = nil },
    ["denmark"] = { x = 0, y = 0, img = nil },
    ["milan"] = { x = 0, y = 0, img = nil },
    ["normans"] = { x = 0, y = 0, img = nil },
    ["turks"] = { x = 0, y = 0, img = nil },
    ["scotland"] = { x = 0, y = 0, img = nil },
    ["timurids"] = { x = 0, y = 0, img = nil },
    ["byzantium"] = { x = 0, y = 0, img = nil },
    ["moors"] = { x = 0, y = 0, img = nil },
    ["sicily"] = { x = 0, y = 0, img = nil },
    ["norway"] = { x = 0, y = 0, img = nil },
    ["saxons"] = { x = 0, y = 0, img = nil },
    ["ireland"] = { x = 0, y = 0, img = nil },
    ["mongols"] = { x = 0, y = 0, img = nil },
    ["teutonic_order"] = { x = 0, y = 0, img = nil },
    ["venice"] = { x = 0, y = 0, img = nil },
    ["england"] = { x = 0, y = 0, img = nil },
    ["poland"] = { x = 0, y = 0, img = nil },
    ["france"] = { x = 0, y = 0, img = nil },
    ["aztecs"] = { x = 0, y = 0, img = nil },
    ["hre"] = { x = 0, y = 0, img = nil },
    ["gundabad"] = { x = 0, y = 0, img = nil },
    ["portugal"] = { x = 0, y = 0, img = nil },
    ["spain"] = { x = 0, y = 0, img = nil },
    ["khand"] = { x = 0, y = 0, img = nil },
    ["russia"] = { x = 0, y = 0, img = nil },
    ["papal_states"] = { x = 0, y = 0, img = nil },
    ["scripts"] = { x = 0, y = 0, img = nil },
    ["united"] = { x = 0, y = 0, img = nil },
    ["slave"] = { x = 0, y = 0, img = nil },
    ["egypt"] = { x = 0, y = 0, img = nil },
}

faction_upgrade_card_silver = {
    ["hungary"] = { x = 0, y = 0, img = nil },
    ["denmark"] = { x = 0, y = 0, img = nil },
    ["milan"] = { x = 0, y = 0, img = nil },
    ["normans"] = { x = 0, y = 0, img = nil },
    ["turks"] = { x = 0, y = 0, img = nil },
    ["scotland"] = { x = 0, y = 0, img = nil },
    ["timurids"] = { x = 0, y = 0, img = nil },
    ["byzantium"] = { x = 0, y = 0, img = nil },
    ["moors"] = { x = 0, y = 0, img = nil },
    ["sicily"] = { x = 0, y = 0, img = nil },
    ["norway"] = { x = 0, y = 0, img = nil },
    ["saxons"] = { x = 0, y = 0, img = nil },
    ["ireland"] = { x = 0, y = 0, img = nil },
    ["mongols"] = { x = 0, y = 0, img = nil },
    ["teutonic_order"] = { x = 0, y = 0, img = nil },
    ["venice"] = { x = 0, y = 0, img = nil },
    ["england"] = { x = 0, y = 0, img = nil },
    ["poland"] = { x = 0, y = 0, img = nil },
    ["france"] = { x = 0, y = 0, img = nil },
    ["aztecs"] = { x = 0, y = 0, img = nil },
    ["hre"] = { x = 0, y = 0, img = nil },
    ["gundabad"] = { x = 0, y = 0, img = nil },
    ["portugal"] = { x = 0, y = 0, img = nil },
    ["spain"] = { x = 0, y = 0, img = nil },
    ["khand"] = { x = 0, y = 0, img = nil },
    ["russia"] = { x = 0, y = 0, img = nil },
    ["papal_states"] = { x = 0, y = 0, img = nil },
    ["scripts"] = { x = 0, y = 0, img = nil },
    ["united"] = { x = 0, y = 0, img = nil },
    ["slave"] = { x = 0, y = 0, img = nil },
    ["egypt"] = { x = 0, y = 0, img = nil },
}

faction_upgrade_card_blue = {
    ["hungary"] = { x = 0, y = 0, img = nil },
    ["denmark"] = { x = 0, y = 0, img = nil },
    ["milan"] = { x = 0, y = 0, img = nil },
    ["normans"] = { x = 0, y = 0, img = nil },
    ["turks"] = { x = 0, y = 0, img = nil },
    ["scotland"] = { x = 0, y = 0, img = nil },
    ["timurids"] = { x = 0, y = 0, img = nil },
    ["byzantium"] = { x = 0, y = 0, img = nil },
    ["moors"] = { x = 0, y = 0, img = nil },
    ["sicily"] = { x = 0, y = 0, img = nil },
    ["norway"] = { x = 0, y = 0, img = nil },
    ["saxons"] = { x = 0, y = 0, img = nil },
    ["ireland"] = { x = 0, y = 0, img = nil },
    ["mongols"] = { x = 0, y = 0, img = nil },
    ["teutonic_order"] = { x = 0, y = 0, img = nil },
    ["venice"] = { x = 0, y = 0, img = nil },
    ["england"] = { x = 0, y = 0, img = nil },
    ["poland"] = { x = 0, y = 0, img = nil },
    ["france"] = { x = 0, y = 0, img = nil },
    ["aztecs"] = { x = 0, y = 0, img = nil },
    ["hre"] = { x = 0, y = 0, img = nil },
    ["gundabad"] = { x = 0, y = 0, img = nil },
    ["portugal"] = { x = 0, y = 0, img = nil },
    ["spain"] = { x = 0, y = 0, img = nil },
    ["khand"] = { x = 0, y = 0, img = nil },
    ["russia"] = { x = 0, y = 0, img = nil },
    ["papal_states"] = { x = 0, y = 0, img = nil },
    ["scripts"] = { x = 0, y = 0, img = nil },
    ["united"] = { x = 0, y = 0, img = nil },
    ["slave"] = { x = 0, y = 0, img = nil },
    ["egypt"] = { x = 0, y = 0, img = nil },
}

faction_upgrade_card_bronze = {
    ["hungary"] = { x = 0, y = 0, img = nil },
    ["denmark"] = { x = 0, y = 0, img = nil },
    ["milan"] = { x = 0, y = 0, img = nil },
    ["normans"] = { x = 0, y = 0, img = nil },
    ["turks"] = { x = 0, y = 0, img = nil },
    ["scotland"] = { x = 0, y = 0, img = nil },
    ["timurids"] = { x = 0, y = 0, img = nil },
    ["byzantium"] = { x = 0, y = 0, img = nil },
    ["moors"] = { x = 0, y = 0, img = nil },
    ["sicily"] = { x = 0, y = 0, img = nil },
    ["norway"] = { x = 0, y = 0, img = nil },
    ["saxons"] = { x = 0, y = 0, img = nil },
    ["ireland"] = { x = 0, y = 0, img = nil },
    ["mongols"] = { x = 0, y = 0, img = nil },
    ["teutonic_order"] = { x = 0, y = 0, img = nil },
    ["venice"] = { x = 0, y = 0, img = nil },
    ["england"] = { x = 0, y = 0, img = nil },
    ["poland"] = { x = 0, y = 0, img = nil },
    ["france"] = { x = 0, y = 0, img = nil },
    ["aztecs"] = { x = 0, y = 0, img = nil },
    ["hre"] = { x = 0, y = 0, img = nil },
    ["gundabad"] = { x = 0, y = 0, img = nil },
    ["portugal"] = { x = 0, y = 0, img = nil },
    ["spain"] = { x = 0, y = 0, img = nil },
    ["khand"] = { x = 0, y = 0, img = nil },
    ["russia"] = { x = 0, y = 0, img = nil },
    ["papal_states"] = { x = 0, y = 0, img = nil },
    ["scripts"] = { x = 0, y = 0, img = nil },
    ["united"] = { x = 0, y = 0, img = nil },
    ["slave"] = { x = 0, y = 0, img = nil },
    ["egypt"] = { x = 0, y = 0, img = nil },
}

faction_upgrade_card_gold = {
    ["hungary"] = { x = 0, y = 0, img = nil },
    ["denmark"] = { x = 0, y = 0, img = nil },
    ["milan"] = { x = 0, y = 0, img = nil },
    ["normans"] = { x = 0, y = 0, img = nil },
    ["turks"] = { x = 0, y = 0, img = nil },
    ["scotland"] = { x = 0, y = 0, img = nil },
    ["timurids"] = { x = 0, y = 0, img = nil },
    ["byzantium"] = { x = 0, y = 0, img = nil },
    ["moors"] = { x = 0, y = 0, img = nil },
    ["sicily"] = { x = 0, y = 0, img = nil },
    ["norway"] = { x = 0, y = 0, img = nil },
    ["saxons"] = { x = 0, y = 0, img = nil },
    ["ireland"] = { x = 0, y = 0, img = nil },
    ["mongols"] = { x = 0, y = 0, img = nil },
    ["teutonic_order"] = { x = 0, y = 0, img = nil },
    ["venice"] = { x = 0, y = 0, img = nil },
    ["england"] = { x = 0, y = 0, img = nil },
    ["poland"] = { x = 0, y = 0, img = nil },
    ["france"] = { x = 0, y = 0, img = nil },
    ["aztecs"] = { x = 0, y = 0, img = nil },
    ["hre"] = { x = 0, y = 0, img = nil },
    ["gundabad"] = { x = 0, y = 0, img = nil },
    ["portugal"] = { x = 0, y = 0, img = nil },
    ["spain"] = { x = 0, y = 0, img = nil },
    ["khand"] = { x = 0, y = 0, img = nil },
    ["russia"] = { x = 0, y = 0, img = nil },
    ["papal_states"] = { x = 0, y = 0, img = nil },
    ["scripts"] = { x = 0, y = 0, img = nil },
    ["united"] = { x = 0, y = 0, img = nil },
    ["slave"] = { x = 0, y = 0, img = nil },
    ["egypt"] = { x = 0, y = 0, img = nil },
}
faction_bu = {
    ["northern_european"] = { x = 0, y = 0, img = nil },
    ["eastern_european"] = { x = 0, y = 0, img = nil },
    ["gondor"] = { x = 0, y = 0, img = nil },
    ["greek"] = { x = 0, y = 0, img = nil },
    ["noldor"] = { x = 0, y = 0, img = nil },
    ["mesoamerican"] = { x = 0, y = 0, img = nil },
    ["middle_eastern"] = { x = 0, y = 0, img = nil },
    ["southern_european"] = { x = 0, y = 0, img = nil },
    ["crags"] = { x = 0, y = 0, img = nil },
}

core_sett_pics = {
    ["northern_european"] = {},
    ["eastern_european"] = {},
    ["gondor"] = {},
    ["greek"] = {},
    ["mesoamerican"] = {},
    ["middle_eastern"] = {},
    ["southern_european"] = {},
}

culture_names = {
    "northern_european",
    "eastern_european",
    "gondor",
    "greek",
    "mesoamerican",
    "middle_eastern",
    "southern_european",
}

core_sett_names = {
    "village",
    "town",
    "large_town",
    "city",
    "large_city",
    "huge_city",
    "motte_and_bailey",
    "wooden_castle",
    "castle",
    "fortress",
    "citadel",
}

core_sett_names_index = {
    [0] = {
        [0] = "village",
        [1] = "town",
        [2] = "large_town",
        [3] = "city",
        [4] = "large_city",
        [5] = "huge_city",
    },
    [1] = {
        [0] = "motte_and_bailey",
        [1] = "wooden_castle",
        [2] = "castle",
        [3] = "fortress",
        [4] = "citadel",
    },
}

eur_tga_table_bu = {}

function loadImages()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."loadImages");
	end
    --[[for i = 0, 200 do
        local edbEntry = EDB.getBuildingByID(i)
        if edbEntry ~= nil then
            for j = 0, edbEntry.buildingLevelCount -1 do
                local level = edbEntry:getBuildingLevel(j)
                if level ~= nil then
                    local path = level:getBuildingPicConstruction(eur_player_faction.cultureID)
                    if path ~= nil or path ~= "" then
                        if file_exists(path) then
                            eur_tga_table_bu[level.name] = { x = 0, y = 0, img = nil }
                            eur_tga_table_bu[level.name].x, eur_tga_table_bu[level.name].y, eur_tga_table_bu[level.name].img =  M2TWEOP.loadTexture(path)
                        end
                    end
                end
            end
        end
    end]]
    --for i = 1, #core_sett_names do
        --for x = 1, #culture_names do
            --if file_exists(M2TWEOP.getModPath().."\\data\\ui\\"..culture_names[x].."\\cities\\"..culture_names[x].."_"..core_sett_names[i]..".tga") then
                --core_sett_pics[culture_names[x]][core_sett_names[i]] = { x = 0, y = 0, img = nil }
                --core_sett_pics[culture_names[x]][core_sett_names[i]].x, core_sett_pics[culture_names[x]][core_sett_names[i]].y, core_sett_pics[culture_names[x]][core_sett_names[i]].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\"..culture_names[x].."\\cities\\"..culture_names[x].."_"..core_sett_names[i]..".tga")
            --end
        --end
    --end
    local path = '"'..M2TWEOP.getModPath().."\\data\\ui\\units\\mercs\\"..'"'
    player_units = {}
    player_units_local = {}
    eur_tga_table = {}
    for i = 0, 1500 do
        local eduEntry = M2TWEOPDU.getEduEntry(i)
        if eduEntry ~= nil then
            --if eduEntry:hasOwnership(eur_playerFactionId) then
                --dir1 = string.lower(eduEntry.unitCardTga)
                dir1 = eduEntry.unitCardTga
                --table.insert(unit_names, dir1)
                if eur_tga_table[dir1] == nil then
                    if file_exists(M2TWEOP.getModPath().."\\data\\ui\\units\\mercs\\"..dir1) then
                        if not tableContains(player_units, eduEntry.eduType) then
                            if not string.find(eduEntry.eduType, "Garrison") then
                                --if eduEntry.soldierCount > replen_beast_value then
                                    if (eduEntry.category ~= unitCategory.siege and eduEntry.category ~= unitCategory.ship) then
                                        if eduEntry:hasOwnership(eur_playerFactionId) then
                                            if player_units_cut[eur_player_faction.name] then
                                                if not tableContains(player_units_cut[eur_player_faction.name], eduEntry.eduType) then
                                                    table.insert(player_units, eduEntry.eduType)
                                                    table.insert(player_units_local, eduEntry.localizedName)
                                                end
                                            end
                                        end
                                    end
                                --end
                            end
                        end
                        eur_tga_table[dir1] = { x = 0, y = 0, img = nil }
                        eur_tga_table[dir1].x, eur_tga_table[dir1].y, eur_tga_table[dir1].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\units\\mercs\\"..dir1)
                    end
                end
            --end
        end
    end
    if player_units ~= {} then
        sortPlayerUnitsAlphabetically(player_units_local, player_units)
    end
    if file_exists(M2TWEOP.getModPath().."\\data\\ui\\units\\mercs\\".."#Dunedain_Bodyguards.tga") then
        eur_tga_table["#Dunedain_Bodyguards.tga"] = { x = 0, y = 0, img = nil }
        eur_tga_table["#Dunedain_Bodyguards.tga"].x, eur_tga_table["#Dunedain_Bodyguards.tga"].y, eur_tga_table["#Dunedain_Bodyguards.tga"].img = M2TWEOP.loadTexture(M2TWEOP.getModPath().."\\data\\ui\\units\\mercs\\".."#Dunedain_Bodyguards.tga")
    end

    
--[[
    faction_info_aa.x, faction_info_aa.y, faction_info_aa.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_aa.tga')
    faction_info_anduin.x, faction_info_anduin.y, faction_info_anduin.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_anduin.tga')
    faction_info_angmar.x, faction_info_angmar.y, faction_info_angmar.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_angmar.tga')
    faction_info_bree.x, faction_info_bree.y, faction_info_bree.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_bree.tga')
    faction_info_da.x, faction_info_da.y, faction_info_da.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_da.tga')
    faction_info_dale_sa.x, faction_info_dale_sa.y, faction_info_dale_sa.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_dale_sa.tga')
    faction_info_dg.x, faction_info_dg.y, faction_info_dg.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_dg.tga')
    faction_info_dorwinion.x, faction_info_dorwinion.y, faction_info_dorwinion.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_dorwinion.tga')
    faction_info_dunland.x, faction_info_dunland.y, faction_info_dunland.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_dunland.tga')
    faction_info_el.x, faction_info_el.y, faction_info_el.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_el.tga')
    faction_info_enedwaith.x, faction_info_enedwaith.y, faction_info_enedwaith.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_enedwaith.tga')
    faction_info_erebor.x, faction_info_erebor.y, faction_info_erebor.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_erebor.tga')
    faction_info_gondor.x, faction_info_gondor.y, faction_info_gondor.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_gondor.tga')
    faction_info_gundabad.x, faction_info_gundabad.y, faction_info_gundabad.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_gundabad.tga')
    faction_info_harad.x, faction_info_harad.y, faction_info_harad.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_harad.tga')
    faction_info_he.x, faction_info_he.y, faction_info_he.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_he.tga')
    faction_info_isengard.x, faction_info_isengard.y, faction_info_isengard.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_isengard.tga')
    faction_info_kd.x, faction_info_kd.y, faction_info_kd.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_kd.tga')
    faction_info_khand.x, faction_info_khand.y, faction_info_khand.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_khand.tga')
    faction_info_lorien.x, faction_info_lorien.y, faction_info_lorien.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_lorien.tga')
    faction_info_mordor.x, faction_info_mordor.y, faction_info_mordor.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_mordor.tga')
    faction_info_moria.x, faction_info_moria.y, faction_info_moria.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_moria.tga')
    faction_info_nd.x, faction_info_nd.y, faction_info_nd.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_nd.tga')
    faction_info_rhun.x, faction_info_rhun.y, faction_info_rhun.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_rhun.tga')
    faction_info_rohan.x, faction_info_rohan.y, faction_info_rohan.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_rohan.tga')
    faction_info_wr.x, faction_info_wr.y, faction_info_wr.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_wr.tga')
    faction_info_nd.x, faction_info_nd.y, faction_info_nd.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\data\\ui\\southern_european\\eventpics\\faction_info_nd.tga')
]]

    faction_bg["northern_european"].x, faction_bg["northern_european"].y, faction_bg["northern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\northern_european.png')

faction_bg["eastern_european"].x, faction_bg["eastern_european"].y, faction_bg["eastern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\eastern_european.png')

faction_bg["gondor"].x, faction_bg["gondor"].y, faction_bg["gondor"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\gondor.png')

faction_bg["greek"].x, faction_bg["greek"].y, faction_bg["greek"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\greek.png')

    faction_bg["noldor"].x, faction_bg["noldor"].y, faction_bg["noldor"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\Noldor.png')

faction_bg["mesoamerican"].x, faction_bg["mesoamerican"].y, faction_bg["mesoamerican"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\mesoamerican.png')

faction_bg["middle_eastern"].x, faction_bg["middle_eastern"].y, faction_bg["middle_eastern"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\middle_eastern.png')

faction_bg["southern_european"].x, faction_bg["southern_european"].y, faction_bg["southern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\southern_european.png')

    faction_bg["crags"].x, faction_bg["crags"].y, faction_bg["crags"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\crags.png')

    faction_accept["northern_european"].x, faction_accept["northern_european"].y, faction_accept["northern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\northern_european_accept.png')

faction_accept["eastern_european"].x, faction_accept["eastern_european"].y, faction_accept["eastern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\eastern_european_accept.png')

faction_accept["gondor"].x, faction_accept["gondor"].y, faction_accept["gondor"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\gondor_accept.png')

faction_accept["greek"].x, faction_accept["greek"].y, faction_accept["greek"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\greek_accept.png')

    faction_accept["noldor"].x, faction_accept["noldor"].y, faction_accept["noldor"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\Noldor_accept.png')

faction_accept["mesoamerican"].x, faction_accept["mesoamerican"].y, faction_accept["mesoamerican"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\mesoamerican_accept.png')

faction_accept["middle_eastern"].x, faction_accept["middle_eastern"].y, faction_accept["middle_eastern"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\middle_eastern_accept.png')

faction_accept["southern_european"].x, faction_accept["southern_european"].y, faction_accept["southern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\southern_european_accept.png')

    faction_accept["crags"].x, faction_accept["crags"].y, faction_accept["crags"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\crags_accept.png')

------------------------

faction_upgrade_card_gold["hungary"].x, faction_upgrade_card_gold["hungary"].y, faction_upgrade_card_gold["hungary"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves.png')
faction_upgrade_card_gold["denmark"].x, faction_upgrade_card_gold["denmark"].y, faction_upgrade_card_gold["denmark"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves.png')
faction_upgrade_card_gold["milan"].x, faction_upgrade_card_gold["milan"].y, faction_upgrade_card_gold["milan"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\rohan.png')
faction_upgrade_card_gold["normans"].x, faction_upgrade_card_gold["normans"].y, faction_upgrade_card_gold["normans"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["turks"].x, faction_upgrade_card_gold["turks"].y, faction_upgrade_card_gold["turks"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dunedain.png')
faction_upgrade_card_gold["scotland"].x, faction_upgrade_card_gold["scotland"].y, faction_upgrade_card_gold["scotland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen.png')
faction_upgrade_card_gold["timurids"].x, faction_upgrade_card_gold["timurids"].y, faction_upgrade_card_gold["timurids"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen.png')
faction_upgrade_card_gold["byzantium"].x, faction_upgrade_card_gold["byzantium"].y, faction_upgrade_card_gold["byzantium"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen.png')
faction_upgrade_card_gold["moors"].x, faction_upgrade_card_gold["moors"].y, faction_upgrade_card_gold["moors"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves.png')
faction_upgrade_card_gold["sicily"].x, faction_upgrade_card_gold["sicily"].y, faction_upgrade_card_gold["sicily"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen.png')
faction_upgrade_card_gold["norway"].x, faction_upgrade_card_gold["norway"].y, faction_upgrade_card_gold["norway"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves.png')
faction_upgrade_card_gold["saxons"].x, faction_upgrade_card_gold["saxons"].y, faction_upgrade_card_gold["saxons"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves.png')
faction_upgrade_card_gold["ireland"].x, faction_upgrade_card_gold["ireland"].y, faction_upgrade_card_gold["ireland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves.png')
faction_upgrade_card_gold["mongols"].x, faction_upgrade_card_gold["mongols"].y, faction_upgrade_card_gold["mongols"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves.png')
faction_upgrade_card_gold["teutonic_order"].x, faction_upgrade_card_gold["teutonic_order"].y, faction_upgrade_card_gold["teutonic_order"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen.png')
faction_upgrade_card_gold["venice"].x, faction_upgrade_card_gold["venice"].y, faction_upgrade_card_gold["venice"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron.png')
faction_upgrade_card_gold["england"].x, faction_upgrade_card_gold["england"].y, faction_upgrade_card_gold["england"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["poland"].x, faction_upgrade_card_gold["poland"].y, faction_upgrade_card_gold["poland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["france"].x, faction_upgrade_card_gold["france"].y, faction_upgrade_card_gold["france"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\isengard.png')
faction_upgrade_card_gold["aztecs"].x, faction_upgrade_card_gold["aztecs"].y, faction_upgrade_card_gold["aztecs"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen.png')
faction_upgrade_card_gold["hre"].x, faction_upgrade_card_gold["hre"].y, faction_upgrade_card_gold["hre"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["gundabad"].x, faction_upgrade_card_gold["gundabad"].y, faction_upgrade_card_gold["gundabad"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["portugal"].x, faction_upgrade_card_gold["portugal"].y, faction_upgrade_card_gold["portugal"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["spain"].x, faction_upgrade_card_gold["spain"].y, faction_upgrade_card_gold["spain"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron.png')
faction_upgrade_card_gold["khand"].x, faction_upgrade_card_gold["khand"].y, faction_upgrade_card_gold["khand"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron.png')
faction_upgrade_card_gold["russia"].x, faction_upgrade_card_gold["russia"].y, faction_upgrade_card_gold["russia"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen.png')
faction_upgrade_card_gold["papal_states"].x, faction_upgrade_card_gold["papal_states"].y, faction_upgrade_card_gold["papal_states"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["scripts"].x, faction_upgrade_card_gold["scripts"].y, faction_upgrade_card_gold["scripts"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["united"].x, faction_upgrade_card_gold["united"].y, faction_upgrade_card_gold["united"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
faction_upgrade_card_gold["slave"].x, faction_upgrade_card_gold["slave"].y, faction_upgrade_card_gold["slave"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc.png')
    faction_upgrade_card_gold["egypt"].x, faction_upgrade_card_gold["egypt"].y, faction_upgrade_card_gold["egypt"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves.png')

    faction_upgrade_card_silver["hungary"].x, faction_upgrade_card_silver["hungary"].y, faction_upgrade_card_silver["hungary"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_silver.png')
faction_upgrade_card_silver["denmark"].x, faction_upgrade_card_silver["denmark"].y, faction_upgrade_card_silver["denmark"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_silver.png')
faction_upgrade_card_silver["milan"].x, faction_upgrade_card_silver["milan"].y, faction_upgrade_card_silver["milan"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\rohan_silver.png')
faction_upgrade_card_silver["normans"].x, faction_upgrade_card_silver["normans"].y, faction_upgrade_card_silver["normans"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["turks"].x, faction_upgrade_card_silver["turks"].y, faction_upgrade_card_silver["turks"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dunedain_silver.png')
faction_upgrade_card_silver["scotland"].x, faction_upgrade_card_silver["scotland"].y, faction_upgrade_card_silver["scotland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_silver.png')
faction_upgrade_card_silver["timurids"].x, faction_upgrade_card_silver["timurids"].y, faction_upgrade_card_silver["timurids"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_silver.png')
faction_upgrade_card_silver["byzantium"].x, faction_upgrade_card_silver["byzantium"].y, faction_upgrade_card_silver["byzantium"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_silver.png')
faction_upgrade_card_silver["moors"].x, faction_upgrade_card_silver["moors"].y, faction_upgrade_card_silver["moors"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_silver.png')
faction_upgrade_card_silver["sicily"].x, faction_upgrade_card_silver["sicily"].y, faction_upgrade_card_silver["sicily"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_silver.png')
faction_upgrade_card_silver["norway"].x, faction_upgrade_card_silver["norway"].y, faction_upgrade_card_silver["norway"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_silver.png')
faction_upgrade_card_silver["saxons"].x, faction_upgrade_card_silver["saxons"].y, faction_upgrade_card_silver["saxons"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_silver.png')
faction_upgrade_card_silver["ireland"].x, faction_upgrade_card_silver["ireland"].y, faction_upgrade_card_silver["ireland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_silver.png')
faction_upgrade_card_silver["mongols"].x, faction_upgrade_card_silver["mongols"].y, faction_upgrade_card_silver["mongols"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_silver.png')
faction_upgrade_card_silver["teutonic_order"].x, faction_upgrade_card_silver["teutonic_order"].y, faction_upgrade_card_silver["teutonic_order"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_silver.png')
faction_upgrade_card_silver["venice"].x, faction_upgrade_card_silver["venice"].y, faction_upgrade_card_silver["venice"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_silver.png')
faction_upgrade_card_silver["england"].x, faction_upgrade_card_silver["england"].y, faction_upgrade_card_silver["england"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["poland"].x, faction_upgrade_card_silver["poland"].y, faction_upgrade_card_silver["poland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["france"].x, faction_upgrade_card_silver["france"].y, faction_upgrade_card_silver["france"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\isengard_silver.png')
faction_upgrade_card_silver["aztecs"].x, faction_upgrade_card_silver["aztecs"].y, faction_upgrade_card_silver["aztecs"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_silver.png')
faction_upgrade_card_silver["hre"].x, faction_upgrade_card_silver["hre"].y, faction_upgrade_card_silver["hre"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["gundabad"].x, faction_upgrade_card_silver["gundabad"].y, faction_upgrade_card_silver["gundabad"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["portugal"].x, faction_upgrade_card_silver["portugal"].y, faction_upgrade_card_silver["portugal"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["spain"].x, faction_upgrade_card_silver["spain"].y, faction_upgrade_card_silver["spain"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_silver.png')
faction_upgrade_card_silver["khand"].x, faction_upgrade_card_silver["khand"].y, faction_upgrade_card_silver["khand"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_silver.png')
faction_upgrade_card_silver["russia"].x, faction_upgrade_card_silver["russia"].y, faction_upgrade_card_silver["russia"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_silver.png')
faction_upgrade_card_silver["papal_states"].x, faction_upgrade_card_silver["papal_states"].y, faction_upgrade_card_silver["papal_states"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["scripts"].x, faction_upgrade_card_silver["scripts"].y, faction_upgrade_card_silver["scripts"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["united"].x, faction_upgrade_card_silver["united"].y, faction_upgrade_card_silver["united"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
faction_upgrade_card_silver["slave"].x, faction_upgrade_card_silver["slave"].y, faction_upgrade_card_silver["slave"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_silver.png')
    faction_upgrade_card_silver["egypt"].x, faction_upgrade_card_silver["egypt"].y, faction_upgrade_card_silver["egypt"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_silver.png')

    faction_upgrade_card_bronze["hungary"].x, faction_upgrade_card_bronze["hungary"].y, faction_upgrade_card_bronze["hungary"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_bronze.png')
faction_upgrade_card_bronze["denmark"].x, faction_upgrade_card_bronze["denmark"].y, faction_upgrade_card_bronze["denmark"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bronze.png')
faction_upgrade_card_bronze["milan"].x, faction_upgrade_card_bronze["milan"].y, faction_upgrade_card_bronze["milan"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\rohan_bronze.png')
faction_upgrade_card_bronze["normans"].x, faction_upgrade_card_bronze["normans"].y, faction_upgrade_card_bronze["normans"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["turks"].x, faction_upgrade_card_bronze["turks"].y, faction_upgrade_card_bronze["turks"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dunedain_bronze.png')
faction_upgrade_card_bronze["scotland"].x, faction_upgrade_card_bronze["scotland"].y, faction_upgrade_card_bronze["scotland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bronze.png')
faction_upgrade_card_bronze["timurids"].x, faction_upgrade_card_bronze["timurids"].y, faction_upgrade_card_bronze["timurids"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bronze.png')
faction_upgrade_card_bronze["byzantium"].x, faction_upgrade_card_bronze["byzantium"].y, faction_upgrade_card_bronze["byzantium"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bronze.png')
faction_upgrade_card_bronze["moors"].x, faction_upgrade_card_bronze["moors"].y, faction_upgrade_card_bronze["moors"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_bronze.png')
faction_upgrade_card_bronze["sicily"].x, faction_upgrade_card_bronze["sicily"].y, faction_upgrade_card_bronze["sicily"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bronze.png')
faction_upgrade_card_bronze["norway"].x, faction_upgrade_card_bronze["norway"].y, faction_upgrade_card_bronze["norway"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_bronze.png')
faction_upgrade_card_bronze["saxons"].x, faction_upgrade_card_bronze["saxons"].y, faction_upgrade_card_bronze["saxons"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bronze.png')
faction_upgrade_card_bronze["ireland"].x, faction_upgrade_card_bronze["ireland"].y, faction_upgrade_card_bronze["ireland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bronze.png')
faction_upgrade_card_bronze["mongols"].x, faction_upgrade_card_bronze["mongols"].y, faction_upgrade_card_bronze["mongols"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bronze.png')
faction_upgrade_card_bronze["teutonic_order"].x, faction_upgrade_card_bronze["teutonic_order"].y, faction_upgrade_card_bronze["teutonic_order"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bronze.png')
faction_upgrade_card_bronze["venice"].x, faction_upgrade_card_bronze["venice"].y, faction_upgrade_card_bronze["venice"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_bronze.png')
faction_upgrade_card_bronze["england"].x, faction_upgrade_card_bronze["england"].y, faction_upgrade_card_bronze["england"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["poland"].x, faction_upgrade_card_bronze["poland"].y, faction_upgrade_card_bronze["poland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["france"].x, faction_upgrade_card_bronze["france"].y, faction_upgrade_card_bronze["france"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\isengard_bronze.png')
faction_upgrade_card_bronze["aztecs"].x, faction_upgrade_card_bronze["aztecs"].y, faction_upgrade_card_bronze["aztecs"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bronze.png')
faction_upgrade_card_bronze["hre"].x, faction_upgrade_card_bronze["hre"].y, faction_upgrade_card_bronze["hre"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["gundabad"].x, faction_upgrade_card_bronze["gundabad"].y, faction_upgrade_card_bronze["gundabad"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["portugal"].x, faction_upgrade_card_bronze["portugal"].y, faction_upgrade_card_bronze["portugal"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["spain"].x, faction_upgrade_card_bronze["spain"].y, faction_upgrade_card_bronze["spain"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_bronze.png')
faction_upgrade_card_bronze["khand"].x, faction_upgrade_card_bronze["khand"].y, faction_upgrade_card_bronze["khand"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_bronze.png')
faction_upgrade_card_bronze["russia"].x, faction_upgrade_card_bronze["russia"].y, faction_upgrade_card_bronze["russia"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bronze.png')
faction_upgrade_card_bronze["papal_states"].x, faction_upgrade_card_bronze["papal_states"].y, faction_upgrade_card_bronze["papal_states"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["scripts"].x, faction_upgrade_card_bronze["scripts"].y, faction_upgrade_card_bronze["scripts"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["united"].x, faction_upgrade_card_bronze["united"].y, faction_upgrade_card_bronze["united"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
faction_upgrade_card_bronze["slave"].x, faction_upgrade_card_bronze["slave"].y, faction_upgrade_card_bronze["slave"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bronze.png')
    faction_upgrade_card_bronze["egypt"].x, faction_upgrade_card_bronze["egypt"].y, faction_upgrade_card_bronze["egypt"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bronze.png')

    faction_upgrade_card_blue["hungary"].x, faction_upgrade_card_blue["hungary"].y, faction_upgrade_card_blue["hungary"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_blue.png')
faction_upgrade_card_blue["denmark"].x, faction_upgrade_card_blue["denmark"].y, faction_upgrade_card_blue["denmark"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_blue.png')
faction_upgrade_card_blue["milan"].x, faction_upgrade_card_blue["milan"].y, faction_upgrade_card_blue["milan"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\rohan_blue.png')
faction_upgrade_card_blue["normans"].x, faction_upgrade_card_blue["normans"].y, faction_upgrade_card_blue["normans"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["turks"].x, faction_upgrade_card_blue["turks"].y, faction_upgrade_card_blue["turks"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dunedain_blue.png')
faction_upgrade_card_blue["scotland"].x, faction_upgrade_card_blue["scotland"].y, faction_upgrade_card_blue["scotland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_blue.png')
faction_upgrade_card_blue["timurids"].x, faction_upgrade_card_blue["timurids"].y, faction_upgrade_card_blue["timurids"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_blue.png')
faction_upgrade_card_blue["byzantium"].x, faction_upgrade_card_blue["byzantium"].y, faction_upgrade_card_blue["byzantium"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_blue.png')
faction_upgrade_card_blue["moors"].x, faction_upgrade_card_blue["moors"].y, faction_upgrade_card_blue["moors"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_blue.png')
faction_upgrade_card_blue["sicily"].x, faction_upgrade_card_blue["sicily"].y, faction_upgrade_card_blue["sicily"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_blue.png')
faction_upgrade_card_blue["norway"].x, faction_upgrade_card_blue["norway"].y, faction_upgrade_card_blue["norway"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_blue.png')
faction_upgrade_card_blue["saxons"].x, faction_upgrade_card_blue["saxons"].y, faction_upgrade_card_blue["saxons"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_blue.png')
faction_upgrade_card_blue["ireland"].x, faction_upgrade_card_blue["ireland"].y, faction_upgrade_card_blue["ireland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_blue.png')
faction_upgrade_card_blue["mongols"].x, faction_upgrade_card_blue["mongols"].y, faction_upgrade_card_blue["mongols"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_blue.png')
faction_upgrade_card_blue["teutonic_order"].x, faction_upgrade_card_blue["teutonic_order"].y, faction_upgrade_card_blue["teutonic_order"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_blue.png')
faction_upgrade_card_blue["venice"].x, faction_upgrade_card_blue["venice"].y, faction_upgrade_card_blue["venice"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_blue.png')
faction_upgrade_card_blue["england"].x, faction_upgrade_card_blue["england"].y, faction_upgrade_card_blue["england"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["poland"].x, faction_upgrade_card_blue["poland"].y, faction_upgrade_card_blue["poland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["france"].x, faction_upgrade_card_blue["france"].y, faction_upgrade_card_blue["france"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\isengard_blue.png')
faction_upgrade_card_blue["aztecs"].x, faction_upgrade_card_blue["aztecs"].y, faction_upgrade_card_blue["aztecs"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_blue.png')
faction_upgrade_card_blue["hre"].x, faction_upgrade_card_blue["hre"].y, faction_upgrade_card_blue["hre"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["gundabad"].x, faction_upgrade_card_blue["gundabad"].y, faction_upgrade_card_blue["gundabad"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["portugal"].x, faction_upgrade_card_blue["portugal"].y, faction_upgrade_card_blue["portugal"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["spain"].x, faction_upgrade_card_blue["spain"].y, faction_upgrade_card_blue["spain"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_blue.png')
faction_upgrade_card_blue["khand"].x, faction_upgrade_card_blue["khand"].y, faction_upgrade_card_blue["khand"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_blue.png')
faction_upgrade_card_blue["russia"].x, faction_upgrade_card_blue["russia"].y, faction_upgrade_card_blue["russia"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_blue.png')
faction_upgrade_card_blue["papal_states"].x, faction_upgrade_card_blue["papal_states"].y, faction_upgrade_card_blue["papal_states"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["scripts"].x, faction_upgrade_card_blue["scripts"].y, faction_upgrade_card_blue["scripts"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["united"].x, faction_upgrade_card_blue["united"].y, faction_upgrade_card_blue["united"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
faction_upgrade_card_blue["slave"].x, faction_upgrade_card_blue["slave"].y, faction_upgrade_card_blue["slave"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_blue.png')
    faction_upgrade_card_blue["egypt"].x, faction_upgrade_card_blue["egypt"].y, faction_upgrade_card_blue["egypt"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_blue.png')

    faction_upgrade_card_bw["hungary"].x, faction_upgrade_card_bw["hungary"].y, faction_upgrade_card_bw["hungary"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_bw.png')
faction_upgrade_card_bw["denmark"].x, faction_upgrade_card_bw["denmark"].y, faction_upgrade_card_bw["denmark"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bw.png')
faction_upgrade_card_bw["milan"].x, faction_upgrade_card_bw["milan"].y, faction_upgrade_card_bw["milan"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\rohan_bw.png')
faction_upgrade_card_bw["normans"].x, faction_upgrade_card_bw["normans"].y, faction_upgrade_card_bw["normans"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["turks"].x, faction_upgrade_card_bw["turks"].y, faction_upgrade_card_bw["turks"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dunedain_bw.png')
faction_upgrade_card_bw["scotland"].x, faction_upgrade_card_bw["scotland"].y, faction_upgrade_card_bw["scotland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bw.png')
faction_upgrade_card_bw["timurids"].x, faction_upgrade_card_bw["timurids"].y, faction_upgrade_card_bw["timurids"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bw.png')
faction_upgrade_card_bw["byzantium"].x, faction_upgrade_card_bw["byzantium"].y, faction_upgrade_card_bw["byzantium"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bw.png')
faction_upgrade_card_bw["moors"].x, faction_upgrade_card_bw["moors"].y, faction_upgrade_card_bw["moors"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_bw.png')
faction_upgrade_card_bw["sicily"].x, faction_upgrade_card_bw["sicily"].y, faction_upgrade_card_bw["sicily"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bw.png')
faction_upgrade_card_bw["norway"].x, faction_upgrade_card_bw["norway"].y, faction_upgrade_card_bw["norway"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\dwarves_bw.png')
faction_upgrade_card_bw["saxons"].x, faction_upgrade_card_bw["saxons"].y, faction_upgrade_card_bw["saxons"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bw.png')
faction_upgrade_card_bw["ireland"].x, faction_upgrade_card_bw["ireland"].y, faction_upgrade_card_bw["ireland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bw.png')
faction_upgrade_card_bw["mongols"].x, faction_upgrade_card_bw["mongols"].y, faction_upgrade_card_bw["mongols"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bw.png')
faction_upgrade_card_bw["teutonic_order"].x, faction_upgrade_card_bw["teutonic_order"].y, faction_upgrade_card_bw["teutonic_order"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bw.png')
faction_upgrade_card_bw["venice"].x, faction_upgrade_card_bw["venice"].y, faction_upgrade_card_bw["venice"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_bw.png')
faction_upgrade_card_bw["england"].x, faction_upgrade_card_bw["england"].y, faction_upgrade_card_bw["england"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["poland"].x, faction_upgrade_card_bw["poland"].y, faction_upgrade_card_bw["poland"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["france"].x, faction_upgrade_card_bw["france"].y, faction_upgrade_card_bw["france"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\isengard_bw.png')
faction_upgrade_card_bw["aztecs"].x, faction_upgrade_card_bw["aztecs"].y, faction_upgrade_card_bw["aztecs"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bw.png')
faction_upgrade_card_bw["hre"].x, faction_upgrade_card_bw["hre"].y, faction_upgrade_card_bw["hre"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["gundabad"].x, faction_upgrade_card_bw["gundabad"].y, faction_upgrade_card_bw["gundabad"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["portugal"].x, faction_upgrade_card_bw["portugal"].y, faction_upgrade_card_bw["portugal"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["spain"].x, faction_upgrade_card_bw["spain"].y, faction_upgrade_card_bw["spain"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_bw.png')
faction_upgrade_card_bw["khand"].x, faction_upgrade_card_bw["khand"].y, faction_upgrade_card_bw["khand"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\southron_bw.png')
faction_upgrade_card_bw["russia"].x, faction_upgrade_card_bw["russia"].y, faction_upgrade_card_bw["russia"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\northmen_bw.png')
faction_upgrade_card_bw["papal_states"].x, faction_upgrade_card_bw["papal_states"].y, faction_upgrade_card_bw["papal_states"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["scripts"].x, faction_upgrade_card_bw["scripts"].y, faction_upgrade_card_bw["scripts"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["united"].x, faction_upgrade_card_bw["united"].y, faction_upgrade_card_bw["united"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
faction_upgrade_card_bw["slave"].x, faction_upgrade_card_bw["slave"].y, faction_upgrade_card_bw["slave"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\orc_bw.png')
    faction_upgrade_card_bw["egypt"].x, faction_upgrade_card_bw["egypt"].y, faction_upgrade_card_bw["egypt"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\upgrade_card\\elves_bw.png')

    ---------------
    
    faction_bu["northern_european"].x, faction_bu["northern_european"].y, faction_bu["northern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\northern_european_bu.png')

faction_bu["eastern_european"].x, faction_bu["eastern_european"].y, faction_bu["eastern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\eastern_european_bu.png')

faction_bu["gondor"].x, faction_bu["gondor"].y, faction_bu["gondor"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\gondor_bu.png')

faction_bu["greek"].x, faction_bu["greek"].y, faction_bu["greek"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\greek_bu.png')

    faction_bu["noldor"].x, faction_bu["noldor"].y, faction_bu["noldor"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\Noldor_bu.png')

faction_bu["mesoamerican"].x, faction_bu["mesoamerican"].y, faction_bu["mesoamerican"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\mesoamerican_bu.png')

faction_bu["middle_eastern"].x, faction_bu["middle_eastern"].y, faction_bu["middle_eastern"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\middle_eastern_bu.png')

faction_bu["southern_european"].x, faction_bu["southern_european"].y, faction_bu["southern_european"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\southern_european_bu.png')

    faction_bu["crags"].x, faction_bu["crags"].y, faction_bu["crags"].img =
    M2TWEOP.loadTexture(M2TWEOP.getModPath() .. '\\eopData\\images\\crags_bu.png')

    minus.x, minus.y, minus.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\minus.png')
    plus.x, plus.y, plus.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\plus.png')
    leg_text.x, leg_text.y, leg_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\leg_text.png')
    revival_text.x, revival_text.y, revival_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\revival_text.png')
    battle_text.x, battle_text.y, battle_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\battle_text.png')
    chrisset_text.x, chrisset_text.y, chrisset_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\chrisset_text.png')
    sort_text.x, sort_text.y, sort_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sort_text.png')
    misc_text.x, misc_text.y, misc_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\misc_text.png')
    rep_text.x, rep_text.y, rep_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\rep_text.png')
    u_text.x, u_text.y, u_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\u_text.png')
    gu_text.x, gu_text.y, gu_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\gu_text.png')
    global_text.x, global_text.y, global_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\global_text.png')
    welcome_beta.x, welcome_beta.y, welcome_beta.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\welcome_beta.png')

    pip_dwarves.x, pip_dwarves.y, pip_dwarves.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_dwarves.tga')
    pip_elvish.x, pip_elvish.y, pip_elvish.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_elvish.tga')
    pip_evil.x, pip_evil.y, pip_evil.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_evil.tga')
    pip_kings.x, pip_kings.y, pip_kings.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_kings.tga')
    pip_middlemen.x, pip_middlemen.y, pip_middlemen.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_middlemen.tga')
    pip_nomadic.x, pip_nomadic.y, pip_nomadic.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_nomadic.tga')
    pip_northmen.x, pip_northmen.y, pip_northmen.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_northmen.tga')
    pip_numenorian.x, pip_numenorian.y, pip_numenorian.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_numenorian.tga')
    pip_religious_unrest.x, pip_religious_unrest.y, pip_religious_unrest.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_religious_unrest.tga')
    pip_rohirrim.x, pip_rohirrim.y, pip_rohirrim.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_rohirrim.tga')
    pip_uruk.x, pip_uruk.y, pip_uruk.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_uruk.tga')
    pip_wicked.x, pip_wicked.y, pip_wicked.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_wicked.tga')
    pip_wicked2.x, pip_wicked2.y, pip_wicked2.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pips\\pip_wicked2.tga')

    culture_ui_stuff = {
        catholic = { name = "Melkor's Shadow", img = pip_evil.img },
        dwarven  = { name = "Dwarven",         img = pip_dwarves.img },
        islam    = { name = "Dúnedain",        img = pip_numenorian.img },
        northmen = { name = "Northmen",        img = pip_northmen.img },
        elven    = { name = "Elven",           img = pip_elvish.img },
        wildmen  = { name = "Middlemen",       img = pip_middlemen.img },
        nomadic  = { name = "Nomadic",         img = pip_nomadic.img },
        heretic  = { name = "Others",          img = pip_uruk.img },
        orthodox = { name = "Men of the East", img = pip_wicked2.img },
        kings    = { name = "King's Men",      img = pip_kings.img },
    }

    koe_title.x, koe_title.y, koe_title.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\koe_title.png')
    kon_title.x, kon_title.y, kon_title.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\kon_title.png')
    kon_council_choice.x, kon_council_choice.y, kon_council_choice.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\kon_council_choice.jpg')
    eregion_rebellion_choice.x, eregion_rebellion_choice.y, eregion_rebellion_choice.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\eregion_rebellion_choice.jpg')
    kon_council_choice.x, kon_council_choice.y, kon_council_choice.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\kon_council_choice.jpg')
    imladris_kon_icon.x, imladris_kon_icon.y, imladris_kon_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\imladris_kon_icon.png')
    lindon_kon_icon.x, lindon_kon_icon.y, lindon_kon_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\lindon_kon_icon.png')
    imladris_icon.x, imladris_icon.y, imladris_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\imladris_icon.png')
    lindon_icon.x, lindon_icon.y, lindon_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\lindon_icon.png')
    coins.x, coins.y, coins.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\coins.png')
    replen.x, replen.y, replen.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\replen.png')
    upg_icon.x, upg_icon.y, upg_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\upg_icon.png')
    sdg_icon.x, sdg_icon.y, sdg_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sdg_icon.png')
    siege.x, siege.y, siege.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\siege.png')
    sword.x, sword.y, sword.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sword.png')
    hammer.x, hammer.y, hammer.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\hammer.png')
    unrest.x, unrest.y, unrest.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\unrest.png')
    pored.x, pored.y, pored.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pored.png')
    poblue.x, poblue.y, poblue.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\poblue.png')
    pogreen.x, pogreen.y, pogreen.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pogreen.png')
    poyellow.x, poyellow.y, poyellow.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\poyellow.png')
    sett_upgrade.x, sett_upgrade.y, sett_upgrade.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sett_upgrade.png')
    plague.x, plague.y, plague.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\plague.png')
    gov.x, gov.y, gov.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\gov.png')

    sword_gold.x,   sword_gold.y,   sword_gold.img   = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sword_gold.png')
    sword_silver.x, sword_silver.y, sword_silver.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sword_silver.png')
    sword_bronze.x, sword_bronze.y, sword_bronze.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sword_bronze.png')
    shield_gold.x,   shield_gold.y,   shield_gold.img   = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\shield_gold.png')
    shield_silver.x, shield_silver.y, shield_silver.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\shield_silver.png')
    shield_bronze.x, shield_bronze.y, shield_bronze.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\shield_bronze.png')
    chevron_gold.x,   chevron_gold.y,   chevron_gold.img   = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\chevron_gold.png')
    chevron_silver.x, chevron_silver.y, chevron_silver.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\chevron_silver.png')
    chevron_bronze.x, chevron_bronze.y, chevron_bronze.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\chevron_bronze.png')
    
    
    map1.x, map1.y, map1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\pp-me-newest-big.png')

    sortstack1.x, sortstack1.y, sortstack1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\sortstack1.png')
    bg_small_1.x, bg_small_1.y, bg_small_1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\bg_small_1.png')
    bg_1_new.x, bg_1_new.y, bg_1_new.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\bg_1_new.png')
    bg_1.x, bg_1.y, bg_1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\bg_1.png')
    bg_2.x, bg_2.y, bg_2.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\bg_2.png')
    bg_3_elven.x, bg_3_elven.y, bg_3_elven.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\bg_3_elven.png')
    bg_gondor_1.x, bg_gondor_1.y, bg_gondor_1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\gondor_1.png')
    scroll_bg.x, scroll_bg.y, scroll_bg.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\scroll_bg.png')
    button_01.x, button_01.y, button_01.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\button_01.png')
    button_02.x, button_02.y, button_02.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\button_02.png')
    seperator.x, seperator.y, seperator.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\seperator.png')

    speed_text.x, speed_text.y, speed_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\speed_text.png')
    credits_text.x, credits_text.y, credits_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\credits_text.png')
    welcome_text.x, welcome_text.y, welcome_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\welcome_text.png')
    revive_yes.x, revive_yes.y, revive_yes.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\revive_yes.png')
    revive_no.x, revive_no.y, revive_no.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\revive_no.png')
    fort.x, fort.y, fort.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\fort.png')
    fort_text.x, fort_text.y, fort_text.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\fort_text.png')
    fort_text_no.x, fort_text_no.y, fort_text_no.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\fort_text_no.png')
    eregion_icon.x, eregion_icon.y, eregion_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\eregion_icon.png')
    aa_icon.x, aa_icon.y, aa_icon.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\aa_icon.png')
    crown1.x, crown1.y, crown1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\crown1.png')
    stew1.x, stew1.y, stew1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\stew1.png')
    ship1.x, ship1.y, ship1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\ship1.png')
    crown1locked.x, crown1locked.y, crown1locked.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\crown1locked.png')
    stew1locked.x, stew1locked.y, stew1locked.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\stew1locked.png')
    ship1locked.x, ship1locked.y, ship1locked.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\ship1locked.png')
    bg_test.x, bg_test.y, bg_test.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\bg_test.png')
    bg_test2.x, bg_test2.y, bg_test2.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\bg_test2.png')
    icon_unit.x, icon_unit.y, icon_unit.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\icon_unit.png')
    icon_unit2.x, icon_unit2.y, icon_unit2.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\icon_unit2.png')
    icon_save.x, icon_save.y, icon_save.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\icon_save.png')
    icon_options.x, icon_options.y, icon_options.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\icon_options.png')
    test1.x, test1.y, test1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\test1.png')
    ent1.x, ent1.y, ent1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\ent1.png')
    eldarlight.x, eldarlight.y, eldarlight.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\eldarlight.png')
    mirror1.x, mirror1.y, mirror1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\mirror1.png')
    mirror2.x, mirror2.y, mirror2.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\mirror2.png')
    mirror3.x, mirror3.y, mirror3.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\mirror3.png')
    yavanna.x, yavanna.y, yavanna.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\yavanna.png')
    orome.x, orome.y, orome.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\orome.png')
    tulkas.x, tulkas.y, tulkas.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\tulkas.png')
    ulmo.x, ulmo.y, ulmo.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\ulmo.png')
    button1.x, button1.y, button1.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\button1.png')
    anor.x, anor.y, anor.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\anor.png')
    mengood_pic_0.x, mengood_pic_0.y, mengood_pic_0.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\mengood_pic_0.png')
    oatheorl.x, oatheorl.y, oatheorl.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\oatheorl.png')
    lordsgondor.x, lordsgondor.y, lordsgondor.img = M2TWEOP.loadTexture(M2TWEOP.getModPath()..'\\eopData\\images\\lordsgondor_2.png')

    EUR_EVENTS["ireland"][0].image = mirror1
    EUR_EVENTS["ireland"][1].image = yavanna
    EUR_EVENTS["ireland"][2].image = ent1
    EUR_EVENTS["ireland"][3].image = eldarlight

    EUR_EVENTS["mongols"][0].image = mirror1
    EUR_EVENTS["mongols"][1].image = yavanna
    EUR_EVENTS["mongols"][2].image = orome
    EUR_EVENTS["mongols"][3].image = eldarlight

    EUR_EVENTS["saxons"][0].image = test1
    EUR_EVENTS["saxons"][1].image = tulkas
    EUR_EVENTS["saxons"][2].image = yavanna
    EUR_EVENTS["saxons"][3].image = eldarlight

    EUR_EVENTS["denmark"][0].image = ulmo
    EUR_EVENTS["denmark"][1].image = yavanna
    EUR_EVENTS["denmark"][2].image = test1
    EUR_EVENTS["denmark"][3].image = eldarlight

    EUR_EVENTS["england"][0].image = test1
    EUR_EVENTS["england"][1].image = test1

    EUR_EVENTS["hre"][0].image = test1
    EUR_EVENTS["hre"][1].image = test1

    EUR_EVENTS["poland"][0].image = test1
    EUR_EVENTS["poland"][1].image = test1

    EUR_EVENTS["normans"][0].image = test1
    EUR_EVENTS["normans"][1].image = test1

    EUR_EVENTS["hungary"][0].image = test1

    EUR_EVENTS["norway"][0].image = test1

    EUR_EVENTS["moors"][0].image = test1

    EUR_EVENTS["sicily"][0].image = anor
    EUR_EVENTS["sicily"][1].image = mengood_pic_0
    EUR_EVENTS["sicily"][2].image = oatheorl
    EUR_EVENTS["sicily"][3].image = lordsgondor

    EUR_EVENTS["turks"][0].image = test1
    EUR_EVENTS["turks"][1].image = test1

    EUR_EVENTS["scotland"][0].image = test1
    EUR_EVENTS["scotland"][1].image = test1

    EUR_EVENTS["milan"][0].image = test1
    EUR_EVENTS["milan"][1].image = test1
    EUR_EVENTS["milan"][2].image = test1
--[[
    faction_events_text["milan"][FACTION_INFO_ROHAN_TITLE].img = faction_info_rohan.img
    faction_events_text["sicily"][FACTION_INFO_GONDOR_TITLE].img = faction_info_gondor.img
    faction_events_text["turks"][FACTION_INFO_ND_TITLE].img = faction_info_nd.img
    faction_events_text["russia"][UMBAR_START_TITLE].img = faction_info_aa.img
    faction_events_text["scotland"][FACTION_INFO_DALE_TITLE].img = faction_info_dale_sa.img
    faction_events_text["byzantium"][FACTION_INFO_DORWINION_TITLE].img = faction_info_dorwinion.img
    faction_events_text["timurids"][FACTION_INFO_ANDUIN_TITLE].img = faction_info_anduin.img
    faction_events_text["portugal"][FACTION_INFO_ANGMAR_TITLE].img = faction_info_angmar.img
    faction_events_text["aztecs"][FACTION_INFO_DUNLAND_TITLE].img = faction_info_dunland.img
    faction_events_text["teutonic_order"][FACTION_INFO_ENEDWAITH_TITLE].img = faction_info_enedwaith.img
    faction_events_text["spain"][FACTION_INFO_HARAD_TITLE].img = faction_info_harad.img
    faction_events_text["khand"][FACTION_INFO_KHAND_TITLE].img = faction_info_khand.img
    faction_events_text["venice"][FACTION_INFO_RHUN_TITLE].img = faction_info_rhun.img
    faction_events_text["moors"][FACTION_INFO_EREBOR_TITLE].img = faction_info_erebor.img
    faction_events_text["hungary"][FACTION_INFO_EL_TITLE].img = faction_info_el.img
    faction_events_text["norway"][FACTION_INFO_KD_TITLE].img = faction_info_kd.img
    faction_events_text["mongols"][FACTION_INFO_WR_TITLE].img = faction_info_wr.img
    faction_events_text["ireland"][FACTION_INFO_LORIEN_TITLE].img = faction_info_lorien.img
    faction_events_text["denmark"]["Faction Info: Lindon"].img = faction_info_he.img
    faction_events_text["england"][FACTION_INFO_MORDOR_TITLE].img = faction_info_mordor.img
    faction_events_text["poland"][FACTION_INFO_DG_TITLE].img = faction_info_dg.img
    faction_events_text["hre"][FACTION_INFO_MORIA_TITLE].img = faction_info_moria.img
    faction_events_text["gundabad"][FACTION_INFO_GUNDABAD_TITLE].img = faction_info_gundabad.img
    faction_events_text["france"][FACTION_INFO_ISENGARD_TITLE].img = faction_info_isengard.img
    faction_events_text["saxons"]["Faction Info: Imladris"].img = faction_info_he.img
]]
    for i = 0, 3 do
        glory_table[i].image = ship1.img
        glory_table[i].imagelocked = ship1locked.img
    end
    for i = 4, 6 do
        glory_table[i].image = stew1.img
        glory_table[i].imagelocked = stew1locked.img
    end
    for i = 7, 9 do
        glory_table[i].image = crown1.img
        glory_table[i].imagelocked = crown1locked.img
    end

    event_backgrounds = {
        ["milan"] = nil,
        ["sicily"] = bg_gondor_1.img,
        ["turks"] = nil,
        ["russia"] = nil,
        ["scotland"] = nil,
        ["byzantium"] = nil,
        ["timurids"] = nil,
        ["portugal"] = nil,
        ["aztecs"] = nil,
        ["teutonic_order"] = nil,
        ["spain"] = nil,
        ["khand"] = nil,
        ["venice"] = nil,
        ["norway"] = nil,
        ["hungary"] = nil,
        ["moors"] = nil,
        ["mongols"] = bg_3_elven.img,
        ["ireland"] = bg_3_elven.img,
        ["denmark"] = bg_3_elven.img,
        ["england"] = nil,
        ["poland"] = nil,
        ["hre"] = nil,
        ["gundabad"] = nil,
        ["france"] = nil,
        ["saxons"] = bg_3_elven.img,
        ["papal_states"] = nil,
        ["egypt"] = nil,
    }
    
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end

function unloadImages()
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."unloadImages");
	end

    if faction_info_aa.img then M2TWEOP.unloadTexture(faction_info_aa.img) end
    if faction_info_anduin.img then M2TWEOP.unloadTexture(faction_info_anduin.img) end
    if faction_info_angmar.img then M2TWEOP.unloadTexture(faction_info_angmar.img) end
    if faction_info_bree.img then M2TWEOP.unloadTexture(faction_info_bree.img) end
    if faction_info_da.img then M2TWEOP.unloadTexture(faction_info_da.img) end
    if faction_info_dale_sa.img then M2TWEOP.unloadTexture(faction_info_dale_sa.img) end
    if faction_info_dg.img then M2TWEOP.unloadTexture(faction_info_dg.img) end
    if faction_info_dorwinion.img then M2TWEOP.unloadTexture(faction_info_dorwinion.img) end
    if faction_info_dunland.img then M2TWEOP.unloadTexture(faction_info_dunland.img) end
    if faction_info_el.img then M2TWEOP.unloadTexture(faction_info_el.img) end
    if faction_info_enedwaith.img then M2TWEOP.unloadTexture(faction_info_enedwaith.img) end
    if faction_info_erebor.img then M2TWEOP.unloadTexture(faction_info_erebor.img) end
    if faction_info_gondor.img then M2TWEOP.unloadTexture(faction_info_gondor.img) end
    if faction_info_gundabad.img then M2TWEOP.unloadTexture(faction_info_gundabad.img) end
    if faction_info_harad.img then M2TWEOP.unloadTexture(faction_info_harad.img) end
    if faction_info_he.img then M2TWEOP.unloadTexture(faction_info_he.img) end
    if faction_info_isengard.img then M2TWEOP.unloadTexture(faction_info_isengard.img) end
    if faction_info_kd.img then M2TWEOP.unloadTexture(faction_info_kd.img) end
    if faction_info_khand.img then M2TWEOP.unloadTexture(faction_info_khand.img) end
    if faction_info_lorien.img then M2TWEOP.unloadTexture(faction_info_lorien.img) end
    if faction_info_mordor.img then M2TWEOP.unloadTexture(faction_info_mordor.img) end
    if faction_info_moria.img then M2TWEOP.unloadTexture(faction_info_moria.img) end
    if faction_info_nd.img then M2TWEOP.unloadTexture(faction_info_nd.img) end
    if faction_info_rhun.img then M2TWEOP.unloadTexture(faction_info_rhun.img) end
    if faction_info_rohan.img then M2TWEOP.unloadTexture(faction_info_rohan.img) end
    if faction_info_wr.img then M2TWEOP.unloadTexture(faction_info_wr.img) end
    
    if faction_bg["northern_european"].img then M2TWEOP.unloadTexture(faction_bg["northern_european"].img) end
    if faction_bg["eastern_european"].img then M2TWEOP.unloadTexture(faction_bg["eastern_european"].img) end
    if faction_bg["gondor"].img then M2TWEOP.unloadTexture(faction_bg["gondor"].img) end
    if faction_bg["greek"].img then M2TWEOP.unloadTexture(faction_bg["greek"].img) end
    if faction_bg["mesoamerican"].img then M2TWEOP.unloadTexture(faction_bg["mesoamerican"].img) end
    if faction_bg["middle_eastern"].img then M2TWEOP.unloadTexture(faction_bg["middle_eastern"].img) end
    if faction_bg["southern_european"].img then M2TWEOP.unloadTexture(faction_bg["southern_european"].img) end
    
    if faction_bu["northern_european"].img then M2TWEOP.unloadTexture(faction_bu["northern_european"].img) end
    if faction_bu["eastern_european"].img then M2TWEOP.unloadTexture(faction_bu["eastern_european"].img) end
    if faction_bu["gondor"].img then M2TWEOP.unloadTexture(faction_bu["gondor"].img) end
    if faction_bu["greek"].img then M2TWEOP.unloadTexture(faction_bu["greek"].img) end
    if faction_bu["mesoamerican"].img then M2TWEOP.unloadTexture(faction_bu["mesoamerican"].img) end
    if faction_bu["middle_eastern"].img then M2TWEOP.unloadTexture(faction_bu["middle_eastern"].img) end
    if faction_bu["southern_european"].img then M2TWEOP.unloadTexture(faction_bu["southern_european"].img) end
    
    if replen.img then M2TWEOP.unloadTexture(replen.img) end
    if siege.img then M2TWEOP.unloadTexture(siege.img) end
    if sword.img then M2TWEOP.unloadTexture(sword.img) end
    if hammer.img then M2TWEOP.unloadTexture(hammer.img) end
    if unrest.img then M2TWEOP.unloadTexture(unrest.img) end
    if pored.img then M2TWEOP.unloadTexture(pored.img) end
    if poblue.img then M2TWEOP.unloadTexture(poblue.img) end
    if pogreen.img then M2TWEOP.unloadTexture(pogreen.img) end
    if poyellow.img then M2TWEOP.unloadTexture(poyellow.img) end
    if sett_upgrade.img then M2TWEOP.unloadTexture(sett_upgrade.img) end
    if plague.img then M2TWEOP.unloadTexture(plague.img) end
    if gov.img then M2TWEOP.unloadTexture(gov.img) end
    
    if map1.img then M2TWEOP.unloadTexture(map1.img) end
    
    if sortstack1.img then M2TWEOP.unloadTexture(sortstack1.img) end
    if bg_small_1.img then M2TWEOP.unloadTexture(bg_small_1.img) end
    if bg_1_new.img then M2TWEOP.unloadTexture(bg_1_new.img) end
    if bg_1.img then M2TWEOP.unloadTexture(bg_1.img) end
    if bg_2.img then M2TWEOP.unloadTexture(bg_2.img) end
    if bg_3_elven.img then M2TWEOP.unloadTexture(bg_3_elven.img) end
    if bg_gondor_1.img then M2TWEOP.unloadTexture(bg_gondor_1.img) end
    if scroll_bg.img then M2TWEOP.unloadTexture(scroll_bg.img) end
    if button_01.img then M2TWEOP.unloadTexture(button_01.img) end
    if button_02.img then M2TWEOP.unloadTexture(button_02.img) end
    if seperator.img then M2TWEOP.unloadTexture(seperator.img) end
    
    if aa_icon.img then M2TWEOP.unloadTexture(aa_icon.img) end
    if crown1.img then M2TWEOP.unloadTexture(crown1.img) end
    if stew1.img then M2TWEOP.unloadTexture(stew1.img) end
    if ship1.img then M2TWEOP.unloadTexture(ship1.img) end
    if crown1locked.img then M2TWEOP.unloadTexture(crown1locked.img) end
    if stew1locked.img then M2TWEOP.unloadTexture(stew1locked.img) end
    if ship1locked.img then M2TWEOP.unloadTexture(ship1locked.img) end
    if bg_test.img then M2TWEOP.unloadTexture(bg_test.img) end
    if bg_test2.img then M2TWEOP.unloadTexture(bg_test2.img) end
    if icon_unit.img then M2TWEOP.unloadTexture(icon_unit.img) end
    if icon_save.img then M2TWEOP.unloadTexture(icon_save.img) end
    if icon_options.img then M2TWEOP.unloadTexture(icon_options.img) end
    if test1.img then M2TWEOP.unloadTexture(test1.img) end
    if ent1.img then M2TWEOP.unloadTexture(ent1.img) end
    if eldarlight.img then M2TWEOP.unloadTexture(eldarlight.img) end
    if mirror1.img then M2TWEOP.unloadTexture(mirror1.img) end
    if mirror2.img then M2TWEOP.unloadTexture(mirror2.img) end
    if mirror3.img then M2TWEOP.unloadTexture(mirror3.img) end
    if yavanna.img then M2TWEOP.unloadTexture(yavanna.img) end
    if orome.img then M2TWEOP.unloadTexture(orome.img) end
    if tulkas.img then M2TWEOP.unloadTexture(tulkas.img) end
    if ulmo.img then M2TWEOP.unloadTexture(ulmo.img) end
    if button1.img then M2TWEOP.unloadTexture(button1.img) end
    if anor.img then M2TWEOP.unloadTexture(anor.img) end
    if mengood_pic_0.img then M2TWEOP.unloadTexture(mengood_pic_0.img) end
    if oatheorl.img then M2TWEOP.unloadTexture(oatheorl.img) end
    if lordsgondor.img then M2TWEOP.unloadTexture(lordsgondor.img) end

-- Unload building construction pictures from eur_tga_table_bu
for buildingName, textureData in pairs(eur_tga_table_bu) do
    if textureData.img then
        M2TWEOP.unloadTexture(textureData.img)
    end
end

-- Unload settlement pictures from core_sett_pics
for cultureName, settTable in pairs(core_sett_pics) do
    for settName, textureData in pairs(settTable) do
        if textureData.img then
            M2TWEOP.unloadTexture(textureData.img)
        end
    end
end

-- Unload unit card pictures from eur_tga_table
for unitCard, textureData in pairs(eur_tga_table) do
    if textureData.img then
        M2TWEOP.unloadTexture(textureData.img)
    end
end

    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end




