--[==[
Copyright ©2020 Porthios of Myzrael
The contents of this addon, excluding third-party resources, are
copyrighted to Porthios with all rights reserved.
This addon is free to use and the members hereby grants you the following rights:
1. You may make modifications to this addon for private use only, you
   may not publicize any portion of this addon.
2. Do not modify the name of this addon, including the addon folders.
3. This copyright notice shall be included in all copies or substantial
  portions of the Software.
All rights not explicitly addressed in this license are reserved by
the copyright holders.
]==]--

local DNACalendarMainFrame = CreateFrame("Frame", "DNACalendarMainFrame", page["Calendar"])
DNACalendarMainFrame:SetPoint("TOPLEFT", 10, -30)
DNACalendarMainFrame:SetWidth(DNAGlobal.width-20)
DNACalendarMainFrame:SetHeight(DNAGlobal.height-40)
DNACalendarMainFrame:SetFrameLevel(2)
DNACalendarMainFrame:Hide()

local calDays = {
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
}

local calDayBack = {
  bgFile   = "Interface/DIALOGFRAME/UI-DialogBox-Background-Dark",
  edgeFile = DNAGlobal.border,
  edgeSize = 18,
  insets = {left=2, right=2, top=2, bottom=2},
}

local DNACalendarMainDay={}
for k,v in ipairs(calDays) do
  local calWeek = v .. 1
  DNACalendarMainDay[calWeek] = CreateFrame("Frame", "DNACalendarMainDay", DNACalendarMainFrame, "BackdropTemplate")
  DNACalendarMainDay[calWeek]:SetPoint("TOPLEFT", 20+(93*k), -60)
  DNACalendarMainDay[calWeek]:SetWidth(100)
  DNACalendarMainDay[calWeek]:SetHeight(100)
  DNACalendarMainDay[calWeek]:SetBackdrop(calDayBack)
  DNACalendarMainDay[calWeek].text = DNACalendarMainDay[calWeek]:CreateFontString(nil, "BACKGROUND")
  DNACalendarMainDay[calWeek].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNACalendarMainDay[calWeek].text:SetPoint("TOPRIGHT", -6, -8)
  DNACalendarMainDay[calWeek].text:SetText("")
  DNACalendarMainDay[calWeek].text:SetTextColor(0.7, 0.7, 0.7, 1)
end
for k,v in ipairs(calDays) do
  local calWeek = v .. 2
  DNACalendarMainDay[calWeek] = CreateFrame("Frame", "DNACalendarMainDay", DNACalendarMainFrame, "BackdropTemplate")
  DNACalendarMainDay[calWeek]:SetPoint("TOPLEFT", 20+(93*k), -152)
  DNACalendarMainDay[calWeek]:SetWidth(100)
  DNACalendarMainDay[calWeek]:SetHeight(100)
  DNACalendarMainDay[calWeek]:SetBackdrop(calDayBack)
end
for k,v in ipairs(calDays) do
  local calWeek = v .. 3
  DNACalendarMainDay[calWeek] = CreateFrame("Frame", "DNACalendarMainDay", DNACalendarMainFrame, "BackdropTemplate")
  DNACalendarMainDay[calWeek]:SetPoint("TOPLEFT", 20+(93*k), -244)
  DNACalendarMainDay[calWeek]:SetWidth(100)
  DNACalendarMainDay[calWeek]:SetHeight(100)
  DNACalendarMainDay[calWeek]:SetBackdrop(calDayBack)
end
for k,v in ipairs(calDays) do
  local calWeek = v .. 4
  DNACalendarMainDay[calWeek] = CreateFrame("Frame", "DNACalendarMainDay", DNACalendarMainFrame, "BackdropTemplate")
  DNACalendarMainDay[calWeek]:SetPoint("TOPLEFT", 20+(93*k), -336)
  DNACalendarMainDay[calWeek]:SetWidth(100)
  DNACalendarMainDay[calWeek]:SetHeight(100)
  DNACalendarMainDay[calWeek]:SetBackdrop(calDayBack)
end
for k,v in ipairs(calDays) do
  local calWeek = v .. 5
  DNACalendarMainDay[calWeek] = CreateFrame("Frame", "DNACalendarMainDay", DNACalendarMainFrame, "BackdropTemplate")
  DNACalendarMainDay[calWeek]:SetPoint("TOPLEFT", 20+(93*k), -428)
  DNACalendarMainDay[calWeek]:SetWidth(100)
  DNACalendarMainDay[calWeek]:SetHeight(100)
  DNACalendarMainDay[calWeek]:SetBackdrop(calDayBack)
end
