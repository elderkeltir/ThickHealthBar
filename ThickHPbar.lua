-- Main frame
local MainFrame = CreateFrame("Frame")

-- Settings frame
local SettingsFrame = CreateFrame("Frame", nil, UIParent)
SettingsFrame.name = "ThickHPbar"
InterfaceOptions_AddCategory(SettingsFrame)
local settings_loaded = false

-- settings boxes names
local SettingsBoxesNames = {
     ["HealthbarHeight"] = "Healthbar Height: ",
     ["HealthTextRightX"] = "Health Text Right X: ",
     ["HealthTextRightY"] = "Health Text Right Y: ",
     ["HealthTextLeftX"] = "Health Text Left X: ",
     ["HealthTextLeftY"] = "Health Text Left Y: ",
     ["HealthTextX"] = "Health Text Middle X: ",
     ["HealthTextY"] = "Health Text Middle Y: ",
}

local PlayerFrames = {
     ["normal"] = "Interface\\Addons\\ThickHPbar\\Textures\\UI-TargetingFrame",
     ["rare"] = "Interface\\Addons\\ThickHPbar\\Textures\\UI-TargetingFrame-Rare",
     ["elite"] = "Interface\\Addons\\ThickHPbar\\Textures\\UI-TargetingFrame-Elite",
     ["rare_elite"] = "Interface\\Addons\\ThickHPbar\\Textures\\UI-TargetingFrame-Rare-Elite",
}

local SettingsDropDownValues = {
     [PlayerFrames["normal"]] = "Normal",
     [PlayerFrames["rare"]] = "Rare",
     [PlayerFrames["elite"]] = "Elite",
     [PlayerFrames["rare_elite"]] = "Rare Elite",
}

-- settings callbacks
function SetHealthBarHeight(value)
     PlayerFrameHealthBar:SetHeight(value);
end

function SetHealthTextRightX(x)
     PlayerFrameHealthBarTextRight:SetPoint("RIGHT", x, SettingsFrame.sliders["HealthTextRightY"]:GetValue())
end

function SetHealthTextRightY(y)
     PlayerFrameHealthBarTextRight:SetPoint("RIGHT", SettingsFrame.sliders["HealthTextRightX"]:GetValue(), y)
end

function SetHealthTextLeftX(x)
     PlayerFrameHealthBarTextLeft:SetPoint("LEFT", x, SettingsFrame.sliders["HealthTextLeftY"]:GetValue())
end

function SetHealthTextLeftY(y)
     PlayerFrameHealthBarTextLeft:SetPoint("LEFT", SettingsFrame.sliders["HealthTextLeftX"]:GetValue(), y)
end

function SetHealthTextX(x)
     PlayerFrameHealthBarText:SetPoint("CENTER", x, SettingsFrame.sliders["HealthTextY"]:GetValue())
end

function SetHealthTextY(y)
     PlayerFrameHealthBarText:SetPoint("CENTER", SettingsFrame.sliders["HealthTextX"]:GetValue(), y)
end

function SetPlayerFrame(val)
     PlayerFrameTexture:SetTexture(val)
end

local SettingsCallbacks = {
     ["HealthbarHeight"] = SetHealthBarHeight,
     ["HealthTextRightX"] = SetHealthTextRightX,
     ["HealthTextRightY"] = SetHealthTextRightY,
     ["HealthTextLeftX"] = SetHealthTextLeftX,
     ["HealthTextLeftY"] = SetHealthTextLeftY,
     ["HealthTextX"] = SetHealthTextX,
     ["HealthTextY"] = SetHealthTextY,
     ["PlayerFrame"] = SetPlayerFrame
}

MainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MainFrame:RegisterEvent("ADDON_LOADED");
MainFrame:RegisterEvent("PLAYER_LOGOUT");
MainFrame:RegisterEvent("PLAYER_LOGIN");
MainFrame:SetScript("OnEvent", function(self, event)
     if (event == "PLAYER_ENTERING_WORLD") then
          Apply()

     elseif (event == "ADDON_LOADED") then
          SetUp()

     elseif (event == "PLAYER_LOGIN") then
          InitializeSettingsUI(SettingsFrame)
     end
end)

function Apply()
     SetPlayerFrame(ThickHPbarData["PlayerFrame"])
     SetHealthBarHeight(ThickHPbarData["HealthbarHeight"])
     SetHealthTextRight(ThickHPbarData["HealthTextRightX"], ThickHPbarData["HealthTextRightY"])
     SetHealthTextLeft(ThickHPbarData["HealthTextLeftX"], ThickHPbarData["HealthTextLeftY"])
     SetHealthText(ThickHPbarData["HealthTextX"], ThickHPbarData["HealthTextY"])
     PlayerFrameManaBarTextRight:SetAlpha(0)
     PlayerFrameManaBarTextLeft:SetAlpha(0)
     PlayerFrameManaBarText:SetAlpha(0)
     PlayerFrameManaBar:SetAlpha(0)

end

function SetUp()
     if not settings_loaded then 
          if not ThickHPbarData then
               ThickHPbarData = {}
          end

          if not ThickHPbarData["HealthbarHeight"] then 
               ThickHPbarData["HealthbarHeight"] = 25
          end

          if not ThickHPbarData["HealthTextRightX"] then 
               ThickHPbarData["HealthTextRightX"] = -5
          end

          if not ThickHPbarData["HealthTextRightY"] then 
               ThickHPbarData["HealthTextRightY"] = -2
          end

          if not ThickHPbarData["HealthTextLeftX"] then 
               ThickHPbarData["HealthTextLeftX"] = 110
          end

          if not ThickHPbarData["HealthTextLeftY"] then 
               ThickHPbarData["HealthTextLeftY"] = -2
          end

          if not ThickHPbarData["HealthTextX"] then 
               ThickHPbarData["HealthTextX"] = 50
          end

          if not ThickHPbarData["HealthTextY"] then 
               ThickHPbarData["HealthTextY"] = -2
          end

          if not ThickHPbarData["PlayerFrame"] then 
               ThickHPbarData["PlayerFrame"] = PlayerFrames["normal"]
          end

          settings_loaded = true
     end
end

function EditBoxSetText(editbox, text)
     editbox:SetText(text)
     editbox:SetCursorPosition(0)
end

function SetHealthTextRight(x, y)
     PlayerFrameHealthBarTextRight:SetPoint("RIGHT", x, y)
end

function SetHealthTextLeft(x, y)
     PlayerFrameHealthBarTextLeft:SetPoint("LEFT", x, y)
end

function SetHealthText(x, y)
     PlayerFrameHealthBarText:SetPoint("CENTER", x, y)
end

function CreateSettingsBlock(settingsFrame, name, sliderMinVal, sliderMaxval)
     local slider = CreateSlider(settingsFrame, name, sliderMinVal, sliderMaxval)
     local editbox = CreateEditbox(settingsFrame, name, slider)

     settingsFrame.sliders[name] = slider
     settingsFrame.editboxes[name] = editbox
end

function CreateSlider(settingsFrame, name, minVal, maxVal)
     local slider = CreateFrame("Slider", name, settingsFrame, "OptionsSliderTemplate")
     slider:SetWidth(144)
     slider:SetHeight(17)
     slider:SetOrientation("HORIZONTAL")
     slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
     slider:SetMinMaxValues(minVal, maxVal)
     slider:SetValueStep(1)
     slider:SetObeyStepOnDrag(true)
     slider:SetValue(ThickHPbarData[name])
     getglobal(slider:GetName() .. 'Low'):SetText(tostring(minVal))
     getglobal(slider:GetName() .. 'High'):SetText(tostring(maxVal))
     getglobal(slider:GetName() .. 'Text'):SetText(SettingsBoxesNames[name]..ThickHPbarData[name])
     slider:SetScript("OnValueChanged", function(self, newValue)
          SettingsCallbacks[name](newValue)
          getglobal(slider:GetName() .. 'Text'):SetText(SettingsBoxesNames[name]..tostring(newValue))
          EditBoxSetText(self:GetParent().editboxes[name], newValue)
     end)

     return slider
end

function CreateEditbox(settingsFrame, name, slider)
     local editbox = CreateFrame("EditBox", name, settingsFrame)
     editbox:SetPoint("CENTER", slider, 0, -25)
     editbox:SetJustifyH("CENTER")
     editbox:SetJustifyV("CENTER")
     editbox:SetHeight(25)
     editbox:SetWidth(40)
     editbox:SetFontObject(GameFontHighlightSmall)
     editbox:SetTextInsets(2,2,2,2)
     editbox:SetMaxLetters(4)
     editbox:SetMultiLine(false)
     editbox:SetAutoFocus(false)
     EditBoxSetText(editbox, ThickHPbarData[name])
     editbox:SetBackdrop({
          bgFile = "Interface/Tooltips/UI-Tooltip-Background",
          edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
          edgeSize = 16,
          insets = { left = 4, right = 4, top = 4, bottom = 4 },
     })
     editbox:SetBackdropColor(0, 0, 0, .5)
     editbox:SetScript("OnEscapePressed", function()
          EditBoxSetText(editbox, editbox:GetParent().sliders[name]:GetValue())
          editbox:ClearFocus()
     end)
     editbox:SetScript("OnEnterPressed", function()
          editbox:GetParent().sliders[name]:SetValue(editbox:GetNumber())
          EditBoxSetText(editbox, editbox:GetParent().sliders[name]:GetValue())
          editbox:ClearFocus()
     end)

     return editbox
end

function CreateDropDown(settingsFrame)
     local dropDown = CreateFrame("FRAME", "WPDemoDropDown", settingsFrame, "UIDropDownMenuTemplate")
     UIDropDownMenu_SetWidth(dropDown, 100)
     UIDropDownMenu_SetText(dropDown, SettingsDropDownValues[ThickHPbarData["PlayerFrame"]])

     UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
          local info = UIDropDownMenu_CreateInfo()
          info.text = "Normal"
          info.checked = false
          info.value = PlayerFrames["normal"]
          info.arg1 = "Normal"
          info.arg2 = PlayerFrames["normal"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHPbarData["PlayerFrame"]] == PlayerFrames["normal"]
          UIDropDownMenu_AddButton(info)

          info.text = "Elite"
          info.checked = false
          info.value = PlayerFrames["elite"]
          info.arg1 = "Elite"
          info.arg2 = PlayerFrames["elite"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHPbarData["PlayerFrame"]] == PlayerFrames["elite"]
          UIDropDownMenu_AddButton(info)

          info.text = "Rare"
          info.checked = false
          info.value = PlayerFrames["rare"]
          info.arg1 = "Rare"
          info.arg2 = PlayerFrames["rare"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHPbarData["PlayerFrame"]] == PlayerFrames["rare"]
          UIDropDownMenu_AddButton(info)

          info.text = "Rare Elite"
          info.checked = false
          info.value = PlayerFrames["rare_elite"]
          info.arg1 = "Rare Elite"
          info.arg2 = PlayerFrames["rare_elite"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHPbarData["PlayerFrame"]] == PlayerFrames["rare_elite"]
          UIDropDownMenu_AddButton(info)
     end)

     function dropDown:SetValue(newName, newValue)
          ThickHPbarData["PlayerFrame"] = newValue
          UIDropDownMenu_SetText(dropDown,  newName)
          SetPlayerFrame(newValue)
          CloseDropDownMenus()
     end

     settingsFrame.dropDown = dropDown
end

function InitializeSettingsUI(settingsFrame)
     -- events on buttons clicked
     settingsFrame.okay = SettingsOk
     settingsFrame.cancel = SettingsCancel

     -- create settings blocks
     settingsFrame.sliders = {}
     settingsFrame.editboxes = {}

     local title = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
     title:SetText("ThickHPbar Settings")
     title:SetPoint("TOPLEFT", settingsFrame, 60, -20)
     
     CreateSettingsBlock(settingsFrame, "HealthbarHeight", 1, 100)
     settingsFrame.sliders["HealthbarHeight"]:SetPoint("TOPLEFT", title, -30, -40)

     CreateSettingsBlock(settingsFrame, "HealthTextRightX", -250, 250)
     settingsFrame.sliders["HealthTextRightX"]:SetPoint("CENTER", settingsFrame.editboxes["HealthbarHeight"], 0, -50)

     CreateSettingsBlock(settingsFrame, "HealthTextRightY", -25, 25)
     settingsFrame.sliders["HealthTextRightY"]:SetPoint("CENTER", settingsFrame.editboxes["HealthTextRightX"], 200, 25)

     CreateSettingsBlock(settingsFrame, "HealthTextLeftX", -250, 250)
     settingsFrame.sliders["HealthTextLeftX"]:SetPoint("CENTER", settingsFrame.editboxes["HealthTextRightX"], 0, -50)

     CreateSettingsBlock(settingsFrame, "HealthTextLeftY", -25, 25)
     settingsFrame.sliders["HealthTextLeftY"]:SetPoint("CENTER", settingsFrame.editboxes["HealthTextLeftX"], 200, 25)

     CreateSettingsBlock(settingsFrame, "HealthTextX", -250, 250)
     settingsFrame.sliders["HealthTextX"]:SetPoint("CENTER", settingsFrame.editboxes["HealthTextLeftX"], 0, -50)

     CreateSettingsBlock(settingsFrame, "HealthTextY", -25, 25)
     settingsFrame.sliders["HealthTextY"]:SetPoint("CENTER", settingsFrame.editboxes["HealthTextX"], 150, 25)

     CreateDropDown(settingsFrame)
     settingsFrame.dropDown:SetPoint("CENTER", settingsFrame.sliders["HealthbarHeight"], 200, 0)
end

function SettingsOk(settingsFrame)
     ThickHPbarData["HealthbarHeight"] = settingsFrame.sliders["HealthbarHeight"]:GetValue()
     ThickHPbarData["HealthTextRightX"] = settingsFrame.sliders["HealthTextRightX"]:GetValue()
     ThickHPbarData["HealthTextRightY"] = settingsFrame.sliders["HealthTextRightY"]:GetValue()
     ThickHPbarData["HealthTextLeftX"] = settingsFrame.sliders["HealthTextLeftX"]:GetValue()
     ThickHPbarData["HealthTextLeftY"] = settingsFrame.sliders["HealthTextLeftY"]:GetValue()
     ThickHPbarData["HealthTextX"] = settingsFrame.sliders["HealthTextX"]:GetValue()
     ThickHPbarData["HealthTextY"] = settingsFrame.sliders["HealthTextY"]:GetValue()
end

function SettingsCancel(settingsFrame)
     EditBoxSetText(settingsFrame.editboxes["HealthbarHeight"], ThickHPbarData["HealthbarHeight"])
     settingsFrame.sliders["HealthbarHeight"]:SetValue(ThickHPbarData["HealthbarHeight"])
     
     EditBoxSetText(settingsFrame.editboxes["HealthTextRightX"], ThickHPbarData["HealthTextRightX"])
     settingsFrame.sliders["HealthTextRightX"]:SetValue(ThickHPbarData["HealthTextRightX"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextRightY"], ThickHPbarData["HealthTextRightY"])
     settingsFrame.sliders["HealthTextRightY"]:SetValue(ThickHPbarData["HealthTextRightY"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextLeftX"], ThickHPbarData["HealthTextLeftX"])
     settingsFrame.sliders["HealthTextLeftX"]:SetValue(ThickHPbarData["HealthTextLeftX"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextLeftY"], ThickHPbarData["HealthTextLeftY"])
     settingsFrame.sliders["HealthTextLeftY"]:SetValue(ThickHPbarData["HealthTextLeftY"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextX"], ThickHPbarData["HealthTextX"])
     settingsFrame.sliders["HealthTextX"]:SetValue(ThickHPbarData["HealthTextX"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextY"], ThickHPbarData["HealthTextY"])
     settingsFrame.sliders["HealthTextY"]:SetValue(ThickHPbarData["HealthTextY"])
end