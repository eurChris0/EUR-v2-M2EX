if (::EUR.EUR_EVENT_TRIGGERS.other) {

    ::events.on("loadingFonts", function() {
        if (::EUR.to_log) { println("EUR SCRIPT: " + "onLoadingFonts") }
        ::EUR.loadFonts()
    })

}

if (::EUR.EUR_EVENT_TRIGGERS.other) {

    // eurSaveLoadValues owns `persistent.eur` on both sides. The second copy that used to live here
    // was the SAME table under a second key: it doubled the payload in every save, and on load it
    // was overwritten by eurSaveLoadValues(false) before anything could read it.
    ::events.on("createSaveFile", function(files) {
        ::EUR.eurSaveLoadValues(true)
        return []
    })

    ::events.on("loadSaveFile", function(files) {
        ::EUR.eurSaveLoadValues(false)
    })

}
