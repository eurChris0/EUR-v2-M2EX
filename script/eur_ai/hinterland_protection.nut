// EUR-only gameplay rule: Hinterland chains remain permanent once the Squirrel
// script database pass has run.  The engine's noDestroy gate is live and is
// also respected by the normal UI demolition/dismantling checks.
function apply() {
    // The setter is available in the EUR-enabled Squirrel binary.  Keeping the
    // guard makes the module harmless if it is copied to an older executable.
    if (!("setNoDestroy" in ::buildings)) return 0

    local protected = 0
    for (local i = 0; i < ::buildings.count(); i += 1) {
        let building = ::buildings.byIndex(i)
        if (building != null && ::buildings.isHinterland(building)) {
            if (!::buildings.setNoDestroy(building, true)) throw "Could not protect Hinterland building: " + ::buildings.name(building)
            protected += 1
        }
    }
    return protected
}
return { apply }
