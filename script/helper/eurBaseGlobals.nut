

if (!("virtualScale" in getroottable())) {

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

    function screen() {
        local s = ::UI.screenSize()
        if (s == null || s.len() < 2) { return [0, 0] }
        return [this.of(s[0]), this.of(s[1])]
    }

    function hudX(v) {
        local d = ::UI.dpiScale()
        if (d <= 0.0) { return v }
        local s = ::UI.screenSize()
        if (s == null || s.len() < 2 || s[0] <= 0) { return v }
        return (v * (s[0] / 1920.0) / d + 0.5).tointeger()
    }

    function hudY(v) { return v }

    function hudStretch() {
        local d = ::UI.dpiScale()
        if (d <= 0.0) { return 1.0 }
        local s = ::UI.screenSize()
        if (s == null || s.len() < 2 || s[0] <= 0) { return 1.0 }
        return (s[0] / 1920.0) / d
    }

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
