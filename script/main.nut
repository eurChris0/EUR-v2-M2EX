::EUR <- {}
// Squirrel load order, mirroring eopData/eopScripts/luaPluginScript.lua's require list.
// Helpers first (luaCompat, then the eurGlobal split: styles / vars / temp vars / helpers),
// then the plugin-script order. eur.helpers.eurGlobal is intentionally NOT here - its content
// was split into helper.eurStyles / eurVars / eurVarsTemp / eurHelpers.
// Missing files fail soft (try/catch below) - not everything is ported yet.

::EUR.to_log <- false
::EUR.dev_enabled <- false


// eurOverrides split into per-category trigger files (eur*Triggers.nut); each file's event
// registrations are gated on its flag here. All on by default.
::EUR.EUR_EVENT_TRIGGERS <- {
    campaign   = true,
    battle     = true,
    character  = true,
    settlement = true,
    ui         = true,
    counter    = true,
    other      = true,
}

//auto_turn <- false
//auto_turn_number <- 74

::EUR.chris_stuff <- false

local MODULES = [
    // ::fonts and ::virtualScale, which used to come from the base script tree. First, because
    // everything below draws with them.
    "helper.eurBaseGlobals",
    "helper.luaCompat",
    "helper.eurUndeclared",
    "helper.eurScroll",
    "helper.eurStyles",
    "helper.eurVars",
    "helper.eurVarsTemp",
    "helper.eurHelpers",
    "helper.eurText",
    "helper.eurGlobalVars",
    "helper.eurSaveLoadValues",
    "helper.eurSaveLoadOptions",
    "helper.eurSaveLoadDefaults",
    "helper.eurUpgradeSave",

    "eur.dev.chrisDev",
    //"eur.dev.eurLayoutEditor",
    "eur.chris_setts.chrisAddResBU",
    "helper.EopLuaHelpers",
    "eur.confed.eurRK",
    "eur.upgrades.eurUnitCardLoc",

    "eur.eru.eurMapHelpers",

    "eur.loaded.eurImgLoad",
    "eur.loaded.eurCasLoad",
    "eur.loaded.eurSoundLoad",
    "eur.loaded.eurFontLoad",

    "eur.rebels.eurRebelSetup",
    "eur.campaign.eurUniqueNames",

    "eur.upgrades.eurPlayerUnitsCut",
    "eur.options.eurGameOptions",
    "eur.options.eurOptions",
    "eur.options.eurOptionsWelcome",
    "eur.options.eurOptionsCampaign",
    "eur.options.eurOptionsCampaignExtra",
    "eur.options.eurOptionsBattle",
    "eur.options.eurOptionsDifficulty",
    "eur.options.eurOptionsGeneralADV",
    "eur.options.eurOptionsUnitADV",
    "eur.options.eurOptionsUpgrades",
    "eur.options.eurOptionsAA",
    "eur.options.eurOptionsCredits",
    "eur.options.eurOptionsNotices",

    "eur.upgrades.eurUnitUpgradeDefault",
    "eur.upgrades.eurUnitUpgradeList",
    "eur.upgrades.eurUnitUpgrades",

    "eur.eurEvent.eurEventsVars",
    "eur.eurEvent.eurEventsFunc",


    "eur.upgrades.eurGeneralBGSwapDefault",
    "eur.upgrades.eurGeneralBGSwapList",
    "eur.upgrades.eurGeneralBGSwapDefault2",
    "eur.upgrades.eurGeneralBGSwapList2",
    "eur.upgrades.eurGeneralBGSwapData",
    "eur.upgrades.eurGeneralBGSwap",
    "eur.upgrades.eurLeaderHeirSwap",
    "eur.global_recruitment.eurGlobalRecruitment",
    "eur.spoils.eurAltLoot",
    "eur.campaign.eurAddCustomBGUnits",
    "eur.campaign.eurDifficulty",
    "eur.campaign.eurCustomGenerals",
    "eur.campaign.eurEvolvingFactions",
    "eur.battle.eursetBattleMapPKG",
    "eur.campaign.eurRevealAllied",
    "eur.campaign.eurWatchtowers",
    "eur.campaign.eurSpawnGeneral",
    "eur.campaign.eurAssignFactionTraits",
    "eur.campaign.eurReviveFactions",
    "eur.battle.eurBattleAI",

    "eur.helmsbrick.eurHelmsBrick",
    "eur.campaign.eurGuilds",

    "eur.army sort-merge.eurMergeArmies",
    "eur.confed.eurSwapUnits",
    "eur.replenishment.eurReplenishment",
    "eur.spoils.eurAddSpoils",
    "eur.confed.eurEregion",
    "eur.confed.eurReunitedKingdom",
    "eur.confed.eurElvenUnion",
    "eur.army sort-merge.eurSortStack",
    "eur.temp.EDU",

    "eur.garrisons.eurGarrisonsList",
    "eur.garrisons.eurGarrisons",

    "helper.eurCampaignTriggers",
    "helper.eurBattleTriggers",
    "helper.eurCharacterTriggers",
    "helper.eurSettlementTriggers",
    "helper.eurUiTriggers",
    "helper.eurCounterTriggers",
    "helper.eurOtherTriggers",

    "eur_ai.strategy.nut",
    "eur_ai.snapshot.nut",
]

// Plugin-script binding-form requires (eurHelmsBrick = require(...), eurMerge = ..., etc.) that
// captured the module's return into a global still need that binding when ported - they are loaded
// for side effects above; add the return-value capture as each is ported.

local failed = []
::EUR.moduleErrors <- []
foreach (name in MODULES) {
    try {
        require(name)
    }
    catch (e) {
        failed.append(name)
        ::EUR.moduleErrors.append(name + " -> " + e)
        println("eur: MODULE FAILED [" + name + "] " + e)
    }
}

if (failed.len() == 0) {
    println("eur: loaded")
} else {
    local list = ""
    foreach (i, name in failed) list += (i == 0 ? "" : ", ") + name
    println("eur: loaded with " + failed.len() + " module(s) SKIPPED: " + list)
}

::EUR.reload <- function() {
    if (!("campaignBoot" in ::EUR)) { return false }
    ::EUR.campaignBoot()
    return true
}

try {
    if (::game.campaign() != null) { ::EUR.reload() }
}
catch (e) {
}
