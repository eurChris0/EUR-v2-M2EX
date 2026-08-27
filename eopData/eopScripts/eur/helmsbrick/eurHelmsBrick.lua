-- ============================================================
--  eur/helmsbrick/eurHelmsBrick.lua
--  HELM'S BRICK – LEGO Battle of Helm's Deep Easter Egg
-- ============================================================
--
--  TRIGGER: Player (Rohan or Isengard) renames Hornburg to
--           "Helm's Brick" on the campaign map.
--
--  FLOW:
--    1. onSettlementTurnStart detects the renamed settlement
--       and fires the event_counter "brick_me".
--    2. onFactionTurnStart (human player turn only) reads the
--       counter and spawns the LEGO armies.
--
--  ──────────────────────────────────────────────────────────
--  SETUP CHECKLIST
--  ──────────────────────────────────────────────────────────
--  1. campaign_script.txt  →  add the line:
--         event_counter brick_me 0
--
--  2. eurGameOptions.lua (or wherever game_options defaults
--     are initialised)  →  add:
--         game_options.helm_bricked = false
--
--  3. luaPluginScript.lua (inside the eur_main_scripts block)
--     →  add before the eurEvents require:
--         require("eur/helmsbrick/eurHelmsBrick")
--
--  4. Your onSettlementTurnStart handler  →  add at the top:
--         helmsBrick.checkForBrick(eventData)
--
--  5. Your onFactionTurnStart handler  →  add at the top:
--         helmsBrick.triggerIfReady(eventData)
--
-- ============================================================

helmsBrick = {}

-- ── Coordinates & settlement ─────────────────────────────
local SETT_NAME = "Helms_Deep"      -- internal name in descr_strat
local LEGO_NAME = "Helm's Brick"  -- localizedName that fires the egg
local ATTACK_X  = 231             -- besieging army tile
local ATTACK_Y  = 260
local REINF_X   = 231             -- friendly reinforcement tile
local REINF_Y   = 259

-- ── Unit tables ──────────────────────────────────────────
--  Format: { type = "EDU name", exp = N, armor = N, weapon = N }
--  The bodyguard unit is supplied separately to eurSpawnArmy.
--  All entries here are created with army:createUnit().

-- Isengard army that attacks the Rohan player
local ATTACK_VS_ROHAN = {
    { type = "Lego Uruk-hai Infantry",          exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry",          exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 5, armor = 1, weapon = 1 },
    { type = "Berserker",                       exp = 5, armor = 0, weapon = 0 },
}

-- Rohan reinforcements that arrive to help the Rohan player
local REINF_FOR_ROHAN = {
    { type = "Lego Rohirrim", exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Rohirrim", exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 4, armor = 1, weapon = 0 },
}

-- Rohan army that attacks the Isengard player
local ATTACK_VS_ISENGARD = {
    { type = "Lego Rohirrim", exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Rohirrim", exp = 5, armor = 1, weapon = 1 },
    { type = "Lego Spearmen", exp = 5, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 5, armor = 1, weapon = 0 },
    { type = "Lego Spearmen", exp = 5, armor = 1, weapon = 0 },
}

-- Isengard reinforcements that arrive to help the Isengard player
local REINF_FOR_ISENGARD = {
    { type = "Lego Uruk-hai Infantry",          exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry",          exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 4, armor = 1, weapon = 1 },
    { type = "Lego Uruk-hai Infantry Upgraded", exp = 4, armor = 1, weapon = 1 },
    { type = "Berserker",                       exp = 4, armor = 0, weapon = 0 },
    { type = "Berserker",                       exp = 4, armor = 0, weapon = 0 },
}

-- ── Private helpers ──────────────────────────────────────

-- Apply traits to a general so the AI commands it properly
-- and it cannot be disbanded/killed by script cleanup.
local function applyLegoGeneralTraits(namedChar)
    if namedChar == nil then return end
    namedChar:addTrait("AIBoost",            1)
    namedChar:addTrait("Locked",             1)  -- prevents script removal
    namedChar:addTrait("GoodCommander",      3)
    namedChar:addTrait("BattleScarred",      2)
    namedChar:addTrait("NightBattleCapable", 1)
end

-- Spawn a LEGO army, populate it, and return the armyStruct.
-- bgUnit    – EDU type name used as the general's bodyguard.
-- shortName – character short name shown in-game.
-- label     – must be unique across the whole campaign.
local function spawnLegoArmy(factionName, shortName, label, bgUnit, x, y, units)
    local army = eurSpawnArmy(
        factionName,   -- faction internal name
        shortName,     -- char short name
        label,         -- unique script label
        "",            -- portrait folder (empty = default)
        false,         -- do not auto-adopt into family tree
        35,            -- character age
        bgUnit,        -- bodyguard unit type (EDU name)
        x, y,          -- map coordinates
        4,             -- bodyguard exp
        1,             -- bodyguard weapon upgrade
        1              -- bodyguard armour upgrade
    )

    if army == nil then
        M2TWEOP.logGame("HelmsBrick ERROR: eurSpawnArmy returned nil for '" .. label .. "'")
        return nil
    end

    -- Populate the army with regular units
    for _, u in ipairs(units) do
        army:createUnit(u.type, u.exp, u.armor, u.weapon)
    end

    -- Apply general traits
    if army.leader ~= nil then
        applyLegoGeneralTraits(army.leader.namedCharacter)
    end

    return army
end

-- ── Public spawn functions ───────────────────────────────

-- Called when the player is Rohan.
-- Spawns: Isengard attacker at (231,260), Rohan reinf at (231,259).
function helmsBrick.spawnForRohan()
    local sett = eur_sMap:getSettlement(SETT_NAME)
    if sett == nil then
        --M2TWEOP.logGame("HelmsBrick ERROR: settlement '" .. SETT_NAME .. "' not found.")
        return
    end

    -- Isengard besieging army
    local attArmy = spawnLegoArmy(
        "france",
        "Uruk Commander",
        "helmsbrick_att_r",          -- unique label
        "Lego Uruk-hai Infantry",
        ATTACK_X, ATTACK_Y,
        ATTACK_VS_ROHAN
    )

    -- Rohan relief force (same faction as player → player keeps it)
    local reinfArmy = spawnLegoArmy(
        "milan",
        "Rohirrim Marshal",
        "helmsbrick_rei_r",          -- unique label
        "Lego Rohirrim",
        REINF_X, REINF_Y,
        REINF_FOR_ROHAN
    )

    -- Trigger the siege assault immediately
    if attArmy ~= nil then
        attArmy:siegeSettlement(sett, true)
    end

    --M2TWEOP.logGame("HelmsBrick: Helm's Brick spawned for Rohan player.")
end

-- Called when the player is Isengard.
-- Spawns: Rohan attacker at (231,260), Isengard reinf at (231,259).
function helmsBrick.spawnForIsengard()
    local sett = eur_sMap:getSettlement(SETT_NAME)
    if sett == nil then
        --M2TWEOP.logGame("HelmsBrick ERROR: settlement '" .. SETT_NAME .. "' not found.")
        return
    end

    -- Rohan besieging army
    local attArmy = spawnLegoArmy(
        "milan",
        "Rohan General",
        "helmsbrick_att_i",          -- unique label
        "Lego Rohirrim",
        ATTACK_X, ATTACK_Y,
        ATTACK_VS_ISENGARD
    )

    -- Isengard relief force (same faction as player → player keeps it)
    local reinfArmy = spawnLegoArmy(
        "france",
        "Uruk Vanguard",
        "helmsbrick_rei_i",          -- unique label
        "Lego Uruk-hai Infantry",
        REINF_X, REINF_Y,
        REINF_FOR_ISENGARD
    )

    -- Trigger the siege assault immediately
    if attArmy ~= nil then
        attArmy:siegeSettlement(sett, true)
    end

    --M2TWEOP.logGame("HelmsBrick: Helm's Brick spawned for Isengard player.")
end

-- ── Event hooks ──────────────────────────────────────────
-- These are thin wrappers; call them from your existing
-- event handler functions.

-- ▸ Add to your onSettlementTurnStart(eventData):
--       helmsBrick.checkForBrick(eventData)
--
-- Detects the rename and arms the "brick_me" event_counter.
-- Guarded by game_options.helm_bricked so it only ever fires once.
function helmsBrick.checkForBrick(eventData)
    local sett = eventData.settlement
    if sett == nil then return end

    -- Only care about Helm's Brick
    if sett.localizedName ~= LEGO_NAME then return end

    -- Only valid for Rohan or Isengard as the human player
    local pFac = eur_player_faction
    if pFac == nil then return end
    local fName = pFac.name
    if fName ~= "milan" and fName ~= "france" then return end

    -- Settlement must be owned by the player's faction
    if sett.ownerFaction == nil then return end
    if sett.ownerFaction.name ~= fName then return end

    -- One-shot guard
    if game_options.helm_bricked then return end

    -- Arm the counter – spawning happens next player turn start
    M2TWEOP.setScriptCounter("brick_me", 1)
    game_options.helm_bricked = true
    --M2TWEOP.logGame("HelmsBrick: 'Helm's Brick' rename detected – battle queued for next turn.")
end

-- ▸ Add to your onFactionTurnStart(eventData):
--       helmsBrick.triggerIfReady(eventData)
--
-- Reads the counter on the PLAYER's turn start only, then
-- spawns the appropriate LEGO armies.
function helmsBrick.triggerIfReady(eventData)
    -- Ignore AI turns
    if eventData.faction.isPlayerControlled ~= 1 then return end

    if M2TWEOP.getScriptCounter("brick_me") ~= 1 then return end

    -- Disarm immediately so this can only run once per session
    M2TWEOP.setScriptCounter("brick_me", 0)

    local fName = eur_player_faction.name
    if fName == "milan" then
        helmsBrick.spawnForRohan()
    elseif fName == "france" then
        helmsBrick.spawnForIsengard()
    end
end

return helmsBrick