
::EUR.uiRebuilders <- [
    function() { ::EUR.eurOptionsWindow.scroll = null },
    function() { ::EUR.eurOptionsNotices.legScroll = null },
    function() { ::EUR.generalBGSwap.swapScroll = null },
    function() { ::EUR.unitUpgrades.upgradeScroll = null },
    function() { ::EUR.eurGlobalRecruitment.scroll = null },
    function() { ::EUR.eurReviveUI.built = false },
    function() { ::EUR.eurEregion.built = false },
    //function() { ::EUR.eurBuildFort.built = false },
    function() { ::EUR.eurStatusIcons.built = false },
]

::EUR.recalibrate <- function() {
    if ("styledRoots" in ::EUR) { ::EUR.styledRoots.clear() }

    ::UI.clear()

    foreach (reset in ::EUR.uiRebuilders) {
        try { reset() }
        catch (e) { println("eur: recalibrate - " + e) }
    }

    if ("buildStyles" in ::EUR && ::EUR.eur_player_faction != null) {
        ::EUR.buildStyles(::EUR.eur_player_faction.name)
    }
}

::UI.onResize(function(w, h) { ::EUR.recalibrate() })
