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
