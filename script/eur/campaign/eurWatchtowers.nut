// Adds watchtowers around a faction's road-connected settlements (ported from chrisAddSetts).
// One tower per cardinal offset, skipping tiles already covered by a nearby tower.
::EUR.towers_already <- {}

// Places a watchtower at (tx, ty) unless the tile is occupied or already within
// range of an existing tower in the region.
::EUR.tryAddTower <- function(faction, settlement, tx, ty) {
    if (!::EUR.checkTileEmpty(tx, ty)) { return }

    local region = ::stratMap.region(settlement.regionId)
    for (local i = 0; i < region.watchtowerCount; i++) {
        local tower = region.watchtower(i)
        if (::EUR.checkStratRange(tower.x, tower.y, tx, ty, 5)) { return }
    }

    faction.createWatchtower(tx, ty)
}

::EUR.addWatchtowers <- function(faction) {
    if (faction.settlementCount <= 0) { return }

    for (local s = 0; s < faction.settlementCount; s++) {
        local settlement = faction.settlement(s)
        if (!settlement.hasBuildingLevel("roads", false)) { continue }
        if (settlement.displayName in ::EUR.towers_already) { continue }

        ::EUR.tryAddTower(faction, settlement, settlement.tileX,      settlement.tileY - 10)
        ::EUR.tryAddTower(faction, settlement, settlement.tileX - 10, settlement.tileY)
        ::EUR.tryAddTower(faction, settlement, settlement.tileX + 10, settlement.tileY)
        ::EUR.tryAddTower(faction, settlement, settlement.tileX,      settlement.tileY + 10)

        ::EUR.towers_already[settlement.displayName] <- true
    }
}
