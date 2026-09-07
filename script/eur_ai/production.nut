let strategy = require("eur_ai.strategy")
// These are UNIT_PRODUCTION_CATEGORY, NOT Enum.UnitCategory (EDU categories).
let categories = { infantry = 0, cavalry = 1, missile = 2, spearmen = 3, siege = 4 }
let capabilities = ["incomeBonus", "taxableIncomeBonus", "farmingLevel", "mineResource",
  "tradeLevelBonus", "freeUpkeep", "recruitmentSlots", "wallLevel"]
function read(controller, enums) {
  let baseline = { build = {}, recruit = {}, infrastructure = {} }
  foreach (name in capabilities) {
    let id = enums?[name]
    if (typeof id != "integer") throw "Missing building capability: " + name
    baseline.build[name] <- controller.buildBias(id)
  }
  foreach (name, id in categories) {
    baseline.recruit[name] <- controller.recruitBias(id)
    baseline.infrastructure[name] <- controller.buildForUnitBias(id)
  }
  foreach (group in baseline) foreach (value in group)
    if (typeof value != "integer") throw "Missing native production priority"
  return baseline
}
function adjust(baseline, context, expanding) {
  let result = { build = clone baseline.build, recruit = clone baseline.recruit, infrastructure = clone baseline.infrastructure }
  // Native persona values are the baseline on EVERY hook. No cached or saved bias.
  // Bounded additive changes also work when a persona's native value is zero.
  if (context.pressured) {
    foreach (name in ["infantry", "missile", "spearmen"])
      result.recruit[name] += context.stressed ? 10 : 20
    result.build.wallLevel += 10
  }
  if (context.stressed) {
    foreach (name in ["incomeBonus", "taxableIncomeBonus", "farmingLevel", "mineResource", "tradeLevelBonus", "freeUpkeep"])
      result.build[name] += 20
  } else if (expanding && context.sustainable && !context.pressured) {
    result.build.recruitmentSlots += 10
    foreach (name, _ in categories) result.infrastructure[name] += 10
  }
  foreach (groupName, group in result) foreach (name, value in group) {
    // Preserve very high native priorities; bound our delta rather than the persona.
    if (value < -2000000000 || value > 2000000000 || value - baseline[groupName][name] > 20)
      throw "Unsafe production adjustment"
  }
  return result
}
function write(controller, enums, values) {
  foreach (name, value in values.build)
    if (!controller.setBuildBias(enums[name], value)) throw "Construction priority refused"
  foreach (name, value in values.recruit)
    if (!controller.setRecruitBias(categories[name], value)) throw "Recruit priority refused"
  foreach (name, value in values.infrastructure)
    if (!controller.setBuildForUnitBias(categories[name], value)) throw "Recruitment infrastructure refused"
}
function apply(controller, enums, result, original) {
  try { write(controller, enums, result) }
  catch (error) {
    local failed = false
    // Try every original value even if one engine reference/slot stays invalid.
    foreach (name, value in original.build) {
      try { if (!controller.setBuildBias(enums[name], value)) failed = true }
      catch (_) { failed = true }
    }
    foreach (name, value in original.recruit) {
      try { if (!controller.setRecruitBias(categories[name], value)) failed = true }
      catch (_) { failed = true }
    }
    foreach (name, value in original.infrastructure) {
      try { if (!controller.setBuildForUnitBias(categories[name], value)) failed = true }
      catch (_) { failed = true }
    }
    if (failed) throw "Production restoration failed after: " + error
    throw error
  }
}
return { read, adjust, apply, categories, capabilities }
