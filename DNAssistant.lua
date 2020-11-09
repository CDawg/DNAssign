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

local packet = {}

local raidSlot = {}
local raidSlot_h = 20
local tankSlot = {}
local healSlot = {}

local player = {}
player.name = UnitName("player")
player.realm = GetRealmName()
player.combine=player.name .. "-" .. player.realm

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
local viewFrameLines = 20 --also setup the same for the assign window

local botTab = {}
local botBack = {}
local botBorder = {}

local viewFrameBotTab = {}

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

local pageDKPView={}
local pageDKPViewScrollChild_colOne = {}
local pageDKPViewScrollChild_colTwo = {}
local pageDKPViewScrollChild_colThree= {}

local version_checked = 0

local ddSelection = nil

--local pageTab = {}
local ddBossList = {}
local ddBossListText = {}
local DNAFrameInstance = {}
local DNAFrameInstanceText={}
local DNAFrameInstanceScript={}
local DNAFrameInstanceGlow={}

local pageRaidDetailsColOne = {}
local pageRaidDetailsColTwo = {}

local DNAFrameAssignTabIcon = {}
local DNAFrameAssignMapGroupID={}

local invited={}

local function getGuildComp()
  if (IsInGuild()) then
    local numTotalMembers, numOnlineMaxLevelMembers, numOnlineMembers = GetNumGuildMembers()
    for i=1, numTotalMembers do
      local name, rank, rankIndex, level, class, zone = GetGuildRosterInfo(i)
      local filterRealm = string.match(name, "(.*)-")
      DNAGuild["member"] = filterRealm
      DNAGuild["rank"][filterRealm] = rank
      --print(filterRealm .. " = " .. rank)
    end
    if (DEBUG) then
      print("getGuildComp()")
    end
  end
end

local function getRaidComp()
  total.raid = GetNumGroupMembers()
  --clear entries and rebuild to always get an accurate count on classes,races,names,etc...
  for k,v in pairs(DNARaid["class"]) do
    DNARaid["class"][k] = nil
  end
  for k,v in pairs(DNARaid["assist"]) do
    DNARaid["assist"][k] = nil
  end

  getGuildComp()

  for i = 1, MAX_RAID_MEMBERS do
    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)

    if (name) then
      DNARaid["assist"][name] = 0

      if (rank > 0) then
        DNARaid["assist"][name] = 1
      end
      if (rank > 1) then
        raidLead = name
      end

      if (IsInRaid()) then
        if (invited[name] ~= 1) then
          --print("DEBUG: " .. name .. " has joined")
          if (DNARaid["assist"][player.name] == 1) then
            if (player.name ~= name) then --dont promote self
              if (IsInGuild()) then
                if (DNAGuild["rank"][name] ~= nil) then --no guild rank or permission
                  if ((DNAGuild["rank"][name] == "Officer") or ((DNAGuild["rank"][name] == "Alt Officer"))) then
                    if (DNARaid["assist"][name] ~= 1) then --has not been promoted yet
                      if (UnitIsGroupAssistant(name) == false) then
                        if (DNACheckbox["AUTOPROMOTE"]:GetChecked()) then
                          DN:ChatNotification("Auto promoted: " .. name)
                          PromoteToAssistant(name)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        invited[name] = 1
      end

      DNARaid["member"][i] = name
      DNARaid["class"][name] = class
      DNARaid["race"][name] = UnitRace(name)
      DNARaid["groupid"][name] = subgroup

    end
  end

  -- Not in a raid, just place your name in the list as a placeholder
  if (total.raid <= 0) then
    DNARaid["member"][1] = player.name
  end

  --FAKE RAID
  if (DEBUG) then
    DNARaid["member"][1] = "Aellwyn"
    DNARaid["member"][2] = "Porthios"
    DNARaid["member"][3] = "Upya"
    DNARaid["member"][4] = "Zarj"
    DNARaid["member"][5] = "Cryonix"
    DNARaid["member"][6] = "Grayleaf"
    DNARaid["member"][7] = "Droott"
    DNARaid["member"][8] = "Aquilla"
    DNARaid["member"][9] = "Neilsbhor"
    DNARaid["member"][10] = "Frosthunt"
    DNARaid["member"][11] = "Nanodel"
    DNARaid["member"][12] = "Crisis"
    DNARaid["member"][13] = "Whistper"
    DNARaid["member"][14] = "Zarianna"
    DNARaid["member"][15] = "Averglade"
    DNARaid["member"][16] = "Roaxe"
    DNARaid["member"][17] = "Krizzu"
    DNARaid["member"][18] = "Elderpen"
    DNARaid["member"][19] = "Snibson"
    DNARaid["member"][20] = "Justwengit"
    DNARaid["member"][21] = "Däggerz"
    DNARaid["member"][22] = "Mirrand"
    DNARaid["member"][23] = "Corr"
    DNARaid["member"][24] = "Valency"
    DNARaid["member"][25] = "Nutty"
    DNARaid["member"][26] = "Zatos"
    DNARaid["member"][27] = "Muppot"
    DNARaid["member"][28] = "Gaelic"
    DNARaid["member"][29] = "Chrundle"
    DNARaid["member"][30] = "Akilina"
    DNARaid["member"][31] = "Mairakus"
    DNARaid["member"][32] = "Sleapy"
    DNARaid["member"][33] = "Stumpymcaxe"
    DNARaid["member"][34] = "Cahonez"
    DNARaid["member"][35] = "Avarius"
    DNARaid["member"][36] = "Blackprince"
    DNARaid["member"][37] = "Nightling"
    DNARaid["member"][38] = "Kelvarn"
    DNARaid["member"][39] = "Measles"

    DNARaid["class"]["Aellwyn"] = "Warrior"
    DNARaid["class"]["Porthios"] = "Warrior"
    DNARaid["class"]["Upya"] = "Warlock"
    DNARaid["class"]["Zarj"] = "Rogue"
    DNARaid["class"]["Cryonix"] = "Priest"
    DNARaid["class"]["Grayleaf"] = "Warrior"
    DNARaid["class"]["Droott"] = "Druid"
    DNARaid["class"]["Aquilla"] = "Mage"
    DNARaid["class"]["Neilsbhor"] = "Mage"
    DNARaid["class"]["Frosthunt"] = "Hunter"
    DNARaid["class"]["Nanodel"] = "Hunter"
    DNARaid["class"]["Crisis"] = "Warrior"
    DNARaid["class"]["Whistper"] = "Hunter"
    DNARaid["class"]["Zarianna"] = "Paladin"
    DNARaid["class"]["Roaxe"] = "Paladin"
    DNARaid["class"]["Krizzu"] = "Mage"
    DNARaid["class"]["Elderpen"] = "Warrior"
    DNARaid["class"]["Snibson"] = "Priest"
    DNARaid["class"]["Averglade"] = "Paladin"
    DNARaid["class"]["Justwengit"] = "Mage"
    DNARaid["class"]["Däggerz"] = "Rogue"
    DNARaid["class"]["Mirrand"] = "Rogue"
    DNARaid["class"]["Corr"] = "Paladin"
    DNARaid["class"]["Valency"] = "Warlock"
    DNARaid["class"]["Nutty"] = "Paladin"
    DNARaid["class"]["Zatos"] = "Priest"
    DNARaid["class"]["Muppot"] = "Warlock"
    DNARaid["class"]["Gaelic"] = "Paladin"
    DNARaid["class"]["Chrundle"] = "Mage"
    DNARaid["class"]["Akilina"] = "Warrior"
    DNARaid["class"]["Sleapy"] = "Priest"
    DNARaid["class"]["Mairakus"] = "Warrior"
    DNARaid["class"]["Stumpymcaxe"] = "Warrior"
    DNARaid["class"]["Cahonez"] = "Rogue"
    DNARaid["class"]["Avarius"] = "Warrior"
    DNARaid["class"]["Blackprince"] = "Paladin"
    DNARaid["class"]["Measles"] = "Warlock"
    DNARaid["class"]["Nightling"] = "Druid"
    DNARaid["class"]["Kelvarn"] = "Priest"

    DNARaid["groupid"]["Aellwyn"] = 1
    DNARaid["groupid"]["Porthios"] = 1
    DNARaid["groupid"]["Zarianna"] = 1
    DNARaid["groupid"]["Upya"] = 1
    DNARaid["groupid"]["Zarj"] = 1
    DNARaid["groupid"]["Cryonix"] = 2
    DNARaid["groupid"]["Grayleaf"] = 2
    DNARaid["groupid"]["Droott"] = 2
    DNARaid["groupid"]["Aquilla"] = 2
    DNARaid["groupid"]["Neilsbhor"] = 2
    DNARaid["groupid"]["Frosthunt"] = 3
    DNARaid["groupid"]["Nanodel"] = 3
    DNARaid["groupid"]["Crisis"] = 3
    DNARaid["groupid"]["Whistper"] = 3
    DNARaid["groupid"]["Roaxe"] = 3
    DNARaid["groupid"]["Krizzu"] = 4
    DNARaid["groupid"]["Elderpen"] = 4
    DNARaid["groupid"]["Snibson"] = 4
    DNARaid["groupid"]["Justwengit"] = 4
    DNARaid["groupid"]["Däggerz"] = 4
    DNARaid["groupid"]["Mirrand"] = 5
    DNARaid["groupid"]["Corr"] = 5
    DNARaid["groupid"]["Valency"] = 5
    DNARaid["groupid"]["Nutty"] = 5
    DNARaid["groupid"]["Zatos"] = 5
    DNARaid["groupid"]["Muppot"] = 6
    DNARaid["groupid"]["Gaelic"] = 6
    DNARaid["groupid"]["Chrundle"] = 6
    DNARaid["groupid"]["Akilina"] = 6
    DNARaid["groupid"]["Sleapy"] = 6
    DNARaid["groupid"]["Mairakus"] = 7
    DNARaid["groupid"]["Stumpymcaxe"] = 7
    DNARaid["groupid"]["Cahonez"] = 7
    DNARaid["groupid"]["Avarius"] = 7
    DNARaid["groupid"]["Blackprince"] = 7
    DNARaid["groupid"]["Measles"] = 8
    DNARaid["groupid"]["Nightling"] = 8
    DNARaid["groupid"]["Kelvarn"] = 8
    DNARaid["groupid"]["Averglade"] = 8

    DNARaid["race"]["Kelvarn"] = "Dwarf"

    print("DEBUG: getRaidComp() total:" .. total.raid)
  end

end

--[==[
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
]==]--

local DNAFrameAssignNotReady={}

function raidReadyClear()
  for i=1, MAX_RAID_MEMBERS do
    raidSlot[i].ready:SetTexture("")
  end
  for i=1, DNASlots.tank do
    tankSlot[i].ready:SetTexture("")
  end
  for i=1, DNASlots.heal do
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
  else
    for i=1, MAX_RAID_MEMBERS do
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
  end
end


--alpha sort the member matrix
local DNARaidMemberSorted = {}
function DN:UpdateRaidRoster()
  local k=0
  --clear all entries, then rebuild raid
  for i = 1, MAX_RAID_MEMBERS do
    DNARaid["member"][i] = nil
  end
  getRaidComp()
  for i = 1, MAX_RAID_MEMBERS do
    DNARaidMemberSorted[i] = nil
    raidSlot[i].text:SetText("")
    raidSlot[i]:Hide()
  end

  --clear the totals then rebuild
  for k,v in pairs(total) do
    total[k] = 0
  end
  for i = 1, DNASlots.tank do
    tankSlot[i].icon:SetTexture("")
    for k, v in pairs(DNARaid["assist"]) do
      if ((tankSlot[i].text:GetText() == k) and (v == 1)) then
        tankSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
    if (tankSlot[i].text:GetText() ~= "Empty") then
      total.tanks = total.tanks +1
      remove_slot = singleKeyFromValue(DNARaid["member"], tankSlot[i].text:GetText())
      if (DNARaid["member"][remove_slot] == tankSlot[i].text:GetText()) then
        DNARaid["member"][remove_slot] = nil
      end
    end
  end

  for i = 1, DNASlots.heal do
    healSlot[i].icon:SetTexture("")
    for k, v in pairs(DNARaid["assist"]) do
      if ((healSlot[i].text:GetText() == k) and (v == 1)) then
        healSlot[i].icon:SetTexture("Interface/GROUPFRAME/UI-GROUP-ASSISTANTICON")
      end
    end
    if (healSlot[i].text:GetText() ~= "Empty") then
      total.healers = total.healers +1
      remove_slot = singleKeyFromValue(DNARaid["member"], healSlot[i].text:GetText())
      if (DNARaid["member"][remove_slot] == healSlot[i].text:GetText()) then
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
    --print("DEBUG: " .. k .. "=" .. v)
    --set text, get class color for each raid slot built
    if (v ~= nil) then
      raidSlot[k].text:SetText(v)
      raidSlot[k]:Show()
      --thisClass = UnitClass(v)
      thisClass = DNARaid["class"][v]
      DN:ClassColorText(raidSlot[k].text, thisClass)
    end
  end

  for i = 1, table.getn(DNARaidMemberSorted) do
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

  total.raid = total.warriors + total.druids + total.priests + total.mages + total.warlocks + total.hunters + total.rogues + total.paladins
  total.melee = total.warriors + total.rogues + total.druids
  total.range = total.hunters + total.mages + total.warlocks

  if (DEBUG) then
    print("DEBUG: DN:UpdateRaidRoster()")
  end
end

local function clearFrameView()
  for i = 1, viewFrameLines do
    DNAFrameViewScrollChild_mark[i]:SetTexture("")
    DNAFrameViewScrollChild_tank[i]:SetText("")
    DNAFrameViewScrollChild_heal[i]:SetText("")
  end
  --ddBossListText[DNARaidBosses[1][1]]:SetText("Select a boss")
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

local function clearFrameAssignPersonal()
  DNAFrameAssignPersonalMark:SetTexture("")
  DNAFrameAssignPersonalColOne:SetText("")
  DNAFrameAssignPersonalColTwo:SetText("")
end

local function InstanceButtonToggle(name, icon)
  local instanceNum = multiKeyFromValue(DNAInstance, name)
  for i, v in ipairs(DNAInstance) do
    DNAFrameInstance[DNAInstance[i][1]]:SetBackdrop({
      bgFile = DNAInstance[i][5],
      edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
      edgeSize = 18,
      insets = {left=0, right=-45, top=0, bottom=-44},
    })
    DNAFrameInstanceGlow[DNAInstance[i][1]]:Hide()
  end
  DNAFrameInstance[name]:SetBackdrop({
    bgFile = icon,
    edgeFile = "Interface/TUTORIALFRAME/UI-TutorialFrame-CalloutGlow",
    edgeSize = 8,
    insets = {left=0, right=-45, top=0, bottom=-44},
  })
  DNAFrameInstanceGlow[name]:Show()
  pageBanner:SetTexture(DNAInstance[instanceNum][3])
  pageBanner.text:SetText(DNAInstance[instanceNum][2])
  pageBossIcon:SetTexture(DNAInstance[instanceNum][4])
  PlaySound(844)
end

--parse the incoming packet
local function parsePacket(packet, netpacket)
  DN:UpdateRaidRoster()
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
  if (packet.role == "T") then
    if ((packet.name == nil) or (packet.name == "Empty")) then
      tankSlot[packet.slot].text:SetText("Empty")
      tankSlot[packet.slot].icon:SetTexture("")
      tankSlot[packet.slot]:SetFrameLevel(2)
      tankSlot[packet.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
      tankSlot[packet.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
      DN:ClassColorText(tankSlot[packet.slot].text, "Empty")
    else
      tankSlot[packet.slot].text:SetText(packet.name)
      tankSlot[packet.slot]:SetFrameLevel(4)
      tankSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
      tankSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
      thisClass = DNARaid["class"][packet.name]
      DN:ClassColorText(tankSlot[packet.slot].text, thisClass)
      --PromoteToAssistant(packet.name)
      --SetPartyAssignment("MAINTANK", packet.name, 1);
    end
  end
  if (packet.role == "H") then
    if ((packet.name == nil) or (packet.name == "Empty")) then
      healSlot[packet.slot].text:SetText("Empty")
      healSlot[packet.slot].icon:SetTexture("")
      healSlot[packet.slot]:SetFrameLevel(2)
      healSlot[packet.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
      healSlot[packet.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
      DN:ClassColorText(healSlot[packet.slot].text, "Empty")
    else
      healSlot[packet.slot].text:SetText(packet.name)
      healSlot[packet.slot]:SetFrameLevel(4)
      healSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
      healSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
      --thisClass = UnitClass(packet.name)
      thisClass = DNARaid["class"][packet.name]
      DN:ClassColorText(healSlot[packet.slot].text, thisClass)
    end
  end

  --update the saved
  DNA[player.combine]["ASSIGN"][packet.role .. packet.slot] = packet.name
  DN:UpdateRaidRoster()
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

local DNAFrameAssignPersonal_w = 300
local DNAFrameAssignPersonal_h = 50
DNAFrameAssignPersonal = CreateFrame("Frame", nil, UIParent)
DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w)
DNAFrameAssignPersonal:SetHeight(DNAFrameAssignPersonal_h)
DNAFrameAssignPersonal:SetPoint("BOTTOMRIGHT", -120, 200)
DNAFrameAssignPersonal:SetMovable(true)
DNAFrameAssignPersonal:EnableMouse(true)
DNAFrameAssignPersonal:SetFrameStrata("DIALOG")
DNAFrameAssignPersonal:RegisterForDrag("LeftButton")
DNAFrameAssignPersonal:SetBackdrop({
  bgFile = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  insets = {left=0, right=0, top=0, bottom=0},
})
DNAFrameAssignPersonal:SetScript("OnDragStart", function()
    DNAFrameAssignPersonal:StartMoving()
end)
DNAFrameAssignPersonal:SetScript("OnDragStop", function()
  DNAFrameAssignPersonal:StopMovingOrSizing()
end)
DNAFrameAssignPersonal:SetBackdropColor(0, 0, 0, 1)
DNAFrameAssignPersonal.header = CreateFrame("Frame", nil, DNAFrameAssignPersonal)
DNAFrameAssignPersonal.header:SetWidth(DNAFrameAssignPersonal_w)
DNAFrameAssignPersonal.header:SetHeight(18)
DNAFrameAssignPersonal.header:SetPoint("TOPLEFT", 0, 0)
DNAFrameAssignPersonal.header:SetBackdrop({
  bgFile = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  insets = {left=0, right=0, top=0, bottom=0},
})
DNAFrameAssignPersonal.headerText = DNAFrameAssignPersonal.header:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonal.headerText:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignPersonal.headerText:SetPoint("TOPLEFT", 5, -3)
DNAFrameAssignPersonal.headerText:SetText(player.name .. "'s Assignment             DNA v" .. DNAGlobal.version)
DNAFrameAssignPersonal.headerText:SetTextColor(1, 1, 0.4)
DNAFrameAssignPersonal.close = CreateFrame("Button", nil, DNAFrameAssignPersonal)
DNAFrameAssignPersonal.close:SetWidth(25)
DNAFrameAssignPersonal.close:SetHeight(25)
DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal_w-20, 4)
DNAFrameAssignPersonal.close:SetFrameLevel(4)
DNAFrameAssignPersonal.close:SetBackdrop({
  bgFile = "Interface/Buttons/UI-Panel-MinimizeButton-Up",
  insets = {left=0, right=0, top=0, bottom=0},
})
DNAFrameAssignPersonal.close:SetScript("OnClick", function()
    DNAFrameAssignPersonal:Hide()
end)
DNAFrameAssignPersonal:Hide()

--DNAFrameAssignMe:Hide()
DNAFrameAssignPersonalMark = DNAFrameAssignPersonal:CreateTexture(nil, "ARTWORK")
DNAFrameAssignPersonalMark:SetSize(16, 16)
DNAFrameAssignPersonalMark:SetPoint("TOPLEFT", 10, -22)
DNAFrameAssignPersonalMark:SetTexture("")
DNAFrameAssignPersonalColOne = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalColOne:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignPersonalColOne:SetPoint("TOPLEFT", 30, -25)
DNAFrameAssignPersonalColOne:SetText("")
DNAFrameAssignPersonalColTwo = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalColTwo:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignPersonalColTwo:SetPoint("TOPLEFT", 125, -25)
DNAFrameAssignPersonalColTwo:SetText("")

--hack, have to create a frame due to the tab clipping over
local DNAFrameAssignBossMapFrame = CreateFrame("Frame", nil, DNAFrameAssignPage["map"], "InsetFrameTemplate")
DNAFrameAssignBossMapFrame:SetSize(384, 301)
DNAFrameAssignBossMapFrame:SetPoint("TOPLEFT", 8, -20)
DNAFrameAssignBossMapFrame:SetFrameStrata("DIALOG")
DNAFrameAssignBossMapFrame:SetFrameLevel(200)

DNAFrameAssignBossMap = DNAFrameAssignBossMapFrame:CreateTexture(nil, "OVERLAY", DNAFrameAssignBossMapFrame)
DNAFrameAssignBossMap:SetSize(384, 300)
DNAFrameAssignBossMap:SetPoint("TOPLEFT", 0, 0)
DNAFrameAssignBossMap:SetTexture(DNAGlobal.dir .. "images/mc") --default
DNAFrameAssign:SetBackdrop({
  bgFile = DNAGlobal.background,
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 26,
  insets = {left=8, right=8, top=8, bottom=8},
})

DNAFrameAssignMapGroupID = DNAFrameAssignPage["map"]:CreateFontString(nil, "ARTWORK")
DNAFrameAssignMapGroupID:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignMapGroupID:SetPoint("TOPLEFT", DNAFrameAssignPage["map"], "TOPLEFT", 20, -340)
DNAFrameAssignMapGroupID:SetText("")
DNAFrameAssignMapGroupID:SetTextColor(1.0, 1.0, 0.7)

local DNAFrameAssignScrollBG = CreateFrame("Frame", nil, DNAFrameAssignPage["assign"], "InsetFrameTemplate")
DNAFrameAssignScrollBG:SetWidth(DNAFrameAssign_w-40)
DNAFrameAssignScrollBG:SetHeight(DNAFrameAssign_h-150)
DNAFrameAssignScrollBG:SetPoint("TOPLEFT", 20, -70)

DNAFrameAssign.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAFrameAssignPage["assign"], "UIPanelScrollFrameTemplate")
DNAFrameAssign.ScrollFrame:SetPoint("TOPLEFT", DNAFrameAssignPage["assign"], "TOPLEFT", 6, -75)
DNAFrameAssign.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAFrameAssignPage["assign"], "BOTTOMRIGHT", 6, 85)
local DNAFrameAssignScrollChild = CreateFrame("Frame", nil, DNAFrameAssign.ScrollFrame)
DNAFrameAssignScrollChild:SetSize(DNAFrameAssign_w-40, DNAFrameAssign_h-80)
DNAFrameAssign.ScrollFrame:SetScrollChild(DNAFrameAssignScrollChild)
DNAFrameAssign.ScrollFrame.ScrollBar:ClearAllPoints()
DNAFrameAssign.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAFrameAssign.ScrollFrame, "TOPRIGHT", -175, -15)
DNAFrameAssign.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAFrameAssign.ScrollFrame, "BOTTOMRIGHT", 100, 14)
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
  DNAFrameAssignScrollChild_mark[i]:SetPoint("TOPLEFT", 20, (-i*18)+12)
  DNAFrameAssignScrollChild_mark[i]:SetTexture("")

  DNAFrameAssignScrollChild_tank[i] = DNAFrameAssignScrollChild:CreateFontString(nil, "ARTWORK")
  DNAFrameAssignScrollChild_tank[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameAssignScrollChild_tank[i]:SetText("")
  DNAFrameAssignScrollChild_tank[i]:SetPoint("TOPLEFT", 45, (-i*18)+10)

  DNAFrameAssignScrollChild_heal[i] = DNAFrameAssignScrollChild:CreateFontString(nil, "ARTWORK")
  DNAFrameAssignScrollChild_heal[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameAssignScrollChild_heal[i]:SetText("")
  DNAFrameAssignScrollChild_heal[i]:SetPoint("TOPLEFT", 145, (-i*18)+10)
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
  ConfirmReadyCheck(1) --ready
  DN:SendPacket("send", "+" .. player.name, true)
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
  ConfirmReadyCheck() --not ready
  DN:SendPacket("send", "!" .. player.name, true)
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
  DNAFrameAssignTabIcon[name] = DNAFrameAssignTab[name]:CreateTexture(nil, "BACKGROUND", DNAFrameAssignTab[name], 1)
  DNAFrameAssignTabIcon[name]:SetSize(44, 40)
  DNAFrameAssignTabIcon[name]:SetPoint("TOPLEFT", 5, -6)
  DNAFrameAssignTabIcon[name]:SetTexture(icon)

  DNAFrameAssignTab[name]:SetScript("OnClick", function()
    DNAFrameAssignTabToggle(name)
  end)
end

DNAFrameAssignSideTab("assign", DNAGlobal.dir .. "images/tab_boss", 30)
DNAFrameAssignSideTab("map", "Interface/WorldMap/BlackwingLair/BlackwingLair3_6", 80)

DNAFrameAssignTabToggle("assign") --default

DNAFrameAssign:Hide()

local DNAFrameAssignTab={}

--[==[
function DNAFrameAssignTabToggle(name)
  DNAFrameAssignTab["assign"]:SetFrameLevel(1)
  DNAFrameAssignTab["map"]:SetFrameLevel(1)
  DNAFrameAssignPage["assign"]:Hide()
  DNAFrameAssignPage["map"]:Hide()
  DNAFrameAssignTab[name]:SetFrameLevel(155)
  DNAFrameAssignPage[name]:Show()
end
]==]--

DN:ChatNotification("v" .. DNAGlobal.version .. " Initializing...")

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
  healer.nodruid ={}
  local boss=""
  local mark = {}
  local text = {}
  local NUM_ADDS = 0
  local raid={}
  raid.warrior={}
  raid.mage={}
  raid.paladin={}
  raid.hunter={}
  raid.rogue={}
  raid.warlock={}
  raid.priest={}
  raid.druid={}
  raid.range={}
  local assign_lock={}
  assign_lock[player.name] = 0

  DN:UpdateRaidRoster()

  clearFrameView() --clear out the current text
  clearFrameAssign()
  clearFrameAssignPersonal()
  DNAFrameAssignPersonal:Hide()

  if (total.raid < 8) then
    DNAFrameViewScrollChild_mark[3]:SetTexture("Interface/DialogFrame/UI-Dialog-Icon-AlertNew")
    DNAFrameViewScrollChild_tank[3]:SetText("Not enough raid members to form assignments!")
    DNABossMap = ""
    return
  end

  for i=1, DNASlots.tank do
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tank.main[i] = tankSlot[i].text:GetText()
      -- always build tanks so the 'nils' dont error
      tank.banish[i] = tankSlot[i].text:GetText()
    end
  end

  for i=1, DNASlots.heal do
    if (healSlot[i].text:GetText() ~= "Empty") then
      healer.all[i] = healSlot[i].text:GetText()
      if (DNARaid["class"][healer.all[i]] == "Paladin") then
        table.insert(healer.paladin, healer.all[i])
      end
      if (DNARaid["class"][healer.all[i]] == "Druid") then
        table.insert(healer.druid, healer.all[i])
      end
      if (DNARaid["class"][healer.all[i]] == "Priest") then
        table.insert(healer.priest, healer.all[i])
      end
    end
  end

  --include warriors as OT
  for k,v in pairs(DNARaid["class"]) do
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

  --[==[
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
  ]==]--

  table.merge(tank.all, tank.main)
  table.merge(tank.all, raid.warrior)
  table.merge(tank.banish, raid.warlock)
  table.merge(tank.banish, raid.warrior) -- merge all tanks with warlocks
  table.merge(healer.nodruid, healer.priest)
  table.merge(healer.nodruid, healer.paladin)
  table.merge(raid.range, raid.hunter)
  table.merge(raid.range, raid.warlock)
  table.merge(raid.range, raid.mage)

  --[==[
  for i=1, table.getn(healer.nodruid) do
    print(healer.nodruid[i])
  end

  for i=1, table.getn(tank.banish) do
    print(tank.banish[i])
  end
  ]==]--

  if ((total.tanks < 2) or (total.healers < 2)) then
    DNAFrameViewScrollChild_mark[3]:SetTexture("Interface/DialogFrame/UI-Dialog-Icon-AlertNew")
    DNAFrameViewScrollChild_tank[3]:SetText("Not enough Tanks and Healers assigned!")
    DNABossMap = ""
    return
  end

  DNAInstanceMC(assign, total, raid, mark, text, heal, tank, healer)
  DNAInstanceBWL(assign, total, raid, mark, text, heal, tank, healer)
  DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer)

  for i=1, viewFrameLines do
    if (mark[i]) then
      DNAFrameViewScrollChild_mark[i]:SetTexture(mark[i])
      DNAFrameAssignScrollChild_mark[i]:SetTexture(mark[i])
    end
    if (text[i]) then
      DNAFrameViewScrollChild_tank[i]:SetText(text[i])
      DN:ClassColorText(DNAFrameViewScrollChild_tank[i], DNARaid["class"][text[i]])
      DNAFrameAssignScrollChild_tank[i]:SetText(text[i])
      DN:ClassColorText(DNAFrameAssignScrollChild_tank[i], DNARaid["class"][text[i]])
    end

    if (text[i] == player.name) then
      if (assign_lock[player.name] ~= 1) then
        if (mark[i]) then --pull mark
          DNAFrameAssignPersonalMark:SetTexture(mark[i])
        end
        if (text[i]) then --pull tank to see who we are healing
          DNAFrameAssignPersonalColOne:SetText(text[i])
          DN:ClassColorText(DNAFrameAssignPersonalColOne, DNARaid["class"][text[i]])
        end
        assign_lock[player.name] = 1
        DNAFrameAssignPersonal:Show()
      end
    end

    if (heal[i]) then
      local filterHealer={}
      healer_row = split(heal[i], ",")
      filterHealer[i] = string.gsub(heal[i], ',', " / ")
      filter_row = ""
      for n=1, table.getn(healer_row) do
        --print("DEBUG :" .. healer_row[n])
        if (n > 1) then
          filter_row = filter_row .. " / " .. DN:ClassColorAppend(healer_row[n], DNARaid["class"][healer_row[n]])
        else
          filter_row = DN:ClassColorAppend(healer_row[n], DNARaid["class"][healer_row[n]])
        end
        if (healer_row[n] == player.name) then
          if (assign_lock[player.name] ~= 1) then
            if (mark[i]) then --pull mark
              DNAFrameAssignPersonalMark:SetTexture(mark[i])
            end
            if (text[i]) then --pull tank to see who we are healing
              DNAFrameAssignPersonalColOne:SetText(text[i])
              DN:ClassColorText(DNAFrameAssignPersonalColOne, DNARaid["class"][text[i]])
            end
            DNAFrameAssignPersonalColTwo:SetText(filter_row)
            assign_lock[player.name] = 1
            DNAFrameAssignPersonal:Show()
          end
        end
      end

      --print(filter_row)
      DNAFrameViewScrollChild_heal[i]:SetText(filter_row)
      DNAFrameAssignScrollChild_heal[i]:SetText(filter_row)
    end
  end

  if (source == "network") then
    if (DNACheckbox["RAIDCHAT"]:GetChecked()) then
      for i=1, viewFrameLines do
        local this_key = 0
        local text_line = ""
        if (text[i]) then
          if (mark[i]) then
            this_key = singleKeyFromValue(DNARaidMarkerText, mark[i])
          end
          if (DNARaidMarkerIcon[this_key]) then
            text_line = text_line .. DNARaidMarkerIcon[this_key] .. " "
          else
            text_line = text_line
          end
          if (heal[i]) then
            text_line = text_line .. text[i] .. " [" .. heal[i] .. "]"
          else
            text_line = text_line .. text[i]
          end
          SendChatMessage(text_line, "RAID", nil, "RAID")
        end
      end
    end
  end

  pageBossIcon:SetTexture(DNABossIcon)
  --pageBossMap:SetTexture(DNABossIcon)
  if (DNABossIcon) then
    DNAFrameAssignBossIcon:SetTexture(DNABossIcon)
  end
  if (DNABossMap) then
    DNAFrameViewBossMap:SetTexture(DNABossMap)
    DNAFrameAssignBossMap:SetTexture(DNABossMap)
    DNAFrameAssignTabIcon["map"]:SetTexture(DNABossMap) --update the little assign tab icon
    if (IsInRaid()) then
      DNAFrameAssignMapGroupID:SetText(player.name .. " is in group " .. DNARaid["groupid"][player.name])
    end
  end
  if (author ~= nil) then
    DNAFrameAssignAuthor:SetText(author .. " has sent raid assignments.")
  end

  raidSelection = packet
end

function raidDetails()
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
local success = C_ChatInfo.RegisterAddonMessagePrefix(DNAGlobal.prefix)
DNAMain:RegisterEvent("CHAT_MSG_ADDON")
DNAMain:RegisterEvent("ZONE_CHANGED")
DNAMain:RegisterEvent("ZONE_CHANGED_NEW_AREA")
DNAMain:RegisterEvent("GROUP_ROSTER_UPDATE")
DNAMain:RegisterEvent("PLAYER_ENTER_COMBAT")
DNAMain:RegisterEvent("PLAYER_REGEN_DISABLED")
--DNAMain:RegisterEvent("PARTY_INVITE_REQUEST")
DNAMain:RegisterEvent("CHAT_MSG_LOOT")

DNAMain:SetScript("OnEvent", function(self, event, prefix, netpacket)
  if ((event == "ADDON_LOADED") and (prefix == "DNA")) then
    DN:BuildGlobal()
  end

  if (event == "PLAYER_LOGIN") then
    DN:BuildGlobal()
    DN:SetVars()
  end

  --[==[
  if (event == "CHAT_MSG_LOOT") then
    loot_msg = string.match(prefix, "item[%-?%d:]+")
    --local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(loot_msg)
    --DN:SendPacket("send", "_" .. player.name .. "," .. itemName, false)
    --safeter to store by the odd string for the itemID
    local inInstance, instanceType = IsInInstance()
    if (inInstance) then
      if (instanceType == "Raid") then
        local instanceName = GetInstanceInfo()
        if (instanceName) then
          DN:SendPacket("send", "_" .. instanceName .. "," .. player.name .. "," .. loot_msg, false)
        end
      end
    end
  end
  ]==]--

  if (event == "GROUP_ROSTER_UPDATE") then
    DN:UpdateRaidRoster()
  end

  if ((event == "PLAYER_ENTER_COMBAT") or (event== "PLAYER_REGEN_DISABLED")) then
    raidReadyClear()
    --print("entered combat!")
  end

  if (event == "CHAT_MSG_ADDON") then
    if (prefix == DNAGlobal.prefix) then
      if (DEBUG) then
        print("DEBUG: Reading netpacket " .. netpacket)
      end

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
            DN:ChatNotification("|cffff0000 You have an outdated version!\nCurrent version is " .. netpacket)
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
        if (DNA[player.combine]["LOOTLOG"][date_day] == nil) then
          DNA[player.combine]["LOOTLOG"][date_day] = {}
        end
        netpacket = string.gsub(netpacket, "_", "")

        local inInstance, instanceType = IsInInstance()
        if (inInstance) then
          if (instanceType == "Raid") then
            local instanceName = GetInstanceInfo()
            if (instanceName) then
              table.insert(DNA[player.combine]["LOOTLOG"][date_day], {timestamp .. "," .. instanceName .. "," .. netpacket})
            end
          end
        end
        --print(cur_date)
        --DNA[player.combine]["Loot Log"] = {cur_date .. "," .. netpacket}
        table.insert(DNA[player.combine]["LOOTLOG"][date_day], {netpacket .. "," .. timestamp})
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

function DN:SetVars()
  local getsave = {}
  for k,v in pairs(DNA[player.combine]["ASSIGN"]) do
    getsave.key = k
    getsave.role = string.gsub(k, "[^a-zA-Z]", "") --remove numbers
    getsave.slot = string.gsub(k, getsave.role, "")
    getsave.slot = tonumber(getsave.slot)
    getsave.name = v

    if (getsave.role == "T") then
      if ((getsave.name == nil) or (getsave.name == "Empty")) then
        tankSlot[getsave.slot].text:SetText("Empty")
        tankSlot[getsave.slot]:SetFrameLevel(2)
        tankSlot[getsave.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        tankSlot[getsave.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(tankSlot[getsave.slot].text, "Empty")
      else
        tankSlot[getsave.slot].text:SetText(getsave.name)
        tankSlot[getsave.slot]:SetFrameLevel(3)
        tankSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        tankSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(tankSlot[getsave.slot].text, thisClass)
      end
    end
    if (getsave.role == "H") then
      if ((getsave.name == nil) or (getsave.name == "Empty")) then
        healSlot[getsave.slot].text:SetText("Empty")
        healSlot[getsave.slot]:SetFrameLevel(2)
        healSlot[getsave.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        healSlot[getsave.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(healSlot[getsave.slot].text, "Empty")
      else
        healSlot[getsave.slot].text:SetText(getsave.name)
        healSlot[getsave.slot]:SetFrameLevel(3)
        healSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        healSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(healSlot[getsave.slot].text, thisClass)
      end
    end
  end

  if (DNA[player.combine]["CONFIG"]["AUTOPROMOTE"] == "ON") then
    DNACheckbox["AUTOPROMOTE"]:SetChecked(true)
  end

  --[==[
  if (DNA[player.combine]["CONFIG"]["DEBUG"] == "ON") then
    DNACheckbox["DEBUG"]:SetChecked(true)
    DEBUG = true
  end
  ]==]--

  if (DNA[player.combine]["CONFIG"]["HIDEICON"] == "ON") then
    DNACheckbox["HIDEICON"]:SetChecked(true)
    DNAMiniMap:Hide()
  end

  if (DNA[player.combine]["CONFIG"]["RAIDCHAT"] == "ON") then
    DNACheckbox["RAIDCHAT"]:SetChecked(true)
  end

  if (DNA[player.combine]["CONFIG"]["RAID"]) then
    local instanceNum = multiKeyFromValue(DNAInstance, DNA[player.combine]["CONFIG"]["RAID"])
    InstanceButtonToggle(DNAInstance[instanceNum][1], DNAInstance[instanceNum][5])
    for i, v in ipairs(DNAInstance) do
      ddBossList[DNAInstance[i][1]]:Hide()
      ddBossListText[DNAInstance[i][1]]:SetText("Select a boss")
    end
    ddBossList[DNAInstance[instanceNum][1]]:Show()
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
  PlaySound(88)
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
pageBanner:SetTexture(DNAInstance[1][3]) --default
pageBanner:SetTexCoord(0, 1, 0.25, 0.50)
pageBanner:SetSize(400, 54)
pageBanner:SetPoint("TOPLEFT", 570, -28)
local pageBannerBorder = page[pages[1][1]]:CreateTexture(nil, "BACKGROUND", page[pages[1][1]], 1)
pageBannerBorder:SetTexture("Interface/ACHIEVEMENTFRAME/UI-Achievement-MetalBorder-Top")
pageBannerBorder:SetSize(452, 14)
pageBannerBorder:SetPoint("TOPLEFT", 570, -75)
pageBanner.text = page[pages[1][1]]:CreateFontString(nil, "ARTWORK")
pageBanner.text:SetFont("Fonts/MORPHEUS.ttf", 18, "OUTLINE")
pageBanner.text:SetText(DNAInstance[1][2]) --default
pageBanner.text:SetTextColor(1.00, 1.00, 0.60)
pageBanner.text:SetPoint("TOPLEFT", pageBanner, "TOPLEFT", 20, -8)
pageBossIcon = page[pages[1][1]]:CreateTexture(nil, "ARTWORK")
pageBossIcon:SetTexture(DNAInstance[1][4]) --default
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

function DN:CheckBox(checkID, checkName, parentFrame, posX, posY)
  local check_static = CreateFrame("CheckButton", nil, parentFrame, "ChatConfigCheckButtonTemplate")
  check_static:SetPoint("TOPLEFT", posX, -posY-40)
  check_static.text = check_static:CreateFontString(nil,"ARTWORK")
  check_static.text:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
  check_static.text:SetPoint("TOPLEFT", check_static, "TOPLEFT", 25, -5)
  check_static.text:SetText(checkName)
  --check_static.tooltip = checkName
  check_static:SetScript("OnClick", function()
    if (DNA[player.combine]["CONFIG"][checkID] == "ON") then
      DNA[player.combine]["CONFIG"][checkID] = "OFF"
      if (checkID == "HIDEICON") then
        DNAMiniMap:Show()
      end
    else
      DNA[player.combine]["CONFIG"][checkID] = "ON"
      if (checkID == "HIDEICON") then
        DNAMiniMap:Hide()
      end
    end
  end)
  DNACheckbox[checkID] = check_static
end

DN:CheckBox("AUTOPROMOTE", "Auto Promote Guild Officers", page[pages[5][1]], 10, 0)
DN:CheckBox("RAIDCHAT", "Assign Marks To Raid Chat", page[pages[5][1]], 10, 20)
DN:CheckBox("HIDEICON", "Hide The Minimap Icon", page[pages[5][1]], 10, 60)
--DN:CheckBox("DEBUG", "Debug Mode (Very Spammy)", page[pages[5][1]], 10, 80)

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
      DN:SendPacket("send", "@" .. pageDKPEdit:GetText(), true)
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

function DN:Notification(msg, show)
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
      DN:SendPacket("send", role .. i .. "," .. name, true)
      DN:SendPacket("send", "#" .. DNAGlobal.version, true)
    else
      DN:Notification("You do not have raid permission to modify assignments.   [E1]", true)
    end
  else
    return DN:Notification("You are not in a raid!   [E1]", true)
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
    DN:Notification("", false)
    for i, v in ipairs(DNAInstance) do
      ddBossList[DNAInstance[i][1]]:Hide() --hide all dropdowns
    end
    local instanceNum = multiKeyFromValue(DNAInstance, name)
    clearFrameView()
    InstanceButtonToggle(name, icon)
    DNA[player.combine]["CONFIG"]["RAID"] = name
    ddBossList[name]:Show()
    ddBossListText[name]:SetText("Select a boss")
  end)
  DNAFrameInstanceGlow[name] = DNAFrameInstance[name]:CreateTexture(nil, "BACKGROUND", DNAFrameInstance[name], -5)
  DNAFrameInstanceGlow[name]:SetTexture("Interface/ExtraButton/ChampionLight")
  DNAFrameInstanceGlow[name]:SetSize(190, 125)
  DNAFrameInstanceGlow[name]:SetPoint("TOPLEFT", -24, 20)
  DNAFrameInstanceGlow[name]:Hide()
end

for i, v in ipairs(DNAInstance) do
  instanceButton(DNAInstance[i][1], i*100, DNAInstance[i][2], DNAInstance[i][5]) --draw all tabs
end

InstanceButtonToggle(DNAInstance[1][1], DNAInstance[1][5])

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
    DN:Notification("", false)
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
local raidSlotOrgPoint_x = {}
local raidSlotOrgPoint_y = {}
local memberDrag = nil
local thisClass = nil
local swapQueue = {}
local prevQueue = {}
local function resetSwapQueues()
  prevQueue["T"] = 0
  swapQueue["T"] = 0
  prevQueue["H"] = 0
  swapQueue["H"] = 0
end

resetSwapQueues()

local DNARaidScrollFrame = CreateFrame("Frame", DNARaidScrollFrame, page[pages[1][1]], "InsetFrameTemplate")
DNARaidScrollFrame:SetWidth(DNARaidScrollFrame_w+20) --add scroll frame width
DNARaidScrollFrame:SetHeight(DNARaidScrollFrame_h-7)
DNARaidScrollFrame:SetPoint("TOPLEFT", 220, -80)
DNARaidScrollFrame.icon = DNARaidScrollFrame:CreateTexture(nil, "OVERLAY")
DNARaidScrollFrame.icon:SetTexture(DNAGlobal.dir .. "images/role_dps")
DNARaidScrollFrame.icon:SetPoint("TOPLEFT", 35, 20)
DNARaidScrollFrame.icon:SetSize(20, 20)
DNARaidScrollFrame:SetFrameLevel(5)
DNARaidScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNARaidScrollFrame, "UIPanelScrollFrameTemplate")
DNARaidScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNARaidScrollFrame, "TOPLEFT", 3, -3)
DNARaidScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNARaidScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNARaidScrollFrameScrollChildFrame = CreateFrame("Frame", DNARaidScrollFrameScrollChildFrame, DNARaidScrollFrame.ScrollFrame)
DNARaidScrollFrameScrollChildFrame:SetSize(DNARaidScrollFrame_w, DNARaidScrollFrame_h)
DNARaidScrollFrame.text = DNARaidScrollFrame:CreateFontString(nil, "ARTWORK")
DNARaidScrollFrame.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
DNARaidScrollFrame.text:SetPoint("CENTER", DNARaidScrollFrame, "TOPLEFT", 75, 10)
DNARaidScrollFrame.text:SetText("Raid")
DNARaidScrollFrame.ScrollFrame:SetScrollChild(DNARaidScrollFrameScrollChildFrame)
DNARaidScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNARaidScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNARaidScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNARaidScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNARaidScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNARaidScrollFrame.MR = DNARaidScrollFrame:CreateTexture(nil, "BACKGROUND", DNARaidScrollFrame, -2)
DNARaidScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNARaidScrollFrame.MR:SetPoint("TOPLEFT", 135, 0)
DNARaidScrollFrame.MR:SetSize(24, 400)
DNARaidScrollFrame:SetScript("OnEnter", function()
  resetSwapQueues()
end)
DNARaidScrollFrame:SetScript("OnLeave", function()
  resetSwapQueues()
end)

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
    resetSwapQueues()
  end)
  raidSlot[i]:SetScript("OnDragStop", function()
    raidSlot[i]:StopMovingOrSizing()
    raidSlot[i]:SetParent(parentFrame)
    raidSlot[i]:SetPoint("TOPLEFT", raidSlotOrgPoint_x[i], raidSlotOrgPoint_y[i])
    resetSwapQueues()
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
  raidSlot[i].blacklist = raidSlot[i]:CreateTexture(nil, "OVERLAY")
  raidSlot[i].blacklist:SetTexture("")
  raidSlot[i].blacklist:SetPoint("TOPLEFT", DNARaidScrollFrame_w-41, -4)
  raidSlot[i].blacklist:SetSize(12, 12)
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
tankSlotframe:SetHeight((DNASlots.tank*20)+4)
tankSlotframe:SetPoint("TOPLEFT", 400, -80)
tankSlotframe.text = tankSlotframe:CreateFontString(nil, "ARTWORK")
tankSlotframe.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
tankSlotframe.text:SetPoint("CENTER", tankSlotframe, "TOPLEFT", 71, 10)
tankSlotframe.text:SetText("Tanks")
tankSlotframe.icon = tankSlotframe:CreateTexture(nil, "OVERLAY")
tankSlotframe.icon:SetTexture(DNAGlobal.dir .. "images/role_tank")
tankSlotframe.icon:SetPoint("TOPLEFT", 25, 20)
tankSlotframe.icon:SetSize(20, 20)
tankSlotframe:SetFrameLevel(2)
--[==[
tankSlotframe:SetScript('OnLeave', function()
  resetSwapQueues()
end)
]==]--
for i = 1, DNASlots.tank do
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
      resetSwapQueues()
      swapQueue["T"] = i
    end
  end)
  tankSlot[i]:SetScript("OnDragStop", function()
    tankSlot[i]:StopMovingOrSizing()
    tankSlot[i]:SetPoint("TOPLEFT", tankSlotOrgPoint_x[i], tankSlotOrgPoint_y[i])
    if ((swapQueue["T"] > 0) and (prevQueue["T"] > 0)) then --swap positions
      --updateSlotPos("T", i, "Empty")
    else
      updateSlotPos("T", i, "Empty")
      --resetSwapQueues()
    end
  end)
  tankSlot[i]:SetScript('OnEnter', function()
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tankSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
      if (swapQueue["T"] > 0) then
        prevQueue["T"] = i
      end
    end
    if ((swapQueue["T"] > 0) and (prevQueue["T"] > 0)) then --swap positions
      if (swapQueue["T"] ~= prevQueue["T"]) then --dupe check
        if ((tankSlot[swapQueue["T"]].text:GetText() ~= "Empty") and (tankSlot[prevQueue["T"]].text:GetText() ~= "Empty")) then
          updateSlotPos("T", swapQueue["T"], tankSlot[prevQueue["T"]].text:GetText() )
          updateSlotPos("T", prevQueue["T"], tankSlot[swapQueue["T"]].text:GetText() )
        end
        resetSwapQueues()
        memberDrag = nil
      end
    else
      if (memberDrag) then
        for dupe = 1, DNASlots.tank do
          if (tankSlot[dupe].text:GetText() == memberDrag) then
            updateSlotPos("T", dupe, "Empty")
            updateSlotPos("T", i, memberDrag)
            return true --print("DEBUG: duplicate slot")
          end
        end
        updateSlotPos("T", i, memberDrag)
      end
    end
  end)
  tankSlot[i]:SetScript('OnLeave', function()
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tankSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
    end
    memberDrag = nil
  end)
end

local healSlotOrgPoint_x = {}
local healSlotOrgPoint_y = {}
local healSlotframe = CreateFrame("Frame", healSlotframe, page[pages[1][1]], "InsetFrameTemplate")
healSlotframe:SetWidth(DNARaidScrollFrame_w+6)
healSlotframe:SetHeight((DNASlots.heal*20)-2)
healSlotframe:SetPoint("TOPLEFT", 400, -240)
healSlotframe.text = healSlotframe:CreateFontString(nil, "ARTWORK")
healSlotframe.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
healSlotframe.text:SetPoint("CENTER", healSlotframe, "TOPLEFT", 71, 10)
healSlotframe.text:SetText("Healers")
healSlotframe.icon = healSlotframe:CreateTexture(nil, "OVERLAY")
healSlotframe.icon:SetTexture(DNAGlobal.dir .. "images/role_heal")
healSlotframe.icon:SetPoint("TOPLEFT", 20, 20)
healSlotframe.icon:SetSize(20, 20)
healSlotframe:SetFrameLevel(2)
--[==[
healSlotframe:SetScript('OnLeave', function()
  resetSwapQueues()
end)
]==]--
for i = 1, DNASlots.heal do
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
      healSlot[i]:SetFrameStrata("DIALOG")
      resetSwapQueues()
      swapQueue["H"] = i
    end
  end)
  healSlot[i]:SetScript("OnDragStop", function()
    healSlot[i]:StopMovingOrSizing()
    healSlot[i]:SetPoint("TOPLEFT", healSlotOrgPoint_x[i], healSlotOrgPoint_y[i])
    if ((swapQueue["H"] > 0) and (prevQueue["H"] > 0)) then --swap positions
      --updateSlotPos("H", i, "Empty")
    else
      updateSlotPos("H", i, "Empty")
      --resetSwapQueues()
    end
  end)
  healSlot[i]:SetScript('OnEnter', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
      if (swapQueue["H"] > 0) then
        prevQueue["H"] = i
      end
    end
    if ((swapQueue["H"] > 0) and (prevQueue["H"] > 0)) then --swap positions
      if (swapQueue["H"] ~= prevQueue["H"]) then --dupe check
        if ((healSlot[swapQueue["H"]].text:GetText() ~= "Empty") and (healSlot[prevQueue["H"]].text:GetText() ~= "Empty")) then
          updateSlotPos("H", swapQueue["H"], healSlot[prevQueue["H"]].text:GetText() )
          updateSlotPos("H", prevQueue["H"], healSlot[swapQueue["H"]].text:GetText() )
        end
        resetSwapQueues()
        memberDrag = nil
      end
    else
      if (memberDrag) then
        for dupe = 1, DNASlots.heal do
          if (healSlot[dupe].text:GetText() == memberDrag) then
            updateSlotPos("H", dupe, "Empty")
            updateSlotPos("H", i, memberDrag)
            return true --print("DEBUG: duplicate slot")
          end
        end
        updateSlotPos("H", i, memberDrag)
      end
    end
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
DNAFrameView:SetHeight(viewFrame_h-80)
DNAFrameView:SetPoint("TOPLEFT", viewFrame_x+5, -viewFrame_y-20)
DNAFrameView:SetMovable(true)
DNAFrameView.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAFrameView, "UIPanelScrollFrameTemplate")
DNAFrameView.ScrollFrame:SetPoint("TOPLEFT", DNAFrameView, "TOPLEFT", 5, -4)
DNAFrameView.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAFrameView, "BOTTOMRIGHT", 10, 5)
local DNAViewScrollChildFrame = CreateFrame("Frame", nil, DNAFrameView.ScrollFrame)
DNAViewScrollChildFrame:SetSize(viewFrame_w, viewFrame_h)
DNAViewScrollChildFrame.bg = DNAViewScrollChildFrame:CreateTexture(nil, "BACKGROUND")
DNAViewScrollChildFrame.bg:SetAllPoints(true)
--DNAViewScrollChildFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.4)
DNAFrameView.ScrollFrame:SetScrollChild(DNAViewScrollChildFrame)
DNAFrameView.ScrollFrame.ScrollBar:ClearAllPoints()
DNAFrameView.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAFrameView.ScrollFrame, "TOPRIGHT", -150, -16)
DNAFrameView.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAFrameView.ScrollFrame, "BOTTOMRIGHT", 106, 14)
DNAFrameView.MR = DNAFrameView:CreateTexture(nil, "BACKGROUND", DNAFrameView, -1)
DNAFrameView.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAFrameView.MR:SetPoint("TOPLEFT", 354, -2)
DNAFrameView.MR:SetSize(24, 316)

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

DNAFrameViewBossMap = DNAFrameView:CreateTexture(nil, "BACKGROUND")
DNAFrameViewBossMap:SetTexture(DNAGlobal.dir .. "images/mc")
DNAFrameViewBossMap:SetSize(380, 320)
DNAFrameViewBossMap:SetPoint("TOPLEFT", 0, 0)
DNAFrameViewBossMap:Hide()

local DNAFrameClassAssignView = CreateFrame("Frame", nil, page[pages[1][1]], "InsetFrameTemplate")
DNAFrameView:SetWidth(viewFrame_w-20)
DNAFrameView:SetHeight(viewFrame_h-80)
DNAFrameView:SetPoint("TOPLEFT", viewFrame_x+5, -viewFrame_y-20)

local DNAFrameClassAssignEdit={}
function DNAFrameClassAssignTextbox(name, pos_y)
  DNAFrameClassAssignEdit[name] = CreateFrame("EditBox", nil, DNAFrameClassAssignView)
  DNAFrameClassAssignEdit[name]:SetWidth(200)
  DNAFrameClassAssignEdit[name]:SetHeight(24)
  DNAFrameClassAssignEdit[name]:SetFontObject(GameFontNormal)
  DNAFrameClassAssignEdit[name]:SetBackdrop(GameTooltip:GetBackdrop())
  DNAFrameClassAssignEdit[name]:SetBackdropColor(0, 0, 0, 0.8)
  DNAFrameClassAssignEdit[name]:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
  DNAFrameClassAssignEdit[name]:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", -50, 0)
  DNAFrameClassAssignEdit[name]:EnableKeyboard(true)
  DNAFrameClassAssignEdit[name]:ClearFocus(self)
  DNAFrameClassAssignEdit[name]:SetAutoFocus(false)
  --[==[
  DNAFrameClassAssign[name].enter:SetScript("OnEscapePressed", function()
    DNAFrameMain:Hide()
  end)
  ]==]--
end
DNAFrameClassAssignTextbox("Warriors", 20)

local function viewFrameBottomTabToggle(name)
  viewFrameBotTab["Markers"]:SetFrameLevel(2)
  viewFrameBotTab["Markers"].text:SetTextColor(0.7, 0.7, 0.7)
  viewFrameBotTab["Map"]:SetFrameLevel(2)
  viewFrameBotTab["Map"].text:SetTextColor(0.7, 0.7, 0.7)
  viewFrameBotTab["Class"]:SetFrameLevel(2)
  viewFrameBotTab["Class"].text:SetTextColor(0.7, 0.7, 0.7)
  viewFrameBotTab[name]:SetFrameLevel(5)
  viewFrameBotTab[name].text:SetTextColor(1.0, 1.0, 0.5)
  if (name == "Markers") then
    DNAViewScrollChildFrame:Show()
    DNAFrameView.ScrollFrame:Show()
    DNAFrameViewBossMap:Hide()
    DNAFrameClassAssignView:Hide()
  end
  if (name == "Map") then
    DNAViewScrollChildFrame:Hide()
    DNAFrameView.ScrollFrame:Hide()
    DNAFrameViewBossMap:Show()
    DNAFrameClassAssignView:Hide()
  end
  if (name == "Class") then
    DNAViewScrollChildFrame:Hide()
    DNAFrameView.ScrollFrame:Hide()
    DNAFrameViewBossMap:Hide()
    DNAFrameClassAssignView:Hide()
  end
end

local function viewFrameBottomTab(name, pos_x, text_pos_x)
  viewFrameBotTab[name] = CreateFrame("Frame", nil, DNAFrameView)
  viewFrameBotTab[name]:SetPoint("BOTTOMLEFT", pos_x, -44)
  viewFrameBotTab[name]:SetWidth(85)
  viewFrameBotTab[name]:SetHeight(60)
  viewFrameBotTab[name]:SetFrameLevel(2)
  viewFrameBotTab[name].text = viewFrameBotTab[name]:CreateFontString(nil, "ARTWORK")
  viewFrameBotTab[name].text:SetFont(DNAGlobal.font, 11, "OUTLINE")
  viewFrameBotTab[name].text:SetText(name)
  viewFrameBotTab[name].text:SetTextColor(0.8, 0.8, 0.8)
  viewFrameBotTab[name].text:SetPoint("CENTER", viewFrameBotTab[name], "CENTER", 9, 0)
  local viewFrameBotBorder ={}
  viewFrameBotBorder[name] = viewFrameBotTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  viewFrameBotBorder[name]:SetTexture("Interface/PaperDollInfoFrame/UI-CHARACTER-ACTIVETAB")
  viewFrameBotBorder[name]:SetSize(100, 35)
  viewFrameBotBorder[name]:SetPoint("TOPLEFT", 0, -14)
  local viewFrameBotTabScript = {}
  viewFrameBotTabScript[name] = CreateFrame("Button", nil, viewFrameBotTab[name], "UIPanelButtonTemplate")
  viewFrameBotTabScript[name] = CreateFrame("Button", nil, viewFrameBotTab[name])
  viewFrameBotTabScript[name]:SetSize(85, 30)
  viewFrameBotTabScript[name]:SetPoint("CENTER", 0, 0)
  viewFrameBotTabScript[name]:SetScript("OnClick", function()
    viewFrameBottomTabToggle(name)
  end)
end

viewFrameBottomTab("Markers", 10, 0)
viewFrameBottomTab("Map", 100, 0)
viewFrameBottomTab("Class", 190, 0)
viewFrameBottomTabToggle("Markers") --default enabled

for i, v in ipairs(DNAInstance) do
  ddBossList[DNAInstance[i][1]] = CreateFrame("frame", nil, page[pages[1][1]], "UIDropDownMenuTemplate")
  ddBossList[DNAInstance[i][1]]:SetPoint("TOPLEFT", 680, -90)
  ddBossListText[DNAInstance[i][1]] = ddBossList[DNAInstance[i][1]]:CreateFontString(nil, "ARTWORK")
  ddBossListText[DNAInstance[i][1]]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  ddBossListText[DNAInstance[i][1]]:SetPoint("TOPLEFT", ddBossList[DNAInstance[i][1]], "TOPLEFT", 25, -8);
  local instanceNum = multiKeyFromValue(DNAInstance, DNAInstance[i][1])
  ddBossListText[DNAInstance[i][1]]:SetText(DNARaidBosses[instanceNum][1])
  --print("DEBUG: " .. DNARaidBosses[instanceNum][1])
  ddBossList[DNAInstance[i][1]].onClick = function(self, checked)
    ddBossListText[DNAInstance[i][1]]:SetText(self.value)
    clearFrameView()
    raidSelection = self.value
    if (DEBUG) then
      print("DEBUG: ddBossList " .. self.value)
    end
    buildRaidAssignments(self.value, nil, "dropdown")
  end
  ddBossList[DNAInstance[i][1]]:Hide()
  ddBossList[DNAInstance[i][1]].initialize = function(self, level)
  	local info = UIDropDownMenu_CreateInfo()
    for ddKey, ddVal in pairs(DNARaidBosses[instanceNum]) do
      if (ddKey ~= 1) then --remove first key
        info.text = ddVal
      	info.value= ddVal
      	info.func = self.onClick
      	UIDropDownMenu_AddButton(info, level)
      end
    end
  end
  UIDropDownMenu_SetWidth(ddBossList[DNAInstance[i][1]], 160)
end

ddBossListText[DNARaidBosses[1][1]]:SetText("Select a boss")

local largePacket = nil
function DN:RaidSendAssignments()

  if ((total.tanks < 2) or (total.healers < 2)) then
    DN:Notification("Not enough tanks and healers assigned!", true)
    return
  end

  largePacket = "{"
  for i = 1, DNASlots.tank do
    if (tankSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. "T" .. i .. "," .. tankSlot[i].text:GetText() .. "}"
    end
  end
  DN:SendPacket("send", largePacket, true)

  largePacket = "{" --beginning key
  for i = 1, DNASlots.heal do
    if (healSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. "H" .. i .. "," .. healSlot[i].text:GetText() .. "}"
    end
  end
  DN:SendPacket("send", largePacket, true)
end

local btnShare_x = 300
local btnShare_y = DNAGlobal.height-45
local btnShare_t = "Push Assignments"
local btnShare = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonTemplate")
btnShare:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnShare:SetPoint("TOPLEFT", btnShare_x, -btnShare_y)
btnShare.text = btnShare:CreateFontString(nil, "ARTWORK")
btnShare.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
btnShare.text:SetText(btnShare_t)
btnShare.text:SetPoint("CENTER", btnShare)

btnShare:SetScript("OnClick", function()
  if (IsInRaid()) then
    DN:UpdateRaidRoster()
    DN:RaidSendAssignments()
  else
    DN:Notification("You are not in a raid!   [E3]", true)
  end
end)
btnShare:Hide()
local btnShareDis = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonGrayTemplate")
btnShareDis:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnShareDis:SetPoint("TOPLEFT", btnShare_x, -btnShare_y)
btnShareDis.text = btnShareDis:CreateFontString(nil, "ARTWORK")
btnShareDis.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
btnShareDis.text:SetText(btnShare_t)
btnShareDis.text:SetPoint("CENTER", btnShare)
btnShareDis:SetScript("OnClick", function()
  if (IsInRaid()) then
    DN:Notification("You do not have raid permission to modify assignments.   [E4]", true)
  else
    DN:Notification("You are not in a raid!   [E4]", true)
  end
end)

local btnPostRaid_x = DNAGlobal.width-260
local btnPostRaid_y = DNAGlobal.height-45
local btnPostRaid_t = "Post to Raid"
local btnPostRaid = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonTemplate")
btnPostRaid:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnPostRaid:SetPoint("TOPLEFT", btnPostRaid_x, -btnPostRaid_y)
btnPostRaid.text = btnPostRaid:CreateFontString(nil, "ARTWORK")
btnPostRaid.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
btnPostRaid.text:SetText(btnPostRaid_t)
btnPostRaid.text:SetPoint("CENTER", btnPostRaid)
btnPostRaid:SetScript("OnClick", function()
  if (IsInRaid()) then
    DN:RaidSendAssignments()
    if (raidSelection == nil) then
      DNAFrameViewScrollChild_tank[3]:SetText("Please select a boss or trash pack!")
    else
      DN:SendPacket("send", "&" .. raidSelection .. "," .. player.name, true) --openassignments
      DoReadyCheck()
    end
  else
    DN:Notification("You are not in a raid!   [E2]", true)
  end
end)
local btnPostRaidDis = CreateFrame("Button", nil, page[pages[1][1]], "UIPanelButtonGrayTemplate")
btnPostRaidDis:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnPostRaidDis:SetPoint("TOPLEFT", btnPostRaid_x, -btnPostRaid_y)
btnPostRaidDis.text = btnPostRaidDis:CreateFontString(nil, "ARTWORK")
btnPostRaidDis.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
btnPostRaidDis.text:SetText(btnPostRaid_t)
btnPostRaidDis.text:SetPoint("CENTER", btnPostRaid)
btnPostRaidDis:SetScript("OnClick", function()
  if (IsInRaid()) then
    DN:Notification("You do not have raid permission to modify assignments.   [E3]", true)
  else
    DN:Notification("You are not in a raid!   [E3]", true)
  end
end)
-- EO PAGE ASSIGN

for i,v in pairs(pages) do
  bottomTab(pages[i][1], pages[i][2])
end

--default selection after drawn
bottomTabToggle(pages[1][1])
ddBossList[DNAInstance[1][1]]:Show() -- show first one

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
  DN:Notification("", false)
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
  resetSwapQueues() --sanity check on queues
  DNAFrameMain:Hide()
end

local function DNAOpenWindow()
  DNAFrameMain:Show()
  --DNAFrameAssign:Show()
  memberDrag = nil --bugfix
  DN:UpdateRaidRoster()
  DN:SetVars()
  raidPermissions()
  raidDetails()
end

SlashCmdList["DNA"] = function(msg)
  DNAOpenWindow()
end

--[==[
DNAFrameMainOpen:SetScript("OnClick", function()
  DNAOpenWindow()
end)
]==]--

DNAMiniMap = CreateFrame("Button", nil, Minimap)
DNAMiniMap:SetFrameLevel(50)
DNAMiniMap:SetSize(28, 28)
DNAMiniMap:SetMovable(true)
DNAMiniMap:SetNormalTexture(DNAGlobal.dir .. "images/icon_dn")
DNAMiniMap:SetPushedTexture(DNAGlobal.dir .. "images/icon_dn")
DNAMiniMap:SetHighlightTexture(DNAGlobal.dir .. "images/icon_dn")

local myIconPos = 40

local function UpdateMapButton()
  local Xpoa, Ypoa = GetCursorPosition()
  local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
  Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
  Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
  myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
  DNAMiniMap:ClearAllPoints()
  DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 62 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 56)
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
    if (DEBUG) then
      print(math.ceil(xOfs) .. "," .. math.ceil(yOfs))
    end
    DNA[player.combine]["CONFIG"]["ICONPOS"] = math.ceil(xOfs) .. "," .. math.ceil(yOfs)
    UpdateMapButton()
end)
DNAMiniMap:ClearAllPoints()
DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 62 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 56)
DNAMiniMap:SetScript("OnClick", function()
  DNAOpenWindow()
end)
