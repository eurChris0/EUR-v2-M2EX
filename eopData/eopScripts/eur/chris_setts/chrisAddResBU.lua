function addHiddenRes()
    for i = 0, eur_campaign.settlementNum - 1 do
        local sett = eur_campaign:getSettlement(i);
        if sett ~= nil then
            local region = M2TW.stratMap.getRegion(sett.regionID);
            if region ~= nil then
                for j = 0, region.resourceCount - 1 do
                    local res = region:getResource(j)
                    if res ~= nil then
                        if res:getResourceID() == resourceType.wine then
                            local hr = region:getHiddenResource("res_wine")
                            --print(hr)
                            if hr then
                                region:setHiddenResource("res_wine", true)
                                --print("found res wine", region.regionName)
                            end
                        end
                    end
                end
            end
        end
    end
end
