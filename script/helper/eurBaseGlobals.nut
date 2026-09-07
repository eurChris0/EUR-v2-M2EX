// ::fonts and ::virtualScale used to come from the base script tree (core/fonts.nut and
// helper/helper_ui.nut). EUR reaches for both on every frame it draws, so it carries its own
// copies here and the mod no longer breaks when that tree is trimmed - delete m2ex/script and all
// that is lost is the dev console.
//
// INSTALL-IF-ABSENT, deliberately. When the base tree IS loaded it wins, so there is exactly one
// ::virtualScale and one loadFont handle in the world rather than two that can drift apart.
//
// Tables rather than classes: the base copy declares `class VirtualScale` at root scope, and a
// second root-scope declaration of the same name is a duplicate newslot. A table has the same
// call shape (::virtualScale.px(x) binds `this` exactly as an instance method would) and no
// scoping question to get wrong.

if (!("virtualScale" in getroottable())) {
    // px / py / spanX / spanY hand back PHYSICAL pixels. A size that has been through them is
    // already converted, so the widget or subtree that receives it must have UI.Cap.autoScale off -
    // pushStyle before creating it, because a widget snapshots the factor at creation. Otherwise
    // autoscale multiplies it a second time and the widget is 25% too big at 1440p, 25% too small
    // at 768p.
    ::virtualScale <- {
        x = 1.0,
        y = 1.0,

        function refresh() {
            local factor = ::UI.virtualScale()
            this.x = factor[0]
            this.y = factor[1]
        }

        function px(virtualX) { return (virtualX * this.x).tointeger() }
        function py(virtualY) { return (virtualY * this.y).tointeger() }

        function spanX(virtualX, virtualWidth) {
            return this.px(virtualX + virtualWidth) - this.px(virtualX)
        }

        function spanY(virtualY, virtualHeight) {
            return this.py(virtualY + virtualHeight) - this.py(virtualY)
        }
    }
}

if (!("fonts" in getroottable())) {
    // game.* are game-font NAMES, not handles - UI.pushFont and UI.textSize take either, and EUR
    // only ever uses verdana and verdanaSml. body is a real loadFont handle, kept for parity with
    // the base copy; a missing ttf must not take the module down with it, hence the try.
    ::fonts <- {
        body = 0,
        game = {
            tnrMed     = "tnr_med",
            verdana    = "verdana",
            verdanaSml = "verdana_sml",
        }
    }
    try { ::fonts.body = ::UI.loadFont("fonts/verdana.ttf") }
    catch (e) { println("eur: fonts.body unavailable - " + e) }
}

// ONE SCALE. Everything EUR authors is in 1080p units and UI.dpiScale() (= screenH/1080, continuous)
// turns it into pixels - widgets through Cap.autoScale, canvas drawing through Cap.autoScaleDraw.
// The engine's separate 1024x768 factor is not a second scale: on any 16:9 screen it is just this
// one times a constant, and that constant is already baked into whatever number was eyeballed.
//
// Only three calls hand back PHYSICAL px - widgetRectGet, contentRect and screenSize - so those come
// back through here and everything else in the mod is authored units end to end.
::authored <- {
    function of(v) {
        local f = ::UI.dpiScale()
        if (f <= 0.0 || f == 1.0) { return v }
        return (v / f + 0.5).tointeger()
    }

    function rect(r) {
        if (r == null) { return null }
        return [this.of(r[0]), this.of(r[1]), this.of(r[2]), this.of(r[3])]
    }

    // Answers 0,0 rather than throwing when the device is down - ensure() runs at the main menu,
    // and a throw there leaves a half-built window class poisoned for the rest of the session.
    function screen() {
        local s = ::UI.screenSize()
        if (s == null || s.len() < 2) { return [0, 0] }
        return [this.of(s[0]), this.of(s[1])]
    }

    // GAME SPACE, for the few things that must sit on the game's own HUD art rather than in our
    // layout. The game stretches its 1024x768 art by (W/1024, H/768); we work in 1080p units that
    // the canvas transform multiplies by dpiScale. Fold the two together and the Y factors cancel
    // exactly - dpiScale IS H/1080 - so only X carries anything: the aspect ratio against 16:9.
    // On any 16:9 screen both are 1.0 and these are identity.
    function hudX(v) {
        local d = ::UI.dpiScale()
        if (d <= 0.0) { return v }
        local s = ::UI.screenSize()
        if (s == null || s.len() < 2 || s[0] <= 0) { return v }
        return (v * (s[0] / 1920.0) / d + 0.5).tointeger()
    }

    function hudY(v) { return v }

    // The x-only stretch a GAME-SPACE canvas pushes on top of Cap.autoScaleDraw's uniform scale:
    // uniform * this = the engine's own W/1920. 1.0 on any 16:9 screen.
    function hudStretch() {
        local d = ::UI.dpiScale()
        if (d <= 0.0) { return 1.0 }
        local s = ::UI.screenSize()
        if (s == null || s.len() < 2 || s[0] <= 0) { return 1.0 }
        return (s[0] / 1920.0) / d
    }

    // A rect read back inside a GAME-SPACE canvas: x and w carry the engine's horizontal factor,
    // y and h the uniform one. rect() would divide x by the uniform factor and read short.
    function gameRect(r) {
        if (r == null) { return null }
        local d = ::UI.dpiScale()
        local s = ::UI.screenSize()
        local fx = (d > 0.0 && s != null && s.len() >= 2 && s[0] > 0) ? (s[0] / 1920.0) : 1.0
        if (fx <= 0.0) { fx = 1.0 }
        return [(r[0] / fx + 0.5).tointeger(), this.of(r[1]),
                (r[2] / fx + 0.5).tointeger(), this.of(r[3])]
    }
}
