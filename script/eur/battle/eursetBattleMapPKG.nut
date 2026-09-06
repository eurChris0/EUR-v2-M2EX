// Picks a custom battle-map package by the defender tile's coordinates.
// custom_maps is populated in eurCasLoad (keyed "x,y").
::EUR.onSelectWorldpkgdesc <- function(selectedRecord, selectedRecordGroup) {
    local battle = ::battle.current()
    if (battle == null) { return selectedRecord }

    local xCoord = battle.defenderX
    local yCoord = battle.defenderY
    if (xCoord == 0 || yCoord == 0) { return selectedRecord }

    local coordKey = xCoord + "," + yCoord
    if (coordKey in ::EUR.custom_maps) {
        selectedRecord = ::EUR.custom_maps[coordKey]
    }
    return selectedRecord
}
