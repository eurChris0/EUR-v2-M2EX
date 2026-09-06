// ---------------------------------------------------------------------------------------------
// The widget palette. With no player faction - the main menu, or a faction missing from
// fact_inner_colour (united / slave / scripts are) - these are the literal greys the mod shipped
// with. With one, every role is a shade of that faction's inner colour, so the whole widget set
// reads as the player's livery. ::UI.shade is native: it clamps and rounds, so a lighten can never
// clip past 255 nor a darken below 0.
//
// fact_inner_colour stores FLOATS 0..1; widget colours are ints 0..255. Round, don't truncate -
// 0.82 * 255 is 209.1, and passing the bare float through would paint the widget black.
local function facCol(name) {
    if (name == null || !(name in ::EUR.fact_inner_colour)) { return null }
    local f = ::EUR.fact_inner_colour[name]
    return [(f.r * 255.0 + 0.5).tointeger(), (f.g * 255.0 + 0.5).tointeger(),
            (f.b * 255.0 + 0.5).tointeger(), 255]
}

// The marks go DARKER than a luma match would suggest: the tinted fills sit well below the old
// white-over-parchment wash, so a mid-grey tick on them would fall to about 2.5:1.
local function palette(facName) {
    local b = facCol(facName)
    if (b == null) {
        return { fill = [255, 255, 255, 180], fillHover = [255, 255, 255, 215], fillHeld = [255, 255, 255, 240],
                 btn = [222, 222, 222, 255], btnHover = [236, 236, 236, 255], btnHeld = [248, 248, 248, 255],
                 border = [70, 70, 70, 255], mark = [128, 128, 128, 255],
                 sep = [0, 0, 0, 160], accent = [128, 128, 128, 0] }
    }
    local light = function(c, t) { return ::UI.shade(c[0], c[1], c[2], c[3], t) }
    local dark  = function(c, t, a) { local d = ::UI.shade(c[0], c[1], c[2], c[3], -t); return [d[0], d[1], d[2], a] }
    return { fill = light(b, 0.30), fillHover = light(b, 0.42), fillHeld = light(b, 0.54),
             btn = light(b, 0.30), btnHover = light(b, 0.45), btnHeld = light(b, 0.60),
             border = dark(b, 0.62, 255), mark = dark(b, 0.45, 255),
             sep = dark(b, 0.75, 160), accent = [b[0], b[1], b[2], 0] }
}

// Every palette-driven token in the two LIVE sheets, by role. Same shape as TOOLTIP_TOKENS below.
// checkboxBox stays in the FILL family on purpose: it is the box background, shared with
// progressTrack / sunken / scrollbar, and darkening it alone would bury the tick drawn on it.
local PALETTE_TOKENS = [
    [::UI.Surface, "frameBg",          "fill"],
    [::UI.Surface, "checkboxBox",      "fill"],
    [::UI.Surface, "radioBox",         "fill"],
    [::UI.Surface, "progressTrack",    "fill"],
    [::UI.Surface, "sunken",           "fill"],
    [::UI.Surface, "scrollbar",        "fill"],
    [::UI.Surface, "frameBgHovered",   "fillHover"],
    [::UI.Surface, "frameBgActive",    "fillHeld"],
    [::UI.Surface, "button",           "btn"],
    [::UI.Surface, "header",           "btn"],
    [::UI.Surface, "tab",              "btn"],
    [::UI.Surface, "buttonHovered",    "btnHover"],
    [::UI.Surface, "headerHovered",    "btnHover"],
    [::UI.Surface, "tabHovered",       "btnHover"],
    [::UI.Surface, "buttonActive",     "btnHeld"],
    [::UI.Surface, "headerActive",     "btnHeld"],
    [::UI.Surface, "tabActive",        "btnHeld"],
    [::UI.Colour,  "border",           "border"],
    [::UI.Surface, "checkboxMark",     "mark"],
    [::UI.Surface, "radioDot",         "mark"],
    [::UI.Surface, "scrollGrabber",    "mark"],
    [::UI.Surface, "selectArrow",      "mark"],
    [::UI.Colour,  "check",            "mark"],
    [::UI.Colour,  "sliderGrab",       "mark"],
    [::UI.Colour,  "sliderGrabActive", "mark"],
    [::UI.Colour,  "separator",        "sep"],
    [::UI.Colour,  "accent",           "accent"],
]

local LIVE_SHEETS = ["basic_4", "options_1"]

local greyLight = [200, 200, 200, 255]
local grey      = [128, 128, 128, 255]
local greyDark  = [70, 70, 70, 255]
local frameFill  = [255, 255, 255, 180]
local frameHover = [255, 255, 255, 215]
local frameHeld  = [255, 255, 255, 240]

// buttons and tabs sit ON the parchment rather than in a sunken frame, so they take a much
// lighter wash than the controls do
// buttons are SOLID light grey; every other control keeps the translucent white wash
local buttonFill  = [222, 222, 222, 255]
local buttonHover = [236, 236, 236, 255]
local buttonHeld  = [248, 248, 248, 255]

// the slider FILL is Colour.accent, shared with the progress bar - alpha 0 leaves only the grab
local sliderFill = [128, 128, 128, 0]
local separator  = [0, 0, 0, 160]

local function metricSheet(rows) {
    local sheet = {}
    foreach (row in rows) {
        if (row[0] in ::UI.Metric) { sheet[::UI.Metric[row[0]]] <- row[1] }
    }
    return sheet
}

::EUR.eurStyles <- {

    options_types = {
        slider  = metricSheet([["labelMaxPct", 100]]),
        stepper = metricSheet([["labelMaxPct", 100]]),
        select  = metricSheet([["labelMaxPct", 100]]),
        sep     = metricSheet([["maxW", 300]]),
    },

    options_control = {
        slider  = 300,
        stepper = 300,
        select  = 300,
    },

    basic_types = {
        slider  = metricSheet([["labelMaxPct", 100]]),
        stepper = metricSheet([["labelMaxPct", 100]]),
        select  = metricSheet([["labelMaxPct", 100]]),
        sep     = metricSheet([["maxW", 200]]),
        input   = metricSheet([["maxW", 200]]),
    },

    basic_control = {
        slider  = 200,
        stepper = 200,
        select  = 200,
    },

    basic_1 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.windowPadX]      = 5,
        [::UI.Metric.windowPadY]      = 5,
        [::UI.Metric.padX]            = 5,
        [::UI.Metric.padY]            = 5,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = [0, 0, 0, 0],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 51],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 128],
        [::UI.Colour.separator]       = [255, 255, 255, 128],
        [::UI.Colour.border]          = [255, 255, 255, 255],
        [::UI.Colour.text]            = [0, 0, 0, 255],
    },

    basic_2 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.padX]            = 5,
        [::UI.Metric.padY]            = 5,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = [0, 0, 0, 0],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 51],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 128],
        [::UI.Colour.separator]       = [255, 255, 255, 128],
        [::UI.Colour.border]          = [255, 255, 255, 0],
        [::UI.Colour.text]            = [0, 0, 0, 255],
    },

    basic_3 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.gap]             = 1,
        [::UI.Metric.indent]          = 0,
        [::UI.Metric.gapInner]        = 0,
        [::UI.Metric.padX]            = 0,
        [::UI.Metric.padY]            = 0,
        [::UI.Metric.roundFrame]      = 0,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = [255, 255, 255, 51],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 128],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 179],
        [::UI.Colour.separator]       = [255, 255, 255, 0],
        [::UI.Colour.border]          = [255, 255, 255, 0],
        [::UI.Colour.text]            = [0, 0, 0, 255],
    },

    basic_4 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.gap]             = 1,
        [::UI.Metric.indent]          = 0,
        [::UI.Metric.gapInner]        = 2,
        [::UI.Metric.padX]            = 0,
        [::UI.Metric.padY]            = 0,
        [::UI.Metric.roundFrame]      = 0,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = buttonFill,
        [::UI.Surface.buttonHovered]  = buttonHover,
        [::UI.Surface.buttonActive]   = buttonHeld,
        [::UI.Colour.separator]       = separator,
        [::UI.Colour.border]          = greyDark,
        [::UI.Metric.borderFrame]     = 1,
        [::UI.Surface.header]         = buttonFill,
        [::UI.Surface.headerHovered]  = buttonHover,
        [::UI.Surface.headerActive]   = buttonHeld,
        [::UI.Metric.popupMaxRows]    = 20,
        [::UI.Metric.borderPopup]     = 1,
        [::UI.Surface.popup]          = [240, 228, 208, 255],
        [::UI.Colour.rowHover]        = [0, 0, 0, 40],
        [::UI.Colour.rowSel]          = [0, 0, 0, 70],
        [::UI.Surface.selectArrow]    = grey,
        [::UI.Colour.text]            = [0, 0, 0, 255],
        [::UI.Surface.window]         = [0, 0, 0, 0],
        [::UI.Surface.panel]          = [0, 0, 0, 0],
        [::UI.Surface.panelAlt]       = [0, 0, 0, 0],
        [::UI.Surface.progressTrack]  = frameFill,
        [::UI.Surface.checkboxBox]    = frameFill,
        [::UI.Surface.radioBox]       = frameFill,
        [::UI.Surface.frameBg]        = frameFill,
        [::UI.Surface.frameBgHovered] = frameHover,
        [::UI.Surface.frameBgActive]  = frameHeld,
        [::UI.Surface.sunken]         = frameFill,
        [::UI.Surface.scrollbar]      = frameFill,
        [::UI.Surface.checkboxMark]   = grey,
        [::UI.Surface.radioDot]       = grey,
        [::UI.Surface.scrollGrabber]  = grey,
        [::UI.Colour.accent]          = sliderFill,
        [::UI.Colour.check]           = grey,
        [::UI.Colour.sliderGrab]      = grey,
        [::UI.Colour.sliderGrabActive] = grey,
    },

    basic_5 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.padX]            = 5,
        [::UI.Metric.padY]            = 5,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = [0, 0, 0, 0],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 51],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 128],
        [::UI.Colour.separator]       = [255, 255, 255, 128],
        [::UI.Colour.border]          = [255, 255, 255, 0],
        [::UI.Colour.text]            = [0, 0, 0, 255],
    },

    basic_6 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.gap]             = 1,
        [::UI.Metric.indent]          = 0,
        [::UI.Metric.gapInner]        = 0,
        [::UI.Metric.padX]            = 0,
        [::UI.Metric.padY]            = 0,
        [::UI.Metric.roundFrame]      = 0,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = [255, 255, 255, 51],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 128],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 179],
        [::UI.Colour.separator]       = [0, 0, 0, 255],
        [::UI.Colour.border]          = [255, 255, 255, 0],
        [::UI.Surface.frameBg]        = [240, 228, 208, 255],
        [::UI.Colour.text]            = [0, 0, 0, 255],
    },

    fort_button = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.gap]             = 1,
        [::UI.Metric.indent]          = 0,
        [::UI.Metric.gapInner]        = 0,
        [::UI.Metric.padX]            = 0,
        [::UI.Metric.padY]            = 0,
        [::UI.Metric.roundFrame]      = 0,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = [255, 255, 255, 128],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 128],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 128],
        [::UI.Colour.separator]       = [0, 0, 0, 255],
        [::UI.Colour.border]          = [0, 0, 0, 255],
        [::UI.Surface.frameBg]        = [240, 228, 208, 255],
        [::UI.Colour.text]            = [0, 0, 0, 255],
    },

    tooltip = {},

    battle_1 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.windowPadX]      = 0,
        [::UI.Metric.windowPadY]      = 0,
        [::UI.Metric.gap]             = 1,
        [::UI.Metric.indent]          = 0,
        [::UI.Metric.gapInner]        = 0,
        [::UI.Metric.padX]            = 0,
        [::UI.Metric.padY]            = 0,
        [::UI.Metric.roundFrame]      = 0,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Surface.button]         = [0, 0, 0, 0],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 51],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 128],
        [::UI.Colour.separator]       = [255, 255, 255, 128],
        [::UI.Surface.frameBg]        = [51, 51, 51, 255],
        [::UI.Colour.border]          = [255, 255, 161, 0],
        [::UI.Colour.text]            = [255, 255, 161, 204],
    },

    options_1 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Metric.borderWindow]    = 0,
        [::UI.Metric.padX]            = 5,
        [::UI.Metric.padY]            = 5,
        [::UI.Metric.gapInner]        = 2,
        [::UI.Metric.windowPadX]      = 50,
        [::UI.Metric.windowPadY]      = 50,
        [::UI.Surface.button]         = buttonFill,
        [::UI.Surface.buttonHovered]  = buttonHover,
        [::UI.Surface.buttonActive]   = buttonHeld,
        [::UI.Colour.separator]       = separator,
        [::UI.Colour.border]          = greyDark,
        [::UI.Metric.borderFrame]     = 1,
        [::UI.Surface.frameBg]        = frameFill,
        [::UI.Surface.frameBgHovered] = frameHover,
        [::UI.Surface.frameBgActive]  = frameHeld,
        [::UI.Surface.popup]          = [240, 228, 208, 255],
        [::UI.Metric.tabWidth]        = -1,
        [::UI.Metric.tabPadY]         = 4,
        [::UI.Metric.borderTab]       = 1,
        [::UI.Surface.tabBar]         = [0, 0, 0, 0],
        [::UI.Surface.tab]            = buttonFill,
        [::UI.Surface.tabHovered]     = buttonHover,
        [::UI.Surface.tabActive]      = buttonHeld,
        [::UI.Surface.header]         = buttonFill,
        [::UI.Surface.headerHovered]  = buttonHover,
        [::UI.Surface.headerActive]   = buttonHeld,
        [::UI.Metric.popupMaxRows]    = 20,
        [::UI.Metric.borderPopup]     = 1,
        [::UI.Surface.popup]          = [240, 228, 208, 255],
        [::UI.Colour.rowHover]        = [0, 0, 0, 40],
        [::UI.Colour.rowSel]          = [0, 0, 0, 70],
        [::UI.Surface.selectArrow]    = grey,
        [::UI.Colour.text]            = [0, 0, 0, 255],
        [::UI.Surface.window]         = [0, 0, 0, 0],
        [::UI.Surface.panel]          = [0, 0, 0, 0],
        [::UI.Surface.panelAlt]       = [0, 0, 0, 0],
        [::UI.Surface.progressTrack]  = frameFill,
        [::UI.Surface.checkboxBox]    = frameFill,
        [::UI.Surface.radioBox]       = frameFill,
        [::UI.Surface.sunken]         = frameFill,
        [::UI.Surface.scrollbar]      = frameFill,
        [::UI.Surface.checkboxMark]   = grey,
        [::UI.Surface.radioDot]       = grey,
        [::UI.Surface.scrollGrabber]  = grey,
        [::UI.Colour.accent]          = sliderFill,
        [::UI.Colour.check]           = grey,
        [::UI.Colour.sliderGrab]      = grey,
        [::UI.Colour.sliderGrabActive] = grey,
    },

    button_1 = {
        [::UI.Metric.fontSize]        = 12,
        [::UI.Surface.button]         = [0, 0, 0, 0],
        [::UI.Surface.buttonHovered]  = [255, 255, 255, 0],
        [::UI.Surface.buttonActive]   = [255, 255, 255, 0],
        [::UI.Colour.border]          = [255, 255, 161, 0],
        [::UI.Colour.text]            = [0, 0, 0, 255],
    },

}

local TOOLTIP_TOKENS = [
    [::UI.Colour,  "tooltipText",   [255, 245, 139, 255]],
    [::UI.Colour,  "tooltipBorder", [255, 245, 139, 255]],
    [::UI.Surface, "tooltip",       [0, 0, 0, 127]],
    [::UI.Metric,  "tooltipPadX",   4],
    [::UI.Metric,  "tooltipPadY",   4],
    [::UI.Metric,  "roundTooltip",  0],
    [::UI.Metric,  "borderTooltip", 2],
    [::UI.Metric,  "tooltipOffX",   24],
    [::UI.Metric,  "tooltipOffY",   34],
    [::UI.Metric,  "tooltipDelay",  0],
]

if ("tabPadX" in ::UI.Metric) { ::EUR.eurStyles.options_1[::UI.Metric.tabPadX] <- 12 }

foreach (row in TOOLTIP_TOKENS) {
    if (row[1] in row[0]) { ::EUR.eurStyles.tooltip[row[0][row[1]]] <- row[2] }
}

::EUR.applyTooltipTheme <- function() {
    foreach (token, value in ::EUR.eurStyles.tooltip) { ::UI.setStyle(token, value) }
}

::EUR.applyTooltipTheme()

// Rebuilt once per campaign, from campaignBoot, as soon as the player faction is known - and once
// with null at load so the shipped literals and the builder can never disagree. No window may be
// built before this runs: pushStyle is snapshotted into each widget at creation, so a widget made
// under the grey palette keeps it.
::EUR.buildStyles <- function(facName) {
    local p = palette(facName)
    foreach (sheetName in LIVE_SHEETS) {
        local sheet = ::EUR.eurStyles[sheetName]
        foreach (row in PALETTE_TOKENS) {
            if (!(row[1] in row[0])) { continue }
            sheet[row[0][row[1]]] <- p[row[2]]
        }
    }
}

::EUR.buildStyles(null)

// Token ids resolved once. Same rows as PALETTE_TOKENS, minus any this build does not carry.
local PALETTE_IDS = []
foreach (row in PALETTE_TOKENS) {
    if (row[1] in row[0]) { PALETTE_IDS.append(row[0][row[1]]) }
}

// Roots whose subtrees carry the palette, registered by each window as it builds. A repaint walks
// THESE rather than the whole forest, because the dev windows and the SqUI console have their own
// themes and must not be tinted.
::EUR.styledRoots <- []

::EUR.registerStyled <- function(root, sheetName, after = null) {
    if (root == null || root == 0) { return }
    foreach (entry in ::EUR.styledRoots) {
        if (entry.root == root) {          // re-registering claims a different sheet, e.g. options_1
            entry.sheet = sheetName
            entry.after = after
            return
        }
    }
    ::EUR.styledRoots.append({ root = root, sheet = sheetName, after = after })
}

// Re-applies the palette to widgets that ALREADY EXIST. pushStyle is snapshotted into a widget at
// creation, so every window built before the faction was known keeps the grey palette; setWidgetStyle
// is the only way back in. Palette tokens only - applying a whole sheet would also stamp over the
// per-widget overrides a window sets deliberately, which is what `after` exists to re-assert.
::EUR.repaintStyles <- function() {
    foreach (entry in ::EUR.styledRoots) {
        if (!(entry.sheet in ::EUR.eurStyles)) { continue }
        local sheet = ::EUR.eurStyles[entry.sheet]
        local rows = ::UI.widgetTree(entry.root)
        if (rows != null) {
            foreach (row in rows) {
                foreach (token in PALETTE_IDS) {
                    if (token in sheet) { ::UI.setWidgetStyle(row.handle, token, sheet[token]) }
                }
            }
        }
        if (entry.after != null) { entry.after() }
    }
}
