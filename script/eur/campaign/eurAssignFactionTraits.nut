::EUR.gondor_fief_traits <- [
    "Amrothian", "Lossarnach", "RingloVale", "Morthond", "Anfalas",
    "PinnathGelin", "Lamedon", "Lebennin", "Anorien", "Ithillien",
]

::EUR.gondor_fief_units <- {
    Amrothian    = "Nimrodel Mariners",
    Lossarnach   = "Lossarnach Household Guard",
    RingloVale   = "Ringlo House Guards",
    Morthond     = "Anfalas Bodyguard",
    Anfalas      = "Anfalas Bodyguard",
    PinnathGelin = "Pinnath Gelin Footmen",
    Lamedon      = "Lamedon Champions",
    Lebennin     = "Pinnath Gelin Footmen",
    Anorien      = "Citadel Guard",
    Ithillien    = "Ithilien Rangers",
}

::EUR.gondor_start_traits <- {
    denethor_1 = "Anorien", denethor_rk = "Anorien",
    boromir_1 = "Anorien", boromir_rk = "Anorien",
    angbor_1 = "Lamedon", angbor_rk = "Lamedon",
    faramir_1 = "Anorien", faramir_rk = "Anorien",
    Dervorin_eop_1 = "RingloVale", dervorin_rk = "RingloVale",
    dinenion_1 = "Anfalas", dinenion_rk = "Anfalas",
    duinhir_1 = "Morthond", duinhir_rk = "Morthond",
    forlong_1 = "Lossarnach", forlong_rk = "Lossarnach",
    golasgil_1 = "Anfalas", golasgil_rk = "Anfalas",
    hirluin_1 = "PinnathGelin", hirluin_rk = "PinnathGelin",
    hurin_1 = "Anorien", hurin_rk = "Anorien",
    iorthon_1 = "Amrothian", iorthon_rk = "Amrothian",
    orodreth_1 = "Lebennin", orodreth_rk = "Lebennin",
    baragund_1 = "Amrothian", baragund_rk = "Amrothian",
    istion_1 = "Amrothian", istion_rk = "Amrothian",
    mistven_1 = "Amrothian", mistven_rk = "Amrothian",
    adrahil_1 = "Amrothian", adrahil_rk = "Amrothian",
    imrahil_1 = "Amrothian", imrahil_rk = "Amrothian",
}

::EUR.assignRandomFief <- function(character) {
    local trait = ::EUR.gondor_fief_traits[::EUR.math.random(0, ::EUR.gondor_fief_traits.len() - 1)]
    character.addTrait(trait, 1)
    character.ensureLabel()
    if (character.label != "" && !(character.label in ::EUR.bgunlock_units_list) && trait != "Anorien") {
        ::EUR.bgunlock_units_list[character.label] <- ::EUR.gondor_fief_units[trait]
    }
}

::EUR.addGondorFiefTrait <- function(character) {
    if (character == null) return
    if (character.label == "") { character.ensureLabel() }

    if (character.label in ::EUR.gondor_start_traits) {
        // a scripted starting lord: give exactly their fief (once)
        local startTrait = ::EUR.gondor_start_traits[character.label]
        if (::EUR.hasTrait(character, startTrait)) return
        character.addTrait(startTrait, 1)
        return
    }

    // already has a fief? nothing to do.
    foreach (fiefTrait in ::EUR.gondor_fief_traits) {
        if (::EUR.hasTrait(character, fiefTrait)) return
    }

    if (character.parent != null) {
        local firstFief = ::EUR.gondor_fief_traits[0]
        if (::EUR.hasTrait(character.parent, firstFief)) {
            character.addTrait(firstFief, 1)
        } else {
            ::EUR.assignRandomFief(character)
        }
    } else {
        ::EUR.assignRandomFief(character)
    }
}
