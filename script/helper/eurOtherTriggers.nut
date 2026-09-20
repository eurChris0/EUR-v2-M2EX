if (::EUR.EUR_EVENT_TRIGGERS.other) {

    ::events.on("loadingFonts", function() {
        if (::EUR.to_log) { println("EUR SCRIPT: " + "onLoadingFonts") }
        ::EUR.loadFonts()
    })

}

if (::EUR.EUR_EVENT_TRIGGERS.other) {

    ::events.on("createSaveFile", function(files) {
        ::EUR.eurSaveLoadValues(true)
        return []
    })

    ::events.on("loadSaveFile", function(files) {
        ::EUR.eurSaveLoadValues(false)
    })

}
