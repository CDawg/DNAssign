--[==[
Copyright ©2020 Porthios of Myzrael
The contents of this addon, excluding third-party resources, are
copyrighted to Porthios with all rights reserved.
This addon is free to use and the authors hereby grants you the following rights:
1. You may make modifications to this addon for private use only, you
   may not publicize any portion of this addon.
2. Do not modify the name of this addon, including the addon folders.
3. This copyright notice shall be included in all copies or substantial
  portions of the Software.
All rights not explicitly addressed in this license are reserved by
the copyright holders.
]==]--

DNAMiniMap = CreateFrame("Button", nil, Minimap)
DNAMiniMap:SetFrameLevel(500)
DNAMiniMap:SetFrameStrata("TOOLTIP")
DNAMiniMap:SetSize(27, 27)
DNAMiniMap:SetMovable(true)
DNAMiniMap:SetNormalTexture(DNAGlobal.icon)
DNAMiniMap:SetPushedTexture(DNAGlobal.icon)
DNAMiniMap:SetHighlightTexture(DNAGlobal.icon)

local myIconPos = 40

local function UpdateMapButton()
  local Xpoa, Ypoa = GetCursorPosition()
  local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
  local point, relativeTo, relativePoint, xOfs, yOfs = DNAMiniMap:GetPoint()
  Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
  Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
  myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
  --if (DNA[player.combine]["CONFIG"]["MMICONUNLOCK"] ~= "ON") then --default and off
    DNAMiniMap:ClearAllPoints()
    DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 60 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 56)
  --end
  debug("MMI UpdateMapButton: " .. point .. "," .. xOfs .. "," .. yOfs)
  DNA[player.combine]["CONFIG"]["MMICONPOS"] = point .. "," .. xOfs .. "," .. yOfs
end
DNAMiniMap:RegisterForDrag("LeftButton")
DNAMiniMap:SetScript("OnDragStart", function()
    DNAMiniMap:StartMoving()
    DNAMiniMap:SetScript("OnUpdate", UpdateMapButton)
end)
--minimapIconPos
DNAMiniMap:SetScript("OnDragStop", function()
  DNAMiniMap:StopMovingOrSizing()
  DNAMiniMap:SetScript("OnUpdate", nil)
  --UpdateMapButton()
end)
DNAMiniMap:SetScript("OnClick", function()
  DN:Open()
end)

function DN:DefaulMiniMapPos()
  DNAMiniMap:SetPoint("TOPLEFT",-7,-12)
end

function DN:ResetMiniMapIcon()
  DNAMiniMap:ClearAllPoints()
  DN:DefaulMiniMapPos()
  DNA[player.combine]["CONFIG"]["MMICONPOS"] = "TOPLEFT,-7,-12"
  DNA[player.combine]["CONFIG"]["MMICONHIDE"] = "OFF"
  --DNA[player.combine]["CONFIG"]["MMICONUNLOCK"] = "OFF"
  DNACheckbox["MMICONHIDE"]:SetChecked(false)
  --DNACheckbox["MMICONUNLOCK"]:SetChecked(false)
  DNAMiniMap:Show()
end
DNAMiniMap:ClearAllPoints()
DN:DefaulMiniMapPos()

local DNADialogMMIReset = CreateFrame("Frame", nil, UIParent)
DNADialogMMIReset:SetWidth(400)
DNADialogMMIReset:SetHeight(100)
DNADialogMMIReset:SetPoint("CENTER", 0, 50)
DNADialogMMIReset:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = DNAGlobal.border,
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNADialogMMIReset.text = DNADialogMMIReset:CreateFontString(nil, "ARTWORK")
DNADialogMMIReset.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADialogMMIReset.text:SetPoint("CENTER", DNADialogMMIReset, "CENTER", 0, 20)
DNADialogMMIReset.text:SetText("Reset the minimap icon position?")
DNADialogMMIReset:SetFrameLevel(150)
DNADialogMMIReset:SetFrameStrata("FULLSCREEN_DIALOG")
local DNADialogMMIResetNo = CreateFrame("Button", nil, DNADialogMMIReset)
DNADialogMMIResetNo:SetPoint("CENTER", -80, -20)
DNADialogMMIResetNo.text = DNADialogMMIResetNo:CreateFontString(nil, "ARTWORK")
DNADialogMMIResetNo.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADialogMMIResetNo.text:SetPoint("CENTER", DNADialogMMIResetNo, "CENTER", 0, 0)
DNADialogMMIResetNo.text:SetText("No")
DN:ButtonFrame(DNADialogMMIResetNo, "red")
DNADialogMMIResetNo:SetScript('OnClick', function()
  DNADialogMMIReset:Hide()
end)
local DNADialogMMIResetYes = CreateFrame("Button", nil, DNADialogMMIReset)
DNADialogMMIResetYes:SetPoint("CENTER", 80, -20)
DNADialogMMIResetYes.text = DNADialogMMIResetYes:CreateFontString(nil, "ARTWORK")
DNADialogMMIResetYes.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADialogMMIResetYes.text:SetPoint("CENTER", DNADialogMMIResetYes, "CENTER", 0, 0)
DNADialogMMIResetYes.text:SetText("Yes")
DN:ButtonFrame(DNADialogMMIResetYes, "red")
DNADialogMMIResetYes:SetScript('OnClick', function()
  DN:ResetMiniMapIcon()
  DNADialogMMIReset:Hide()
end)
DNADialogMMIReset:Hide()

local DNAMiniMapRestore = CreateFrame("Button", nil, page["Settings"])
DNAMiniMapRestore:SetPoint("TOPLEFT", 34, -415)
DNAMiniMapRestore.text = DNAMiniMapRestore:CreateFontString(nil, "ARTWORK")
DNAMiniMapRestore.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
DNAMiniMapRestore.text:SetText("Reset Minimap Icon")
DNAMiniMapRestore.text:SetPoint("CENTER", DNAMiniMapRestore)
DN:ButtonFrame(DNAMiniMapRestore, "red")
DNAMiniMapRestore:SetScript("OnClick", function()
  DNADialogMMIReset:Show()
end)

local DNADialogWTFReset = CreateFrame("Frame", nil, UIParent)
DNADialogWTFReset:SetWidth(400)
DNADialogWTFReset:SetHeight(100)
DNADialogWTFReset:SetPoint("CENTER", 0, 50)
DNADialogWTFReset:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = DNAGlobal.border,
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNADialogWTFReset.text = DNADialogWTFReset:CreateFontString(nil, "ARTWORK")
DNADialogWTFReset.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADialogWTFReset.text:SetPoint("CENTER", DNADialogMMIReset, "CENTER", 0, 20)
DNADialogWTFReset.text:SetText("Reset all defaults?\nThis will delete your current profile for\n|cfff2c983" .. player.combine .. ".")
DNADialogWTFReset:SetFrameLevel(150)
DNADialogWTFReset:SetFrameStrata("FULLSCREEN_DIALOG")
local DNADialogWTFResetNo = CreateFrame("Button", nil, DNADialogWTFReset)
DNADialogWTFResetNo:SetPoint("CENTER", -80, -20)
DNADialogWTFResetNo.text = DNADialogWTFResetNo:CreateFontString(nil, "ARTWORK")
DNADialogWTFResetNo.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADialogWTFResetNo.text:SetPoint("CENTER", DNADialogWTFResetNo, "CENTER", 0, 0)
DNADialogWTFResetNo.text:SetText("No")
DN:ButtonFrame(DNADialogWTFResetNo, "red")
DNADialogWTFResetNo:SetScript('OnClick', function()
  DNADialogWTFReset:Hide()
end)
local DNADialogWTFResetYes = CreateFrame("Button", nil, DNADialogWTFReset)
DNADialogWTFResetYes:SetPoint("CENTER", 80, -20)
DNADialogWTFResetYes.text = DNADialogWTFResetYes:CreateFontString(nil, "ARTWORK")
DNADialogWTFResetYes.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADialogWTFResetYes.text:SetPoint("CENTER", DNADialogWTFResetYes, "CENTER", 0, 0)
DNADialogWTFResetYes.text:SetText("Yes")
DN:ButtonFrame(DNADialogWTFResetYes, "red")
DNADialogWTFResetYes:SetScript('OnClick', function()
  DNA[player.combine] = nil
  ReloadUI()
end)
DNADialogWTFReset:Hide()

local DNAWTFRestore = CreateFrame("Button", nil, page["Settings"])
DNAWTFRestore:SetPoint("TOPLEFT", 20, -DNAGlobal.height+50)
DNAWTFRestore.text = DNAWTFRestore:CreateFontString(nil, "ARTWORK")
DNAWTFRestore.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
DNAWTFRestore.text:SetText("Restore All Defaults")
DNAWTFRestore.text:SetPoint("CENTER", DNAWTFRestore)
DN:ButtonFrame(DNAWTFRestore, "red")
DNAWTFRestore:SetScript("OnClick", function()
  DNADialogWTFReset:Show()
end)
