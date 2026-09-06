local glorychoice = 99

function gondor_2(faction_name, bool)
    if bool then
        if glorychoice == 99 then
            EUR_EVENTS["sicily"][3].cost = 999999
            EUR_EVENTS["sicily"][3].desc = [["One day, our paths will lead us there. And the tower guard shall take up the call: 'The Lords of Gondor have returned!'" - Boromir]]
        end
        ImGui.Text("Dedicate works in the name of the great rulers of Gondor: ")
        ImGui.NewLine()

        ImGui.BeginGroup()
        for i = 0, 3 do
            ImGui.SetNextWindowBgAlpha(0)
            ImGui.BeginChild("Child Window_glory_"..tostring(i), (img_x+20)*eurbackgroundWindowSizeRight, (img_y+20)*eurbackgroundWindowSizeBottom)
            if glory_table[i].locked then
                if glory_table[i].image ~= nil then
                    if centeredImageButtonReal("ship_"..tostring(i), glory_table[i].image, img_x, img_y, -5) then
                        EUR_EVENTS["sicily"][3].cost = glory_table[i].cost
                        EUR_EVENTS["sicily"][3].desc = glory_table[i].desc
                        glorychoice = i
                    end
                end
            else
                if glory_table[i].imagelocked ~= nil then
                    centeredImage(glory_table[i].imagelocked, img_x, img_y)
                end
            end
            local hovered = ImGui.IsItemHovered()
            if hovered then
                ImGui.BeginTooltip()
                ImGui.Text(glory_table[i].title)
                ImGui.Text("Gold: "..tostring(glory_table[i].cost))
                gloryGondorText(i)
                ImGui.EndTooltip()
            end
            ImGui.EndChild()
        end
        ImGui.EndGroup()
        ImGui.SameLine()
        ImGui.BeginGroup()
        for i = 4, 6 do
            ImGui.SetNextWindowBgAlpha(0)
            ImGui.BeginChild("Child Window_glory_"..tostring(i), (img_x+20)*eurbackgroundWindowSizeRight, (img_y+20)*eurbackgroundWindowSizeBottom)
            if glory_table[i].locked then
                if glory_table[i].image ~= nil then
                    if centeredImageButtonReal("ste_"..tostring(i), glory_table[i].image, img_x, img_y, -5) then
                        EUR_EVENTS["sicily"][3].cost = glory_table[i].cost
                        EUR_EVENTS["sicily"][3].desc = glory_table[i].desc
                        glorychoice = i
                    end
                end
            else
                if glory_table[i].imagelocked ~= nil then
                    centeredImage(glory_table[i].imagelocked, img_x, img_y)
                end
            end
            local hovered = ImGui.IsItemHovered()
            if hovered then
                ImGui.BeginTooltip()
                ImGui.Text(glory_table[i].title)
                ImGui.Text("Gold: "..tostring(glory_table[i].cost))
                gloryGondorText(i)
                ImGui.EndTooltip()
            end
            ImGui.EndChild()
        end
        ImGui.EndGroup()
        ImGui.SameLine()
        ImGui.BeginGroup()
        for i = 7, 9 do
            ImGui.SetNextWindowBgAlpha(0)
            ImGui.BeginChild("Child Window_glory_"..tostring(i), (img_x+20)*eurbackgroundWindowSizeRight, (img_y+20)*eurbackgroundWindowSizeBottom)
            if glory_table[i].locked then
                if glory_table[i].image ~= nil then
                    if centeredImageButtonReal("king_"..tostring(i), glory_table[i].image, img_x, img_y, -5) then
                        EUR_EVENTS["sicily"][3].cost = glory_table[i].cost
                        EUR_EVENTS["sicily"][3].desc = glory_table[i].desc
                        glorychoice = i
                    end
                end
            else
                if glory_table[i].imagelocked ~= nil then
                    centeredImage(glory_table[i].imagelocked, img_x, img_y)
                end
            end
            local hovered = ImGui.IsItemHovered()
            if hovered then
                ImGui.BeginTooltip()
                ImGui.Text(glory_table[i].title)
                ImGui.Text("Gold: "..tostring(glory_table[i].cost))
                gloryGondorText(i)
                ImGui.EndTooltip()
            end
            ImGui.EndChild()
        end
        ImGui.EndGroup()
    else
        gloryGondor(glorychoice)
        glorychoice = 99
        EUR_EVENTS["sicily"][3].desc = [["One day, our paths will lead us there. And the tower guard shall take up the call: 'The Lords of Gondor have returned!'" - Boromir]]
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end


function rohan_1(faction_name, bool)
    if bool then
        ImGui.Text("Call upon Gondor for assistance: ")
        if test1 ~= nil then
            ImGui.Image(eur_tga_table["Rohirrim"].img, img_x, img_y)
            ImGui.SameLine()
        end
        if test1 ~= nil then
            ImGui.Image(test1.img, img_x, img_y)
            ImGui.SameLine()
        end
        if test1 ~= nil then
            ImGui.Image(test1.img, img_x, img_y)
            ImGui.SameLine()
        end
        ImGui.NewLine()
        ImGui.BulletText("Call upon Gondor for assistance")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
        ImGui.BulletText("Gondor Spearmen")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
        ImGui.BulletText("Gondor Spearmen")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
    else
        local faction = eur_campaign:getFaction(faction_name)
        army = eurSpawnArmy(faction_name, "random_name", "dpr_", "", false, 18, "Gondor Spearmen", faction.capital.xCoord, faction.capital.yCoord, 3, 1, 0)
        if army then
            army:createUnit("Gondor Spearmen",3,0,0);
            army:createUnit("Gondor Spearmen",3,0,0);
            if army.leader ~= nil then
                char = army.leader.namedCharacter
                if char ~= nil then
                    char:addTrait("ElvenRace", 1)
                    char:addTrait("Nandor", 1)
                    char:addTrait("BattleChivalryGood", 1)
                    char:addTrait("Brave", 1)
                    char:addTrait("GoodAttacker", 1)
                    char:addTrait("GoodCommander", 1)
                    char:addTrait("Loyal", 2)
                    char:addTrait("Upright", 2)
                    char:addTrait("LoyaltyStarter", 2)
                    char:addTrait("PietyStarter", 2)
                end
            end
        end
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function gondor_1(faction_name, bool)
    if bool then
        ImGui.Text("Call upon Rohan for assistance: ")
        if eur_tga_table["Rohirrim"] ~= nil then
            ImGui.Image(eur_tga_table["Rohirrim"].img, img_x, img_y)
            ImGui.SameLine()
        end
        if eur_tga_table["Rohirrim"] ~= nil then
            ImGui.Image(eur_tga_table["Rohirrim"].img, img_x, img_y)
            ImGui.SameLine()
        end
        if eur_tga_table["Rohirrim"] ~= nil then
            ImGui.Image(eur_tga_table["Rohirrim"].img, img_x, img_y)
            ImGui.SameLine()
        end
        ImGui.NewLine()
        ImGui.BulletText("Call upon Rohan for assistance")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
        ImGui.BulletText("Rohirrim")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
        ImGui.BulletText("Rohirrim")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
    else
        local faction = eur_campaign:getFaction(faction_name)
        army = eurSpawnArmy(faction_name, "random_name", "dpr_", "", false, 18, "Rohirrim", faction.capital.xCoord, faction.capital.yCoord, 3, 1, 0)
        if army then
            army:createUnit("Rohirrim",3,0,0);
            army:createUnit("Rohirrim",3,0,0);
            if army.leader ~= nil then
                char = army.leader.namedCharacter
                if char ~= nil then
                    char:addTrait("ElvenRace", 1)
                    char:addTrait("Nandor", 1)
                    char:addTrait("BattleChivalryGood", 1)
                    char:addTrait("Brave", 1)
                    char:addTrait("GoodAttacker", 1)
                    char:addTrait("GoodCommander", 1)
                    char:addTrait("Loyal", 2)
                    char:addTrait("Upright", 2)
                    char:addTrait("LoyaltyStarter", 2)
                    char:addTrait("PietyStarter", 2)
                end
            end
        end
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function mengood_0(faction_name, bool)
    local mengoodtemplist_sett = {}
    local mengoodtemplist_sett_actual = {}
    for i = 0, eur_player_faction.settlementsNum - 1 do
        local sett = eur_player_faction:getSettlement(i)
        if sett then
            table.insert(mengoodtemplist_sett, sett.localizedName)
            table.insert(mengoodtemplist_sett_actual, sett)
        end
    end
    if bool then
        ImGui.Text("Resettle Lands(each turn): ")
        ImGui.NewLine()
        ImGui.BulletText("Population Growth")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 100")
        ImGui.BulletText("Culture Bonus")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 10%%")
        ImGui.NewLine()
        ImGui.Text("Select Settlement: ")
        tempmengoodTarget, clicked = ImGui.Combo("", tempmengoodTarget, mengoodtemplist_sett, #mengoodtemplist_sett, #mengoodtemplist_sett+1)
    else
        mengood_0_sett = mengoodtemplist_sett_actual[tempmengoodTarget+1]
        mengoodTurnsRemain = 5
        populationCultureBonus(100, 0.1, mengood_0_sett)
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end


function gondor_0(faction_name, bool)
    local anortemplist_fact = {}
    local anortemplist_fact_0 = {}
    local anortemplist_sett = {}
    local nu_fact = eur_campaign.numberOfFactions
    for i = 0, nu_fact-5 do
        anorfaction = stratmap.game.getFaction(i)
        if anorfaction then
            if anorfaction.isPlayerControlled == 0 then
                if anorfaction.numOfCharacters > 0 then
                    table.insert(anortemplist_fact, anorfaction.localizedName)
                    table.insert(anortemplist_fact_0, anorfaction.name)
                end
            end
        end
    end
    for i = 0, anorfaction.settlementsNum - 1 do
        local sett = anorfaction:getSettlement(i)
        if sett then
            table.insert(anortemplist_sett, sett.localizedName)
        end
    end
    if bool then
        ImGui.Text("Reveals armies and agents for the target faction.")
        ImGui.NewLine()
        ImGui.Text("Select Faction: ")
        tempanorTarget, clicked = ImGui.Combo("", tempanorTarget, anortemplist_fact, #anortemplist_fact, #anortemplist_fact+1)
    else
        anorTarget = anortemplist_fact_0[tempanorTarget+1]
        anorTurnsRemain = EUR_EVENTS[faction_name][event_number].duration
        anorStone()
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function dwarven_0(faction_name, bool)
    if bool then
        ImGui.Text("Mining Operations(all mines, permanent): ")
        ImGui.NewLine()
        ImGui.BulletText("Income bonus")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 25 per building level")
        if dwarven_0_count < 5 then
            ImGui.BulletText("Growth")
            ImGui.SameLine()
            ImGui.TextColored(0, 1, 0, 1, " + 0.5%%")
        end
        ImGui.BulletText("Possibility for any general to gain points in Mining trait.")
    else
        dwarven_0_count = (dwarven_0_count+1)
        miningdwarvesAdd()
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function orcgobbo_0(faction_name, bool)
   local orchordetemplist_sett = {}
   local orchordetemplist_sett_name = {}
   local orchordetemplist_cost = {5000, 10000, 15000}
   local orchordetemplist_cost_desc = {"5000", "10000", "15000"}
   if eur_player_faction.settlementsNum > 0 then
       for i = 0, eur_player_faction.settlementsNum - 1 do
           local sett = eur_player_faction:getSettlement(i)
           if sett then
               table.insert(orchordetemplist_sett_name, sett.localizedName)
               table.insert(orchordetemplist_sett, sett)
           end
       end
   end
   if bool then
    ImGui.SetNextWindowBgAlpha(0)
    ImGui.Text("Raise a horde from the target settlement.")
    ImGui.NewLine()
    ImGui.BeginChild("Events_eye_1", 250*eurbackgroundWindowSizeRight, 300*eurbackgroundWindowSizeBottom)
       ImGui.SetNextWindowBgAlpha(0)
       ImGui.BeginChild("Events_eye_sub_1", 250*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
       ImGui.Text("Select Settlement: ")
       temporchordeTarget, clicked = ImGui.Combo("", temporchordeTarget, orchordetemplist_sett_name, #orchordetemplist_sett_name, #orchordetemplist_sett_name+1)
       ImGui.EndChild()
       ImGui.SetNextWindowBgAlpha(0)
       ImGui.BeginChild("Events_eye_sub_2", 250*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
       ImGui.Text("Select Settlement: ")
       temporchordeTarget_cost, clicked2 = ImGui.Combo("", temporchordeTarget_cost, orchordetemplist_cost_desc, #orchordetemplist_cost_desc, #orchordetemplist_cost_desc+1)
       ImGui.EndChild()
       if orchordetemplist_sett[temporchordeTarget+1].settlementStats then
            if orchordetemplist_sett[temporchordeTarget+1].settlementStats.population-(orchordetemplist_cost[temporchordeTarget_cost+1]/10) < 500 then
                ImGui.TextColored(1, 0, 0, 1, "Population too low")
                EUR_EVENTS[faction_name][event_number].cost = 9999999
            else
                ImGui.Text("Population for horde: -"..tostring((EUR_EVENTS[faction_name][event_number].cost/10)))
                EUR_EVENTS[faction_name][event_number].cost = orchordetemplist_cost[temporchordeTarget_cost+1]
            end
        end
       ImGui.EndChild()
       ImGui.SameLine()
       ImGui.SetNextWindowBgAlpha(0)
       ImGui.BeginChild("Events_eye_2", 320*eurbackgroundWindowSizeRight, 300*eurbackgroundWindowSizeBottom)
       ImGui.Text("Available Units: ")
       ImGui.NewLine()
       local row_nu = 0
        for i = 0, orchordetemplist_sett[temporchordeTarget+1].recruitmentCapabilityNum -1 do
            local capability = orchordetemplist_sett[temporchordeTarget+1]:getRecruitmentCapability(i).eduIndex
            local eduEntry = M2TWEOPDU.getEduEntry(capability)
            if eduEntry then
                if eduEntry.recruitCost < EUR_EVENTS[faction_name][event_number].cost/5 then
                    if eur_tga_table[eduEntry.unitCardTga] then
                        if row_nu == 4 then
                            ImGui.NewLine()
                        elseif row_nu == 8 then
                            ImGui.NewLine()
                        elseif row_nu == 12 then
                            ImGui.NewLine()
                        elseif row_nu == 16 then
                            ImGui.NewLine()
                        else
                            ImGui.SameLine()
                        end
                        ImGui.Image(eur_tga_table[eduEntry.unitCardTga].img, img_x, img_y)
                        local hovered = ImGui.IsItemHovered()
                        if hovered then
                            ImGui.BeginTooltip()
                            ImGui.Text(eduEntry.eduType)
                            ImGui.EndTooltip()
                        end
                    end
                    row_nu = row_nu+1
                end
            end
        end
        ImGui.EndChild()
   else
       orcHorde(orchordetemplist_sett[temporchordeTarget+1], EUR_EVENTS[faction_name][event_number].cost)
       eur_event_active = true
       if EUR_EVENTS[faction_name][event_number].duration ~= nil then
           if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
               eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
           end
       end
       EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
       if EUR_EVENTS[faction_name][event_number].duration ~= nil then
           EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
       end
       EUR_EVENTS[faction_name][event_number].unlocked = false

       if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
           M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
       end

       stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

       show_events_window = false
       eur_event_min_cooldown = 10
       event_selected[event_number] = false
       event_number = 99
   end
end

function mordor_0(faction_name, bool)
    local eyetemplist_fact = {}
    local eyetemplist_fact_0 = {}
    local eyetemplist_fact_1 = {}
    local eyetemplist_sett = {}
    local eyetemplist_sett_name = {}
    local nu_fact = eur_campaign.numberOfFactions
    for i = 0, nu_fact-5 do
        eyefaction = stratmap.game.getFaction(i)
        if eyefaction then
            if eyefaction.numOfCharacters > 0 then
                table.insert(eyetemplist_fact, eyefaction.localizedName)
                table.insert(eyetemplist_fact_0, eyefaction.name)
                table.insert(eyetemplist_fact_1, eyefaction)
            end
        end
    end
    if eyetemplist_fact_1[tempeyeTarget+1].settlementsNum > 0 then
        for i = 0, eyetemplist_fact_1[tempeyeTarget+1].settlementsNum - 1 do
            local sett = eyetemplist_fact_1[tempeyeTarget+1]:getSettlement(i)
            if sett then
                table.insert(eyetemplist_sett_name, sett.localizedName)
                table.insert(eyetemplist_sett, sett.regionID)
            end
        end
    end
    if bool then
        ImGui.Text("Reveals the lands around the selected settlement.")
        ImGui.NewLine()
        ImGui.SetNextWindowBgAlpha(0)
        ImGui.BeginChild("Events_eye_sub_1", 200*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
        ImGui.Text("Select Faction: ")
        tempeyeTarget, clicked = ImGui.Combo("", tempeyeTarget, eyetemplist_fact, #eyetemplist_fact, #eyetemplist_fact+1)
        ImGui.EndChild()
        ImGui.SetNextWindowBgAlpha(0)
        ImGui.BeginChild("Events_eye_sub_2", 200*eurbackgroundWindowSizeRight, 50*eurbackgroundWindowSizeBottom)
        ImGui.Text("Select Region: ")
        tempeyeTarget_region, clicked2 = ImGui.Combo("", tempeyeTarget_region, eyetemplist_sett_name, #eyetemplist_sett_name, #eyetemplist_sett_name+1)
        ImGui.EndChild()
    else
        eyeTarget = eyetemplist_sett[tempeyeTarget_region+1]
        eyeTurnsRemain = EUR_EVENTS[faction_name][event_number].duration
        greatEye(true)
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function lindon_0(faction_name, bool)
    if bool then
        ImGui.Text("Ulmo's Favour(all ports, permanent): ")
        ImGui.NewLine()
        ImGui.BulletText("Income bonus")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 15 per building level")
        if lindon_0_count < 5 then
            ImGui.BulletText("Growth")
            ImGui.SameLine()
            ImGui.TextColored(0, 1, 0, 1, " + 0.5%%")
        end
        if lindon_0_count == 1 then
            ImGui.BulletText("Recruitment pool increase: Lindar Mariners(factionwide)")
        elseif lindon_0_count == 4 then
            ImGui.BulletText("Recruitment pool increase: Mithlond Nobles(Mithlond)")
        end
    else
        lindon_0_count = (lindon_0_count+1)
        ulmoAdd()
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function imladris_0(faction_name, bool)
    if bool then
        ImGui.Text("Celebration of Tulkas(factionwide): ")
        ImGui.NewLine()
        ImGui.BulletText("Chance for existing units to gain a level")
        ImGui.BulletText("Experience for new units")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 3")
        ImGui.BulletText("Recruitment cost")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " - 60%%")
        ImGui.BulletText("Recruitment time")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " - 1 turn")       
    else
        tulkasTurnsRemain = 5
        tulkasActive = true
        modifyEDU(true, 0, 0, 0.4, 1, 0)
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function imladris_1(faction_name, bool)
    local ringtemplist_char = {}
    local ringtemplist_char_0 = {}
    local tempgim = {"Minor ring of power","Recruitment drive",}
    local tempgim_units = {{"Noldorin Defenders", "Noldorin Archers","Noldorin Archers",}, {"Reavers of the Dark Coast"},{"Eregion Smiths",},}
    local tempgim_units_count = {3, 1, 1}
    local tempgim_units_desc = {"Noldorin Defenders, Noldorin Archers x2","Reavers of the Dark Coast x2","Eregion Smiths",}
    for i = 0, eur_player_faction.numOfCharacters - 1 do
        local char = eur_player_faction:getCharacter(i)
        if char then
            if char:getTypeID() == 7 then
                if char.ability == "" then
                    table.insert(ringtemplist_char, char.namedCharacter.localizedDisplayName)
                    table.insert(ringtemplist_char_0, char)
                end
            end
        end
    end
    if bool then
        ImGui.Text("Call upon the smiths of the Gwaith-i-Mírdain.")
        ImGui.NewLine()
        ImGui.Text("Select Project: ")
        tempgimtarget, tempgimtarget_clicked = ImGui.Combo("", tempgimtarget, tempgim, #tempgim, #tempgim+1)
        if tempgimtarget == 0 then
            ImGui.BeginChild("Events_window_tempcharTarget", 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
            ImGui.Text("Select General: ")
            tempcharTarget, tempcharTarget_clicked = ImGui.Combo("", tempcharTarget, ringtemplist_char, #ringtemplist_char, #ringtemplist_char)
            EUR_EVENTS["saxons"][0].cost = 10000
            EUR_EVENTS["saxons"][0].cooldown = 40
            EUR_EVENTS["denmark"][2].cost = 10000
            EUR_EVENTS["denmark"][2].cooldown = 40
            if ringtemplist_char[1] == nil then
                ImGui.TextColored(1, 0, 0, 1, "NO GENERALS AVAILABLE")
            end
            ImGui.EndChild()
        elseif tempgimtarget == 1 then
            ImGui.BeginChild("Events_window_tempcharTarget", 250*eurbackgroundWindowSizeRight, 250*eurbackgroundWindowSizeBottom, ImGuiWindowFlags.NoInputs)
            ImGui.Text("Select Units: ")
            tempgim_units_target, tempgim_units_target_clicked = ImGui.Combo("", tempgim_units_target, tempgim_units_desc, #tempgim_units_desc, #tempgim_units_desc+1)
            if (eur_player_faction.capital.army.numOfUnits+tempgim_units_count[tempgim_units_target+1]) > 20 then
                ImGui.TextColored(1, 0, 0, 1, "NOT ENOUGH ROOM IN CAPITAL")
            end
            EUR_EVENTS["saxons"][0].cost = 5000
            EUR_EVENTS["saxons"][0].cooldown = 30
            EUR_EVENTS["denmark"][2].cost = 5000
            EUR_EVENTS["denmark"][2].cooldown = 30
            ImGui.EndChild()
        end
    else
        if tempgimtarget == 0 then
            if ringtemplist_char[1] == nil then return end
            ringtemplist_char_0[tempcharTarget+1].namedCharacter:addTrait("HeroAbilityElf", 1);
            ringtemplist_char_0[tempcharTarget+1].ability = "Light_of_the_Faith"
        elseif tempgimtarget == 1 then
            if (eur_player_faction.capital.army.numOfUnits+tempgim_units_count[tempgim_units_target+1]) > 20 then return end
            if eur_player_faction.capital.army then
                for i = 1, #tempgim_units[tempgim_units_target+1] do
                    eur_player_faction.capital.army:createUnit(tempgim_units[tempgim_units_target+1][i], 3, 1, 6)
                end
            else
                local army = stratmap.game.createArmyInSettlement(eur_player_faction.capital)
                for i = 1, #tempgim_units[tempgim_units_target+1] do
                    army:createUnit(tempgim_units[tempgim_units_target+1][i], 3, 1, 6)
                end
            end
        end
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function wr_0(faction_name, bool)
    if bool then
        ImGui.Text("Spirit of Oromë(factionwide): ")
        ImGui.NewLine()
        ImGui.BulletText("Command (Ambushing)")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 4")
        ImGui.BulletText("Line of sight")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 2")
        ImGui.BulletText("Ammunition for all Archers")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 25%%")
        ImGui.BulletText("Recruitment cost")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " - 35%%")
        ImGui.BulletText("Recruitment time")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " - 1 turn")   
    else
        traitToAdd = "SpritofOrome"
        traitTurnsRemain = 6
        eventAddTrait(eur_player_faction, true)
        edumodTurnsRemain = 6
        edumodActive = true
        modifyEDU(true, 1.25, 0, 0.65, 1, 0)
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function lorien_0(faction_name, bool)
    local mirrortemplist_fact = {}
    local mirrortemplist_fact_0 = {}
    local mirrortemplist_sett = {}
    local nu_fact = eur_campaign.numberOfFactions
    for i = 0, nu_fact-5 do
        mirrorfaction = stratmap.game.getFaction(i)
        if mirrorfaction then
            if mirrorfaction.numOfCharacters > 0 then
                table.insert(mirrortemplist_fact, mirrorfaction.localizedName)
                table.insert(mirrortemplist_fact_0, mirrorfaction.name)
            end
        end
    end
    for i = 0, mirrorfaction.settlementsNum - 1 do
        local sett = mirrorfaction:getSettlement(i)
        if sett then
            table.insert(mirrortemplist_sett, sett.localizedName)
        end
    end
    if bool then
        ImGui.Text("Reveals all of the target's land, armies and agent.")
        ImGui.NewLine()
        ImGui.Text("Select Faction: ")
        tempmirrorTarget, clicked = ImGui.Combo("", tempmirrorTarget, mirrortemplist_fact, #mirrortemplist_fact, #mirrortemplist_fact+1)
    else
        mirrorTarget = mirrortemplist_fact_0[tempmirrorTarget+1]
        mirrorTurnsRemain = EUR_EVENTS[faction_name][event_number].duration
        mirrorGaladriel()
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function lorien_1(faction_name, bool)
    if bool then
        ImGui.Text("Yavanna's Blessing(factionwide): ")
        ImGui.NewLine()
        ImGui.BulletText("Growth")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 0.5%%")
        ImGui.BulletText("Population Replenishment")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 25")
        ImGui.BulletText("Wounded Garrison Replenishment")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 15 per unit")
        ImGui.BulletText("Halt Elven Passing(10 turns)")
    else
        fert_level = 2
        modify_growth = true
        growthTurnsRemain = 5
        block_poe_turns = 10
        replen_bonus = 15
        increaseGrowth(stratmap.game.getFaction(faction_name), 2)
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function lorien_2(faction_name, bool)
    if bool then
        ImGui.Text("Summon units: ")
        if eur_tga_table["ents"] ~= nil then
            ImGui.Image(eur_tga_table["ents"].img, img_x, img_y)
            ImGui.SameLine()
        end
        if eur_tga_table["ents"] ~= nil then
            ImGui.Image(eur_tga_table["ents"].img, img_x, img_y)
            ImGui.SameLine()
        end
        if eur_tga_table["lothlorien_marchwarden"] ~= nil then
            ImGui.Image(eur_tga_table["lothlorien_marchwarden"].img, img_x, img_y)
            ImGui.SameLine()
        end
        ImGui.NewLine()
        ImGui.BulletText("Ent General")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
        ImGui.BulletText("Ents")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
        ImGui.BulletText("Lothlorien Marchwardens")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 1")
    else
        local faction = eur_campaign:getFaction(faction_name)
        army = eurSpawnArmy(faction_name, "random_name", "dpr_", "", false, 18, "Ents", faction.capital.xCoord, faction.capital.yCoord, 3, 1, 0)
        if army then
            army:createUnit("Ents",3,0,0);
            army:createUnit("Lothlorien Marchwardens",3,0,0);
            if army.leader ~= nil then
                char = army.leader.namedCharacter
                if char ~= nil then
                    char:addTrait("ElvenRace", 1)
                    char:addTrait("Nandor", 1)
                    char:addTrait("BattleChivalryGood", 1)
                    char:addTrait("Brave", 1)
                    char:addTrait("GoodAttacker", 1)
                    char:addTrait("GoodCommander", 1)
                    char:addTrait("Loyal", 2)
                    char:addTrait("Upright", 2)
                    char:addTrait("LoyaltyStarter", 2)
                    char:addTrait("PietyStarter", 2)
                end
            end
        end
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

function elves_0(faction_name, bool)
    if bool then
        ImGui.Text("Grants trait Light of the Eldar(all characters): ")
        ImGui.NewLine()
        ImGui.BulletText("Command")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 4")
        ImGui.BulletText("Line Of Sight")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 4")
        ImGui.BulletText("Movement Points")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 25%%")
        ImGui.BulletText("Hitpoints")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 5")
        ImGui.BulletText("Troop Morale")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 2")
        ImGui.BulletText("Casualty Recovery")
        ImGui.SameLine()
        ImGui.TextColored(0, 1, 0, 1, " + 5%%")
    else
        traitToAdd = "EldarLightEvent"
        traitTurnsRemain = 8
        eventAddTrait(eur_player_faction, true)
        eur_event_active = true
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            if eur_event_activelen < EUR_EVENTS[faction_name][event_number].duration then
                eur_event_activelen = EUR_EVENTS[faction_name][event_number].duration
            end
        end
        EUR_EVENTS[faction_name][event_number].active_cooldown = EUR_EVENTS[faction_name][event_number].cooldown
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            EUR_EVENTS[faction_name][event_number].active_duration = EUR_EVENTS[faction_name][event_number].duration
        end
        EUR_EVENTS[faction_name][event_number].unlocked = false

        if EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound] ~= nil then
            M2TWEOPSounds.playEOPSound(EOP_WAVS[EUR_EVENTS[faction_name][event_number].sound])
        end

        stratmap.game.callConsole("add_money", "-" .. tostring(EUR_EVENTS[faction_name][event_number].cost))

        show_events_window = false
        eur_event_min_cooldown = 10
        event_selected[event_number] = false
        event_number = 99
    end
end

EUR_EVENTS["ireland"][0].func = lorien_0
EUR_EVENTS["ireland"][1].func = lorien_1
EUR_EVENTS["ireland"][2].func = lorien_2
EUR_EVENTS["ireland"][3].func = elves_0

EUR_EVENTS["mongols"][0].func = lorien_0
EUR_EVENTS["mongols"][1].func = lorien_1
EUR_EVENTS["mongols"][2].func = wr_0
EUR_EVENTS["mongols"][3].func = elves_0

EUR_EVENTS["saxons"][0].func = imladris_1
EUR_EVENTS["saxons"][1].func = imladris_0
EUR_EVENTS["saxons"][2].func = lorien_1
EUR_EVENTS["saxons"][3].func = elves_0

EUR_EVENTS["denmark"][0].func = lindon_0
EUR_EVENTS["denmark"][1].func = lorien_1
EUR_EVENTS["denmark"][2].func = imladris_1
EUR_EVENTS["denmark"][3].func = elves_0

EUR_EVENTS["england"][0].func = mordor_0
EUR_EVENTS["england"][1].func = orcgobbo_0

EUR_EVENTS["hre"][0].func = mordor_0
EUR_EVENTS["hre"][1].func = orcgobbo_0

EUR_EVENTS["poland"][0].func = mordor_0
EUR_EVENTS["poland"][1].func = orcgobbo_0

EUR_EVENTS["normans"][0].func = mordor_0
EUR_EVENTS["normans"][1].func = orcgobbo_0

EUR_EVENTS["hungary"][0].func = dwarven_0

EUR_EVENTS["norway"][0].func = dwarven_0

EUR_EVENTS["moors"][0].func = dwarven_0

EUR_EVENTS["sicily"][0].func = gondor_0
EUR_EVENTS["sicily"][1].func = mengood_0
EUR_EVENTS["sicily"][2].func = gondor_1
EUR_EVENTS["sicily"][3].func = gondor_2

EUR_EVENTS["milan"][0].func = gondor_0
EUR_EVENTS["milan"][1].func = mengood_0
EUR_EVENTS["milan"][2].func = rohan_1

EUR_EVENTS["turks"][0].func = gondor_0
EUR_EVENTS["turks"][1].func = mengood_0

EUR_EVENTS["scotland"][0].func = gondor_0
EUR_EVENTS["scotland"][1].func = mengood_0

function eventSideWindow(faction_name, faction)
    if event_number ~= nil then
        if not EUR_EVENTS[faction_name][event_number] then return end
        ImGui.SameLine()
        ImGui.BeginGroup()
        ImGui.SetNextWindowBgAlpha(0.5)
        ImGui.BeginChild("Events_window_02", 620*eurbackgroundWindowSizeRight, 545*eurbackgroundWindowSizeBottom, ImGuiChildFlags.FrameStyle)
        centeredText(EUR_EVENTS[faction_name][event_number].name, 20)
        ImGui.NewLine()
        ImGui.TextWrapped("Gold: "..tostring(EUR_EVENTS[faction_name][event_number].cost))
        if EUR_EVENTS[faction_name][event_number].duration ~= nil then
            ImGui.TextWrapped("Duration: "..tostring(EUR_EVENTS[faction_name][event_number].duration))
        end
        ImGui.TextWrapped("Cooldown: "..tostring(EUR_EVENTS[faction_name][event_number].cooldown))
        ImGui.NewLine()
        ImGui.SetNextWindowBgAlpha(00)
        ImGui.BeginChild("Events_window_05", 400*eurbackgroundWindowSizeRight, 150*eurbackgroundWindowSizeBottom)
        ImGui.TextWrapped(EUR_EVENTS[faction_name][event_number].desc)
        ImGui.EndChild()
        ImGui.NewLine()

        EUR_EVENTS[faction_name][event_number].func(faction_name, true)

        ImGui.EndChild()

        ImGui.SetNextWindowBgAlpha(0)
        ImGui.SetNextWindowPos(1115*eurbackgroundWindowSizeRight, 620*eurbackgroundWindowSizeBottom)
        ImGui.BeginChild("Events_window_03", 620*eurbackgroundWindowSizeRight, 60*eurbackgroundWindowSizeBottom)
        if EUR_EVENTS[faction_name][event_number].active_cooldown == 0 then
            if eur_event_min_cooldown == 0 then
                if faction.money >= EUR_EVENTS[faction_name][event_number].cost then
                    if (centeredImageButton("Accept", 80, 50, 0)) then
                        EUR_EVENTS[faction_name][event_number].func(faction_name, false)
                    end
                else
                    centeredText("Requires: ".. tostring(EUR_EVENTS[faction_name][event_number].cost) .. " Gold.", 20)
                end
            else
                centeredText("Too soon since last event, next available in: ".. tostring(eur_event_min_cooldown) .. " Turns.", 20)
            end
        else
            centeredText("Event on cooldown for: ".. tostring(EUR_EVENTS[faction_name][event_number].active_cooldown) .. " Turns.", 20)
        end
        ImGui.EndChild()
        ImGui.EndGroup()
    end
end
