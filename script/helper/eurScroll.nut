class eurScroll {

    spritePage     = null
    spriteSetNames = null
    edgeIndex      = null
    closeSeal      = null
    loadedSets     = null

    constructor() {
        this.spritePage = ::UI.PAGE_SHARED

        this.spriteSetNames = {
            scroll = ["SCROLL_TOP_LEFT", "SCROLL_TOP_CENTER", "SCROLL_TOP_RIGHT",
                      "SCROLL_MID_LEFT", "SCROLL_MID", "SCROLL_MID_RIGHT",
                      "SCROLL_BOTTOM_LEFT", "SCROLL_BOTTOM_CENTER", "SCROLL_BOTTOM_RIGHT"],
            panel  = ["FRAME_BORDER_TL", "FRAME_BORDER_TOP", "FRAME_BORDER_TR",
                      "FRAME_BORDER_L",  "TILEABLE_FRAME_BG", "FRAME_BORDER_R",
                      "FRAME_BORDER_BL", "FRAME_BORDER_BOTTOM", "FRAME_BORDER_BR"],
        }

        this.edgeIndex = { left = 3, top = 1, right = 5, bottom = 7 }

        this.closeSeal = { spriteName = "SEAL_BUTTON_IMAGE", insetX = 4,
                           liftHover = 51, liftHeld = 77 }

        this.loadedSets = {}
    }

    function loadSet(setName) {
        if (setName in this.loadedSets) return this.loadedSets[setName]
        if (!(setName in this.spriteSetNames)) return null

        this.loadedSets[setName] <- ::UI.loadSpriteSet(this.spriteSetNames[setName], this.spritePage)
        return this.loadedSets[setName]
    }

    function edgeSizes(set) {
        local left = ::UI.imageSize(set[this.edgeIndex.left]),  top    = ::UI.imageSize(set[this.edgeIndex.top])
        local right = ::UI.imageSize(set[this.edgeIndex.right]), bottom = ::UI.imageSize(set[this.edgeIndex.bottom])
        if (left == null || top == null || right == null || bottom == null) return null

        return { left = left[0], top = top[1], right = right[0], bottom = bottom[1] }
    }

    function drawFrame(set, vx, vy, vw, vh, hollow = false) {
        local parts = set
        if (hollow) {
            parts = clone set
            parts[4] = 0
        }
        ::UI.drawImageNine(parts, ::virtualScale.px(vx), ::virtualScale.py(vy), ::virtualScale.spanX(vx, vw), ::virtualScale.spanY(vy, vh),
                           ::UI.Slice.tile, ::virtualScale.x, ::virtualScale.y)
    }

    function sealOnTop(scroll) {
        if (scroll == null || scroll.sealCanvas == 0) { return }
        ::UI.addChild(scroll.window, scroll.sealCanvas)
        ::UI.setParent(scroll.window)
    }

    function renderSeal(scroll) {
        ::virtualScale.refresh()
        local rect = ::UI.widgetRectGet(scroll.window)
        if (rect == null) return
        this.drawCloseSeal(scroll, rect[0] / ::virtualScale.x, rect[1] / ::virtualScale.y,
                           rect[2] / ::virtualScale.x, rect[3] / ::virtualScale.y)
    }

    function render(scroll) {
        ::virtualScale.refresh()
        local set = this.loadSet("scroll")
        if (set == null) return

        ::virtualScale.refresh()

        local rect = ::UI.widgetRectGet(scroll.window)
        if (rect == null) return

        local windowX = rect[0] / ::virtualScale.x, windowY = rect[1] / ::virtualScale.y
        local windowWidth = rect[2] / ::virtualScale.x, windowHeight = rect[3] / ::virtualScale.y

        this.drawFrame(set, windowX, windowY, windowWidth, windowHeight)
    }

    function drawCloseSeal(scroll, vx, vy, vw, vh) {
        if (scroll.onClose == null) return

        local seal = ::UI.loadSprite(this.closeSeal.spriteName, this.spritePage)
        if (seal.w <= 0 || seal.h <= 0) return

        local sealX = vx + vw - seal.w - this.closeSeal.insetX, sealY = vy + vh - seal.h
        local x = ::virtualScale.px(sealX), y = ::virtualScale.py(sealY)
        local width = ::virtualScale.spanX(sealX, seal.w), height = ::virtualScale.spanY(sealY, seal.h)

        ::UI.pushHitMode(::UI.Hit.alpha)
        local hit = ::UI.imageButton(seal.img, width, height, x, y)
        ::UI.popHitMode()

        if (hit.hovered) {
            local sink = hit.held ? ::UI.getStyle(::UI.Metric.pressOffset) : 0
            local dx = (sink * ::virtualScale.x + 0.5).tointeger(), dy = (sink * ::virtualScale.y + 0.5).tointeger()
            ::UI.pushBlend(1)
            ::UI.image(seal.img, width, height, x + dx, y + dy, 255, 255, 255,
                       hit.held ? this.closeSeal.liftHeld : this.closeSeal.liftHover)
            ::UI.popBlend()
        }

        if (!hit.clicked) return

        ::UI.widgetVisible(scroll.window, false)
        scroll.onClose()
    }

    // The window carries no surface and no border of its own - the 9-slice frame the canvas draws IS
    // the chrome. Re-asserted after a palette repaint, which would otherwise stamp the faction border
    // onto every scroll window.
    function windowChrome(window) {
        ::UI.setWidgetStyle(window, ::UI.Surface.window, [0, 0, 0, 0])
        ::UI.setWidgetStyle(window, ::UI.Colour.border, [0, 0, 0, 0])
        ::UI.setWidgetStyle(window, ::UI.Metric.borderWindow, 0)
        ::UI.setWidgetStyle(window, ::UI.Metric.windowPadX, 0)
        ::UI.setWidgetStyle(window, ::UI.Metric.windowPadY, 0)
    }

    function create(vw, vh, vx, vy, onClose = null) {
        ::virtualScale.refresh()

        ::UI.pushStyle({ [::UI.Cap.autoScale] = 0 })
        local window = ::UI.window("", ::virtualScale.px(vw), ::virtualScale.py(vh), ::virtualScale.px(vx), ::virtualScale.py(vy),
                                   [::UI.WindowFlag.hideTitleBar, ::UI.WindowFlag.noShadow,
                                    ::UI.WindowFlag.notDraggable, ::UI.WindowFlag.fixedSize,
                                    ::UI.WindowFlag.noScrollBodyY])
        ::UI.popStyle()

        this.windowChrome(window)

        local canvas = ::UI.canvas(0, 0)
        ::UI.placeAbsolute(canvas)
        local sealCanvas = ::UI.canvas(0, 0)
        ::UI.placeAbsolute(sealCanvas)
        local scroll = { window = window, canvas = canvas, sealCanvas = sealCanvas, onClose = onClose }
        local component = this
        // Every EUR window root is created here, so this is the one place the palette repaint has to
        // learn about them. basic_4 is the default; a window wanting another sheet re-registers.
        ::EUR.registerStyled(window, "basic_4", function() { component.windowChrome(window) })

        ::UI.canvasDraw(canvas, function() { component.render(scroll) })
        ::UI.canvasDraw(sealCanvas, function() { component.renderSeal(scroll) })
        ::UI.setParent(window)
        return scroll
    }

    function drawSet(setName, vx, vy, vw, vh, hollow = false) {
        local set = this.loadSet(setName)
        if (set == null) return false

        ::virtualScale.refresh()
        this.drawFrame(set, vx, vy, vw, vh, hollow)
        return true
    }

    function setMargins(setName) {
        local set = this.loadSet(setName)
        if (set == null) return null

        local edge = this.edgeSizes(set)
        if (edge == null) return null

        return [(edge.left * ::virtualScale.x).tointeger(), (edge.top * ::virtualScale.y).tointeger(),
                (edge.right * ::virtualScale.x).tointeger(), (edge.bottom * ::virtualScale.y).tointeger()]
    }

}

::EUR.scroll <- eurScroll()
