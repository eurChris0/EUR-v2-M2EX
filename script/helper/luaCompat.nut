local _m = require("math")

::EUR.math <- {
    floor  = function(x) { return _m.floor(x).tointeger() },
    ceil   = function(x) { return _m.ceil(x).tointeger() },
    abs    = _m.abs,
    sqrt   = _m.sqrt,
    pow    = _m.pow,
    pi     = _m.PI,
    huge   = 3.0e38,
    min = function(...) {
        local r = vargv[0]
        for (local i = 1; i < vargv.len(); i++) if (vargv[i] < r) r = vargv[i]
        return r
    },
    max = function(...) {
        local r = vargv[0]
        for (local i = 1; i < vargv.len(); i++) if (vargv[i] > r) r = vargv[i]
        return r
    },
    // Lua semantics: () -> float [0,1); (m) -> int [1,m]; (m,n) -> int [m,n].
    random = function(...) {
        if (vargv.len() == 0) return _m.rand().tofloat() / (_m.RAND_MAX + 1.0)
        if (vargv.len() == 1) return 1 + _m.rand() % vargv[0]
        return vargv[0] + _m.rand() % (vargv[1] - vargv[0] + 1)
    },
}

::EUR.table <- {
    insert = function(t, posOrVal, val = null) {
        if (val == null) { t.append(posOrVal) }
        else { t.insert(posOrVal, val) }
    },
    remove = function(t, pos = null) {
        if (pos == null) { return t.pop() }
        return t.remove(pos)
    },
    getn = function(t) { return t.len() },
}

::EUR.bit <- {
    bor    = function(...) { local r = 0;  foreach (v in vargv) r = r | v; return r },
    band   = function(...) { local r = -1; foreach (v in vargv) r = r & v; return r },
    bxor   = function(...) { local r = 0;  foreach (v in vargv) r = r ^ v; return r },
    lshift = function(a, n) { return a << n },
    rshift = function(a, n) { return a >> n },
    bnot   = function(a) { return ~a },
}

local _str = require("string")

::EUR.string <- {
    format = _str.format,
    gsub = function(s, pat, rep) {
        if (pat.len() == 0) return s
        local out = ""
        local idx = s.indexof(pat)
        while (idx != null) {
            out += s.slice(0, idx) + rep
            s = s.slice(idx + pat.len())
            idx = s.indexof(pat)
        }
        return out + s
    },
}

// Lua print: tab-separated args, trailing newline.

::EUR.select <- function(n, ...) {
    if (n == "#") return vargv.len()
    return vargv[n - 1]
}
