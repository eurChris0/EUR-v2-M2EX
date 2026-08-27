---@diagnostic disable: lowercase-global
-- Action class for delayed execution
Action = {}

---@diagnostic disable-next-line: duplicate-set-field
function Action:new(func, waitTime, ...)
    newObj = {
        func = func or nil,                 -- store func pointer
        waitTime = waitTime,                -- store time to wait
        waitEndTime = os.time() + waitTime, -- calculate end time
        args = { ... } or {}                -- pack and store function args
    }
    self.__index = self
    return setmetatable(newObj, self)
end

---@diagnostic disable-next-line: duplicate-set-field
function Action:execute()
    ---@diagnostic disable-next-line: deprecated
    self.func(unpack(self.args)) -- unpack all args and execute function
end

-- table with our waiting functions
local waitingFuncs = {}

-- Add error checking in the execute function
local function execute(action)
    if not action or not action.func then
        M2TWEOP.logGame("[ERROR] Attempted to execute invalid waiting function")
        return false
    end

    local success, error = pcall(action.execute, action)
    if not success then
        M2TWEOP.logGame("[ERROR] Error executing waiting function: " .. tostring(error))
        return false
    end
    return true
end

-- Process waiting functions
function waitingFuncsTick()
    if #waitingFuncs == 0 then
        return
    end

    local currentTime = os.time()
    local remainingFuncs = {}

    for _, action in ipairs(waitingFuncs) do
        if action and action.waitEndTime then
            if currentTime >= action.waitEndTime then
                execute(action)
            else
                table.insert(remainingFuncs, action)
            end
        end
    end

    waitingFuncs = remainingFuncs
end

-- Schedule a function to execute after specified seconds
-- @param func Function to execute
-- @param sec Seconds to wait
-- @param ... Additional arguments to pass to the function
function wait(func, sec, ...)
    table.insert(waitingFuncs, Action:new(func, sec, ...))
end

function printTable(t)
    local printTable_cache = {}

    local function sub_printTable(t, indent)
        if (printTable_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            printTable_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_printTable(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_printTable(t, "  ")
        print("}")
    else
        sub_printTable(t, "  ")
    end
end

-- Helper function to check if a table contains a value
function tableContains(tbl, item)
    for _, value in ipairs(tbl) do
        if value == item then
            return true
        end
    end
    return false
end

-- Helper function to get the list of settlements held by a faction
---@param faction factionStruct
---@return table<settlementStruct>
function getListOfFactionSettlements(faction)
    local settlements = {}
    local settlementsNum = faction.settlementsNum

    for i = 0, settlementsNum - 1 do
        local settlement = faction:getSettlement(i)
        table.insert(settlements, settlement)
    end

    return settlements
end

return {
    wait = wait,
    waitingFuncsTick = waitingFuncsTick,
    printTable = printTable,
    tableContains = tableContains,
    getListOfFactionSettlements = getListOfFactionSettlements
}
