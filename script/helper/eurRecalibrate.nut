
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
    // EUR's own roots only: a bare ::UI.clear() takes the whole world, base game UI included.
    if ("styledRoots" in ::EUR) {
        foreach (entry in ::EUR.styledRoots) { ::UI.destroy(entry.root) }
        ::EUR.styledRoots.clear()
    }

    foreach (reset in ::EUR.uiRebuilders) {
        try { reset() }
        catch (e) { println("eur: recalibrate - " + e) }
    }

    if ("buildStyles" in ::EUR && ::EUR.eur_player_faction != null) {
        ::EUR.buildStyles(::EUR.eur_player_faction.name)
    }
}

::UI.onResize(function(w, h) { ::EUR.recalibrate() })
