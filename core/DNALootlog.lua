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

local DNALootlogScrollFrame_w = 200
local DNALootlogScrollFrame_h = 500

local DNALootlogScrollFrame = CreateFrame("Frame", DNALootlogScrollFrame, page["Loot Log"], "InsetFrameTemplate")
DNALootlogScrollFrame:SetWidth(DNALootlogScrollFrame_w+20)
DNALootlogScrollFrame:SetHeight(DNALootlogScrollFrame_h)
DNALootlogScrollFrame:SetPoint("TOPLEFT", 20, -50)
DNALootlogScrollFrame:SetFrameLevel(5)
DNALootlogScrollFrame.text = DNALootlogScrollFrame:CreateFontString(nil, "ARTWORK")
DNALootlogScrollFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogScrollFrame.text:SetPoint("CENTER", DNALootlogScrollFrame, "TOPLEFT", 90, 10)
DNALootlogScrollFrame.text:SetText("LOOT LOGS")
DNALootlogScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNALootlogScrollFrame, "UIPanelScrollFrameTemplate")
DNALootlogScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNALootlogScrollFrame, "TOPLEFT", 3, -3)
DNALootlogScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNALootlogScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNALootlogScrollFrameScrollChildFrame = CreateFrame("Frame", DNALootlogScrollFrameScrollChildFrame, DNALootlogScrollFrame.ScrollFrame)
DNALootlogScrollFrameScrollChildFrame:SetSize(DNALootlogScrollFrame_w, DNALootlogScrollFrame_h)
DNALootlogScrollFrame.ScrollFrame:SetScrollChild(DNALootlogScrollFrameScrollChildFrame)
DNALootlogScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNALootlogScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNALootlogScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNALootlogScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNALootlogScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNALootlogScrollFrame.MR = DNALootlogScrollFrame:CreateTexture(nil, "BACKGROUND", DNALootlogScrollFrame, -2)
DNALootlogScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNALootlogScrollFrame.MR:SetPoint("TOPLEFT", DNALootlogScrollFrame_w-5, 0)
DNALootlogScrollFrame.MR:SetSize(24, DNALootlogScrollFrame_h)

local DNALootlogBidItemFrame = CreateFrame("Frame", nil, page["Loot Log"], "InsetFrameTemplate")
DNALootlogBidItemFrame:SetSize(300, 150)
DNALootlogBidItemFrame:SetPoint("TOPLEFT", 480, -140)
DNALootlogBidItemFrame:Hide()

DNALootlogBidItem = DNALootlogBidItemFrame:CreateFontString(nil, "ARTWORK", DNALootlogBidItemFrame, 2)
DNALootlogBidItem:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogBidItem:SetPoint("TOPLEFT", 10, -10)
DNALootlogBidItem:SetText("")
--DNALootlogBidItem:Hide()

-- ML set the timer for biddings - default at 10
local DNABidTimerSetBorder = CreateFrame("Frame", nil, DNALootlogBidItemFrame)
DNABidTimerSetBorder:SetWidth(36)
DNABidTimerSetBorder:SetHeight(25)
DNABidTimerSetBorder:SetPoint("TOPLEFT", 20, -35)
DNABidTimerSetBorder:SetBackdrop({
  bgFile = "Interface/ToolTips/CHATBUBBLE-BACKGROUND",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNABidTimerSet = CreateFrame("EditBox", nil, DNABidTimerSetBorder)
DNABidTimerSet:SetSize(30, 22)
DNABidTimerSet:SetFontObject(GameFontWhite)
DNABidTimerSet:SetPoint("TOPLEFT", 5, -1)
DNABidTimerSet:EnableKeyboard(true)
DNABidTimerSet:ClearFocus(self)
DNABidTimerSet:SetAutoFocus(false)
DNABidTimerSet:GetNumber()
DNABidTimerSet:SetScript("OnEscapePressed", function()
  --DN:Debug("get out of bid window")
  DNABidTimerSet:ClearFocus(self)
  --DNABidWindow:Hide()
end)
DNABidTimerSet:SetScript("OnKeyUp", function()
  current_timer_number = DNABidTimerSet:GetText()
  if (tonumber(current_timer_number)) then
    DNABidTimerSet:SetText(current_timer_number)
  else
    DNABidTimerSet:SetText("")
    DNABidTimerSet:ClearFocus(self)
  end
end)
DNABidTimerSet:SetText(BID_TIMER)

DNABidTimerSetText = DNALootlogBidItemFrame:CreateFontString(nil, "ARTWORK", DNALootlogBidItemFrame)
DNABidTimerSetText:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNABidTimerSetText:SetPoint("TOPLEFT", 65, -41)
DNABidTimerSetText:SetText("Bid Timer (Seconds)")

DNALootlogOpenbidBtn = CreateFrame("Button", nil, DNALootlogBidItemFrame)
DNALootlogOpenbidBtn:SetPoint("TOPLEFT", 10, -70)
DNALootlogOpenbidBtn:SetFrameLevel(5)
DNALootlogOpenbidBtn.text = DNALootlogOpenbidBtn:CreateFontString(nil, "ARTWORK")
DNALootlogOpenbidBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogOpenbidBtn.text:SetPoint("CENTER", DNALootlogOpenbidBtn, "TOPLEFT", 68, -13)
DNALootlogOpenbidBtn.text:SetText("Start Bid")
DN:ButtonFrame(DNALootlogOpenbidBtn, "green")
DNALootlogOpenbidBtn:SetScript("OnClick", function()
  local get_bid_timer_cache = DNABidTimerSet:GetText()
  if (IsMasterLooter()) then
    if ((_GitemName) and (_GitemRarity)) then
      DN:Debug(_GitemName)
      DN:Debug(_GitemRarity)
      if ((get_bid_timer_cache == nil) or (get_bid_timer_cache == "")) then
        get_bid_timer_cache = 1
      end
      DN:SendPacket(packetPrefix.openbid .. _GitemName .. "," .. _GitemRarity .. "," .. player.name .. "," .. tonumber(get_bid_timer_cache), false)
    end
  end
end)

DNALootlogStopbidBtn = CreateFrame("Button", nil, DNALootlogBidItemFrame)
DNALootlogStopbidBtn:SetPoint("TOPLEFT", 10, -100)
DNALootlogStopbidBtn:SetFrameLevel(5)
DNALootlogStopbidBtn.text = DNALootlogStopbidBtn:CreateFontString(nil, "ARTWORK")
DNALootlogStopbidBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogStopbidBtn.text:SetPoint("CENTER", DNALootlogStopbidBtn, "TOPLEFT", 68, -13)
DNALootlogStopbidBtn.text:SetText("Stop Bid")
DN:ButtonFrame(DNALootlogStopbidBtn, "red")
DNALootlogStopbidBtn:SetScript("OnClick", function()
  if (IsMasterLooter()) then
    DN:SendPacket(packetPrefix.stopbid .. "," .. player.name, false)
  end
end)

DNALootlogBidTimerText = DNALootlogScrollFrame:CreateFontString(nil, "ARTWORK", page["Loot Log"], 2)
DNALootlogBidTimerText:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogBidTimerText:SetPoint("TOPLEFT", 460, -120)
DNALootlogBidTimerText:SetText("")
DNALootlogBidTimerText:Hide()

local DNADeleteAllLootlogPrompt = CreateFrame("Frame", nil, UIParent)
DNADeleteAllLootlogPrompt:SetWidth(450)
DNADeleteAllLootlogPrompt:SetHeight(100)
DNADeleteAllLootlogPrompt:SetPoint("CENTER", 0, 50)
DNADeleteAllLootlogPrompt:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = DNAGlobal.border,
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNADeleteAllLootlogPrompt.text = DNADeleteAllLootlogPrompt:CreateFontString(nil, "ARTWORK")
DNADeleteAllLootlogPrompt.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteAllLootlogPrompt.text:SetPoint("CENTER", DNADeleteAllLootlogPrompt, "CENTER", 0, 20)
DNADeleteAllLootlogPrompt.text:SetText("Delete all Loot logs?\nThis will delete all loot logs account wide and reload.")
DNADeleteAllLootlogPrompt:SetFrameLevel(150)
DNADeleteAllLootlogPrompt:SetFrameStrata("FULLSCREEN_DIALOG")

local DNADeleteAllLootlogPromptYes = CreateFrame("Button", nil, DNADeleteAllLootlogPrompt)
DNADeleteAllLootlogPromptYes:SetPoint("CENTER", 80, -20)
DNADeleteAllLootlogPromptYes.text = DNADeleteAllLootlogPromptYes:CreateFontString(nil, "ARTWORK")
DNADeleteAllLootlogPromptYes.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteAllLootlogPromptYes.text:SetPoint("CENTER", DNADeleteAllLootlogPromptYes, "CENTER", 0, 0)
DNADeleteAllLootlogPromptYes.text:SetText("Yes")
DN:ButtonFrame(DNADeleteAllLootlogPromptYes, "red")
DNADeleteAllLootlogPromptYes:SetScript('OnClick', function()
  for i=1, numLootLogs.init do
    lootLogSlot[i]:Hide()
  end
  DNA["LOOTLOG"] = {}
  ReloadUI()
end)
local DNADeleteAllLootlogPromptNo = CreateFrame("Button", nil, DNADeleteAllLootlogPrompt)
DNADeleteAllLootlogPromptNo:SetPoint("CENTER", -80, -20)
DNADeleteAllLootlogPromptNo.text = DNADeleteAllLootlogPromptNo:CreateFontString(nil, "ARTWORK")
DNADeleteAllLootlogPromptNo.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteAllLootlogPromptNo.text:SetPoint("CENTER", DNADeleteAllLootlogPromptNo, "CENTER", 0, 0)
DNADeleteAllLootlogPromptNo.text:SetText("No")
DN:ButtonFrame(DNADeleteAllLootlogPromptNo, "red")
DNADeleteAllLootlogPromptNo:SetScript('OnClick', function()
  DNADeleteAllLootlogPrompt:Hide()
end)
DNADeleteAllLootlogPrompt:Hide()

DNALootlogDeleteAllBtn = CreateFrame("Button", nil, DNALootlogScrollFrame)
DNALootlogDeleteAllBtn:SetPoint("TOPLEFT", 35, -DNALootlogScrollFrame_h-5)
DNALootlogDeleteAllBtn:SetFrameLevel(5)
DNALootlogDeleteAllBtn.text = DNALootlogDeleteAllBtn:CreateFontString(nil, "ARTWORK")
DNALootlogDeleteAllBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogDeleteAllBtn.text:SetPoint("CENTER", DNALootlogDeleteAllBtn)
DNALootlogDeleteAllBtn.text:SetText("Delete All Logs")
DN:ButtonFrame(DNALootlogDeleteAllBtn, "red")
DNALootlogDeleteAllBtn:SetScript("OnClick", function()
  DNADeleteAllLootlogPrompt:Show()
end)
DNALootlogDeleteAllBtn:Hide()

local DNALootlogDetailsFrame={}
local DNALootlogItemScrollFrame={}
local DNALootlogDeleteLogBtn={}
local DNALootlogExportLogBtn={}

local lootlogLogDate = nil
local lootlogLogName = nil
local lootlogLogID = 0
local sortLootlogName = {}
local DNADeleteSingleLootlogPrompt = CreateFrame("Frame", nil, UIParent)
DNADeleteSingleLootlogPrompt:SetWidth(450)
DNADeleteSingleLootlogPrompt:SetHeight(100)
DNADeleteSingleLootlogPrompt:SetPoint("CENTER", 0, 50)
DNADeleteSingleLootlogPrompt:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = DNAGlobal.border,
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNADeleteSingleLootlogPrompt.text = DNADeleteSingleLootlogPrompt:CreateFontString(nil, "ARTWORK")
DNADeleteSingleLootlogPrompt.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteSingleLootlogPrompt.text:SetPoint("CENTER", DNADeleteSingleLootlogPrompt, "CENTER", 0, 20)
DNADeleteSingleLootlogPrompt.text:SetText("Delete Loot Log?")
DNADeleteSingleLootlogPrompt:SetFrameLevel(150)
DNADeleteSingleLootlogPrompt:SetFrameStrata("FULLSCREEN_DIALOG")

local DNADeleteSingleLootlogPromptYes = CreateFrame("Button", nil, DNADeleteSingleLootlogPrompt)
DNADeleteSingleLootlogPromptYes:SetPoint("CENTER", 80, -20)
DNADeleteSingleLootlogPromptYes.text = DNADeleteSingleLootlogPromptYes:CreateFontString(nil, "ARTWORK")
DNADeleteSingleLootlogPromptYes.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteSingleLootlogPromptYes.text:SetPoint("CENTER", DNADeleteSingleLootlogPromptYes, "CENTER", 0, 0)
DNADeleteSingleLootlogPromptYes.text:SetText("Yes")
DN:ButtonFrame(DNADeleteSingleLootlogPromptYes, "red")
DNADeleteSingleLootlogPromptYes:SetScript('OnClick', function()
  if ((lootlogLogDate) and (lootlogLogName)) then
    DNA["LOOTLOG"][lootlogLogDate][lootlogLogName] = nil
  end
  if (lootlogLogID ~= 0) then
    lootLogSlot[lootlogLogID]:Hide()
  end
  DNADeleteSingleLootlogPrompt:Hide()
  DNALootlogDetailsFrame:Hide()
  DNALootlogItemScrollFrame:Hide()
  DNALootlogDeleteLogBtn:Hide()
  DNALootlogExportLogBtn:Hide()
  --DNALootlogOpenbidBtn:Hide()
  --DNALootlogBidItem:Hide()
  DNALootlogBidItemFrame:Hide()
end)
local DNADeleteSingleLootlogPromptNo = CreateFrame("Button", nil, DNADeleteSingleLootlogPrompt)
DNADeleteSingleLootlogPromptNo:SetPoint("CENTER", -80, -20)
DNADeleteSingleLootlogPromptNo.text = DNADeleteSingleLootlogPromptNo:CreateFontString(nil, "ARTWORK")
DNADeleteSingleLootlogPromptNo.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteSingleLootlogPromptNo.text:SetPoint("CENTER", DNADeleteSingleLootlogPromptNo, "CENTER", 0, 0)
DNADeleteSingleLootlogPromptNo.text:SetText("No")
DN:ButtonFrame(DNADeleteSingleLootlogPromptNo, "red")
DNADeleteSingleLootlogPromptNo:SetScript('OnClick', function()
  DNADeleteSingleLootlogPrompt:Hide()
end)
DNADeleteSingleLootlogPrompt:Hide()

DNALootlogDeleteLogBtn = CreateFrame("Button", nil, page["Loot Log"])
DNALootlogDeleteLogBtn:SetPoint("TOPLEFT", 480, -50)
DNALootlogDeleteLogBtn:SetFrameLevel(5)
DNALootlogDeleteLogBtn.text = DNALootlogDeleteLogBtn:CreateFontString(nil, "ARTWORK")
DNALootlogDeleteLogBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogDeleteLogBtn.text:SetPoint("CENTER", DNALootlogDeleteLogBtn)
DNALootlogDeleteLogBtn.text:SetText("Delete Log")
DN:ButtonFrame(DNALootlogDeleteLogBtn, "red")
DNALootlogDeleteLogBtn:SetScript("OnClick", function()
  if ((lootlogLogDate) and (lootlogLogName))then
    DN:Debug(lootlogLogDate)
    DN:Debug(lootlogLogName)
  end
  DNADeleteSingleLootlogPrompt.text:SetText("Delete Loot log:\n|cfff2c983" .. lootlogLogDate .. " " ..  lootlogLogName .. "|cffffffff?")
  DNADeleteSingleLootlogPrompt:Show()
end)
DNALootlogDeleteLogBtn:Hide()

local DNALootlogExportWindowScrollFrame_w = 250
local DNALootlogExportWindowScrollFrame_h = 400
DNALootlogExportWindow = CreateFrame("Frame", DNALootlogExportWindow, UIParent, "BasicFrameTemplate")
DNALootlogExportWindow:SetWidth(DNALootlogExportWindowScrollFrame_w+50)
DNALootlogExportWindow:SetHeight(DNALootlogExportWindowScrollFrame_h+80)
DNALootlogExportWindow:SetPoint("CENTER", 0, 100)
DNALootlogExportWindow:SetFrameStrata("DIALOG")
DNALootlogExportWindow.title = DNALootlogExportWindow:CreateFontString(nil, "ARTWORK")
DNALootlogExportWindow.title:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogExportWindow.title:SetPoint("TOPLEFT", DNALootlogExportWindow, "TOPLEFT", 10, -6)
DNALootlogExportWindow.title:SetText("Lootlog Export")
DNALootlogExportWindow.text = DNALootlogExportWindow:CreateFontString(nil, "ARTWORK")
DNALootlogExportWindow.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogExportWindow.text:SetPoint("TOPLEFT", DNALootlogExportWindow, "TOPLEFT", 40, -DNALootlogExportWindowScrollFrame_h-35)
DNALootlogExportWindow.text:SetText("Copy the data using CTRL+C")
DNALootlogExportWindow:Hide()
DNALootlogExportWindowScrollFrame = CreateFrame("Frame", DNALootlogExportWindowScrollFrame, DNALootlogExportWindow, "InsetFrameTemplate")
DNALootlogExportWindowScrollFrame:SetWidth(DNALootlogExportWindowScrollFrame_w+20)
DNALootlogExportWindowScrollFrame:SetHeight(DNALootlogExportWindowScrollFrame_h)
DNALootlogExportWindowScrollFrame:SetPoint("TOPLEFT", 15, -30)
DNALootlogExportWindowScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNALootlogExportWindowScrollFrame, "UIPanelScrollFrameTemplate")
DNALootlogExportWindowScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNALootlogExportWindowScrollFrame, "TOPLEFT", 3, -3)
DNALootlogExportWindowScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNALootlogExportWindowScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNALootlogExportWindowScrollFrameChildFrame = CreateFrame("Frame", DNALootlogExportWindowScrollFrameChildFrame, DNALootlogExportWindowScrollFrame.ScrollFrame)
DNALootlogExportWindowScrollFrameChildFrame:SetSize(DNALootlogExportWindowScrollFrame_w, DNALootlogExportWindowScrollFrame_h)
DNALootlogExportWindowScrollFrame.ScrollFrame:SetScrollChild(DNALootlogExportWindowScrollFrameChildFrame)
DNALootlogExportWindowScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNALootlogExportWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNALootlogExportWindowScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNALootlogExportWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNALootlogExportWindowScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNALootlogExportWindowScrollFrame.MR = DNALootlogExportWindowScrollFrame:CreateTexture(nil, "BACKGROUND", DNALootlogExportWindowScrollFrame, -2)
DNALootlogExportWindowScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNALootlogExportWindowScrollFrame.MR:SetPoint("TOPLEFT", DNALootlogExportWindowScrollFrame_w-5, 0)
DNALootlogExportWindowScrollFrame.MR:SetSize(24, DNALootlogExportWindowScrollFrame_h)
DNALootlogExportWindow.data = CreateFrame("EditBox", nil, DNALootlogExportWindowScrollFrameChildFrame)
DNALootlogExportWindow.data:SetWidth(DNALootlogExportWindowScrollFrame_w-10)
DNALootlogExportWindow.data:SetHeight(20)
DNALootlogExportWindow.data:SetFontObject(GameFontWhite)
DNALootlogExportWindow.data:SetPoint("TOPLEFT", 5, 0)
DNALootlogExportWindow.data:SetMultiLine(true)
DNALootlogExportWindow.data:SetText("There was an error pulling the log")

local DNALootlogCloseBtn = CreateFrame("Button", nil, DNALootlogExportWindow)
DNALootlogCloseBtn:SetPoint("TOPLEFT", 80, -DNALootlogExportWindowScrollFrame_h-52)
DNALootlogCloseBtn.text = DNALootlogCloseBtn:CreateFontString(nil, "ARTWORK")
DNALootlogCloseBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogCloseBtn.text:SetPoint("CENTER", DNALootlogCloseBtn, "CENTER", 0, 0)
DNALootlogCloseBtn.text:SetText("Close")
DN:ButtonFrame(DNALootlogCloseBtn, "red")
DNALootlogCloseBtn:SetScript('OnClick', function()
  DNALootlogExportWindow:Hide()
end)

DNALootlogExportLogBtn = CreateFrame("Button", nil, page["Loot Log"])
DNALootlogExportLogBtn:SetPoint("TOPLEFT", 480, -80)
DNALootlogExportLogBtn:SetFrameLevel(5)
DNALootlogExportLogBtn.text = DNALootlogExportLogBtn:CreateFontString(nil, "ARTWORK")
DNALootlogExportLogBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogExportLogBtn.text:SetPoint("CENTER", DNALootlogExportLogBtn)
DNALootlogExportLogBtn.text:SetText("Export Log")
DN:ButtonFrame(DNALootlogExportLogBtn, "red")
DNALootlogExportLogBtn:SetScript("OnClick", function()
  DNALootlogExportWindow:Show()
  if ((lootlogLogDate) and (lootlogLogName)) then
    lootlogLogExportData = "Loot Log\n"
    lootlogLogExportData = lootlogLogExportData .. "Date: " .. lootlogLogDate .. "\n"
    lootlogLogExportData = lootlogLogExportData .. "Raid: " .. lootlogLogName .. "\n"
    if (table.getn(sortLootlogName)) then
       lootlogLogExportData = lootlogLogExportData .. "Total: " .. table.getn(sortLootlogName) .. "\n"
    end
    lootlogLogExportData = lootlogLogExportData .. "\n"
    for k,v in ipairs(sortLootlogName) do
      lootlogLogExportData = lootlogLogExportData .. v:sub(15) .. "\n"
    end
    lootlogLogExportData = lootlogLogExportData .. "\n"
    DNALootlogExportWindow.data:SetText(lootlogLogExportData)
    DNALootlogExportWindow.data:HighlightText()
  end
end)
DNALootlogExportLogBtn:Hide()

local DNALootlogItemScrollFrame_w = 200
local DNALootlogItemScrollFrame_h = 430
DNALootlogDetailsFrame = CreateFrame("Frame", DNALootlogDetailsFrame, page["Loot Log"], "InsetFrameTemplate")
DNALootlogDetailsFrame:SetWidth(DNALootlogItemScrollFrame_w+20)
DNALootlogDetailsFrame:SetHeight(60)
DNALootlogDetailsFrame:SetPoint("TOPLEFT", 250, -50)
DNALootlogDetailsFrame.date = DNALootlogDetailsFrame:CreateFontString(nil, "ARTWORK")
DNALootlogDetailsFrame.date:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogDetailsFrame.date:SetPoint("TOPLEFT", 10, -10)
DNALootlogDetailsFrame.date:SetText("Select an loot log")
DNALootlogDetailsFrame.instance = DNALootlogDetailsFrame:CreateFontString(nil, "ARTWORK")
DNALootlogDetailsFrame.instance:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogDetailsFrame.instance:SetPoint("TOPLEFT", 10, -30)
DNALootlogDetailsFrame.instance:SetText("")
--[==[
DNALootlogDetailsFrame.count = DNALootlogDetailsFrame:CreateFontString(nil, "ARTWORK")
DNALootlogDetailsFrame.count:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootlogDetailsFrame.count:SetPoint("TOPLEFT", 10, -50)
DNALootlogDetailsFrame.count:SetText("")
]==]--
DNALootlogDetailsFrame:Hide()

DNALootlogItemScrollFrame = CreateFrame("Frame", DNALootlogItemScrollFrame, page["Loot Log"], "InsetFrameTemplate")
DNALootlogItemScrollFrame:SetWidth(DNALootlogItemScrollFrame_w+20)
DNALootlogItemScrollFrame:SetHeight(DNALootlogItemScrollFrame_h)
DNALootlogItemScrollFrame:SetPoint("TOPLEFT", 250, -120)
DNALootlogItemScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNALootlogItemScrollFrame, "UIPanelScrollFrameTemplate")
DNALootlogItemScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNALootlogItemScrollFrame, "TOPLEFT", 3, -3)
DNALootlogItemScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNALootlogItemScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNALootlogItemScrollFrameChildFrame = CreateFrame("Frame", DNALootlogItemScrollFrameChildFrame, DNALootlogItemScrollFrame.ScrollFrame)
DNALootlogItemScrollFrameChildFrame:SetSize(DNALootlogItemScrollFrame_w, DNALootlogItemScrollFrame_h)
DNALootlogItemScrollFrame.ScrollFrame:SetScrollChild(DNALootlogItemScrollFrameChildFrame)
DNALootlogItemScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNALootlogItemScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNALootlogItemScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNALootlogItemScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNALootlogItemScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNALootlogItemScrollFrame.MR = DNALootlogItemScrollFrame:CreateTexture(nil, "BACKGROUND", DNALootlogItemScrollFrame, -2)
DNALootlogItemScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNALootlogItemScrollFrame.MR:SetPoint("TOPLEFT", DNALootlogItemScrollFrame_w-5, 0)
DNALootlogItemScrollFrame.MR:SetSize(24, DNALootlogItemScrollFrame_h)
DNALootlogItemScrollFrame:Hide()

local lootlogSingleSlot={}
--local lootlogSingleSlotInvite={}
local lootlogSingleSlotText={}

--just create the 80 frames, then occupy data into them
for i=1, MAX_RAID_ITEMS do
  lootlogSingleSlot[i] = {}
  lootlogSingleSlot[i] = CreateFrame("button", lootlogSingleSlot[i], DNALootlogItemScrollFrameChildFrame)
  lootlogSingleSlot[i]:SetWidth(DNALootlogItemScrollFrame_w-5)
  lootlogSingleSlot[i]:SetHeight(raidSlot_h)
  lootlogSingleSlot[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  lootlogSingleSlot[i]:SetBackdropColor(1, 1, 1, 0.3)
  lootlogSingleSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  lootlogSingleSlot[i]:SetPoint("TOPLEFT", 0, (-i*18)+raidSlot_h-4)
  lootlogSingleSlotText[i] = {}
  lootlogSingleSlotText[i] = lootlogSingleSlot[i]:CreateFontString(nil, "ARTWORK")
  lootlogSingleSlotText[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  lootlogSingleSlotText[i]:SetPoint("TOPLEFT", 5, -4)
  lootlogSingleSlotText[i]:SetText("")

  --[==[
  lootlogSingleSlot[i]:SetScript('OnClick', function()
    lootlogSingleSlot[i]:SetBackdropColor(1, 1, 0.3, 1)
    lootlogSingleSlot[i]:SetBackdropBorderColor(1, 1, 0.3, 1)
    DN:Debug("this working?")
  end)
  ]==]--
  lootlogSingleSlot[i]:SetScript('OnEnter', function()
    lootlogSingleSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
  end)
  lootlogSingleSlot[i]:SetScript('OnLeave', function()
    lootlogSingleSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  end)

  lootlogSingleSlot[i]:Hide()
end

function setLootlogSlotSingleFrame(i, _item, quality)
  if (lootlogSingleSlot[i]) then
    lootlogSingleSlotText[i]:SetText(_item:sub(1, 26))
    lootlogSingleSlot[i]:Show()
    if (quality) then
      DN:ItemQualityColorText(lootlogSingleSlotText[i], quality)
    end
  end
end

function lootLogSlotFrame(i, filteredName, name)
  lootLogSlot[i] = CreateFrame("button", lootLogSlot[i], DNALootlogScrollFrameScrollChildFrame)
  lootLogSlot[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  lootLogSlot[i]:SetBackdropColor(1, 1, 1, 0.3)
  lootLogSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  lootLogSlot[i]:SetWidth(DNALootlogScrollFrame_w-5)
  lootLogSlot[i]:SetHeight(raidSlot_h)
  lootLogSlot[i]:SetPoint("TOPLEFT", 0, (-i*18)+raidSlot_h-4)
  lootLogSlot[i].text = lootLogSlot[i]:CreateFontString(nil, "ARTWORK")
  lootLogSlot[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  lootLogSlot[i].text:SetPoint("TOPLEFT", 5, -4)
  --local name_trunc = strsub(filteredName, 1, 25)
  local name_trunc = filteredName:sub(1, 25)
  lootLogSlot[i].text:SetText(name_trunc)
  lootLogSlot[i].refresh = lootLogSlot[i]:CreateTexture(nil, "ARTWORK")
  lootLogSlot[i].refresh:SetTexture("Interface/Buttons/UI-RefreshButton")
  lootLogSlot[i].refresh:SetPoint("TOPLEFT", 175, -3)
  lootLogSlot[i].refresh:SetSize(14, 14)
  lootLogSlot[i]:SetScript('OnEnter', function()
    lootLogSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
  end)
  lootLogSlot[i]:SetScript('OnLeave', function()
    lootLogSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  end)
  lootLogSlot[i]:SetScript('OnClick', function()
    for n=1, MAX_RAID_ITEMS do
      lootlogSingleSlot[n]:Hide()
      lootlogSingleSlot[n]:SetBackdropColor(1, 1, 1, 0.3)
    end
    for n=1, numLootLogs.init do
      lootLogSlot[n]:SetBackdropColor(1, 1, 1, 0.3)
      lootLogSlot[n].text:SetTextColor(1, 1, 1)
    end
    lootLogSlot[i]:SetBackdropColor(1, 1, 0.3, 1)
    lootLogSlot[i]:SetBackdropBorderColor(1, 1, 0.3, 1)
    lootLogSlot[i].text:SetTextColor(1, 1, 0.6)
    sortLootlogName = {}
    for k,v in pairs(lootlog[name]) do
      table.insert(sortLootlogName, k)
    end
    table.sort(sortLootlogName)
    for k,v in ipairs(sortLootlogName) do
      local filterItemTimeprint = v:sub(15)
      --local itemQuality = v[1]
      setLootlogSlotSingleFrame(k, filterItemTimeprint, lootlog[name][v][1])
      lootlogSingleSlot[k]:SetScript('OnClick', function()
        for n=1, MAX_RAID_ITEMS do
          lootlogSingleSlot[n]:SetBackdropColor(1, 1, 1, 0.2)
        end
        lootlogSingleSlot[k]:SetBackdropColor(1, 1, 0, 1)
        lootlogSingleSlot[k]:SetBackdropBorderColor(1, 1, 0.3, 1)
        _GitemName = filterItemTimeprint
        _GitemRarity=lootlog[name][v][1]

        if ((IsMasterLooter()) or (DEBUG)) then
          DNALootlogBidItemFrame:Show()
          --DNALootlogOpenbidBtn:Show()
          --DNALootlogBidItem:Show()
          DNALootlogBidItem:SetText(_GitemName)
          DN:ItemQualityColorText(DNALootlogBidItem, _GitemRarity)
        end
      end)
      --DN:Debug(filterItemTimeprint .. "=" .. lootlog[name][v][1])
    end
    local filterLogName = split(name, "}")
    filterLogName[2] = string.gsub(filterLogName[2], " ", "", 1) --first space
    DNALootlogDetailsFrame.date:SetText("|cfffffa8bDate:|r " .. filterLogName[1])
    DNALootlogDetailsFrame.instance:SetText("|cfffffa8bRaid:|r " .. filterLogName[2])
    DNALootlogDeleteLogBtn:Show()
    DNALootlogExportLogBtn:Show()
    DNALootlogDetailsFrame:Show()
    DNALootlogItemScrollFrame:Show()
    lootlogLogDate = filterLogName[1]
    lootlogLogName = filterLogName[2]
    lootlogLogID = i
    DN:Debug(lootlogLogDate)
    DN:Debug(lootlogLogName)
    DN:Debug(lootlogLogID)
  end)
end

local _numLootLogs = 0
function refreshLootLogs()
  DN:GetLootLogs()
  local _lootlog = lootlog
  --[==[
  for k,v in pairs(_lootlog) do
    local filterLogName = string.gsub(k, "}", "")
    DN:Debug(filterLogName)
  end
  ]==]--
  local _sortLoot = {}
  for k,v in pairs(_lootlog) do
    table.insert(_sortLoot, k)
  end
  table.sort(_sortLoot, function(a,b) return a>b end)
  for k,v in ipairs(_sortLoot) do
    --_numLootLogs = _numLootLogs + 1
    --create the number of log frames from the log count
    local filterLogName = string.gsub(v, "}", "")
    DN:Debug(filterLogName)
  end
end

DNALootlogRefreshBtn = CreateFrame("Button", nil, page["Loot Log"])
DNALootlogRefreshBtn:SetWidth(22)
DNALootlogRefreshBtn:SetHeight(22)
DNALootlogRefreshBtn:SetPoint("TOPLEFT", 190, -30)
DNALootlogRefreshBtn:SetBackdrop({
  bgFile = "Interface/Buttons/GREENGRAD64",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNALootlogRefreshBtn:SetBackdropColor(0.8, 0.8, 0.8, 1)
DNALootlogRefreshBtn:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
--[==[
DNALootlogRefreshBtn:SetScript("OnEnter", function()
end)
DNALootlogRefreshBtn:SetScript("OnLeave", function()
end)
]==]--
DNALootlogRefreshBtn:SetScript("OnClick", function()
  refreshLootLogs()
end)
DNALootlogRefreshBtn:Hide()

local DNALootWindow_w = 300
local DNALootWindow_h = 250
local DNALootWindow_z = 500
DNALootWindow = CreateFrame("Frame", "DNALootWindow", UIParent)
DNALootWindow:SetWidth(DNALootWindow_w)
DNALootWindow:SetHeight(DNALootWindow_h)
DNALootWindow:SetPoint("CENTER", 200, 50)
DNALootWindow:SetFrameLevel(DNALootWindow_z)
DNALootWindow:SetBackdrop({
  edgeFile = DNAGlobal.border,
  edgeSize = 24,
  tile = true,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNALootWindow:Hide()
DNALootWindow.title = CreateFrame("Frame", nil, DNALootWindow)
DNALootWindow.title:SetWidth(DNALootWindow_w)
DNALootWindow.title:SetHeight(34)
DNALootWindow.title:SetPoint("TOPLEFT", 0, 5)
DNALootWindow.title:SetFrameLevel(DNALootWindow_z+1)
DNALootWindow.title:SetBackdrop({
  bgFile = DNAGlobal.backdrop,
  edgeFile = DNAGlobal.border,
  edgeSize = 24,
  tile = true,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNALootWindow.text = DNALootWindow.title:CreateFontString(nil, "ARTWORK")
DNALootWindow.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNALootWindow.text:SetPoint("TOPLEFT", 10, -10)
DNALootWindow.text:SetText("|cffe2dbbf" .. DNAGlobal.sub .. " Loot Options |cffdededev" .. DNAGlobal.version)

local DNALootWindowScrollFrame = {}
DNALootWindowScrollFrame = CreateFrame("Frame", DNALootWindowScrollFrame, DNALootWindow, "InsetFrameTemplate")
DNALootWindowScrollFrame:SetWidth(DNALootWindow_w-10)
DNALootWindowScrollFrame:SetHeight(DNALootWindow_h-32)
DNALootWindowScrollFrame:SetPoint("TOPLEFT", 5, -25)
--DNALootWindowScrollFrame:SetFrameLevel(5)
DNALootWindowScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNALootWindowScrollFrame, "UIPanelScrollFrameTemplate")
DNALootWindowScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNALootWindowScrollFrame, "TOPLEFT", 3, -3)
DNALootWindowScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNALootWindowScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNALootWindowScrollChildFrame = CreateFrame("Frame", DNALootWindowScrollChildFrame, DNALootWindowScrollFrame.ScrollFrame)
DNALootWindowScrollChildFrame:SetSize(DNALootWindow_w-10, DNALootWindow_h-32)
DNALootWindowScrollFrame.ScrollFrame:SetScrollChild(DNALootWindowScrollChildFrame)
DNALootWindowScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNALootWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNALootWindowScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNALootWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNALootWindowScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNALootWindowScrollFrame.MR = DNALootWindowScrollFrame:CreateTexture(nil, "BACKGROUND", DNALootlogScrollFrame, -2)
DNALootWindowScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNALootWindowScrollFrame.MR:SetPoint("TOPLEFT",  DNALootWindow_w-34, 0)
DNALootWindowScrollFrame.MR:SetSize(24,  DNALootWindow_h-32)
DNALootWindow:SetMovable(true)
DNALootWindow:EnableMouse(true)
DNALootWindow:RegisterForDrag("LeftButton")
DNALootWindow:SetScript("OnDragStart", function()
  DNALootWindow:StartMoving()
end)
DNALootWindow:SetScript("OnDragStop", function()
  DNALootWindow:StopMovingOrSizing()
  local point, relativeTo, relativePoint, xOfs, yOfs = DNALootWindow:GetPoint()
  DN:Debug("LW Pos: " .. point .. "," .. xOfs .. "," .. yOfs)
  DNA[player.combine]["CONFIG"]["LWPOS"] = point .. "," .. xOfs .. "," .. yOfs
end)

for i=1, MAX_CORPSE_ITEMS do
  DNAlootWindowItem[i] = {}
  DNAlootWindowItem[i] = DNALootWindowScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAlootWindowItem[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DNAlootWindowItem[i]:SetPoint("TOPLEFT", 5, -i*40+25)
  DNAlootWindowItem[i]:SetText("item " .. i)
  DNAlootWindowItem[i]:Hide()
  DNAlootWindowItemID[i] = {}
  DNAlootWindowItemID[i] = DNALootWindowScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAlootWindowItemID[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DNAlootWindowItemID[i]:SetPoint("TOPLEFT", 150, -i*40+25)
  DNAlootWindowItemID[i]:SetText("item " .. i)
  DNAlootWindowItemID[i]:Hide()
  DNAlootWindowItemQuality[i] = {}
  DNAlootWindowItemQuality[i] = DNALootWindowScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAlootWindowItemQuality[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DNAlootWindowItemQuality[i]:SetPoint("TOPLEFT", 150, -i*40+25)
  DNAlootWindowItemQuality[i]:SetText("")
  DNAlootWindowItemQuality[i]:Hide()

  DNAlootWindowItemBidBtn[i] = {}
  DNAlootWindowItemBidBtn[i] = CreateFrame("button", nil, DNALootWindowScrollChildFrame)
  DNAlootWindowItemBidBtn[i]:SetWidth(75)
  DNAlootWindowItemBidBtn[i]:SetHeight(25)
  DNAlootWindowItemBidBtn[i]:SetPoint("TOPLEFT", 190, -i*40+30)
  DNAlootWindowItemBidBtn[i]:SetBackdrop({
    bgFile = "Interface/Buttons/GREENGRAD64",
    edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize = 15,
    insets = {left=4, right=4, top=4, bottom=4},
  })
  DNAlootWindowItemBidBtn[i]:Hide()
  DNAlootWindowItemBidBtn[i].text = DNAlootWindowItemBidBtn[i]:CreateFontString(nil, "ARTWORK")
  DNAlootWindowItemBidBtn[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DNAlootWindowItemBidBtn[i].text:SetPoint("CENTER", 0, 0)
  DNAlootWindowItemBidBtn[i].text:SetText("Open Bid")
  DNAlootWindowItemBidBtn[i]:SetScript("OnClick", function()
    local _GitemID = DNAlootWindowID[i]:GetText()
    local _GitemName = DNAlootWindowItem[i]:GetText()
    local _GitemRarity = DNAlootWindowItemQuality[i]:GetText()
    --if (IsMasterLooter()) then
      if ((_GitemName) and (_GitemRarity)) then
        DN:Debug(_GitemNameID)
        DN:Debug(_GitemName)
        DN:Debug(_GitemRarity)
        DN:SendPacket(packetPrefix.openbid .. _GitemName .. "," .. _GitemRarity .. "," .. player.name .. "," .. 10, false)
      end
    --end
  end)

end

--DN:Debug("|cff9d9d9d|Hitem:22726::::::::80:|h[Splinter of Atiesh]|h|r")
--DN:Debug("|cff9d9d9d|Hitem:7073::::::::80:|h[Broken Fang]|h|r")

--local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(22726)
--DN:Debug("|cff9d9d9d|Hitem:22726::::::::80:|h[Splinter of Atiesh]|h|r")
--DN:Debug(itemLink)
