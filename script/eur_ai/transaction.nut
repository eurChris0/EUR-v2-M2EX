let evaluator = require("eur_ai.ltgd_evaluator")
function capture(ltgd, targets) {
  let result = {}
  foreach (target in targets) {
    let native = ltgd.attitudeTowards(target.id)
    if (native == null || !native.valid) throw "Missing native attitude: " + target.name
    let values = {}
    foreach (field in evaluator.fields) values[field] <- native[field]
    result[target.name] <- { native, values }
  }
  return result
}
function write(rows, original) {
  foreach (name, values in rows) {
    let native = original[name].native
    if (!native.valid) throw "Attitude became invalid"
    foreach (field in evaluator.fields) {
      native[field] = values[field]
      if (native[field] != values[field]) throw "Attitude write refused: " + field
    }
  }
}
function apply(result, original, commit = null) {
  let names = original.keys()
  evaluator.validate(result, names)
  try {
    write(result.rows, original)
    if (commit != null) commit()
  }
  catch (error) {
    local restoreFailed = false
    foreach (_, row in original) foreach (field in evaluator.fields) {
      try {
        row.native[field] = row.values[field]
        if (row.native[field] != row.values[field]) restoreFailed = true
      } catch (_) { restoreFailed = true }
    }
    if (restoreFailed) throw "Attitude restoration failed after: " + error
    throw error
  }
}
return { capture, apply }
