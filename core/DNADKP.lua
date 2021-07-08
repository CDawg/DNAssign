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

MAX_DKP_RECORDS = 800

local DNADKPScrollFrame_w = 400
local DNADKPScrollFrame_h = 500
local DNADKPScrollFrame = CreateFrame("Frame", DNADKPScrollFrame, page["DKP"], "InsetFrameTemplate")
DNADKPScrollFrame:SetWidth(DNADKPScrollFrame_w+20)
DNADKPScrollFrame:SetHeight(DNADKPScrollFrame_h)
DNADKPScrollFrame:SetPoint("TOPLEFT", 20, -60)
DNADKPScrollFrame:SetFrameLevel(5)
DNADKPScrollFrame.text = DNADKPScrollFrame:CreateFontString(nil, "ARTWORK")
DNADKPScrollFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize -1, "OUTLINE")
DNADKPScrollFrame.text:SetPoint("CENTER", DNADKPScrollFrame, "TOPLEFT", 100, 10)
--DNADKPScrollFrame.text:SetText("NAME | DKP | BONUS")
DNADKPScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNADKPScrollFrame, "UIPanelScrollFrameTemplate")
DNADKPScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNADKPScrollFrame, "TOPLEFT", 3, -3)
DNADKPScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNADKPScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNADKPScrollFrameScrollChildFrame = CreateFrame("Frame", DNADKPScrollFrameScrollChildFrame, DNADKPScrollFrame.ScrollFrame)
DNADKPScrollFrameScrollChildFrame:SetSize(DNADKPScrollFrame_w, DNADKPScrollFrame_h)
DNADKPScrollFrame.ScrollFrame:SetScrollChild(DNADKPScrollFrameScrollChildFrame)
DNADKPScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNADKPScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNADKPScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNADKPScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNADKPScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNADKPScrollFrame.MR = DNADKPScrollFrame:CreateTexture(nil, "BACKGROUND", DNADKPScrollFrame, -2)
DNADKPScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNADKPScrollFrame.MR:SetPoint("TOPLEFT", DNADKPScrollFrame_w-5, 0)
DNADKPScrollFrame.MR:SetSize(24, DNADKPScrollFrame_h)

local DNADKPDetailsFrame={}
local DNADKPMemberScrollFrame={}
local DNADKPDeleteLogBtn={}
local DNADKPExportLogBtn={}

local DKPLogDate = nil
local DKPLogName = nil
local DKPLogID = 0
local sortDKPName = {}

local DNADKPExportWindowScrollFrame_w = 250
local DNADKPExportWindowScrollFrame_h = 400
DNADKPExportWindow = CreateFrame("Frame", DNADKPExportWindow, UIParent, "BasicFrameTemplate")
DNADKPExportWindow:SetWidth(DNADKPExportWindowScrollFrame_w+50)
DNADKPExportWindow:SetHeight(DNADKPExportWindowScrollFrame_h+80)
DNADKPExportWindow:SetPoint("CENTER", 0, 100)
DNADKPExportWindow:SetFrameStrata("DIALOG")
DNADKPExportWindow.title = DNADKPExportWindow:CreateFontString(nil, "ARTWORK")
DNADKPExportWindow.title:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADKPExportWindow.title:SetPoint("TOPLEFT", DNADKPExportWindow, "TOPLEFT", 10, -6)
DNADKPExportWindow.title:SetText("DKP Export")
DNADKPExportWindow.text = DNADKPExportWindow:CreateFontString(nil, "ARTWORK")
DNADKPExportWindow.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADKPExportWindow.text:SetPoint("TOPLEFT", DNADKPExportWindow, "TOPLEFT", 30, -DNADKPExportWindowScrollFrame_h-35)
DNADKPExportWindow.text:SetText("Copy the data using CTRL+C")
DNADKPExportWindow:Hide()
DNADKPExportWindowScrollFrame = CreateFrame("Frame", DNADKPExportWindowScrollFrame, DNADKPExportWindow, "InsetFrameTemplate")
DNADKPExportWindowScrollFrame:SetWidth(DNADKPExportWindowScrollFrame_w+20)
DNADKPExportWindowScrollFrame:SetHeight(DNADKPExportWindowScrollFrame_h)
DNADKPExportWindowScrollFrame:SetPoint("TOPLEFT", 15, -30)
DNADKPExportWindowScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNADKPExportWindowScrollFrame, "UIPanelScrollFrameTemplate")
DNADKPExportWindowScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNADKPExportWindowScrollFrame, "TOPLEFT", 3, -3)
DNADKPExportWindowScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNADKPExportWindowScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNADKPExportWindowScrollFrameChildFrame = CreateFrame("Frame", DNADKPExportWindowScrollFrameChildFrame, DNADKPExportWindowScrollFrame.ScrollFrame)
DNADKPExportWindowScrollFrameChildFrame:SetSize(DNADKPExportWindowScrollFrame_w, DNADKPExportWindowScrollFrame_h)
DNADKPExportWindowScrollFrame.ScrollFrame:SetScrollChild(DNADKPExportWindowScrollFrameChildFrame)
DNADKPExportWindowScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNADKPExportWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNADKPExportWindowScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNADKPExportWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNADKPExportWindowScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNADKPExportWindowScrollFrame.MR = DNADKPExportWindowScrollFrame:CreateTexture(nil, "BACKGROUND", DNADKPExportWindowScrollFrame, -2)
DNADKPExportWindowScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNADKPExportWindowScrollFrame.MR:SetPoint("TOPLEFT", DNADKPExportWindowScrollFrame_w-5, 0)
DNADKPExportWindowScrollFrame.MR:SetSize(24, DNADKPExportWindowScrollFrame_h)
DNADKPExportWindow.data = CreateFrame("EditBox", nil, DNADKPExportWindowScrollFrameChildFrame)
DNADKPExportWindow.data:SetWidth(DNADKPExportWindowScrollFrame_w-10)
DNADKPExportWindow.data:SetHeight(20)
DNADKPExportWindow.data:SetFontObject(GameFontWhite)
DNADKPExportWindow.data:SetPoint("TOPLEFT", 5, 0)
DNADKPExportWindow.data:SetMultiLine(true)
DNADKPExportWindow.data:SetText("There was an error pulling the log")

-- export
local DNADKPlogCloseBtn = CreateFrame("Button", nil, DNADKPExportWindow, "UIPanelButtonTemplate")
DNADKPlogCloseBtn:SetSize(100, 24)
DNADKPlogCloseBtn:SetPoint("TOPLEFT", 100, -DNADKPExportWindowScrollFrame_h-52)
DNADKPlogCloseBtn.text = DNADKPlogCloseBtn:CreateFontString(nil, "ARTWORK")
DNADKPlogCloseBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADKPlogCloseBtn.text:SetPoint("CENTER", DNADKPlogCloseBtn, "CENTER", 0, 0)
DNADKPlogCloseBtn.text:SetText("Close")
DNADKPlogCloseBtn:SetScript('OnClick', function()
  DNADKPExportWindow:Hide()
end)

DNADKPExportLogBtn = CreateFrame("Button", nil, page["DKP"], "UIPanelButtonTemplate")
DNADKPExportLogBtn:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
DNADKPExportLogBtn:SetPoint("TOPLEFT", 680, -80)
DNADKPExportLogBtn:SetFrameLevel(5)
DNADKPExportLogBtn.text = DNADKPExportLogBtn:CreateFontString(nil, "ARTWORK")
DNADKPExportLogBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADKPExportLogBtn.text:SetPoint("CENTER", DNADKPExportLogBtn, "TOPLEFT", 68, -13)
DNADKPExportLogBtn.text:SetText("Export Log")
DNADKPExportLogBtn:SetScript("OnClick", function()
  DNADKPExportWindow:Show()
  if ((DKPLogDate) and (DKPLogName)) then
    DKPLogExportData = "DKP Log\n"
    DKPLogExportData = DKPLogExportData .. "Date: " .. DKPLogDate .. "\n"
    DKPLogExportData = DKPLogExportData .. "Raid: " .. DKPLogName .. "\n"
    if (table.getn(sortDKPName)) then
       DKPLogExportData = DKPLogExportData .. "Total: " .. table.getn(sortDKPName) .. "\n"
    end
    DKPLogExportData = DKPLogExportData .. "\n"
    for k,v in ipairs(sortDKPName) do
      DKPLogExportData = DKPLogExportData .. v .. "\n"
    end
    DKPLogExportData = DKPLogExportData .. "\n"
    DNADKPExportWindow.data:SetText(DKPLogExportData)
    DNADKPExportWindow.data:HighlightText()
  end
end)
DNADKPExportLogBtn:Hide()

--[==[
local DNADKPMemberScrollFrame_w = 200
local DNADKPMemberScrollFrame_h = 410
DNADKPDetailsFrame = CreateFrame("Frame", DNADKPDetailsFrame, page["DKP"], "InsetFrameTemplate")
DNADKPDetailsFrame:SetWidth(DNADKPMemberScrollFrame_w+20)
DNADKPDetailsFrame:SetHeight(80)
DNADKPDetailsFrame:SetPoint("TOPLEFT", 450, -50)
DNADKPDetailsFrame.date = DNADKPDetailsFrame:CreateFontString(nil, "ARTWORK")
DNADKPDetailsFrame.date:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADKPDetailsFrame.date:SetPoint("TOPLEFT", 10, -10)
DNADKPDetailsFrame.date:SetText("Select an DKP log")
DNADKPDetailsFrame.instance = DNADKPDetailsFrame:CreateFontString(nil, "ARTWORK")
DNADKPDetailsFrame.instance:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADKPDetailsFrame.instance:SetPoint("TOPLEFT", 10, -30)
DNADKPDetailsFrame.instance:SetText("")
DNADKPDetailsFrame.count = DNADKPDetailsFrame:CreateFontString(nil, "ARTWORK")
DNADKPDetailsFrame.count:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADKPDetailsFrame.count:SetPoint("TOPLEFT", 10, -50)
DNADKPDetailsFrame.count:SetText("")
DNADKPDetailsFrame:Hide()
]==]--

--local DKPLogMemberUpdate={}
--local DKPLogMemberUpdateText={}

DKPLogColumn={}
DKPLogColumn["name"] = CreateFrame("Button", "DKPLogColumn", DNADKPScrollFrame, "BackdropTemplate")
DKPLogColumn["name"]:SetWidth(140)
DKPLogColumn["name"]:SetHeight(30)
DKPLogColumn["name"]:SetPoint("TOPLEFT", 2, 0)
DKPLogColumn["name"]:SetFrameLevel(15)
DKPLogColumn["name"]:SetBackdrop({
  bgFile = "Interface/HELPFRAME/DarkSandstone-Tile",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DKPLogColumn["name"]:SetBackdropColor(1,1,1,1)
DKPLogColumn["name"]:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
DKPLogColumn["name"].text = DKPLogColumn["name"]:CreateFontString(nil, "ARTWORK")
DKPLogColumn["name"].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DKPLogColumn["name"].text:SetPoint("CENTER", 0, 0)
DKPLogColumn["name"].text:SetText("Name")
DKPLogColumn["name"]:SetScript('OnClick', function()
  SortGuildRoster("name")
end)
DKPLogColumn["name"]:SetScript('OnEnter', function(self)
  self:SetBackdropBorderColor(1, 1, 0.8, 1)
end)
DKPLogColumn["name"]:SetScript('OnLeave', function(self)
  self:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
end)

DKPLogColumn["dkp"] = CreateFrame("Button", "DKPLogColumn", DNADKPScrollFrame, "BackdropTemplate")
DKPLogColumn["dkp"]:SetWidth(60)
DKPLogColumn["dkp"]:SetHeight(30)
DKPLogColumn["dkp"]:SetPoint("TOPLEFT", 140, 0)
DKPLogColumn["dkp"]:SetFrameLevel(15)
DKPLogColumn["dkp"]:SetBackdrop({
  bgFile = "Interface/HELPFRAME/DarkSandstone-Tile",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DKPLogColumn["dkp"]:SetBackdropColor(1, 1, 1, 1)
DKPLogColumn["dkp"]:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
DKPLogColumn["dkp"].text = DKPLogColumn["dkp"]:CreateFontString(nil, "ARTWORK")
DKPLogColumn["dkp"].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DKPLogColumn["dkp"].text:SetPoint("CENTER", 0, 0)
DKPLogColumn["dkp"].text:SetText("DKP")

DKPLogColumn["bonus"] = CreateFrame("Button", "DKPLogColumn", DNADKPScrollFrame, "BackdropTemplate")
DKPLogColumn["bonus"]:SetWidth(60)
DKPLogColumn["bonus"]:SetHeight(30)
DKPLogColumn["bonus"]:SetPoint("TOPLEFT", 198, 0)
DKPLogColumn["bonus"]:SetFrameLevel(15)
DKPLogColumn["bonus"]:SetBackdrop({
  bgFile = "Interface/HELPFRAME/DarkSandstone-Tile",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DKPLogColumn["bonus"]:SetBackdropColor(1,1,1,1)
DKPLogColumn["bonus"]:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
DKPLogColumn["bonus"].text = DKPLogColumn["bonus"]:CreateFontString(nil, "ARTWORK")
DKPLogColumn["bonus"].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DKPLogColumn["bonus"].text:SetPoint("CENTER", 0, 0)
DKPLogColumn["bonus"].text:SetText("Bonus")

DKPLogColumn["total"] = CreateFrame("Button", "DKPLogColumn", DNADKPScrollFrame, "BackdropTemplate")
DKPLogColumn["total"]:SetWidth(60)
DKPLogColumn["total"]:SetHeight(30)
DKPLogColumn["total"]:SetPoint("TOPLEFT", 256, 0)
DKPLogColumn["total"]:SetFrameLevel(15)
DKPLogColumn["total"]:SetBackdrop({
  bgFile = "Interface/HELPFRAME/DarkSandstone-Tile",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DKPLogColumn["total"]:SetBackdropColor(1,1,1,1)
DKPLogColumn["total"]:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
DKPLogColumn["total"].text = DKPLogColumn["total"]:CreateFontString(nil, "ARTWORK")
DKPLogColumn["total"].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DKPLogColumn["total"].text:SetPoint("CENTER", 0, 0)
DKPLogColumn["total"].text:SetText("Total")

DKPLogColumn["blank"] = CreateFrame("Button", "DKPLogColumn", DNADKPScrollFrame, "BackdropTemplate")
DKPLogColumn["blank"]:SetWidth(86)
DKPLogColumn["blank"]:SetHeight(30)
DKPLogColumn["blank"]:SetPoint("TOPLEFT", 313, 0)
DKPLogColumn["blank"]:SetFrameLevel(15)
DKPLogColumn["blank"]:SetBackdrop({
  bgFile = "Interface/HELPFRAME/DarkSandstone-Tile",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DKPLogColumn["blank"]:SetBackdropColor(1,1,1,1)
DKPLogColumn["blank"]:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
DKPLogColumn["blank"].text = DKPLogColumn["blank"]:CreateFontString(nil, "ARTWORK")
DKPLogColumn["blank"].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DKPLogColumn["blank"].text:SetPoint("CENTER", 0, 0)
DKPLogColumn["blank"].text:SetText("")

for i=1, MAX_DKP_RECORDS do
  DKPLogMember[i] = CreateFrame("Button", DKPLogMember[i], DNADKPScrollFrameScrollChildFrame, "BackdropTemplate")
  DKPLogMember[i]:SetWidth(DNADKPScrollFrame_w-5)
  DKPLogMember[i]:SetHeight(raidSlot_h)
  DKPLogMember[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  DKPLogMember[i]:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.6)
  DKPLogMember[i]:SetPoint("TOPLEFT", 0, (-i*18)+raidSlot_h-12)
  DKPLogMember[i]:SetScript('OnEnter', function()
    DKPLogMember[i]:SetBackdropBorderColor(1, 1, 0.4, 1)
  end)
  DKPLogMember[i]:SetScript('OnLeave', function()
    DKPLogMember[i]:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.6)
  end)
  DKPLogMember[i]:SetBackdropColor(0.4, 0.4, 0.4, 1)
  DKPLogMemberName[i] = DKPLogMember[i]:CreateFontString(nil, "ARTWORK")
  DKPLogMemberName[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DKPLogMemberName[i]:SetPoint("TOPLEFT", 5, -4)
  DKPLogMemberName[i]:SetText("")
  DKPLogMemberName[i]:SetTextColor(0.4, 0.4, 0.4, 1)
  DKPLogMemberDKP[i] = DKPLogMember[i]:CreateFontString(nil, "ARTWORK")
  DKPLogMemberDKP[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DKPLogMemberDKP[i]:SetPoint("TOPLEFT", 160, -4)
  DKPLogMemberDKP[i]:SetText(0)
  DKPLogMemberDKPB[i] = DKPLogMember[i]:CreateFontString(nil, "ARTWORK")
  DKPLogMemberDKPB[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DKPLogMemberDKPB[i]:SetPoint("TOPLEFT", 220, -4)
  DKPLogMemberDKPB[i]:SetText(0)
  DKPLogMemberDKPT[i] = DKPLogMember[i]:CreateFontString(nil, "ARTWORK")
  DKPLogMemberDKPT[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  DKPLogMemberDKPT[i]:SetPoint("TOPLEFT", 276, -4)
  DKPLogMemberDKPT[i]:SetText(0)
  DKPLogMemberDKPT[i]:SetTextColor(0.5, 1, 0.5, 1)
  DKPLogMember[i]:Hide()

  --[==[
  DKPLogMemberUpdate[i] = CreateFrame("Button", DKPLogMember[i], DNADKPScrollFrameScrollChildFrame)
  DKPLogMemberUpdate[i]:SetWidth(50)
  DKPLogMemberUpdate[i]:SetHeight(raidSlot_h)
  DKPLogMemberUpdate[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  DKPLogMemberUpdate[i]:SetBackdropColor(0, 1, 0, 1)
  DKPLogMemberUpdate[i]:SetBackdropBorderColor(0.8, 1, 0.8, 1)
  DKPLogMemberUpdate[i]:SetPoint("TOPLEFT", 280, (-i*18)+raidSlot_h-4)
  DKPLogMemberUpdateText[i] = DKPLogMemberUpdate[i]:CreateFontString(nil, "ARTWORK")
  DKPLogMemberUpdateText[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  DKPLogMemberUpdateText[i]:SetPoint("CENTER", 0, 0)
  DKPLogMemberUpdateText[i]:SetText("Update")
  ]==]--
end

--[==[
function setDKPSlotMemberFrame(i, member, class)
  if (DKPLogMemberName[i]) then
    DKPLogMemberNameText[i]:SetText(member)
    DKPLogMemberName[i]:Show()
    if (class) then
      DN:ClassColorText(DKPLogMemberNameText[i], class)
    end
    DKPLogMemberNameInvite[i]:Show()
    local thisMember = DKPLogMemberNameText[i]:GetText()
    if (thisMember == player.name) then
      DKPLogMemberNameInvite[i]:Hide()
    end
  end
end
]==]--

local guildLoad = 1
function DN:GetGuildDKP()
  guildLoad = guildLoad+1
  local DKPPacketString = ""
  if (guildLoad >= 3) then
    local guildCount = 1
    for i=1, GetNumGuildMembers() do
      --local name, rank, rankIndex, level, class, zone = GetGuildRosterInfo(i)
      local name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(i)
      if (rankIndex <= 6) then
        guildCount = guildCount +1
        local guild_member = split(name, "-")
        DKPLogMemberName[guildCount]:SetText(guild_member[1])
        DN:ClassColorText(DKPLogMemberName[guildCount], "Offline")
        if (online) then
          DN:ClassColorText(DKPLogMemberName[guildCount], class)
        end
        DKPLogMemberDKP[guildCount]:SetText("0")
        DKPLogMember[guildCount]:Show()
        DKPLogMember[guildCount]:SetBackdropColor(0.4, 0.4, 0.4, 1)
        if (guild_member[1] == player.name) then
          DKPLogMember[guildCount]:SetBackdropColor(1, 1, 1, 1)
        end
      end
    end
    --print("DNA: guildLoadDKP")
  end
end
