::EUR.addHiddenRes <- function() {
    for (local i = 0; i < ::EUR.eur_campaign.settlementCount; i++) {
        local sett = ::EUR.eur_campaign.settlement(i)
        if (sett == null) continue
        local region = ::EUR.eur_sMap.region(sett.regionId)
        if (region == null) continue
        for (local j = 0; j < region.resourceCount; j++) {
            local resource = region.resource(j)
            if (resource == null) continue
            if (resource.id == ::Enum.ResourceType.wine && region.hasHiddenResource("res_wine")) {
                region.setHiddenResource("res_wine", true)
            }
        }
    }
}
