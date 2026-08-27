---@diagnostic disable: lowercase-global

-- Text Resources for EUR mod
-- Organized by feature/module for easy maintenance
EurTextResources = {
    -- Campaign Settings Window text resources
    CampaignSettings = {
        Window = {
            Title = "Campaign Settings",
            ConfirmationText = "Start campaign with these settings?",
            AcceptButton = "Accept Settings",
            YesButton = "Yes",
            NoButton = "No"
        },

        -- Merging Armies section
        MergingArmies = {
            Header = "Merging Armies",
            EnableLabel = "Enable armies merging",
            CooldownLabel = "Merge Cooldown",
            CooldownFormat = "%d turns",
            Description = "When enabled, allows AI armies to merge every %d turns."
        },

        -- Unit Replenishment section
        Replenishment = {
            Header = "Unit Replenishment",
            EnableLabel = "Enable unit replenishment",
            EnableAILabel = "Enable for AI factions",
            TerritoryLabel = "Only in own/allied territory",
            RateLabel = "Replenishment Rate",
            RateFormat = "%d%% of unit size (5%% is a recommended value)",
            Description =
            "Units will replenish %d%%%% of their maximum size per turn when in settlements/forts, and half that amount in the field."
        },

        -- Post-Battle Loot section
        PostBattleLoot = {
            Header = "Post-Battle Loot",
            EnableLabel = "Enable post-battle loot",
            UnitCostsLabel = "Calculate loot from unit costs",
            SmallArmyLabel = "Reduce loot for small armies (<11 units)",
            VictoryModifierLabel = "Apply victory type modifiers",
            BaseAmountLabel = "Base Loot Amount",
            BaseAmountFormat = "%d gold",
            Description = {
                UnitCosts = "Loot will be calculated based on the upkeep costs of defeated enemy units.",
                BaseAmount = "A base amount of %d gold will be awarded after victories.",
                SmallArmyPenalty = "Small armies will receive reduced loot based on their size.",
                VictoryModifier =
                "Loot amount will be modified based on the type of victory (Close/Average/Clear/Crushing)."
            }
        },

        -- Army Sorting section
        ArmySorting = {
            Header = "Army Sorting",
            EnableLabel = "Enable army sorting",
            TurnEndLabel = "Sort armies at turn end",
            SelectionLabel = "Sort when army is selected",
            Description = "Units will be sorted by Category, Class, and Experience."
        },

        -- Elven Passing section
        ElvenPassing = {
            Header = "Elven Passing",
            EnableLabel = "Enable Elven Passing",
            TimingLabel = "Use random timing between events",
            MinTurnsLabel = "Minimum Turns Between Events",
            MaxTurnsLabel = "Maximum Turns Between Events",
            FixedTurnsLabel = "Turns Between Events",
            TurnsFormat = "%d turns"
        }
    },

    -- Event text resources
    Events = {
        -- Post-battle loot events
        PostBattleLoot = {
            PositiveLoot = {
                Title = "Enemy Camp Sacked",
                Message =
                "Good tidings! Our men have found the enemy camp and claimed anything of worth. We should be able to make some coin out of this victory!\n\nGold taken: %d"
            },
            NegativeLoot = {
                Title = "Failed to Sack Enemy Camp",
                Message = "My Lord, our men have failed to find anything of worth in the enemy camp."
            }
        },

        -- Elven Passing events
        ElvenPassing = {
            UI = {
                WindowTitle = "The Great Passing",
                ButtonTooltip = "Elven Passing",
                ButtonText = "EP",
                CloseButton = "Close",
                Sections = {
                    Progress = "Progress",
                    MainEnemies = "Main Enemies:",
                    ProgressThresholds = {
                        Title = "Progress Thresholds:",
                        FirstEnemy = "- Cannot exceed 74%% until one main enemy is defeated",
                        BothEnemies = "- Cannot reach 100%% until both main enemies are defeated",
                        Completion = "- Reaching 100%% completes the event with special rewards"
                    },
                    WaysToGain = {
                        Title = "Ways to Gain Progress",
                        CoreSettlement = "+20: Recapture your core settlement",
                        EnemyCore = "+10: Capture enemy core settlement",
                        MinorVictories = "+5:  Win heroic victory or when main enemy faction is destroyed",
                        AverageVictory = "+3:  Win average victory against main enemy"
                    },
                    WaysToLose = {
                        Title = "Ways to Lose Progress",
                        CoreLoss = "-20: Lose core settlement or king dies",
                        MinorLoss = "-10: Lose minor settlement or suffer crushing defeat",
                        SmallLoss = "-5:  Lose battle, win with high losses, or 10 turns without battle"
                    },
                    StageEffects = {
                        PopulationLoss = "- Population loss: %d%%%%",
                        GoldPerElf = "- Gold taken per elf: %d"
                    }
                }
            },
            Stages = {
                {
                    Title = "The Great Passing - Critical",
                    Description =
                    "The yearning for the West has reached a critical point. Our people are leaving in great numbers, unable to resist the call of the sea."
                },
                {
                    Title = "The Great Passing - Strong",
                    Description =
                    "The call of the Undying Lands remains strong. Many of our kin look westward with longing eyes."
                },
                {
                    Title = "The Great Passing - Moderate",
                    Description = "The pull of the West is present, but our people find strength in their purpose here."
                },
                {
                    Title = "The Great Passing - Weakening",
                    Description =
                    "The desire to sail West has diminished. Most of our people have chosen to remain in Middle-earth."
                },
                {
                    Title = "The Great Passing - Resisted",
                    Description =
                    "Our people have found renewed purpose in Middle-earth. The call of the West holds little sway over us now."
                }
            },
            Effects = {
                PopulationLoss = "Total population loss: %d",
                WealthLoss = "Total gold taken by departing elves: %d",
                Defeat = {
                    Title = "The Last Ship Departs",
                    Description =
                    "The last rays of the setting sun paint the harbor in gold, as the final white ship slips silently into the West. The great halls of our realm now stand empty, their echoing corridors a testament to what once was. The time of the Elves in Middle-earth has come to an end.\n\nThe last of our people have answered the call of the sea, leaving these shores to fade into legend and song.",
                    AcceptButton = "Accept Our Fate"
                },
                Rewards = {
                    Header = "The Great Passing - Event Completed",
                    Description =
                    "The call of the West has been resisted. Our people have found renewed purpose in Middle-earth, and the exodus has been halted. Our king's purse has been increased by 1,500 gold as a reward for this great achievement.\n\nWith our people's commitment to remain in Middle-earth secured, we can now invest in greater infrastructure. Your settlements may now construct Highways, Docklands, and Merchants' Quarters."
                },
                StageTransitions = {
                    Worsening = {
                        Title = "The Call Grows Stronger",
                        ToStrong =
                        "The yearning for the West intensifies. More of our kin turn their gaze towards the Grey Havens, their hearts heavy with longing.",
                        ToCritical =
                        "A great wave of melancholy sweeps through our realm. The call of the sea has become almost unbearable for many.",
                        ToModerate = "Doubt creeps back into our hearts. The whispers of the sea grow louder once more."
                    },
                    Improving = {
                        Title = "Hope Returns",
                        FromCritical =
                        "The overwhelming despair subsides. Though the call remains strong, we find strength to resist it.",
                        ToModerate =
                        "The shadow of departure begins to lift. Our people find new purpose in defending these shores.",
                        ToWeakening =
                        "Victory strengthens our resolve. The call of the West, while still present, no longer holds such sway over our hearts."
                    }
                }
            }
        }
    },

    -- Common text strings that are used across multiple features
    Common = {
        -- Common text resources can be added here
    }
}

-- Return the module
return EurTextResources
