// event state not already declared in the eurGlobal split
::EUR.anorTarget <- ""
::EUR.edu_modified <- false
::EUR.mengood_0_pop <- 0
::EUR.mengood_0_cul <- 0
::EUR.lindon_0_bu_added <- false
::EUR.dwarven_0_bu_added <- false

::EUR.labels_unedited <- [
    "maernil_1_eregion00",
    "glorfindel_1",
    "Ecthellion_1_eregion",
    "Ciryatan_1_eregion",
    "Tauriel_1",
    "galadriel_1",
    "adrahil_1",
    "adrahil_rk",
    "agandaur_1",
    "alatar_1",
    "alatar_2",
    "alatar_3",
    "alatar_4",
    "alf_1",
    "alf_2",
    "rhunheir_1",
    "ancantar_1",
    "ancantar_2",
    "ancantar_3",
    "ancantar_4",
    "ancantar_5",
    "breeheir_1",
    "breeheir_2",
    "angbor_1",
    "angbor_rk",
    "aragorn_1",
    "arkish_1",
    "balin_1",
    "balroga_bc1",
    "balroga_slave1",
    "balrog_hre1",
    "balrog_slave1",
    "balrog_bc1",
    "baragund_1",
    "barliman_1",
    "barliman_2",
    "barrow_wight_1",
    "barrow_wight_10",
    "barrow_wight_2",
    "barrow_wight_3",
    "barrow_wight_4",
    "barrow_wight_5",
    "barrow_wight_6",
    "barrow_wight_7",
    "barrow_wight_8",
    "barrow_wight_9",
    "bartan_1",
    "bilbo_1",
    "bilbo_2",
    "boromir_1",
    "boromir_rk",
    "brathor1",
    "carfe_1",
    "celeborn_1",
    "celeborn_union",
    "cirdan_1",
    "denethor_1",
    "denethor_rk",
    "dinenion_1",
    "dornornoston_1",
    "duinhir_1",
    "duinhir_rk",
    "durin_7",
    "elladan_1",
    "elrohir_1",
    "elrond_1",
    "alliance_invaders_1",
    "enpremi_1",
    "enpremi_union",
    "eomer_1",
    "faramir_1",
    "faramir_rk",
    "forlong_1",
    "forlong_rk",
    "freca1",
    "galdor_1",
    "gandalf_1",
    "gandalf_2",
    "gildor_1",
    "bn_army_1",
    "bn_army_3",
    "bn_army_2",
    "golasgil_1",
    "golasgil_rk",
    "gothmog_1",
    "goblinking_1",
    "halbarad_1",
    "haldir_1",
    "haldir_union",
    "hirluin_1",
    "hirluin_rk",
    "hurin_1",
    "hurin_rk",
    "imrahil_1",
    "imrahil_rk",
    "iorthon_1",
    "istion_1",
    "istion_rk",
    "kurashir_1",
    "legolas_1",
    "legolas_union",
    "isengard_attackers_3",
    "lurtz_1",
    "gondor_attackers_2",
    "gondor_attackers_m",
    "maernil_1",
    "mazog_1",
    "mistven_1",
    "mistven_rk",
    "n1",
    "nazgula_f1",
    "nazgula_f10",
    "nazgula_f11",
    "nazgula_f12",
    "nazgula_f13",
    "nazgula_f14",
    "nazgula_f2",
    "nazgula_f3",
    "nazgula_f4",
    "nazgula_f5",
    "nazgula_f6",
    "nazgula_f7",
    "nazgula_f8",
    "nazgula_f9",
    "nazgula_p1",
    "nazgula_p2",
    "nazgula_r1",
    "nazgula_r10",
    "nazgula_r11",
    "nazgula_r12",
    "nazgula_r13",
    "nazgula_r14",
    "nazgula_r15",
    "nazgula_r16",
    "nazgula_r17",
    "nazgula_r18",
    "nazgula_r19",
    "nazgula_r2",
    "nazgula_r20",
    "nazgula_r21",
    "nazgula_r22",
    "nazgula_r23",
    "nazgula_r24",
    "nazgula_r25",
    "nazgula_r26",
    "nazgula_r27",
    "nazgula_r28",
    "nazgula_r29",
    "nazgula_r3",
    "nazgula_r30",
    "nazgula_r31",
    "nazgula_r32",
    "nazgula_r33",
    "nazgula_r34",
    "nazgula_r35",
    "nazgula_r36",
    "nazgula_r37",
    "nazgula_r38",
    "nazgula_r39",
    "nazgula_r4",
    "nazgula_r40",
    "nazgula_r41",
    "nazgula_r42",
    "nazgula_r43",
    "nazgula_r44",
    "nazgula_r45",
    "nazgula_r46",
    "nazgula_r47",
    "nazgula_r48",
    "nazgula_r49",
    "nazgula_r5",
    "nazgula_r50",
    "nazgula_r51",
    "nazgula_r52",
    "nazgula_r53",
    "nazgula_r54",
    "nazgula_r55",
    "nazgula_r56",
    "nazgula_r57",
    "nazgula_r58",
    "nazgula_r59",
    "nazgula_r6",
    "nazgula_r60",
    "nazgula_r7",
    "nazgula_r8",
    "nazgula_r9",
    "z1",
    "n2",
    "nazgulb_f1",
    "nazgulb_f10",
    "nazgulb_f11",
    "nazgulb_f12",
    "nazgulb_f13",
    "nazgulb_f14",
    "nazgulb_f15",
    "nazgulb_f16",
    "nazgulb_f17",
    "nazgulb_f2",
    "nazgulb_f3",
    "nazgulb_f4",
    "nazgulb_f5",
    "nazgulb_f6",
    "nazgulb_f7",
    "nazgulb_f8",
    "nazgulb_f9",
    "nazgulb_r1",
    "nazgulb_r10",
    "nazgulb_r11",
    "nazgulb_r12",
    "nazgulb_r13",
    "nazgulb_r14",
    "nazgulb_r15",
    "nazgulb_r16",
    "nazgulb_r17",
    "nazgulb_r18",
    "nazgulb_r19",
    "nazgulb_r2",
    "nazgulb_r20",
    "nazgulb_r21",
    "nazgulb_r22",
    "nazgulb_r23",
    "nazgulb_r24",
    "nazgulb_r25",
    "nazgulb_r26",
    "nazgulb_r27",
    "nazgulb_r28",
    "nazgulb_r29",
    "nazgulb_r3",
    "nazgulb_r30",
    "nazgulb_r31",
    "nazgulb_r32",
    "nazgulb_r33",
    "nazgulb_r34",
    "nazgulb_r35",
    "nazgulb_r36",
    "nazgulb_r37",
    "nazgulb_r38",
    "nazgulb_r39",
    "nazgulb_r4",
    "nazgulb_r40",
    "nazgulb_r41",
    "nazgulb_r42",
    "nazgulb_r43",
    "nazgulb_r44",
    "nazgulb_r45",
    "nazgulb_r46",
    "nazgulb_r47",
    "nazgulb_r48",
    "nazgulb_r49",
    "nazgulb_r5",
    "nazgulb_r50",
    "nazgulb_r6",
    "nazgulb_r7",
    "nazgulb_r8",
    "nazgulb_r9",
    "z2",
    "n3",
    "nazgulc_f1",
    "nazgulc_f10",
    "nazgulc_f11",
    "nazgulc_f12",
    "nazgulc_f13",
    "nazgulc_f14",
    "nazgulc_f15",
    "nazgulc_f16",
    "nazgulc_f2",
    "nazgulc_f3",
    "nazgulc_f4",
    "nazgulc_f5",
    "nazgulc_f6",
    "nazgulc_f7",
    "nazgulc_f8",
    "nazgulc_f9",
    "nazgulc_r1",
    "nazgulc_r10",
    "nazgulc_r11",
    "nazgulc_r12",
    "nazgulc_r13",
    "nazgulc_r14",
    "nazgulc_r15",
    "nazgulc_r16",
    "nazgulc_r17",
    "nazgulc_r18",
    "nazgulc_r19",
    "nazgulc_r2",
    "nazgulc_r20",
    "nazgulc_r21",
    "nazgulc_r22",
    "nazgulc_r23",
    "nazgulc_r24",
    "nazgulc_r25",
    "nazgulc_r26",
    "nazgulc_r27",
    "nazgulc_r28",
    "nazgulc_r29",
    "nazgulc_r3",
    "nazgulc_r30",
    "nazgulc_r31",
    "nazgulc_r32",
    "nazgulc_r33",
    "nazgulc_r34",
    "nazgulc_r35",
    "nazgulc_r36",
    "nazgulc_r37",
    "nazgulc_r38",
    "nazgulc_r39",
    "nazgulc_r4",
    "nazgulc_r40",
    "nazgulc_r41",
    "nazgulc_r42",
    "nazgulc_r43",
    "nazgulc_r44",
    "nazgulc_r45",
    "nazgulc_r46",
    "nazgulc_r47",
    "nazgulc_r48",
    "nazgulc_r49",
    "nazgulc_r5",
    "nazgulc_r50",
    "nazgulc_r6",
    "nazgulc_r7",
    "nazgulc_r8",
    "nazgulc_r9",
    "z3",
    "n4",
    "nazguld_f1",
    "nazguld_f10",
    "nazguld_f11",
    "nazguld_f12",
    "nazguld_f13",
    "nazguld_f14",
    "nazguld_f2",
    "nazguld_f3",
    "nazguld_f4",
    "nazguld_f5",
    "nazguld_f6",
    "nazguld_f7",
    "nazguld_f8",
    "nazguld_f9",
    "nazguld_r1",
    "nazguld_r10",
    "nazguld_r11",
    "nazguld_r12",
    "nazguld_r13",
    "nazguld_r14",
    "nazguld_r15",
    "nazguld_r16",
    "nazguld_r17",
    "nazguld_r18",
    "nazguld_r19",
    "nazguld_r2",
    "nazguld_r20",
    "nazguld_r21",
    "nazguld_r22",
    "nazguld_r23",
    "nazguld_r24",
    "nazguld_r25",
    "nazguld_r26",
    "nazguld_r27",
    "nazguld_r28",
    "nazguld_r29",
    "nazguld_r3",
    "nazguld_r30",
    "nazguld_r31",
    "nazguld_r32",
    "nazguld_r33",
    "nazguld_r34",
    "nazguld_r35",
    "nazguld_r36",
    "nazguld_r37",
    "nazguld_r38",
    "nazguld_r39",
    "nazguld_r4",
    "nazguld_r40",
    "nazguld_r41",
    "nazguld_r42",
    "nazguld_r43",
    "nazguld_r44",
    "nazguld_r45",
    "nazguld_r46",
    "nazguld_r47",
    "nazguld_r48",
    "nazguld_r49",
    "nazguld_r5",
    "nazguld_r50",
    "nazguld_r6",
    "nazguld_r7",
    "nazguld_r8",
    "nazguld_r9",
    "z4",
    "n5",
    "nazgule_f1",
    "nazgule_f10",
    "nazgule_f11",
    "nazgule_f12",
    "nazgule_f13",
    "nazgule_f14",
    "nazgule_f15",
    "nazgule_f16",
    "nazgule_f17",
    "nazgule_f2",
    "nazgule_f3",
    "nazgule_f4",
    "nazgule_f5",
    "nazgule_f6",
    "nazgule_f7",
    "nazgule_f8",
    "nazgule_f9",
    "nazgule_r1",
    "nazgule_r10",
    "nazgule_r11",
    "nazgule_r12",
    "nazgule_r13",
    "nazgule_r14",
    "nazgule_r15",
    "nazgule_r16",
    "nazgule_r17",
    "nazgule_r18",
    "nazgule_r19",
    "nazgule_r2",
    "nazgule_r20",
    "nazgule_r21",
    "nazgule_r22",
    "nazgule_r23",
    "nazgule_r24",
    "nazgule_r25",
    "nazgule_r26",
    "nazgule_r27",
    "nazgule_r28",
    "nazgule_r29",
    "nazgule_r3",
    "nazgule_r30",
    "nazgule_r31",
    "nazgule_r32",
    "nazgule_r33",
    "nazgule_r34",
    "nazgule_r35",
    "nazgule_r36",
    "nazgule_r37",
    "nazgule_r38",
    "nazgule_r39",
    "nazgule_r4",
    "nazgule_r40",
    "nazgule_r41",
    "nazgule_r42",
    "nazgule_r43",
    "nazgule_r44",
    "nazgule_r45",
    "nazgule_r46",
    "nazgule_r47",
    "nazgule_r48",
    "nazgule_r49",
    "nazgule_r5",
    "nazgule_r50",
    "nazgule_r6",
    "nazgule_r7",
    "nazgule_r8",
    "nazgule_r9",
    "z5",
    "n6",
    "nazgulf_f1",
    "nazgulf_f10",
    "nazgulf_f11",
    "nazgulf_f12",
    "nazgulf_f13",
    "nazgulf_f14",
    "nazgulf_f15",
    "nazgulf_f16",
    "nazgulf_f2",
    "nazgulf_f3",
    "nazgulf_f4",
    "nazgulf_f5",
    "nazgulf_f6",
    "nazgulf_f7",
    "nazgulf_f8",
    "nazgulf_f9",
    "nazgulf_r1",
    "nazgulf_r10",
    "nazgulf_r11",
    "nazgulf_r12",
    "nazgulf_r13",
    "nazgulf_r14",
    "nazgulf_r15",
    "nazgulf_r16",
    "nazgulf_r17",
    "nazgulf_r18",
    "nazgulf_r19",
    "nazgulf_r2",
    "nazgulf_r20",
    "nazgulf_r21",
    "nazgulf_r22",
    "nazgulf_r23",
    "nazgulf_r24",
    "nazgulf_r25",
    "nazgulf_r26",
    "nazgulf_r27",
    "nazgulf_r28",
    "nazgulf_r29",
    "nazgulf_r3",
    "nazgulf_r30",
    "nazgulf_r31",
    "nazgulf_r32",
    "nazgulf_r33",
    "nazgulf_r34",
    "nazgulf_r35",
    "nazgulf_r36",
    "nazgulf_r37",
    "nazgulf_r38",
    "nazgulf_r39",
    "nazgulf_r4",
    "nazgulf_r40",
    "nazgulf_r41",
    "nazgulf_r42",
    "nazgulf_r43",
    "nazgulf_r44",
    "nazgulf_r45",
    "nazgulf_r46",
    "nazgulf_r47",
    "nazgulf_r48",
    "nazgulf_r49",
    "nazgulf_r5",
    "nazgulf_r50",
    "nazgulf_r6",
    "nazgulf_r7",
    "nazgulf_r8",
    "nazgulf_r9",
    "z6",
    "n7",
    "nazgulg_f1",
    "nazgulg_f10",
    "nazgulg_f11",
    "nazgulg_f12",
    "nazgulg_f13",
    "nazgulg_f14",
    "nazgulg_f15",
    "nazgulg_f2",
    "nazgulg_f3",
    "nazgulg_f4",
    "nazgulg_f5",
    "nazgulg_f6",
    "nazgulg_f7",
    "nazgulg_f8",
    "nazgulg_f9",
    "nazgulg_r1",
    "nazgulg_r10",
    "nazgulg_r11",
    "nazgulg_r12",
    "nazgulg_r13",
    "nazgulg_r14",
    "nazgulg_r15",
    "nazgulg_r16",
    "nazgulg_r17",
    "nazgulg_r18",
    "nazgulg_r19",
    "nazgulg_r2",
    "nazgulg_r20",
    "nazgulg_r21",
    "nazgulg_r22",
    "nazgulg_r23",
    "nazgulg_r24",
    "nazgulg_r25",
    "nazgulg_r26",
    "nazgulg_r27",
    "nazgulg_r28",
    "nazgulg_r29",
    "nazgulg_r3",
    "nazgulg_r30",
    "nazgulg_r31",
    "nazgulg_r32",
    "nazgulg_r33",
    "nazgulg_r34",
    "nazgulg_r35",
    "nazgulg_r36",
    "nazgulg_r37",
    "nazgulg_r38",
    "nazgulg_r39",
    "nazgulg_r4",
    "nazgulg_r40",
    "nazgulg_r41",
    "nazgulg_r42",
    "nazgulg_r43",
    "nazgulg_r44",
    "nazgulg_r45",
    "nazgulg_r46",
    "nazgulg_r47",
    "nazgulg_r48",
    "nazgulg_r49",
    "nazgulg_r5",
    "nazgulg_r50",
    "nazgulg_r6",
    "nazgulg_r7",
    "nazgulg_r8",
    "nazgulg_r9",
    "z7",
    "n8",
    "nazgulh_f1",
    "nazgulh_f10",
    "nazgulh_f11",
    "nazgulh_f12",
    "nazgulh_f13",
    "nazgulh_f14",
    "nazgulh_f15",
    "nazgulh_f2",
    "nazgulh_f3",
    "nazgulh_f4",
    "nazgulh_f5",
    "nazgulh_f6",
    "nazgulh_f7",
    "nazgulh_f8",
    "nazgulh_f9",
    "nazgulh_r1",
    "nazgulh_r10",
    "nazgulh_r11",
    "nazgulh_r12",
    "nazgulh_r13",
    "nazgulh_r14",
    "nazgulh_r15",
    "nazgulh_r16",
    "nazgulh_r17",
    "nazgulh_r18",
    "nazgulh_r19",
    "nazgulh_r2",
    "nazgulh_r20",
    "nazgulh_r21",
    "nazgulh_r22",
    "nazgulh_r23",
    "nazgulh_r24",
    "nazgulh_r25",
    "nazgulh_r26",
    "nazgulh_r27",
    "nazgulh_r28",
    "nazgulh_r29",
    "nazgulh_r3",
    "nazgulh_r30",
    "nazgulh_r31",
    "nazgulh_r32",
    "nazgulh_r33",
    "nazgulh_r34",
    "nazgulh_r35",
    "nazgulh_r36",
    "nazgulh_r37",
    "nazgulh_r38",
    "nazgulh_r39",
    "nazgulh_r4",
    "nazgulh_r40",
    "nazgulh_r41",
    "nazgulh_r42",
    "nazgulh_r43",
    "nazgulh_r44",
    "nazgulh_r45",
    "nazgulh_r46",
    "nazgulh_r47",
    "nazgulh_r48",
    "nazgulh_r49",
    "nazgulh_r5",
    "nazgulh_r50",
    "nazgulh_r6",
    "nazgulh_r7",
    "nazgulh_r8",
    "nazgulh_r9",
    "z8",
    "n9",
    "nazguli_f1",
    "nazguli_f10",
    "nazguli_f11",
    "nazguli_f12",
    "nazguli_f13",
    "nazguli_f14",
    "nazguli_f15",
    "nazguli_f2",
    "nazguli_f3",
    "nazguli_f4",
    "nazguli_f5",
    "nazguli_f6",
    "nazguli_f7",
    "nazguli_f8",
    "nazguli_f9",
    "nazguli_r1",
    "nazguli_r10",
    "nazguli_r11",
    "nazguli_r12",
    "nazguli_r13",
    "nazguli_r14",
    "nazguli_r15",
    "nazguli_r16",
    "nazguli_r17",
    "nazguli_r18",
    "nazguli_r19",
    "nazguli_r2",
    "nazguli_r20",
    "nazguli_r21",
    "nazguli_r22",
    "nazguli_r23",
    "nazguli_r24",
    "nazguli_r25",
    "nazguli_r26",
    "nazguli_r27",
    "nazguli_r28",
    "nazguli_r29",
    "nazguli_r3",
    "nazguli_r30",
    "nazguli_r31",
    "nazguli_r32",
    "nazguli_r33",
    "nazguli_r34",
    "nazguli_r35",
    "nazguli_r36",
    "nazguli_r37",
    "nazguli_r38",
    "nazguli_r39",
    "nazguli_r4",
    "nazguli_r40",
    "nazguli_r41",
    "nazguli_r42",
    "nazguli_r43",
    "nazguli_r44",
    "nazguli_r45",
    "nazguli_r46",
    "nazguli_r47",
    "nazguli_r48",
    "nazguli_r49",
    "nazguli_r5",
    "nazguli_r50",
    "nazguli_r6",
    "nazguli_r7",
    "nazguli_r8",
    "nazguli_r9",
    "z9",
    "oin_1",
    "orash_1",
    "guardian_moria_1",
    "guardian_moria_2",
    "orodreth_1",
    "orodreth_rk",
    "orophin_1",
    "orophin_union",
    "orthordir_1",
    "orthordir_union",
    "paladin_1",
    "paladin_2",
    "pallando_1",
    "pallando_2",
    "pallando_3",
    "pallando_4",
    "radagast",
    "family_rhun1",
    "rumil_1",
    "rumil_union",
    "saruman_1",
    "sauron_1",
    "skorgrim_bc1",
    "skorgrim_slave1",
    "theoden_1",
    "thingol_1",
    "thranduil_1",
    "thranduil_union",
    "toghrul_1",
    "isengard_attackers_4",
    "ugluk_1",
    "ulfang_1",
    "ulfang_2",
    "wil_1",
    "wil_2",
    "Yagthak_1",
    "yiltig_1",
]

::EUR.eurSpawnArmy <- function(faction_name, name, label, custom_portrait, family, age, unit, x, y, exp, weapon, armor) {
    local tile = ::EUR.getValidTile(x, y)
    x = tile[0]; y = tile[1]
    if (!::EUR.tableContains(::EUR.labels_unedited, label)) {
        label = label + ::EUR.eur_turn_number + ::EUR.eur_spawned_characters
    }
    local faction = ::EUR.eur_campaign.factionByName(faction_name)
    local eduEntry = ::units.get(unit)
    local eduIndex = (eduEntry != null) ? eduEntry.index : -1
    local army = faction.spawnArmy(name, "", ::Enum.CharacterType.namedCharacter, label,
        custom_portrait, x, y, age, family, 31, eduIndex, exp, weapon, armor, -1)
    ::EUR.eur_spawned_characters = ::EUR.eur_spawned_characters + 1
    return army
}

::EUR.mirrorGaladriel <- function() {
    local faction = ::EUR.eur_campaign.factionByName(::EUR.mirrorTarget)
    for (local i = 0; i < faction.settlementCount; i++) {
        local sett = faction.settlement(i)
        if (sett == null) continue
        local region = ::EUR.eur_sMap.region(sett.regionId)
        for (local t = 0; t < region.tileCount; t++) {
            if (t % 2 != 0) continue
            local tile = region.tileAt(t)
            if (::EUR.checkTileEmpty(tile.x, tile.y)) {
                ::game.runScriptCommand("reveal_tile", tile.x + " " + tile.y)
            }
        }
    }
    for (local i = 0; i < faction.armyCount; i++) {
        local stack = faction.army(i)
        if (stack != null && stack.leader != null) {
            ::game.runScriptCommand("reveal_tile", stack.leader.x + " " + stack.leader.y)
        }
    }
    for (local i = 0; i < faction.characterCount; i++) {
        local char = faction.character(i)
        if (char != null) {
            ::game.runScriptCommand("reveal_tile", char.x + " " + char.y)
        }
    }
}

::EUR.mirrorCheck <- function() {
    if (::EUR.mirrorTarget == "") return
    if (::EUR.mirrorTurnsRemain == 0) { ::EUR.mirrorTarget = ""; return }
    ::EUR.mirrorGaladriel()
    ::EUR.mirrorTurnsRemain = ::EUR.mirrorTurnsRemain - 1
}

::EUR.eventAddTrait <- function(faction, bool) {
    for (local i = 0; i < faction.characterCount; i++) {
        local char = faction.character(i).record
        if (char == null) continue
        if (bool) { char.addTrait(::EUR.traitToAdd, 1) }
        else { char.removeTrait(::EUR.traitToAdd) }
    }
}

::EUR.traitCheck <- function(id) {
    if (id != ::EUR.eur_playerFactionId) return
    if (::EUR.traitToAdd == "") return
    if (::EUR.traitTurnsRemain == 0) {
        ::EUR.eventAddTrait(::EUR.eur_player_faction, false)
        ::EUR.traitToAdd = ""
    } else if (::EUR.traitTurnsRemain == 8) {
        ::EUR.eventAddTrait(::EUR.eur_player_faction, true)
        ::EUR.traitTurnsRemain = ::EUR.traitTurnsRemain - 1
    } else {
        ::EUR.traitTurnsRemain = ::EUR.traitTurnsRemain - 1
    }
}

::EUR.increaseGrowth <- function(faction, level) {
    for (local i = 0; i < faction.settlementCount; i++) {
        local sett = faction.settlement(i)
        if (sett != null) {
            sett.baseFertility = level
            sett.population = sett.stats().population + 25
        }
    }
}

::EUR.growthCheck <- function(id) {
    if (id != ::EUR.eur_playerFactionId) return
    if (!::EUR.modify_growth) return
    if (::EUR.growthTurnsRemain == 0) {
        ::EUR.increaseGrowth(::EUR.eur_player_faction, 1)
        ::EUR.modify_growth = false
    } else if (::EUR.growthTurnsRemain > 0) {
        ::EUR.increaseGrowth(::EUR.eur_player_faction, ::EUR.fert_level)
        ::EUR.growthTurnsRemain = ::EUR.growthTurnsRemain - 1
    }
}

::EUR.modifyEDU <- function(bool, ammo, locked, cost, time, range) {
    for (local i = 0; i < 1500; i++) {
        local eduEntry = ::units.at(i)
        if (eduEntry == null || !eduEntry.hasOwnership(::EUR.eur_playerFactionId)) continue
        if (!(eduEntry.name in ::EUR.UNIT_ORIGINAL)) continue   // UNIT_ORIGINAL must be populated first
        local orig = ::EUR.UNIT_ORIGINAL[eduEntry.name]
        if (bool) {
            if (ammo > 0) { eduEntry.setAmmo(0, ::EUR.math.ceil(orig.ammo * ammo)) }
            // no house row for eduEntry.moraleLocked - the accessor has the field, SqUnitType registers nothing
            // if (locked > 0) { eduEntry.moraleLocked = 1 }
            if (cost > 0) { eduEntry.recruitCost = ::EUR.math.ceil(orig.recruitCost * cost) }
            if (time > 0 && eduEntry.recruitPoints > time) { eduEntry.recruitPoints = orig.recruitTime - time }
            if (range > 0) { eduEntry.setRange(0, orig.range + range) }
            ::EUR.edu_modified = true
        } else {
            eduEntry.setAmmo(0, orig.ammo)
            // no house row for eduEntry.moraleLocked - the accessor has the field, SqUnitType registers nothing
            // eduEntry.moraleLocked = orig.moraleLocked
            eduEntry.recruitCost = orig.recruitCost
            eduEntry.recruitPoints = orig.recruitTime
            eduEntry.setRange(0, orig.range)
            ::EUR.edu_modified = false
        }
    }
}

::EUR.modifyEDUcheck <- function(id, bool) {
    if (id != ::EUR.eur_playerFactionId) return
    if (::EUR.edumodActive) {
        if (::EUR.edumodTurnsRemain == 0) {
            ::EUR.modifyEDU(false, 0, 0, 0, 0, 0)
            ::EUR.edumodActive = false
        } else if (::EUR.edumodTurnsRemain > 0) {
            if (!::EUR.edu_modified) { ::EUR.modifyEDU(true, 1.25, 0, 0.65, 1, 0) }
            if (bool) { ::EUR.edumodTurnsRemain = ::EUR.edumodTurnsRemain - 1 }
        }
    }
    if (::EUR.tulkasActive) {
        if (::EUR.tulkasTurnsRemain == 0) {
            ::EUR.modifyEDU(false, 0, 0, 0, 0, 0)
            ::EUR.tulkasActive = false
        } else if (::EUR.tulkasTurnsRemain > 0) {
            if (!::EUR.edu_modified) { ::EUR.modifyEDU(true, 0, 0, 0.4, 1, 0) }
            ::EUR.tulkasTurnsRemain = ::EUR.tulkasTurnsRemain - 1
        }
    }
}

::EUR.tulkasCheck <- function(id, unit, new) {
    if (id != ::EUR.eur_playerFactionId) return
    if (!::EUR.tulkasActive) return
    if (new) {
        if (unit.experience < 7) { unit.setParams(unit.experience + 3, unit.armourLevel, unit.weaponLevel) }
    } else if (::EUR.tulkasTurnsRemain > 3) {
        for (local i = 0; i < ::EUR.eur_player_faction.armyCount; i++) {
            local stack = ::EUR.eur_player_faction.army(i)
            if (stack == null) continue
            for (local j = 0; j < stack.unitCount; j++) {
                local u = stack.unit(j)
                if (::EUR.math.random(1, 100) > 50 && u.experience < 9) {
                    u.setParams(u.experience + 1, u.armourLevel, u.weaponLevel)
                }
            }
        }
    }
}

::EUR.ulmoAdd <- function() {
    if (::EUR.lindon_0_count <= 0) { return }

    local building = ::buildings.byName("port")
    if (building == null) { return }

    local bonus = 15
    for (local i = 1; i <= ::EUR.lindon_0_count; i++) {
        for (local j = 0; j <= 4; j++) {
            local level = ::buildings.level(building, j)
            if (level == null) { continue }

            ::buildings.addCapability(level, 0, ::Enum.BuildingCapability.incomeBonus, bonus * (j + 1), true, "factions { denmark, }")
            if (i < 6) {
                ::buildings.addCapability(level, 0, ::Enum.BuildingCapability.populationGrowthBonus, 1, true, "factions { denmark, }")
            }

            if (::EUR.lindon_0_count == 2) {
                ::buildings.addRecruitPool(level, ::units.indexOf("Lindar Mariners"), 1.0, 0.1, 2.0, 1, false, "factions { denmark, } and region_religion elven 33 and event_counter mithlond_controlled 1")
            }
            if (::EUR.lindon_0_count == 4 && i == 4) {
                ::buildings.addRecruitPool(level, ::units.indexOf("Mithlond Nobles"), 1.0, 0.1, 2.0, 1, false, "factions { denmark, } and region_religion elven 80 and hidden_resource Lindon")
            }
        }
    }

    ::EUR.lindon_0_bu_added = true
}

::EUR.miningdwarvesAdd <- function() {
    local building = ::buildings.byName("hinterland_mines")
    local bonus = 25

    if (::EUR.dwarven_0_count > 0 && building != null) {
        for (local i = 1; i <= ::EUR.dwarven_0_count; i++) {
            for (local j = 0; j <= 2; j++) {
                local level = ::buildings.level(building, j)
                if (level == null) { continue }

                ::buildings.addCapability(level, 0, ::Enum.BuildingCapability.incomeBonus, bonus * (j + 1), true, "factions { moors, hungary, norway, }")
                if (i < 6) {
                    ::buildings.addCapability(level, 0, ::Enum.BuildingCapability.populationGrowthBonus, 1, true, "factions { moors, hungary, norway, }")
                }
            }
        }
        ::EUR.dwarven_0_bu_added = true
    }
    for (local i = 0; i < ::EUR.eur_player_faction.characterCount; i++) {
        local char = ::EUR.eur_player_faction.character(i)
        if (char.typeId != 7 || ::EUR.math.random(1, 100) <= 50) continue
        if (char.record.traitLevel("MiningSkill") == 0) {
            char.record.addTrait("MiningSkill", 1)
        } else if (char.record.traitLevel("MiningSkill") < 2) {
            char.record.addTraitPoints("MiningSkill", 1)
        }
    }
}

::EUR.greatEye <- function(reset) {
    if (::EUR.eyeTarget == 0) return
    if (reset) { ::game.runScriptCommand("hide_all_revealed_tiles", "") }
    local region = ::EUR.eur_sMap.region(::EUR.eyeTarget)
    for (local i = 0; i < region.tileCount; i++) {
        if (i % 2 != 0) continue
        local tile = region.tileAt(i)
        if (::EUR.checkTileEmpty(tile.x, tile.y)) {
            ::game.runScriptCommand("reveal_tile", tile.x + " " + tile.y)
        }
    }
}

::EUR.eyeCheck <- function(id) {
    if (id != ::EUR.eur_playerFactionId) return
    if (::EUR.eyeTarget == 0) return
    ::EUR.greatEye(false)
}

::EUR.anorStone <- function() {
    local target = ::EUR.eur_campaign.factionByName(::EUR.anorTarget)
    if (!target) return
    for (local i = 0; i < target.characterCount; i++) {
        local char = target.character(i)
        if (char == null) continue
        if ((char.typeId == 6 || char.typeId == 7) && !(char.settlement || char.fort)) {
            ::EUR.revealTilesAround(char.x, char.y)
        }
    }
    for (local i = 0; i < target.settlementCount; i++) {
        local sett = target.settlement(i)
        if (sett != null) { ::EUR.revealTilesAround(sett.tileX, sett.tileY) }
    }
}

::EUR.anorStoneCheck <- function() {
    if (::EUR.anorTarget == "") return
    if (::EUR.anorTurnsRemain == 1) {
        ::EUR.anorTurnsRemain = ::EUR.anorTurnsRemain - 1
        ::EUR.anorTarget = ""
    } else if (::EUR.anorTurnsRemain > 1) {
        ::EUR.anorStone()
        ::EUR.anorTurnsRemain = ::EUR.anorTurnsRemain - 1
    }
}

::EUR.populationCultureBonus <- function(pop, culture, settlement) {
    if (!settlement) return
    settlement.population = settlement.stats().population + pop
    local relLevel = settlement.religion(::EUR.eur_player_faction.religionId)
    if (relLevel + culture > 1) { settlement.setReligion(::EUR.eur_player_faction.religionId, 1) }
    else { settlement.setReligion(::EUR.eur_player_faction.religionId, relLevel + culture) }
}

::EUR.mengood_0_check <- function(id) {
    if (id != ::EUR.eur_playerFactionId) return
    if (!::EUR.mengood_0_sett) return
    if (::EUR.mengoodTurnsRemain == 1) {
        ::EUR.mengoodTurnsRemain = ::EUR.mengoodTurnsRemain - 1
        ::EUR.populationCultureBonus(::EUR.mengood_0_pop, ::EUR.mengood_0_cul, ::EUR.mengood_0_sett)
        ::EUR.mengood_0_sett = null
    } else if (::EUR.mengoodTurnsRemain > 1) {
        ::EUR.populationCultureBonus(::EUR.mengood_0_pop, ::EUR.mengood_0_cul, ::EUR.mengood_0_sett)
        ::EUR.mengoodTurnsRemain = ::EUR.mengoodTurnsRemain - 1
    }
}

::EUR.eurEventUnlockCheck <- function(id) {
    if (id != ::EUR.eur_playerFactionId) return
    local dolGuldur = ::EUR.eur_campaign.factionByName("poland")
    if (!::EUR.poe_end_condition) {
        if (::EUR.eur_player_faction.name == "ireland") {
            if (dolGuldur.characterCount == 0) {
                ::EUR.poe_end_condition = true
                ::EUR.EUR_EVENTS["ireland"][0].duration = 10
                ::EUR.EUR_EVENTS["ireland"][0].cooldown = 25
                ::EUR.EUR_EVENTS["mongols"][0].duration = 10
                ::EUR.EUR_EVENTS["mongols"][0].cooldown = 25
            }
        } else if (::EUR.eur_player_faction.name == "saxons") {
            if (::EUR.checkCounter("jewel_guild_rebuilt")) { ::EUR.poe_end_condition = true }
        }
    }
    if (::EUR.eur_turn_number > 14) {
        // nothing
    } else if (::EUR.eur_turn_number > 49) {
        ::EUR.EUR_EVENTS["denmark"][2].unlocked = true
    }
    if (dolGuldur.characterCount == 0) {
        ::EUR.EUR_EVENTS["ireland"][0].unlocked = true
        ::EUR.EUR_EVENTS["ireland"][2].unlocked = true
        ::EUR.EUR_EVENTS["ireland"][0].duration = 10
        ::EUR.EUR_EVENTS["ireland"][0].cooldown = 25
    }
    local sett = ::EUR.eur_sMap.findSettlement("North_Khand")
    if (sett.owner.name == "ireland") {
        ::EUR.EUR_EVENTS["ireland"][2].unlocked = true
        ::EUR.EUR_EVENTS["ireland"][2].cooldown = 40
    } else {
        ::EUR.EUR_EVENTS["ireland"][2].cooldown = 60
    }
    sett = ::EUR.eur_sMap.findSettlement("Deep_Mirkwood")
    if (sett.owner.name == "ireland") {
        if (!::EUR.EUR_EVENTS["ireland"][0].unlocked) { ::EUR.EUR_EVENTS["ireland"][0].unlocked = true }
    } else if (sett.owner.name == "mongols") {
        if (!::EUR.EUR_EVENTS["mongols"][0].unlocked && ::EUR.checkCounter("elven_union")) {
            ::EUR.EUR_EVENTS["mongols"][0].unlocked = true
        }
    }
    sett = ::EUR.eur_sMap.findSettlement("Eregion")
    if (sett.owner.name == "saxons") {
        ::EUR.EUR_EVENTS["saxons"][0].unlocked = true
    }
}

::EUR.eurEventActiveCheck <- function(id, faction_name) {
    if (id != ::EUR.eur_playerFactionId) return
    if (::EUR.eur_event_active) {
        if (::EUR.eur_event_activelen == 1) { ::EUR.eur_event_activelen = ::EUR.eur_event_activelen - 1 }
        else if (::EUR.eur_event_activelen > 1) { ::EUR.eur_event_activelen = ::EUR.eur_event_activelen - 1 }
        else { ::EUR.eur_event_active = false }
    }
    if (!(faction_name in ::EUR.EUR_EVENTS)) return
    foreach (i, event in ::EUR.EUR_EVENTS[faction_name]) {
        if (event.active_cooldown == 1) { event.active_cooldown = 0; event.unlocked = true }
        else if (event.active_cooldown > 0) { event.active_cooldown = event.active_cooldown - 1 }
        if (event.active_duration == 1) { event.active_duration = 0; event.unlocked = true }
        else if (event.active_duration > 0) { event.active_duration = event.active_duration - 1 }
    }
    if (::EUR.eur_event_min_cooldown > 0) { ::EUR.eur_event_min_cooldown = ::EUR.eur_event_min_cooldown - 1 }
    if (::EUR.block_poe_turns == 1) { ::EUR.block_poe_turns = ::EUR.block_poe_turns - 1; ::EUR.replen_bonus = 0 }
    else if (::EUR.block_poe_turns > 0) { ::EUR.block_poe_turns = ::EUR.block_poe_turns - 1 }
}
