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

local DNAAttendanceScrollFrame_w = 200
local DNAAttendanceScrollFrame_h = 500

local DNAAttendanceScrollFrame = CreateFrame("Frame", DNAAttendanceScrollFrame, page["Attendance"], "InsetFrameTemplate")
DNAAttendanceScrollFrame:SetWidth(DNAAttendanceScrollFrame_w+20)
DNAAttendanceScrollFrame:SetHeight(DNAAttendanceScrollFrame_h)
DNAAttendanceScrollFrame:SetPoint("TOPLEFT", 220, -50)
DNAAttendanceScrollFrame:SetFrameLevel(5)
DNAAttendanceScrollFrame.text = DNAAttendanceScrollFrame:CreateFontString(nil, "ARTWORK")
DNAAttendanceScrollFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceScrollFrame.text:SetPoint("CENTER", DNAAttendanceScrollFrame, "TOPLEFT", 100, 10)
DNAAttendanceScrollFrame.text:SetText("ATTENDANCE LOGS")
DNAAttendanceScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAAttendanceScrollFrame, "UIPanelScrollFrameTemplate")
DNAAttendanceScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNAAttendanceScrollFrame, "TOPLEFT", 3, -3)
DNAAttendanceScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAAttendanceScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNAAttendanceScrollFrameScrollChildFrame = CreateFrame("Frame", DNAAttendanceScrollFrameScrollChildFrame, DNAAttendanceScrollFrame.ScrollFrame)
DNAAttendanceScrollFrameScrollChildFrame:SetSize(DNAAttendanceScrollFrame_w, DNAAttendanceScrollFrame_h)
DNAAttendanceScrollFrame.ScrollFrame:SetScrollChild(DNAAttendanceScrollFrameScrollChildFrame)
DNAAttendanceScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNAAttendanceScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAAttendanceScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNAAttendanceScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAAttendanceScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNAAttendanceScrollFrame.MR = DNAAttendanceScrollFrame:CreateTexture(nil, "BACKGROUND", DNAAttendanceScrollFrame, -2)
DNAAttendanceScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAAttendanceScrollFrame.MR:SetPoint("TOPLEFT", DNAAttendanceScrollFrame_w-5, 0)
DNAAttendanceScrollFrame.MR:SetSize(24, DNAAttendanceScrollFrame_h)

local DNADeleteAllAttendancePrompt = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
DNADeleteAllAttendancePrompt:SetWidth(450)
DNADeleteAllAttendancePrompt:SetHeight(100)
DNADeleteAllAttendancePrompt:SetPoint("CENTER", 0, 50)
DNADeleteAllAttendancePrompt:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = DNAGlobal.border,
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNADeleteAllAttendancePrompt.text = DNADeleteAllAttendancePrompt:CreateFontString(nil, "ARTWORK")
DNADeleteAllAttendancePrompt.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteAllAttendancePrompt.text:SetPoint("CENTER", DNADeleteAllAttendancePrompt, "CENTER", 0, 20)
DNADeleteAllAttendancePrompt.text:SetText("Delete all Attendance logs?\nThis will delete all attendance logs account wide and reload.")
DNADeleteAllAttendancePrompt:SetFrameLevel(150)
DNADeleteAllAttendancePrompt:SetFrameStrata("FULLSCREEN_DIALOG")

local DNADeleteAllAttendancePromptYes = CreateFrame("Button", nil, DNADeleteAllAttendancePrompt, "BackdropTemplate")
DNADeleteAllAttendancePromptYes:SetPoint("CENTER", 80, -20)
DNADeleteAllAttendancePromptYes.text = DNADeleteAllAttendancePromptYes:CreateFontString(nil, "ARTWORK")
DNADeleteAllAttendancePromptYes.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteAllAttendancePromptYes.text:SetPoint("CENTER", DNADeleteAllAttendancePromptYes, "CENTER", 0, 0)
DNADeleteAllAttendancePromptYes.text:SetText("Yes")
DN:ButtonFrame(DNADeleteAllAttendancePromptYes, "red")
DNADeleteAllAttendancePromptYes:SetScript('OnClick', function()
  for i=1, numAttendanceLogs do
    attendanceLogSlot[i]:Hide()
  end
  DNA["ATTENDANCE"] = {}
  ReloadUI()
end)
local DNADeleteAllAttendancePromptNo = CreateFrame("Button", nil, DNADeleteAllAttendancePrompt, "BackdropTemplate")
DNADeleteAllAttendancePromptNo:SetPoint("CENTER", -80, -20)
DNADeleteAllAttendancePromptNo.text = DNADeleteAllAttendancePromptNo:CreateFontString(nil, "ARTWORK")
DNADeleteAllAttendancePromptNo.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteAllAttendancePromptNo.text:SetPoint("CENTER", DNADeleteAllAttendancePromptNo, "CENTER", 0, 0)
DNADeleteAllAttendancePromptNo.text:SetText("No")
DN:ButtonFrame(DNADeleteAllAttendancePromptNo, "red")
DNADeleteAllAttendancePromptNo:SetScript('OnClick', function()
  DNADeleteAllAttendancePrompt:Hide()
end)
DNADeleteAllAttendancePrompt:Hide()

DNAAttendanceDeleteAllBtn = CreateFrame("Button", nil, DNAAttendanceScrollFrame, "BackdropTemplate")
DNAAttendanceDeleteAllBtn:SetPoint("TOPLEFT", 35, -DNAAttendanceScrollFrame_h-5)
DNAAttendanceDeleteAllBtn:SetFrameLevel(5)
DNAAttendanceDeleteAllBtn.text = DNAAttendanceDeleteAllBtn:CreateFontString(nil, "ARTWORK")
DNAAttendanceDeleteAllBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceDeleteAllBtn.text:SetPoint("CENTER", DNAAttendanceDeleteAllBtn)
DNAAttendanceDeleteAllBtn.text:SetText("Delete All Logs")
DN:ButtonFrame(DNAAttendanceDeleteAllBtn, "red")
DNAAttendanceDeleteAllBtn:SetScript("OnClick", function()
  DNADeleteAllAttendancePrompt:Show()
end)
DNAAttendanceDeleteAllBtn:Hide()

local DNAAttendanceDetailsFrame={}
local DNAAttendanceMemberScrollFrame={}
local DNAAttendanceDeleteLogBtn={}
local DNAAttendanceExportLogBtn={}

local attendanceLogDate = nil
local attendanceLogName = nil
local attendanceLogID = 0
local sortAttendanceName = {}
local DNADeleteSingleAttendancePrompt = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
DNADeleteSingleAttendancePrompt:SetWidth(450)
DNADeleteSingleAttendancePrompt:SetHeight(100)
DNADeleteSingleAttendancePrompt:SetPoint("CENTER", 0, 50)
DNADeleteSingleAttendancePrompt:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = DNAGlobal.border,
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNADeleteSingleAttendancePrompt.text = DNADeleteSingleAttendancePrompt:CreateFontString(nil, "ARTWORK")
DNADeleteSingleAttendancePrompt.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteSingleAttendancePrompt.text:SetPoint("CENTER", DNADeleteSingleAttendancePrompt, "CENTER", 0, 20)
DNADeleteSingleAttendancePrompt.text:SetText("Delete Attendance Log?")
DNADeleteSingleAttendancePrompt:SetFrameLevel(150)
DNADeleteSingleAttendancePrompt:SetFrameStrata("FULLSCREEN_DIALOG")

local DNADeleteSingleAttendancePromptYes = CreateFrame("Button", nil, DNADeleteSingleAttendancePrompt, "BackdropTemplate")
DNADeleteSingleAttendancePromptYes:SetPoint("CENTER", 80, -20)
DNADeleteSingleAttendancePromptYes.text = DNADeleteSingleAttendancePromptYes:CreateFontString(nil, "ARTWORK")
DNADeleteSingleAttendancePromptYes.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteSingleAttendancePromptYes.text:SetPoint("CENTER", DNADeleteSingleAttendancePromptYes, "CENTER", 0, 0)
DNADeleteSingleAttendancePromptYes.text:SetText("Yes")
DN:ButtonFrame(DNADeleteSingleAttendancePromptYes, "red")
DNADeleteSingleAttendancePromptYes:SetScript('OnClick', function()
  if ((attendanceLogDate) and (attendanceLogName)) then
    DNA["ATTENDANCE"][attendanceLogDate][attendanceLogName] = nil
  end
  if (attendanceLogID ~= 0) then
    attendanceLogSlot[attendanceLogID]:Hide()
  end
  DNADeleteSingleAttendancePrompt:Hide()
  DNAAttendanceDetailsFrame:Hide()
  DNAAttendanceMemberScrollFrame:Hide()
  DNAAttendanceDeleteLogBtn:Hide()
  DNAAttendanceExportLogBtn:Hide()
end)
local DNADeleteSingleAttendancePromptNo = CreateFrame("Button", nil, DNADeleteSingleAttendancePrompt, "BackdropTemplate")
DNADeleteSingleAttendancePromptNo:SetPoint("CENTER", -80, -20)
DNADeleteSingleAttendancePromptNo.text = DNADeleteSingleAttendancePromptNo:CreateFontString(nil, "ARTWORK")
DNADeleteSingleAttendancePromptNo.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNADeleteSingleAttendancePromptNo.text:SetPoint("CENTER", DNADeleteSingleAttendancePromptNo, "CENTER", 0, 0)
DNADeleteSingleAttendancePromptNo.text:SetText("No")
DN:ButtonFrame(DNADeleteSingleAttendancePromptNo, "red")
DNADeleteSingleAttendancePromptNo:SetScript('OnClick', function()
  DNADeleteSingleAttendancePrompt:Hide()
end)
DNADeleteSingleAttendancePrompt:Hide()

DNAAttendanceDeleteLogBtn = CreateFrame("Button", nil, page["Attendance"], "BackdropTemplate")
DNAAttendanceDeleteLogBtn:SetPoint("TOPLEFT", 680, -50)
DNAAttendanceDeleteLogBtn:SetFrameLevel(5)
DNAAttendanceDeleteLogBtn.text = DNAAttendanceDeleteLogBtn:CreateFontString(nil, "ARTWORK")
DNAAttendanceDeleteLogBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceDeleteLogBtn.text:SetPoint("CENTER", DNAAttendanceDeleteLogBtn)
DNAAttendanceDeleteLogBtn.text:SetText("Delete Log")
DN:ButtonFrame(DNAAttendanceDeleteLogBtn, "red")
DNAAttendanceDeleteLogBtn:SetScript("OnClick", function()
  if ((attendanceLogDate) and (attendanceLogName))then
    DN:Debug(attendanceLogDate)
    DN:Debug(attendanceLogName)
  end
  DNADeleteSingleAttendancePrompt.text:SetText("Delete Attendance log:\n|cfff2c983" .. attendanceLogDate .. " " ..  attendanceLogName .. "|cffffffff?")
  DNADeleteSingleAttendancePrompt:Show()
end)
DNAAttendanceDeleteLogBtn:Hide()

local DNAAttendanceExportWindowScrollFrame_w = 250
local DNAAttendanceExportWindowScrollFrame_h = 400
DNAAttendanceExportWindow = CreateFrame("Frame", DNAAttendanceExportWindow, UIParent, "BasicFrameTemplate")
DNAAttendanceExportWindow:SetWidth(DNAAttendanceExportWindowScrollFrame_w+50)
DNAAttendanceExportWindow:SetHeight(DNAAttendanceExportWindowScrollFrame_h+80)
DNAAttendanceExportWindow:SetPoint("CENTER", 0, 100)
DNAAttendanceExportWindow:SetFrameStrata("DIALOG")
DNAAttendanceExportWindow.title = DNAAttendanceExportWindow:CreateFontString(nil, "ARTWORK")
DNAAttendanceExportWindow.title:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceExportWindow.title:SetPoint("TOPLEFT", DNAAttendanceExportWindow, "TOPLEFT", 10, -6)
DNAAttendanceExportWindow.title:SetText("Attendance Export")
DNAAttendanceExportWindow.text = DNAAttendanceExportWindow:CreateFontString(nil, "ARTWORK")
DNAAttendanceExportWindow.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceExportWindow.text:SetPoint("TOPLEFT", DNAAttendanceExportWindow, "TOPLEFT", 30, -DNAAttendanceExportWindowScrollFrame_h-35)
DNAAttendanceExportWindow.text:SetText("Copy the data using CTRL+C")
DNAAttendanceExportWindow:Hide()
DNAAttendanceExportWindowScrollFrame = CreateFrame("Frame", DNAAttendanceExportWindowScrollFrame, DNAAttendanceExportWindow, "InsetFrameTemplate")
DNAAttendanceExportWindowScrollFrame:SetWidth(DNAAttendanceExportWindowScrollFrame_w+20)
DNAAttendanceExportWindowScrollFrame:SetHeight(DNAAttendanceExportWindowScrollFrame_h)
DNAAttendanceExportWindowScrollFrame:SetPoint("TOPLEFT", 15, -30)
DNAAttendanceExportWindowScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAAttendanceExportWindowScrollFrame, "UIPanelScrollFrameTemplate")
DNAAttendanceExportWindowScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNAAttendanceExportWindowScrollFrame, "TOPLEFT", 3, -3)
DNAAttendanceExportWindowScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAAttendanceExportWindowScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNAAttendanceExportWindowScrollFrameChildFrame = CreateFrame("Frame", DNAAttendanceExportWindowScrollFrameChildFrame, DNAAttendanceExportWindowScrollFrame.ScrollFrame)
DNAAttendanceExportWindowScrollFrameChildFrame:SetSize(DNAAttendanceExportWindowScrollFrame_w, DNAAttendanceExportWindowScrollFrame_h)
DNAAttendanceExportWindowScrollFrame.ScrollFrame:SetScrollChild(DNAAttendanceExportWindowScrollFrameChildFrame)
DNAAttendanceExportWindowScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNAAttendanceExportWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAAttendanceExportWindowScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNAAttendanceExportWindowScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAAttendanceExportWindowScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNAAttendanceExportWindowScrollFrame.MR = DNAAttendanceExportWindowScrollFrame:CreateTexture(nil, "BACKGROUND", DNAAttendanceExportWindowScrollFrame, -2)
DNAAttendanceExportWindowScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAAttendanceExportWindowScrollFrame.MR:SetPoint("TOPLEFT", DNAAttendanceExportWindowScrollFrame_w-5, 0)
DNAAttendanceExportWindowScrollFrame.MR:SetSize(24, DNAAttendanceExportWindowScrollFrame_h)
DNAAttendanceExportWindow.data = CreateFrame("EditBox", nil, DNAAttendanceExportWindowScrollFrameChildFrame)
DNAAttendanceExportWindow.data:SetWidth(DNAAttendanceExportWindowScrollFrame_w-10)
DNAAttendanceExportWindow.data:SetHeight(20)
DNAAttendanceExportWindow.data:SetFontObject(GameFontWhite)
DNAAttendanceExportWindow.data:SetPoint("TOPLEFT", 5, 0)
DNAAttendanceExportWindow.data:SetMultiLine(true)
DNAAttendanceExportWindow.data:SetText("There was an error pulling the log")

local DNAAttendancelogCloseBtn = CreateFrame("Button", nil, DNAAttendanceExportWindow, "BackdropTemplate")
DNAAttendancelogCloseBtn:SetPoint("TOPLEFT", 80, -DNAAttendanceExportWindowScrollFrame_h-52)
DNAAttendancelogCloseBtn.text = DNAAttendancelogCloseBtn:CreateFontString(nil, "ARTWORK")
DNAAttendancelogCloseBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendancelogCloseBtn.text:SetPoint("CENTER", DNAAttendancelogCloseBtn, "CENTER", 0, 0)
DNAAttendancelogCloseBtn.text:SetText("Close")
DN:ButtonFrame(DNAAttendancelogCloseBtn, "red")
DNAAttendancelogCloseBtn:SetScript('OnClick', function()
  DNAAttendanceExportWindow:Hide()
end)

DNAAttendanceExportLogBtn = CreateFrame("Button", nil, page["Attendance"], "BackdropTemplate")
DNAAttendanceExportLogBtn:SetPoint("TOPLEFT", 680, -80)
DNAAttendanceExportLogBtn:SetFrameLevel(5)
DNAAttendanceExportLogBtn.text = DNAAttendanceExportLogBtn:CreateFontString(nil, "ARTWORK")
DNAAttendanceExportLogBtn.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceExportLogBtn.text:SetPoint("CENTER", DNAAttendanceExportLogBtn)
DNAAttendanceExportLogBtn.text:SetText("Export Log")
DN:ButtonFrame(DNAAttendanceExportLogBtn, "red")
DNAAttendanceExportLogBtn:SetScript("OnClick", function()
  DNAAttendanceExportWindow:Show()
  if ((attendanceLogDate) and (attendanceLogName)) then
    attendanceLogExportData = "Attendance Log\n"
    attendanceLogExportData = attendanceLogExportData .. "Date: " .. attendanceLogDate .. "\n"
    attendanceLogExportData = attendanceLogExportData .. "Raid: " .. attendanceLogName .. "\n"
    if (table.getn(sortAttendanceName)) then
       attendanceLogExportData = attendanceLogExportData .. "Total: " .. table.getn(sortAttendanceName) .. "\n"
    end
    attendanceLogExportData = attendanceLogExportData .. "\n"
    for k,v in ipairs(sortAttendanceName) do
      attendanceLogExportData = attendanceLogExportData .. v .. "\n"
    end
    attendanceLogExportData = attendanceLogExportData .. "\n"
    DNAAttendanceExportWindow.data:SetText(attendanceLogExportData)
    DNAAttendanceExportWindow.data:HighlightText()
  end
end)
DNAAttendanceExportLogBtn:Hide()

local DNAAttendanceMemberScrollFrame_w = 200
local DNAAttendanceMemberScrollFrame_h = 410
DNAAttendanceDetailsFrame = CreateFrame("Frame", DNAAttendanceDetailsFrame, page["Attendance"], "InsetFrameTemplate")
DNAAttendanceDetailsFrame:SetWidth(DNAAttendanceMemberScrollFrame_w+20)
DNAAttendanceDetailsFrame:SetHeight(80)
DNAAttendanceDetailsFrame:SetPoint("TOPLEFT", 450, -50)
DNAAttendanceDetailsFrame.date = DNAAttendanceDetailsFrame:CreateFontString(nil, "ARTWORK")
DNAAttendanceDetailsFrame.date:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceDetailsFrame.date:SetPoint("TOPLEFT", 10, -10)
DNAAttendanceDetailsFrame.date:SetText("Select an attendance log")
DNAAttendanceDetailsFrame.instance = DNAAttendanceDetailsFrame:CreateFontString(nil, "ARTWORK")
DNAAttendanceDetailsFrame.instance:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceDetailsFrame.instance:SetPoint("TOPLEFT", 10, -30)
DNAAttendanceDetailsFrame.instance:SetText("")
DNAAttendanceDetailsFrame.count = DNAAttendanceDetailsFrame:CreateFontString(nil, "ARTWORK")
DNAAttendanceDetailsFrame.count:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAAttendanceDetailsFrame.count:SetPoint("TOPLEFT", 10, -50)
DNAAttendanceDetailsFrame.count:SetText("")
DNAAttendanceDetailsFrame:Hide()

DNAAttendanceMemberScrollFrame = CreateFrame("Frame", DNAAttendanceMemberScrollFrame, page["Attendance"], "InsetFrameTemplate")
DNAAttendanceMemberScrollFrame:SetWidth(DNAAttendanceMemberScrollFrame_w+20)
DNAAttendanceMemberScrollFrame:SetHeight(DNAAttendanceMemberScrollFrame_h)
DNAAttendanceMemberScrollFrame:SetPoint("TOPLEFT", 450, -140)
DNAAttendanceMemberScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAAttendanceMemberScrollFrame, "UIPanelScrollFrameTemplate")
DNAAttendanceMemberScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNAAttendanceMemberScrollFrame, "TOPLEFT", 3, -3)
DNAAttendanceMemberScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAAttendanceMemberScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNAAttendanceMemberScrollFrameChildFrame = CreateFrame("Frame", DNAAttendanceMemberScrollFrameChildFrame, DNAAttendanceMemberScrollFrame.ScrollFrame)
DNAAttendanceMemberScrollFrameChildFrame:SetSize(DNAAttendanceMemberScrollFrame_w, DNAAttendanceMemberScrollFrame_h)
DNAAttendanceMemberScrollFrame.ScrollFrame:SetScrollChild(DNAAttendanceMemberScrollFrameChildFrame)
DNAAttendanceMemberScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNAAttendanceMemberScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAAttendanceMemberScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNAAttendanceMemberScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAAttendanceMemberScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNAAttendanceMemberScrollFrame.MR = DNAAttendanceMemberScrollFrame:CreateTexture(nil, "BACKGROUND", DNAAttendanceMemberScrollFrame, -2)
DNAAttendanceMemberScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAAttendanceMemberScrollFrame.MR:SetPoint("TOPLEFT", DNAAttendanceMemberScrollFrame_w-5, 0)
DNAAttendanceMemberScrollFrame.MR:SetSize(24, DNAAttendanceMemberScrollFrame_h)
DNAAttendanceMemberScrollFrame:Hide()

local attendanceLogMemberSlot={}
local attendanceLogMemberSlotInvite={}
local attendanceLogMemberSlotText={}

--just create the 80 frames, then occupy data into them
for i=1, MAX_RAID_MEMBERS*2 do
  attendanceLogMemberSlot[i] = {}
  attendanceLogMemberSlot[i] = CreateFrame("button", attendanceLogMemberSlot[i], DNAAttendanceMemberScrollFrameChildFrame, "BackdropTemplate")
  attendanceLogMemberSlot[i]:SetWidth(DNAAttendanceMemberScrollFrame_w-5)
  attendanceLogMemberSlot[i]:SetHeight(raidSlot_h)
  attendanceLogMemberSlot[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  attendanceLogMemberSlot[i]:SetBackdropColor(1, 1, 1, 0.6)
  attendanceLogMemberSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  attendanceLogMemberSlot[i]:SetPoint("TOPLEFT", 0, (-i*18)+raidSlot_h-4)
  attendanceLogMemberSlotText[i] = {}
  attendanceLogMemberSlotText[i] = attendanceLogMemberSlot[i]:CreateFontString(nil, "ARTWORK")
  attendanceLogMemberSlotText[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  attendanceLogMemberSlotText[i]:SetPoint("TOPLEFT", 5, -4)
  attendanceLogMemberSlotText[i]:SetText("")
  attendanceLogMemberSlotInvite[i] = CreateFrame("button", attendanceLogMemberSlotInvite[i], attendanceLogMemberSlot[i], "BackdropTemplate")
  attendanceLogMemberSlotInvite[i]:SetWidth(80)
  attendanceLogMemberSlotInvite[i]:SetHeight(raidSlot_h)
  attendanceLogMemberSlotInvite[i]:SetPoint("TOPLEFT", 114, 0)
  attendanceLogMemberSlotInvite[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  attendanceLogMemberSlotInvite[i]:SetBackdropBorderColor(0.5, 1, 0.7, 0.60)
  attendanceLogMemberSlotInvite[i]:SetBackdropColor(0.3, 1, 0.9, 1)
  attendanceLogMemberSlotInvite[i].text = attendanceLogMemberSlotInvite[i]:CreateFontString(nil, "ARTWORK")
  attendanceLogMemberSlotInvite[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  attendanceLogMemberSlotInvite[i].text:SetPoint("CENTER", 2, 1)
  attendanceLogMemberSlotInvite[i].text:SetText("Reinvite")
  attendanceLogMemberSlotInvite[i]:SetScript('OnEnter', function()
    attendanceLogMemberSlotInvite[i]:SetBackdropBorderColor(0.3, 1, 0.8, 1)
  end)
  attendanceLogMemberSlotInvite[i]:SetScript('OnLeave', function()
    attendanceLogMemberSlotInvite[i]:SetBackdropBorderColor(0.5, 1, 0.7, 0.60)
  end)
  attendanceLogMemberSlotInvite[i]:Hide()
  attendanceLogMemberSlotInvite[i]:SetScript('OnClick', function()
    local thisMember = attendanceLogMemberSlotText[i]:GetText()
    InviteUnit(thisMember)
    if (IsInRaid()) then
      DN:ChatNotification("Invited " .. thisMember .. " to Raid.")
    else
      DN:ChatNotification("Converted to Raid.")
      ConvertToRaid()
    end
  end)

  attendanceLogMemberSlot[i]:Hide()
end

function setAttendanceSlotMemberFrame(i, member, class)
  if (attendanceLogMemberSlot[i]) then
    attendanceLogMemberSlotText[i]:SetText(member)
    attendanceLogMemberSlot[i]:Show()
    if (class) then
      DN:ClassColorText(attendanceLogMemberSlotText[i], class)
    end
    attendanceLogMemberSlotInvite[i]:Show()
    local thisMember = attendanceLogMemberSlotText[i]:GetText()
    if (thisMember == player.name) then
      attendanceLogMemberSlotInvite[i]:Hide()
    end
  end
end

function attendanceLogSlotFrame(i, filteredName, name)
  attendanceLogSlot[i] = CreateFrame("button", attendanceLogSlot[i], DNAAttendanceScrollFrameScrollChildFrame, "BackdropTemplate")
  attendanceLogSlot[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  attendanceLogSlot[i]:SetBackdropColor(1, 1, 1, 0.3)
  attendanceLogSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  attendanceLogSlot[i]:SetWidth(DNAAttendanceScrollFrame_w-5)
  attendanceLogSlot[i]:SetHeight(raidSlot_h)
  attendanceLogSlot[i]:SetPoint("TOPLEFT", 0, (-i*18)+raidSlot_h-4)
  attendanceLogSlot[i].text = attendanceLogSlot[i]:CreateFontString(nil, "ARTWORK")
  attendanceLogSlot[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  attendanceLogSlot[i].text:SetPoint("TOPLEFT", 5, -4)
  --local name_trunc = strsub(filteredName, 1, 28)
  local name_trunc = filteredName:sub(1, 28)
  attendanceLogSlot[i].text:SetText(name_trunc)
  attendanceLogSlot[i]:SetScript('OnEnter', function()
    attendanceLogSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
  end)
  attendanceLogSlot[i]:SetScript('OnLeave', function()
    attendanceLogSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  end)
  attendanceLogSlot[i]:SetScript('OnClick', function()
    for n=1, MAX_RAID_MEMBERS*2 do
      attendanceLogMemberSlot[n]:Hide()
    end
    for n=1, numAttendanceLogs do
      attendanceLogSlot[n]:SetBackdropColor(1, 1, 1, 0.3)
      attendanceLogSlot[n].text:SetTextColor(1, 1, 1)
    end
    attendanceLogSlot[i]:SetBackdropColor(1, 1, 0.3, 1)
    attendanceLogSlot[i]:SetBackdropBorderColor(1, 1, 0.3, 1)
    attendanceLogSlot[i].text:SetTextColor(1, 1, 0.6)
    sortAttendanceName = {}
    for k,v in pairs(attendance[name]) do
      table.insert(sortAttendanceName, k)
    end
    table.sort(sortAttendanceName)
    for k,v in ipairs(sortAttendanceName) do
      setAttendanceSlotMemberFrame(k, v, attendance[name][v])
    end
    local filterLogName = split(name, "}")
    filterLogName[2] = string.gsub(filterLogName[2], " ", "", 1) --first space
    DNAAttendanceDetailsFrame.date:SetText("|cfffffa8bDate:|r " .. filterLogName[1])
    DNAAttendanceDetailsFrame.instance:SetText("|cfffffa8bRaid:|r " .. filterLogName[2])
    DNAAttendanceDetailsFrame.count:SetText("|cfffffa8bMembers:|r " .. table.getn(sortAttendanceName))
    DNAAttendanceDeleteLogBtn:Show()
    DNAAttendanceExportLogBtn:Show()
    DNAAttendanceDetailsFrame:Show()
    DNAAttendanceMemberScrollFrame:Show()
    attendanceLogDate = filterLogName[1]
    attendanceLogName = filterLogName[2]
    attendanceLogID = i
    DN:Debug(attendanceLogDate)
    DN:Debug(attendanceLogName)
    DN:Debug(attendanceLogID)
  end)
end
