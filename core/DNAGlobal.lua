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

DEBUG = true

DNAGlobal = {}
DNAGlobal.name      = "Destructive Nature Assistant"
DNAGlobal.dir       = "Interface/AddOns/DNAssistant/"
DNAGlobal.icon      = DNAGlobal.dir .. "images/icon_dn"
DNAGlobal.vmajor    = 1
DNAGlobal.vminor    = 227
DNAGlobal.width     = 980
DNAGlobal.height    = 600
DNAGlobal.font      = DNAGlobal.dir .. "Fonts/verdana.ttf"
--DNAGlobal.font      = "Fonts/ARIALN.ttf"
--DNAGlobal.font      = "Fonts/FRIZQT__.TTF"
DNAGlobal.fontSize  = 12
DNAGlobal.btn_w     = 130
DNAGlobal.btn_h     = 25
DNAGlobal.prefix    = "dnassist"
DNAGlobal.version   = DNAGlobal.vmajor .. "." .. DNAGlobal.vminor
DNAGlobal.backdrop  = "Interface/Garrison/GarrisonMissionParchment" --default
DNAGlobal.border    = "Interface/DialogFrame/UI-DialogBox-Border"
DNAGlobal.slotbg    = "Interface/Collections/CollectionsBackgroundTile"
DNAGlobal.slotborder= "Interface/Tooltips/UI-Tooltip-Border"
DNAGlobal.tabborder = "Interface/PaperDollInfoFrame/UI-CHARACTER-ACTIVETAB"
DNAGlobal.author    = "Porthios of Myzrael"
DNAGlobal.DKP       = 5
DN = {}

total = {}
total.warriors= 0
total.rogues  = 0
total.hunters = 0
total.paladins= 0
total.shamans = 0
total.priests = 0
total.warlocks= 0
total.mages   = 0
total.druids  = 0
total.warriors_dps= 0 --dps warrs called to OT
total.druids_dps  = 0 --dps druids called to OT
total.paladins_dps= 0 --dps paladins called to OT
total.shaman_dps  = 0 --dps shamans called to OT
--
total.tanks = 0
total.healers= 0
total.cc = 0
total.melee = 0
total.range = 0
--
total.raid = 0

expTab = {}
expansionTabs = {
  {"Classic", "Interface/GLUES/COMMON/GLUES-WOW-CLASSICLOGO"},
  {"TBC",     "Interface/GLUES/COMMON/GLUES-WOW-BCLOGO"},
}

DNAPages = {
  "Assignment",
  "Attendance",
  "Loot Log",
  "DKP",
  "Settings",
  --"Raid Builder"
}

textcolor={}
textcolor.white ="|cffffffff"
textcolor.note  ="|cffe2dbbf"
textcolor.red   ="|cff912525"
textcolor.green ="|cff76ed5e"
textcolor.blue  ="|cff175aa8"
textcolor.yellow="|cffdcdf36"

DNACheckbox = {}

DNASlots = {}
DNASlots.tank = 6
DNASlots.heal = 12
DNASlots.cc   = 6

MAX_RAID_SLOTS = 600
MAX_FRAME_LINES = 25 --also setup the same for the assign window
MAX_DKP_LINES = 120

DNAInstance = {}
DNARaidBosses = {}

onPage = "Assignment" --firstpage

function DN:ChatNotification(msg)
  print("|cff00e3d5" .. DNAGlobal.name .. "|r " .. msg)
end

function DN:PromoteToAssistant(name)
  DN:ChatNotification("Auto promoted: " .. name)
  PromoteToAssistant(name)
end

function DN:SetupDefaultVars() --called only when a new profile is created
  DNACheckbox["AUTOPROMOTE"]:SetChecked(true)
  DNA[player.combine]["CONFIG"]["AUTOPROMOTE"] = "ON"
  DNACheckbox["AUTOPROMOTEC"]:SetChecked(true)
  DNA[player.combine]["CONFIG"]["AUTOPROMOTEC"] = "ON"
  DNACheckbox["RAIDCHAT"]:SetChecked(true)
  DNA[player.combine]["CONFIG"]["RAIDCHAT"] = "ON"
  DNACheckbox["LOGATTENDANCE"]:SetChecked(true)
  DNA[player.combine]["CONFIG"]["LOGATTENDANCE"] = "ON"
end

--always load
function DN:BuildGlobalVars()
  if (DNA == nil) then
    DNA = {}
  end
  if (DNA[player.combine] == nil) then
    DNA[player.combine] = {}
    if (DNA[player.combine]["CONFIG"] == nil) then
      DNA[player.combine]["CONFIG"] = {}
    end
    if (DNA[player.combine]["ASSIGN"] == nil) then
      DNA[player.combine]["ASSIGN"] = {}
    end
    if (DNA[player.combine]["LOOTLOG"] == nil) then
      DNA[player.combine]["LOOTLOG"] = {}
    end
    if (DNA[player.combine]["DKP"] == nil) then
      DNA[player.combine]["DKP"] = {}
    end
    if (DNA[player.combine]["SAVECONF"] == nil) then
      DNA[player.combine]["SAVECONF"] = {}
    end
    DN:ChatNotification("Creating Raid Profile: " .. player.combine)
    DN:SetupDefaultVars()
  else
    DN:ChatNotification("Loading Raid Profile: " .. player.combine)
    --it doesn't exist, enable it for the first time
    if (DNA[player.combine]["CONFIG"]["LOGATTENDANCE"] == nil) then
      DNA[player.combine]["CONFIG"]["LOGATTENDANCE"] = "ON"
    end
    if (DNA[player.combine]["CONFIG"]["AUTOPROMOTE"] == nil) then
      DNA[player.combine]["CONFIG"]["AUTOPROMOTE"] = "ON"
    end
    if (DNA[player.combine]["CONFIG"]["AUTOPROMOTEC"] == nil) then
      DNA[player.combine]["CONFIG"]["AUTOPROMOTEC"] = "ON"
    end
  end
end

function DN:SendPacket(packet, filtered)
  filteredPacket = nil
  if (filtered) then
    filteredPacket = packet:gsub("%s+", "") --filter spaces
  else
    filteredPacket = packet
  end
  if (IsInRaid()) then
    C_ChatInfo.SendAddonMessage(DNAGlobal.prefix, filteredPacket, "RAID")
  else
    if ((DEBUG) or (onPage == "Raid Builder")) then
      C_ChatInfo.SendAddonMessage(DNAGlobal.prefix, filteredPacket, "WHISPER", player.name)
      debug("C_ChatInfo.SendAddonMessage(.. WHISPER)")
    end
  end
end

swapQueue={}
prevQueue={}
function DN:ResetQueueTransposing()
  prevQueue[TANK]=0
  swapQueue[TANK]=0
  prevQueue[HEAL]=0
  swapQueue[HEAL]=0
  prevQueue[CC] = 0
  swapQueue[CC] = 0
  --debug("DN:ResetQueueTransposing()")
end

DNAClasses={
  "Druid",
  "Hunter",
  "Mage",
  "Paladin",
  "Priest",
  "Rogue",
  "Shaman",
  "Warlock",
  "Warrior",
}

TANK="T"
HEAL="H"
CC = "C"

netCode = {
  --packet codes
  {"tanks",   "0xEFTa"},
  {"healers", "0xEFHe"},
  --class codes
  {"Warrior", "0xEFWa"},
  {"Hunter",  "0xEFHu"},
  {"Druid",   "0xEFDr"},
  {"Rogue",   "0xEFRo"},
  {"Warlock", "0xEFLo"},
  {"Paladin", "0xEFPa"},
  {"Shaman",  "0xEFSh"},
  {"Priest",  "0xEFPr"},
  {"Mage",    "0xEFMa"},
  --app codes
  {"posttoraid","0xEFPo"},
  {"version",   "0xEFVe"},
  {"readyyes",  "0xEFRy"},
  {"readyno",   "0xEFNr"},
  {"postdkp",   "0xEFPd"},
  {"author",    "0xEFAu"},
  {"lootitem",  "0xEFLi"},
}

DNARaidMarkers={
  {"",   ""},   --leave blank for boss icons that are dynamic
  {"{skull}",   "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8"},
  {"{cross}",   "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_7"},
  {"{triangle}","Interface/TARGETINGFRAME/UI-RaidTargetingIcon_4"},
  {"{circle}",  "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_2"},
  {"{square}",  "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_6"},
  {"{diamond}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_3"},
  {"{moon}",    "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_5"},
  {"{star}",    "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_1"},
  {"{alert}",   "Interface/DialogFrame/UI-Dialog-Icon-AlertNew"},
  {"{up}",       DNAGlobal.dir .. "images/arrow-up"},
  {"{down}",     DNAGlobal.dir .. "images/arrow-down"},
  {"{left}",     DNAGlobal.dir .. "images/arrow-left"},
  {"{right}",    DNAGlobal.dir .. "images/arrow-right"},
}
icon = {}
for i=1, table.getn(DNARaidMarkers) do
  local icon_mark = DNARaidMarkers[i][1]
  if (icon_mark ~= "") then
    icon_str = string.gsub(icon_mark, "{", "")
    icon_str = string.gsub(icon_str, "}", "")
    icon[icon_str] = DNARaidMarkers[i][2]
  end
end

function DN:ClassColorText(frame, class)
  local rgb={0.60, 0.60, 0.60} --offline gray
  if (class) then
    if (class == "Empty") then
      rgb={0.20, 0.20, 0.20}
    else
      local r, g, b = GetClassColor(string.upper(class))
      rgb={r, g, b}
    end
  end
  return frame:SetTextColor(rgb[1], rgb[2], rgb[3])
end

function DN:ClassColorAppend(name, class)
  local hex="ffdedede" --offline gray
  if (arrayValue(DNAClasses, class)) then
    r, g, b, hex = GetClassColor(string.upper(class))
  end
  return "|c" .. hex .. name .. "|r"
end

function DN:ItemQualityColorText(frame, quality)
  for i = 0, 8 do
    local r, g, b = GetItemQualityColor(quality)
    rgb={r, g, b}
  end
  return frame:SetTextColor(rgb[1], rgb[2], rgb[3])
end

DNAGuild={}
DNAGuild["member"] = {}
DNAGuild["class"] = {}
DNAGuild["rank"] = {}

DNARaid={}
DNARaid["member"] = {}
DNARaid["class"] = {}
DNARaid["race"] = {}
DNARaid["groupid"] = {}
DNARaid["assist"] = {}
DNARaid["raidID"] = {}

DNABossIcon = nil
DNABossMap = nil

DNAFrameViewScrollChild_tank = {}
DNAFrameViewScrollChild_mark = {}
DNAFrameViewScrollChild_heal = {}
DNAFrameViewBossMap = {}
DNAFrameAssignScrollChild_tank = {}
DNAFrameAssignScrollChild_mark = {}
DNAFrameAssignScrollChild_heal = {}
DNAFrameAssignPersonal={}
DNAFrameAssignPersonalMark={}
DNAFrameAssignPersonalText={}
DNAFrameAssignBossIcon = {}
DNAFrameAssignBossText = {}
DNAFrameAssignBossMap = {}
DNAFrameAssignAuthor = {}

DNATooltip = CreateFrame("Frame", nil, UIParent)
DNATooltip:SetWidth(25)
DNATooltip:SetHeight(25)
DNATooltip:SetPoint("CENTER", 0, 0)
DNATooltip:SetFrameStrata("DIALOG")
DNATooltip:SetFrameLevel(500)
DNATooltipFrame = CreateFrame("Frame", nil, DNATooltip)
DNATooltipFrame:SetWidth(25)
DNATooltipFrame:SetHeight(25)
DNATooltipFrame:SetPoint("TOPLEFT", 30, -15)
DNATooltip.text = DNATooltipFrame:CreateFontString(nil, "OVERLAY")
DNATooltip.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DNATooltip.text:SetPoint("CENTER", 0, 0)
DNATooltip.text:SetText("Hello World")
DNATooltipFrame:SetBackdrop({
  bgFile = "Interface/ToolTips/UI-Tooltip-Background",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNATooltipFrame:SetBackdropColor(0.2, 0.2, 0.2, 1)
DNATooltip:Hide()

function DN:ToolTip(frame, msg, offset_x, offset_y)
  frame:SetScript("OnEnter", function()
    local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint() --parent
    local strlength = string.len(msg)
    DNATooltip:Show()
    DNATooltipFrame:SetWidth(strlength*10)
    DNATooltipFrame:SetHeight(20)
    DNATooltip.text:SetText(msg)
    --debug(strlength)
    if ((offset_x) and (offset_y)) then
      if (strlength >= 60) then
        strlength = 65
      end
      DNATooltip:SetParent(frame)
      DNATooltip:SetPoint(point, offset_x, offset_y)
      DNATooltipFrame:SetWidth(strlength*7)
      DNATooltipFrame:SetHeight(50)
    else
      DNATooltip:ClearAllPoints()
      DNATooltip:SetPoint(point, frame, relativeTo)
    end
  end)
  frame:SetScript("OnLeave", function()
    DNATooltip:Hide()
  end)
end
function DN:ClearToolTip()
  DNATooltip:Hide()
end

function DN:FrameBorder(title, frame, x, y, w, h)
  local DNAFrameBackBorder={}
  DNAFrameBackBorder = CreateFrame("Frame", nil, frame, "InsetFrameTemplate")
  --DNAFrameBackBorder = CreateFrame("Frame", nil, frame)
  DNAFrameBackBorder:SetSize(w, h)
  DNAFrameBackBorder:SetPoint("TOPLEFT", x, -y)
  DNAFrameBackBorder:SetFrameLevel(2)
  --[==[
  DNAFrameBackBorder:SetBackdrop({
    bgFile = "",
    edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  ]==]--
  DNAFrameBackBorder.text = DNAFrameBackBorder:CreateFontString(nil,"ARTWORK")
  DNAFrameBackBorder.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNAFrameBackBorder.text:SetPoint("TOPLEFT", DNAFrameBackBorder, "TOPLEFT", 5, 13)
  --DNAFrameBackBorder.text:SetTextColor(0.9, 0.7, 0.7)
  DNAFrameBackBorder.text:SetText("|cffffe885" .. title)
end

DNABossPacket = ""
function isItem(compare, item) --dropdown packets that are filtered from spaces
  local boss_icon = nil
  filteredItem = item:gsub("%s+", "")
  if ((compare == item) or (compare == filteredItem)) then
    DNAFrameAssignBossText:SetText(item)
    DNABossPacket = item
    for i=1, table.getn(DNARaidBosses) do
      boss_icon = multiKeyFromValue(DNARaidBosses[i], item)
      if (boss_icon) then
        DNABossIcon = DNARaidBosses[i][boss_icon][2]
      end
    end
    return true
  else
    return false
  end
end

packet={}

raidSlot={}
raidSlot_h=20
tankSlot={}
healSlot={}
ccSlot = {}
tankSlotFrame={}
healSlotFrame={}
ccSlotFrame={}
healSlotUp={}
healSlotDown={}
tankSlotFrameClear={}
healSlotFrameClear={}
ccSlotFrameClear={}
DNAFrameMainAuthor={}

raidSelection = nil

DNAFrameMainBottomTab={}

viewFrameBotTab={}

page={}
pageBanner={}
pageBossIcon={}

DNAMiniMap={}

pageDKPView={}
pageDKPViewScrollChild_colOne={}
pageDKPViewScrollChild_colTwo={}
pageDKPViewScrollChild_colThree= {}

version_checked = 0

numAttendanceLogs = 0
numLootLogs = 0

ddSelection = nil

--pageTab={}
ddBossList={}
ddBossListText={}
DNAFrameInstance={}
DNAFrameInstanceText={}
DNAFrameInstanceScript={}
DNAFrameInstanceShadow={}
DNAFrameInstanceGlow={}

DNAFrameView={}
DNAFrameViewBG={}

DNAFrameClassAssignEdit={}
--DNAFrameClassAssignHidden={}

pageRaidDetailsColOne={}
pageRaidDetailsColTwo={}

DNARaidScrollFrame={}

DNAFrameAssignTabIcon={}
DNAFrameAssignMapGroupID={}

DNAFrameAssignPersonal_w = 320 --MIN WIDTH, length may depend on the string length
DNAFrameAssignPersonal_h = 80

DNAFramePreset={}

pagePreBuildDisable={}
btnPostRaid={}
btnPostRaidDis={}
btnSaveRaid={}
btnSaveRaidDis={}
btnLoadRaid={}
btnLoadRaidDis={}
noLoadRaidText={}

currentViewTank={}
currentViewHeal={}
currentViewCC={}
presetViewTank={}
presetViewHeal={}
presetViewCC={}

raidInvited={}

totalGuildMembers = 0
