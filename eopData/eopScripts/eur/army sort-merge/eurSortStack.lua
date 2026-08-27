local sort = {}

function sort.eurSortStack(faction)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."eurSortStack");
	end
    --print("sort check "..faction.name)
    --if faction.isPlayerControlled == 0 then return end;
    --print("sorting for "..faction.name)
 -- 1 = EDU Type
 -- 2 = Category
 -- 3 = Class
 -- 4 = Soldier Count
 -- 5 = Experience
 -- 6 = Category + Class
 -- 7 = AI unit value
    for j = 0, faction.armiesNum - 1 do
        local stack = faction:getArmy(j);
        if stack then
            if not (stack:findInSettlement() or stack:findInFort()) then
                stack:sortStack(sort_order.a+1, sort_order.b+1, sort_order.c+1)
            end
        end
    end
end

 function sort.eurSortOnSelected(selectedChar)
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."eurSortOnSelected");
	end
    if selectedChar.character.armyLeaded then
        selectedChar.character.armyLeaded:sortStack(sort_order.a+1, sort_order.b+1, sort_order.c+1);
    end
 end

return sort