if (::EUR.EUR_EVENT_TRIGGERS.other) {

    ::events.on("loadingFonts", function() {
        if (::EUR.to_log) { println("EUR SCRIPT: " + "onLoadingFonts") }
        ::EUR.loadFonts()
    })

}

if (::EUR.EUR_EVENT_TRIGGERS.other) {

    ::events.on("createSaveFile", function(files) {
        ::EUR.eurSaveLoadValues(true)
        ::persistent.eurEventsData <- ::EUR.eurEventsData
        return []
    })

    ::events.on("loadSaveFile", function(files) {
        if (!("eurEventsData" in ::persistent)) { return }
        ::EUR.eurEventsData = ::persistent.eurEventsData
        ::EUR.eurSaveLoadValues(false)
    })

}
