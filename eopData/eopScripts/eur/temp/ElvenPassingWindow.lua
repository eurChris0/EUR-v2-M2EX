---@diagnostic disable: lowercase-global
-- Elven Passing UI module for EUR mod
-- Handles the UI for Elven Passing feature
local ElvenPassingWindow = {}

local EurElvenPassing = require("eur/EurElvenPassing")
local TextRes = require("eur/EurTextResources").Events.ElvenPassing

-- UI constants
local BUTTON_SIZE = { width = 50, height = 50 }   -- Made it square to match the UI bar icons
local WINDOW_SIZE = { width = 600, height = 600 } -- Made window much larger

-- Window style constants
local WINDOW_STYLE = {
    FONT_SCALE = {
        TITLE = 1.8,
        SUBTITLE = 1.5,
        HEADER = 1.2,
        CONTENT = 1.0
    },
    INDENT = {
        LEFT = 40,    -- Left margin
        CONTENT = 60, -- Content indentation
        SECTION = 20  -- Section spacing
    },
    SPACING = {
        SECTION = 20, -- Space between sections
        ITEM = 10     -- Space between items
    }
}

-- UI styling constants
local COLORS = {
    WINDOW = {
        BACKGROUND = { 0.95, 0.94, 0.92, 0.95 }, -- Lighter beige parchment with some transparency
        BORDER = { 0.4, 0.35, 0.3, 1.0 },        -- Darker border
        TITLE = { 0.3, 0.25, 0.2, 1.0 },         -- Dark brown title bar
        TITLE_ACTIVE = { 0.35, 0.3, 0.25, 1.0 }
    },
    BUTTON = {
        NORMAL = { 0.45, 0.35, 0.25, 1.0 }, -- Brown base color
        HOVER = { 0.55, 0.45, 0.35, 1.0 },  -- Lighter brown on hover
        ACTIVE = { 0.35, 0.25, 0.15, 1.0 }, -- Darker brown when clicked
        TEXT = { 0.95, 0.92, 0.88, 1.0 },   -- Light beige text
        BORDER = { 0.25, 0.15, 0.05, 1.0 }  -- Dark brown border
    },
    TEXT = {
        TITLE = { 0.2, 0.15, 0.1, 1.0 }, -- Dark brown for title
        CONTENT = { 0.1, 0.1, 0.1, 1.0 } -- Almost black for content
    },
    PROGRESS_BAR = {
        BACKGROUND = { 0.2, 0.15, 0.1, 0.8 }, -- Dark brown background with transparency
        TEXT = { 0.95, 0.92, 0.88, 1.0 }      -- Light text for better contrast
    }
}

-- Background image for the window
local backgroundImage = {
    x = 0,
    y = 0,
    img = nil
}


-- Initialize screen dimensions
local function initializeScreenDimensions()
    -- Get the actual game window dimensions using ImGui
    SCREEN_WIDTH = ImGui.GetIO().DisplaySize.x
    SCREEN_HEIGHT = ImGui.GetIO().DisplaySize.y
end

-- Calculate scaled positions
local function getScaledPositions()
    return {
        buttonPos = {
            x = SCREEN_WIDTH - 445, -- Moved closer to Citadel icon
            y = SCREEN_HEIGHT - 250
        },
        windowPos = {
            x = 1075 * (SCREEN_WIDTH / 1920),
            y = 150 * (SCREEN_HEIGHT / 1080)
        }
    }
end

-- Apply window styling
local function pushWindowStyle()
    -- Window colors
    ImGui.PushStyleColor(ImGuiCol.WindowBg, COLORS.WINDOW.BACKGROUND[1], COLORS.WINDOW.BACKGROUND[2],
        COLORS.WINDOW.BACKGROUND[3], COLORS.WINDOW.BACKGROUND[4])
    ImGui.PushStyleColor(ImGuiCol.Border, 0, 0, 0, 0) -- Transparent border
    ImGui.PushStyleColor(ImGuiCol.TitleBg, COLORS.WINDOW.TITLE[1], COLORS.WINDOW.TITLE[2], COLORS.WINDOW.TITLE[3],
        COLORS.WINDOW.TITLE[4])
    ImGui.PushStyleColor(ImGuiCol.TitleBgActive, COLORS.WINDOW.TITLE_ACTIVE[1], COLORS.WINDOW.TITLE_ACTIVE[2],
        COLORS.WINDOW.TITLE_ACTIVE[3], COLORS.WINDOW.TITLE_ACTIVE[4])

    -- Button colors
    ImGui.PushStyleColor(ImGuiCol.Button, COLORS.BUTTON.NORMAL[1], COLORS.BUTTON.NORMAL[2], COLORS.BUTTON.NORMAL[3],
        COLORS.BUTTON.NORMAL[4])
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, COLORS.BUTTON.HOVER[1], COLORS.BUTTON.HOVER[2], COLORS.BUTTON.HOVER[3],
        COLORS.BUTTON.HOVER[4])
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, COLORS.BUTTON.ACTIVE[1], COLORS.BUTTON.ACTIVE[2], COLORS.BUTTON.ACTIVE
        [3],
        COLORS.BUTTON.ACTIVE[4])

    -- Style variables
    ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0.0) -- No border
    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 0.0)   -- No rounding
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 4.0)    -- Rounded buttons and frames
    ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 12, 8)    -- More space between items
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 8, 6)    -- More padding inside frames
end

-- Progress bar colors based on stage
local PROGRESS_COLORS = {
    CRITICAL = { 0.8, 0.2, 0.2, 1.0 },  -- Red (0-24)
    STRONG = { 0.8, 0.4, 0.2, 1.0 },    -- Orange (25-49)
    MODERATE = { 0.8, 0.8, 0.2, 1.0 },  -- Yellow (50-74)
    WEAKENING = { 0.6, 0.8, 0.2, 1.0 }, -- Light green (75-99)
    RESISTED = { 0.4, 0.8, 0.2, 1.0 }   -- Green (100)
}

-- Get progress bar color based on current progress
local function getProgressBarColor(progress)
    if progress <= 24 then
        return PROGRESS_COLORS.CRITICAL
    elseif progress <= 49 then
        return PROGRESS_COLORS.STRONG
    elseif progress <= 74 then
        return PROGRESS_COLORS.MODERATE
    elseif progress <= 99 then
        return PROGRESS_COLORS.WEAKENING
    else
        return PROGRESS_COLORS.RESISTED
    end
end

-- Show the Elven Passing button
function ElvenPassingWindow.showButton()
    initializeScreenDimensions()
    local positions = getScaledPositions()

    ImGui.SetNextWindowPos(positions.buttonPos.x, positions.buttonPos.y, ImGuiCond.Always)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(BUTTON_SIZE.width, BUTTON_SIZE.height)

    pushWindowStyle()
    local windowFlags = ImGuiWindowFlags.NoTitleBar +
        ImGuiWindowFlags.NoBackground +
        ImGuiWindowFlags.NoScrollbar +
        ImGuiWindowFlags.NoMove +
        ImGuiWindowFlags.NoResize
    if ImGui.Begin("elven_passing_button", true, windowFlags) then
        local isHovered = false

        -- Main button
        ImGui.PushStyleColor(ImGuiCol.Button, COLORS.BUTTON.NORMAL[1], COLORS.BUTTON.NORMAL[2], COLORS.BUTTON.NORMAL[3],
            COLORS.BUTTON.NORMAL[4])
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, COLORS.BUTTON.HOVER[1], COLORS.BUTTON.HOVER[2],
            COLORS.BUTTON.HOVER[3],
            COLORS.BUTTON.HOVER[4])
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, COLORS.BUTTON.ACTIVE[1], COLORS.BUTTON.ACTIVE[2],
            COLORS.BUTTON.ACTIVE[3], COLORS.BUTTON.ACTIVE[4])
        ImGui.PushStyleColor(ImGuiCol.Text, COLORS.BUTTON.TEXT[1], COLORS.BUTTON.TEXT[2], COLORS.BUTTON.TEXT[3],
            COLORS.BUTTON.TEXT[4])
        ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 25.0)  -- Make it fully round
        ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, 2.0) -- Border thickness
        ImGui.PushStyleColor(ImGuiCol.Border, COLORS.BUTTON.BORDER[1], COLORS.BUTTON.BORDER[2], COLORS.BUTTON.BORDER[3],
            COLORS.BUTTON.BORDER[4])

        if ImGui.Button(TextRes.UI.ButtonText, BUTTON_SIZE.width - 4, BUTTON_SIZE.height - 4) then
            UIState.ElvenPassingUI.IsWindowOpen = not UIState.ElvenPassingUI.IsWindowOpen
        end
        isHovered = ImGui.IsItemHovered()

        if isHovered then
            ImGui.PushStyleColor(ImGuiCol.Text, 1.0, 1.0, 1.0, 1.0)
            ImGui.PushStyleColor(ImGuiCol.PopupBg, 0.1, 0.1, 0.1, 0.95)
            ImGui.SetTooltip(TextRes.UI.ButtonTooltip)
            ImGui.PopStyleColor(2)
        end

        ImGui.PopStyleVar(2)
        ImGui.PopStyleColor(5)
        ImGui.End()
    end

    -- Pop styles
    ImGui.PopStyleVar(5)
    ImGui.PopStyleColor(7)
end

-- Show the Elven Passing window
function ElvenPassingWindow.showWindow()
    if not UIState.ElvenPassingUI.IsWindowOpen then return end

    initializeScreenDimensions()
    local positions = getScaledPositions()

    -- Load background texture if not loaded yet
    if backgroundImage.img == nil then
        backgroundImage.x, backgroundImage.y, backgroundImage.img = M2TWEOP.loadTexture(M2TWEOP.getModPath() ..
            "/eopData/resources/images/SCROLL_BACKGROUND.png")
    end

    ImGui.SetNextWindowPos(positions.windowPos.x, positions.windowPos.y)
    ImGui.SetNextWindowSize(WINDOW_SIZE.width + 200, WINDOW_SIZE.height + 270)
    ImGui.SetNextWindowBgAlpha(0.0) -- Make window background fully transparent

    pushWindowStyle()

    local windowFlags = ImGuiWindowFlags.NoTitleBar +
        ImGuiWindowFlags.NoResize +
        ImGuiWindowFlags.NoMove +
        ImGuiWindowFlags.NoScrollbar +
        ImGuiWindowFlags.NoScrollWithMouse

    if ImGui.Begin("Elven Passing", true, windowFlags) then
        -- Draw background image
        local cursorX, cursorY = ImGui.GetCursorPos()
        ImGui.Image(backgroundImage.img, ImGui.GetWindowWidth(), ImGui.GetWindowHeight())
        ImGui.SetCursorPos(cursorX, cursorY)

        -- Add initial padding
        ImGui.Indent(WINDOW_STYLE.INDENT.LEFT)
        ImGui.Spacing()
        ImGui.Spacing()
        ImGui.Spacing()
        ImGui.Spacing()
        ImGui.Spacing()

        -- Title
        ImGui.PushFont(ImGui.GetFont())
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.TITLE)
        local titleText = TextRes.UI.WindowTitle
        local titleWidth = ImGui.CalcTextSize(titleText)
        local windowWidth = ImGui.GetWindowWidth()
        ImGui.SetCursorPosX((windowWidth - titleWidth) * 0.5)
        ImGui.TextColored(COLORS.TEXT.TITLE[1], COLORS.TEXT.TITLE[2], COLORS.TEXT.TITLE[3], COLORS.TEXT.TITLE[4],
            titleText)
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
        ImGui.PopFont()

        ImGui.Spacing()
        ImGui.Spacing()

        -- Content section
        ImGui.Indent(WINDOW_STYLE.INDENT.CONTENT)

        -- Progress bar
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.HEADER)
        ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3], COLORS.TEXT.CONTENT[4],
            TextRes.UI.Sections.Progress)
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)

        -- Set progress bar colors
        local progressColor = getProgressBarColor(CampaignState.ElvenPassing.CurrentProgress)
        ImGui.PushStyleColor(ImGuiCol.PlotHistogram, progressColor[1], progressColor[2], progressColor[3],
            progressColor[4])
        ImGui.PushStyleColor(ImGuiCol.FrameBg, COLORS.PROGRESS_BAR.BACKGROUND[1], COLORS.PROGRESS_BAR.BACKGROUND[2],
            COLORS.PROGRESS_BAR.BACKGROUND[3], COLORS.PROGRESS_BAR.BACKGROUND[4])
        ImGui.PushStyleColor(ImGuiCol.Text, COLORS.PROGRESS_BAR.TEXT[1], COLORS.PROGRESS_BAR.TEXT[2],
            COLORS.PROGRESS_BAR.TEXT[3], COLORS.PROGRESS_BAR.TEXT[4])

        ImGui.ProgressBar(CampaignState.ElvenPassing.CurrentProgress / 100, WINDOW_SIZE.width - 160, 20,
            string.format("%.0f%%", CampaignState.ElvenPassing.CurrentProgress))

        ImGui.PopStyleColor(3)

        ImGui.Spacing()
        ImGui.Spacing()

        -- Current stage info
        local currentStage = EurElvenPassing.getCurrentEventStage(CampaignState.ElvenPassing.CurrentProgress)
        if currentStage then
            ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.HEADER)
            ImGui.TextColored(COLORS.TEXT.TITLE[1], COLORS.TEXT.TITLE[2], COLORS.TEXT.TITLE[3], COLORS.TEXT.TITLE[4],
                currentStage.title)
            ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
            ImGui.Spacing()
            ImGui.PushTextWrapPos(ImGui.GetCursorPosX() + WINDOW_SIZE.width - 140)
            ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
                COLORS.TEXT.CONTENT[4], currentStage.description)
            ImGui.PopTextWrapPos()
            ImGui.Spacing()
        end

        -- Current stage effects
        if currentStage and currentStage.effects then
            ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
                COLORS.TEXT.CONTENT[4],
                string.format(TextRes.UI.Sections.StageEffects.PopulationLoss .. "\n" ..
                    TextRes.UI.Sections.StageEffects.GoldPerElf .. "\n",
                    currentStage.effects.populationLossPercent,
                    currentStage.effects.goldPerElf))
            ImGui.Spacing()
        end

        ImGui.Spacing()

        -- Help section
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
        ImGui.Spacing()
        ImGui.PushTextWrapPos(ImGui.GetCursorPosX() + WINDOW_SIZE.width - 140)

        -- Progress thresholds
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.HEADER)
        ImGui.TextColored(COLORS.TEXT.TITLE[1], COLORS.TEXT.TITLE[2], COLORS.TEXT.TITLE[3], COLORS.TEXT.TITLE[4],
            TextRes.UI.Sections.ProgressThresholds.Title)
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
        ImGui.Spacing()

        ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
            COLORS.TEXT.CONTENT[4],
            TextRes.UI.Sections.ProgressThresholds.FirstEnemy .. "\n" ..
            TextRes.UI.Sections.ProgressThresholds.BothEnemies .. "\n" ..
            TextRes.UI.Sections.ProgressThresholds.Completion)

        ImGui.Spacing()
        ImGui.Spacing()

        -- Ways to gain progress
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.HEADER)
        ImGui.TextColored(COLORS.TEXT.TITLE[1], COLORS.TEXT.TITLE[2], COLORS.TEXT.TITLE[3], COLORS.TEXT.TITLE[4],
            TextRes.UI.Sections.WaysToGain.Title)
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
        ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
            COLORS.TEXT.CONTENT[4],
            TextRes.UI.Sections.WaysToGain.CoreSettlement .. "\n" ..
            TextRes.UI.Sections.WaysToGain.EnemyCore .. "\n" ..
            TextRes.UI.Sections.WaysToGain.MinorVictories .. "\n" ..
            TextRes.UI.Sections.WaysToGain.AverageVictory)

        ImGui.Spacing()
        ImGui.Spacing()

        -- Ways to lose progress
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.HEADER)
        ImGui.TextColored(COLORS.TEXT.TITLE[1], COLORS.TEXT.TITLE[2], COLORS.TEXT.TITLE[3], COLORS.TEXT.TITLE[4],
            TextRes.UI.Sections.WaysToLose.Title)
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
        ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
            COLORS.TEXT.CONTENT[4],
            TextRes.UI.Sections.WaysToLose.CoreLoss .. "\n" ..
            TextRes.UI.Sections.WaysToLose.MinorLoss .. "\n" ..
            TextRes.UI.Sections.WaysToLose.SmallLoss)

        ImGui.Spacing()
        ImGui.Spacing()

        -- Main enemies info
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.HEADER)
        ImGui.TextColored(COLORS.TEXT.TITLE[1], COLORS.TEXT.TITLE[2], COLORS.TEXT.TITLE[3], COLORS.TEXT.TITLE[4],
            TextRes.UI.Sections.MainEnemies)
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
        ImGui.Spacing()

        local mainEnemiesMap = EurElvenPassing.getMainEnemiesForElvenFaction(CampaignState.PlayerFactionName)
        for _, enemyName in pairs(mainEnemiesMap) do
            local enemyFaction = getFactionbyName(enemyName)
            if enemyFaction then
                ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
                    COLORS.TEXT.CONTENT[4], "- " .. enemyFaction.localizedName)
            else
                ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
                    COLORS.TEXT.CONTENT[4], "- " .. enemyName)
            end
        end



        ImGui.PopTextWrapPos()

        ImGui.Spacing()
        ImGui.Spacing()
        ImGui.Spacing()
        ImGui.Spacing()

        -- Close button
        local buttonWidth = 120
        local buttonHeight = 30
        local windowWidth = ImGui.GetWindowWidth()
        ImGui.SetCursorPosX((windowWidth - buttonWidth) * 0.5)

        -- Push white text color for the button
        ImGui.PushStyleColor(ImGuiCol.Text, COLORS.BUTTON.TEXT[1], COLORS.BUTTON.TEXT[2], COLORS.BUTTON.TEXT[3],
            COLORS.BUTTON.TEXT[4])
        if ImGui.Button(TextRes.UI.CloseButton, buttonWidth, buttonHeight) then
            UIState.ElvenPassingUI.IsWindowOpen = false
        end
        ImGui.PopStyleColor()

        -- Remove indentation
        ImGui.Unindent(WINDOW_STYLE.INDENT.CONTENT)
        ImGui.Unindent(WINDOW_STYLE.INDENT.LEFT)
        ImGui.End()
    end

    -- Pop styles
    ImGui.PopStyleVar(5)
    ImGui.PopStyleColor(7)
end

-- Show the defeat window when progress reaches 0
function ElvenPassingWindow.showDefeatWindow()
    if not UIState.ElvenPassingUI.IsDefeatWindowOpen then return end

    initializeScreenDimensions()

    -- Center the window on screen
    local windowWidth = 600
    local windowHeight = 300
    ImGui.SetNextWindowPos(SCREEN_WIDTH / 2 - windowWidth / 2, SCREEN_HEIGHT / 2 - windowHeight / 2)
    ImGui.SetNextWindowSize(windowWidth, windowHeight)

    pushWindowStyle()

    local windowFlags = ImGuiWindowFlags.NoTitleBar +
        ImGuiWindowFlags.NoResize +
        ImGuiWindowFlags.NoMove +
        ImGuiWindowFlags.NoScrollbar +
        ImGuiWindowFlags.NoScrollWithMouse

    if ImGui.Begin("##defeat_window", true, windowFlags) then
        -- Add initial padding
        ImGui.Indent(WINDOW_STYLE.INDENT.LEFT)
        ImGui.Spacing()
        ImGui.Spacing()

        -- Title
        ImGui.PushFont(ImGui.GetFont())
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.TITLE)
        local titleText = TextRes.Effects.Defeat.Title
        local titleWidth = ImGui.CalcTextSize(titleText)
        local windowWidth = ImGui.GetWindowWidth()
        ImGui.SetCursorPosX((windowWidth - titleWidth) * 0.5)
        ImGui.TextColored(COLORS.TEXT.TITLE[1], COLORS.TEXT.TITLE[2], COLORS.TEXT.TITLE[3], COLORS.TEXT.TITLE[4],
            titleText)
        ImGui.SetWindowFontScale(WINDOW_STYLE.FONT_SCALE.CONTENT)
        ImGui.PopFont()

        ImGui.Spacing()
        ImGui.Spacing()

        -- Description
        ImGui.PushTextWrapPos(ImGui.GetCursorPosX() + windowWidth - 80)
        ImGui.TextColored(COLORS.TEXT.CONTENT[1], COLORS.TEXT.CONTENT[2], COLORS.TEXT.CONTENT[3],
            COLORS.TEXT.CONTENT[4], TextRes.Effects.Defeat.Description)
        ImGui.PopTextWrapPos()

        ImGui.Spacing()
        ImGui.Spacing()
        ImGui.Spacing()
        ImGui.Spacing()

        -- Accept button
        local buttonWidth = 150
        local buttonHeight = 40
        ImGui.SetCursorPosX((windowWidth - buttonWidth) * 0.5)

        ImGui.PushStyleColor(ImGuiCol.Text, COLORS.BUTTON.TEXT[1], COLORS.BUTTON.TEXT[2], COLORS.BUTTON.TEXT[3],
            COLORS.BUTTON.TEXT[4])
        if ImGui.Button(TextRes.Effects.Defeat.AcceptButton, buttonWidth, buttonHeight) then
            UIState.ElvenPassingUI.IsDefeatWindowOpen = false
            M2TWEOP.callConsole("kill_faction", CampaignState.PlayerFactionName or stratmap.game.getFaction(0).name)
        end
        ImGui.PopStyleColor()

        ImGui.Unindent(WINDOW_STYLE.INDENT.LEFT)
        ImGui.End()
    end

    -- Pop styles
    ImGui.PopStyleVar(5)
    ImGui.PopStyleColor(7)
end

-- Clean up when module is unloaded
local function cleanup()
    if backgroundImage.img then
        M2TWEOP.unloadTexture(backgroundImage.img)
        backgroundImage.img = nil
    end
end

-- Return the module
return {
    showButton = ElvenPassingWindow.showButton,
    showWindow = ElvenPassingWindow.showWindow,
    showDefeatWindow = ElvenPassingWindow.showDefeatWindow,
    cleanup = cleanup
}
