
finance_calc = {
    missionIncome = 0,
    diplomacyIncome = 0,
    tributesIncome = 0,
    tributesExpense = 0,
    diplomacyExpense = 0,
}

function showFinUIextra()
    if eur_player_faction ~= nil then
        local economyTable = eur_player_faction:getFactionEconomy(0)
        if economyTable == nil then return end
        ImGui.SetNextWindowPos(1775*eurbackgroundWindowSizeRight, 1020*eurbackgroundWindowSizeBottom)
        ImGui.SetNextWindowBgAlpha(0.5)
        ImGui.SetNextWindowSize(200*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
        ImGui.Begin("showFinUIExtra", true, bit.bor(ImGuiWindowFlags.NoDecoration,ImGuiWindowFlags.NoBackground))
        eurStyle("basic_4", true)

        local income = 
        economyTable.farmingIncome +
        economyTable.taxesIncome +
        economyTable.miningIncome +
        economyTable.tradeIncome +
        economyTable.merchantIncome +
        --economyTable.constructionIncome +
        economyTable.lootingIncome +
        finance_calc.missionIncome +
        finance_calc.diplomacyIncome +
        finance_calc.tributesIncome +
        economyTable.adminIncome +
        economyTable.kingsPurseIncome

        local expenses = 
        economyTable.wagesExpense +
        economyTable.upkeepExpense +
        --economyTable.constructionExpenseBuildings +
        --economyTable.constructionExpenseField +
        --economyTable.recruitmentExpenseBuildings +
        --economyTable.recruitmentExpenseMercs +
        economyTable.corruptionExpense +
        finance_calc.diplomacyExpense +
        finance_calc.tributesExpense +
        economyTable.disasterExpense +
        economyTable.entertainmentExpense +
        economyTable.devastationExpense

        local total = income - expenses
        ImGui.SetWindowFontScale(1.4*eurbackgroundWindowSizeRight)
        if total < 0 then
            ImGui.TextColored(1, 0.5, 0.5, 1, tostring(total))
        else
            ImGui.TextColored(0.5, 1, 0.5, 1, "+"..tostring(total))
        end
        ImGui.SetWindowFontScale(1.1*eurbackgroundWindowSizeRight)
        eurStyle("basic_4", false)
        ImGui.End()
    end
end

function showSettUIExtra()
    ImGui.SetNextWindowPos(1170*eurbackgroundWindowSizeRight, 327*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(100*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
    ImGui.Begin("showSettUIExtra", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    eurStyle("basic_2", true)
    ImGui.SetWindowFontScale(1.2*eurbackgroundWindowSizeRight)
    local settlementInfoScroll = M2TWEOP.getSettlementInfoScroll();
    if settlementInfoScroll ~= nil then
        if settlementInfoScroll.settlement ~= nil then
            local sett = settlementInfoScroll.settlement
            local culture_val = sett:getReligion(eur_player_faction.religion)
            local cult_name = M2TWEOP.getReligionName(eur_player_faction.religion)
            ImGui.TextColored(0, 0, 0, 1, tostring(math.floor((culture_val*100)+0.5)).." %%")
            ImGui.SameLine()
            if culture_ui_stuff[cult_name] then
                ImGui.Image(culture_ui_stuff[cult_name].img, 24*eurbackgroundWindowSizeRight, 24*eurbackgroundWindowSizeBottom)
                local tooltext = culture_ui_stuff[cult_name].name
                if sett.isMinorSettlement then
                    tooltext = tooltext.."\n\n(Minor Settlement, culture is controlled from the region capital.)"
                end
                hoveredSimple(tooltext)
            end
        end
    end
    eurStyle("basic_2", false)
    ImGui.End()
end

function showUnitScrollextra()
    ImGui.SetNextWindowPos(800*eurbackgroundWindowSizeRight, 500*eurbackgroundWindowSizeBottom)
    ImGui.SetNextWindowBgAlpha(0.0)
    ImGui.SetNextWindowSize(50*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
    ImGui.Begin("showUnitScrollExtra", true, bit.bor(ImGuiWindowFlags.NoScrollWithMouse, ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoBackground))
    eurStyle("basic_2", true)
    --[[local infoScroll = M2TW.uiCardManager.getUnitInfoScroll()
    if infoScroll ~= nil then
        if infoScroll.unit ~= nil then
            if infoScroll.unit.eduEntry ~= nil then
                local entry = infoScroll.unit.eduEntry
                local arlvl = unit.armourLVL*2
                if entry.primaryDefenseStats.isValid then
                    ImGui.Image(test1.img, 24*eurbackgroundWindowSizeRight, 24*eurbackgroundWindowSizeBottom)
                    local hovered = ImGui.IsItemHovered()
                    if hovered then
                        eurStyle("tooltip", true)
                        ImGui.BeginTooltip()
                        ImGui.Text("Hidden defence values:")
                        ImGui.BulletText("Armour: "..tostring(entry.primaryDefenseStats.armour+arlvl))
                        ImGui.BulletText("Defense Skill: "..tostring(entry.primaryDefenseStats.defense))
                        ImGui.BulletText("Shield: "..tostring(entry.primaryDefenseStats.shield))
                        ImGui.BulletText("Total: "..tostring((entry.primaryDefenseStats.armour+arlvl)+entry.primaryDefenseStats.defense+entry.primaryDefenseStats.shield))
                        ImGui.EndTooltip()
                        eurStyle("tooltip", false)
                    end
                end
            end
        end
    end]]
    eurStyle("basic_2", false)
    ImGui.End()
end