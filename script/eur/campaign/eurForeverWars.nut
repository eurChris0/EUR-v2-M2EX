// Readable campaign aliases for the fixed engine faction IDs.
local Dunland = "aztecs"
local Dorwinon = "byzantium"
local Lindon = "denmark"
local Noldor = "egypt"
local Mordor = "england"
local Isenguard = "france"
local Gundabad = "gundabad"
local Misty_Mountains = "hre"
local Ered_Luin = "hungary"
local Lothlorien = "ireland"
local Khand = "khand"
local Rohan = "milan"
local Woodland_Realm = "mongols"
local Erebor = "moors"
local Blue_Craigs = "normans"
local Khazad_Dum = "norway"
local Sauron = "papal_states"
local Dol_Goldur = "poland"
local Angmar = "portugal"
local Ar_Ardunaim = "russia"
local Imladris = "saxons"
local Dale = "scotland"
local spawningPool = "scripts"
local Gondor = "sicily"
local Rebels = "slave"
local Harad = "spain"
local Enedwaith = "teutonic_order"
local Anduin_Vale = "timurids"
local Northern_Dunedain = "turks"
local ReunitedKingdom = "united"
local Rhun = "venice"

::EUR.FOREVER_WARS <- {
    [Dunland] = [],
    [Dorwinon] = [],
    [Lindon] = [],
    [Noldor] = [],
    [Mordor] = [],
    [Isenguard] = [],
    [Gundabad] = [],
    [Misty_Mountains] = [],
    [Ered_Luin] = [],
    [Lothlorien] = [],
    [Khand] = [],
    [Rohan] = [],
    [Woodland_Realm] = [],
    [Erebor] = [],
    [Blue_Craigs] = [],
    [Khazad_Dum] = [],
    [Sauron] = [],
    [Dol_Goldur] = [],
    [Angmar] = [],
    [Ar_Ardunaim] = [],
    [Imladris] = [],
    [Dale] = [],
    [spawningPool] = [],
    [Gondor] = [],
    [Rebels] = [],
    [Harad] = [],
    [Enedwaith] = [],
    [Anduin_Vale] = [],
    [Northern_Dunedain] = [],
    [ReunitedKingdom] = [],
    [Rhun] = [],
}

::EUR.foreverWarUsesCounter <- function(counterName) {
    foreach (rules in ::EUR.FOREVER_WARS) {
        foreach (rule in rules) {
            if ("endsOn" in rule && rule.endsOn == counterName) { return true }
        }
    }
    return false
}

::EUR.applyForeverWars <- function(campaign) {
    if (campaign == null) { return false }

    local allApplied = true
    foreach (firstName, rules in ::EUR.FOREVER_WARS) {
        foreach (rule in rules) {
            local first = campaign.factionByName(firstName)
            local second = campaign.factionByName(rule.target)
            if (first == null || second == null) {
                println("eur: forever-war rule has an unknown faction: " + firstName + ", " + rule.target)
                allApplied = false
                continue
            }

            local ended = false
            if ("endsOn" in rule) {
                local counterValue = campaign.getEventCounter(rule.endsOn)
                ended = counterValue != null && counterValue > 0
            }

            if (!campaign.setForeverWar(first, second, !ended)) {
                println("eur: failed to update forever-war rule: " + firstName + ", " + rule.target)
                allApplied = false
                continue
            }

            if (ended && "makePeace" in rule && rule.makePeace) {
                if (!campaign.setStance(::Enum.DiplomaticRelation.peace, first, second)) {
                    println("eur: failed to make peace after forever war: " + firstName + ", " + rule.target)
                    allApplied = false
                }
            }
        }
    }
    return allApplied
}
