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

DEBUG = false

DNAGlobal = {}
DNAGlobal.name      = GetAddOnMetadata("DNAssistant", "Title")
DNAGlobal.sub       = "DNA"
DNAGlobal.dir       = "Interface/AddOns/DNAssistant/"
DNAGlobal.icon      = DNAGlobal.dir .. "images/icon_dn"
DNAGlobal.width     = 980
DNAGlobal.height    = 600
DNAGlobal.font      = DNAGlobal.dir .. "Fonts/verdana.ttf"
--DNAGlobal.font      = "Fonts/ARIALN.ttf"
--DNAGlobal.font      = "Fonts/FRIZQT__.TTF"
DNAGlobal.fontSize  = 12
DNAGlobal.btn_w     = 130
DNAGlobal.btn_h     = 25
DNAGlobal.prefix    = "dnassist"
DNAGlobal.version   = GetAddOnMetadata("DNAssistant", "Version")
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
total.shaman_dps  = 0
--
total.tanks = 0
total.healers= 0
total.cc = 0
total.melee = 0
total.range = 0
--
total.raid = 0

Instance = {}
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

_GitemQuality = {
  POOR    = 0,
  COMMON  = 1,
  UNCOMMON= 2,
  RARE    = 3,
  EPIC    = 4,
  LEGENDARY=5,
  ARTIFACT= 6,
  HEIRLOOM= 7,
}

MAX_RAID_SLOTS  = 600
MAX_FRAME_LINES = 25 --also setup the same for the assign window
MAX_DKP_LINES   = 120
MAX_RAID_ITEMS  = 160 --you never know, just make this high
MAX_CORPSE_ITEMS= 30 --max items on a corpse at one time
MAX_BIDS  = 100
BID_TIMER = 10
MIN_LOOT_QUALITY= _GitemQuality["EPIC"] --the loot to record or bid against

DNAInstance = {}
DNARaidBosses = {}

bidderTable = {}
myBid = 1
DNABidWindow = {}
DNABidNumber = {}
DNABidWindow_w = 250
DNABidWindow_h = 350
bitTimerPos_y = DNABidWindow_h-27
bidSound = {}
DNAlootWindowItem = {}
DNAlootWindowItemBidBtn = {}
DNAlootWindowItemQuality= {}
DNABidControlFrame = {}
DNABidControlWinner = {}
DNABidWindowBidderName= {}
DNABidWindowBidderNum = {}

onPage = "Assignment" --firstpage

function DN:Debug(msg)
  if (DEBUG) then
    if (msg) then
      return print("DEBUG: " .. msg)
    end
  end
end

function DN:HideGlobalReadyCheck()
  ReadyCheckFrame:Hide()
  DN:Debug("ReadyCheckFrame:Hide()")
end

function DN:ChatNotification(msg)
  print(DNAGlobal.name .. "|r " .. msg)
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

function DN:SendPacket(packet, filtered, who)
  filteredPacket = nil
  local msg_to = "RAID"
  if (who) then
    msg_to = who
  end
  if (filtered) then
    filteredPacket = packet:gsub("%s+", "") --filter spaces
  else
    filteredPacket = packet
  end

  --[==[
  if ((DEBUG) or (onPage == "Raid Builder")) then
    C_ChatInfo.SendAddonMessage(DNAGlobal.prefix, filteredPacket, "WHISPER", player.name)
    DN:Debug("C_ChatInfo.SendAddonMessage(.. WHISPER)")
  else
  ]==]--
    C_ChatInfo.SendAddonMessage(DNAGlobal.prefix, filteredPacket, msg_to)
  --end
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
  --DN:Debug("DN:ResetQueueTransposing()")
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
  {"lootbid",   "0xEFLb"},
  {"openbid",   "0xEFOb"},
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

version_alerted = 0

numAttendanceLogs = 0

numLootLogs={}
numLootLogs.init = 0
numLootLogs.cache= 0

ddSelection = nil

--pageTab={}
ddBossList={}
ddBossListText={}
DNAFrameInstance={}
DNAFrameInstanceText={}
DNAFrameInstanceScript={}
DNAFrameInstanceShadow={}

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
DNAGuild["member"]={}
DNAGuild["class"] ={}
DNAGuild["rank"] = {}
DNAGuild["rankID"]={}

DNARaid={}
DNARaid["member"]={}
DNARaid["class"] ={}
DNARaid["race"] = {}
DNARaid["groupid"]={}
DNARaid["assist"] ={}
DNARaid["raidID"] ={}

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
    --DN:Debug(strlength)
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

function DN:GetGuildComp()
  if (IsInGuild()) then
    totalGuildMembers = GetNumGuildMembers()
    DN:Debug("totalGuildMembers " .. totalGuildMembers)
    local numTotalMembers, numOnlineMaxLevelMembers, numOnlineMembers = GetNumGuildMembers()
    for i=1, numTotalMembers do
      local name, rank, rankIndex, level, class, zone = GetGuildRosterInfo(i)
      local filterRealm = string.match(name, "(.*)-")
      DNAGuild["member"] = filterRealm
      DNAGuild["class"][filterRealm] = class
      DNAGuild["rank"][filterRealm] = rank
      DNAGuild["rankID"][filterRealm] = rankIndex
      --DN:Debug("Guild RankID " .. rankIndex .. " = " .. rank)
    end
    DN:Debug("getGuildComp()")
  end
end

function DN:BuildAttendance()
  if (DNA["ATTENDANCE"] == nil) then
    DNA["ATTENDANCE"] = {}
  end
  if (DNA[player.combine]["CONFIG"]["LOGATTENDANCE"] == "ON") then
    if (DNA["ATTENDANCE"][timestamp.date] == nil) then
      DNA["ATTENDANCE"][timestamp.date] = {}
    end
    local inInstance, instanceType = IsInInstance()
    if (inInstance) then
      if (instanceType == "raid") then
        local instanceName = GetInstanceInfo()
        if (instanceName) then
          for i=1, MAX_RAID_MEMBERS do
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
            if ((name) and (class)) then
              if (DNA["ATTENDANCE"][timestamp.date][instanceName] == nil) then
                DNA["ATTENDANCE"][timestamp.date][instanceName] = {}
              end
              if (DNA["ATTENDANCE"][timestamp.date][instanceName][name] == nil) then
                DNA["ATTENDANCE"][timestamp.date][instanceName][name] = {DNAGlobal.DKP}
              end
              if (DNA["ATTENDANCE"][timestamp.date][instanceName][name][class] == nil) then
                DNA["ATTENDANCE"][timestamp.date][instanceName][name][class] = {}
              end
            end
          end
        end
      end
    end
  end
end

function DN:GetRaidComp()
  total.raid = GetNumGroupMembers()
  --clear entries and rebuild to always get an accurate count on classes,races,names,etc...
  for k,v in pairs(DNARaid["class"]) do
    DNARaid["class"][k] = nil
  end
  for k,v in pairs(DNARaid["assist"]) do
    DNARaid["assist"][k] = nil
  end

  DN:GetGuildComp() --get guild ranks

  for i=1, MAX_RAID_MEMBERS do
    --local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)

    if (name) then
      DNARaid["assist"][name] = 0
      DNARaid["raidID"][name] = i

      if (rank > 0) then
        DNARaid["assist"][name] = 1
      end
      rankLead = ""
      if (rank > 1) then
        raidLead = name
        DN:Debug("Raid Lead: " .. raidLead)
      end

      if (IsInRaid()) then
        if (raidInvited[name] ~= 1) then --already invited attempt
          DN:Debug(name .. " has joined")
          if (raidLead == player.name) then
            if (player.name ~= name) then --dont promote self
              if (IsInGuild()) then
                if (DNAGuild["rankID"][name] ~= nil) then --no guild rank or permission
                  if (DNAGuild["rankID"][name] <= 3) then
                    if (DNARaid["assist"][name] ~= 1) then --has not been promoted yet
                      if (UnitIsGroupAssistant(name) == false) then
                        DN:PromoteToAssistant(name)
                      end
                    end
                  end
                end
              end
            end
          end
        end
        raidInvited[name] = 1
      end

      DNARaid["member"][i] = name
      DNARaid["class"][name] = class
      DNARaid["race"][name] = UnitRace(name)
      DNARaid["groupid"][name] = subgroup

    end
  end

  if (DEBUG) then
    buildDebugRaid() --fake raid
    DN:Debug("DN:GetRaidComp() total:" .. total.raid)
  end
end

function DN:RaidDetails()
  pageRaidDetailsColOne[1]:SetText("Druids")
  DN:ClassColorText(pageRaidDetailsColOne[1], "Druid")
  pageRaidDetailsColTwo[1]:SetText(total.druids)

  pageRaidDetailsColOne[2]:SetText("Hunters")
  DN:ClassColorText(pageRaidDetailsColOne[2], "Hunter")
  pageRaidDetailsColTwo[2]:SetText(total.hunters)

  pageRaidDetailsColOne[3]:SetText("Mages")
  DN:ClassColorText(pageRaidDetailsColOne[3], "Mage")
  pageRaidDetailsColTwo[3]:SetText(total.mages)

  pageRaidDetailsColOne[4]:SetText("Paladins")
  DN:ClassColorText(pageRaidDetailsColOne[4], "Paladin")
  pageRaidDetailsColTwo[4]:SetText(total.paladins)

  pageRaidDetailsColOne[5]:SetText("Priests")
  DN:ClassColorText(pageRaidDetailsColOne[5], "Priest")
  pageRaidDetailsColTwo[5]:SetText(total.priests)

  pageRaidDetailsColOne[6]:SetText("Rogues")
  DN:ClassColorText(pageRaidDetailsColOne[6], "Rogue")
  pageRaidDetailsColTwo[6]:SetText(total.rogues)

  pageRaidDetailsColOne[7]:SetText("Warlocks")
  DN:ClassColorText(pageRaidDetailsColOne[7], "Warlock")
  pageRaidDetailsColTwo[7]:SetText(total.warlocks)

  pageRaidDetailsColOne[8]:SetText("Warriors")
  DN:ClassColorText(pageRaidDetailsColOne[8], "Warrior")
  pageRaidDetailsColTwo[8]:SetText(total.warriors)

  pageRaidDetailsColOne[9]:SetText("Shamans")
  DN:ClassColorText(pageRaidDetailsColOne[9], "Shaman")
  pageRaidDetailsColTwo[9]:SetText(total.shamans)

  pageRaidDetailsColOne[12]:SetText("TOTAL")
  pageRaidDetailsColTwo[12]:SetText(total.raid)
end

function DN:AlignSlotText()
  for i=1, DNASlots.tank do
    if (tankSlot[i].text:GetText() == "Empty") then
      tankSlot[i].text:ClearAllPoints()
      tankSlot[i].text:SetPoint("CENTER", 0, 0)
      --DN:Debug("tankSlot " .. tankSlot[i].text:GetText())
    end
  end
  for i=1, DNASlots.heal do
    if (healSlot[i].text:GetText() == "Empty") then
      healSlot[i].text:ClearAllPoints()
      healSlot[i].text:SetPoint("CENTER", 0, 0)
      --DN:Debug("healSlot " .. healSlot[i].text:GetText())
    end
  end
  for i=1, DNASlots.cc do
    if (ccSlot[i].text:GetText() == "Empty") then
      ccSlot[i].text:ClearAllPoints()
      ccSlot[i].text:SetPoint("CENTER", 0, 0)
      --DN:Debug("ccSlot " .. ccSlot[i].text:GetText())
    end
  end
  DN:Debug("DN:AlignSlotText()")
end

DNAFrameAssignNotReady={}
function DN:RaidReadyClear()
  for i=1, MAX_RAID_SLOTS do
    raidSlot[i].ready:SetTexture("")
  end
  for i=1, DNASlots.tank do
    tankSlot[i].ready:SetTexture("")
  end
  for i=1, DNASlots.heal do
    healSlot[i].ready:SetTexture("")
  end
  for i=1, DNASlots.cc do
    ccSlot[i].ready:SetTexture("")
  end
  DN:Debug("DN:RaidReadyClear()")
end

function DN:RaidReadyMember(member, isReady)
  if (isReady) then
    for i=1, MAX_RAID_MEMBERS do
      if (raidSlot[i].text:GetText() == member) then
        raidSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
      end
    end
    for i=1, DNASlots.tank do
      if (tankSlot[i].text:GetText() == member) then
        tankSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
      end
    end
    for i=1, DNASlots.heal do
      if (healSlot[i].text:GetText() == member) then
        healSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
      end
    end
    for i=1, DNASlots.cc do
      if (ccSlot[i].text:GetText() == member) then
        ccSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
      end
    end
  else
    for i=1, MAX_RAID_SLOTS do
      if (raidSlot[i].text:GetText() == member) then
        raidSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady")
      end
    end
    for i=1, DNASlots.tank do
      if (tankSlot[i].text:GetText() == member) then
        tankSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady")
      end
    end
    for i=1, DNASlots.heal do
      if (healSlot[i].text:GetText() == member) then
        healSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady")
      end
    end
    for i=1, DNASlots.cc do
      if (ccSlot[i].text:GetText() == member) then
        ccSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady")
      end
    end
  end
end

function DN:RaidPermission()
  if (DEBUG) then
    return true
  end
  if (IsInRaid()) then
    if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
      return true
    else
      DN:Notification("You do not have raid permission to modify assignments.", true)
      return false
    end
  else
    DN:Notification("You are not in a raid.", true)
    return false
  end
end

--alpha sort the member matrix
local DNARaidMemberSorted={}
function DN:UpdateRaidRoster()
  local k=0
  --clear all entries, then rebuild raid
  for i=1, MAX_RAID_SLOTS do
    DNARaid["member"][i] = nil
  end

  DN:GetRaidComp() --pulling guild, what page are we on

  DN:GetAttendanceLogs()
  DN:GetLootLogs()

  for i=1, MAX_RAID_SLOTS do
    DNARaidMemberSorted[i] = nil
    raidSlot[i].text:SetText("")
    raidSlot[i]:Hide()
  end

  --clear the totals then rebuild
  for k,v in pairs(total) do
    total[k] = 0
  end
  for i=1, DNASlots.tank do
    tankSlot[i].icon:SetTexture("")
    for k, v in pairs(DNARaid["assist"]) do
      if ((tankSlot[i].text:GetText() == k) and (v == 1)) then
        tankSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
    if (tankSlot[i].text:GetText() ~= "Empty") then
      total.tanks = total.tanks +1
      tankSlotFrameClear:Show()
      remove_slot = singleKeyFromValue(DNARaid["member"], tankSlot[i].text:GetText())
      if (DNARaid["member"][remove_slot] == tankSlot[i].text:GetText()) then
        DNARaid["member"][remove_slot] = nil
      end
    end
  end

  for i=1, DNASlots.heal do
    healSlot[i].icon:SetTexture("")
    healSlotUp[i]:Hide()
    healSlotDown[i]:Hide()
    for k, v in pairs(DNARaid["assist"]) do
      if ((healSlot[i].text:GetText() == k) and (v == 1)) then
        healSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
    if (healSlot[i].text:GetText() ~= "Empty") then
      total.healers = total.healers +1
      if (IsInRaid()) then
        if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
          healSlotUp[i]:Show()
          healSlotDown[i]:Show()
          healSlotFrameClear:Show()
        end
      end
      remove_slot = singleKeyFromValue(DNARaid["member"], healSlot[i].text:GetText())
      if (DNARaid["member"][remove_slot] == healSlot[i].text:GetText()) then
        DNARaid["member"][remove_slot] = nil
      end
    end
  end
  healSlotUp[1]:Hide()
  healSlotDown[DNASlots.heal]:Hide()

  for i=1, DNASlots.cc do
    ccSlot[i].icon:SetTexture("")
    for k, v in pairs(DNARaid["assist"]) do
      if ((ccSlot[i].text:GetText() == k) and (v == 1)) then
        ccSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
    if (ccSlot[i].text:GetText() ~= "Empty") then
      total.cc = total.cc +1
      ccSlotFrameClear:Show()
      remove_slot = singleKeyFromValue(DNARaid["member"], ccSlot[i].text:GetText())
      if (DNARaid["member"][remove_slot] == ccSlot[i].text:GetText()) then
        DNARaid["member"][remove_slot] = nil
      end
    end
  end

  --rebuild the roster and alphabetize
  for k,v in pairs(DNARaid["member"]) do
    table.insert(DNARaidMemberSorted, v)
  end
  table.sort(DNARaidMemberSorted)
  for k,v in ipairs(DNARaidMemberSorted) do
    --set text, get class color for each raid slot built
    if ((v ~= nil) and (v ~= "")) then
      raidSlot[k].text:SetText(v)
      raidSlot[k]:Show()
      thisClass = DNARaid["class"][v]
      DN:ClassColorText(raidSlot[k].text, thisClass)
      --DN:ToolTip(raidSlot[k], v, true)
    end
  end

  for i=1, table.getn(DNARaidMemberSorted) do
    raidSlot[i].icon:SetTexture("")
    for k, v in pairs(DNARaid["assist"]) do
      if ((raidSlot[i].text:GetText() == k) and (v == 1)) then
        raidSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
  end

  for k,v in pairs(DNARaid["class"]) do
    lowerTextClass = string.lower(v) .. "s"
    total[lowerTextClass] = total[lowerTextClass] +1
  end

  total.raid = total.warriors + total.druids + total.priests + total.mages + total.warlocks + total.hunters + total.rogues + total.paladins + total.shamans
  total.melee = total.warriors + total.rogues + total.druids
  total.range = total.hunters + total.mages + total.warlocks

  DN:Debug("DN:UpdateRaidRoster()")
end

function DN:ClearFrameView()
  for i=1, MAX_FRAME_LINES do
    DNAFrameViewScrollChild_mark[i]:SetTexture("")
    DNAFrameViewScrollChild_tank[i]:SetText("")
    DNAFrameViewScrollChild_heal[i]:SetText("")
  end
  DN:Debug("DN:ClearFrameView()")
end

function DN:ClearFrameAssign()
  for i=1, MAX_FRAME_LINES do
    DNAFrameAssignScrollChild_mark[i]:SetTexture("")
    DNAFrameAssignScrollChild_tank[i]:SetText("")
    DNAFrameAssignScrollChild_heal[i]:SetText("")
  end
  DN:Debug("DN:ClearFrameAssign()")
end

function DN:ClearFrameClassAssign()
  for i, v in ipairs(DNAClasses) do
    DNAFrameClassAssignEdit[v]:SetText("")
  end
end

function DN:ClearFrameAssignPersonal()
  DNAFrameAssignPersonalMark:SetTexture("")
  DNAFrameAssignPersonalColOne:SetText("")
  DNAFrameAssignPersonalColTwo:SetText("")
  DNAFrameAssignPersonalClass:SetText("")
  --reset the window positioning, similar to a chat bubble
  DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w) --default
  DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-24, 4)
  DN:Debug("DN:ClearFrameAssignPersonal()")
  if (DNACheckbox["SMALLASSIGNCOMBAT"]:GetChecked()) then
    DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w -140)
    DNAFrameAssignPersonal:SetHeight(DNAFrameAssignPersonal_h /2)
    DNAFrameAssignPersonal.header:SetHeight(9)
    DNAFrameAssignPersonal.headerText:SetFont(DNAGlobal.font, 6, "OUTLINE")
    DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-12, 2)
    DNAFrameAssignPersonal.close:SetWidth(12)
    DNAFrameAssignPersonal.close:SetHeight(12)
    DNAFrameAssignPersonalMark:SetSize(8, 8)
    DNAFrameAssignPersonalColOne:SetFont(DNAGlobal.font, 6, "OUTLINE")
    DNAFrameAssignPersonalColTwo:SetFont(DNAGlobal.font, 6, "OUTLINE")
    DNAFrameAssignPersonalClass:SetFont(DNAGlobal.font, 6, "OUTLINE")
    DN:Debug("size personal assignment window down")
  end
  DNAFrameAssignPersonal.header:SetWidth(DNAFrameAssignPersonal:GetWidth())
end

function DN:InstanceButtonToggle(name, icon)
  local instanceNum = multiKeyFromValue(DNAInstance, name)
  for i, v in ipairs(DNAInstance) do
    DNAFrameInstance[DNAInstance[i][1]]:SetBackdrop({
      bgFile = DNAInstance[i][5],
      edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
      edgeSize = 14,
      insets = {left=0, right=-78, top=0, bottom=-24},
    })
    DNAFrameInstance[DNAInstance[i][1]]:SetBackdropBorderColor(1, 1, 1, 1)
    DNAFrameInstanceShadow[DNAInstance[i][1]]:Show()
    DNAFrameInstanceText[DNAInstance[i][1]]:SetTextColor(1, 1, 1)
  end

  DNAFrameInstance[name]:SetBackdropBorderColor(1, 1, 0.40, 1)
  DNAFrameInstanceShadow[name]:Hide()
  DNAFrameInstanceText[name]:SetTextColor(1, 1, 0.60)
  pageBanner:SetTexture(DNAInstance[instanceNum][3])
  pageBanner.text:SetText(DNAInstance[instanceNum][2])
  pageBossIcon:SetTexture(DNAInstance[instanceNum][4])
  DNAFrameViewBG:SetTexture(DNAInstance[instanceNum][6])
  DNAFrameViewBossMap:SetTexture(DNAInstance[instanceNum][7])
  DNAFrameAssignBossMap:SetTexture(DNAInstance[instanceNum][7])

  DN:ClearFrameClassAssign()
  PlaySound(840)
  raidSelection=""
  DN:PresetClear()
  DN:Debug("DN:InstanceButtonToggle(..., ...)")
end

--parse the incoming packet
function DN:ParseSlotPacket(packet, netpacket)
  DN:UpdateRaidRoster()
  DN:RaidReadyClear() -- there was a change to the roster, people may not be ready
  packet.split = split(netpacket, ",")
  for i=1, table.getn(packet.split) do
    --packet.role = packet.split[1]
    packet.role = string.gsub(packet.split[1], "[^a-zA-Z]", "")
    packet.slot = string.gsub(packet.split[1], packet.role, "")
    packet.slot = tonumber(packet.slot)
    packet.name = packet.split[2]
  end

  if ((packet.role) and (packet.slot) and (packet.name)) then
    if (packet.role == TANK) then
      if ((packet.name == nil) or (packet.name == "Empty")) then
        tankSlot[packet.slot].text:SetText("Empty")
        tankSlot[packet.slot].icon:SetTexture("")
        tankSlot[packet.slot]:SetFrameLevel(2)
        tankSlot[packet.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        tankSlot[packet.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(tankSlot[packet.slot].text, "Empty")
      else
        tankSlot[packet.slot].text:SetText(packet.name)
        tankSlot[packet.slot].text:SetPoint("TOPLEFT", 20, -4)
        tankSlot[packet.slot]:SetFrameLevel(4)
        tankSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
        tankSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        if (DNAGuild["class"][packet.name]) then
          thisClass = DNAGuild["class"][packet.name]
        else
          thisClass = DNARaid["class"][packet.name]
        end
        DN:ClassColorText(tankSlot[packet.slot].text, thisClass)
        --SetPartyAssignment("MAINTANK", packet.name, 1)
        --DN:Debug("MAINTANK = " .. packet.name)
      end
    end

    if (packet.role == HEAL) then
      if ((packet.name == nil) or (packet.name == "Empty")) then
        healSlot[packet.slot].text:SetText("Empty")
        healSlot[packet.slot].icon:SetTexture("")
        healSlot[packet.slot]:SetFrameLevel(2)
        healSlot[packet.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        healSlot[packet.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(healSlot[packet.slot].text, "Empty")
      else
        healSlot[packet.slot].text:SetText(packet.name)
        healSlot[packet.slot].text:SetPoint("TOPLEFT", 20, -4)
        healSlot[packet.slot]:SetFrameLevel(4)
        healSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
        healSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(packet.name)
        thisClass = DNARaid["class"][packet.name]
        DN:ClassColorText(healSlot[packet.slot].text, thisClass)
      end
    end

    if (packet.role == CC) then
      if ((packet.name == nil) or (packet.name == "Empty")) then
        ccSlot[packet.slot].text:SetText("Empty")
        ccSlot[packet.slot].icon:SetTexture("")
        ccSlot[packet.slot]:SetFrameLevel(2)
        ccSlot[packet.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        ccSlot[packet.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(ccSlot[packet.slot].text, "Empty")
      else
        ccSlot[packet.slot].text:SetText(packet.name)
        ccSlot[packet.slot].text:SetPoint("TOPLEFT", 20, -4)
        ccSlot[packet.slot]:SetFrameLevel(4)
        ccSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
        ccSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(packet.name)
        thisClass = DNARaid["class"][packet.name]
        DN:ClassColorText(ccSlot[packet.slot].text, thisClass)
      end
    end

    DN:Debug("packet.role " .. packet.role)
    DN:Debug("packet.slot " .. packet.slot)
    DN:Debug("packet.name " .. packet.name)
  end

  --update the saved
  DNA[player.combine]["ASSIGN"][packet.role .. packet.slot] = packet.name
  DN:UpdateRaidRoster()
  DN:ClearFrameView()
  DN:Debug("DN:ParseSlotPacket()")
end

function DN:ClearLootWindow()
  for i=1, MAX_CORPSE_ITEMS do
    DNAlootWindowItem[i]:SetText("")
    DNAlootWindowItem[i]:Hide()
    DNAlootWindowItemBidBtn[i]:Hide()
  end
end

windowOpen = false
function DN:Close()
  DN:ResetQueueTransposing() --sanity check on queues
  DNAFrameMain:Hide()
  windowOpen = false
  PlaySound(88)
end

attendanceLogSlot = {}
lootLogSlot = {}

function DN:Open()
  if (windowOpen) then
    DN:Close()
  else
    windowOpen = true
    DNAFrameMain:Show()
    --DNAFrameAssign:Show() --DEBUG
    memberDrag = nil --bugfix
    DN:UpdateRaidRoster()
    DN:GetProfileVars()

    DN:PermissionVisibility()
    DN:RaidDetails()
    DN:ResetQueueTransposing() --sanity check on queues
    --DN:HideGlobalReadyCheck()

    --clean up old values
    if (DNA[player.combine]["CONFIG"]["UNLOCKICON"]) then
      DNA[player.combine]["CONFIG"]["UNLOCKICON"] = nil
    end
    if (DNA[player.combine]["CONFIG"]["ICONPOS"]) then
      DNA[player.combine]["CONFIG"]["ICONPOS"] = nil
    end
    if (DNA[player.combine]["CONFIG"]["HIDEICON"]) then
      DNA[player.combine]["CONFIG"]["HIDEICON"] = nil
    end
    if (DNA[player.combine]["CONFIG"]["INDICON"]) then
      DNA[player.combine]["CONFIG"]["INDICON"] = nil
    end
    if (numAttendanceLogs > 0) then
      DNAAttendanceDeleteAllBtn:Show()
    end
    if (numLootLogs.init > 0) then
      DNALootlogDeleteAllBtn:Show()
    end

    local _totalAttendanceLogs = 0
    if (DNA["ATTENDANCE"]) then
      for k,v in pairs(DNA["ATTENDANCE"]) do
        _totalAttendanceLogs = _totalAttendanceLogs +1
      end
    end
    if (_totalAttendanceLogs >= 1) then
      DN:Debug(_totalAttendanceLogs)
      --attendanceLogSlot[_totalAttendanceLogs]:Click()
      attendanceLogSlot[1]:Click()
    end

    local _totalLootLogs = 0
    if (DNA["LOOTLOG"]) then
      for k,v in pairs(DNA["LOOTLOG"]) do
        _totalLootLogs = _totalLootLogs +1
      end
    end
    if (_totalLootLogs >= 1) then
      --lootLogSlot[_totalLootLogs]:Click()
      lootLogSlot[1]:Click()
    end

  end
end
