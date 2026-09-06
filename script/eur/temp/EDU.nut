local format = require("string").format

// join an array of values into a ", "-separated string
::EUR.tableToCSVString <- function(dataTable) {
    local out = ""
    foreach (i, value in dataTable) { out += (i == 0 ? "" : ", ") + value }
    return out
}

class EduModifiers {
    moveSpeedText        = "\n• Movement Speed: "
    freeUpkeepText       = "\n• Free Upkeep"
    generalsUnitText     = "\n• General's Bodyguard"
    relentlessText       = "\n• Relentless"
    rangeText            = "\n• Range: "
    ammoText             = "\n• Missiles: "
    slaveUnitText        = "\n• Slave Unit"
    bpRangeText          = "\n• Body Piercing Missiles"
    apRangeText          = "\n• Armour Piercing Missiles"
    gunpowderText        = "\n• Gunpowder Unit"
    apSecText            = "\n• Armour Piercing Secondary"
    shieldPiercingText   = "\n• Shield Piercing Missiles"
    secAttText           = "\n• Secondary Attack: "
    lockMoraleText       = "\n• Morale: Unbreakable"
    moraleResText        = "\n• Morale Response: "
    poisonArrowText      = "\n• Poison Arrows"
    fireArrowText        = "\n• Fire Arrows"
    deadlyPoisonArrowText = "\n• Deadly Poison Arrows"
    silverthornArrowText = "\n• Silverthorn Arrows"
    splitshotArrowText   = "\n• Splitshot Arrows"
    moraleText           = "\n• Morale: "
    accuracyText         = "\n• Accuracy: "
    trainingText         = "\n• Training: "
    wargText             = "\n• Bonus damage vs. cavalry"
    thrownText           = "\n• Bonus damage vs. creatures and chariots"
    effectText           = ""

    terrain = {
        bonusText = "\n• Terrain Bonus: ",
        malusText = "\n• Terrain Malus: ",
        scrubText = "Shrubs",
        sandText = "Barren",
        forestText = "Forest",
        snowText = "Snow",
    }
    moraleResponse = [
        { text = "Average",   discipline = 1 },
        { text = "High",      discipline = 2 },
        { text = "Very High", discipline = 3 },
        { text = "Excellent", discipline = 4 },
    ]
    accuracy = [
        { text = "Abysmal",     min = 0.080, max = 1.0 },
        { text = "Low",         min = 0.070, max = 0.080 },
        { text = "Average",     min = 0.055, max = 0.070 },
        { text = "High",        min = 0.045, max = 0.055 },
        { text = "Very High",   min = 0.025, max = 0.045 },
        { text = "Exceptional", min = 0.015, max = 0.025 },
        { text = "Legendary",   min = 0.0,   max = 0.015 },
    ]
    morale = [
        { text = "Abysmal",    min = 0,  max = 5 },
        { text = "Poor",       min = 6,  max = 7 },
        { text = "Average",    min = 8,  max = 9 },
        { text = "Fair",       min = 10, max = 11 },
        { text = "Good",       min = 12, max = 13 },
        { text = "Very Good",  min = 14, max = 15 },
        { text = "Excellent",  min = 16, max = 17 },
        { text = "Unwavering", min = 18, max = 64 },
    ]
    relentlessAnims = [
        "MTW2_Mace_no_stun", "MTW2_Giant_no_stun", "DaC_Nazg-hai_no_knock",
        "DaC_Nazg-hai_no_def_no_knock", "MTW2_Dwarf_2H_Axe_relentless", "MTW2_Dwarf_Mace_relentless",
    ]
    wargMounts = ["mount_light_wolf", "mount_light_wolf_goblin", "indep_warg", "warg_camel"]

    function isRanged(entry) {
        return (entry.hasProjectile(0) || entry.hasProjectile(1)
             || entry.hasProjectile(3) || entry.hasProjectile(4)) ? true : false
    }

    function applyRangedModifiers(entry) {
        // attackStats.isValid has no house row (AttackField::IsValid is unbound), so the
        // whole non-engine arrow-type / accuracy block below cannot be gated - left off.
        // if (!entry.engineStats.isValid) {
        //     local projectile = entry.primaryStats.projectile || entry.secondaryStats.projectile || entry.mountStats.projectile
        //     local name = projectile.name
        //     if (name.indexof("poison") != null) {
        //         this.effectText += (name.indexof("deadly") != null) ? this.deadlyPoisonArrowText : this.poisonArrowText
        //     } else if (name.indexof("rhun_elite_arrow") != null) {
        //         this.effectText += this.fireArrowText
        //     } else if (name.indexof("silverthorn") != null) {
        //         this.effectText += this.silverthornArrowText
        //     } else if (name.indexof("gurveleg") != null) {
        //         this.effectText += this.splitshotArrowText
        //     }
        //     local unitAccuracy = projectile.accuracy
        //     foreach (tier in this.accuracy) {
        //         if (unitAccuracy >= tier.min && unitAccuracy <= tier.max) {
        //             this.effectText += this.accuracyText + tier.text
        //             break
        //         }
        //     }
        // }

        if ((entry.isArmourPiercing(0) && entry.hasProjectile(0))
            || (entry.isArmourPiercing(1) && entry.hasProjectile(1)) || entry.isArmourPiercing(3)) {
            this.effectText += this.apRangeText
        }
        // attackStats.isBP has no house row (AttackField::IsBP is unbound; projectileBodyPiercing
        // is a different bit on the descr_projectile record, not a substitute).
        // if ((entry.primaryStats.isBP && entry.primaryStats.projectile)
        //     || (entry.secondaryStats.isBP && entry.secondaryStats.projectile) || entry.engineStats.isBP) {
        //     this.effectText += this.bpRangeText
        // }

        if (entry.range(3) > 1)        { this.effectText += this.rangeText + entry.range(3) }
        else if (entry.range(0) > 1)   { this.effectText += this.rangeText + entry.range(0) }
        else if (entry.range(1) > 1)   { this.effectText += this.rangeText + entry.range(1) }
        else if (entry.range(4) > 1)   { this.effectText += this.rangeText + entry.range(4) }

        if (entry.ammo(3) > 1)         { this.effectText += this.ammoText + entry.ammo(3) }
        else if (entry.ammo(0) > 1)    { this.effectText += this.ammoText + entry.ammo(0) }
        else if (entry.ammo(4) > 1)    { this.effectText += this.ammoText + entry.ammo(4) }
    }

    function applyMoraleModifiers(entry) {
        // eduEntry.moraleLocked has no house row (UnitField::MoraleLocked is unbound).
        // if (entry.moraleLocked) {
        //     this.effectText += this.lockMoraleText
        //     return
        // }
        if (entry.morale) {
            foreach (tier in this.morale) {
                if (entry.morale >= tier.min && entry.morale <= tier.max) {
                    this.effectText += this.moraleText + tier.text + " (" + entry.morale + ")"
                    break
                }
            }
        }
        if (entry.discipline) {
            foreach (tier in this.moraleResponse) {
                if (entry.discipline == tier.discipline) {
                    this.effectText += this.moraleResText + tier.text
                    break
                }
            }
        }
    }

    function applyTerrainModifiers(entry) {
        local bonusTerrain = []
        local malusTerrain = []
        local check = function(value, label) {
            if (value > 0)      { bonusTerrain.append(label + " (+" + value + ")") }
            else if (value < 0) { malusTerrain.append(label + " (" + value + ")") }
        }
        check(entry.scrubModifier, this.terrain.scrubText)
        check(entry.sandModifier, this.terrain.sandText)
        check(entry.forestModifier, this.terrain.forestText)
        check(entry.snowModifier, this.terrain.snowText)

        if (bonusTerrain.len() > 0) { this.effectText += this.terrain.bonusText + ::EUR.tableToCSVString(bonusTerrain) }
        if (malusTerrain.len() > 0) { this.effectText += this.terrain.malusText + ::EUR.tableToCSVString(malusTerrain) }
    }

    function addEffects(entry) {
        if (!entry) return
        this.effectText = ""
        local flavourText = entry.description
        entry.description = ""

        if (entry.generalUnit || entry.hasAttribute("general_unit") || entry.hasAttribute("bodyguard_unit")) {
            this.effectText += this.generalsUnitText
        }
        if (::EUR.tableContains(this.relentlessAnims, entry.primaryAnim)
            || ::EUR.tableContains(this.relentlessAnims, entry.secondaryAnim)
            || entry.primaryAnim.tolower().indexof("relentless") != null
            || entry.secondaryAnim.tolower().indexof("relentless") != null) {
            this.effectText = this.relentlessText + this.effectText
        }
        if (entry.hasAttribute("slave_unit")) { this.effectText += this.slaveUnitText }
        if (entry.isArmourPiercing(1)) { this.effectText += this.apSecText }
        if (entry.freeUpkeep) { this.effectText += this.freeUpkeepText }
        if (entry.mount && entry.mount.name && ::EUR.tableContains(this.wargMounts, entry.mount.name)) {
            this.effectText += this.wargText
        }
        if (entry.moveSpeedModifier != 1) {
            this.effectText += this.moveSpeedText + format("%.0f%%", entry.moveSpeedModifier * 100)
        }

        if (this.isRanged(entry)) { this.applyRangedModifiers(entry) }
        this.applyMoraleModifiers(entry)
        this.applyTerrainModifiers(entry)

        this.effectText += "\n\n"
        entry.description = this.effectText + flavourText
        entry.description = entry.description.slice(1)   // drop the leading newline
    }

    function updateDescriptions() {
        if (::EUR.EDUDescSet) return
        for (local i = 0; i < 1500; i++) {
            local entry = ::units.at(i)
            if (entry != null) { this.addEffects(entry) }
        }
        // EOP script-key sweep: units.at is record-index only, so 4990..5020 never resolved the
        // custom bodyguard clones. They are reachable by name (units.get(eduType + "_" + eopId)).
        // for (local i = 4990; i <= 5020; i++) {
        //     local entry = ::units.at(i)
        //     if (entry != null) { this.addEffects(entry) }
        // }
        ::EUR.EDUDescSet = true
    }
}

::EUR.EDU_MODIFIERS <- EduModifiers()
