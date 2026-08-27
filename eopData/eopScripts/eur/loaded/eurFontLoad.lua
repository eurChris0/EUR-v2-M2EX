function loadFonts()
	if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."loadFonts");
	end
    font_0 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/RINGM___.TTF", 18, nil, nil)
    font_1 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/Merriweather-Regular.ttf", 18, nil, nil)
    font_2 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/merriweather.bold.ttf", 18, nil, nil)
    --font_3 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/markdownH1Font.ttf", 18, nil, nil)
    --font_4 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/MedievalSharp-xOZ5.ttf", 18, nil, nil)
    --font_5 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/Middleearth-ao6m.ttf", 18, nil, nil)
    --font_6 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/anirb___.ttf", 18, nil, nil)
    --font_7 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/anirm___.ttf", 18, nil, nil)
    --font_8 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/Magicmedieval-pRV1.ttf", 18, nil, nil)
    --font_9 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/markdownH2Font.ttf", 18, nil, nil)
    --font_10 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/WitcherKnight-vmLdA.ttf", 18, nil, nil)
    --font_11 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/ModernAntiqua-Zw5K.ttf.ttf", 18, nil, nil)
    --font_12 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/DevinneSwash-qZd5.ttf", 18, nil, nil)
    --font_13 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/Anironc-d9DK.ttf", 18, nil, nil)
    --font_14 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/Fleshandblood-MVA5x.ttf", 18, nil, nil)
    --font_15 = ImGui.GetIO().Fonts:AddFontFromFileTTF(M2TWEOP.getModPath().."/fonts/mainFont.ttf", 18, nil, nil)
    font_list_names = {"None", "Ringbearer", "Merriweather", "Verdana"}
    font_list = {nil, font_0, font_1, font_2}
    font_RINGM = font_1
    font_RINGMB = font_2
    if to_log then
		M2TWEOP.logGame("EUR SCRIPT: "..tostring(os.clock()).."Function End");
	end
end