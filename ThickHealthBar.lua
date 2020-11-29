-- Main frame
local MainFrame = CreateFrame("Frame")

-- Settings frame
local SettingsFrame = CreateFrame("Frame", nil, UIParent)
SettingsFrame.name = "ThickHealthBar"
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
     ["normal"] = "Interface\\Addons\\ThickHealthBar\\Textures\\UI-TargetingFrame",
     ["rare"] = "Interface\\Addons\\ThickHealthBar\\Textures\\UI-TargetingFrame-Rare",
     ["elite"] = "Interface\\Addons\\ThickHealthBar\\Textures\\UI-TargetingFrame-Elite",
     ["rare_elite"] = "Interface\\Addons\\ThickHealthBar\\Textures\\UI-TargetingFrame-Rare-Elite",
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
     SetPlayerFrame(ThickHealthBarData["PlayerFrame"])
     SetHealthBarHeight(ThickHealthBarData["HealthbarHeight"])
     SetHealthTextRight(ThickHealthBarData["HealthTextRightX"], ThickHealthBarData["HealthTextRightY"])
     SetHealthTextLeft(ThickHealthBarData["HealthTextLeftX"], ThickHealthBarData["HealthTextLeftY"])
     SetHealthText(ThickHealthBarData["HealthTextX"], ThickHealthBarData["HealthTextY"])
     PlayerFrameManaBarTextRight:SetAlpha(0)
     PlayerFrameManaBarTextLeft:SetAlpha(0)
     PlayerFrameManaBarText:SetAlpha(0)
     PlayerFrameManaBar:SetAlpha(0)

end

function SetUp()
     if not settings_loaded then 
          if not ThickHealthBarData then
               ThickHealthBarData = {}
          end

          if not ThickHealthBarData["HealthbarHeight"] then 
               ThickHealthBarData["HealthbarHeight"] = 25
          end

          if not ThickHealthBarData["HealthTextRightX"] then 
               ThickHealthBarData["HealthTextRightX"] = -5
          end

          if not ThickHealthBarData["HealthTextRightY"] then 
               ThickHealthBarData["HealthTextRightY"] = -2
          end

          if not ThickHealthBarData["HealthTextLeftX"] then 
               ThickHealthBarData["HealthTextLeftX"] = 110
          end

          if not ThickHealthBarData["HealthTextLeftY"] then 
               ThickHealthBarData["HealthTextLeftY"] = -2
          end

          if not ThickHealthBarData["HealthTextX"] then 
               ThickHealthBarData["HealthTextX"] = 50
          end

          if not ThickHealthBarData["HealthTextY"] then 
               ThickHealthBarData["HealthTextY"] = -2
          end

          if not ThickHealthBarData["PlayerFrame"] then 
               ThickHealthBarData["PlayerFrame"] = PlayerFrames["normal"]
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
     slider:SetValue(ThickHealthBarData[name])
     getglobal(slider:GetName() .. 'Low'):SetText(tostring(minVal))
     getglobal(slider:GetName() .. 'High'):SetText(tostring(maxVal))
     getglobal(slider:GetName() .. 'Text'):SetText(SettingsBoxesNames[name]..ThickHealthBarData[name])
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
     EditBoxSetText(editbox, ThickHealthBarData[name])
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
     UIDropDownMenu_SetText(dropDown, SettingsDropDownValues[ThickHealthBarData["PlayerFrame"]])

     UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
          local info = UIDropDownMenu_CreateInfo()
          info.text = "Normal"
          info.checked = false
          info.value = PlayerFrames["normal"]
          info.arg1 = "Normal"
          info.arg2 = PlayerFrames["normal"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHealthBarData["PlayerFrame"]] == PlayerFrames["normal"]
          UIDropDownMenu_AddButton(info)

          info.text = "Elite"
          info.checked = false
          info.value = PlayerFrames["elite"]
          info.arg1 = "Elite"
          info.arg2 = PlayerFrames["elite"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHealthBarData["PlayerFrame"]] == PlayerFrames["elite"]
          UIDropDownMenu_AddButton(info)

          info.text = "Rare"
          info.checked = false
          info.value = PlayerFrames["rare"]
          info.arg1 = "Rare"
          info.arg2 = PlayerFrames["rare"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHealthBarData["PlayerFrame"]] == PlayerFrames["rare"]
          UIDropDownMenu_AddButton(info)

          info.text = "Rare Elite"
          info.checked = false
          info.value = PlayerFrames["rare_elite"]
          info.arg1 = "Rare Elite"
          info.arg2 = PlayerFrames["rare_elite"]
          info.func = self.SetValue
          info.checked = SettingsDropDownValues[ThickHealthBarData["PlayerFrame"]] == PlayerFrames["rare_elite"]
          UIDropDownMenu_AddButton(info)
     end)

     function dropDown:SetValue(newName, newValue)
          ThickHealthBarData["PlayerFrame"] = newValue
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
     title:SetText("ThickHealthBar Settings")
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
     settingsFrame.sliders["HealthTextY"]:SetPoint("CENTER", settingsFrame.editboxes["HealthTextX"], 200, 25)

     CreateDropDown(settingsFrame)
     settingsFrame.dropDown:SetPoint("CENTER", settingsFrame.sliders["HealthbarHeight"], 200, 0)
end

function SettingsOk(settingsFrame)
     ThickHealthBarData["HealthbarHeight"] = settingsFrame.sliders["HealthbarHeight"]:GetValue()
     ThickHealthBarData["HealthTextRightX"] = settingsFrame.sliders["HealthTextRightX"]:GetValue()
     ThickHealthBarData["HealthTextRightY"] = settingsFrame.sliders["HealthTextRightY"]:GetValue()
     ThickHealthBarData["HealthTextLeftX"] = settingsFrame.sliders["HealthTextLeftX"]:GetValue()
     ThickHealthBarData["HealthTextLeftY"] = settingsFrame.sliders["HealthTextLeftY"]:GetValue()
     ThickHealthBarData["HealthTextX"] = settingsFrame.sliders["HealthTextX"]:GetValue()
     ThickHealthBarData["HealthTextY"] = settingsFrame.sliders["HealthTextY"]:GetValue()
end

function SettingsCancel(settingsFrame)
     EditBoxSetText(settingsFrame.editboxes["HealthbarHeight"], ThickHealthBarData["HealthbarHeight"])
     settingsFrame.sliders["HealthbarHeight"]:SetValue(ThickHealthBarData["HealthbarHeight"])
     
     EditBoxSetText(settingsFrame.editboxes["HealthTextRightX"], ThickHealthBarData["HealthTextRightX"])
     settingsFrame.sliders["HealthTextRightX"]:SetValue(ThickHealthBarData["HealthTextRightX"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextRightY"], ThickHealthBarData["HealthTextRightY"])
     settingsFrame.sliders["HealthTextRightY"]:SetValue(ThickHealthBarData["HealthTextRightY"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextLeftX"], ThickHealthBarData["HealthTextLeftX"])
     settingsFrame.sliders["HealthTextLeftX"]:SetValue(ThickHealthBarData["HealthTextLeftX"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextLeftY"], ThickHealthBarData["HealthTextLeftY"])
     settingsFrame.sliders["HealthTextLeftY"]:SetValue(ThickHealthBarData["HealthTextLeftY"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextX"], ThickHealthBarData["HealthTextX"])
     settingsFrame.sliders["HealthTextX"]:SetValue(ThickHealthBarData["HealthTextX"])

     EditBoxSetText(settingsFrame.editboxes["HealthTextY"], ThickHealthBarData["HealthTextY"])
     settingsFrame.sliders["HealthTextY"]:SetValue(ThickHealthBarData["HealthTextY"])
end