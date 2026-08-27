

---@param selectedRecord string
---@param selectedRecordGroup string
---@returns selectedRecord string
function onSelectWorldpkgdesc(selectedRecord,selectedRecordGroup)
    --Defender coordinates (tile battle takes place on)
    if M2TW == nil then return end
    if M2TW.battle == nil then return end
    local x_coord = M2TW.battle.defenderXCoord
    local y_coord = M2TW.battle.defenderYCoord
    if x_coord == 0 or y_coord == 0 then return end
    --format as single string for index match (avoids loop)
    local coord_key = string.format("%d,%d", x_coord, y_coord)
    M2TWEOP.logGame('battle coords are: '.. coord_key)
    --print(x_coord, y_coord)

    --returns file name if coords match
    local map_name = custom_maps[coord_key]
    if map_name then
        selectedRecord = map_name
    end
    M2TWEOP.logGame('selected record is: '.. selectedRecord)
    return selectedRecord;
end
