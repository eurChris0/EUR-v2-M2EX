local EurSortStack = {}

-- Global sorting configuration
-- 1 = EDU Type
-- 2 = Category
-- 3 = Class
-- 4 = Soldier Count
-- 5 = Experience
-- 6 = Category + Class
-- 7 = AI unit value
SortOrder = {
    a = 6, -- Default values from eurGlobal.lua (they were 5, 0, 3 but +1 for some reason)
    b = 1,
    c = 4
}

---@param faction factionStruct
function EurSortStack.sortAllStacks(faction)
    if faction.isPlayerControlled == 0 then return end
    M2TWEOP.logGame("sorting for " .. faction.name)
    for a = 0, faction.armiesNum - 1 do
        local stack = faction:getArmy(a)
        if stack then
            stack:sortStack(SortOrder.a, SortOrder.b, SortOrder.c)
        end
    end
end

---@param eventData eventTrigger
function EurSortStack.sortPreBattle(eventData)
    --print("sorting pre-battle")
    for s = 1, BATTLE.sidesNum do -- 1-indexed
        local side = BATTLE.sides[s]

        -- Process each army in the battle
        for a = 1, side.armiesNum do
            local battleSideArmy = side.armies[a]

            battleSideArmy.army:sortStack(SortOrder.a, SortOrder.b, SortOrder.c)
        end
    end
end

---@param eventData eventTrigger
function EurSortStack.sortSelectedArmy(eventData)
    -- because the type of first "character" is the characterRecord, second "character" is the character
    if eventData and eventData.character and eventData.character.character and eventData.character.character.army then
        eventData.character.character.army:sortStack(SortOrder.a, SortOrder.b, SortOrder.c)
    end
end

---@param clickedCharacter character
function EurSortStack.sortClickedCharacter(clickedCharacter)
    if clickedCharacter and clickedCharacter.army then
        if clickedCharacter.faction.isPlayerControlled == 1 then
            clickedCharacter.army:sortStack(SortOrder.a, SortOrder.b, SortOrder.c)
        end
    end
end

---@param eventData eventTrigger
function EurSortStack.sortSelectedSettlement(eventData)
    if eventData and eventData.settlement and eventData.settlement.army then
        if eventData.settlement.ownerFaction.isPlayerControlled == 1 then
            eventData.settlement.army:sortStack(SortOrder.a, SortOrder.b, SortOrder.c)
        end
    end
end

return EurSortStack
