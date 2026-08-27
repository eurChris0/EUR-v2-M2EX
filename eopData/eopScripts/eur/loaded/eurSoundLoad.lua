EOP_WAVS = {}

wavs = {
    --"uicah_menuclick1",
    --"uicah_menuclick2",
    --"uclicknofun",
    --"uclick_zoom",
}

function loadSounds()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."loadSounds");
	end
    for i = 1, #wavs do
        if wavs[i] ~= nil then
            if not EOP_WAVS[wavs[i]] then
                EOP_WAVS[wavs[i]] = M2TWEOPSounds.createEOPSound(M2TWEOP.getModPath().."/eopData/sounds/"..wavs[i]..".wav")
            end
        end
    end
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end