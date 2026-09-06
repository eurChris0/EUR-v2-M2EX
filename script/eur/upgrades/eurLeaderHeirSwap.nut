
::EUR.leaderheir_combi_list <- {
    ["milan"] = {
        leader = {unit="King's Horseguard",ability="CHARGE",},
        heir = {unit="King's Horseguard",ability="CAPTAIN",},
    },
    ["sicily"] = {
        leader = {unit="Stewards Guards",ability="IRON_FIST",},
        heir = {unit="Osgiliath Veterans",ability="SHIELD",},
    },
    ["turks"] = {
        leader = {unit="Grey Company",ability="CAPTAIN",},
        heir = {unit="Dunedain Bodyguard",ability="CAPTAIN",},
    },
    ["russia"] = {
        leader = {unit="Royal Legion of Armenelos",ability="NUMENOR",},
        heir = {unit="Naru n'Aru Sentinels",ability="NUMENOR",},
    },
    ["scotland"] = {
        leader = {unit="Royal Guardsmen",ability="IRON_FIST",},
        heir = {unit="Hearthguard",ability="CAPTAIN",},
    },
    ["byzantium"] = {
        leader = {unit="High Paladins",ability="IRON_FIST",},
        heir = {unit="High Paladins",ability="SHIELD",},
    },
    ["timurids"] = {
        leader = {unit="Beorning Shapeshifters",ability="BEORN",},
        heir = {unit="Skin-Changers",ability="BEORN",},
    },
    ["portugal"] = {
        leader = {unit="Dreadguard",ability="IRON_FIST",},
        heir = {unit="Darkblades",ability="VENOM",},
    },
    ["aztecs"] = {
        leader = {unit="Orthanc Guard",ability="SHIELD",},
        heir = {unit="Brenin's Guard",ability="SHIELD",},
    },
    ["teutonic_order"] = {
        leader = {unit="Mochaini Ambaxtoi",ability="IRON_FIST",},
        heir = {unit="Dubhshith Foresters",ability="IRON_FIST",},
    },
    ["spain"] = {
        leader = {unit="Black Snake Guard",ability="VENOM",},
        heir = {unit="Black Snake Guard",ability="VENOM",},
    },
    ["khand"] = {
        leader = {unit="Variag Nobles",ability="VENOM",},
        heir = {unit="Variag Nobles",ability="VENOM",},
    },
    ["venice"] = {
        leader = {unit="Loke Rim Bodyguard",ability="VENOM",},
        heir = {unit="Loke Rim Bodyguard",ability="VENOM",},
    },
    ["norway"] = {
        leader = {unit="Khazad-dum Reclaimers",ability="DWARVES",},
        heir = {unit="Zenith Guard",ability="DWARVES",},
    },
    ["hungary"] = {
        leader = {unit="Gabilgathol Guard",ability="DWARVES",},
        heir = {unit="Broadbeam Marksmen",ability="DWARVES",},
    },
    ["moors"] = {
        leader = {unit="Legionaries of Erebor",ability="DWARVES",},
        heir = {unit="Axeguard of Erebor",ability="DWARVES",},
    },
    ["mongols"] = {
        leader = {unit="Aredhirith",ability="SILVAN",},
        heir = {unit="Hin e-Daur",ability="SILVAN",},
    },
    ["ireland"] = {
        leader = {unit="Berio I Ngelaidh",ability="SILVAN",},
        heir = {unit="Elbereths Sentinels",ability="Light_of_the_Faith",},
    },
    ["denmark"] = {
        leader = {unit="Falas Lords",ability="ELROND",},
        heir = {unit="Heavy Falathrim Axeguard",ability="Light_of_the_Faith",},
    },
    ["saxons"] = {
        leader = {unit="Elderinwe Roquen",ability="ELROND",},
        heir = {unit="Noldorin Archers",ability="Light_of_the_Faith",},
    },
    ["egypt"] = {
        leader = {unit="Maedhros Oathsworn",ability="ELROND",},
        heir = {unit="Eregion Avengers",ability="Light_of_the_Faith",},
    },
    ["england"] = {
        leader = {unit="Temple Marksmen",ability="ORC_DRAUGHT",},
        heir = {unit="Temple Knights",ability="ORC_DRAUGHT",},
    },
    ["poland"] = {
        leader = {unit="Khamuls Shadowknights",ability="VENOM",},
        heir = {unit="Castellans of Dol Guldur",ability="VENOM",},
    },
    ["hre"] = {
        leader = {unit="Mountain Uruks",ability="LEGION",},
        heir = {unit="Goblin Bodyguards",ability="ORC_DRAUGHT",},
    },
    ["gundabad"] = {
        leader = {unit="Pale Uruks",ability="LEGION",},
        heir = {unit="Orc Avengers",ability="ORC_DRAUGHT",},
    },
    ["normans"] = {
        leader = {unit="Blue Crag Orc Blunt",ability="LEGION",},
        heir = {unit="Blue Crag Berserkers",ability="ORC_DRAUGHT",},
    },
    ["france"] = {
        leader = {unit="Guard of the Hand",ability="LEGION",},
        heir = {unit="Berserkers",ability="ORC_DRAUGHT",},
    },
    ["papal_states"] = {
        leader = {unit="Guard of the Hand",ability="LEGION",},
        heir = {unit="Berserkers",ability="ORC_DRAUGHT",},
    },
}

::EUR.current_heir_check <- []

::EUR.swapHierLeaderStuff <- function(character, bool) {
    if (::EUR.to_log) {
        println("EUR SCRIPT: " + "swapHierLeaderStuff")
    }
    if (::EUR.eur_campaign == null) return
    if (character == null) return
    if (bool) {
        if ((character.faction.name in ::EUR.leaderheir_combi_list) && ::EUR.leaderheir_combi_list[character.faction.name]) {
            if (character.heroAbility == "") {
                //println("true")
                character.heroAbility = ::EUR.leaderheir_combi_list[character.faction.name].leader.ability
            }
        }
    } else {
        if ((character.faction.name in ::EUR.leaderheir_combi_list) && ::EUR.leaderheir_combi_list[character.faction.name]) {
            if (character.heroAbility == "") {
                //println("true")
                if (::EUR.swapHierStuffCheck(character.faction)) {
                    character.heroAbility = ::EUR.leaderheir_combi_list[character.faction.name].heir.ability
                }
            }
        }
    }
}

::EUR.swapHierStuffCheck <- function(faction) {
    if (::EUR.to_log) {
        println("EUR SCRIPT: " + "swapHierStuffCheck")
    }
    if (::EUR.current_heir_check.len() == 0 || ::EUR.current_heir_check[0] == null) {
        ::EUR.current_heir_check.insert(0, faction.heir)
        return true
    } else {
        if (::EUR.current_heir_check[0].isAlive == true) {
            return false
        } else {
            ::EUR.current_heir_check = []
            ::EUR.current_heir_check.insert(0, faction.heir)
            return true
        }
    }
}

::EUR.swapHeirLeaderStuffAI <- function(faction) {
    if (::EUR.to_log) {
        println("EUR SCRIPT: " + "swapHeirLeaderStuffAI")
    }
    if (faction.isPlayerControlled == 1) return
    if (!(faction.name in ::EUR.default_general_units) || !::EUR.default_general_units[faction.name]) return
    if ((faction.name in ::EUR.leaderheir_combi_list) && ::EUR.leaderheir_combi_list[faction.name]) {
        local char = faction.leader
        if (char != null) {
            if (char.character != null) {
                if (char.character.heroAbility == "") {
                    char.character.heroAbility = ::EUR.leaderheir_combi_list[faction.name].leader.ability
                }
                if (char.character.bodyguard != null) {
                    if (::EUR.default_general_units[faction.name].old == char.character.bodyguard.type.name) {
                        local eduEntry = ::units.get(::EUR.leaderheir_combi_list[faction.name].leader.unit)
                        if (char.character.bodyguard.type.name == ::EUR.leaderheir_combi_list[faction.name].leader.unit) return
                        if (eduEntry != null) {
                            if (eduEntry.hasOwnership(faction.id)) {
                                if (char.character.bodyguard.army) {
                                    if (char.character.bodyguard.army.unitCount < 20) {
                                        ::EUR.setBodyguard(char.character, (::EUR.leaderheir_combi_list[faction.name].leader.unit), char.character.bodyguard.experience, char.character.bodyguard.weaponLevel, 0, "")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        char = faction.heir
        if (char != null) {
            if (char.character != null) {
                if (char.character.heroAbility == "") {
                    char.character.heroAbility = ::EUR.leaderheir_combi_list[faction.name].heir.ability
                }
                if (char.character.bodyguard != null) {
                    if (char.character.bodyguard.type.name == ::EUR.leaderheir_combi_list[faction.name].heir.unit) return
                    if (::EUR.default_general_units[faction.name].old == char.character.bodyguard.type.name) {
                        local eduEntry = ::units.get(::EUR.leaderheir_combi_list[faction.name].heir.unit)
                        if (eduEntry != null) {
                            if (eduEntry.hasOwnership(faction.id)) {
                                if (char.character.bodyguard.army) {
                                    if (char.character.bodyguard.army.unitCount < 20) {
                                        ::EUR.setBodyguard(char.character, (::EUR.leaderheir_combi_list[faction.name].heir.unit), char.character.bodyguard.experience, char.character.bodyguard.weaponLevel, 0, "")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
