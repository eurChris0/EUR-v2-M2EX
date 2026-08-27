
function eurSpawnCustomGeneral(faction_name, name, label, custom_portrait, family, age, unit, x, y, exp, weapon, armor, modelName, casModel)
    local x, y = getValidTile(x, y)
    if tableContains(labels_unedited, label) then
        -- nothing
     else
        label = label .. tostring(eur_turn_number) .. tostring(eur_spawned_characters)
     end
    local army = stratmap.game.spawnArmy(
    eur_campaign:getFaction(faction_name),
    name,
    "",
    characterType.named_character,
    label,
    custom_portrait,
    x, y,
    age, family, 31,
    M2TWEOPDU.getEduIndexByType(unit), exp, weapon, armor
       )
    eur_spawned_characters = (eur_spawned_characters+1)
    local char = nil
    if army then
    if army.leader then
        char = army.leader
        char:setCharacterModel(casModel);
        char.characterRecord.modelName = modelName

    end
end
    
    return army, char
end

function galadrielTitleCheck()
    local fac = eur_campaign:getFaction("ireland")
    if fac ~= nil then
       if fac.numOfCharacters == 0 then return end
        if fac.leader ~= nil then
            if fac.leader.label == "celeborn_1" then return end
            if fac.leader.label == "galadriel_1" then
                local name = fac.leader.localizedDisplayName
                name = (string.gsub(name, "Lord ", "Lady "))
                M2TWEOP.setExpandedString("EMT_IRELAND_FACTION_LEADER_NAME", "Lady %S");
            else
                local name = fac.leader.localizedDisplayName
                name = (string.gsub(name, "Lady ", "Lord "))
                M2TWEOP.setExpandedString("EMT_IRELAND_FACTION_LEADER_NAME", "Lord %S");
            end
        end
    end
end

galadriel_spawn_title = [[The Lady of Lorien]]
galadriel_spawn_body = [[There are few who still walk the paths of Arda who remember the Elder Days. Among them, Círdan the Shipwright, one of the wise, far sighted both over land and the paths of the future, Glorfindel, who died in Gondolin and was returned by Manwe, the Balrogs in their pits, and Fangorn, the firstborn of Yavanna, who has ever walked the lands of Middle Earth. Yet, all of them, in their long years of existence, cannot help but love Galadriel. Her beauty was made timeless and unerring, even by the standards of the Eldar, by long years basking in the radiant majesty of the Two Trees of Valinor, and was made more radiant by the power of her ring, Nenya. She has shielded Lothlorien from unfriendly eyes, a craft she learned well from Melian in Doriath, and one that is supplemented by the Ring of Adamant.

Yet, now Sauron’s forces gather in numbers beyond counting, the Nazgul are dispatched to form their own realms, reclaiming their status as Kings of Old, gathering warhosts in the name of the Dark Lord on his Dark Throne. The White Council drove Sauron from Dol Guldur as the company of Thorin Oakenshield marched on Erebor, but the taint remained. The taint that turned Amon Lanc from a bastion of Elvendom in Rhovanion, to the tower of the Necromancer.

Long has she endured the ‘caution’ of Saruman, the assertion that they have time, even as the Enemy poisoned the Greenwood, unaware of his search for the Ruling Ring. She is not so blind as to deny that her heart desires it. Not for rulership, no… but so that she may drive the Spirit of Sauron from the Ring and unmake him. Though, those closest to her, the ones who are privy to those deepest thoughts, understand that such an act would diminish her, not in Power, for that is the one thing the Ring has in excess, but in beauty.

Yet, for all the games of the Wise, the Battle for Middle Earth has begun, and the Lady of Lorien is no longer content to merely wait and see. Saruman has long urged it, and now she perceives his treachery, and her wrath at the marring of Fangorn and the subjugation of the ‘Wildmen’ knows no bounds. The Mistress of Magic she is called by the men of Gondor, but they do not know how apt the title is, for in the Unseen Realm she is a bonfire. So potent is her spirit that she is radiant even to the eyes of Mortals. Armed with the foresight of the Eldar, and being one of the few who possess a Fëa of sufficient potency to threaten the Ring Lord, Galadriel once again girds herself for war. This is no sporting game in Aman, nor the grueling pilgrimage over Hithaeglir. The Servants of Shadow fear her already, and now she shall wield their fear as surely as any weapon, until Rhovanion is once again free of the Shadow.]]

its_tauriel = [[Tauriel, formerly the captain of King Thranduil's personal guard, has returned at long last from her mission to the Dwarves of Erebor. She brings tidings, and reassures the King that the Dwarves intend to honor their rekindled friendship. She seems to have been reinvigorated by that embassy, and takes her place once again among the Woodland Realm's finest wardens. While the shadows of Mirkwood are never fully dispelled, her return is another sign that the light shall persist even in the darkest of shadows.]]

function spawnTauriel()
    if anorien_swap.tauriel_spawned then return end
    if eur_player_faction.name == "mongols" then
        if eur_player_faction.settlementsNum > 9 then
            local army = eurSpawnCustomGeneral(eur_player_faction.name, "Tauriel", "Tauriel_1", "Tauriel", false, 35, 'Aredhirith', eur_player_faction.capital.xCoord, eur_player_faction.capital.yCoord, 2, 0, 0, "tauriel", "tauriel")
            stratmap.game.historicEvent("tauriel_spawned", "The Changing of the Guard", its_tauriel)
            anorien_swap.tauriel_spawned = true
            if army.leader ~= nil then
                local char = army.leader.characterRecord
                if char ~= nil then
                    char:addTrait("Hero", 1)
                    char:addTrait("ElvenRace", 1)
                    char:addTrait("HeroAbilitySilvanElf", 1)
                    char:addTrait("Brave", 1)
                    char:addTrait("GoodAmbusher", 1)
                    char:addTrait("GoodCommander", 2)
                    char:addTrait("Loyal", 3)
                    char:addTrait("LoyaltyStarter", 1)
                    char:addTrait("PietyStarter", 1)
                    char:addTrait("TacticalSkill", 2)
                    --
                    char:addAncillary("silvan_bow")
                    char:addAncillary("silvan_armour")
                    char:addAncillary("silvan_sentinel")
                    char:addAncillary("erebor_raven")
                    
                end
            end
        end
    else
        local army = eurSpawnCustomGeneral("mongols", "Tauriel", "tauriel_1", "Tauriel", false, 35, 'Aredhirith', eur_campaign:getFaction("mongols").capital.xCoord, eur_campaign:getFaction("mongols").capital.yCoord-1, 2, 0, 0, "tauriel", "tauriel")
        anorien_swap.tauriel_spawned = true
        if army.leader ~= nil then
            local char = army.leader.characterRecord
            if char ~= nil then
                char:addTrait("Hero", 1)
                char:addTrait("ElvenRace", 1)
                char:addTrait("HeroAbilitySilvanElf", 1)
                char:addTrait("Brave", 1)
                char:addTrait("GoodAmbusher", 1)
                char:addTrait("GoodCommander", 2)
                char:addTrait("Loyal", 3)
                char:addTrait("LoyaltyStarter", 1)
                char:addTrait("PietyStarter", 1)
                char:addTrait("TacticalSkill", 2)
                --
                char:addAncillary("silvan_bow")
                char:addAncillary("silvan_armour")
                char:addAncillary("silvan_sentinel")
                char.character.ability="SILVAN"
            end
        end
    end
end

function spawnGaladriel()
    local galad = getnamedCharbyLabel("galadriel_1")
    if galad ~= nil then 
        --galad.localizedDisplayName = "Lady Galadriel"
    end
    if anorien_swap.galadriel_spawned then return end
    if eur_player_faction.name == "ireland" then
        if eur_player_faction.settlementsNum > 9 then
            local army = eurSpawnCustomGeneral("ireland", "Artanis", "galadriel_1", "galadriel", true, 28, 'Berio I Ngelaidh', eur_campaign:getFaction("ireland").capital.xCoord-1, eur_campaign:getFaction("ireland").capital.yCoord, 5, 0, 0, "galadriel", "galadriel")
            anorien_swap.galadriel_spawned = true
            stratmap.game.historicEvent("galadriel_spawned", galadriel_spawn_title, galadriel_spawn_body)
            if army.leader ~= nil then
                local char = army.leader.characterRecord
                if char ~= nil then
                    --char.localizedDisplayName = "Lady Galadriel"
                    char:addTrait("Hero", 1)
                    char:addTrait("ElvenRace", 1)
                    char:addTrait("Noldor", 1)
                    char:addTrait("IsFamily", 1)
                    char:addTrait("Galadriel", 1)
                    --char:addTrait("HeroAbility_GALADRIEL", 1)
                    char:addTrait("ElvesBattleSurgery", 1)
                    char:addTrait("Loyal", 1)
                    char:addTrait("Just", 2)
                    char:addTrait("LoyaltyStarter", 1)
                    char:addTrait("LivedAges", 1)
                    char:addTrait("Hatesengland", 1)
                    char:addTrait("GoodCommander", 2)
                    char:addTrait("TacticalSkill", 2)
                    char:addTrait("GoodAdministrator", 3)
                    char:addTrait("NaturalManagementSkill", 3)
                    char:addTrait("NaturalMilitarySkill", 2)
                    char:addTrait("KindRuler", 2)
                    char:addTrait("FathersLegacy", 1)
                    char:addTrait("Handsome", 3)
                    --
                    char:addAncillary("nenya")
                    
                    --char.character.ability="GALADRIEL"
                    char.character.ability="Light_of_the_Faith"
                end
            end
        end
    end
end

function spawnSharku()
    local army = eurSpawnCustomGeneral("france", "Sharku", "sharku_1", "sharku", true, 28, 'Warg Riders', eur_campaign:getFaction("france").capital.xCoord-1, eur_campaign:getFaction("france").capital.yCoord, 5, 0, 0, "sharku", "sharku")
    --stratmap.game.historicEvent("galadriel_spawned", galadriel_spawn_title, galadriel_spawn_body)
    if army.leader ~= nil then
        anorien_swap.sharku_spawned = true
        local char = army.leader.characterRecord
        if char ~= nil then
            char:addTrait("Hero", 1)
            char:addTrait("UrukHaiRace", 1)
            char:addTrait("FactionHeirCustom", 1)
            char:addTrait("HeroAbilityUrukHai", 1)
            char:addTrait("BattleChivalryEvil", 2)
            char:addTrait("Bloodthirsty", 2)
            char:addTrait("GoodAttacker", 1)
            char:addTrait("GoodCommander", 2)
            char:addTrait("LoyaltyStarter", 1)
            char:addTrait("NightBattleCapable", 1)
            char:addTrait("PietyStarter", 1)
            char:addTrait("Sharku", 1)
            --
            char:addAncillary("uruk_raider")
            char:addAncillary("wolf_rider")
            char:addAncillary("uruk_captain")
            
            char.character.ability="URUK_HAI"
        end
    end
end

--eurSpawnCustomGeneral(eur_player_faction.name, "Tauriel", "Tauriel_test", "Tauriel", true, 30, 'Woodland Wardens', eur_player_faction.capital.xCoord, eur_player_faction.capital.yCoord, 2, 0, 0, "tauriel", "tauriel")