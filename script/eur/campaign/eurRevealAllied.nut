::EUR.revealAllied <- function() {
    if (::EUR.game_options.reveal_allied) {
        for (local i = 0; i < ::EUR.eur_campaign.factionCount; i++) {
            local faction = ::EUR.eur_campaign.factionByOrder(i)
            if (faction == ::EUR.eur_player_faction) continue
            if (!::EUR.eur_campaign.checkStance(::Enum.DiplomaticRelation.alliance, ::EUR.eur_player_faction, faction)) continue

            for (local c = 0; c < faction.characterCount; c++) {
                local char = faction.character(c)
                if (char == null) continue
                if (char.typeId != 6 && char.typeId != 7) continue
                if (char.settlement || char.fort) continue
                local tile = ::EUR.eur_sMap.tile(char.x, char.y)
                if (tile != null && !tile.fort && !tile.settlement) {
                    ::EUR.revealTilesAround(char.x, char.y)
                }
            }
            for (local s = 0; s < faction.settlementCount; s++) {
                local sett = faction.settlement(s)
                if (sett != null) { ::EUR.revealTilesAround(sett.tileX, sett.tileY) }
            }
        }
    }
    if (::EUR.eur_event_active) {
        ::EUR.mirrorCheck()
        ::EUR.anorStoneCheck()
    }
}
