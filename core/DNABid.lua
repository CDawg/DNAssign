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

-- bid window --
local frameZindex=500
local MAX_BID_ALLOWED = 999
bidSound.start = 12889
bidSound.placed= DNAGlobal.dir .. "sounds/MagicClick.ogg"
--bidSound.expire= 5274
bidSound.expire= 6674

DNABidWindow ={}
DNABidWindow = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplate")
DNABidWindow:SetWidth(DNABidWindow_w)
DNABidWindow:SetHeight(DNABidWindow_h)
DNABidWindow:SetPoint("CENTER", 300, 0)
DNABidWindow:SetMovable(true)
DNABidWindow:EnableMouse(true)
DNABidWindow:SetFrameStrata("DIALOG")
DNABidWindow:SetFrameLevel(frameZindex)
DNABidWindow:RegisterForDrag("LeftButton")
DNABidWindow:SetScript("OnDragStart", function()
  DNABidWindow:StartMoving()
end)
DNABidWindow:SetScript("OnDragStop", function()
  DNABidWindow:StopMovingOrSizing()
  local point, relativeTo, relativePoint, xOfs, yOfs = DNABidWindow:GetPoint()
  DN:Debug("BW Pos: " .. point .. "," .. xOfs .. "," .. yOfs)
  DNA[player.combine]["CONFIG"]["BWPOS"] = point .. "," .. xOfs .. "," .. yOfs
end)

local bidderScrollWindow_h = 100
local DNABidWindowBG = CreateFrame("Frame", nil, DNABidWindow, "InsetFrameTemplate")
DNABidWindowBG:SetSize(DNABidWindow_w-4, bidderScrollWindow_h)
DNABidWindowBG:SetPoint("TOPLEFT", 1, -60)
DNABidWindow.title = DNABidWindow:CreateFontString(nil, "ARTWORK")
DNABidWindow.title:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidWindow.title:SetText("DNA |cffdededev" .. DNAGlobal.version)
DNABidWindow.title:SetTextColor(1, 1, 0.8)
DNABidWindow.title:SetPoint("TOPLEFT", 10, -5)

DNABidWindowItem = DNABidWindow:CreateFontString(nil, "ARTWORK")
DNABidWindowItem:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidWindowItem:SetText("Unknown")
DNABidWindowItem:SetPoint("TOPLEFT", 5, -38)

DNABidWindowMLTimer = DNABidWindow:CreateFontString(nil, "ARTWORK")
DNABidWindowMLTimer:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidWindowMLTimer:SetText(BID_TIMER) --just a placeholder

DNABidWindow.ScrollFrame = CreateFrame("ScrollFrame", nil, DNABidWindowBG, "UIPanelScrollFrameTemplate")
DNABidWindow.ScrollFrame:SetPoint("TOPLEFT", DNABidWindowBG, "TOPLEFT", 5, -4)
DNABidWindow.ScrollFrame:SetPoint("BOTTOMRIGHT", DNABidWindowBG, "BOTTOMRIGHT", -25, 5)
local DNABidWindowScrollChildFrame = CreateFrame("Frame", nil, DNABidWindow.ScrollFrame)
DNABidWindowScrollChildFrame:SetSize(DNABidWindow_w, bidderScrollWindow_h)
DNABidWindow.ScrollFrame:SetScrollChild(DNABidWindowScrollChildFrame)
DNABidWindow.ScrollFrame.ScrollBar:ClearAllPoints()
DNABidWindow.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNABidWindow.ScrollFrame, "TOPRIGHT", -50, -16)
DNABidWindow.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNABidWindow.ScrollFrame, "BOTTOMRIGHT", 76, 14)
--[==[
DNABidWindowMR = DNABidWindow:CreateTexture(nil, "BACKGROUND", DNABidWindow, -1)
DNABidWindowMR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNABidWindowMR:SetPoint("TOPLEFT", DNABidWindow_w, -2)
DNABidWindowMR:SetSize(24, 116)
]==]--

local bidderTextPos_y = 5

function clearBidding()
  for i=1, MAX_BIDS do
    DNABidWindowBidderName[i]:SetText("")
    DNABidWindowBidderNum[i]:SetText("")
  end
  table.clear(bidderTable)
end

for i=1, MAX_BIDS do
  DNABidWindowBidderName[i] = DNABidWindowScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNABidWindowBidderName[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNABidWindowBidderName[i]:SetText("")
  DNABidWindowBidderName[i]:SetPoint("TOPLEFT", 20, -15*i+bidderTextPos_y)
  DNABidWindowBidderNum[i] = DNABidWindowScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNABidWindowBidderNum[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNABidWindowBidderNum[i]:SetText("")
  DNABidWindowBidderNum[i]:SetPoint("TOPLEFT", 150, -15*i+bidderTextPos_y)
end

DNABidControlWinner = DNABidWindow:CreateFontString(nil, "OVERLAY")
DNABidControlWinner:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidControlWinner:SetText("WEINER")
DNABidControlWinner:SetPoint("CENTER", 0, -40)
DNABidControlWinner:Hide()

DNABidControlFrame = CreateFrame("Frame", nil, DNABidWindow)
DNABidControlFrame:SetWidth(238)
DNABidControlFrame:SetHeight(140)
DNABidControlFrame:SetPoint("TOPLEFT", 5, -DNABidWindow_h+170)
DNABidControlFrame:SetBackdrop({
  --bgFile = "Interface/ToolTips/CHATBUBBLE-BACKGROUND",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})

local DNABidBtnLow = {}
local DNABidNumberBorder = CreateFrame("Frame", nil, DNABidControlFrame)
DNABidNumberBorder:SetWidth(36)
DNABidNumberBorder:SetHeight(25)
DNABidNumberBorder:SetPoint("TOPLEFT", 20, -20)
DNABidNumberBorder:SetBackdrop({
  bgFile = "Interface/ToolTips/CHATBUBBLE-BACKGROUND",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNABidNumber = CreateFrame("EditBox", nil, DNABidNumberBorder)
DNABidNumber:SetSize(30, 22)
DNABidNumber:SetFontObject(GameFontWhite)
DNABidNumber:SetPoint("TOPLEFT", 5, -1)
DNABidNumber:EnableKeyboard(true)
DNABidNumber:ClearFocus(self)
DNABidNumber:SetAutoFocus(false)
DNABidNumber:GetNumber()
DNABidNumber:SetScript("OnEscapePressed", function()
  --DN:Debug("get out of bid window")
  DNABidNumber:ClearFocus(self)
  --DNABidWindow:Hide()
end)
local current_number = 0
DNABidNumber:SetScript("OnKeyUp", function()
  current_number = DNABidNumber:GetText()
  --DNABidBtnLow.text:SetText("Bid [" .. DNABidNumber:GetText() .. "]")
  if (tonumber(current_number)) then
    DNABidNumber:SetText(current_number)
  else
    DNABidNumber:SetText("")
  end
end)
DNABidNumber:SetText("0")

DNABidBtnLow = CreateFrame("Button", nil, DNABidControlFrame)
DNABidBtnLow:SetWidth(110)
DNABidBtnLow:SetHeight(28)
DNABidBtnLow:SetPoint("TOPLEFT", 70, -20)
DNABidBtnLow:SetBackdrop({
  bgFile = "Interface/Buttons/GREENGRAD64",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 15,
  insets = {left=4, right=4, top=4, bottom=4},
})
DNABidBtnLow:SetBackdropColor(0.8, 0.8, 0.8, 1)
DNABidBtnLow:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
DNABidBtnLow.text = DNABidBtnLow:CreateFontString(nil, "OVERLAY")
DNABidBtnLow.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidBtnLow.text:SetText("Bid")
DNABidBtnLow.text:SetPoint("CENTER", 0, 0)
DNABidBtnLow.image = DNABidBtnLow:CreateTexture(nil, "OVERLAY", DNABidBtnLow, 7)
DNABidBtnLow.image:SetTexture("Interface/Buttons/UI-MicroStream-Green")
DNABidBtnLow.image:SetWidth(25)
DNABidBtnLow.image:SetHeight(25)
DNABidBtnLow.image:SetPoint("TOPLEFT", 70, 0)
DNABidBtnLow.image:SetRotation(math.rad(180))
--DNABidBtnLow.image:SetBlendMode("ADD")
DNABidBtnLow:SetScript("OnEnter", function()
  DNABidBtnLow:SetBackdropBorderColor(1, 1, 1, 1)
end)
DNABidBtnLow:SetScript("OnLeave", function()
  DNABidBtnLow:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
end)
DNABidBtnLow:SetScript("OnClick", function()
  local bidRoll = tonumber(DNABidNumber:GetText())
  if ((bidRoll == nil) or (bidRoll == "")) then
    bidRoll = 0
    --DNABidNumber:SetText("0")
  end
  if (tonumber(bidRoll)) then
    local getCode = multiKeyFromValue(netCode, "lootbid")
    if (myBid == bidRoll) then
      DN:ChatNotification("|cfff00000Your bid [".. tonumber(bidRoll) .. "] was already placed!")
      return
    end
    if ((DNABidWindowBidderNum[1]:GetText() == nil) or (DNABidWindowBidderNum[1]:GetText() == "")) then
      bidPlaced = 0
    else
      bidPlaced = tonumber(DNABidWindowBidderNum[1]:GetText())
    end
    if (bidRoll < bidPlaced) then
      local highBid = bidPlaced+1
      --DNABidNumber:SetText(highBid)
      bidRoll = highBid
      --DN:ChatNotification("|cfff00000Your bid must be match or exceed ".. bidPlaced)
      --return
    end
    if (bidRoll > MAX_BID_ALLOWED) then
      DN:ChatNotification("|cfff00000Bid exceeds the limit!")
      return
    end
    DN:SendPacket(netCode[getCode][2] .. player.name .. "," .. tonumber(bidRoll), true)
    DNABidNumber:SetText("")
    DNABidNumber:ClearFocus(self)
    myBid = bidRoll
  else
    DN:ChatNotification("|cfff00000Invalid Bid Number!")
  end
end)

local DNABidBtnMax = {}
DNABidBtnMax = CreateFrame("Button", nil, DNABidControlFrame)
DNABidBtnMax:SetWidth(110)
DNABidBtnMax:SetHeight(28)
DNABidBtnMax:SetPoint("TOPLEFT", 70, -50)
DNABidBtnMax:SetBackdrop({
  bgFile = "Interface/Buttons/REDGRAD64",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 15,
  insets = {left=4, right=4, top=4, bottom=4},
})
DNABidBtnMax:SetBackdropColor(0.5, 0.4, 0.4, 1)
DNABidBtnMax:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
DNABidBtnMax.text = DNABidBtnMax:CreateFontString(nil, "OVERLAY")
DNABidBtnMax.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidBtnMax.text:SetText("Max")
DNABidBtnMax.text:SetPoint("CENTER", 0, 0)
DNABidBtnMax:SetScript("OnEnter", function()
  DNABidBtnMax:SetBackdropBorderColor(1, 1, 1, 1)
end)
DNABidBtnMax:SetScript("OnLeave", function()
  DNABidBtnMax:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
end)
DNABidBtnMax:SetScript("OnClick", function()
  --local getCode = multiKeyFromValue(netCode, "lootbid")
  --DN:SendPacket(netCode[getCode][2] .. player.name .. "," .. 4, true)
end)

DNABidBtnMaxBonus = {}
DNABidBtnMaxBonus = CreateFrame("Button", nil, DNABidControlFrame)
DNABidBtnMaxBonus:SetWidth(110)
DNABidBtnMaxBonus:SetHeight(28)
DNABidBtnMaxBonus:SetPoint("TOPLEFT", 70, -80)
DNABidBtnMaxBonus:SetBackdrop({
  bgFile = "Interface/Buttons/REDGRAD64",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 15,
  insets = {left=4, right=4, top=4, bottom=4},
})
DNABidBtnMaxBonus:SetBackdropColor(0.5, 0.3, 0.3, 1)
DNABidBtnMaxBonus:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
DNABidBtnMaxBonus.text = DNABidBtnMaxBonus:CreateFontString(nil, "OVERLAY")
DNABidBtnMaxBonus.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidBtnMaxBonus.text:SetText("Max + Bonus")
DNABidBtnMaxBonus.text:SetPoint("CENTER", 0, 0)
DNABidBtnMaxBonus:SetScript("OnEnter", function()
  DNABidBtnMaxBonus:SetBackdropBorderColor(1, 1, 1, 1)
end)
DNABidBtnMaxBonus:SetScript("OnLeave", function()
  DNABidBtnMaxBonus:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
end)
DNABidBtnMaxBonus:SetScript("OnClick", function()
  --local getCode = multiKeyFromValue(netCode, "lootbid")
  --DN:SendPacket(netCode[getCode][2] .. player.name .. "," .. 4, true)
end)

--progress
local bidtimer_h = 24
DNABidTimerProg = CreateFrame("Frame", nil, DNABidWindow)
DNABidTimerProg:SetWidth(0)
DNABidTimerProg:SetHeight(bidtimer_h)
DNABidTimerProg:SetFrameLevel(frameZindex+2)
DNABidTimerProg:SetPoint("TOPLEFT", 0, -bitTimerPos_y)
DNABidTimerProg:SetBackdrop({
  bgFile   = "Interface/Buttons/GoldGradiant",
  edgeFile = "",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNABidTimerProg:SetBackdropColor(1, 1, 1, 0.8)

DNABidTimerBorder = CreateFrame("Frame", nil, DNABidWindow)
DNABidTimerBorder:SetWidth(DNABidWindow_w-2)
DNABidTimerBorder:SetHeight(bidtimer_h)
DNABidTimerBorder:SetFrameLevel(frameZindex+3)
DNABidTimerBorder:SetPoint("TOPLEFT", 0, -bitTimerPos_y)
DNABidTimerBorder:SetBackdrop({
  bgFile   = "",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNABidTimerCount = DNABidTimerBorder:CreateFontString(nil, "ARTWORK")
DNABidTimerCount:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidTimerCount:SetText("")
--DNABidTimerCount:SetTextColor(1, 1, 1)
DNABidTimerCount:SetPoint("CENTER", 0, 0)

DNABidTimerBG = CreateFrame("Frame", nil, DNABidWindow)
DNABidTimerBG:SetWidth(DNABidWindow_w-2)
DNABidTimerBG:SetHeight(bidtimer_h)
DNABidTimerBG:SetFrameLevel(frameZindex+1)
DNABidTimerBG:SetPoint("TOPLEFT", 0, -bitTimerPos_y)
DNABidTimerBG:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = "",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNABidTimerSpark = DNABidTimerBorder:CreateTexture(nil, "OVERLAY", DNABidTimerBorder, 7)
DNABidTimerSpark:SetTexture("Interface/CastingBar/UI-CastingBar-Spark")
DNABidTimerSpark:SetWidth(25)
DNABidTimerSpark:SetHeight(bidtimer_h*2+2)
DNABidTimerSpark:SetPoint("TOPLEFT", -5, 12)
DNABidTimerSpark:SetBlendMode("ADD")
DNABidTimerSpark:Hide()

DNABidWindow:Hide()
