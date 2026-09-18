class eurScroll {

    style     = null

    constructor() {
        this.style = { [::UI.Colour.border]       = [0, 0, 0, 0],
                       [::UI.Metric.borderWindow] = 0,
                       [::UI.Metric.windowPadX]   = 0,
                       [::UI.Metric.windowPadY]   = 0 }
    }

    function frameRatio() {
        local dpi = ::UI.dpiScale()
        if (dpi <= 0.0) { dpi = 1.0 }
        return ::UI.virtualScale()[1] / dpi
    }

    function windowChrome(window) {
        ::UI.setWidgetStyle(window, ::UI.Colour.border, [0, 0, 0, 0])
        ::UI.setWidgetStyle(window, ::UI.Metric.borderWindow, 0)
        ::UI.setWidgetStyle(window, ::UI.Metric.windowPadX, 0)
        ::UI.setWidgetStyle(window, ::UI.Metric.windowPadY, 0)
        ::UI.setWidgetStyle(window, ::UI.Metric.sliceBorderScale,
                            (this.frameRatio() * 100.0 + 0.5).tointeger())
    }

    function create(id, vw, vh, vx, vy) {
        ::UI.pushStyle({ [::UI.Cap.autoScaleAbsolute] = 1, [::UI.Cap.fitScreen] = 1 })
        ::UI.pushStyle(this.style)
        ::UI.setSurfaceNine(::UI.Surface.window, ::EX.shared.images.tileable_scroll, ::UI.Slice.tile)
        ::UI.setSurfaceNine(::UI.Surface.panel, ::EX.shared.images.tileable_panel, ::UI.Slice.tile)

        local window = ::UI.window("###" + id, vw, vh, vx, vy,
                                   [::UI.WindowFlag.hideTitleBar, ::UI.WindowFlag.noShadow,
                                    ::UI.WindowFlag.notDraggable, ::UI.WindowFlag.fixedSize,
                                    ::UI.WindowFlag.noScrollBodyY])
        ::UI.popStyle()
        ::UI.popStyle()

        this.windowChrome(window)

        local scroll = { window = window }
        local component = this
        ::EUR.registerStyled(window, "basic_4", function() { component.windowChrome(window) })
        ::UI.setParent(window)
        return scroll
    }

    function place(scroll, x, y, w, h) {
        ::UI.widgetRect(scroll.window, x, y, w, h)
    }

    function placeGame(scroll, x, y, w, h) {
        local scale = ::EX.shared.scaler(true)
        this.place(scroll, scale.x(x), scale.y(y), scale.x(w), scale.y(h))
    }

}

::EUR.scroll <- eurScroll()
