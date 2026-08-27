
cas_set_already = {}
cas_standalone_set_already = false

function loadCharCAS()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."loadCharCAS");
	end
    if file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\tauriel.cas") and
    file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\textures\\tauriel_body_diff.tga") then
        M2TW.campaign.addCharacterCas(
        "strat_named_with_army",
        "mods/Divide_and_Conquer_EUR/data/models_strat/tauriel.cas",
        "mods/Divide_and_Conquer_EUR/data/models_strat/tauriel.cas",
        "tauriel",
        "mods/Divide_and_Conquer_EUR/data/models_strat/textures/tauriel_body_diff.tga",
        0.7
        )
        custom_cas.tauriel = true
        print("tauriel loaded")
    end
    if file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\galadriel.cas") and
    file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\textures\\galadriel.tga") then
        M2TW.campaign.addCharacterCas(
        "strat_named_with_army",
        "mods/Divide_and_Conquer_EUR/data/models_strat/galadriel.cas",
        "mods/Divide_and_Conquer_EUR/data/models_strat/galadriel.cas",
        "galadriel",
        "mods/Divide_and_Conquer_EUR/data/models_strat/textures/galadriel.tga",
        0.7
        )
        custom_cas.galadriel = true
        print("galadriel loaded")
    end
    if file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\noldor_general.cas") and
    file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\textures\\noldor_general.tga") then
        M2TW.campaign.addCharacterCas(
        "strat_named_with_army",
        "mods/Divide_and_Conquer_EUR/data/models_strat/noldor_general.cas",
        "mods/Divide_and_Conquer_EUR/data/models_strat/noldor_general.cas",
        "noldor_general",
        "mods/Divide_and_Conquer_EUR/data/models_strat/textures/noldor_general.tga",
        0.7
        )
        custom_cas.noldor_general = true
        print("noldor general loaded")
    end
    if file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\noldor_captain.cas") and
    file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\textures\\noldor_general.tga") then
        M2TW.campaign.addCharacterCas(
        "strat_named_with_army",
        "mods/Divide_and_Conquer_EUR/data/models_strat/noldor_captain.cas",
        "mods/Divide_and_Conquer_EUR/data/models_strat/noldor_captain.cas",
        "noldor_captain",
        "mods/Divide_and_Conquer_EUR/data/models_strat/textures/noldor_general.tga",
        0.7
        )
        custom_cas.noldor_captain = true
        print("noldor captian loaded")
    end

    if file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\sharku.cas") and
    file_exists(M2TWEOP.getModPath().."\\data\\models_strat\\textures\\sharku.tga") then
        M2TW.campaign.addCharacterCas(
        "strat_named_with_army",
        "mods/Divide_and_Conquer_EUR/data/models_strat/sharku.cas",
        "mods/Divide_and_Conquer_EUR/data/models_strat/sharku.cas",
        "sharku",
        "mods/Divide_and_Conquer_EUR/data/models_strat/textures/sharku.tga",
        0.7
        )
        custom_cas.sharku = true
        print("sharku loaded")
    end
    if to_log then
        M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
    end
end

function loadStratCAS()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."loadCharCAS");
	end
    for i = 1, #strat_models do
        if strat_models[i] ~= "" then
            M2TWEOP.addModelToGame("data/models_strat/residences/"..strat_models[i], i)
        end
    end
    if to_log then
        M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
    end
end

function setCasStandalone()
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."setCasStandalone");
	end
    for k, v in pairs(strat_cas_standalone) do
        if v.appearing then
            M2TW.stratMap.startDrawModelAt(v.modelID, v.xCoord, v.yCoord, v.scale)
        end
    end
    for k, v in pairs(strat_cas_setts) do
        local sett = eur_sMap:getSettlement(k)
        if sett ~= nil then
            M2TWEOP.setModel(sett.xCoord,sett.yCoord,strat_cas_setts[sett.name],strat_cas_setts[sett.name])
        end
    end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT END: "..tostring(os.clock()).."setCasStandalone");
	end
end

function setCasSett(sett)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."setCasSett");
	end
    if sett ~= nil then
        M2TWEOP.setModel(sett.xCoord,sett.yCoord,strat_cas_setts[sett.name],strat_cas_setts[sett.name])
        --print(sett.xCoord,sett.yCoord,strat_cas_setts[sett.name],strat_cas_setts[sett.name])
        --print("sett model test: "..sett.name, sett.xCoord, sett.yCoord)
    end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT END: "..tostring(os.clock()).."setCasSett");
	end
end

good_factions = {
	"byzantium",
	"denmark",
	"hungary",
	"ireland",
	"milan",
	"mongols",
	"moors",
	"norway",
	"saxons",
	"scotland",
	"sicily",
	"teutonic_order",
	"timurids",
	"turks",
}

elf_factions = {
	"denmark",
	"ireland",
	"mongols",
	"saxons",
}

evil_factions = {
	"england",
	"france",
	"gundabad",
	"hre",
	"normans",
	"poland",
	"portugal",
}

caras_galadhon_corrupted_body = [[The heart of the Golden Realm has fallen… The lands of the Galadhrim, having long stood defiant against the encroaching darkness, are drowned beneath the tide of the Servants of Evil. The ageless boughs, and the filtered golden shade, are new hewn and burn the ground the black of orc blood. Even if it is retaken, it shall never be the same…]]
caras_galadhon_corrupted_title = [[Caras Galadhon in flames!]]
--note if any evil faction takes CG it will change to a ruined model and some of the trees around the settlement will die

helms_deep_corrupted_body = [[The Fires of Industry have claimed Helm’s Deep. Long has the Deeping Wall stood as a redoubt against those who would kill the sons of the Hammerhand. Now, the wall is studded with steel, and the craft of Saruman set into the very stone. Ost-Curunír he calls it, for it has become his fortress, and crown jewel. A symbol of hope for the Eoreds now a permanent reminder of their failures, and Saruman’s ascendancy!]]
helms_deep_corrupted_title = [[The Deeping Wall is broken!]]
--note Isengard can corrupt Helms deep, changes strat model to dark colour and name to Ost-Curunír

anorien_corrupted_body = [[Tragedy! The Tower of Guard burns. The people flee in a tide of stinking fear to the upper levels, and everywhere are pursued by the Armies of Shadow. The Steward’s whereabouts are unknown, and it is said that the White Tree was set aflame by the jeering foes of the line of Anarion. The last of the great bastions of the Numenorean exiles stands now as a dark pit of slavery and torment, and the people of Gondor wonder if there shall ever be a new dawn for Men.]]
anorien_corrupted_title = [[The White Tree burns!]]
--note if Mordor holds Minas Tirith, Cair Andros and both Osgiliaths the models of all four will swap to evil versions, Minas Tirith renames to Amon Dûr

anorien_cleansed_body = [[The streets of Minas Tirith are filled with cheers, for the White City has been reclaimed from the Armies of Shadow. Those who survived the revels of the City’s conquest are now liberated from their slavery, and stand newly defiant against the Shadow in the East. Already, the wrath of the Edain surges to avenge the fallen, and a glimmer of hope dawns, for the White Tree shows a solitary bud, defiant against the flames which marred it.]]
anorien_cleansed_title = [[The Tower of Guard reclaimed!]]
--note Gondor and ND can change Anorien back to the original name and models

isengard_cleansed_body = [[The gauntleted fist of the White Hand, Isengard, has fallen to the Free Peoples of Middle-Earth. The Ancient fortress of Angrenost and the Orthanc Stone within, were bequeathed to Saruman the White by the King of Rohan and Steward of Gondor when he returned from his pilgrimage through the Far East. Following the Treason of Saruman the White, the land was scarred, and pits were dug as the Wizard began working in service to the Shadow in the East. No longer is this the Vale of the Wizard! Now, the fortress, and the great tower of Orthanc in its heart, will once again be a shield to guard the fords of Isen. Even now, the Ents have shepherd many young and lively trees to reclaim the ruined ground, and the Isen once again flows.]]
isengard_cleansed_title = [[Nature reclaims Angrenost!]]
--note if any good faction takes Isengard it changes to a nicer model with trees and stuff

amon_sul_restored_body = [[Amon Sûl, the ruined watchtower of Elendil the Tall, stands as warden over Arnor’s northernmost borders once again! Though its Palantir still rests at the bottom of the Bay of Forochel, the beacon flame blazes defiant against the darkness that had long threatened these lands, and is a symbol of the renewed strength of Arnor! The Kingdom of the North is no longer blind, and its people shall always be protected by the light of the Dúnedain.]]
amon_sul_restored_title = [[Amon Sûl rebuilt!]]
--note after ND restore Arnor Amon Sul is automatically rebuilt with new model

tharbad_restored_body = [[Once a trade city to rival Pelargir, and Umbar, Tharbad was abandoned to the tribesmen by Gondor when it began to wane. Yet, that time has passed, the descendants of Numenor have restored the city’s walls, the Bridge of Tharbad once again spans the Gwathlo, and the river is a restored avenue of trade for the City’s Lords.]]
tharbad_restored_title = [[Tharbad restored!]]
--note NS, Gondor and AA can restore Tharbad after building the restored bridge, changes the strat model

amon_lanc_cleansed_body = [[The Naked Hill has been snatched from the grasp of Sauron’s Servants and purified of the foul corruption of the Dark Lord. It is no longer a haven of Necromancers and orcs, its dark altars have been cast down, and the light of the Eldar returns to its ancient bastion. Amon Lanc stands as a blazing, defiant, beacon against the joint shadows of Mirkwood and Mordor, and the Free Peoples know now that the Lady of Lorien stands alongside them.]]
amon_lanc_cleansed_title = [[Dol Guldur cleansed!]]
--note any elven faction can cleanse Dol Guldur, renames to Amon Lanc and changes strat model

minas_ithil_cleansed_body = [[Minas Morgul, long coveted and held by the Witch King of Angmar, in service to the Dark Tower, has been cleansed of the filth that long marred the Moon Tower of Isildur. The descendants of the Realms in Exile have long wished to revenge themselves for the loss of Minas Anor’s sister city, and now their voices are raised in triumph. The Shadow is broken! The Bulwarks of the Black Land fall, and for the first time since Sauron returned to Mordor, we have hope that this terrible war may soon end.]]
minas_ithil_cleansed_title = [[Minas Ithil scoured!]]
--note gondor / ND can cleanse Minas Ithil, same mechanic as previous versions

anorien_swap = {
    anorien_good = true,
    mordor_takeover = false,
    gondor_takeover = false,
    mordor_timer = 5,
    gondor_timer = 5,
    isengard_good = false,
    isengard_takeover = false,
    isengard_timer = 5,
    dg_good = false,
    dg_takeover = false,
    dg_timer = 5,
    helm_good = true,
    helm_takeover = false,
    helm_timer = 5,
    minasmorgul_good = false,
    minasmorgul_takeover = false,
    minasmorgul_timer = 5,
    carasg_good = true,
    carasg_takeover = false,
    carasg_timer = 5,
    tharbad_restored = false, 
    amonsul_restored =  false,
    tauriel_spawned = false,
    galadriel_spawned = false,
    NDCASset = false,
    sharku_spawned = false,
}

function isengardSwapCheck(faction)
    if faction.name == "slave" then
        if not anorien_swap.isengard_good then
            if not tableContains(evil_factions, eur_sMap:getSettlement("Nan_Curunir").ownerFaction.name) then
                anorien_swap.isengard_takeover = true
                if anorien_swap.isengard_timer == 1 then
                    --eur_sMap:getSettlement("Anorien").localizedName = "Amon Dûr"
                    M2TWEOP.setModel(224,279,17,17)  -- Isengard
                    custom_maps[string.format("%d,%d", 224, 279)] = 'isengard_ag'
                    stratmap.game.historicEvent("isengard_cleansed", isengard_cleansed_title, isengard_cleansed_body)
                    anorien_swap.isengard_takeover =  false
                    anorien_swap.isengard_good = true
                    anorien_swap.isengard_timer = 5
                else
                    anorien_swap.isengard_timer = anorien_swap.isengard_timer - 1
                end
            else
                anorien_swap.isengard_takeover =  false
                anorien_swap.isengard_timer = 5
            end
        end
    end
end

function amonlancSwapCheck(faction)
    if faction.name == "slave" then
        if not anorien_swap.dg_good then
            if tableContains(elf_factions, eur_sMap:getSettlement("Deep_Mirkwood").ownerFaction.name) then
                anorien_swap.dg_takeover = true
                if anorien_swap.dg_timer == 1 then
                    eur_sMap:getSettlement("Deep_Mirkwood").localizedName = "Amon Lanc"
                    M2TWEOP.setScriptCounter("lanc_cleared", 1) 
                    M2TWEOP.setModel(299, 329,24,24)  -- Isengard
                    --[string.format("%d,%d", 299, 329)] = 'isengard_ag'
                    stratmap.game.historicEvent("amon_lanc_cleansed", amon_lanc_cleansed_title, amon_lanc_cleansed_body)
                    anorien_swap.dg_takeover =  false
                    anorien_swap.dg_good = true
                    anorien_swap.dg_timer = 5
                else
                    anorien_swap.dg_timer = anorien_swap.dg_timer - 1
                end
            else
                anorien_swap.dg_takeover =  false
                anorien_swap.dg_timer = 5
            end
        end
    end
end

function helmSwapCheck(faction)
    if faction.name == "slave" then
        if anorien_swap.helm_good then
            if eur_sMap:getSettlement("Helms_Deep").ownerFaction.name == "france" then
                anorien_swap.helm_takeover = true
                if anorien_swap.helm_timer == 1 then
                    eur_sMap:getSettlement("Helms_Deep").localizedName = "Ost-Curunír"
                    M2TWEOP.setModel(230, 260,33,33)  -- Helms Deep
                    --[string.format("%d,%d", 299, 329)] = 'isengard_ag'
                    stratmap.game.historicEvent("helms_deep_corrupted", helms_deep_corrupted_title, helms_deep_corrupted_body)
                    anorien_swap.helm_takeover =  false
                    anorien_swap.helm_good = false
                    anorien_swap.helm_timer = 5
                else
                    anorien_swap.helm_timer = anorien_swap.helm_timer - 1
                end
            else
                anorien_swap.helm_takeover =  false
                anorien_swap.helm_timer = 5
            end
        end
    end
end

function carasSwapCheck(faction)
    if faction.name == "slave" then
        if not anorien_swap.carasg_good then
            if tableContains(evil_factions, eur_sMap:getSettlement("Celebrant").ownerFaction.name) then
                anorien_swap.carasg_takeover = true
                if anorien_swap.carasg_timer == 1 then
                    --eur_sMap:getSettlement("Celebrant").localizedName = "Minas Ithil"
                    M2TWEOP.setModel(268,327,31,31)  -- Isengard
                    --custom_maps[string.format("%d,%d", 339, 221)] = 'Minas Ithil'
                    stratmap.game.historicEvent("caras_galadhon_corrupted", caras_galadhon_corrupted_title, caras_galadhon_corrupted_body)
                    anorien_swap.carasg_takeover =  false
                    anorien_swap.carasg_good = true
                    anorien_swap.carasg_timer = 5
                else
                    anorien_swap.carasg_timer = anorien_swap.carasg_timer - 1
                end
            else
                anorien_swap.carasg_takeover =  false
                anorien_swap.carasg_timer = 5
            end
        end
    end
end

function minasIthilSwapCheck(faction)
    if faction.name == "slave" then
        if not anorien_swap.minasmorgul_good then
            if eur_sMap:getSettlement("Morgul_Vale").ownerFaction.name == "sicily" or eur_sMap:getSettlement("Morgul_Vale").ownerFaction.name == "turks" or eur_sMap:getSettlement("Morgul_Vale").ownerFaction.name == "russia"  then
                anorien_swap.minasmorgul_takeover = true
                if anorien_swap.minasmorgul_timer == 1 then
                    eur_sMap:getSettlement("Morgul_Vale").localizedName = "Minas Ithil"
                    M2TWEOP.setModel(339,221,18,18)  -- Isengard
                    custom_maps[string.format("%d,%d", 339, 221)] = 'Minas Ithil'
                    stratmap.game.historicEvent("minas_ithil_cleansed", minas_ithil_cleansed_title, minas_ithil_cleansed_body)
                    anorien_swap.minasmorgul_takeover =  false
                    anorien_swap.minasmorgul_good = true
                    anorien_swap.minasmorgul_timer = 5
                else
                    anorien_swap.minasmorgul_timer = anorien_swap.minasmorgul_timer - 1
                end
            else
                anorien_swap.minasmorgul_takeover =  false
                anorien_swap.minasmorgul_timer = 5
            end
        end
    end
end

function tharbadSwapCheck(faction)
    if faction.name == "slave" then
        if not anorien_swap.tharbad_restored then
            local tharbad = eur_sMap:getSettlement("Tharbad")
            if tharbad.ownerFaction.name == "turks" or tharbad.ownerFaction.name == "sicily" or tharbad.ownerFaction.name == "russia" or tharbad.ownerFaction.name == "teutonic_order" then
                if tharbad:buildingPresentMinLevel("rebuilt_bridge", true) then
                    strat_cas_setts["Tharbad"] = 8
                    strat_cas_setts["Ettenmoors"] = 9
                    M2TWEOP.setModel(186,333,8,8)  -- tharbad_north_a
                    M2TWEOP.setModel(188,333,9,9)  -- tharbad_south_a
                    custom_maps[string.format("%d,%d", 188, 333)] = 'osgiliath_east_repaired_a'
                    custom_maps[string.format("%d,%d", 186, 333)] = 'osgiliath_west_repaired_a'
                    stratmap.game.historicEvent("tharbad_rebuilt", tharbad_restored_title, tharbad_restored_body)
                    anorien_swap.tharbad_restored = true
                end
            end
        end
    end
end

function amonSulSwapCheck(faction)
    if faction.name == "slave" then
        if not anorien_swap.amonsul_restored then
            local Weather_Hills = eur_sMap:getSettlement("Weather_Hills")
            if Weather_Hills.ownerFaction.name == "turks" or Weather_Hills.ownerFaction.name == "sicily" or Weather_Hills.ownerFaction.name == "russia" then
                if checkCounter("arnor_restored") then
                    strat_cas_setts["Weather_Hills"] = 46
                    M2TWEOP.setModel(194,380,46,46)  -- Weather_Hills
                    stratmap.game.historicEvent("amon_sul_rebuilt", amon_sul_restored_title, amon_sul_restored_body)
                    anorien_swap.amonsul_restored = true
                end
            end
        end
    end
end

function mordorAnorienCheck(faction)
    if faction.name == "england" then
        if anorien_swap.anorien_good then
            if eur_sMap:getSettlement("Anorien").ownerFaction.name == "england" and
                eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "england" and
                eur_sMap:getSettlement("West_Osgiliath").ownerFaction.name == "england" and
                eur_sMap:getSettlement("Cair_Andros").ownerFaction.name == "england" then
                    anorien_swap.gondor_takeover =  false
                    anorien_swap.gondor_timer = 5
                    anorien_swap.mordor_takeover =  true
                    if anorien_swap.mordor_timer == 1 then
                        eur_sMap:getSettlement("Anorien").localizedName = "Amon Dûr"
                        M2TWEOP.setModel(324,217,34,34)  -- Minas Tirith
                        M2TWEOP.setModel(328,219,36,36)  -- W Osgiliath
                        M2TWEOP.setModel(330,219,32,32)  -- E Osgiliath
                        M2TWEOP.setModel(327,229,30,30)  -- Cair Andros

                        custom_maps[string.format("%d,%d", 330, 219)] = 'osgiliath_east_aev'    --(Osgiliath_E_EVIL)
                        custom_maps[string.format("%d,%d", 328, 219)] = 'osgiliath_west_aev'    --(Osgiliath_W_EVIL)
                        custom_maps[string.format("%d,%d", 324, 217)] = 'minas_tirith_aev'      --(Minas_Tirith_EVIL)
                        custom_maps[string.format("%d,%d", 327, 229)] = 'cair_andros_aev'       --(Cair_Andros_EVIL)
                        stratmap.game.historicEvent("anorien_corrupted", anorien_corrupted_title, anorien_corrupted_body)
                        anorien_swap.mordor_takeover =  false
                        anorien_swap.anorien_good = false
                        anorien_swap.mordor_timer = 5
                    else
                        anorien_swap.mordor_timer = anorien_swap.mordor_timer - 1
                    end
                else
                    anorien_swap.mordor_takeover =  false
                    anorien_swap.mordor_timer = 5
            end
        end
    elseif faction.name == "sicily" then
        if not anorien_swap.anorien_good then
            if (eur_sMap:getSettlement("Anorien").ownerFaction.name == "sicily" or eur_sMap:getSettlement("Anorien").ownerFaction.name == "turks" or eur_sMap:getSettlement("Anorien").ownerFaction.name == "russia" ) and
            (eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "sicily" or eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "turks" or eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "russia" ) and
            (eur_sMap:getSettlement("West_Osgiliath").ownerFaction.name == "sicily" or eur_sMap:getSettlement("West_Osgiliath").ownerFaction.name == "turks" or eur_sMap:getSettlement("West_Osgiliath").ownerFaction.name == "russia" ) and
            (eur_sMap:getSettlement("Cair_Andros").ownerFaction.name == "sicily" or eur_sMap:getSettlement("Cair_Andros").ownerFaction.name == "turks" or eur_sMap:getSettlement("Cair_Andros").ownerFaction.name == "russia" ) then
                    anorien_swap.mordor_takeover =  false
                    anorien_swap.mordor_timer = 5
                    anorien_swap.gondor_takeover =  true
                    if anorien_swap.gondor_timer == 1 then
                        eur_sMap:getSettlement("Anorien").localizedName = "Minas Tirith"
                        M2TWEOP.setModel(324,217,42,42)  -- Minas Tirith
                        if eur_sMap:getSettlement("East_Osgiliath").level == 5 then
                            M2TWEOP.setModel(330,219,48,48)  -- E Osgiliath
                            custom_maps[string.format("%d,%d", 330, 219)] = 'osgiliath_east_repaired_a'    --(Osgiliath_E_GOOD)
                        else
                            M2TWEOP.setModel(330,219,43,43)  -- E Osgiliath
                            custom_maps[string.format("%d,%d", 330, 219)] = 'osgiliath_east_a'    --(Osgiliath_E_GOOD)
                        end
                        if eur_sMap:getSettlement("West_Osgiliath").level == 4 then
                            M2TWEOP.setModel(328,219,49,49)  -- W Osgiliath
                            custom_maps[string.format("%d,%d", 328, 219)] = 'osgiliath_west_repaired_a'    --(Osgiliath_W_GOOD)
                        else
                            M2TWEOP.setModel(328,219,44,44)  -- W Osgiliath
                            custom_maps[string.format("%d,%d", 328, 219)] = 'osgiliath_west_a'    --(Osgiliath_W_GOOD)
                        end
                        M2TWEOP.setModel(327,229,37,37)  -- Cair Andros

                        custom_maps[string.format("%d,%d", 324, 217)] = 'minas_tirith_a'      --(Minas_Tirith_GOOD)
                        custom_maps[string.format("%d,%d", 327, 229)] = 'cair_andros_a'       --(Cair_Andros_GOOD)
                        
                        stratmap.game.historicEvent("anorien_cleansed", anorien_cleansed_title, anorien_cleansed_body)
                        anorien_swap.gondor_takeover =  false
                        anorien_swap.anorien_good = true
                        anorien_swap.gondor_timer = 5
                    else
                        anorien_swap.gondor_timer = anorien_swap.gondor_timer - 1
                    end
                else
                    anorien_swap.gondor_takeover =  false
                    anorien_swap.gondor_timer = 5
            end
        end
    end
    if anorien_swap.anorien_good then
        if (eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "sicily" or eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "turks" or eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "russia" ) then
            if eur_sMap:getSettlement("East_Osgiliath").level == 5 then
                custom_maps[string.format("%d,%d", 330, 219)] = 'osgiliath_east_repaired_a'    --(Osgiliath_E_GOOD)
            end
        end
        if (eur_sMap:getSettlement("West_Osgiliath").ownerFaction.name == "sicily" or eur_sMap:getSettlement("West_Osgiliath").ownerFaction.name == "turks" or eur_sMap:getSettlement("East_Osgiliath").ownerFaction.name == "russia" ) then
            if eur_sMap:getSettlement("West_Osgiliath").level == 4 then
                custom_maps[string.format("%d,%d", 328, 219)] = 'osgiliath_west_repaired_a'    --(Osgiliath_W_GOOD)
            end
        end
    end
end

local coord_lookup = {}
for key, data in pairs(strat_cas_standalone) do
    coord_lookup[data.xCoord] = coord_lookup[data.xCoord] or {}
    coord_lookup[data.xCoord][data.yCoord] = key
end

function supplyTooltip()
    if M2TW.selectionInfo.hoveredCharacter then
        if M2TW.selectionInfo.hoveredCharacter.characterType == 7 then
            if M2TW.selectionInfo.hoveredCharacter.characterRecord ~= nil then
                local char = M2TW.selectionInfo.hoveredCharacter.characterRecord
                if hasTrait(char, "Supplies") then
                    local level = char:getTraitLevel("Supplies")
                    xPos, yPos = ImGui.GetMousePos();
                    --ImGui.SetNextWindowPos(xPos+50, yPos+50)
                    ImGui.SetNextWindowPos(xPos, yPos)
                    ImGui.Begin("strat_tooltip_1", true, bit.bor(ImGuiWindowFlags.NoInputs, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
                    eurStyle("tooltip", true)
                    ImGui.BeginTooltip()
                    ImGui.Text("Supplies level: "..tostring(level))
                    ImGui.EndTooltip()
                    eurStyle("tooltip", false)
                    ImGui.End()
                end
            end
        end
    end
end

function tooltipAtCoord()
    local x, y = M2TWEOP.getStratHoveredCoords()
    if coord_lookup[x] and coord_lookup[x][y] then
        local item_key = coord_lookup[x][y]
        local item_data = strat_cas_standalone[item_key]
        local tooltip_text = item_data.tooltip
        if tooltip_text ~= "" then
            xPos, yPos = ImGui.GetMousePos();
            ImGui.SetNextWindowPos(xPos, yPos)
            ImGui.Begin("strat_tooltip_1", true, bit.bor(ImGuiWindowFlags.NoInputs, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
            eurStyle("tooltip", true)
            ImGui.BeginTooltip()
            ImGui.Text(tooltip_text)
            ImGui.EndTooltip()
            eurStyle("tooltip", false)
            ImGui.End()
        end
    end
end
