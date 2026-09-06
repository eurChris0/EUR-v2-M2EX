::EUR.EOP_WAVS <- {}
::EUR.wavs <- []   // e.g. "uicah_menuclick1" - none active yet

::EUR.loadSounds <- function() {
    ::EUR.logHelper("loadSounds")
    foreach (name in ::EUR.wavs) {
        if (name != null && !(name in ::EUR.EOP_WAVS)) {
            ::EUR.EOP_WAVS[name] <- ::sound.create(::game.modPath() + "/eopData/sounds/" + name + ".wav")
        }
    }
    ::EUR.logHelper("loadSounds end")
}
