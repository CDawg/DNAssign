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

PLEASE NOTE: If you modify the instance dropdown boss names and call for the msg packet, it MUST not have a space.
The compressed network packets will read as "LavaPack" and not "Lava Pack".
All of this is because Blizz uses LUA which is a fucking piece of shit garbage code from hell and whoever invented it needs to get his nuts cut off!
- Porthios of Myzrael

hooksecurefunc
]==]--

local DEBUG = true

local function globalNotification(msg)
  print("|cffe36c00" .. DNAGlobal.name .. "|r " .. msg)
end

local packet = {}
--packet.role = nil
--packet.slot = nil
--packet.name = nil

--removing/decreasing slots could cause LUA errors with nil entries
local tankSlots = 6
local healSlots = 12

local player = {}
player.name = UnitName("player")
player.realm = GetRealmName()
player.combine=player.name .. "-" .. player.realm

local getsave = {}

local lastSelection = nil

local raidSlot = {}
local raidSlot_h = 20

local tankSlot = {}

local healSlot = {}

local raidMember = {}
local raidClass = {}
local raidRace = {}
local raidAssist = {}

local total = {}
total.warriors= 0
total.rogues = 0
total.hunters = 0
total.paladins= 0
total.priests = 0
total.warlocks= 0
total.mages = 0
total.druids = 0
total.warriors_dps = 0 --dps warrs called to OT
total.druids_dps = 0 --dps druids called to OT
total.paladins_dps = 0 --dps paladins called to OT
--
total.tanks = 0
total.healers = 0
total.melee = 0
total.range = 0
--
total.raid = 0

local raidSelection = nil
local viewFrameLines = 20

local botTab = {}
local botBack = {}
local botBorder = {}

local pages = {
  {"Assignment", 10},
  {"Raid Details", 100},
  {"DKP", 190},
  {"Loot Log", 280},
  {"Config", 370},
}

local page={}
local pageBanner = {}
local pageBossIcon = {}

local DNAMiniMap={}

local DNAFrameViewScrollChild_tank = {}
local DNAFrameViewScrollChild_mark = {}
local DNAFrameViewScrollChild_heal = {}
local DNAFrameAssignScrollChild_tank = {}
local DNAFrameAssignScrollChild_mark = {}
local DNAFrameAssignScrollChild_heal = {}
local DNAFrameAssignBossIcon = {}
local DNAFrameAssignBossText = {}
local DNAFrameAssignAuthor = {}

local pageDKPView={}
local pageDKPViewScrollChild_colOne = {}
local pageDKPViewScrollChild_colTwo = {}
local pageDKPViewScrollChild_colThree= {}

local version_checked = 0

local ddSelection = nil

local function isItem(compare, item) --dropdown packets that are filtered from spaces
  --(lava pack)
  filteredItem = item:gsub("%s+", "")
  if ((compare == item) or (compare == filteredItem)) then
    DNAFrameAssignBossText:SetText(item)
    return true
  else
    return false
  end
end

local instance={
  {
    "MC", --key
    "Molten Core",
    "Interface/GLUES/LoadingScreens/LoadScreenMoltenCore",
    "Interface/EncounterJournal/UI-EJ-BOSS-Ragnaros",
    "Interface/EncounterJournal/UI-EJ-LOREBG-MoltenCore",
    "Interface/EncounterJournal/UI-EJ-LOREBG-MoltenCore", --map
  },
  {
    "BWL", --key
    "Blackwing Lair",
    "Interface/GLUES/LoadingScreens/LoadScreenBlackWingLair",
    "Interface/EncounterJournal/UI-EJ-BOSS-Nefarian",
    "Interface/EncounterJournal/UI-EJ-LOREBG-BlackwingLair"
  },
  {
    "AQ40", --key
    "Temple of Ahn'Qiraj",
    "Interface/GLUES/LoadingScreens/LoadScreenAhnQiraj40man",
    "Interface/EncounterJournal/UI-EJ-BOSS-CThun",
    "Interface/EncounterJournal/UI-EJ-LOREBG-TempleofAhnQiraj"
  }
}
local raidBoss = {
  {"MC",
  "Trash MC",
  "Lucifron",
  "Dogpack",
  "Magmadar",
  "Gehennas",
  "Garr",
  "Lava Pack",
  "Sulfuron",
  "Golemagg",
  "Majordomo Executus",
  "Ragnaros"
  },
  {"BWL",
  "Razorgore",
  "Vaelestraz",
  "Dragon Pack",
  "Suppression Room",
  "Goblin Pack",
  "Firemaw",
  "Small Wyrmguards (4)",
  "Large Wyrmguards (3)"
  },
  {"AQ40",
  "Anubisath Sentinels",
  "Prophet Skerem"
  },
}

local markers={
  {"",   ""}, --leave blank for boss icons that are dynamic
  {"{skull}",   "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8"},
  {"{cross}",   "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_7"},
  {"{triangle}","Interface/TARGETINGFRAME/UI-RaidTargetingIcon_4"},
  {"{circle}",  "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_2"},
  {"{square}",  "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_6"},
  {"{diamond}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_3"},
  {"{moon}",    "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_5"},
  {"{star}",    "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_1"},
}

--local pageTab = {}
local ddBossList = {}
local ddBossListText = {}
local DNAFrameInstance = {}
local DNAFrameInstanceText={}
local DNAFrameInstanceScript={}
local DNAFrameInstanceGlow={}

local pageRaidDetailsColOne = {}
local pageRaidDetailsColTwo = {}

local function getRaidComp()
  total.raid = GetNumGroupMembers()
  --clear entries and rebuild to always get an accurate count on classes,races,names,etc...
  for k,v in pairs(raidClass) do
    raidClass[k] = nil
  end
  for k,v in pairs(raidAssist) do
    raidAssist[k] = nil
  end

  for i = 1, MAX_RAID_MEMBERS do
    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)

    if (name) then
      raidAssist[name] = 0

      if (rank > 0) then
        raidAssist[name] = 1
      end
      if (rank > 1) then
        raidLead = name
      end

      raidMember[i] = name
      raidClass[name] = class
      raidRace[name] = UnitRace(name)
    end
  end

  if (DEBUG) then
    print("DEBUG: getRaidComp() total:" .. total.raid)
  end

  -- Not in a raid, just place your name in the list as a placeholder
  if (total.raid <= 0) then
    raidMember[1] = player.name
  end

  --FAKE RAID
  if (DEBUG) then
    raidMember[1] = "Aellwyn"
    raidMember[2] = "Porthios"
    raidMember[3] = "Upya"
    raidMember[4] = "Zarj"
    raidMember[5] = "Cryonix"
    raidMember[6] = "Grayleaf"
    raidMember[7] = "Droott"
    raidMember[8] = "Aquilla"
    raidMember[9] = "Neilsbhor"
    raidMember[10] = "Frosthunt"
    raidMember[11] = "Nanodel"
    raidMember[12] = "Crisis"
    raidMember[13] = "Whistper"
    raidMember[14] = "Zarianna"
    raidMember[15] = "Addontesterc"
    raidMember[16] = "Roaxe"
    raidMember[17] = "Krizzu"
    raidMember[18] = "Elderpen"
    raidMember[19] = "Snibson"
    raidMember[20] = "Justwengit"
    raidMember[21] = "Daggerz"
    raidMember[22] = "Mirrand"
    raidMember[23] = "Corr"
    raidMember[24] = "Valency"
    raidMember[25] = "Nutty"
    raidMember[26] = "Zatos"
    raidMember[27] = "Muppot"
    raidMember[28] = "Gaelic"
    raidMember[29] = "Chrundle"
    raidMember[30] = "Akilina"
    raidMember[31] = "Mairakus"
    raidMember[32] = "Sleapy"
    raidMember[33] = "Stumpymcaxe"
    raidMember[34] = "Cahonez"
    raidMember[35] = "Avarius"
    raidMember[36] = "Blackprince"
    raidMember[37] = "Nightling"
    raidMember[38] = "Kelvarn"
    raidMember[39] = "Measles"

    raidClass["Aellwyn"] = "Warrior"
    raidClass["Porthios"] = "Warrior"
    raidClass["Upya"] = "Warlock"
    raidClass["Zarj"] = "Rogue"
    raidClass["Cryonix"] = "Priest"
    raidClass["Grayleaf"] = "Warrior"
    raidClass["Droott"] = "Druid"
    raidClass["Aquilla"] = "Mage"
    raidClass["Neilsbhor"] = "Mage"
    raidClass["Frosthunt"] = "Hunter"
    raidClass["Nanodel"] = "Hunter"
    raidClass["Crisis"] = "Warrior"
    raidClass["Whistper"] = "Hunter"
    raidClass["Zarianna"] = "Paladin"
    raidClass["Roaxe"] = "Paladin"
    raidClass["Elderpen"] = "Warrior"
    raidClass["Snibson"] = "Priest"
    raidClass["Justwengit"] = "Mage"
    raidClass["Daggerz"] = "Rogue"
    raidClass["Mirrand"] = "Rogue"
    raidClass["Corr"] = "Paladin"
    raidClass["Valency"] = "Warlock"
    raidClass["Nutty"] = "Paladin"
    raidClass["Zatos"] = "Priest"
    raidClass["Muppot"] = "Warlock"
    raidClass["Gaelic"] = "Paladin"
    raidClass["Chrundle"] = "Mage"
    raidClass["Akilina"] = "Warrior"
    raidClass["Sleapy"] = "Priest"
    raidClass["Mairakus"] = "Warrior"
    raidClass["Stumpymcaxe"] = "Warrior"
    raidClass["Cahonez"] = "Rogue"
    raidClass["Avarius"] = "Warrior"
    raidClass["Blackprince"] = "Paladin"
    raidClass["Measles"] = "Warlock"
    raidClass["Nightling"] = "Druid"
    raidClass["Kelvarn"] = "Priest"

    raidRace["Kelvarn"] = "Dwarf"
  end

end

--[==[
local trash = {}
for k,v in pairs(markers) do
  trash[k] = {v[1], v[2]}
end
]==]--

local icon_boss    = markers[1][2]
local icon_skull   = markers[2][2]
local icon_cross   = markers[3][2]
local icon_triangle= markers[4][2]
local icon_circle  = markers[5][2]
local icon_square  = markers[6][2]
local icon_diamond = markers[7][2]
local icon_moon    = markers[8][2]
local icon_star    = markers[9][2]

local function classColorText(frame, class)
  local rgb={0.60, 0.60, 0.60} --offline gray
  if (class == "Warrior") then
    rgb={0.78, 0.61, 0.43}
  end
  if (class == "Warlock") then
    rgb={0.53, 0.53, 0.93}
  end
  if (class == "Rogue") then
    rgb={1.00, 0.96, 0.41}
  end
  if (class == "Druid") then
    rgb={1.00, 0.49, 0.04}
  end
  if (class == "Hunter") then
    rgb={0.67, 0.83, 0.45}
  end
  if (class == "Paladin") then
    rgb={0.96, 0.55, 0.73}
  end
  if (class == "Mage") then
    rgb={0.25, 0.78, 0.92}
  end
  if (class == "Priest") then
    rgb={1.00, 1.00, 1.00}
  end
  if (class == "Empty") then --empty slot
    rgb={0.20, 0.20, 0.20}
  end
  return frame:SetTextColor(rgb[1],rgb[2],rgb[3])
end

local function classColorAppend(name, class)
  local rgb="dedede" --offline gray
  if (class == "Warrior") then
    rgb="C79C6E"
  end
  if (class == "Warlock") then
    rgb="8787ED"
  end
  if (class == "Rogue") then
    rgb="FFF569"
  end
  if (class == "Druid") then
    rgb="FF7D0A"
  end
  if (class == "Hunter") then
    rgb="A9D271"
  end
  if (class == "Paladin") then
    rgb="F58CBA"
  end
  if (class == "Mage") then
    rgb="40C7EB"
  end
  if (class == "Priest") then
    rgb="ffffff"
  end
  if (class == "Empty") then --empty slot
    rgb="ededed"
  end
  return "|cff" .. rgb .. name .. "|r"
end

--local DNAFrameMainOpen = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
local DNAFrameMainOpen = CreateFrame("Button", nil, UIParent)
DNAFrameMainOpen:SetWidth(80)
DNAFrameMainOpen:SetHeight(40)
DNAFrameMainOpen:SetPoint("TOPLEFT", 220, 10)
local DNAFrameMainOpenBG = DNAFrameMainOpen:CreateTexture(nil, "ARTWORK")
DNAFrameMainOpenBG:SetTexture("Interface/ExtraButton/GarrZoneAbility-MageTower")
DNAFrameMainOpenBG:SetSize(80, 40)
DNAFrameMainOpenBG:SetPoint("TOPLEFT", -5, 0)
local DNAFrameMainOpenIcon = DNAFrameMainOpen:CreateTexture(nil, "ARTWORK", DNAFrameMainOpenBG, -4)
DNAFrameMainOpenIcon:SetTexture("Interface/Icons/Spell_Nature_Lightning")
DNAFrameMainOpenIcon:SetSize(18, 18)
DNAFrameMainOpenIcon:SetPoint("TOPLEFT", 26, -10)

local DNAFrameAssignNotReady={}

function raidReadyClear()
  for i=1, MAX_RAID_MEMBERS do
    raidSlot[i].ready:SetTexture("")
  end
  for i=1, tankSlots do
    tankSlot[i].ready:SetTexture("")
  end
  for i=1, healSlots do
    healSlot[i].ready:SetTexture("")
  end
  --DNAFrameAssignNotReady:SetBackdropColor(0.6, 0.5, 0.5, 1)
end

function raidReadyMember(member, isReady)
  if (isReady) then
    for i=1, MAX_RAID_MEMBERS do
      if (raidSlot[i].text:GetText() == member) then
        raidSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
      end
    end
    for i=1, tankSlots do
      if (tankSlot[i].text:GetText() == member) then
        tankSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
      end
    end
    for i=1, healSlots do
      if (healSlot[i].text:GetText() == member) then
        healSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-Ready")
      end
    end
  else
    for i=1, MAX_RAID_MEMBERS do
      if (raidSlot[i].text:GetText() == member) then
        raidSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady")
      end
    end
    for i=1, tankSlots do
      if (tankSlot[i].text:GetText() == member) then
        tankSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady")
      end
    end
    for i=1, healSlots do
      if (healSlot[i].text:GetText() == member) then
        healSlot[i].ready:SetTexture("Interface/RAIDFRAME/ReadyCheck-NotReady")
      end
    end
  end
end

--alpha sort the member matrix
local raidMemberSorted = {}
local function updateRaidRoster()
  local k=0
  --clear all entries, then rebuild raid
  for i = 1, MAX_RAID_MEMBERS do
    raidMember[i] = nil
  end
  getRaidComp()
  for i = 1, MAX_RAID_MEMBERS do
    raidMemberSorted[i] = nil
    raidSlot[i].text:SetText("")
    raidSlot[i]:Hide()
  end

  --clear the totals then rebuild
  for k,v in pairs(total) do
    total[k] = 0
  end
  for i = 1, tankSlots do
    tankSlot[i].icon:SetTexture("")
    for k, v in pairs(raidAssist) do
      if ((tankSlot[i].text:GetText() == k) and (v == 1)) then
        tankSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
    if (tankSlot[i].text:GetText() ~= "Empty") then
      total.tanks = total.tanks +1
      remove_slot = singleKeyFromValue(raidMember, tankSlot[i].text:GetText())
      if (raidMember[remove_slot] == tankSlot[i].text:GetText()) then
        raidMember[remove_slot] = nil
      end
    end
  end

  for i = 1, healSlots do
    healSlot[i].icon:SetTexture("")
    for k, v in pairs(raidAssist) do
      if ((healSlot[i].text:GetText() == k) and (v == 1)) then
        healSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
    if (healSlot[i].text:GetText() ~= "Empty") then
      total.healers = total.healers +1
      remove_slot = singleKeyFromValue(raidMember, healSlot[i].text:GetText())
      if (raidMember[remove_slot] == healSlot[i].text:GetText()) then
        raidMember[remove_slot] = nil
      end
    end
  end

  --rebuild the roster and alphabetize
  for k,v in pairs(raidMember) do
    table.insert(raidMemberSorted, v)
  end
  table.sort(raidMemberSorted)
  for k,v in ipairs(raidMemberSorted) do
    --print("DEBUG: " .. k .. "=" .. v)
    --set text, get class color for each raid slot built
    if (v ~= nil) then
      raidSlot[k].text:SetText(v)
      raidSlot[k]:Show()
      --thisClass = UnitClass(v)
      thisClass = raidClass[v]
      classColorText(raidSlot[k].text, thisClass)
    end
  end

  for i = 1, table.getn(raidMemberSorted) do
    raidSlot[i].icon:SetTexture("")
    for k, v in pairs(raidAssist) do
      if ((raidSlot[i].text:GetText() == k) and (v == 1)) then
        raidSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
  end

  for k,v in pairs(raidClass) do
    lowerTextClass = string.lower(v) .. "s"
    total[lowerTextClass] = total[lowerTextClass] +1
  end

  total.raid = total.warriors + total.druids + total.priests + total.mages + total.warlocks + total.hunters + total.rogues + total.paladins
  total.melee = total.warriors + total.rogues + total.druids
  total.range = total.hunters + total.mages + total.warlocks

  --[==[
  DNAFrameMainOpen:Hide()
  if (IsInRaid()) then
    DNAFrameMainOpen:Show()
  end
  ]==]--

  if (DEBUG) then
    print("DEBUG: updateRaidRoster()")
  end
end

local function clearFrameView()
  for i = 1, viewFrameLines do
    DNAFrameViewScrollChild_mark[i]:SetTexture("")
    DNAFrameViewScrollChild_tank[i]:SetText("")
    DNAFrameViewScrollChild_heal[i]:SetText("")
  end
  if (DEBUG) then
    print("DEBUG: clearFrameView()")
  end
end

local function clearFrameAssign()
  for i = 1, viewFrameLines do
    DNAFrameAssignScrollChild_mark[i]:SetTexture("")
    DNAFrameAssignScrollChild_tank[i]:SetText("")
    DNAFrameAssignScrollChild_heal[i]:SetText("")
  end
  if (DEBUG) then
    print("DEBUG: clearFrameAssign()")
  end
end


local function InstanceButtonToggle(name, icon)
  local instanceNum = multiKeyFromValue(instance, name)
  for i, v in ipairs(instance) do
    DNAFrameInstance[instance[i][1]]:SetBackdrop({
      bgFile = instance[i][5],
      edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
      edgeSize = 18,
      insets = {left=0, right=-45, top=0, bottom=-44},
    })
    DNAFrameInstanceGlow[instance[i][1]]:Hide()
  end
  DNAFrameInstance[name]:SetBackdrop({
    bgFile = icon,
    edgeFile = "Interface/TUTORIALFRAME/UI-TutorialFrame-CalloutGlow",
    edgeSize = 8,
    insets = {left=0, right=-45, top=0, bottom=-44},
  })
  DNAFrameInstanceGlow[name]:Show()
  pageBanner:SetTexture(instance[instanceNum][3])
  pageBanner.text:SetText(instance[instanceNum][2])
  pageBossIcon:SetTexture(instance[instanceNum][4])
  PlaySound(844)
end

--parse the incoming packet
local function parsePacket(packet, netpacket)
  updateRaidRoster()
  raidReadyClear() -- there was a change to the roster, people may not be ready
  packet.split = split(netpacket, ",")
  for i = 1, table.getn(packet.split) do
    --packet.role = packet.split[1]
    packet.role = string.gsub(packet.split[1], "[^a-zA-Z]", "")
    packet.slot = string.gsub(packet.split[1], packet.role, "")
    packet.slot = tonumber(packet.slot)
    packet.name = packet.split[2]
  end
  if (DEBUG) then
    print("DEBUG: packet.role " .. packet.role)
    print("DEBUG: packet.slot " .. packet.slot)
    print("DEBUG: packet.name " .. packet.name)
  end
  if (packet.role == "tank") then
    if ((packet.name == nil) or (packet.name == "Empty")) then
      tankSlot[packet.slot].text:SetText("Empty")
      tankSlot[packet.slot].icon:SetTexture("")
      tankSlot[packet.slot]:SetFrameLevel(2)
      tankSlot[packet.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
      tankSlot[packet.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
      classColorText(tankSlot[packet.slot].text, "Empty")
    else
      tankSlot[packet.slot].text:SetText(packet.name)
      tankSlot[packet.slot]:SetFrameLevel(4)
      tankSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
      tankSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
      thisClass = raidClass[packet.name]
      classColorText(tankSlot[packet.slot].text, thisClass)
      --PromoteToAssistant(packet.name)
      --SetPartyAssignment("MAINTANK", packet.name, 1);
    end
  end
  if (packet.role == "heal") then
    if ((packet.name == nil) or (packet.name == "Empty")) then
      healSlot[packet.slot].text:SetText("Empty")
      healSlot[packet.slot].icon:SetTexture("")
      healSlot[packet.slot]:SetFrameLevel(2)
      healSlot[packet.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
      healSlot[packet.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
      classColorText(healSlot[packet.slot].text, "Empty")
    else
      healSlot[packet.slot].text:SetText(packet.name)
      healSlot[packet.slot]:SetFrameLevel(4)
      healSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
      healSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
      --thisClass = UnitClass(packet.name)
      thisClass = raidClass[packet.name]
      classColorText(healSlot[packet.slot].text, thisClass)
    end
  end

  --update the saved
  DNA[player.combine][packet.role .. packet.slot] = packet.name
  updateRaidRoster()
  clearFrameView()
end

-- assignment window --
local DNAFrameAssign_w = 400
local DNAFrameAssign_h = 450
--local DNAFrameAssign = CreateFrame("Frame", nil, UIParent, "ButtonFrameTemplate")
local DNAFrameAssign = CreateFrame("Frame", nil, UIParent)
DNAFrameAssign:SetWidth(DNAFrameAssign_w)
DNAFrameAssign:SetHeight(DNAFrameAssign_h)
DNAFrameAssign:SetPoint("CENTER", 0, 0)
DNAFrameAssign:SetMovable(true)
DNAFrameAssign:EnableMouse(true)
DNAFrameAssign:SetFrameStrata("DIALOG")
DNAFrameAssign:SetFrameLevel(150)
DNAFrameAssign:RegisterForDrag("LeftButton")
local DNAFrameAssignTitle = CreateFrame("Frame", nil, DNAFrameAssign)
DNAFrameAssignTitle:SetWidth(DNAFrameAssign_w)
DNAFrameAssignTitle:SetHeight(35)
DNAFrameAssignTitle:SetPoint("TOPLEFT", 0, 12)
DNAFrameAssignTitle:SetBackdrop({
  bgFile = "Interface/HelpFrame/DarkSandstone-Tile",
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 26,
  insets = {left=8, right=8, top=8, bottom=8},
})
local DNAFrameAssignTitleText = DNAFrameAssignTitle:CreateFontString(nil, "ARTWORK")
DNAFrameAssignTitleText:SetFont(DNAGlobal.font, 13, "OUTLINE")
DNAFrameAssignTitleText:SetPoint("TOPLEFT", DNAFrameAssignTitle, "TOPLEFT", 15, -12)
DNAFrameAssignTitleText:SetText("Assignments            [DNA v" .. DNAGlobal.version .. "]")
DNAFrameAssignTitleText:SetTextColor(1.0, 1.0, 0.5)

local DNAFrameAssignPage={}
DNAFrameAssignPage["assign"] = CreateFrame("Frame", nil, DNAFrameAssign)
DNAFrameAssignPage["assign"]:SetWidth(DNAFrameAssign_w)
DNAFrameAssignPage["assign"]:SetHeight(DNAFrameAssign_h)
DNAFrameAssignPage["assign"]:SetPoint("TOPLEFT", 0, 0)
DNAFrameAssignPage["map"] = CreateFrame("Frame", nil, DNAFrameAssign)
DNAFrameAssignPage["map"]:SetWidth(DNAFrameAssign_w)
DNAFrameAssignPage["map"]:SetHeight(DNAFrameAssign_h)
DNAFrameAssignPage["map"]:SetPoint("TOPLEFT", 0, 0)

DNAFrameAssignBossText = DNAFrameAssignPage["assign"]:CreateFontString(nil, "ARTWORK")
DNAFrameAssignBossText:SetFont("Fonts/MORPHEUS.ttf", 18, "OUTLINE")
DNAFrameAssignBossText:SetPoint("TOPLEFT", DNAFrameAssignPage["assign"], "TOPLEFT", 120, -40)
DNAFrameAssignBossText:SetText("Empty")
DNAFrameAssignBossIcon = DNAFrameAssignPage["assign"]:CreateTexture(nil, "OVERLAY", nil, 2)
DNAFrameAssignBossIcon:SetSize(90, 50)
DNAFrameAssignBossIcon:SetPoint("TOPLEFT", 25, -20)
DNAFrameAssignBossIcon:SetTexture("")
DNAFrameAssign:SetBackdrop({
  bgFile = DNAGlobal.background,
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 26,
  insets = {left=8, right=8, top=8, bottom=8},
})
--"InsetFrameTemplate"
local DNAFrameAssignScrollBG = CreateFrame("Frame", nil, DNAFrameAssignPage["assign"], "InsetFrameTemplate")
DNAFrameAssignScrollBG:SetWidth(DNAFrameAssign_w-40)
DNAFrameAssignScrollBG:SetHeight(DNAFrameAssign_h-150)
DNAFrameAssignScrollBG:SetPoint("TOPLEFT", 20, -70)

DNAFrameAssign.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAFrameAssignPage["assign"], "UIPanelScrollFrameTemplate")
DNAFrameAssign.ScrollFrame:SetPoint("TOPLEFT", DNAFrameAssignPage["assign"], "TOPLEFT", 6, -85)
DNAFrameAssign.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAFrameAssignPage["assign"], "BOTTOMRIGHT", 6, 80)
local DNAFrameAssignScrollChild = CreateFrame("Frame", nil, DNAFrameAssign.ScrollFrame)
DNAFrameAssignScrollChild:SetSize(DNAFrameAssign_w-40, DNAFrameAssign_h-80)
DNAFrameAssign.ScrollFrame:SetScrollChild(DNAFrameAssignScrollChild)
DNAFrameAssign.ScrollFrame.ScrollBar:ClearAllPoints()
DNAFrameAssign.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAFrameAssign.ScrollFrame, "TOPRIGHT", -175, -5)
DNAFrameAssign.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAFrameAssign.ScrollFrame, "BOTTOMRIGHT", 100, 20)
--[==[
DNAFrameAssignScrollChild.bg = DNAFrameAssignScrollChild:CreateTexture(nil, "ARTWORK")
DNAFrameAssignScrollChild.bg:SetAllPoints(true)
DNAFrameAssignScrollChild.bg:SetColorTexture(0, 1, 0, 0.1)
]==]--
DNAFrameAssign:SetScript("OnDragStart", function()
    DNAFrameAssign:StartMoving()
end)
DNAFrameAssign:SetScript("OnDragStop", function()
    DNAFrameAssign:StopMovingOrSizing()
end)
for i = 1, viewFrameLines do
  DNAFrameAssignScrollChild_mark[i] = DNAFrameAssignScrollChild:CreateTexture(nil, "ARTWORK")
  DNAFrameAssignScrollChild_mark[i]:SetSize(16, 16)
  DNAFrameAssignScrollChild_mark[i]:SetPoint("TOPLEFT", 20, (-i*18)+22)
  DNAFrameAssignScrollChild_mark[i]:SetTexture("")

  DNAFrameAssignScrollChild_tank[i] = DNAFrameAssignScrollChild:CreateFontString(nil, "ARTWORK")
  DNAFrameAssignScrollChild_tank[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameAssignScrollChild_tank[i]:SetText("")
  DNAFrameAssignScrollChild_tank[i]:SetPoint("TOPLEFT", 45, (-i*18)+20)

  DNAFrameAssignScrollChild_heal[i] = DNAFrameAssignScrollChild:CreateFontString(nil, "ARTWORK")
  DNAFrameAssignScrollChild_heal[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameAssignScrollChild_heal[i]:SetText("")
  DNAFrameAssignScrollChild_heal[i]:SetPoint("TOPLEFT", 145, (-i*18)+20)
end
local DNAFrameAssignReady = CreateFrame("Button", nil, DNAFrameAssign)
DNAFrameAssignReady:SetWidth(120)
DNAFrameAssignReady:SetHeight(28)
DNAFrameAssignReady:SetPoint("TOPLEFT", 70, -DNAFrameAssign_h+65)
DNAFrameAssignReady.text = DNAFrameAssignReady:CreateFontString(nil, "ARTWORK")
DNAFrameAssignReady.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
DNAFrameAssignReady.text:SetText("Ready        √")
DNAFrameAssignReady.text:SetPoint("CENTER", DNAFrameAssignReady)
DNAFrameAssignReady:SetBackdrop({
  bgFile = "Interface/Buttons/GREENGRAD64",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 15,
  insets = {left=4, right=4, top=4, bottom=4},
})
DNAFrameAssignReady:SetBackdropColor(0.8, 0.8, 0.8, 1)
DNAFrameAssignReady:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
DNAFrameAssignReady:SetScript("OnEnter", function()
  DNAFrameAssignReady:SetBackdropBorderColor(1, 1, 1, 1)
end)
DNAFrameAssignReady:SetScript("OnLeave", function()
  DNAFrameAssignReady:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
end)
DNAFrameAssignReady:SetScript("OnClick", function()
  ConfirmReadyCheck(1)
  DNASendPacket("send", "+" .. player.name, true)
  DNAFrameAssign:Hide()
end)

DNAFrameAssignNotReady = CreateFrame("Button", nil, DNAFrameAssign)
DNAFrameAssignNotReady:SetWidth(120)
DNAFrameAssignNotReady:SetHeight(28)
DNAFrameAssignNotReady:SetPoint("TOPLEFT", 210, -DNAFrameAssign_h+65)
DNAFrameAssignNotReady.text = DNAFrameAssignNotReady:CreateFontString(nil, "ARTWORK")
DNAFrameAssignNotReady.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
DNAFrameAssignNotReady.text:SetText("Not Ready     X")
DNAFrameAssignNotReady.text:SetPoint("CENTER", DNAFrameAssignNotReady)
DNAFrameAssignNotReady:SetBackdrop({
  bgFile = "Interface/Buttons/RedGrad64",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 15,
  insets = {left=4, right=4, top=4, bottom=4},
})
DNAFrameAssignNotReady:SetBackdropColor(0.5, 0.4, 0.4, 1)
DNAFrameAssignNotReady:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
DNAFrameAssignNotReady:SetScript("OnEnter", function()
  DNAFrameAssignNotReady:SetBackdropBorderColor(1, 1, 1, 1)
end)
DNAFrameAssignNotReady:SetScript("OnLeave", function()
  DNAFrameAssignNotReady:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
end)
DNAFrameAssignNotReady:SetScript("OnClick", function()
  ConfirmReadyCheck()
  DNASendPacket("send", "!" .. player.name, true)
  --DNAFrameAssignNotReady:SetBackdropColor(0.2, 0.1, 0.1, 0.4)
  DNAFrameAssign:Hide()
end)
DNAFrameAssignAuthor = DNAFrameAssign:CreateFontString(nil, "ARTWORK")
DNAFrameAssignAuthor:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignAuthor:SetText("")
DNAFrameAssignAuthor:SetPoint("CENTER", 0, -205)
DNAFrameAssignAuthor:SetTextColor(0.8, 0.8, 0.8)

local DNAFrameAssignTab={}

function DNAFrameAssignTabToggle(name)
  DNAFrameAssignTab["assign"]:SetFrameLevel(1)
  DNAFrameAssignTab["map"]:SetFrameLevel(1)
  DNAFrameAssignPage["assign"]:Hide()
  DNAFrameAssignPage["map"]:Hide()
  DNAFrameAssignTab[name]:SetFrameLevel(155)
  DNAFrameAssignPage[name]:Show()
end

function DNAFrameAssignSideTab(name, icon, pos_y)
  DNAFrameAssignTab[name] = CreateFrame("Button", nil, DNAFrameAssign)
  DNAFrameAssignTab[name]:SetWidth(50)
  DNAFrameAssignTab[name]:SetHeight(50)
  DNAFrameAssignTab[name]:SetPoint("TOPLEFT", -45, -pos_y)
  DNAFrameAssignTab[name]:SetFrameLevel(1)
  local DNAFrameAssignTabBorder = DNAFrameAssignTab[name]:CreateTexture(nil, "BACKGROUND", DNAFrameAssignTab[name], 2)
  DNAFrameAssignTabBorder:SetSize(50, 50)
  DNAFrameAssignTabBorder:SetPoint("TOPLEFT", 0, 0)
  DNAFrameAssignTabBorder:SetTexture("Interface/COMMON/GreyBorder64-Left")
  local DNAFrameAssignTabBG = DNAFrameAssignTab[name]:CreateTexture(nil, "BACKGROUND", DNAFrameAssignTab[name], -1)
  DNAFrameAssignTabBG:SetSize(54, 38)
  DNAFrameAssignTabBG:SetPoint("TOPLEFT", 5, -6)
  DNAFrameAssignTabBG:SetTexture(DNAGlobal.background)
  local DNAFrameAssignTabIcon = DNAFrameAssignTab[name]:CreateTexture(nil, "BACKGROUND", DNAFrameAssignTab[name], 1)
  DNAFrameAssignTabIcon:SetSize(44, 40)
  DNAFrameAssignTabIcon:SetPoint("TOPLEFT", 5, -6)
  DNAFrameAssignTabIcon:SetTexture(icon)
  DNAFrameAssignTab[name]:SetScript("OnClick", function()
    DNAFrameAssignTabToggle(name)
  end)
end

--[==[
local DNAFrameAssignMap={}
for i=1, 4 do
  DNAFrameAssignMap[i] = DNAFrameAssignPage["map"]:CreateTexture(nil, "BORDER")
  DNAFrameAssignMap[i]:SetSize(90, 90)
  DNAFrameAssignMap[i]:SetPoint("TOPLEFT", i*90-70, -20)
  DNAFrameAssignMap[i]:SetTexture("Interface/WorldMap/BlackwingLair/BlackwingLair1_" .. i)
end
for i=1, 4 do
  DNAFrameAssignMap[i+4] = DNAFrameAssignPage["map"]:CreateTexture(nil, "BORDER")
  DNAFrameAssignMap[i+4]:SetSize(90, 90)
  DNAFrameAssignMap[i+4]:SetPoint("TOPLEFT", i*90-70, -110)
  DNAFrameAssignMap[i+4]:SetTexture("Interface/WorldMap/BlackwingLair/BlackwingLair1_" .. i+4)
end
for i=1, 4 do
  DNAFrameAssignMap[i+8] = DNAFrameAssignPage["map"]:CreateTexture(nil, "BORDER")
  DNAFrameAssignMap[i+8]:SetSize(90, 90)
  DNAFrameAssignMap[i+8]:SetPoint("TOPLEFT", i*90-70, -200)
  DNAFrameAssignMap[i+8]:SetTexture("Interface/WorldMap/BlackwingLair/BlackwingLair1_" .. i+8)
end
]==]--

DNAFrameAssignSideTab("assign", "Interface/Calendar/Holidays/Calendar_WeekendWorldQuestEnd", 30)
--DNAFrameAssignSideTab("map", "Interface/WorldMap/Azeroth/Azeroth3", 80)
DNAFrameAssignSideTab("map", "Interface/WorldMap/MoltenCore/MoltenCore1_7", 80)

DNAFrameAssignTabToggle("assign") --default

DNAFrameAssign:Hide()

globalNotification("Initializing...")

local boss_icon = nil

function instanceMC(assign, total, raid, markers, mark, text, heal, tank, healer)
  local fear_ward={}

  if (isItem(assign, "Trash MC")) then
    NUM_ADDS = 3
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-BaelGar"
    for i=1, NUM_ADDS+1 do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Lucifron")) then
    num_adds = 2
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Lucifron"
    for i=1, num_adds+1 do
      mark[i] = markers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    --assign up to 5 healers to dispel
    for i=1, 5 do
      if (raidClass[healer.all[i+num_adds+1]] ~= "Druid") then
        mark[i+num_adds+1] = "Interface/Icons/spell_holy_dispelmagic"
        text[i+num_adds+1] = "MC Dispells"
        heal[i+num_adds+1] = healer.all[i+num_adds+1]
      end
    end
    mark[1] = boss_icon
  end

  if (isItem(assign, "Gehennas")) then
    num_adds = 2
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Gehennas"
    for i=1, num_adds+1 do
      mark[i] = markers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    num_healers_dr = table.getn(healer.druid)
    for i=1, num_healers_dr do
      mark[i+num_adds+2] = "Interface/Icons/spell_holy_removecurse"
      text[i+num_adds+2] = "Decurse"
      heal[i+num_adds+2] = healer.druid[i]
    end
    for i=1, total.mages do
      mark[i+num_adds+num_healers_dr+2] = "Interface/Icons/spell_nature_removecurse"
      text[i+num_adds+num_healers_dr+2] = "Decurse"
      heal[i+num_adds+num_healers_dr+2] = raid.mage[i]
    end
    mark[1] = boss_icon
  end

  if (isItem(assign, "Dogpack")) then
    num_adds = 5
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Son of the Beast"
    for i=1, num_adds do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
    end
  end

  if (isItem(assign, "Magmadar")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Magmadar"
    mark[1] = boss_icon
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2]
    --fear warders
    for i=1, healSlots do
      if ((raidClass[healer.all[i]] == "Priest") and (raidRace[healer.all[i]] == "Dwarf")) then
        fear_ward[i] = healer.all[i]
      end
    end
    for k,v in pairs(fear_ward) do
      mark[3] = "Interface/Icons/spell_holy_excorcism"
      text[3] = "Fear Ward"
      heal[3] = v
    end

    for i=1, table.getn(raid.hunter) do
      mark[i+4] = "Interface/Icons/spell_nature_drowsy"
      text[i+4] = "Tranq Shot"
      heal[i+4] = raid.hunter[i]
    end

  end

  if (isItem(assign, "Garr")) then
    num_adds = 8
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Lord Roccor"
    for i=1, num_adds do
      mark[i] = markers[i][2]
      text[i] = tank.banish[i]
      if (raidClass[tank.banish[i]] ~= "Warlock") then
        heal[i] = healer.all[i] --we dont need healers for banishers
      end
    end
    mark[1] = boss_icon
  end

  if (isItem(assign, "Lava Pack")) then
    num_adds = 3 --minimum, last for a banisher
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Garr"
    for i=1, num_adds do
      mark[i] = markers[i+1][2]
      text[i] = tank.banish[i]
      heal[i] = healer.all[i]
    end
    if (raid.warlock[1]) then
      mark[4] = markers[5][2]
      text[4] = raid.warlock[1]
    else
      text[4] = tank.all[4]
    end

    text[6] = "-- Backup --"

    if (raid.warlock[2]) then
      mark[7] = markers[6][2]
      text[7] = raid.warlock[2]
    else
      text[7] = tank.all[5]
    end
  end

  if (isItem(assign, "Sulfuron")) then
    num_adds = 5
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Sulfuron Harbinger"
    for i=1, num_adds do
      mark[i] = markers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    text[7] = "-- Rogue Kicks / Warrior Pummels -- " --add a space
    if (raid.rogue[1]) then
      mark[8] = markers[2][2]
      text[8] = raid.rogue[1]
    else
      if (raid.warrior[5]) then
        mark[8] = markers[2][2]
        text[8] = raid.warrior[5]
      end
    end
    if (raid.rogue[2]) then
      mark[9] = markers[3][2]
      text[9] = raid.rogue[2]
    else
      if (raid.warrior[6]) then
        mark[8] = markers[2][2]
        text[8] = raid.warrior[6]
      end
    end
    if (raid.rogue[3]) then
      mark[10] = markers[4][2]
      text[10] = raid.rogue[3]
    else
      if (raid.warrior[7]) then
        mark[8] = markers[2][2]
        text[8] = raid.warrior[7]
      end
    end
    if (raid.rogue[4]) then
      mark[11] = markers[5][2]
      text[11] = raid.rogue[4]
    else
      if (raid.warrior[8]) then
        mark[8] = markers[2][2]
        text[8] = raid.warrior[8]
      end
    end
    mark[1] = boss_icon
  end

  if (isItem(assign, "Golemagg")) then
    num_adds = 2
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Golemagg the Incinerator"
    for i=1, num_adds+1 do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i] .. "," .. healer.all[i+num_adds+1]
    end
  end

  if (isItem(assign, "Majordomo Executus")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Majordomo Executus"
    for i=1, 5 do
      mark[i] = markers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    mark[1] = boss_icon

    mark[6] = icon_square
    if (raid.mage[1]) then
      text[6] = raid.mage[1]
    else
      text[6] = tank.all[6]
      heal[6] = healer.all[6]
    end
    mark[7] = icon_diamond
    if (raid.mage[2]) then
      text[7] = raid.mage[2]
    else
      text[7] = tank.all[7]
      heal[7] = healer.all[7]
    end
    mark[8] = icon_moon
    if (raid.mage[3]) then
      text[8] = raid.mage[3]
    else
      text[8] = tank.all[8]
      heal[8] = healer.all[8]
    end
    mark[9] = icon_star
    if (raid.mage[4]) then
      text[9] = raid.mage[4]
    else
      text[9] = tank.all[9]
      heal[9] = healer.all[9]
    end
    if (raid.hunter[1]) then
      mark[11] = boss_icon
      text[11] = "Distracting"
      heal[11] = raid.hunter[1]
    end
  end

  if (isItem(assign, "Ragnaros")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Ragnaros"
    mark[1] = boss_icon
    text[1] = tank.main[1]
    heal[1] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    if (tank.main[2]) then
      mark[2] = boss_icon
      text[2] = tank.main[2]
      heal[2] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    end
    if (tank.main[3]) then --is there a third tank
      mark[3] = boss_icon
      text[3] = tank.main[3]
      heal[3] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    end
    text[5] = "Melee Heals"
    heal[5] = healer.all[4] .. "," .. healer.all[5]
  end
end

-- BUILD THE RAID PER BOSS
local function buildRaidAssignments(packet, author, source)
  local assign = packet
  local tank={}
  tank.main={}
  tank.banish={}
  tank.all={}
  local heal = {}
  local healer={}
  healer.all = {}
  healer.priest={}
  healer.paladin={}
  healer.druid ={}
  local boss=""
  local mark = {}
  local text = {}
  local num_adds = 0
  --local fear_ward = {}
  local raid={}
  raid.warrior={}
  raid.mage={}
  raid.paladin={}
  raid.hunter={}
  raid.rogue={}
  raid.warlock={}
  raid.priest={}
  raid.druid={}

  updateRaidRoster()

  clearFrameView() --clear out the current text
  clearFrameAssign()

  if (total.raid < 8) then
    return DNAFrameViewScrollChild_tank[3]:SetText("Not enough raid members to form assignments!")
  end

  for i = 1, tankSlots do
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tank.main[i] = tankSlot[i].text:GetText()
      -- always build tanks so the 'nils' dont error
      --tank.all[i] = tankSlot[i].text:GetText()
      tank.banish[i] = tankSlot[i].text:GetText()
    end
  end

  for i = 1, healSlots do
    if (healSlot[i].text:GetText() ~= "Empty") then
      healer.all[i] = healSlot[i].text:GetText()
      if (raidClass[healer.all[i]] == "Paladin") then
        table.insert(healer.paladin, healer.all[i])
      end
      if (raidClass[healer.all[i]] == "Druid") then
        table.insert(healer.druid, healer.all[i])
      end
      if (raidClass[healer.all[i]] == "Priest") then
        table.insert(healer.priest, healer.all[i])
      end
    end
  end

  --include warriors as OT
  for k,v in pairs(raidClass) do
    if (v == "Warrior") then
      if (tContains(tank.main, k) == false) then
        table.insert(raid.warrior, k) -- exclude tanks
      end
    end
    if (v == "Paladin") then
      if (tContains(healer.all, k) == false) then
        table.insert(raid.paladin, k) -- exclude healers
      end
    end
    if (v == "Priest") then
      if (tContains(healer.priest, k) == false) then
        table.insert(raid.priest, k) -- exclude healers
      end
    end
    if (v == "Druid") then
      if (tContains(healer.druid, k) == false) then
        table.insert(raid.druid, k) -- exclude healers
      end
    end
    if (v == "Rogue") then
      table.insert(raid.rogue, k)
    end
    if (v == "Warlock") then
      table.insert(raid.warlock, k)
    end
    if (v == "Hunter") then
      table.insert(raid.hunter, k)
    end
    if (v == "Mage") then
      table.insert(raid.mage, k)
    end
  end

  if (DEBUG) then
    print("num_tanks " .. total.tanks)
    print("num_healers " .. total.healers)
    print("num_warriors " .. total.warriors)
    print("num_hunters " .. total.hunters)
    print("num_rogues " .. total.rogues)
    print("num_druids " .. total.druids)
    print("num_priests " .. total.priests)
    print("num_mages " .. total.mages)
    print("num_paladins " .. total.paladins)
    print("num_warlocks " .. total.warlocks)
  end

  table.merge(tank.all, tank.main)
  table.merge(tank.all, raid.warrior)
  table.merge(tank.banish, raid.warlock)
  table.merge(tank.banish, raid.warrior) -- merge all tanks with warlocks

  --[==[
  for i=1, table.getn(tank.banish) do
    print(tank.banish[i])
  end
  ]==]--

  instanceMC(assign, total, raid, markers, mark, text, heal, tank, healer)

  if (isItem(assign, "Razorgore")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Razorgore the Untamed"
    for i=1, 5 do
      heal[i] = tank.all[i] .. "," .. healer.all[i]
    end
    --mark[1] = "Interface/Icons/INV_Misc_Orb_03"
    text[1] = "-ORB-"
    --mark[2] = "Interface/MiniMap/MiniMap-QuestArrow"
    text[2] = "-NORTH-"
    --mark[3] = "Interface/Buttons/UI-SpellbookIcon-NextPage-Up"
    text[3] = "-EAST-"
   --mark[4] = "Interface/Buttons/Arrow-Down-Up"
    text[4] = "-SOUTH-"
    --mark[5] = "Interface/Buttons/UI-SpellbookIcon-PrevPage-Up"
    text[5] = "-WEST-"
  end

  if (isItem(assign, "Vaelestraz")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Vaelastrasz the Corrupt"
    local healer_row = ""
    local vael_heals = {}
    table.merge(vael_heals, healer.priest)
    table.merge(vael_heals, healer.druid)
    for i=1, table.getn(healer.paladin) do
      if (i <= 4) then --max at 4 pally healers
        healer_row = healer_row .. healer.paladin[i] .. ","
      end
    end
    for i=1, 3 do
      text[i] = tank.all[i]
      heal[i] = healer_row
    end
    text[5] = "-- RAID HEALS --"
    for i=1, table.getn(vael_heals) do
      text[i+5] = vael_heals[i]
    end
  end

  if (isItem(assign, "Dragon Pack")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Overlord Wyrmthalak"
    for i=1, 3 do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    mark[4] = icon_circle
    mark[5] = icon_square
    if (raid.hunter[1]) then
      text[4] = raid.hunter[1]
    else
      text[4] = tank.all[4]
    end
    if (raid.hunter[2]) then
      text[5] = raid.hunter[2]
    else
      text[5] = tank.all[5]
    end
    if (healer.druid[1]) then
      mark[6] = icon_diamond
      text[6] = healer.druid[1]
      heal[6] = healer.all[4]
      if (heal[6] == healer.all[4]) then
        heal[6] = healer.all[5]
      end
    end
    if (healer.druid[2]) then
      mark[7] = icon_moon
      text[7] = healer.druid[2]
      heal[7] = healer.all[6]
      if (heal[7] == healer.all[6]) then
        heal[7] = healer.all[7]
      end
    end
    text[9] = "Extra marks provided for Crowd Control"
  end

  if (isItem(assign, "Suppression Room")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Flamebender Kagraz"
    NUM_ADDS = 3
    text[1] = "No AOE Tank assigned!" --default message
    for i=1, tankSlots do
      if ((raidClass[tank.main[i]] == "Paladin") or (raidClass[tank.main[i]] == "Druid")) then
        text[1] = "Whelps"
        heal[1] = tank.main[i]
      end
    end
    for i=1, NUM_ADDS do
      mark[i+1] = markers[i+1][2]
      text[i+1] = tank.all[i]
      heal[i+1] = healer.all[i]
    end
    for i=1, total.rogues do
      text[i+NUM_ADDS*2] = "Device"
      heal[i+NUM_ADDS*2] = raid.rogue[i]
    end
  end

  if (isItem(assign, "Goblin Pack")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Pauli Rocketspark"
    for i=1, 6 do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    text[8] = "-- PULL --"
    heal[8] = "-- TANK --"

    for i=1, 4 do
      if (raid.hunter[i]) then
        mark[i+8] = markers[i+1][2]
        text[i+8] = raid.hunter[i]
        heal[i+8] = tank.all[i]
      end
    end
  end

  if (isItem(assign, "Firemaw")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Firemaw"
    text[1] = tank.all[1]
    heal[1] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    if (tank.all[3]) then
      text[3] = "-- Stack Rotation Relief --"
      text[4] = tank.all[3]
      heal[4] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    end
    text[6] = "-- Wingbuff --"
    text[7] = tank.all[2]
    heal[7] = healer.paladin[3] .. "," .. healer.priest[2] .. "," .. healer.priest[3]

    text[9] = "-- RANGE HEALERS --"
    text[10] = healer.priest[4]

    text[12] = "-- MELEE HEALERS --"
    local firemaw_heals = {}
    table.merge(firemaw_heals, healer.all)
    for i=1, table.getn(firemaw_heals) do
      print("before :" .. i .. firemaw_heals[i])
    end
    --remove the assigned healers
    removeValueFromArray(firemaw_heals, healer.paladin[1])
    removeValueFromArray(firemaw_heals, healer.paladin[2])
    removeValueFromArray(firemaw_heals, healer.paladin[3])
    removeValueFromArray(firemaw_heals, healer.priest[1])
    removeValueFromArray(firemaw_heals, healer.priest[2])
    removeValueFromArray(firemaw_heals, healer.priest[3])
    removeValueFromArray(firemaw_heals, healer.priest[4])

    for i=1, table.getn(firemaw_heals) do
      print("after :" .. i .. firemaw_heals[i])
    end
    for i=1, table.getn(firemaw_heals) do
      if (firemaw_heals[i]) then
        text[i+12] = firemaw_heals[i]
      end
    end
  end

  if (isItem(assign, "Small Wyrmguards (4)")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer"
    NUM_ADDS = 4
    for i=1, NUM_ADDS do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Large Wyrmguards (3)")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer"
    NUM_ADDS = 3
    for i=1, NUM_ADDS do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    text[5] = "-- BACKUP --"
    for i=1, NUM_ADDS do
      mark[i+5] = markers[i+1][2]
      text[i+5] = tank.all[i+3]
      heal[i+5] = healer.all[i+3]
    end
  end

  --wow-ui-textures/EncounterJournal/UI-EJ-BOSS-Harbinger Skyriss.PNG
  --UI-EJ-BOSS-General Rajaxx.PNG
  --UI-EJ-BOSS-Ayamiss the Hunter.PNG
  --UI-EJ-BOSS-Ossirian the Unscarred
  --UI-EJ-BOSS-Setesh

  if (isItem(assign, "Anubisath Sentinels")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Setesh"
    num_adds = 4
    for i=1, num_adds do
      mark[i] = markers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]

      if (raid.mage[i]) then
        mark[i+num_adds+1] = "Interface/Icons/spell_holy_dizzy"
        text[i+num_adds+1] = "Detect Magic"
        heal[i+num_adds+1] = raid.mage[i]
      end
    end
  end

  for i = 1, viewFrameLines do
    if (mark[i]) then
      DNAFrameViewScrollChild_mark[i]:SetTexture(mark[i])
      DNAFrameAssignScrollChild_mark[i]:SetTexture(mark[i])
    end
    if (text[i]) then
      DNAFrameViewScrollChild_tank[i]:SetText(text[i])
      classColorText(DNAFrameViewScrollChild_tank[i], raidClass[text[i]])
      DNAFrameAssignScrollChild_tank[i]:SetText(text[i])
      classColorText(DNAFrameAssignScrollChild_tank[i], raidClass[text[i]])
    end

    if (heal[i]) then
      local filterHealer={}
      healer_row = split(heal[i], ",")
      filterHealer[i] = string.gsub(heal[i], ',', " / ")
      filter_row = ""
      for n=1, table.getn(healer_row) do
        if (n > 1) then
          filter_row = filter_row .. " / " .. classColorAppend(healer_row[n], raidClass[healer_row[n]])
        else
          filter_row = classColorAppend(healer_row[n], raidClass[healer_row[n]])
        end
      end
      --print(filter_row)
      DNAFrameViewScrollChild_heal[i]:SetText(filter_row)
      DNAFrameAssignScrollChild_heal[i]:SetText(filter_row)
    end
  end

  pageBossIcon:SetTexture(boss_icon)
  DNAFrameAssignBossIcon:SetTexture(boss_icon)
  if (author ~= nil) then
    DNAFrameAssignAuthor:SetText(author .. " has sent raid assignments.")
  end


  raidSelection = packet
end

function raidDetails()
  pageRaidDetailsColOne[1]:SetText("Druids")
  classColorText(pageRaidDetailsColOne[1], "Druid")
  pageRaidDetailsColTwo[1]:SetText(total.druids)

  pageRaidDetailsColOne[2]:SetText("Hunters")
  classColorText(pageRaidDetailsColOne[2], "Hunter")
  pageRaidDetailsColTwo[2]:SetText(total.hunters)

  pageRaidDetailsColOne[3]:SetText("Mages")
  classColorText(pageRaidDetailsColOne[3], "Mage")
  pageRaidDetailsColTwo[3]:SetText(total.mages)

  pageRaidDetailsColOne[4]:SetText("Paladins")
  classColorText(pageRaidDetailsColOne[4], "Paladin")
  pageRaidDetailsColTwo[4]:SetText(total.paladins)

  pageRaidDetailsColOne[5]:SetText("Priests")
  classColorText(pageRaidDetailsColOne[5], "Priest")
  pageRaidDetailsColTwo[5]:SetText(total.priests)

  pageRaidDetailsColOne[6]:SetText("Rogues")
  classColorText(pageRaidDetailsColOne[6], "Rogue")
  pageRaidDetailsColTwo[6]:SetText(total.rogues)

  pageRaidDetailsColOne[7]:SetText("Warlocks")
  classColorText(pageRaidDetailsColOne[7], "Warlock")
  pageRaidDetailsColTwo[7]:SetText(total.warlocks)

  pageRaidDetailsColOne[8]:SetText("Warriors")
  classColorText(pageRaidDetailsColOne[8], "Warrior")
  pageRaidDetailsColTwo[8]:SetText(total.warriors)

  pageRaidDetailsColOne[10]:SetText("Total Range")
  pageRaidDetailsColTwo[10]:SetText(total.range)
  pageRaidDetailsColOne[11]:SetText("Total Melee")
  pageRaidDetailsColTwo[11]:SetText(total.melee)

  pageRaidDetailsColOne[13]:SetText("Total")
  pageRaidDetailsColTwo[13]:SetText(total.raid)
end

local DNAMain = CreateFrame("Frame")
DNAMain:RegisterEvent("ADDON_LOADED")
DNAMain:RegisterEvent("PLAYER_LOGIN")
DNAMain:RegisterEvent("PLAYER_ENTERING_WORLD")
local success = C_ChatInfo.RegisterAddonMessagePrefix("dnassist")
DNAMain:RegisterEvent("CHAT_MSG_ADDON")
DNAMain:RegisterEvent("ZONE_CHANGED")
DNAMain:RegisterEvent("ZONE_CHANGED_NEW_AREA")
DNAMain:RegisterEvent("GROUP_ROSTER_UPDATE")
DNAMain:RegisterEvent("PLAYER_ENTER_COMBAT")
DNAMain:RegisterEvent("PLAYER_REGEN_DISABLED")
DNAMain:RegisterEvent("CHAT_MSG_LOOT")

DNAMain:SetScript("OnEvent", function(self, event, prefix, netpacket)
  if ((event == "ADDON_LOADED") and (prefix == "DNA")) then
    if (DNA == nil) then
      DNA = {}
    end
    if (DNA[player.combine] == nil) then
      DNA[player.combine] = {}
    end
    if (DNA[player.combine]["Loot Log"] == nil) then
      DNA[player.combine]["Loot Log"] = {}
    end
    if (DNA[player.combine]["Loot Log"][date_day] == nil) then
      DNA[player.combine]["Loot Log"][date_day] = {}
    end
  end

  if (event == "PLAYER_LOGIN") then
    if (DNA == nil) then
      DNA = {}
    end
    if (DNA[player.combine] == nil) then
      DNA[player.combine] = {}
      if (DNA[player.combine]["Loot Log"] == nil) then
        DNA[player.combine]["Loot Log"] = {}
      end
      globalNotification("Creating Raid Profile: " .. player.combine)
    else
      globalNotification("Loading Raid Profile: " .. player.combine)
      setDNAVars()
    end
  end

  --[==[
  if (event == "CHAT_MSG_LOOT") then
    loot_msg = string.match(prefix, "item[%-?%d:]+")
    --local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(loot_msg)
    --DNASendPacket("send", "_" .. player.name .. "," .. itemName, false)
    --safeter to store by the odd string for the itemID
    local inInstance, instanceType = IsInInstance()
    if (inInstance) then
      if (instanceType == "Raid") then
        local instanceName = GetInstanceInfo()
        if (instanceName) then
          DNASendPacket("send", "_" .. instanceName .. "," .. player.name .. "," .. loot_msg, false)
        end
      end
    end
  end
  ]==]--

  if (event == "GROUP_ROSTER_UPDATE") then
    updateRaidRoster()
  end

  if ((event == "PLAYER_ENTER_COMBAT") or (event== "PLAYER_REGEN_DISABLED")) then
    raidReadyClear()
    print("entered combat!")
  end

  if (event == "CHAT_MSG_ADDON") then
    if (prefix == "dnassist") then
      print("DEBUG: CHAT_MSG_ADDON " .. netpacket)

      --parse incoming large packet chunk
      if (string.sub(netpacket, 1, 1) == "{") then
        netpacket = netpacket .. "EOL"
        netpacket = string.gsub(netpacket, '}EOL', "")
        local filteredPacket = {}
        packetChunk = split(netpacket, "}")
        for x=1, table.getn(packetChunk) do
          filteredPacket[x] = string.gsub(packetChunk[x], "{", "")
          parsePacket(packet, filteredPacket[x])
        end
         raidReadyClear()
        return true
      end
      if (string.sub(netpacket, 1, 1) == "&") then
        netpacket = string.gsub(netpacket, "&", "")
        local raid_assignment = split(netpacket, ",")
        print(raid_assignment[1])
        print(raid_assignment[2])
        buildRaidAssignments(raid_assignment[1], raid_assignment[2], "network")
        DNAFrameAssign:Show()
        raidReadyClear()
        return true
      end
      if (string.sub(netpacket, 1, 1) == "#") then
        netpacket = string.gsub(netpacket, "#", "")
        --if (version_checked <= 0) then
          if (DNAGlobal.version < netpacket) then
            globalNotification("|cffff0000 You have an outdated version!\nCurrent version is " .. netpacket)
            version_checked = tonumber(netpacket)
          end
        --end
        return true
      end
      --READYCHECK
      if (string.sub(netpacket, 1, 1) == "+") then
        netpacket = string.gsub(netpacket, "+", "")
        raidReadyMember(netpacket, true)
        return true
      end
      --NOT READY
      if (string.sub(netpacket, 1, 1) == "!") then
        netpacket = string.gsub(netpacket, "!", "")
        raidReadyMember(netpacket, false)
        return true
      end
      --LOOT
      if (string.sub(netpacket, 1, 1) == "_") then
        if (DNA[player.combine]["Loot Log"][date_day] == nil) then
          DNA[player.combine]["Loot Log"][date_day] = {}
        end
        netpacket = string.gsub(netpacket, "_", "")

        local inInstance, instanceType = IsInInstance()
        if (inInstance) then
          if (instanceType == "Raid") then
            local instanceName = GetInstanceInfo()
            if (instanceName) then
              table.insert(DNA[player.combine]["Loot Log"][date_day], {timestamp .. "," .. instanceName .. "," .. netpacket})
            end
          end
        end
        --print(cur_date)
        --DNA[player.combine]["Loot Log"] = {cur_date .. "," .. netpacket}
        table.insert(DNA[player.combine]["Loot Log"][date_day], {netpacket .. "," .. timestamp})
        --print(netpacket)
        return true
      end
      if (string.sub(netpacket, 1, 1) == "@") then
        netpacket = string.gsub(netpacket, "@", "")
        --DNAFrameAssign:Show()
        --print("DKP Pushed: " .. netpacket)
        packetChunk = split(netpacket, "}")
        packetLength= strlen(netpacket)
        --print(packetLength)
        local DKPName={}
        local DKPNum={}
        for x=1, table.getn(packetChunk) do
          DKPName[x] = split(packetChunk[x], "=")
          if (DKPName[x][1] ~= nil) then
            DKPNum[x] = split(DKPName[x][1], ",")
            pageDKPViewScrollChild_colOne[x]:SetText(DKPName[x][1])
          end
        end
        for x=1, table.getn(DKPName) do
          if (DKPName[x][2] ~= nil) then
            DKPNum[x] = split(DKPName[x][2], ",")
          end
          if (DKPNum[x][1] ~= nil) then
            pageDKPViewScrollChild_colTwo[x]:SetText(DKPNum[x][1])
          end
          if (DKPNum[x][2] ~= nil) then
            pageDKPViewScrollChild_colThree[x]:SetText(DKPNum[x][2])
          end
        end
        return true
      end

      --single slot update, parse individual packets
      parsePacket(packet, netpacket)
    end
  end
end)

SLASH_DNA1 = "/DNA"
function SlashCmdList.DNA(msg)
  --print("DEBUG: " .. slash input)
end

--build the cached array
getRaidComp()

function setDNAVars()
  for k,v in pairs(DNA[player.combine]) do
    getsave.key = k
    getsave.role = string.gsub(k, "[^a-zA-Z]", "")
    getsave.slot = string.gsub(k, getsave.role, "")
    getsave.slot = tonumber(getsave.slot)
    getsave.name = v
    --[==[
    if (getsave.key == "minimap_x") then
      if (getsave.name ~= nil) then
        minimap_x = tonumber(getsave.name)
        print(minimap_x)
      end
    end
    if (getsave.key == "minimap_y") then
      if (getsave.name ~= nil) then
        minimap_y = tonumber(getsave.name)
        print(minimap_y)
      end
    end
    ]==]--
    if (getsave.role == "tank") then
      if ((getsave.name == nil) or (getsave.name == "Empty")) then
        tankSlot[getsave.slot].text:SetText("Empty")
        tankSlot[getsave.slot]:SetFrameLevel(2)
        tankSlot[getsave.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        tankSlot[getsave.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        classColorText(tankSlot[getsave.slot].text, "Empty")
      else
        tankSlot[getsave.slot].text:SetText(getsave.name)
        tankSlot[getsave.slot]:SetFrameLevel(3)
        tankSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        tankSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = raidClass[getsave.name]
        classColorText(tankSlot[getsave.slot].text, thisClass)
      end
    end
    if (getsave.role == "heal") then
      if ((getsave.name == nil) or (getsave.name == "Empty")) then
        healSlot[getsave.slot].text:SetText("Empty")
        healSlot[getsave.slot]:SetFrameLevel(2)
        healSlot[getsave.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        healSlot[getsave.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        classColorText(healSlot[getsave.slot].text, "Empty")
      else
        healSlot[getsave.slot].text:SetText(getsave.name)
        healSlot[getsave.slot]:SetFrameLevel(3)
        healSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        healSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = raidClass[getsave.name]
        classColorText(healSlot[getsave.slot].text, thisClass)
      end
    end
  end
  --DNAMiniMap:SetPoint("TOPLEFT",  minimap_x, minimap_y)
  if (DNA[player.combine]["Last Selection"]) then
    local instanceNum = multiKeyFromValue(instance, DNA[player.combine]["Last Selection"])
    InstanceButtonToggle(instance[instanceNum][1], instance[instanceNum][5])
    for i, v in ipairs(instance) do
      ddBossList[instance[i][1]]:Hide()
      ddBossListText[instance[i][1]]:SetText("Select a boss")
    end
    ddBossList[instance[instanceNum][1]]:Show()
  end
end

--local DNAFrameMain = CreateFrame("Frame", DNAFrameMain, UIParent, "BasicFrameTemplateWithInset")
local DNAFrameMain = CreateFrame("Frame", "DNAFrameMain", UIParent)
DNAFrameMain:SetWidth(DNAGlobal.width)
DNAFrameMain:SetHeight(DNAGlobal.height)
DNAFrameMain:SetPoint("CENTER", 20, 40)
DNAFrameMain.title = CreateFrame("Frame", nil, DNAFrameMain)
DNAFrameMain.title:SetWidth(DNAGlobal.width)
DNAFrameMain.title:SetHeight(34)
DNAFrameMain.title:SetPoint("TOPLEFT", 0, 5)
DNAFrameMain.title:SetFrameLevel(3)
DNAFrameMain.title:SetBackdrop({
  bgFile = "Interface/HelpFrame/DarkSandstone-Tile",
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 26,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNAFrameMain.text = DNAFrameMain.title:CreateFontString(nil, "ARTWORK")
DNAFrameMain.text:SetFont(DNAGlobal.font, 15, "OUTLINE")
DNAFrameMain.text:SetPoint("TOPLEFT", 20, -10)
DNAFrameMain.text:SetText(DNAGlobal.name .. " " .. DNAGlobal.version)
DNAFrameMain.text:SetTextColor(1.0, 1.0, 0.5)
DNAFrameMain:SetBackdrop({
  bgFile = DNAGlobal.background,
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 26,
  tile = true,
  tileSize = 450,
  insets = {left=4, right=4, top=20, bottom=4},
})
DNAFrameMainClose = CreateFrame("Button", nil, DNAFrameMain.title, "UIPanelButtonTemplate")
DNAFrameMainClose:SetSize(25, 24)
DNAFrameMainClose:SetPoint("TOPLEFT", DNAGlobal.width-29, -4)
DNAFrameMainCloseX= DNAFrameMainClose:CreateTexture(nil, "ARTWORK")
DNAFrameMainCloseX:SetTexture("Interface/Buttons/UI-StopButton")
DNAFrameMainCloseX:SetSize(14, 14)
DNAFrameMainCloseX:SetPoint("TOPLEFT", 5, -5)
DNAFrameMainClose:SetScript("OnClick", function()
  DNAFrameMain:Hide()
end)
DNAFrameMain:EnableKeyboard(true)
tinsert(UISpecialFrames, "DNAFrameMain")
DNAFrameMain.enter = CreateFrame("EditBox", nil, DNAFrameMain)
DNAFrameMain.enter:SetWidth(100)
DNAFrameMain.enter:SetHeight(20)
DNAFrameMain.enter:SetFontObject(GameFontNormal)
DNAFrameMain.enter:SetBackdrop(GameTooltip:GetBackdrop())
DNAFrameMain.enter:SetBackdropColor(0, 0, 0, 0.8)
DNAFrameMain.enter:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
DNAFrameMain.enter:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", -50, 0)
DNAFrameMain.enter:ClearFocus(self)
DNAFrameMain.enter:SetAutoFocus(false)
DNAFrameMain.enter:Hide()
DNAFrameMain.enter:SetScript("OnEscapePressed", function()
  DNAFrameMain:Hide()
end)

page[pages[1][1]] = CreateFrame("Frame", nil, DNAFrameMain)
page[pages[1][1]]:SetWidth(DNAGlobal.width)
page[pages[1][1]]:SetHeight(DNAGlobal.height)
page[pages[1][1]]:SetPoint("TOPLEFT", 0, 0)

local pageAssignBtnDiv={}
for i=1, 5 do
  pageAssignBtnDiv[i] = page[pages[1][1]]:CreateTexture(nil, "ARTWORK", page[pages[1][1]], 3)
  pageAssignBtnDiv[i]:SetTexture("Interface/DialogFrame/UI-DialogBox-Divider")
  pageAssignBtnDiv[i]:SetSize(256, 20)
  pageAssignBtnDiv[i]:SetPoint("TOPLEFT", 6, i*100-622)
end

local pageAssignRightDiv = page[pages[1][1]]:CreateTexture(nil, "ARTWORK")
pageAssignRightDiv:SetTexture("Interface/FrameGeneral/!UI-Frame")
pageAssignRightDiv:SetSize(12, DNAGlobal.height-28)
pageAssignRightDiv:SetPoint("TOPLEFT", 566, -21)

pageBanner = page[pages[1][1]]:CreateTexture(nil, "BACKGROUND", page[pages[1][1]], 0)
pageBanner:SetTexture(instance[1][3]) --default
pageBanner:SetTexCoord(0, 1, 0.25, 0.50)
pageBanner:SetSize(400, 54)
pageBanner:SetPoint("TOPLEFT", 570, -28)
local pageBannerBorder = page[pages[1][1]]:CreateTexture(nil, "BACKGROUND", page[pages[1][1]], 1)
pageBannerBorder:SetTexture("Interface/ACHIEVEMENTFRAME/UI-Achievement-MetalBorder-Top")
pageBannerBorder:SetSize(452, 14)
pageBannerBorder:SetPoint("TOPLEFT", 570, -75)
pageBanner.text = page[pages[1][1]]:CreateFontString(nil, "ARTWORK")
pageBanner.text:SetFont("Fonts/MORPHEUS.ttf", 18, "OUTLINE")
pageBanner.text:SetText(instance[1][2]) --default
pageBanner.text:SetTextColor(1.00, 1.00, 0.60)
pageBanner.text:SetPoint("TOPLEFT", pageBanner, "TOPLEFT", 20, -8)
pageBossIcon = page[pages[1][1]]:CreateTexture(nil, "ARTWORK")
pageBossIcon:SetTexture(instance[1][4]) --default
pageBossIcon:SetSize(134, 70)
pageBossIcon:SetPoint("TOPLEFT", 590, -52)

local DNAFrameMainNotif = CreateFrame("Frame", nil, DNAFrameMain)
DNAFrameMainNotif:SetSize(500, 40)
DNAFrameMainNotif:SetPoint("CENTER", 0, 300)
DNAFrameMainNotif:SetFrameStrata("DIALOG")
DNAFrameMainNotifText = DNAFrameMainNotif:CreateFontString(nil, "OVERLAY")
DNAFrameMainNotifText:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameMainNotifText:SetPoint("CENTER", 0, 0)
DNAFrameMainNotifText:SetText("")
DNAFrameMainNotif:SetBackdrop({
  bgFile = "Interface/ToolTips/UI-Tooltip-Background",
  edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNAFrameMainNotif:SetBackdropBorderColor(1, 0, 0)
DNAFrameMainNotif:SetBackdropColor(1, 0.2, 0.2, 1)
DNAFrameMainNotif:Hide()

page[pages[2][1]] = CreateFrame("Frame", nil, DNAFrameMain)
page[pages[2][1]]:SetWidth(DNAGlobal.width)
page[pages[2][1]]:SetHeight(DNAGlobal.height)
page[pages[2][1]]:SetPoint("TOPLEFT", 0, 0)

page[pages[3][1]] = CreateFrame("Frame", nil, DNAFrameMain)
page[pages[3][1]]:SetWidth(DNAGlobal.width)
page[pages[3][1]]:SetHeight(DNAGlobal.height)
page[pages[3][1]]:SetPoint("TOPLEFT", 0, 0)

page[pages[4][1]] = CreateFrame("Frame", nil, DNAFrameMain)
page[pages[4][1]]:SetWidth(DNAGlobal.width)
page[pages[4][1]]:SetHeight(DNAGlobal.height)
page[pages[4][1]]:SetPoint("TOPLEFT", 0, 0)

page[pages[5][1]] = CreateFrame("Frame", nil, DNAFrameMain)
page[pages[5][1]]:SetWidth(DNAGlobal.width)
page[pages[5][1]]:SetHeight(DNAGlobal.height)
page[pages[5][1]]:SetPoint("TOPLEFT", 0, 0)

local checkbox = {}
function checkBox(checkID, checkName, parentFrame, posX, posY)
  local check_static = CreateFrame("CheckButton", nil, parentFrame, "ChatConfigCheckButtonTemplate")
  check_static:SetPoint("TOPLEFT", posX, -posY-40)
  check_static.text = check_static:CreateFontString(nil,"ARTWORK")
  check_static.text:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
  check_static.text:SetPoint("TOPLEFT", check_static, "TOPLEFT", 25, -5)
  check_static.text:SetText(checkName)
  --check_static.tooltip = checkName
  check_static:SetScript("OnClick", function()
     if (DEBUG) then
       DNA[player.combine]["DEBUG"] = "off"
       DEBUG = false
     else
       DNA[player.combine]["DEBUG"] = "on"
       DEBUG = true
     end
  end)
  checkbox[checkID] = check_static
end

checkBox("AUTOPROMOTE", "Auto Promote Guild Officers On Raid Invite", page[pages[5][1]], 10, 0)
checkBox("DEBUG", "Debug Mode (Very Spammy)", page[pages[5][1]], 10, 20)

pageDKPEdit = CreateFrame("EditBox", nil, page[pages[3][1]])
pageDKPEdit:SetWidth(200)
pageDKPEdit:SetHeight(200)
pageDKPEdit:SetFontObject(GameFontNormal)
pageDKPEdit:SetBackdrop(GameTooltip:GetBackdrop())
pageDKPEdit:SetBackdropColor(0, 0, 0, 0.8)
pageDKPEdit:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", 100, -100)
pageDKPEdit:ClearFocus(self)
pageDKPEdit:SetAutoFocus(false)
--pageDKPEdit:Insert("")
pageDKPEdit:SetMultiLine(true)
pageDKPEdit:SetBackdrop(GameTooltip:GetBackdrop())
pageDKPEdit:SetBackdropColor(0, 0, 0, 0.8)
pageDKPEdit:SetCursorPosition(0)
pageDKPEdit:SetJustifyH("LEFT")
pageDKPEdit:SetJustifyV("CENTER")
pageDKPEdit:SetTextColor(1, 1, 1)
pageDKPEdit:Hide()

local btnPostDKP = CreateFrame("Button", nil, page[pages[3][1]], "UIPanelButtonTemplate")
btnPostDKP:SetSize(120, 28)
btnPostDKP:SetPoint("TOPLEFT", 30, -100)
btnPostDKP.text = btnPostDKP:CreateFontString(nil, "ARTWORK")
btnPostDKP.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
btnPostDKP.text:SetText("Update Raid DKP")
btnPostDKP.text:SetPoint("CENTER", btnPostDKP)
btnPostDKP:SetScript("OnClick", function()
  if (UnitIsGroupLeader(player.name)) then
    if (pageDKPEdit:GetText()) then
      DNASendPacket("send", "@" .. pageDKPEdit:GetText(), true)
    end
  end
end)
btnPostDKP:Hide()

local DNAFrameRaidDetailsBG = CreateFrame("Frame", nil, page[pages[2][1]], "InsetFrameTemplate")
DNAFrameRaidDetailsBG:SetSize(194, DNAGlobal.height-5)
DNAFrameRaidDetailsBG:SetPoint("TOPLEFT", 6, 0)
DNAFrameRaidDetailsBG:SetFrameLevel(2)

for i = 1, 50 do
  pageRaidDetailsColOne[i] = page[pages[2][1]]:CreateFontString(nil, "ARTWORK")
  pageRaidDetailsColOne[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  pageRaidDetailsColOne[i]:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", 20, (-i*14)-24)
  pageRaidDetailsColOne[i]:SetText("")
  pageRaidDetailsColOne[i]:SetTextColor(1, 1, 1)

  pageRaidDetailsColTwo[i] = page[pages[2][1]]:CreateFontString(nil, "ARTWORK")
  pageRaidDetailsColTwo[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  pageRaidDetailsColTwo[i]:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", 110, (-i*14)-24)
  pageRaidDetailsColTwo[i]:SetText("")
  pageRaidDetailsColTwo[i]:SetTextColor(0.9, 0.9, 0.9)
end

local DKPViewFrame_w = 400
local DKPViewFrame_h = 400
local DKPViewFrame_x = 580
local DKPViewFrame_y = 100
local pageDKPView = CreateFrame("Frame", nil, page[pages[3][1]], "InsetFrameTemplate")
pageDKPView:SetWidth(DKPViewFrame_w-20)
pageDKPView:SetHeight(DKPViewFrame_h-40)
pageDKPView:SetPoint("TOPLEFT", DKPViewFrame_x+5, -DKPViewFrame_y-20)
pageDKPView:SetMovable(true)
pageDKPView.ScrollFrame = CreateFrame("ScrollFrame", nil, pageDKPView, "UIPanelScrollFrameTemplate")
pageDKPView.ScrollFrame:SetPoint("TOPLEFT", pageDKPView, "TOPLEFT", 5, -20)
pageDKPView.ScrollFrame:SetPoint("BOTTOMRIGHT", pageDKPView, "BOTTOMRIGHT", 10, 20)
local pageDKPViewScrollChildFrame = CreateFrame("Frame", nil, pageDKPView.ScrollFrame)
pageDKPViewScrollChildFrame:SetSize(DKPViewFrame_w, DKPViewFrame_h)
pageDKPViewScrollChildFrame.bg = pageDKPViewScrollChildFrame:CreateTexture(nil, "BACKGROUND")
pageDKPViewScrollChildFrame.bg:SetAllPoints(true)
--pageDKPViewScrollChildFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.4)
pageDKPView.ScrollFrame:SetScrollChild(pageDKPViewScrollChildFrame)
pageDKPView.ScrollFrame.ScrollBar:ClearAllPoints()
pageDKPView.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", pageDKPView.ScrollFrame, "TOPRIGHT", -150, 0)
pageDKPView.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", pageDKPView.ScrollFrame, "BOTTOMRIGHT", 106, 0)

for i = 1, 256 do
  pageDKPViewScrollChild_colOne[i] = pageDKPViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  pageDKPViewScrollChild_colOne[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  pageDKPViewScrollChild_colOne[i]:SetText("")
  pageDKPViewScrollChild_colOne[i]:SetPoint("TOPLEFT", 30, (-i*18)+10)

  pageDKPViewScrollChild_colTwo[i] = pageDKPViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  pageDKPViewScrollChild_colTwo[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  pageDKPViewScrollChild_colTwo[i]:SetText("")
  pageDKPViewScrollChild_colTwo[i]:SetPoint("TOPLEFT", 140, (-i*18)+10)

  pageDKPViewScrollChild_colThree[i] = pageDKPViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  pageDKPViewScrollChild_colThree[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  pageDKPViewScrollChild_colThree[i]:SetText("")
  pageDKPViewScrollChild_colThree[i]:SetPoint("TOPLEFT", 200, (-i*18)+10)
end

local function topNotification(msg, show)
  if (show) then
    DNAFrameMainNotifText:SetText(msg)
    DNAFrameMainNotif:Show()
  else
    DNAFrameMainNotif:Hide()
  end
end

--[==[
local SecureCmdList = {}
SecureCmdList["MAINTANKON"] = function(msg)
	local action, target = SecureCmdOptionParse(msg);
	if ( action ) then
		if ( not target ) then
			target = action;
		end
		if ( target == "" ) then
			target = "target";
		end
		SetPartyAssignment("MAINTANK", target);
	end
end

local secureScript = {}
secureScript["test"] = CreateFrame('Button', nil, DNAFrameMain, 'InsecureActionButtonTemplate')
secureScript["test"]:SetAttribute('type', 'macro')
secureScript["test"]:SetAttribute('macrotext', '/mt krizzu')

local sbtn =  CreateFrame("CheckButton", "thisActionButton", DNAFrameMain, "ActionBarButtonTemplate");
sbtn:SetAttribute("type", "macro");
sbtn:SetAttribute("width", "30");
sbtn:SetAttribute("height", "30");
sbtn:SetAttribute("macrotext", "/maintank target");
sbtn:ClearAllPoints();
sbtn:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", -100, -100); -- (point, frame, relativePoint , x, y);
]==]--

--send the network data, then save after
local function updateSlotPos(role, i, name)
  if (IsInRaid()) then
    if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
      --[==[
      if (name ~= "Empty") then
        --TargetUnit(name)
        ClearPartyAssignment("MAINTANK", name)
        --SetPartyAssignment("MAINTANK", name) --security issue has been disabled in LUA
      end
      ]==]--
      DNASendPacket("send", role .. i .. "," .. name, true)
      DNASendPacket("send", "#" .. DNAGlobal.version, true)
    else
      topNotification("You do not have raid permission to modify assignments.   [E1]", true)
    end
  else
    return topNotification("You are not in a raid!   [E1]", true)
  end
end

DNAFrameMain:Hide()
page[pages[3][1]]:Hide()
page[pages[2][1]]:Hide()

local DNAFrameInstanceBG = CreateFrame("Frame", nil, page[pages[1][1]], "InsetFrameTemplate")
DNAFrameInstanceBG:SetSize(194, DNAGlobal.height-5)
DNAFrameInstanceBG:SetPoint("TOPLEFT", 6, 0)
DNAFrameInstanceBG:SetFrameLevel(2)

local function instanceButton(name, pos_y, longtext, icon)
  DNAFrameInstance[name] = CreateFrame("Frame", nil, page[pages[1][1]])
  DNAFrameInstance[name]:SetSize(140, 80)
  DNAFrameInstance[name]:SetPoint("TOPLEFT", 30, -pos_y+64)
  DNAFrameInstance[name]:SetBackdrop({
    bgFile = icon,
    edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize = 18,
    insets = {left=0, right=-45, top=0, bottom=-44},
  })
  --DNAFrameInstance[name]:SetScript('OnEnter', function()
    DNAFrameInstance[name]:SetBackdropBorderColor(1, 1, 0, 1)
  --end)
  DNAFrameInstanceText[name] = DNAFrameInstance[name]:CreateFontString(nil, "OVERLAY")
  DNAFrameInstanceText[name]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameInstanceText[name]:SetPoint("CENTER", 0, -25)
  DNAFrameInstanceText[name]:SetText(longtext)

  --DNAFrameInstanceScript[name] = CreateFrame("Button", nil, DNAFrameInstance[name], "UIPanelButtonTemplate")
  DNAFrameInstanceScript[name] = CreateFrame("Button", nil, DNAFrameInstance[name])
  DNAFrameInstanceScript[name]:SetSize(140, 80)
  DNAFrameInstanceScript[name]:SetPoint("CENTER", 0, 2)
  DNAFrameInstanceScript[name]:SetScript("OnClick", function()
    topNotification("", false)
    for i, v in ipairs(instance) do
      ddBossList[instance[i][1]]:Hide() --hide all dropdowns
    end
    local instanceNum = multiKeyFromValue(instance, name)
    lastSelection = name
    clearFrameView()
    InstanceButtonToggle(name, icon)
    DNA[player.combine]["Last Selection"] = lastSelection
    ddBossList[name]:Show()
    ddBossListText[name]:SetText("Select a boss")
  end)
  DNAFrameInstanceGlow[name] = DNAFrameInstance[name]:CreateTexture(nil, "BACKGROUND", DNAFrameInstance[name], -5)
  DNAFrameInstanceGlow[name]:SetTexture("Interface/ExtraButton/ChampionLight")
  DNAFrameInstanceGlow[name]:SetSize(190, 125)
  DNAFrameInstanceGlow[name]:SetPoint("TOPLEFT", -24, 20)
  DNAFrameInstanceGlow[name]:Hide()
end

for i, v in ipairs(instance) do
  instanceButton(instance[i][1], i*100, instance[i][2], instance[i][5]) --draw all tabs
end

InstanceButtonToggle(instance[1][1], instance[1][5])

local function bottomTabToggle(name)
  for i,v in pairs(pages) do
    botTab[v[1]]:SetFrameStrata("LOW")
    botTab[v[1]].text:SetTextColor(0.7, 0.7, 0.7)
    page[v[1]]:Hide()
  end
  botTab[name]:SetFrameStrata("MEDIUM")
  botTab[name].text:SetTextColor(1.0, 1.0, 0.5)
  page[name]:Show()
end

local function bottomTab(name, pos_x, text_pos_x)
  botTab[name] = CreateFrame("Frame", nil, DNAFrameMain)
  botTab[name]:SetPoint("BOTTOMLEFT", pos_x, -39)
  botTab[name]:SetWidth(85)
  botTab[name]:SetHeight(60)
  botTab[name]:SetFrameStrata("LOW")
  botTab[name].text = botTab[name]:CreateFontString(nil, "ARTWORK")
  botTab[name].text:SetFont(DNAGlobal.font, 11, "OUTLINE")
  botTab[name].text:SetText(name)
  botTab[name].text:SetTextColor(0.8, 0.8, 0.8)
  --botTab[name].text:SetPoint("TOPLEFT", botTab[name], "TOPLEFT", text_pos_x, -26)
  botTab[name].text:SetPoint("CENTER", botTab[name], "CENTER", 9, 0)
  botBorder[name] = botTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  botBorder[name]:SetTexture("Interface/PaperDollInfoFrame/UI-CHARACTER-ACTIVETAB")
  botBorder[name]:SetSize(100, 35)
  botBorder[name]:SetPoint("TOPLEFT", 0, -14)
  botTabScript = {}
  botTabScript[name] = CreateFrame("Button", nil, botTab[name], "UIPanelButtonTemplate")
  botTabScript[name] = CreateFrame("Button", nil, botTab[name])
  botTabScript[name]:SetSize(85, 30)
  botTabScript[name]:SetPoint("CENTER", 0, 0)
  botTabScript[name]:SetScript("OnClick", function()
    topNotification("", false)
    bottomTabToggle(name)
  end)
end

function tabInactive(name)
  tabBorder[name]:SetTexture("Interface/AddOns/DNAssistant/images/sidetab")
  sideTab[name]:SetFrameLevel(0)
  sideTab[name].text:SetTextColor(0.7, 0.7, 0.7)
end
function tabActive(name)
  tabBorder[name]:SetTexture("Interface/AddOns/DNAssistant/images/sidetab_sel")
  sideTab[name]:SetFrameLevel(5)
  sideTab[name].text:SetTextColor(1, 1, 0.5)
end

-- BO PAGE ASSIGN
local DNARaidScrollFrame_w = 140
local DNARaidScrollFrame_h = 406

local DNARaidScrollFrame = CreateFrame("Frame", DNARaidScrollFrame, page[pages[1][1]], "InsetFrameTemplate")
DNARaidScrollFrame:SetWidth(DNARaidScrollFrame_w+20) --add scroll frame width
DNARaidScrollFrame:SetHeight(DNARaidScrollFrame_h-7)
DNARaidScrollFrame:SetPoint("TOPLEFT", 220, -80)
DNARaidScrollFrame:SetFrameLevel(5)
DNARaidScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNARaidScrollFrame, "UIPanelScrollFrameTemplate")
DNARaidScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNARaidScrollFrame, "TOPLEFT", 3, -10)
DNARaidScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNARaidScrollFrame, "BOTTOMRIGHT", 10, 20)
local DNARaidScrollFrameScrollChildFrame = CreateFrame("Frame", DNARaidScrollFrameScrollChildFrame, DNARaidScrollFrame.ScrollFrame)
DNARaidScrollFrameScrollChildFrame:SetSize(DNARaidScrollFrame_w, DNARaidScrollFrame_h)
DNARaidScrollFrame.text = DNARaidScrollFrame:CreateFontString(nil, "ARTWORK")
DNARaidScrollFrame.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
DNARaidScrollFrame.text:SetPoint("CENTER", DNARaidScrollFrame, "TOPLEFT", 60, 10)
DNARaidScrollFrame.text:SetText("Raid")
DNARaidScrollFrame.ScrollFrame:SetScrollChild(DNARaidScrollFrameScrollChildFrame)
DNARaidScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNARaidScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNARaidScrollFrame.ScrollFrame, "TOPRIGHT", 0, -10)
DNARaidScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNARaidScrollFrame.ScrollFrame, "BOTTOMRIGHT", -40, -1)

local raidSlotOrgPoint_x = {}
local raidSlotOrgPoint_y = {}
local memberDrag = nil
local thisClass = nil
function raidSlotFrame(parentFrame, i, y)
  raidSlot[i] = CreateFrame("button", raidSlot[i], parentFrame)
  raidSlot[i]:SetFrameLevel(10)
  raidSlot[i]:SetMovable(true)
  raidSlot[i]:EnableMouse(true)
  raidSlot[i]:RegisterForDrag("LeftButton")
  raidSlotOrgPoint_x[i] = 0
  raidSlotOrgPoint_y[i] = -y+17 --top padding
  raidSlot[i]:SetScript("OnDragStart", function()
    raidSlot[i]:StartMoving()
    raidSlot[i]:SetParent(page[pages[1][1]])
    raidSlot[i]:SetFrameStrata("DIALOG")
    memberDrag = raidSlot[i].text:GetText()
  end)
  raidSlot[i]:SetScript("OnDragStop", function()
    raidSlot[i]:StopMovingOrSizing()
    raidSlot[i]:SetParent(parentFrame)
    raidSlot[i]:SetPoint("TOPLEFT", raidSlotOrgPoint_x[i], raidSlotOrgPoint_y[i])
  end)
  raidSlot[i]:SetBackdrop({
    bgFile = "Interface/Collections/CollectionsBackgroundTile",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  raidSlot[i]:SetBackdropColor(1, 1, 1, 0.6)
  raidSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  raidSlot[i]:SetWidth(DNARaidScrollFrame_w-5)
  raidSlot[i]:SetHeight(raidSlot_h)
  raidSlot[i]:SetPoint("TOPLEFT", raidSlotOrgPoint_x[i], raidSlotOrgPoint_y[i])
  raidSlot[i].icon = raidSlot[i]:CreateTexture(nil, "OVERLAY")
  raidSlot[i].icon:SetTexture("")
  raidSlot[i].icon:SetPoint("TOPLEFT", 4, -4)
  raidSlot[i].icon:SetSize(12, 12)
  raidSlot[i].text = raidSlot[i]:CreateFontString(nil, "ARTWORK")
  raidSlot[i].text:SetFont(DNAGlobal.font, 12, "OUTLINE")
  raidSlot[i].text:SetPoint("CENTER", raidSlot[i], "CENTER", 0, 0)
  raidSlot[i].text:SetText("Empty")
  raidSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  raidSlot[i].ready = raidSlot[i]:CreateTexture(nil, "OVERLAY")
  raidSlot[i].ready:SetTexture("")
  raidSlot[i].ready:SetPoint("TOPLEFT", DNARaidScrollFrame_w-21, -4)
  raidSlot[i].ready:SetSize(12, 12)
  raidSlot[i]:SetScript('OnEnter', function()
    raidSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
  end)
  raidSlot[i]:SetScript('OnLeave', function()
    raidSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  end)
end

local tankSlotOrgPoint_x = {}
local tankSlotOrgPoint_y = {}
local tankSlotframe = CreateFrame("Frame", tankSlotframe, page[pages[1][1]], "InsetFrameTemplate")
tankSlotframe:SetWidth(DNARaidScrollFrame_w+6)
tankSlotframe:SetHeight((tankSlots*20)+4)
tankSlotframe:SetPoint("TOPLEFT", 400, -80)
tankSlotframe.text = tankSlotframe:CreateFontString(nil, "ARTWORK")
tankSlotframe.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
tankSlotframe.text:SetPoint("CENTER", tankSlotframe, "TOPLEFT", 71, 10)
tankSlotframe.text:SetText("Tanks")
tankSlotframe:SetFrameLevel(2)
for i = 1, tankSlots do
  tankSlot[i] = CreateFrame("Button", tankSlot[i], tankSlotframe)
  tankSlot[i]:SetWidth(DNARaidScrollFrame_w)
  tankSlot[i]:SetHeight(raidSlot_h)
  tankSlotOrgPoint_x[i] = 3
  tankSlotOrgPoint_y[i] = (-i*19)+14 --top padding
  tankSlot[i]:SetPoint("TOPLEFT", tankSlotOrgPoint_x[i], tankSlotOrgPoint_y[i])
  tankSlot[i].icon = tankSlot[i]:CreateTexture(nil, "OVERLAY")
  tankSlot[i].icon:SetTexture("")
  tankSlot[i].icon:SetPoint("TOPLEFT", 4, -4)
  tankSlot[i].icon:SetSize(12, 12)
  tankSlot[i].text = tankSlot[i]:CreateFontString(tankSlot[i], "ARTWORK")
  tankSlot[i].text:SetFont(DNAGlobal.font, 12, "OUTLINE")
  tankSlot[i].text:SetPoint("CENTER", tankSlot[i], "TOPLEFT", 70, -10)
  tankSlot[i].text:SetText("Empty")
  tankSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  tankSlot[i]:SetBackdrop({
    bgFile   = "Interface/Collections/CollectionsBackgroundTile",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 12,
  	insets = {left=2, right=2, top=2, bottom=2},
  })
  tankSlot[i].ready = tankSlot[i]:CreateTexture(nil, "OVERLAY")
  tankSlot[i].ready:SetTexture("")
  tankSlot[i].ready:SetPoint("TOPLEFT", DNARaidScrollFrame_w-21, -4)
  tankSlot[i].ready:SetSize(12, 12)

  --tankSlot[i]:SetBackdropColor(1, 1, 1, 0.6)
  tankSlot[i]:SetBackdropColor(0.2, 0.2, 0.2, 1)
  tankSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  tankSlot[i]:SetFrameLevel(2)
  tankSlot[i]:EnableMouse()
  tankSlot[i]:SetMovable(true)
  tankSlot[i]:RegisterForDrag("LeftButton")
  tankSlot[i]:SetScript("OnDragStart", function()
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tankSlot[i]:StartMoving()
      tankSlot[i]:SetFrameStrata("DIALOG")

      memberDrag = tankSlot[i].text:GetText()
      print("start moving tank: " .. memberDrag)

    end
  end)
  tankSlot[i]:SetScript("OnDragStop", function()
    tankSlot[i]:StopMovingOrSizing()
    tankSlot[i]:SetPoint("TOPLEFT", tankSlotOrgPoint_x[i], tankSlotOrgPoint_y[i])
    updateSlotPos("tank", i, "Empty")
  end)
  tankSlot[i]:SetScript('OnEnter', function()
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tankSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
    end
    if (memberDrag) then
      for dupe = 1, tankSlots do
        if (tankSlot[dupe].text:GetText() == memberDrag) then
          updateSlotPos("tank", dupe, "Empty")
          updateSlotPos("tank", i, memberDrag)
          print("DEBUG: duplicate slot")
          return true --print("DEBUG: duplicate slot")
        end
      end
      updateSlotPos("tank", i, memberDrag)
    end
  end)
  tankSlot[i]:SetScript('OnLeave', function()
    memberDrag = nil
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tankSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
    end
  end)
end

local healSlotOrgPoint_x = {}
local healSlotOrgPoint_y = {}
local healSlotframe = CreateFrame("Frame", healSlotframe, page[pages[1][1]], "InsetFrameTemplate")
healSlotframe:SetWidth(DNARaidScrollFrame_w+6)
healSlotframe:SetHeight((healSlots*20)-2)
healSlotframe:SetPoint("TOPLEFT", 400, -240)
healSlotframe.text = healSlotframe:CreateFontString(nil, "ARTWORK")
healSlotframe.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
healSlotframe.text:SetPoint("CENTER", healSlotframe, "TOPLEFT", 71, 10)
healSlotframe.text:SetText("Healers")
healSlotframe:SetFrameLevel(2)
for i = 1, healSlots do
  healSlot[i] = CreateFrame("Button", healSlot[i], healSlotframe)
  healSlot[i]:SetWidth(DNARaidScrollFrame_w)
  healSlot[i]:SetHeight(raidSlot_h)
  healSlotOrgPoint_x[i] = 3
  healSlotOrgPoint_y[i] = (-i*19)+14
  healSlot[i]:SetPoint("TOPLEFT", healSlotOrgPoint_x[i], healSlotOrgPoint_y[i])
  healSlot[i].icon = healSlot[i]:CreateTexture(nil, "OVERLAY")
  healSlot[i].icon:SetTexture("")
  healSlot[i].icon:SetPoint("TOPLEFT", 4, -4)
  healSlot[i].icon:SetSize(12, 12)
  healSlot[i].text = healSlot[i]:CreateFontString(healSlot[i], "ARTWORK")
  healSlot[i].text:SetFont(DNAGlobal.font, 12, "OUTLINE")
  healSlot[i].text:SetPoint("CENTER", healSlot[i], "TOPLEFT", 70, -10)
  healSlot[i].text:SetText("Empty")
  healSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  healSlot[i]:SetBackdrop({
    bgFile = "Interface/Collections/CollectionsBackgroundTile",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  healSlot[i].ready = healSlot[i]:CreateTexture(nil, "OVERLAY")
  healSlot[i].ready:SetTexture("")
  healSlot[i].ready:SetPoint("TOPLEFT", DNARaidScrollFrame_w-21, -4)
  healSlot[i].ready:SetSize(12, 12)
  --healSlot[i]:SetBackdropColor(1, 1, 1, 0.6)
  healSlot[i]:SetBackdropColor(0.2, 0.2, 0.2, 1)
  healSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  healSlot[i]:SetFrameLevel(2)
  healSlot[i]:EnableMouse()
  healSlot[i]:SetMovable(true)
  healSlot[i]:RegisterForDrag("LeftButton")
  healSlot[i]:SetScript("OnDragStart", function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:StartMoving()
    end
  end)
  healSlot[i]:SetScript("OnDragStop", function()
    healSlot[i]:StopMovingOrSizing()
    healSlot[i]:SetPoint("TOPLEFT", healSlotOrgPoint_x[i], healSlotOrgPoint_y[i])
    updateSlotPos("heal", i, "Empty")
  end)
  healSlot[i]:SetScript('OnEnter', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
    end
    --if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
      if (memberDrag) then
        for dupe = 1, healSlots do
          if (healSlot[dupe].text:GetText() == memberDrag) then
            updateSlotPos("heal", dupe, "Empty")
            updateSlotPos("heal", i, memberDrag)
            return true --print("DEBUG: duplicate slot")
          end
        end
        updateSlotPos("heal", i, memberDrag)
      end
    --end
  end)
  healSlot[i]:SetScript('OnLeave', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
    end
    memberDrag = nil
  end)
end

--build all 40 first
for i = 1, MAX_RAID_MEMBERS do
  raidSlotFrame(DNARaidScrollFrameScrollChildFrame, i, i*19)
  raidSlot[i]:Hide()
end

local viewFrame_w = 400
local viewFrame_h = 400
local viewFrame_x = 580
local viewFrame_y = 100
local DNAFrameView = CreateFrame("Frame", nil, page[pages[1][1]], "InsetFrameTemplate")
DNAFrameView:SetWidth(viewFrame_w-20)
DNAFrameView:SetHeight(viewFrame_h-40)
DNAFrameView:SetPoint("TOPLEFT", viewFrame_x+5, -viewFrame_y-20)
DNAFrameView:SetMovable(true)
DNAFrameView.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAFrameView, "UIPanelScrollFrameTemplate")
DNAFrameView.ScrollFrame:SetPoint("TOPLEFT", DNAFrameView, "TOPLEFT", 5, -20)
DNAFrameView.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAFrameView, "BOTTOMRIGHT", 10, 20)
local DNAViewScrollChildFrame = CreateFrame("Frame", nil, DNAFrameView.ScrollFrame)
DNAViewScrollChildFrame:SetSize(viewFrame_w, viewFrame_h)
DNAViewScrollChildFrame.bg = DNAViewScrollChildFrame:CreateTexture(nil, "BACKGROUND")
DNAViewScrollChildFrame.bg:SetAllPoints(true)
--DNAViewScrollChildFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.4)
DNAFrameView.ScrollFrame:SetScrollChild(DNAViewScrollChildFrame)
DNAFrameView.ScrollFrame.ScrollBar:ClearAllPoints()
DNAFrameView.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAFrameView.ScrollFrame, "TOPRIGHT", -150, 0)
DNAFrameView.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAFrameView.ScrollFrame, "BOTTOMRIGHT", 106, 0)

for i = 1, viewFrameLines do
  DNAFrameViewScrollChild_mark[i] = DNAViewScrollChildFrame:CreateTexture(nil, "ARTWORK")
  DNAFrameViewScrollChild_mark[i]:SetSize(16, 16)
  DNAFrameViewScrollChild_mark[i]:SetPoint("TOPLEFT", 5, (-i*18)+13)
  DNAFrameViewScrollChild_mark[i]:SetTexture("")

  DNAFrameViewScrollChild_tank[i] = DNAViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAFrameViewScrollChild_tank[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameViewScrollChild_tank[i]:SetText("")
  DNAFrameViewScrollChild_tank[i]:SetPoint("TOPLEFT", 30, (-i*18)+10)

  DNAFrameViewScrollChild_heal[i] = DNAViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAFrameViewScrollChild_heal[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameViewScrollChild_heal[i]:SetText("")
  DNAFrameViewScrollChild_heal[i]:SetPoint("TOPLEFT", 130, (-i*18)+10)
end

for i, v in ipairs(instance) do
  ddBossList[instance[i][1]] = CreateFrame("frame", nil, page[pages[1][1]], "UIDropDownMenuTemplate")
  ddBossList[instance[i][1]]:SetPoint("TOPLEFT", 680, -90)
  ddBossListText[instance[i][1]] = ddBossList[instance[i][1]]:CreateFontString(nil, "ARTWORK")
  ddBossListText[instance[i][1]]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  ddBossListText[instance[i][1]]:SetPoint("TOPLEFT", ddBossList[instance[i][1]], "TOPLEFT", 25, -8);
  local instanceNum = multiKeyFromValue(instance, instance[i][1])
  ddBossListText[instance[i][1]]:SetText(raidBoss[instanceNum][1])
  --print("DEBUG: " .. raidBoss[instanceNum][1])
  ddBossList[instance[i][1]].onClick = function(self, checked)
    ddBossListText[instance[i][1]]:SetText(self.value)
    clearFrameView()
    raidSelection = self.value
    if (DEBUG) then
      print("DEBUG: ddBossList " .. self.value)
    end
    buildRaidAssignments(self.value, nil, "dropdown")
  end
  ddBossList[instance[i][1]]:Hide()
  ddBossList[instance[i][1]].initialize = function(self, level)
  	local info = UIDropDownMenu_CreateInfo()
    for ddKey, ddVal in pairs(raidBoss[instanceNum]) do
      if (ddKey ~= 1) then --remove first key
        info.text = ddVal
      	info.value= ddVal
      	info.func = self.onClick
      	UIDropDownMenu_AddButton(info, level)
      end
    end
  end
  UIDropDownMenu_SetWidth(ddBossList[instance[i][1]], 160)
end

ddBossListText[raidBoss[1][1]]:SetText("Select a boss")

function updateRaid(raid)
  print("{rt8} test")
end

local largePacket = nil
local function raidPush()
  largePacket = "{"
  for i = 1, tankSlots do
    if (tankSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. "tank" .. i .. "," .. tankSlot[i].text:GetText() .. "}"
    end
  end
  DNASendPacket("send", largePacket, true)

  largePacket = "{" --beginning key
  for i = 1, healSlots do
    if (healSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. "heal" .. i .. "," .. healSlot[i].text:GetText() .. "}"
    end
  end
  DNASendPacket("send", largePacket, true)
end

local btnShare_w = 160
local btnShare_h = 28
local btnShare_x = 300
local btnShare_y = DNAGlobal.height-45
local btnShare_t = "Push Assignments"
local btnShare = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonTemplate")
btnShare:SetSize(btnShare_w, btnShare_h)
btnShare:SetPoint("TOPLEFT", btnShare_x, -btnShare_y)
btnShare.text = btnShare:CreateFontString(nil, "ARTWORK")
btnShare.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
btnShare.text:SetText(btnShare_t)
btnShare.text:SetPoint("CENTER", btnShare)
btnShare:SetScript("OnClick", function()
  updateRaidRoster()
  raidPush()
end)
btnShare:Hide()
local btnShareDis = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonGrayTemplate")
btnShareDis:SetSize(btnShare_w, btnShare_h)
btnShareDis:SetPoint("TOPLEFT", btnShare_x, -btnShare_y)
btnShareDis.text = btnShareDis:CreateFontString(nil, "ARTWORK")
btnShareDis.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
btnShareDis.text:SetText(btnShare_t)
btnShareDis.text:SetPoint("CENTER", btnShare)
btnShareDis:SetScript("OnClick", function()
  if (IsInRaid()) then
    topNotification("You do not have raid permission to modify assignments.   [E3]", true)
  else
    topNotification("You are not in a raid!   [E3]", true)
  end
end)

local btnPostRaid_w = 120
local btnPostRaid_h = 28
local btnPostRaid_x = DNAGlobal.width-260
local btnPostRaid_y = DNAGlobal.height-45
local btnPostRaid_t = "Post to Raid"
local btnPostRaid = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonTemplate")
btnPostRaid:SetSize(btnPostRaid_w, btnPostRaid_h)
btnPostRaid:SetPoint("TOPLEFT", btnPostRaid_x, -btnPostRaid_y)
btnPostRaid.text = btnPostRaid:CreateFontString(nil, "ARTWORK")
btnPostRaid.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
btnPostRaid.text:SetText(btnPostRaid_t)
btnPostRaid.text:SetPoint("CENTER", btnPostRaid)
btnPostRaid:SetScript("OnClick", function()
  raidPush()
  if (raidSelection == nil) then
    DNAFrameViewScrollChild_tank[3]:SetText("Please select a boss or trash pack!")
  else
    DNASendPacket("send", "&" .. raidSelection .. "," .. player.name, true) --openassignments
    --DoReadyCheck()
  end
end)
local btnPostRaidDis = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonGrayTemplate")
btnPostRaidDis:SetSize(btnPostRaid_w, btnPostRaid_h)
btnPostRaidDis:SetPoint("TOPLEFT", btnPostRaid_x, -btnPostRaid_y)
btnPostRaidDis.text = btnPostRaidDis:CreateFontString(nil, "ARTWORK")
btnPostRaidDis.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
btnPostRaidDis.text:SetText(btnPostRaid_t)
btnPostRaidDis.text:SetPoint("CENTER", btnPostRaid)
btnPostRaidDis:SetScript("OnClick", function()
  if (IsInRaid()) then
    topNotification("You do not have raid permission to modify assignments.   [E2]", true)
  else
    topNotification("You are not in a raid!   [E2]", true)
  end
end)
-- EO PAGE ASSIGN

for i,v in pairs(pages) do
  bottomTab(pages[i][1], pages[i][2])
end

--default selection after drawn
bottomTabToggle(pages[1][1])
ddBossList[instance[1][1]]:Show() -- show first one

--[==[
local SecureCmdList = {}
SecureCmdList["MAINTANKON"] = function(msg)
	local action, target = SecureCmdOptionParse(msg)
	if ( action ) then
		if ( not target ) then
			target = action
		end
		if ( target == "" ) then
			target = "target"
		end
		SetPartyAssignment("MAINTANK", target)
	end
end

SecureCmdList["MAINTANKOFF"] = function(msg)
	local action, target = SecureCmdOptionParse(msg)
	if ( action ) then
		if ( not target ) then
			target = action
		end
		if ( target == "" ) then
			target = "target"
		end
		ClearPartyAssignment("MAINTANK", target)
	end
end

--local secBtn = CreateFrame("Button", nil, page[pages[1][1]], 'SecureActionButtonTemplate')
--local secBtn = CreateFrame("Button", "secrun", page[pages[1][1]], 'InsecureActionButtonTemplate')
local secBtn = CreateFrame("Button", "secrun", page[pages[1][1]], 'InsecureActionButtonTemplate')
secBtn:SetSize(80, 20)
secBtn:SetPoint("TOPLEFT", 0, 0)
secBtn.text = secBtn:CreateFontString(nil, "ARTWORK")
secBtn.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
secBtn.text:SetPoint("CENTER", secBtn, "CENTER", 10, -30)
secBtn.text:SetText("| tank test |")
secBtn:SetAttribute("type", "macro")
secBtn:SetAttribute("macrotext", "/mt Krizzu")
secBtn:SetScript("OnClick", function()
  print("test")
end)
]==]--

local function raidPermissions()
  topNotification("", false)
  if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
    btnShareDis:Hide()
    btnShare:Show()
    btnPostRaid:Show()
    btnPostRaidDis:Hide()
  else
    btnShareDis:Show()
    btnShare:Hide()
    btnPostRaid:Hide()
    btnPostRaidDis:Show()
  end
end

local function DNACloseWindow()
  DNAFrameMain:Hide()
end

local function DNAOpenWindow()
  DNAFrameMain:Show()
  --DNAFrameAssign:Show()
  updateRaidRoster()
  setDNAVars()
  raidPermissions()
  raidDetails()
end

SlashCmdList["DNA"] = function(msg)
  DNAOpenWindow()
end

DNAFrameMainOpen:SetScript("OnClick", function()
  DNAOpenWindow()
end)

--[==[
DNAMiniMap = CreateFrame("Button", nil, Minimap)
DNAMiniMap:SetFrameLevel(6)
DNAMiniMap:SetSize(24, 24)
DNAMiniMap:SetMovable(true)
DNAMiniMap:SetNormalTexture("Interface/Icons/inv_misc_book_04")
DNAMiniMap:SetPushedTexture("Interface/Icons/inv_misc_book_04")
DNAMiniMap:SetHighlightTexture("Interface/Icons/inv_misc_book_04")

local myIconPos = 40

local function UpdateMapButton()
  local Xpoa, Ypoa = GetCursorPosition()
  local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
  Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
  Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
  myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
  DNAMiniMap:ClearAllPoints()
  DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 62 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 62)
end
DNAMiniMap:RegisterForDrag("LeftButton")
DNAMiniMap:SetScript("OnDragStart", function()
    DNAMiniMap:StartMoving()
    DNAMiniMap:SetScript("OnUpdate", UpdateMapButton)
end)
DNAMiniMap:SetScript("OnDragStop", function()
    DNAMiniMap:StopMovingOrSizing()
    DNAMiniMap:SetScript("OnUpdate", nil)
    local point, relativeTo, relativePoint, xOfs, yOfs = DNAMiniMap:GetPoint()
    print(xOfs .. " , " .. yOfs)
    DNA[player.combine]["minimap_x"] = xOfs
    DNA[player.combine]["minimap_y"] = yOfs
    UpdateMapButton()
end)
DNAMiniMap:ClearAllPoints()
DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 62 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 62)
DNAMiniMap:SetScript("OnClick", function()
  DNAOpenWindow()
end)
]==]--
