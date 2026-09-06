// walk a named character's trait linked-list looking for one by name.
::EUR.hasTrait <- function(namedCharacter, traitName) {
    local trait = namedCharacter.firstTrait()
    while (trait != null) {
        if (trait.name == traitName) return true
        trait = trait.next
    }
    return false
}

::EUR.startLog <- function(logFolder) {}

::EUR.log <- function(text, isTable = false) {
    println("" + text)
}
