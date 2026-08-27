function setGameOptions()

    if game_options.auto_saves_enabled then
        M2TWEOP.getOptions2().toggleAutoSave = 1
    else
        M2TWEOP.getOptions2().toggleAutoSave = 0
    end
    

end