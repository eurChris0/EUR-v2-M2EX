local EUR_UI_Swap = {}

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
    
    -- Perform the file copy using M2TWEOP.copyFile with timing
    local start_time = os.clock()
    local success, error = pcall(function()
        M2TWEOP.copyFile(source_dir, dest_dir)
    end)
    local end_time = os.clock()
    M2TWEOP.logGame("EUR_UI_Swap - File copy took " .. (end_time - start_time) .. " seconds")
    if not success then
        M2TWEOP.logGame("EUR_UI_Swap - Failed to copy files from " .. source_dir .. " to " .. dest_dir .. ": " .. tostring(error))
        return false
    end
    M2TWEOP.logGame("EUR_UI_Swap - Copy executed from " .. source_dir .. " to " .. dest_dir .. ". Check timestamps on data/ui, data/models_strat, and data/unit_models for confirmation.")
    
    return true
end

return EUR_UI_Swap