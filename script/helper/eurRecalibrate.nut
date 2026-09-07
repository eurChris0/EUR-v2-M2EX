// Rebuild the whole EUR UI when the resolution changes.
//
// The scale factor is SNAPSHOTTED into each widget when it is created (Widget::m_uiScale), so a
// resolution change does not re-lay-out a tree that already exists - widgets keep the factor they
// were born with while everything placed from a fresh screenSize moves, which is what makes the
// absolutely-placed ones jump around. UI.onResize is the documented hook for exactly this, and the
// only honest answer is to throw the tree away and build it again at the new factor.
//
// UI.clear() drops every root widget with its callbacks and binds, but deliberately LEAVES the
// UI.onFrame handlers alone - which is what makes this work: every window class builds from its
// own render(), so clearing the guards below is enough for the next frame to rebuild all of them.

::EUR.uiRebuilders <- [
    function() { ::EUR.eurOptionsWindow.scroll = null },
    function() { ::EUR.eurOptionsNotices.legScroll = null },
    function() { ::EUR.generalBGSwap.swapScroll = null },
    function() { ::EUR.unitUpgrades.upgradeScroll = null },
    function() { ::EUR.eurGlobalRecruitment.scroll = null },
    function() { ::EUR.eurReviveUI.built = false },
    function() { ::EUR.eurEregion.built = false },
]

::EUR.recalibrate <- function() {
    // Roots are about to stop resolving, so the palette registry has to forget them or the next
    // repaint walks dead handles.
    if ("styledRoots" in ::EUR) { ::EUR.styledRoots.clear() }

    ::UI.clear()

    foreach (reset in ::EUR.uiRebuilders) {
        try { reset() }
        catch (e) { println("eur: recalibrate - " + e) }
    }

    // The palette is per-faction and the sheets survive the clear, so only the repaint has to wait
    // for the new widgets: the next frame's ensure() calls register their roots again.
    if ("buildStyles" in ::EUR && ::EUR.eur_player_faction != null) {
        ::EUR.buildStyles(::EUR.eur_player_faction.name)
    }
}

::UI.onResize(function(w, h) { ::EUR.recalibrate() })
