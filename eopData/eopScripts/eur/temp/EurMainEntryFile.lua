---@diagnostic disable: lowercase-global
--- Main entry file for EUR mod
local ffi = require("ffi")
ffi.cdef [[
typedef void* HWND;
typedef struct {
    long left;
    long top;
    long right;
    long bottom;
} RECT;

HWND GetActiveWindow(void);
int GetClientRect(HWND hWnd, RECT* lpRect);
]]

-- Helper function to check if a value exists in a table
function table.contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local rect = ffi.new("RECT")
local window = ffi.C.GetActiveWindow()
ffi.C.GetClientRect(window, rect)

SCREEN_WIDTH = rect.right - rect.left
SCREEN_HEIGHT = rect.bottom - rect.top

-- Load modules
EurEOPUnits = require('eur/units/EurEOPUnits')
CampaignSettingsWindow = require('eur/windows/CampaignSettings')
EurMergingArmies = require('eur/campaign/EurMergingArmies')
EurReplenishment = require('eur/campaign/EurReplenishment')
EurElvenPassing = require('eur/campaign/EurElvenPassing')
EurHelpers = require('eur/EurHelpers')
EurSortStack = require('eur/campaign/EurSortStack')
EurPostBattleLoot = require('eur/campaign/EurPostBattleLoot')
ElvenPassingWindow = require('eur/windows/ElvenPassingWindow')
EUR_UI_Swap = require('eur/campaign/EUR_UI_Swap') -- Ensure global access

UIState = {
    CampaignSettingsWindow = { IsOpen = false },
    CampaignSettingsConfirmationWindow = { IsOpen = false },
    PreBattleUI = { IsPreBattleState = false, IsWindowOpen = false, IsButtonVisible = false },
    ElvenPassingUI = { IsWindowOpen = false },
    SelectedUISwapOption = 1, -- Default to "Default"
    IsUISwapInProgress = false,
}

CampaignState = {
    IsFirstCampaignLoad = false,
    IsSettingsConfirmed = false,
    PlayerFactionName = nil,
    LastAppliedEventType = nil,
    ElvenPassing = {
        CurrentProgress = 50,
        PreviousTurnWhenEventHappened = 0,
        PreviousTurnWhenBattleHappened = 0,
        SettlementsHeldList = {},
        IsFirstMainEnemyDefeated = false,
        IsSecondMainEnemyDefeated = false,
        IsEventFinished = false,
    },
    NeedResetDisplay = false,
    IsResetDisplayInProgress = false, -- New flag to prevent cycling
    Settings = {
        MergingArmies = { Enabled = false, Cooldown = 5, LastMergeTurn = 0 },
        Replenishment = { Enabled = false, EnableForAI = false, ReplenishmentPercent = 5, OnlyInOwnTerritory = true },
        ArmySorting = { Enabled = false, SortOnTurnEnd = true, SortOnSelection = true, SortOrder = {} },
        PostBattleLoot = { Enabled = false, UseUnitCosts = true, SmallArmyPenalty = true, BaseAmount = 400, VictoryTypeModifier = true },
        ElvenPassing = { Enabled = false, UseRandomTiming = true, MinTurns = 3, MaxTurns = 6 },
    },
}

TemporaryState = { IsOnCampaignMap = false }

ELVEN_FACTIONS = {
    ["saxons"] = true,  -- Imladris
    ["denmark"] = true, -- Lindon
    ["mongols"] = true, -- Woodland Realm
    ["ireland"] = true, -- Lothlórien
}

local has_processed_initial_swap = false
local player_faction = nil
local last_swap_turn = -1
has_reset_display = false

function GetTurnNumber()
    return CAMPAIGN and CAMPAIGN.turnNumber or 0
end

local EurMain = {}

function EurMain.initSettings()
    M2TWEOP.setAncillariesLimit(16)
    M2TWEOP.setMaxBgSize(60)
    M2TWEOP.setBuildingChainLimit(15)
    M2TWEOP.setEDUUnitsSize(1, 300)
    M2TWEOP.setGuildCooldown(5)
end

function EurMain.isPlayerFactionElven()
    return ELVEN_FACTIONS[CampaignState.PlayerFactionName] or ELVEN_FACTIONS[stratmap.game.getFaction(0).name]
end

function EurMain.onPluginLoad()
    EurMain.initSettings()
    M2TWEOP.logGame("Plugin loaded - UI swap on plugin load removed; will handle UI reset separately")
    has_processed_initial_swap = false -- Resetting this as it’s no longer needed
    has_reset_display = false -- Resetting this as it’s no longer needed
    CampaignState.LastAppliedEventType = nil -- Clear any previous event type
end

function EurMain.onCreateSaveFile()
    local savefiles = {}
    local currentPath = M2TWEOP.getPluginPath()
    print("Saving campaign state to: " .. currentPath)
    persistence.store(currentPath .. "configTable.lua", CampaignState)
    savefiles[1] = currentPath .. "configTable.lua"
    return savefiles
end

function EurMain.onLoadSaveFile(paths)
    M2TWEOP.logGame("onLoadSaveFile - Starting save file load")
    CampaignState.IsFirstCampaignLoad = true
    has_processed_initial_swap = false
    has_reset_display = false
    last_swap_turn = -1
    CampaignState.LastAppliedEventType = nil
    for _, path in pairs(paths) do
        if string.find(path, "configTable.lua") then
            M2TWEOP.logGame("onLoadSaveFile - Attempting to load config from: " .. path)
            local success, savedState = pcall(persistence.load, path)
            if not success or not savedState then
                M2TWEOP.logGame("[ERROR] Failed to load saved state from: " .. path .. " - Error: " .. (savedState or "unknown"))
                return
            end
            CampaignState = savedState
            M2TWEOP.logGame("onLoadSaveFile - Config loaded successfully")
        end
    end
    M2TWEOP.logGame("Campaign loaded - settings restored from save file")
    M2TWEOP.logGame("onLoadSaveFile - Completed - Swap deferred to onPreFactionTurnStart")
end

function EurMain.onGameInit()
    if EUR_SCRIPTS_ENABLED then
        EurEOPUnits.populateEDB()
    end
    M2TWEOP.logGame("ARE EUR SCRIPTS ENABLED: " .. (EUR_SCRIPTS_ENABLED == true and "ENABLED" or "DISABLED"))
end

function EurMain.onNewGameStart()
    M2TWEOP.logGame("onNewGameStart - Starting")
    CampaignState.IsFirstCampaignLoad = true
    has_processed_initial_swap = false
    has_reset_display = false
    last_swap_turn = -1
    CampaignState.LastAppliedEventType = nil
    M2TWEOP.logGame("onNewGameStart - Detecting player faction")
    local faction_id = M2TWEOP.getLocalFactionID()
    if faction_id and M2TW.campaign and M2TW.campaign.factions then
        local factions = M2TW.campaign.factions
        for i = 0, factions:numItems() - 1 do
            local f = factions:itemAt(i)
            if f and f:factionID() == faction_id then
                player_faction = f:getFactionName()
                M2TWEOP.logGame("onNewGameStart - Player faction set: " .. player_faction)
                break
            end
        end
    end
    M2TWEOP.logGame("onNewGameStart - Completed")
end

function EurMain.onChangeTurnNum()
    M2TWEOP.logGame("Turn number updated to: " .. GetTurnNumber())
end

function EurMain.showSettingsWindow()
    UIState.CampaignSettingsWindow.IsOpen = true
    UIState.CampaignSettingsConfirmationWindow.IsOpen = false
end

function EurMain.onCampaignMapLoaded()
    M2TWEOP.logGame("onCampaignMapLoaded - Starting")
    CampaignState.PlayerFactionName = stratmap.game.getFaction(0).name
    if CampaignState.IsFirstCampaignLoad then
        EurHelpers.wait(EurMain.showSettingsWindow, 6)
        M2TWEOP.logGame("First campaign load - will show settings window in 6 seconds")
    end
    TemporaryState.IsOnCampaignMap = true
    if not EurMain.isPlayerFactionElven() then
        CampaignState.Settings.ElvenPassing.Enabled = false
    end
    if not CampaignState.ElvenPassing.SettlementsHeldList then
        CampaignState.ElvenPassing.initFactionSettlementsList(stratmap.game.getFaction(0))
    end

    -- Execute reset_display if needed, but prevent cycling
    if CampaignState.NeedResetDisplay and not CampaignState.IsResetDisplayInProgress then
        CampaignState.IsResetDisplayInProgress = true -- Set flag to prevent re-entry
        M2TWEOP.logGame("onCampaignMapLoaded - Executing reset_display console command")
        local success, error = pcall(function()
            local result = stratmap.game.callConsole("reset_display")
            if result ~= "" then
                M2TWEOP.logGame("onCampaignMapLoaded - reset_display failed with error: " .. tostring(result))
            else
                M2TWEOP.logGame("onCampaignMapLoaded - reset_display executed successfully")
            end
        end)
        if not success then
            M2TWEOP.logGame("onCampaignMapLoaded - reset_display call failed with error: " .. tostring(error))
        end
        CampaignState.NeedResetDisplay = false -- Reset the flag
        CampaignState.IsResetDisplayInProgress = false -- Reset the in-progress flag
    elseif CampaignState.IsResetDisplayInProgress then
        M2TWEOP.logGame("onCampaignMapLoaded - Skipping reset_display: already in progress")
    end

    M2TWEOP.logGame("onCampaignMapLoaded - Completed")
end

function EurMain.onScrollClosed(eventData)
    local scrollName = eventData.resourceDescription
    M2TWEOP.logGame("onScrollClosed - Scroll closed: " .. scrollName)
end

function EurMain.onPreFactionTurnStart(faction)
    if EUR_SCRIPTS_ENABLED and faction then
        local faction_name = type(faction) == "string" and faction or (faction.getFactionName and faction:getFactionName() or "unknown")
        local isPlayerControlled = type(faction) == "string" and CampaignState.PlayerFactionName == faction
            or (faction.isPlayerControlled and faction.isPlayerControlled == 1)
        M2TWEOP.logGame("onPreFactionTurnStart - Faction: " .. faction_name .. ", isPlayerControlled: " .. tostring(isPlayerControlled))
        
        if not player_faction and ELVEN_FACTIONS[faction_name] and isPlayerControlled then
            player_faction = faction_name
            M2TWEOP.logGame("onPreFactionTurnStart - Player faction set: " .. faction_name)
        end

        -- Trigger UI swap on kon = 1 or koe = 1, but respect manual swaps and avoid redundant swaps
        if isPlayerControlled and (faction_name == "saxons" or faction_name == "denmark") then
            local isExistKon, event_kon = stratmap.game.getScriptCounter("kon_council_choice_accepted")
            local isExistKoe, event_koe = stratmap.game.getScriptCounter("koe_part_2")
            local kon = tonumber(event_kon) or 0
            local koe = tonumber(event_koe) or 0
            M2TWEOP.logGame("onPreFactionTurnStart - kon: " .. kon .. ", koe: " .. koe .. ", isExistKon: " .. tostring(isExistKon) .. ", isExistKoe: " .. tostring(isExistKoe))
            local event_type = nil
            if isExistKon and kon == 1 then
                event_type = "kon_council_choice_accepted"
            elseif isExistKoe and koe == 1 then
                event_type = "koe_part_2"
            end

            -- Check if a manual UI swap has been performed
            local lastSwapType = CampaignState.LastAppliedEventType
            local manualSwapValues = {
                "default", "Eregion_Imladris", "Eregion_Lindon", "Noldor_Imladris", "Noldor_Lindon"
            }
            local isManualSwap = lastSwapType and table.contains(manualSwapValues, lastSwapType)

            if isManualSwap then
                M2TWEOP.logGame("onPreFactionTurnStart - Manual UI swap active (" .. lastSwapType .. "), skipping automatic UI swap")
            elseif event_type then
                -- Only trigger UI swap if the event_type has changed
                if lastSwapType ~= event_type then
                    M2TWEOP.logGame("onPreFactionTurnStart - Event detected (kon or koe = 1), triggering UI swap")
                    EUR_UI_Swap.swap_ui(faction_name, event_type, true)
                    -- Set flag to execute reset_display in onCampaignMapLoaded
                    CampaignState.NeedResetDisplay = true
                    CampaignState.LastAppliedEventType = event_type
                else
                    M2TWEOP.logGame("onPreFactionTurnStart - Event type (" .. event_type .. ") unchanged, skipping UI swap")
                end
            else
                -- If no event is active, revert to default only if the last swap wasn't already default
                if lastSwapType ~= "default" then
                    M2TWEOP.logGame("onPreFactionTurnStart - No event active, reverting UI")
                    EUR_UI_Swap.swap_ui(faction_name, "default", true)
                    -- Set flag to execute reset_display in onCampaignMapLoaded
                    CampaignState.NeedResetDisplay = true
                    CampaignState.LastAppliedEventType = "default"
                else
                    M2TWEOP.logGame("onPreFactionTurnStart - Already on default UI, skipping revert")
                end
            end
        end

        if not EurMain.isPlayerFactionElven() then
            M2TWEOP.setScriptCounter("highways_and_market_unlocked", 1)
        else
            if not isPlayerControlled then
                M2TWEOP.setScriptCounter("highways_and_market_unlocked", 1)
            else
                if CampaignState.Settings.ElvenPassing.Enabled then
                    if CampaignState.ElvenPassing.IsEventFinished then
                        M2TWEOP.setScriptCounter("highways_and_market_unlocked", 1)
                    else
                        M2TWEOP.setScriptCounter("highways_and_market_unlocked", 0)
                    end
                end
            end
        end
    end
end

function EurMain.onFactionTurnStart(faction)
    if EUR_SCRIPTS_ENABLED and faction then
        if CampaignState.Settings.Replenishment.Enabled then
            EurReplenishment.replenishArmies(faction)
        end
    end

    if EUR_SCRIPTS_ENABLED and faction then
        local faction_name = type(faction) == "string" and faction or (faction.getFactionName and faction:getFactionName() or "unknown")
        local isPlayerControlled = type(faction) == "string" and CampaignState.PlayerFactionName == faction
            or (faction.isPlayerControlled and faction.isPlayerControlled == 1)
        M2TWEOP.logGame("onFactionTurnStart - Faction: " .. faction_name .. ", isPlayerControlled: " .. tostring(isPlayerControlled))
    end
end

function EurMain.onFactionTurnEnd(faction)
    if CampaignState.Settings.MergingArmies.Enabled then
        EurMergingArmies.mergeFactionArmies(faction)
    end
    if CampaignState.Settings.ArmySorting.Enabled and CampaignState.Settings.ArmySorting.SortOnTurnEnd then
        EurSortStack.sortAllStacks(faction)
    end
    if CampaignState.Settings.ElvenPassing.Enabled then
        EurElvenPassing.onFactionTurnEnd(faction)
    end
end

function EurMain.onCeasedFactionLeader(eventData)
    if CampaignState.Settings.ElvenPassing.Enabled then
        EurElvenPassing.onCeasedFactionLeader(eventData)
    end
end

function EurMain.onUnloadCampaign()
    CampaignState.IsFirstCampaignLoad = false
    UIState.CampaignSettingsWindow.IsOpen = false
    UIState.CampaignSettingsConfirmationWindow.IsOpen = false
    TemporaryState.IsOnCampaignMap = false
end

function EurMain.onPreBattlePanelOpen(eventData)
    if CampaignState.Settings.ArmySorting.Enabled then
        EurSortStack.sortPreBattle(eventData)
    end
    TemporaryState.IsOnCampaignMap = false
end

function EurMain.onPreBattleWithdrawal(eventData)
    TemporaryState.IsOnCampaignMap = true
end

function EurMain.onBattleStart()
    TemporaryState.IsOnCampaignMap = false
end

function EurMain.onBattleFinished(eventData) end

function EurMain.onScrollOpened(eventData)
    TemporaryState.IsOnCampaignMap = false
end

function EurMain.onPostBattle(eventData)
    TemporaryState.IsOnCampaignMap = true
    if CampaignState.Settings.PostBattleLoot.Enabled and TemporaryState.IsOnCampaignMap then
        EurPostBattleLoot.postBattleCheck(eventData.faction)
    end
    if CampaignState.Settings.ElvenPassing.Enabled then
        EurElvenPassing.onPostBattle(eventData.faction)
    end
end

function EurMain.onCharacterSelected(eventData)
    if CampaignState.Settings.ArmySorting.Enabled and CampaignState.Settings.ArmySorting.SortOnSelection then
        EurSortStack.sortSelectedArmy(eventData)
    end
end

function EurMain.onCharacterClicked(clickedCharacter)
    if CampaignState.Settings.ArmySorting.Enabled and CampaignState.Settings.ArmySorting.SortOnSelection then
        EurSortStack.sortClickedCharacter(clickedCharacter)
    end
end

function EurMain.onSettlementSelected(eventData)
    if CampaignState.Settings.ArmySorting.Enabled and CampaignState.Settings.ArmySorting.SortOnSelection then
        EurSortStack.sortSelectedSettlement(eventData)
    end
end

function EurMain.onDraw()
    if ImGui.IsKeyPressed(ImGuiKey.F1) and ImGui.IsKeyDown(ImGuiKey.LeftCtrl) then
        if UIState.CampaignSettingsWindow.IsOpen then
            UIState.CampaignSettingsWindow.IsOpen = false
            if CampaignState.IsSettingsConfirmed then
                UIState.CampaignSettingsConfirmationWindow.IsOpen = false
            else
                UIState.CampaignSettingsConfirmationWindow.IsOpen = true
            end
        elseif UIState.CampaignSettingsConfirmationWindow.IsOpen then
            if CampaignState.IsSettingsConfirmed then
                UIState.CampaignSettingsConfirmationWindow.IsOpen = false
            end
        elseif not UIState.CampaignSettingsWindow.IsOpen then
            UIState.CampaignSettingsWindow.IsOpen = true
        end
    end

    if ImGui.IsKeyPressed(ImGuiKey.Escape) then
        if ImGui.IsKeyDown(ImGuiKey.LeftCtrl) then
            UIState.CampaignSettingsWindow.IsOpen = false
            UIState.CampaignSettingsConfirmationWindow.IsOpen = false
            UIState.ElvenPassingUI.IsWindowOpen = false
        elseif UIState.CampaignSettingsWindow.IsOpen then
            UIState.CampaignSettingsWindow.IsOpen = false
            if CampaignState.IsSettingsConfirmed then
                UIState.CampaignSettingsConfirmationWindow.IsOpen = false
            else
                UIState.CampaignSettingsConfirmationWindow.IsOpen = true
            end
        elseif UIState.CampaignSettingsConfirmationWindow.IsOpen then
            if CampaignState.IsSettingsConfirmed then
                UIState.CampaignSettingsConfirmationWindow.IsOpen = false
            end
        elseif UIState.PreBattleUI.IsWindowOpen then
            UIState.PreBattleUI.IsWindowOpen = false
        elseif UIState.PreBattleUI.IsPreBattleState then
            UIState.PreBattleUI.IsButtonVisible = false
        elseif UIState.ElvenPassingUI.IsWindowOpen then
            UIState.ElvenPassingUI.IsWindowOpen = false
        end
    end

    if UIState.CampaignSettingsWindow.IsOpen then
        CampaignSettingsWindow.ShowCampaignSettingsWindow()
    end
    if UIState.CampaignSettingsConfirmationWindow.IsOpen then
        CampaignSettingsWindow.ShowConfirmationWindow()
    end
    if CampaignState.Settings.ElvenPassing.Enabled and EurMain.isPlayerFactionElven() and TemporaryState.IsOnCampaignMap then
        ElvenPassingWindow.showButton()
        ElvenPassingWindow.showWindow()
        ElvenPassingWindow.showDefeatWindow()
    end
    EurHelpers.waitingFuncsTick()
end

-- Updated EUR_UI_Swap.swap_ui to handle folder copying for ui, unit_models, and models_strat
function EUR_UI_Swap.swap_ui(faction_name, event_type, is_player_faction)
    M2TWEOP.logGame("EUR_UI_Swap - Swapping UI for faction: " .. faction_name .. " with event_type: " .. tostring(event_type) .. ", is_player_faction: " .. tostring(is_player_faction))
    
    -- Skip if not player faction
    if not is_player_faction then
        M2TWEOP.logGame("EUR_UI_Swap - Skipping swap: not player faction")
        return false
    end
    
    -- Determine source folder based on faction and event
    local mod_dir = M2TWEOP.getModPath()
    local source_folder
    if event_type == "default" then
        source_folder = "default"
    elseif event_type == "Eregion_Imladris" then
        source_folder = "Eregion_Imladris"
    elseif event_type == "Eregion_Lindon" then
        source_folder = "Eregion_Lindon"
    elseif event_type == "Noldor_Imladris" then
        source_folder = "Noldor_Imladris"
    elseif event_type == "Noldor_Lindon" then
        source_folder = "Noldor_Lindon"
    elseif event_type == "kon_council_choice_accepted" then
        source_folder = faction_name == "saxons" and "Noldor_Imladris" or faction_name == "denmark" and "Noldor_Lindon" or "default"
    elseif event_type == "koe_part_2" then
        source_folder = faction_name == "denmark" and "Noldor_Lindon" or "default"
    else
        M2TWEOP.logGame("Unknown UI swap event type: " .. event_type)
        return false
    end
    
    M2TWEOP.logGame("EUR_UI_Swap - Selected source folder: " .. source_folder)
    
    -- Define source and destination paths
    local source_dir = mod_dir .. "/data/replacements/" .. source_folder .. "/"
    local dest_dir = mod_dir .. "/data/"
    M2TWEOP.logGame("EUR_UI_Swap - Attempting copy from " .. source_dir .. " to " .. dest_dir)
    
    -- Perform the file copy using M2TWEOP.copyFile
    local success, error = pcall(function()
        M2TWEOP.copyFile(source_dir, dest_dir)
    end)
    if not success then
        M2TWEOP.logGame("EUR_UI_Swap - Failed to copy files from " .. source_dir .. " to " .. dest_dir .. ": " .. tostring(error))
        return false
    end
    M2TWEOP.logGame("EUR_UI_Swap - Copy executed from " .. source_dir .. " to " .. dest_dir .. ". Check timestamps on data/ui, data/models_strat, and data/unit_models for confirmation.")
    
    return true
end

return {
    onPluginLoad = EurMain.onPluginLoad,
    onGameInit = EurMain.onGameInit,
    onNewGameStart = EurMain.onNewGameStart,
    onCampaignMapLoaded = EurMain.onCampaignMapLoaded,
    onUnloadCampaign = EurMain.onUnloadCampaign,
    onDraw = EurMain.onDraw,
    PopulateEDU = EurEOPUnits.populateEDU,
    onCreateSaveFile = EurMain.onCreateSaveFile,
    onLoadSaveFile = EurMain.onLoadSaveFile,
    onPreBattlePanelOpen = EurMain.onPreBattlePanelOpen,
    onPreBattleWithdrawal = EurMain.onPreBattleWithdrawal,
    onCharacterSelected = EurMain.onCharacterSelected,
    onCharacterClicked = EurMain.onCharacterClicked,
    onPreFactionTurnStart = EurMain.onPreFactionTurnStart,
    onFactionTurnStart = EurMain.onFactionTurnStart,
    onFactionTurnEnd = EurMain.onFactionTurnEnd,
    onSettlementSelected = EurMain.onSettlementSelected,
    onBattleFinished = EurMain.onBattleFinished,
    onChangeTurnNum = EurMain.onChangeTurnNum,
    onBattleStart = EurMain.onBattleStart,
    onPostBattle = EurMain.onPostBattle,
    onCeasedFactionLeader = EurMain.onCeasedFactionLeader,
    onScrollOpened = EurMain.onScrollOpened,
    onScrollClosed = EurMain.onScrollClosed,
}