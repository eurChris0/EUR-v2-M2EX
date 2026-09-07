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
        // Authored units in. The SLICE scale keeps the game's own non-uniform stretch - that is what
        // makes the frame read as the game's UI rather than a flat bitmap - expressed RELATIVE to the
        // one scale, because the canvas transform multiplies by dpiScale on the way out. On 16:9 the
        // ratio is the constant 1.875 / 1.40625; on 21:9 it widens, exactly as the game's own art does.
        ::virtualScale.refresh()
        local baseScale = ::UI.dpiScale()
        if (baseScale <= 0.0) { baseScale = 1.0 }
        // UNIFORM, off the Y ratio. Per-axis was the bug: virtualScale.y/dpiScale reduces to the
        // constant 1080/768, but virtualScale.x/dpiScale is (W/1024)/(H/1080) - it carries the
        // ASPECT RATIO, so the frame over- or under-stretched horizontally at anything but 16:9,
        // and disagreed with the vertical even at 1080p.
        local frameScale = ::virtualScale.y / baseScale
        ::UI.drawImageNine(parts, vx, vy, vw, vh, ::UI.Slice.tile, frameScale, frameScale)
    }

    function sealOnTop(scroll) {
        if (scroll == null || scroll.sealCanvas == 0) { return }
        ::UI.addChild(scroll.window, scroll.sealCanvas)
        ::UI.setParent(scroll.window)
    }

    function renderSeal(scroll) {
        local rect = ::authored.rect(::UI.widgetRectGet(scroll.window))
        if (rect == null) return
        this.drawCloseSeal(scroll, rect[0], rect[1], rect[2], rect[3])
    }

    function render(scroll) {
        local set = this.loadSet("scroll")
        if (set == null) return


        local rect = ::authored.rect(::UI.widgetRectGet(scroll.window))
        if (rect == null) return

        this.drawFrame(set, rect[0], rect[1], rect[2], rect[3])
    }

    function drawCloseSeal(scroll, vx, vy, vw, vh) {
        if (scroll.onClose == null) return

        local seal = ::UI.loadSprite(this.closeSeal.spriteName, this.spritePage)
        if (seal.w <= 0 || seal.h <= 0) return

        // The seal rides the frame, so it takes the frame's stretch - the same ratio drawFrame
        // hands the 9-slice, not our base scale.
        ::virtualScale.refresh()
        local sealScale = ::UI.dpiScale()
        if (sealScale <= 0.0) { sealScale = 1.0 }
        local sealRatio = ::virtualScale.y / sealScale
        local width = (seal.w * sealRatio + 0.5).tointeger()
        local height = (seal.h * sealRatio + 0.5).tointeger()
        local x = vx + vw - width - this.closeSeal.insetX, y = vy + vh - height

        ::UI.pushHitMode(::UI.Hit.alpha)
        local hit = ::UI.imageButton(seal.img, width, height, x, y)
        ::UI.popHitMode()

        if (hit.hovered) {
            local sink = hit.held ? ::UI.getStyle(::UI.Metric.pressOffset) : 0
            local dx = sink, dy = sink
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

    // Every window class re-places its scroll each frame with authored numbers, and the window was
    // created with Cap.autoScale off, so those land as literal physical px. Windowed mode and small
    // or short screens are then smaller than the window. One clamp, here, for all of them: identity
    // whenever the window already fits.
    function place(window, x, y, w, h) {
        local screen = ::authored.screen()
        if (screen[0] <= 0 || screen[1] <= 0) { ::UI.widgetRect(window, x, y, w, h); return }
        if (w > screen[0]) { w = screen[0] }
        if (h > screen[1]) { h = screen[1] }
        if (x + w > screen[0]) { x = screen[0] - w }
        if (y + h > screen[1]) { y = screen[1] - h }
        if (x < 0) { x = 0 }
        if (y < 0) { y = 0 }
        ::UI.widgetRect(window, x, y, w, h)
    }

    // GAME SPACE placement, for the LEFT PANELS only. Those sit in the game's own scroll slot and
    // have to contort with it, so they take the engine's non-uniform factor instead of our uniform
    // one: x by W/1920, y by H/1080. Folded against dpiScale, which widgetRect applies on the way
    // in, that is exactly ::authored.hudX / hudY. Identity on any 16:9 screen.
    // Freestanding windows - options, notices, accept panels - keep place() and stay uniform.
    function placeGame(window, x, y, w, h) {
        this.place(window, ::authored.hudX(x), ::authored.hudY(y),
                           ::authored.hudX(w), ::authored.hudY(h))
    }

    function create(vw, vh, vx, vy, onClose = null) {

        // The authored size goes through the engine's 1024x768 factor, whose VERTICAL half is
        // screenH/768 - so an 835-tall window is 1174px on a 1080p screen and has always spilled off
        // the bottom. On a 21:9 screen the two halves diverge and it spills sideways too. Clamp to
        // the screen: identity wherever the window already fitted.
        local screen = ::authored.screen()
        local winW = vw, winH = vh, winX = vx, winY = vy
        if (screen[0] <= 0 || screen[1] <= 0) { screen = [winX + winW, winY + winH] }   // device down
        if (winW > screen[0]) { winW = screen[0] }
        if (winH > screen[1]) { winH = screen[1] }
        if (winX + winW > screen[0]) { winX = screen[0] - winW }
        if (winY + winH > screen[1]) { winY = screen[1] - winH }
        if (winX < 0) { winX = 0 }
        if (winY < 0) { winY = 0 }

        ::UI.pushStyle({ [::UI.Cap.autoScalePos] = 1, [::UI.Cap.autoScaleDraw] = 1 })
        local window = ::UI.window("", winW, winH, winX, winY,
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

        this.drawFrame(set, vx, vy, vw, vh, hollow)
        return true
    }

    function setMargins(setName) {
        local set = this.loadSet(setName)
        if (set == null) return null

        local edge = this.edgeSizes(set)
        if (edge == null) return null

        // The margins inset by the STRETCHED edge art, so they carry the same ratio the slice does.
        ::virtualScale.refresh()
        local baseScale = ::UI.dpiScale()
        if (baseScale <= 0.0) { baseScale = 1.0 }
        // Same uniform ratio the frame is drawn with, or the margins would not match its edges.
        local edgeScale = ::virtualScale.y / baseScale
        return [(edge.left * edgeScale + 0.5).tointeger(),
                (edge.top * edgeScale + 0.5).tointeger(),
                (edge.right * edgeScale + 0.5).tointeger(),
                (edge.bottom * edgeScale + 0.5).tointeger()]
    }

}

::EUR.scroll <- eurScroll()
