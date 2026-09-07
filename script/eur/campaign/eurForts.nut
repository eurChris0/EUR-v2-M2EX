// Keep EUR's option and the engine's native fort-construction rule in sync.
// The native Field Construction panel now owns the Fort row, its validation,
// confirmation flow, cost deduction, and construction.

class eurFortCreationToggle {
    function sync() {
        local enabled = ::EUR.build_forts
        // Match the Lua price using the construction region's live fort count.
        ::campaignDb.settlement.setFortConstructionCost(enabled ? 7500 : -1, 7500)
        if (::campaignDb.settlement.canBuildForts() != enabled) {
            ::campaignDb.settlement.setCanBuildForts(enabled)
        }
    }
}

::EUR.eurFortCreationToggle <- eurFortCreationToggle()
::UI.onFrame(function() { ::EUR.eurFortCreationToggle.sync() })
