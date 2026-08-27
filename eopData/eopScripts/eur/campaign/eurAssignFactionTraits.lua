gondor_fief_traits = 
{
    "Amrothian",
    "Lossarnach",
    "RingloVale",
    "Morthond",
    "Anfalas",
    "PinnathGelin",
    "Lamedon",
    "Lebennin",
    "Anorien",
    "Ithillien",
}

gondor_fief_units = 
{
    ["Amrothian"] = "Nimrodel Mariners",
    ["Lossarnach"] = "Lossarnach Household Guard",
    ["RingloVale"] = "Ringlo House Guards",
    ["Morthond"] = "Anfalas Bodyguard",
    ["Anfalas"] = "Anfalas Bodyguard",
    ["PinnathGelin"] = "Pinnath Gelin Footmen",
    ["Lamedon"] = "Lamedon Champions",
    ["Lebennin"] = "Pinnath Gelin Footmen",
    ["Anorien"] = "Citadel Guard",
    ["Ithillien"] = "Ithilien Rangers",
}

gondor_start_traits = 
{
    ["denethor_1"] = "Anorien",
    ["denethor_rk"] = "Anorien",
    ["boromir_1"] = "Anorien",
    ["boromir_rk"] = "Anorien",
    ["angbor_1"] = "Lamedon",
    ["angbor_rk"] = "Lamedon",
    ["faramir_1"] = "Anorien",
    ["faramir_rk"] = "Anorien",
    ["Dervorin_eop_1"] = "RingloVale",
    ["dervorin_rk"] = "RingloVale",
    ["dinenion_1"] = "Anfalas",
    ["dinenion_rk"] = "Anfalas",
    ["duinhir_1"] = "Morthond",
    ["duinhir_rk"] = "Morthond",
    ["forlong_1"] = "Lossarnach",
    ["forlong_rk"] = "Lossarnach",
    ["golasgil_1"] = "Anfalas",
    ["golasgil_rk"] = "Anfalas",
    ["hirluin_1"] = "PinnathGelin",
    ["hirluin_rk"] = "PinnathGelin",
    ["hurin_1"] = "Anorien",
    ["hurin_rk"] = "Anorien",
    ["iorthon_1"] = "Amrothian",
    ["iorthon_rk"] = "Amrothian",
    ["orodreth_1"] = "Lebennin",
    ["orodreth_rk"] = "Lebennin",
    ["baragund_1"] = "Amrothian",
    ["baragund_rk"] = "Amrothian",
    ["istion_1"] = "Amrothian",
    ["istion_rk"] = "Amrothian",
    ["mistven_1"] = "Amrothian",
    ["mistven_rk"] = "Amrothian",
    ["adrahil_1"] = "Amrothian",
    ["adrahil_rk"] = "Amrothian",
    ["imrahil_1"] = "Amrothian",
    ["imrahil_rk"] = "Amrothian",
}

function addGondorFiefTrait(character)
    --print("addGondorFiefTrait")
    if character ~= nil then
        if character.label == "" then
            character:giveValidLabel()
        end
        --print("label "..character.label)
        if not gondor_start_traits[character.label] then
            for i = 1, #gondor_fief_traits do
                if hasTrait(character, gondor_fief_traits[i]) then 
                    --print("already has "..character.label)
                    return end
            end
            if character.parent ~= nil then
                for i = 1, #gondor_fief_traits do
                    if hasTrait(character.parent, gondor_fief_traits[i]) then
                        character:addTrait(gondor_fief_traits[i], 1)
                        --print("added "..character.label)
                    break
                    else
                        local rand = math.random(1, #gondor_fief_traits)
                        character:addTrait(gondor_fief_traits[rand], 1)
                        --print("added "..character.label)
                        character:giveValidLabel()
                        if character.label ~= "" then
                            if not bgunlock_units_list[character.label] then
                                local trait = gondor_fief_traits[rand]
                                if trait ~= "Anorien" then
                                    bgunlock_units_list[character.label] = gondor_fief_units[trait]
                                end
                            end
                        end 
                        break
                    end
                end
            else
                local rand = math.random(1, #gondor_fief_traits)
                character:addTrait(gondor_fief_traits[rand], 1)
                --print("added "..character.label)
                character:giveValidLabel()
                if character.label ~= "" then
                    if not bgunlock_units_list[character.label] then
                        local trait = gondor_fief_traits[rand]
                        if trait ~= "Anorien" then
                            bgunlock_units_list[character.label] = gondor_fief_units[trait]
                        end
                    end
                end 
            end
        else
            if hasTrait(character, gondor_start_traits[character.label]) then 
                return 
            else
                character:addTrait(gondor_start_traits[character.label], 1)
                --print("added "..character.label)
                if not bgunlock_units_list[character.label] then
                    local trait = gondor_fief_traits[character.label]
                    if trait ~= "Anorien" then
                        bgunlock_units_list[character.label] = gondor_fief_units[trait]
                    end
                end
            end
        end
    end
end
