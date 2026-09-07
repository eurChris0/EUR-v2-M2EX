::EUR.LAYOUT_TARGETS <- [
    { title = "Options window",     holder = "eurOptionsWindow" },
    { title = "General BG swap",    holder = "generalBGSwap" },
    { title = "Unit upgrades",      holder = "unitUpgrades" },
    { title = "Global recruitment", holder = "eurGlobalRecruitment" },
    { title = "Scroll close seal",  holder = "scroll", field = "closeSeal" },
]

class eurLayoutEditor {
    layout = {
        windowX = 300, windowY = 60,
        windowW = 620, windowH = 760,
        pickerW = 560, pickerH = 22,
        sliderW = 330, inputW = 90, rowH = 20,
        sliderPad = 200,
        sliderFloor = -200,
        channelMax = 255,
        previewX = 20, previewY = 40,
        previewW = 460, previewH = 820,
    }

    window      = 0
    tabs        = 0
    layoutPage  = 0
    stylePage   = 0
    layoutPick  = 0
    stylePick   = 0
    layoutBody  = 0
    styleBody   = 0
    dumpPage    = 0
    dumpField   = 0
    dumpBtn     = 0
    preview     = 0
    previewCanvas = 0
    previewTabs = 0
    layoutRows  = null
    styleRows   = null
    styleNames  = null
    tokenName   = null
    built       = false
    shown       = false
    raised      = false
    layoutAt    = -1
    styleAt     = -1

    function ensure() {
        if (this.built) return
        this.layoutRows = []
        this.styleRows = []
        local self = this

        this.window = ::UI.window("EUR live editor", this.layout.windowW, this.layout.windowH,
                                  this.layout.windowX, this.layout.windowY)
        ::UI.setWidgetStyle(this.window, ::UI.Surface.window, [20, 22, 28, 235])
        ::UI.setWidgetStyle(this.window, ::UI.Colour.text, [235, 235, 235, 255])

        this.tabs = ::UI.tabs()
        ::UI.addChild(this.window, this.tabs)

        this.layoutPage = ::UI.panel()
        ::UI.addChild(this.tabs, this.layoutPage)
        local layoutTitles = []
        foreach (t in ::EUR.LAYOUT_TARGETS) { layoutTitles.append(t.title) }
        this.layoutPick = ::UI.select("", this.layout.pickerW, this.layout.pickerH)
        ::UI.selectOptions(this.layoutPick, layoutTitles)
        ::UI.addChild(this.layoutPage, this.layoutPick)
        ::UI.selectChange(this.layoutPick, function(i) { self.showLayout(i) })
        this.layoutBody = ::UI.panel()
        ::UI.addChild(this.layoutPage, this.layoutBody)

        this.stylePage = ::UI.panel()
        ::UI.addChild(this.tabs, this.stylePage)
        this.styleNames = []
        if ("eurStyles" in ::EUR && ::EUR.eurStyles != null) {
            foreach (name, table in ::EUR.eurStyles) { this.styleNames.append(name) }
        }
        this.styleNames.sort()
        this.stylePick = ::UI.select("", this.layout.pickerW, this.layout.pickerH)
        ::UI.selectOptions(this.stylePick, this.styleNames)
        ::UI.addChild(this.stylePage, this.stylePick)
        ::UI.selectChange(this.stylePick, function(i) { self.showStyle(i) })
        this.styleBody = ::UI.panel()
        ::UI.addChild(this.stylePage, this.styleBody)

        this.dumpPage = ::UI.panel()
        ::UI.addChild(this.tabs, this.dumpPage)
        this.dumpBtn = ::UI.button("Rebuild dump", 140, 24)
        ::UI.addChild(this.dumpPage, this.dumpBtn)
        ::UI.buttonClick(this.dumpBtn, function() { self.refreshDump() })
        this.dumpField = ::UI.inputMultiline("", this.layout.pickerW, 600)
        ::UI.addChild(this.dumpPage, this.dumpField)
        ::UI.inputMultilineReadOnly(this.dumpField, true)

        ::UI.tabsTitles(this.tabs, ["Layout", "Styles", "Output"])

        ::UI.widgetVisible(this.window, false)
        this.buildPreview()
        this.built = true   // LAST: a throw above leaves this false and the next frame retries
    }

    function buildPreview() {
        local self = this
        ::UI.setParent(0)
        this.preview = ::UI.window("Style preview", this.layout.previewW, this.layout.previewH,
                                   this.layout.previewX, this.layout.previewY)
        this.previewCanvas = ::UI.canvas(0, 0)
        ::UI.addChild(this.preview, this.previewCanvas)
        ::UI.placeAbsolute(this.previewCanvas)
        ::UI.canvasDraw(this.previewCanvas, function() { self.drawPreviewFrame() })

        ::UI.addChild(this.preview, ::UI.textWrapped("Wrapped paragraph text for the Text colour."))
        ::UI.addChild(this.preview, ::UI.bullet("A bullet line"))
        ::UI.addChild(this.preview, ::UI.badge("Badge"))
        ::UI.addChild(this.preview, ::UI.link("A link"))
        ::UI.addChild(this.preview, ::UI.separator())
        ::UI.addChild(this.preview, ::UI.button("Button"))
        ::UI.addChild(this.preview, ::UI.checkbox("Checkbox"))
        ::UI.addChild(this.preview, ::UI.toggle("Toggle"))
        ::UI.addChild(this.preview, ::UI.radio("Radio"))
        local bar = ::UI.progress("Progress")
        ::UI.addChild(this.preview, bar)
        ::UI.progressValue(bar, 0.6)
        ::UI.addChild(this.preview, ::UI.slider("Slider", 0, 100, 1))
        ::UI.addChild(this.preview, ::UI.stepper("Stepper"))
        local sel = ::UI.select("Select")
        ::UI.addChild(this.preview, sel)
        ::UI.selectOptions(sel, ["First", "Second", "Third"])
        ::UI.addChild(this.preview, ::UI.input("Input"))
        ::UI.addChild(this.preview, ::UI.inputMultiline("", 0, 60))

        this.previewTabs = ::UI.tabs()
        ::UI.addChild(this.preview, this.previewTabs)
        local one = ::UI.panel()
        ::UI.addChild(this.previewTabs, one)
        ::UI.addChild(one, ::UI.textWrapped("Tab page one"))
        local two = ::UI.panel()
        ::UI.addChild(this.previewTabs, two)
        ::UI.addChild(two, ::UI.textWrapped("Tab page two"))
        ::UI.tabsTitles(this.previewTabs, ["Alpha", "Beta"])

        ::UI.setParent(0)
        ::UI.widgetVisible(this.preview, false)
    }

    function drawPreviewFrame() {
        if (!("scroll" in ::EUR) || ::EUR.scroll == null) return
        local r = ::authored.rect(::UI.widgetRectGet(this.preview))
        if (r == null) return
        ::EUR.scroll.drawSet("panel", r[0], r[1],
                                      r[2], r[3])
    }

    function tokenNames() {
        if (this.tokenName != null) return this.tokenName
        this.tokenName = {}
        foreach (group in ["Colour", "Surface", "Metric", "Font", "Cap"]) {
            if (!(group in ::UI)) continue
            foreach (name, id in ::UI[group]) {
                if (typeof(id) == "integer") { this.tokenName[id] <- group + "." + name }
            }
        }
        return this.tokenName
    }

    function clearRows(rows) {
        foreach (r in rows) { ::UI.destroy(r) }
        rows.clear()
    }

    function addNumber(parent, rows, label, value, lo, hi, setFn) {
        local slider = ::UI.slider(label, lo, hi, 1, this.layout.sliderW, this.layout.rowH)
        ::UI.setWidgetStyle(slider, ::UI.Metric.labelMaxPct, 100)
        ::UI.addChild(parent, slider)
        rows.append(slider)

        local field = ::UI.input("", this.layout.inputW, this.layout.rowH)
        ::UI.addChild(parent, field)
        rows.append(field)

        ::UI.sliderValue(slider, value)
        ::UI.textSet(field, "" + value)

        ::UI.sliderChange(slider, function(v) {
            local n = v.tointeger()
            setFn(n)
            ::UI.textSet(field, "" + n)
        })
        ::UI.inputSubmit(field, function(text) {
            local n = text.tointeger()
            setFn(n)
            ::UI.sliderValue(slider, n)
        })
    }

    function addFlag(parent, rows, label, value, setFn) {
        local box = ::UI.checkbox(label)
        ::UI.setWidgetStyle(box, ::UI.Metric.labelMaxPct, 100)
        ::UI.addChild(parent, box)
        rows.append(box)
        ::UI.checkboxValue(box, value ? 1 : 0)
        ::UI.checkboxChange(box, function(v) { setFn(v ? true : false) })
    }

    function showLayout(index) {
        this.layoutAt = index
        this.clearRows(this.layoutRows)

        local table = null
        if (index >= 0 && index < ::EUR.LAYOUT_TARGETS.len()) {
            local spec = ::EUR.LAYOUT_TARGETS[index]
            if (spec.holder in ::EUR) {
                local obj = ::EUR[spec.holder]
                local field = ("field" in spec) ? spec.field : "layout"
                if (obj != null && (field in obj)) { table = obj[field] }
            }
        }
        if (table == null) {
            local miss = ::UI.textWrapped("Nothing to edit here yet.")
            ::UI.addChild(this.layoutBody, miss)
            this.layoutRows.append(miss)
            return
        }

        local names = []
        foreach (key, value in table) { names.append(key) }
        names.sort()

        foreach (key in names) {
            local value = table[key]
            local kind = typeof(value)
            if (kind == "integer" || kind == "float") {
                local lo = (value < this.layout.sliderFloor) ? value : this.layout.sliderFloor
                local hi = value + this.layout.sliderPad
                if (hi < 100) hi = 100
                this.addNumber(this.layoutBody, this.layoutRows, key, value, lo, hi,
                               function(n) { table[key] = n })
            }
            else if (kind == "bool") {
                this.addFlag(this.layoutBody, this.layoutRows, key, value,
                             function(b) { table[key] = b })
            }
        }
    }

    function showStyle(index) {
        this.styleAt = index
        this.clearRows(this.styleRows)
        if (index < 0 || index >= this.styleNames.len()) return

        local sheet = ::EUR.eurStyles[this.styleNames[index]]
        local names = this.tokenNames()

        local note = ::UI.textWrapped("Edits write the table AND the global theme, so you see them now. "
                                      + "Widgets already built keep their snapshot until a reload.")
        ::UI.addChild(this.styleBody, note)
        this.styleRows.append(note)

        foreach (token, value in sheet) {
            if (typeof(token) != "integer") continue
            local label = (token in names) ? names[token] : ("token " + token)
            local kind = typeof(value)

            if (kind == "integer") {
                this.addNumber(this.styleBody, this.styleRows, label, value, -50, 400,
                               function(n) { sheet[token] = n; ::UI.setStyle(token, n) })
            }
            else if (kind == "array" && value.len() == 4) {
                local channels = ["r", "g", "b", "a"]
                for (local c = 0; c < 4; ++c) {
                    local at = c
                    this.addNumber(this.styleBody, this.styleRows, label + " " + channels[c],
                                   value[c], 0, this.layout.channelMax,
                                   function(n) { value[at] = n; ::UI.setStyle(token, value) })
                }
            }
        }
    }

    function buildDump() {
        local nl = "\n"
        local out = "// ---- LAYOUT TABLES ----" + nl
        foreach (spec in ::EUR.LAYOUT_TARGETS) {
            if (!(spec.holder in ::EUR)) continue
            local obj = ::EUR[spec.holder]
            local field = ("field" in spec) ? spec.field : "layout"
            if (obj == null || !(field in obj)) continue
            local table = obj[field]
            out += nl + "// " + spec.title + "  (::EUR." + spec.holder + "." + field + ")" + nl
            out += field + " = {" + nl
            local names = []
            foreach (key, value in table) { names.append(key) }
            names.sort()
            foreach (key in names) {
                local v = table[key]
                local kind = typeof(v)
                if (kind == "integer" || kind == "float") {
                    out += "    " + key + " = " + v + "," + nl
                } else if (kind == "bool") {
                    out += "    " + key + " = " + (v ? "true" : "false") + "," + nl
                }
            }
            out += "}" + nl
        }

        out += nl + "// ---- STYLE TABLES ----" + nl
        if (!("eurStyles" in ::EUR) || ::EUR.eurStyles == null) { return out }
        local names = this.tokenNames()
        foreach (sheetName in this.styleNames) {
            local sheet = ::EUR.eurStyles[sheetName]
            out += nl + sheetName + " = {" + nl
            foreach (token, value in sheet) {
                if (typeof(token) != "integer") continue
                local label = (token in names) ? ("[::UI." + names[token] + "]") : ("[" + token + "]")
                local kind = typeof(value)
                if (kind == "integer") {
                    out += "    " + label + " = " + value + "," + nl
                } else if (kind == "array" && value.len() == 4) {
                    out += "    " + label + " = [" + value[0] + ", " + value[1] + ", "
                           + value[2] + ", " + value[3] + "]," + nl
                }
            }
            out += "}" + nl
        }
        return out
    }

    function refreshDump() {
        ::UI.textSet(this.dumpField, this.buildDump())
    }

    function toggle() {
        this.ensure()
        this.shown = !this.shown
        ::UI.widgetVisible(this.window, this.shown)
        if (!this.shown) { this.raised = false; return }
        if (this.layoutAt < 0) { this.showLayout(0) }
        if (this.styleAt < 0)  { this.showStyle(0) }
        this.refreshDump()
        if (!this.raised) { this.raised = true; ::UI.raise(this.window) }
    }

    function render() {
        if (::UI.keyboard.pressed(::UI.Key.p, false)) { this.toggle() }
        if (!this.built) return
        local wantPreview = this.shown && ::UI.tabsActiveGet(this.tabs) == 1
        ::UI.widgetVisible(this.preview, wantPreview)
    }
}

println("EUR: layout editor loaded - press P")
::EUR.eurLayoutEditor <- eurLayoutEditor()
::UI.onFrame(function() { ::EUR.eurLayoutEditor.render() })
