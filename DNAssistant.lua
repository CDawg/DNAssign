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

local packet={}

local raidSlot={}
local raidSlot_h=20
local tankSlot={}
local healSlot={}
local tankSlotFrame={}
local healSlotFrame={}
local healSlotUp={}
local healSlotDown={}
local tankSlotFrameClear={}
local healSlotFrameClear={}
local DNAFrameMainAuthor={}

local raidSelection = nil

local DNAFrameMainBottomTab={}

local viewFrameBotTab={}

local page={}
local pageBanner={}
local pageBossIcon={}

local DNAMiniMap={}

local pageDKPView={}
local pageDKPViewScrollChild_colOne={}
local pageDKPViewScrollChild_colTwo={}
local pageDKPViewScrollChild_colThree= {}

local version_checked = 0

local ddSelection = nil

--local pageTab={}
local ddBossList={}
local ddBossListText={}
local DNAFrameInstance={}
local DNAFrameInstanceText={}
local DNAFrameInstanceScript={}
local DNAFrameInstanceGlow={}

local DNAFrameView={}
local DNAFrameViewBG={}

local DNAFrameClassAssignEdit={}
--local DNAFrameClassAssignHidden={}

local pageRaidDetailsColOne={}
local pageRaidDetailsColTwo={}

local DNAFrameAssignTabIcon={}
local DNAFrameAssignMapGroupID={}

local DNAFrameAssignPersonal_w = 320 --MIN WIDTH, length may depend on the string length
local DNAFrameAssignPersonal_h = 80

local invited={}

local function getGuildComp()
  if (IsInGuild()) then
    local numTotalMembers, numOnlineMaxLevelMembers, numOnlineMembers = GetNumGuildMembers()
    for i=1, numTotalMembers do
      local name, rank, rankIndex, level, class, zone = GetGuildRosterInfo(i)
      local filterRealm = string.match(name, "(.*)-")
      DNAGuild["member"] = filterRealm
      DNAGuild["rank"][filterRealm] = rank
      --debug(filterRealm .. " = " .. rank)
    end
    debug("getGuildComp()")
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
          debug(name .. " has joined")
          if (DNARaid["assist"][player.name] == 1) then
            if (player.name ~= name) then --dont promote self
              if (IsInGuild()) then
                if (DNAGuild["rank"][name] ~= nil) then --no guild rank or permission
                  if ((DNAGuild["rank"][name] == "Officer") or ((DNAGuild["rank"][name] == "Alt Officer"))) then
                    if (DNARaid["assist"][name] ~= 1) then --has not been promoted yet
                      if (UnitIsGroupAssistant(name) == false) then
                        if (DNACheckbox["AUTOPROMOTE"]:GetChecked()) then
                          DN:PromoteToAssistant(name)
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

  if (DEBUG) then
    buildDebugRaid() --fake raid
    debug("getRaidComp() total:" .. total.raid)
  end
end

local windowOpen = false

local swapQueue={}
local prevQueue={}
local function resetSwapQueues()
  prevQueue[TANK] = 0
  swapQueue[TANK] = 0
  prevQueue[HEAL] = 0
  swapQueue[HEAL] = 0
  debug("resetSwapQueues()")
end

local function DNACloseWindow()
  resetSwapQueues() --sanity check on queues
  DNAFrameMain:Hide()
  windowOpen = false
  PlaySound(88)
end

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
local DNARaidMemberSorted={}
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
      tankSlotFrameClear:Show()
      remove_slot = singleKeyFromValue(DNARaid["member"], tankSlot[i].text:GetText())
      if (DNARaid["member"][remove_slot] == tankSlot[i].text:GetText()) then
        DNARaid["member"][remove_slot] = nil
      end
    end
  end

  for i = 1, DNASlots.heal do
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

  --rebuild the roster and alphabetize
  for k,v in pairs(DNARaid["member"]) do
    table.insert(DNARaidMemberSorted, v)
  end
  table.sort(DNARaidMemberSorted)
  for k,v in ipairs(DNARaidMemberSorted) do
    --set text, get class color for each raid slot built
    if (v ~= nil) then
      raidSlot[k].text:SetText(v)
      raidSlot[k]:Show()
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

  total.raid = total.warriors + total.druids + total.priests + total.mages + total.warlocks + total.hunters + total.rogues + total.paladins + total.shamans
  total.melee = total.warriors + total.rogues + total.druids
  total.range = total.hunters + total.mages + total.warlocks
  debug("DN:UpdateRaidRoster()")
end

local function clearFrameView()
  for i = 1, MAX_FRAME_LINES do
    DNAFrameViewScrollChild_mark[i]:SetTexture("")
    DNAFrameViewScrollChild_tank[i]:SetText("")
    DNAFrameViewScrollChild_heal[i]:SetText("")
  end
  debug("clearFrameView()")
end

local function clearFrameAssign()
  for i = 1, MAX_FRAME_LINES do
    DNAFrameAssignScrollChild_mark[i]:SetTexture("")
    DNAFrameAssignScrollChild_tank[i]:SetText("")
    DNAFrameAssignScrollChild_heal[i]:SetText("")
  end
  debug("clearFrameAssign()")
end

local function clearFrameClassAssign()
  for i, v in ipairs(DNAClasses) do
    DNAFrameClassAssignEdit[v]:SetText("")
  end
end

local function clearFrameAssignPersonal()
  DNAFrameAssignPersonalMark:SetTexture("")
  DNAFrameAssignPersonalColOne:SetText("")
  DNAFrameAssignPersonalColTwo:SetText("")
  DNAFrameAssignPersonalClass:SetText("")
  --reset the window positioning, similar to a chat bubble
  DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w) --default
  DNAFrameAssignPersonal.header:SetWidth(DNAFrameAssignPersonal:GetWidth())
  DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-24, 4)
end

local function InstanceButtonToggle(name, icon)
  local instanceNum = multiKeyFromValue(DNAInstance, name)
  for i, v in ipairs(DNAInstance) do
    DNAFrameInstance[DNAInstance[i][1]]:SetBackdrop({
      bgFile = DNAInstance[i][5],
      edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
      edgeSize = 14,
      insets = {left=0, right=-66, top=0, bottom=-28},
    })
    DNAFrameInstance[DNAInstance[i][1]]:SetBackdropBorderColor(1, 1, 1, 1)
    DNAFrameInstanceGlow[DNAInstance[i][1]]:Hide()
  end
  DNAFrameInstance[name]:SetBackdrop({
    bgFile = icon,
    edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize = 14,
    insets = {left=0, right=-66, top=0, bottom=-28},
  })
  DNAFrameInstance[name]:SetBackdropBorderColor(1, 1, 0.40, 1)
  DNAFrameInstanceGlow[name]:Show()
  pageBanner:SetTexture(DNAInstance[instanceNum][3])
  pageBanner.text:SetText(DNAInstance[instanceNum][2])
  pageBossIcon:SetTexture(DNAInstance[instanceNum][4])
  DNAFrameViewBG:SetTexture(DNAInstance[instanceNum][6])
  DNAFrameViewBossMap:SetTexture(DNAInstance[instanceNum][7])
  DNAFrameAssignBossMap:SetTexture(DNAInstance[instanceNum][7])
  clearFrameClassAssign()
  PlaySound(844)
  debug("InstanceButtonToggle()")
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
  debug("packet.role " .. packet.role)
  debug("packet.slot " .. packet.slot)
  debug("packet.name " .. packet.name)
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
      tankSlot[packet.slot]:SetFrameLevel(4)
      tankSlot[packet.slot]:SetBackdropColor(1, 1, 1, 0.6)
      tankSlot[packet.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
      thisClass = DNARaid["class"][packet.name]
      DN:ClassColorText(tankSlot[packet.slot].text, thisClass)
      --DN:PromoteToAssistant(packet.name)
      --SetPartyAssignment("MAINTANK", packet.name, 1)
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
DNAFrameAssignPersonal.headerText:SetText(player.name .. "'s Assignment         DNA v" .. DNAGlobal.version)
DNAFrameAssignPersonal.headerText:SetTextColor(1, 1, 0.4)
DNAFrameAssignPersonal.close = CreateFrame("Button", nil, DNAFrameAssignPersonal)
DNAFrameAssignPersonal.close:SetWidth(25)
DNAFrameAssignPersonal.close:SetHeight(25)
DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-14, 4)
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
DNAFrameAssignPersonalMark:SetPoint("TOPLEFT", 6, -22)
DNAFrameAssignPersonalMark:SetTexture("")
DNAFrameAssignPersonalColOne = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalColOne:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignPersonalColOne:SetPoint("TOPLEFT", 25, -25)
DNAFrameAssignPersonalColOne:SetText("")
DNAFrameAssignPersonalColTwo = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalColTwo:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignPersonalColTwo:SetPoint("TOPLEFT", 125, -25)
DNAFrameAssignPersonalColTwo:SetText("")
DNAFrameAssignPersonalClass = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalClass:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignPersonalClass:SetPoint("TOPLEFT", 20, -50)
DNAFrameAssignPersonalClass:SetText("")

--hack, have to create a frame due to the tab clipping over
local DNAFrameAssignBossMapFrame = CreateFrame("Frame", nil, DNAFrameAssignPage["map"], "InsetFrameTemplate")
DNAFrameAssignBossMapFrame:SetSize(384, 301)
DNAFrameAssignBossMapFrame:SetPoint("TOPLEFT", 8, -20)
DNAFrameAssignBossMapFrame:SetFrameStrata("DIALOG")
DNAFrameAssignBossMapFrame:SetFrameLevel(200)

DNAFrameAssignBossMap = DNAFrameAssignBossMapFrame:CreateTexture(nil, "OVERLAY", DNAFrameAssignBossMapFrame)
DNAFrameAssignBossMap:SetSize(384, 300)
DNAFrameAssignBossMap:SetPoint("TOPLEFT", 0, 0)
DNAFrameAssignBossMap:SetTexture("")
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
DNAFrameAssign.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAFrameAssignPage["assign"], "BOTTOMRIGHT", -25, 85)
local DNAFrameAssignScrollChild = CreateFrame("Frame", nil, DNAFrameAssign.ScrollFrame)
DNAFrameAssignScrollChild:SetSize(DNAFrameAssign_w-40, DNAFrameAssign_h-80)
DNAFrameAssign.ScrollFrame:SetScrollChild(DNAFrameAssignScrollChild)
DNAFrameAssign.ScrollFrame.ScrollBar:ClearAllPoints()
DNAFrameAssign.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAFrameAssign.ScrollFrame, "TOPRIGHT", -175, -15)
DNAFrameAssign.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAFrameAssign.ScrollFrame, "BOTTOMRIGHT", 160, 14)
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
for i = 1, MAX_FRAME_LINES do
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
  local getCode = multiKeyFromValue(netCode, "readyyes")
  DN:SendPacket(netCode[getCode][2] .. player.name, true)
  DNAFrameAssign:Hide()
  print("|cfffaff04You have marked yourself as Ready.")
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
  local getCode = multiKeyFromValue(netCode, "readyno")
  DN:SendPacket(netCode[getCode][2] .. player.name, true)
  DNAFrameAssign:Hide()
end)
DNAFrameAssignAuthor = DNAFrameAssign:CreateFontString(nil, "ARTWORK")
DNAFrameAssignAuthor:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameAssignAuthor:SetText("")
DNAFrameAssignAuthor:SetPoint("CENTER", 0, -205)
DNAFrameAssignAuthor:SetTextColor(1, 1, 1)

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

DN:ChatNotification("v" .. DNAGlobal.version .. " Initializing...")

-- BUILD THE RAID PER BOSS
local function buildRaidAssignments(packet, author, source)
  local assign = packet
  local tank={}
  tank.main={}
  tank.banish={}
  tank.all={}
  local heal={}
  local healer={}
  healer.all={}
  healer.priest={}
  healer.paladin={}
  healer.shaman={}
  healer.druid ={}
  healer.nodruid ={}
  local boss=""
  local mark={}
  local text={}
  local NUM_ADDS = 0
  local raid={}
  raid.warrior={}
  raid.warrior_dps={}
  raid.mage={}
  raid.paladin={}
  raid.paladin_dps={}
  raid.shaman={}
  raid.shaman_dps={}
  raid.hunter={}
  raid.rogue={}
  raid.warlock={}
  raid.priest={}
  raid.priest_dps={}
  raid.druid={}
  raid.druid_dps={}
  raid.fearward={}
  local locked_assignments={}
  locked_assignments[player.name] = 0

  debug("buildRaidAssignments()")

  clearNotifications()
  DN:UpdateRaidRoster()
  clearFrameView() --clear out the current text
  clearFrameAssign()
  clearFrameAssignPersonal()
  DNAFrameAssignPersonal:Hide()

  if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
    tankSlotFrameClear:Show()
    healSlotFrameClear:Show()
  else
    for i = 1, DNASlots.heal do
      healSlotUp[i]:Hide()
      healSlotDown[i]:Hide()
    end
    tankSlotFrameClear:Hide()
    healSlotFrameClear:Hide()
  end

  if (total.raid < 12) then
    --DNAFrameViewScrollChild_mark[3]:SetTexture("Interface/DialogFrame/UI-Dialog-Icon-AlertNew")
    --DNAFrameViewScrollChild_tank[3]:SetText("Not enough raid members to form assignments!")
    DN:Notification("Not enough raid members to form assignments!", true)
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
      if (DNARaid["class"][healer.all[i]] == "Shaman") then
        table.insert(healer.shaman, healer.all[i])
      end
    end
  end

  --include warriors as OT for the first prio
  for k,v in pairs(DNARaid["class"]) do
    if (v == "Warrior") then
      if (tContains(tank.main, k) == false) then
        table.insert(raid.warrior_dps, k) -- exclude tanks
      end
      table.insert(raid.warrior, k)
    end
    if (v == "Paladin") then
      if ((tContains(tank.main, k) == false) and (tContains(healer.all, k) == false)) then
        table.insert(raid.paladin_dps, k) --exclude tanks/healers
      end
      table.insert(raid.paladin, k)
    end
    if (v == "Druid") then
      if ((tContains(tank.main, k) == false) and (tContains(healer.all, k) == false)) then
        table.insert(raid.druid_dps, k) -- exclude tanks/healers
      end
      table.insert(raid.druid, k)
    end
    if (v == "Shaman") then
      if (tContains(healer.all, k) == false) then
        table.insert(raid.shaman_dps, k) -- exclude healers
      end
      table.insert(raid.shaman, k)
    end
    if (v == "Priest") then
      if (tContains(healer.all, k) == false) then
        table.insert(raid.priest_dps, k) -- exclude healers
      end
      table.insert(raid.priest, k)
    end
    if (v == "Rogue") then
      table.insert(raid.rogue, k)
    end
    if (v == "Warlock") then
      table.insert(raid.warlock, k)
    end
    if (v == "Hunter") then
      table.insert(raid.hunter, k)
      --table.sort()
    end
    if (v == "Mage") then
      table.insert(raid.mage, k)
    end
  end

  if ((total.tanks < 2) or (total.healers < 8)) then
    DN:Notification("Not enough tanks and healers assigned!     [L1]", true)
    DNABossMap = ""
    return
  end

  --fear warders
  local num_fearwards = 0
  for i = 1, MAX_RAID_MEMBERS do
    if ((DNARaid["class"][raid.priest[i]] == "Priest") and (DNARaid["race"][raid.priest[i]] == "Dwarf")) then
      num_fearwards = num_fearwards +1
      raid.fearward[num_fearwards] = raid.priest[i]
    end
  end

  --sort alpha, not by key
  table.sort(raid.warrior)
  table.sort(raid.warrior_dps)
  table.sort(raid.mage)
  table.sort(raid.paladin)
  table.sort(raid.paladin_dps)
  table.sort(raid.shaman)
  table.sort(raid.shaman_dps)
  table.sort(raid.hunter)
  table.sort(raid.rogue)
  table.sort(raid.warlock)
  table.sort(raid.priest)
  table.sort(raid.priest_dps)
  table.sort(raid.druid)
  table.sort(raid.druid_dps)
  table.sort(raid.fearward)

  --sort before building the raid assignments
  table.merge(tank.all, tank.main)
  table.merge(tank.all, raid.warrior_dps)
  table.merge(tank.banish, raid.warlock)
  table.merge(tank.banish, raid.warrior_dps) -- merge all tanks with warlocks
  table.merge(healer.nodruid, healer.priest)
  table.merge(healer.nodruid, healer.paladin)
  table.merge(healer.nodruid, healer.shaman)

  DNAInstanceMC(assign, total, raid, mark, text, heal, tank, healer)
  DNAInstanceBWL(assign, total, raid, mark, text, heal, tank, healer)
  DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer)

  for i=1, MAX_FRAME_LINES do
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
      if (locked_assignments[player.name] ~= 1) then
        if (mark[i]) then --pull mark
          DNAFrameAssignPersonalMark:SetTexture(mark[i])
        end
        if (text[i]) then --pull tank to see who we are healing
          DNAFrameAssignPersonalColOne:SetText(text[i])
          DN:ClassColorText(DNAFrameAssignPersonalColOne, DNARaid["class"][text[i]])
        end
        locked_assignments[player.name] = 1
        DNAFrameAssignPersonal:Show()
      end
    end

    if (heal[i]) then
      local filterHealer={}
      healer_row = split(heal[i], ",")
      filterHealer[i] = string.gsub(heal[i], ',', " / ")
      filter_row = ""
      for n=1, table.getn(healer_row) do
        --debug("DEBUG :" .. healer_row[n])
        if (n > 1) then
          filter_row = filter_row .. " / " .. DN:ClassColorAppend(healer_row[n], DNARaid["class"][healer_row[n]])
        else
          filter_row = DN:ClassColorAppend(healer_row[n], DNARaid["class"][healer_row[n]])
        end
        if (healer_row[n] == player.name) then
          if (locked_assignments[player.name] ~= 1) then
            if (mark[i]) then --pull mark
              DNAFrameAssignPersonalMark:SetTexture(mark[i])
            end
            if (text[i]) then --pull tank to see who we are healing
              DNAFrameAssignPersonalColOne:SetText(text[i])
              DN:ClassColorText(DNAFrameAssignPersonalColOne, DNARaid["class"][text[i]])
            end
            DNAFrameAssignPersonalColTwo:SetText(filter_row)
            locked_assignments[player.name] = 1
            DNAFrameAssignPersonal:Show()
            debug("Personal Window Width " .. string.len(filter_row)) --increase the width of the window
            if (string.len(filter_row) > 40) then
              DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w + string.len(filter_row)+40)
              DNAFrameAssignPersonal.header:SetWidth(DNAFrameAssignPersonal:GetWidth())
              DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-24, 4)
            end
          end
        end
      end
      DNAFrameViewScrollChild_heal[i]:SetText(filter_row)
      DNAFrameAssignScrollChild_heal[i]:SetText(filter_row)
    end
  end

  --class notes
  local my_class = DNARaid["class"][player.name]
  if (my_class) then
    local class_message = DNAFrameClassAssignEdit[my_class]:GetText()
    if (class_message ~= "") then
      class_message = string.gsub(class_message, "%.", "\n") --ad a carriage return?
      local max_class_message_length = class_message:sub(1, 80)
      if (string.len(max_class_message_length)) then
        DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w + string.len(max_class_message_length)*3)
        DNAFrameAssignPersonal.header:SetWidth(DNAFrameAssignPersonal:GetWidth())
        DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-24, 4)
      end
      DNAFrameAssignPersonalClass:SetText(my_class .. "'s: " .. max_class_message_length)
      DN:ClassColorText(DNAFrameAssignPersonalClass, my_class)
      DNAFrameAssignPersonal:Show()
    end
  end

  if (source == "network") then
    if (DNACheckbox["RAIDCHAT"]:GetChecked()) then
      for i=1, MAX_FRAME_LINES do
        local this_key = 0
        local text_line = ""
        if (text[i]) then
          text[i] = string.gsub(text[i], note_color, "")
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
          if (author == player.name) then
            SendChatMessage(text_line, "RAID", nil, "RAID")
          end
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
      --DNAFrameAssignMapGroupID:SetText("You are a " .. DNARaid["class"][player.name])
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

  pageRaidDetailsColOne[9]:SetText("Shamans")
  DN:ClassColorText(pageRaidDetailsColOne[9], "Shaman")
  pageRaidDetailsColTwo[9]:SetText(total.shamans)

  --[==[
  pageRaidDetailsColOne[10]:SetText("Total Range")
  pageRaidDetailsColTwo[10]:SetText(total.range)
  pageRaidDetailsColOne[11]:SetText("Total Melee")
  pageRaidDetailsColTwo[11]:SetText(total.melee)
  ]==]--

  pageRaidDetailsColOne[10]:SetText("Total")
  pageRaidDetailsColTwo[10]:SetText(total.raid)
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
DNAMain:RegisterEvent("PLAYER_LEAVE_COMBAT")
DNAMain:RegisterEvent("PLAYER_REGEN_ENABLED")
DNAMain:RegisterEvent("PLAYER_REGEN_DISABLED")
--DNAMain:RegisterEvent("PARTY_INVITE_REQUEST")
DNAMain:RegisterEvent("CHAT_MSG_LOOT")

DNAMain:SetScript("OnEvent", function(self, event, prefix, netpacket)
  if ((event == "ADDON_LOADED") and (prefix == "DNA")) then
    DN:BuildGlobalVars()
    debug(event)
  end

  if (event == "PLAYER_LOGIN") then
    DN:BuildGlobalVars()
    DN:ProfileSaves()
    debug(event)
  end

  --[==[
  if (event == "CHAT_MSG_LOOT") then
    loot_msg = string.match(prefix, "item[%-?%d:]+")
    --local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(loot_msg)
    --DN:SendPacket("_" .. player.name .. "," .. itemName, false)
    --safeter to store by the odd string for the itemID
    local inInstance, instanceType = IsInInstance()
    if (inInstance) then
      if (instanceType == "Raid") then
        local instanceName = GetInstanceInfo()
        if (instanceName) then
          DN:SendPacket("_" .. instanceName .. "," .. player.name .. "," .. loot_msg, false)
        end
      end
    end
  end
  ]==]--

  if (event == "GROUP_ROSTER_UPDATE") then
    DN:UpdateRaidRoster()
  end

  if (event== "PLAYER_REGEN_DISABLED") then --entered combat
    raidReadyClear()
    debug("Entered Combat!")
  end
  if (event == "PLAYER_REGEN_ENABLED") then --left combat
    if (DNACheckbox["HIDEASSIGNCOMBAT"]:GetChecked()) then
      DNAFrameAssignPersonal:Hide()
      debug("Left Combat!")
    end
  end

  if (event == "CHAT_MSG_ADDON") then
    if (prefix == DNAGlobal.prefix) then
      debug("Reading netpacket " .. netpacket)

      --parse incoming large packet chunk
      if (string.sub(netpacket, 1, 1) == "{") then
        netpacket = netpacket .. "EOL"
        netpacket = string.gsub(netpacket, '}EOL', "")
        local filteredPacket={}
        packetChunk = split(netpacket, "}")
        for x=1, table.getn(packetChunk) do
          filteredPacket[x] = string.gsub(packetChunk[x], "{", "")
          parsePacket(packet, filteredPacket[x])
        end
         raidReadyClear()
        return true
      end

      local hasClassAssigns = false

      --class notes
      for i,v in ipairs(DNAClasses) do
        local getCode = multiKeyFromValue(netCode, v)
        if (getCode) then
          if (string.sub(netpacket, 1, strlen(netCode[getCode][2])) == netCode[getCode][2]) then
            netpacket = string.gsub(netpacket, netCode[getCode][2], "")
            DNAFrameClassAssignEdit[v]:SetText(netpacket)
            hasClassAssigns = true
          end
        end
      end

      local getCode = multiKeyFromValue(netCode, "author")
      if (getCode) then
        if (string.sub(netpacket, 1, strlen(netCode[getCode][2])) == netCode[getCode][2]) then
          netpacket = string.gsub(netpacket, netCode[getCode][2], "")
          if (netpacket) then
            DNAFrameMainAuthor:SetText("Last Update: " .. netpacket)
            DNAFrameMainAuthor:Show()
          end
          return true
        end
      end

      local getCode = multiKeyFromValue(netCode, "posttoraid")
      if (getCode) then
        if (string.sub(netpacket, 1, strlen(netCode[getCode][2])) == netCode[getCode][2]) then
          netpacket = string.gsub(netpacket, netCode[getCode][2], "")
          local raid_assignment = split(netpacket, ",")
          debug(raid_assignment[1])
          debug(raid_assignment[2])
          buildRaidAssignments(raid_assignment[1], raid_assignment[2], "network")
          DNAFrameAssign:Show()
          raidReadyClear()
          return true
        end
      end

      if (hasClassAssigns) then
        return true
      end

      local getCode = multiKeyFromValue(netCode, "version")
      if (getCode) then
        if (string.sub(netpacket, 1, strlen(netCode[getCode][2])) == netCode[getCode][2]) then
          netpacket = string.gsub(netpacket, netCode[getCode][2], "")
            if (DNAGlobal.version < netpacket) then
              DN:ChatNotification("|cffff0000 You have an outdated version!\nCurrent version is " .. netpacket)
              version_checked = tonumber(netpacket)
            end
          return true
        end
      end
      --READYCHECK
      local getCode = multiKeyFromValue(netCode, "readyyes")
      if (getCode) then
        if (string.sub(netpacket, 1, strlen(netCode[getCode][2])) == netCode[getCode][2]) then
          netpacket = string.gsub(netpacket, netCode[getCode][2], "")
          raidReadyMember(netpacket, true)
          clearFrameClassAssign()
          return true
        end
      end
      --NOT READY
      local getCode = multiKeyFromValue(netCode, "readyno")
      if (getCode) then
        if (string.sub(netpacket, 1, strlen(netCode[getCode][2])) == netCode[getCode][2]) then
          netpacket = string.gsub(netpacket, netCode[getCode][2], "")
          raidReadyMember(netpacket, false)
          clearFrameClassAssign()
          return true
        end
      end

      --LOOT
      --[==[
      if (string.sub(netpacket, 1, 1) == "_") then
        if (DNA[player.combine]["LOOTLOG"][date_day] == nil) then
          DNA[player.combine]["LOOTLOG"][date_day]={}
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
        table.insert(DNA[player.combine]["LOOTLOG"][date_day], {netpacket .. "," .. timestamp})
        return true
      end

      if (string.sub(netpacket, 1, 1) == "@") then --DKP
        netpacket = string.gsub(netpacket, "@", "")
        --DNAFrameAssign:Show()
        --debug("DKP Pushed: " .. netpacket)
        packetChunk = split(netpacket, "}")
        packetLength= strlen(netpacket)
        --debug(packetLength)
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
      ]==]--

      --single slot update, parse individual packets
      parsePacket(packet, netpacket)
    end
  end
end)

SLASH_DNA1 = "/dna"
function SlashCmdList.DNA(msg)
  debug(msg)
end

--build the cached array
getRaidComp()

local minimapIconPos={}

function DN:ProfileSaves()
  local getsave={}
  for k,v in pairs(DNA[player.combine]["ASSIGN"]) do
    getsave.key = k
    getsave.role = string.gsub(k, "[^a-zA-Z]", "") --remove numbers
    getsave.slot = string.gsub(k, getsave.role, "")
    getsave.slot = tonumber(getsave.slot)
    getsave.name = v

    if (getsave.role == TANK) then
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
    if (getsave.role == HEAL) then
      if ((getsave.name == nil) or (getsave.name == "Empty")) then
        healSlot[getsave.slot].text:SetText("Empty")
        healSlot[getsave.slot]:SetFrameLevel(2)
        healSlot[getsave.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        healSlot[getsave.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(healSlot[getsave.slot].text, "Empty")
        healSlotUp[getsave.slot]:Hide()
        healSlotDown[getsave.slot]:Hide()
      else
        healSlot[getsave.slot].text:SetText(getsave.name)
        healSlot[getsave.slot]:SetFrameLevel(3)
        healSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        healSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(healSlot[getsave.slot].text, thisClass)
        if (IsInRaid()) then
          if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
            healSlotUp[getsave.slot]:Show()
            healSlotDown[getsave.slot]:Show()
          end
        end
      end
    end
    healSlotUp[1]:Hide()
    healSlotDown[DNASlots.heal]:Hide()

    if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
      if (IsInRaid()) then
        tankSlotFrameClear:Show()
        healSlotFrameClear:Show()
      end
    else
      for i = 1, DNASlots.heal do
        healSlotUp[i]:Hide()
        healSlotDown[i]:Hide()
      end
      tankSlotFrameClear:Hide()
      healSlotFrameClear:Hide()
    end
  end

  if (DNA[player.combine]["CONFIG"]["AUTOPROMOTE"] == "ON") then
    DNACheckbox["AUTOPROMOTE"]:SetChecked(true)
  end

  if (DNA[player.combine]["CONFIG"]["HIDEASSIGNCOMBAT"] == "ON") then
    DNACheckbox["HIDEASSIGNCOMBAT"]:SetChecked(true)
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

  if (DNA[player.combine]["CONFIG"]["ICONPOS"]) then
    minimapIconPos = split(DNA[player.combine]["CONFIG"]["ICONPOS"], ",")
    if ((minimapIconPos[1]) and (minimapIconPos[2])) then
      DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", minimapIconPos[1]+130, minimapIconPos[2]+22)
    end
  end

  if (DNA[player.combine]["CONFIG"]["RAIDCHAT"] == "ON") then
    DNACheckbox["RAIDCHAT"]:SetChecked(true)
  end

  if (DNA[player.combine]["CONFIG"]["RAID"]) then
    local instanceNum = multiKeyFromValue(DNAInstance, DNA[player.combine]["CONFIG"]["RAID"])
    InstanceButtonToggle(DNAInstance[instanceNum][1], DNAInstance[instanceNum][5])
    for i, v in ipairs(DNAInstance) do
      ddBossList[DNAInstance[i][1]]:Hide()
      --ddBossListText[DNAInstance[i][1]]:SetText("Select a boss")
      DN:Notification("Please select a boss or trash pack!          [E8]", true)
    end
    ddBossList[DNAInstance[instanceNum][1]]:Show()
  end
end

DNAFrameMain = CreateFrame("Frame", "DNAFrameMain", UIParent)
DNAFrameMain:SetWidth(DNAGlobal.width)
DNAFrameMain:SetHeight(DNAGlobal.height)
DNAFrameMain:SetPoint("CENTER", 20, 40)
DNAFrameMain.title = CreateFrame("Frame", nil, DNAFrameMain)
DNAFrameMain.title:SetWidth(DNAGlobal.width)
DNAFrameMain.title:SetHeight(34)
DNAFrameMain.title:SetPoint("TOPLEFT", 0, 5)
DNAFrameMain.title:SetFrameLevel(3)
DNAFrameMain.title:SetBackdrop({
  bgFile = DNAGlobal.background,
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 26,
  tile = true,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNAFrameMain.title:SetBackdropColor(0.5, 0.5, 0.5)
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
  DNACloseWindow()
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
--[==[
DNAFrameMain.enter:SetScript("OnEscapePressed", function()
  DNACloseWindow()
end)
]==]--

page["Assignment"] = CreateFrame("Frame", nil, DNAFrameMain)
page["Assignment"]:SetWidth(DNAGlobal.width)
page["Assignment"]:SetHeight(DNAGlobal.height)
page["Assignment"]:SetPoint("TOPLEFT", 0, 0)

local pageAssignBtnDiv={}
for i=1, 5 do
  pageAssignBtnDiv[i] = page["Assignment"]:CreateTexture(nil, "ARTWORK", page["Assignment"], 3)
  pageAssignBtnDiv[i]:SetTexture("Interface/DialogFrame/UI-DialogBox-Divider")
  pageAssignBtnDiv[i]:SetSize(256, 20)
  pageAssignBtnDiv[i]:SetPoint("TOPLEFT", 6, i*100-622)
end

local pageAssignRightDiv = page["Assignment"]:CreateTexture(nil, "ARTWORK")
pageAssignRightDiv:SetTexture("Interface/FrameGeneral/!UI-Frame")
pageAssignRightDiv:SetSize(12, DNAGlobal.height-28)
pageAssignRightDiv:SetPoint("TOPLEFT", 566, -21)

pageBanner = page["Assignment"]:CreateTexture(nil, "BACKGROUND", page["Assignment"], 0)
pageBanner:SetTexture(DNAInstance[1][3]) --default
pageBanner:SetTexCoord(0, 1, 0.25, 0.50)
pageBanner:SetSize(400, 54)
pageBanner:SetPoint("TOPLEFT", 570, -28)
local pageBannerBorder = page["Assignment"]:CreateTexture(nil, "BACKGROUND", page["Assignment"], 1)
pageBannerBorder:SetTexture("Interface/ACHIEVEMENTFRAME/UI-Achievement-MetalBorder-Top")
pageBannerBorder:SetSize(452, 14)
pageBannerBorder:SetPoint("TOPLEFT", 570, -75)
pageBanner.text = page["Assignment"]:CreateFontString(nil, "ARTWORK")
pageBanner.text:SetFont("Fonts/MORPHEUS.ttf", 18, "OUTLINE")
pageBanner.text:SetText(DNAInstance[1][2]) --default
pageBanner.text:SetTextColor(1.00, 1.00, 0.60)
pageBanner.text:SetPoint("TOPLEFT", pageBanner, "TOPLEFT", 20, -8)
pageBossIcon = page["Assignment"]:CreateTexture(nil, "ARTWORK")
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

page["Raid Builder"] = CreateFrame("Frame", nil, DNAFrameMain)
page["Raid Builder"]:SetWidth(DNAGlobal.width)
page["Raid Builder"]:SetHeight(DNAGlobal.height)
page["Raid Builder"]:SetPoint("TOPLEFT", 0, 0)

page["DKP"] = CreateFrame("Frame", nil, DNAFrameMain)
page["DKP"]:SetWidth(DNAGlobal.width)
page["DKP"]:SetHeight(DNAGlobal.height)
page["DKP"]:SetPoint("TOPLEFT", 0, 0)

page["Loot Log"] = CreateFrame("Frame", nil, DNAFrameMain)
page["Loot Log"]:SetWidth(DNAGlobal.width)
page["Loot Log"]:SetHeight(DNAGlobal.height)
page["Loot Log"]:SetPoint("TOPLEFT", 0, 0)

page["Config"] = CreateFrame("Frame", nil, DNAFrameMain)
page["Config"]:SetWidth(DNAGlobal.width)
page["Config"]:SetHeight(DNAGlobal.height)
page["Config"]:SetPoint("TOPLEFT", 0, 0)

local profileMessage = page["Config"]:CreateFontString(nil, "ARTWORK")
profileMessage:SetFont(DNAGlobal.font, 13, "OUTLINE")
profileMessage:SetText("|cffffe885Profile:|r " .. player.combine)
profileMessage:SetPoint("TOPLEFT", 30, -50)

local viewFrame_w = 400
local viewFrame_h = 400
local viewFrame_x = 580
local viewFrame_y = 100
DNAFrameView = CreateFrame("Frame", nil, page["Assignment"], "InsetFrameTemplate")
DNAFrameView:SetWidth(viewFrame_w-20)
DNAFrameView:SetHeight(viewFrame_h-80)
DNAFrameView:SetPoint("TOPLEFT", viewFrame_x+5, -viewFrame_y-20)
DNAFrameView:SetMovable(true)

DNAFrameViewBG = DNAFrameView:CreateTexture(nil, "BACKGROUND", DNAFrameView, -4)
DNAFrameViewBG:SetPoint("TOPLEFT", 0, 0)
DNAFrameViewBG:SetSize(viewFrame_w+90, viewFrame_h-20)
DNAFrameViewBG:SetTexture("Interface/EncounterJournal/UI-EJ-BACKGROUND-BlackwingLair")

DNAFrameViewDARK = DNAFrameView:CreateTexture(nil, "BACKGROUND", DNAFrameView, -3)
DNAFrameViewDARK:SetAllPoints(true)
DNAFrameViewDARK:SetColorTexture(0, 0, 0, 0.8)

DNAFrameView.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAFrameView, "UIPanelScrollFrameTemplate")
DNAFrameView.ScrollFrame:SetPoint("TOPLEFT", DNAFrameView, "TOPLEFT", 5, -4)
DNAFrameView.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAFrameView, "BOTTOMRIGHT", -25, 5)
local DNAViewScrollChildFrame = CreateFrame("Frame", nil, DNAFrameView.ScrollFrame)
DNAViewScrollChildFrame:SetSize(viewFrame_w, viewFrame_h)
DNAFrameView.ScrollFrame:SetScrollChild(DNAViewScrollChildFrame)
DNAFrameView.ScrollFrame.ScrollBar:ClearAllPoints()
DNAFrameView.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAFrameView.ScrollFrame, "TOPRIGHT", -50, -16)
DNAFrameView.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAFrameView.ScrollFrame, "BOTTOMRIGHT", 76, 14)
DNAFrameViewMR = DNAFrameView:CreateTexture(nil, "BACKGROUND", DNAFrameView, -1)
DNAFrameViewMR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAFrameViewMR:SetPoint("TOPLEFT", 354, -2)
DNAFrameViewMR:SetSize(24, 316)

for i = 1, MAX_FRAME_LINES do
  DNAFrameViewScrollChild_mark[i] = DNAViewScrollChildFrame:CreateTexture(nil, "ARTWORK")
  DNAFrameViewScrollChild_mark[i]:SetSize(16, 16)
  DNAFrameViewScrollChild_mark[i]:SetPoint("TOPLEFT", 5, (-i*18)+13)
  DNAFrameViewScrollChild_mark[i]:SetTexture("")

  DNAFrameViewScrollChild_tank[i] = DNAViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAFrameViewScrollChild_tank[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameViewScrollChild_tank[i]:SetText("")
  DNAFrameViewScrollChild_tank[i]:SetPoint("TOPLEFT", 25, (-i*18)+10)

  DNAFrameViewScrollChild_heal[i] = DNAViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAFrameViewScrollChild_heal[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameViewScrollChild_heal[i]:SetText("")
  DNAFrameViewScrollChild_heal[i]:SetPoint("TOPLEFT", 130, (-i*18)+10)
end

DNAFrameViewBossMap = DNAFrameView:CreateTexture(nil, "BACKGROUND")
DNAFrameViewBossMap:SetTexture("")
DNAFrameViewBossMap:SetSize(380, 320)
DNAFrameViewBossMap:SetPoint("TOPLEFT", 0, 0)
DNAFrameViewBossMap:Hide()

local DNAFrameClassAssignView = CreateFrame("Frame", nil, page["Assignment"], "InsetFrameTemplate")
DNAFrameClassAssignView:SetWidth(viewFrame_w-20)
DNAFrameClassAssignView:SetHeight(viewFrame_h-80)
DNAFrameClassAssignView:SetPoint("TOPLEFT", viewFrame_x+5, -viewFrame_y-20)

function DNAFrameClassAssignTextbox(name, pos_y)
  local edit_w = 225
  local edit_h = 25
  local DNAFrameClassAssignBorder = CreateFrame("Frame", nil, DNAFrameClassAssignView)
  DNAFrameClassAssignBorder:SetSize(edit_w, edit_h)
  DNAFrameClassAssignBorder:SetPoint("TOPLEFT", 115, -pos_y)
  DNAFrameClassAssignBorder:SetBackdrop({
    bgFile = "Interface/ToolTips/UI-Tooltip-Background",
    edgeFile = "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  DNAFrameClassAssignBorder:SetBackdropColor(0, 0, 0, 0.8)
  local DNAFrameClassAssignIcon = DNAFrameClassAssignBorder:CreateTexture(nil, "BACKGROUND")
  DNAFrameClassAssignIcon:SetSize(20, 20)
  DNAFrameClassAssignIcon:SetTexture("Interface/Icons/ClassIcon_" .. name)
  DNAFrameClassAssignIcon:SetPoint("TOPLEFT", -100, -2)
  local DNAFrameClassAssignLabel = DNAFrameClassAssignBorder:CreateFontString(nil, "OVERLAY")
  DNAFrameClassAssignLabel:SetFont(DNAGlobal.font, 14, "OUTLINE")
  DNAFrameClassAssignLabel:SetPoint("TOPLEFT", -75, -4)
  DNAFrameClassAssignLabel:SetText(name .. "s")

  DNAFrameClassAssignEdit[name] = CreateFrame("EditBox", nil, DNAFrameClassAssignBorder)
  DNAFrameClassAssignEdit[name]:SetSize(edit_w-12, edit_h)
  DNAFrameClassAssignEdit[name]:SetFontObject(GameFontWhite)
  DNAFrameClassAssignEdit[name]:SetPoint("TOPLEFT", 8, 0)
  DNAFrameClassAssignEdit[name]:EnableKeyboard(true)
  DNAFrameClassAssignEdit[name]:ClearFocus(self)
  DNAFrameClassAssignEdit[name]:SetAutoFocus(false)
  --DNAFrameClassAssign[name].enter:SetScript("OnEscapePressed", function()
  --end)
end

--DNAFrameClassAssignTextbox("Tank", 15)
--DNAFrameClassAssignTextbox("Heal", 50)

for i, v in ipairs(DNAClasses) do
  DNAFrameClassAssignTextbox(v, (i*26)-10)
end

function DN:CheckBox(checkID, checkName, parentFrame, posX, posY)
  local check_static = CreateFrame("CheckButton", nil, parentFrame, "ChatConfigCheckButtonTemplate")
  check_static:SetPoint("TOPLEFT", posX+10, -posY-40)
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

DN:CheckBox("AUTOPROMOTE", "Auto Promote Guild Officers", page["Config"], 10, 40)
DN:CheckBox("RAIDCHAT", "Assign Marks To Raid Chat", page["Config"], 10, 60)
DN:CheckBox("HIDEASSIGNCOMBAT", "Hide Personal Assignments After Combat", page["Config"], 10, 80)
DN:CheckBox("HIDEICON", "Hide The Minimap Icon", page["Config"], 10, 100)
--DN:CheckBox("DEBUG", "Debug Mode (Very Spammy)", page["Config"], 10, 80)

pageDKPEdit = CreateFrame("EditBox", nil, page["DKP"])
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

local btnPostDKP = CreateFrame("Button", nil, page["DKP"], "UIPanelButtonTemplate")
btnPostDKP:SetSize(120, 28)
btnPostDKP:SetPoint("TOPLEFT", 30, -100)
btnPostDKP.text = btnPostDKP:CreateFontString(nil, "ARTWORK")
btnPostDKP.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
btnPostDKP.text:SetText("Update Raid DKP")
btnPostDKP.text:SetPoint("CENTER", btnPostDKP)
btnPostDKP:SetScript("OnClick", function()
  if (UnitIsGroupLeader(player.name)) then
    if (pageDKPEdit:GetText()) then
      local getCode = multiKeyFromValue(netCode, "postdkp")
      DN:SendPacket(netCode[getCode][2] .. player.name, true)
    end
  end
end)
btnPostDKP:Hide()

local DNAFrameRaidDetailsBG = CreateFrame("Frame", nil, page["Raid Builder"], "InsetFrameTemplate")
DNAFrameRaidDetailsBG:SetSize(194, DNAGlobal.height-5)
DNAFrameRaidDetailsBG:SetPoint("TOPLEFT", 6, 0)
DNAFrameRaidDetailsBG:SetFrameLevel(2)

for i = 1, 50 do
  pageRaidDetailsColOne[i] = page["Raid Builder"]:CreateFontString(nil, "ARTWORK")
  pageRaidDetailsColOne[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  pageRaidDetailsColOne[i]:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", 20, (-i*14)-24)
  pageRaidDetailsColOne[i]:SetText("")
  pageRaidDetailsColOne[i]:SetTextColor(1, 1, 1)

  pageRaidDetailsColTwo[i] = page["Raid Builder"]:CreateFontString(nil, "ARTWORK")
  pageRaidDetailsColTwo[i]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  pageRaidDetailsColTwo[i]:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", 110, (-i*14)-24)
  pageRaidDetailsColTwo[i]:SetText("")
  pageRaidDetailsColTwo[i]:SetTextColor(0.9, 0.9, 0.9)
end

local DKPViewFrame_w = 400
local DKPViewFrame_h = 400
local DKPViewFrame_x = 580
local DKPViewFrame_y = 100
local pageDKPView = CreateFrame("Frame", nil, page["DKP"], "InsetFrameTemplate")
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

function clearNotifications()
  DNAFrameMainNotifText:SetText("")
  DNAFrameMainNotif:Hide()
end

function DN:Notification(msg)
  clearNotifications()
  DNAFrameMainNotifText:SetText(msg)
  DNAFrameMainNotif:Show()
end

--[==[
local SecureCmdList={}
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

local secureScript={}
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
      DN:SendPacket(role .. i .. "," .. name, true)
      local getCode = multiKeyFromValue(netCode, "author")
      local sendCode
      if (getCode) then
        local sendCode = netCode[getCode][2]
        DN:SendPacket(sendCode .. player.name, true)
      end
      local getCode = multiKeyFromValue(netCode, "version")
      local sendCode = netCode[getCode][2]
      DN:SendPacket(sendCode .. DNAGlobal.version, true)
    else
      DN:Notification("You do not have raid permission to modify assignments.   [P1]", true)
    end
  else
    return DN:Notification("You are not in a raid!     [E1]", true)
  end
end

DNAFrameMain:Hide()
page["DKP"]:Hide()
page["Raid Builder"]:Hide()

local DNAFrameInstanceBG = CreateFrame("Frame", nil, page["Assignment"], "InsetFrameTemplate")
DNAFrameInstanceBG:SetSize(194, DNAGlobal.height-5)
DNAFrameInstanceBG:SetPoint("TOPLEFT", 6, 0)
DNAFrameInstanceBG:SetFrameLevel(2)

local function instanceButton(name, pos_y, longtext, icon)
  DNAFrameInstance[name] = CreateFrame("Frame", nil, page["Assignment"])
  DNAFrameInstance[name]:SetSize(140, 80)
  DNAFrameInstance[name]:SetPoint("TOPLEFT", 30, -pos_y+64)

  DNAFrameInstanceText[name] = DNAFrameInstance[name]:CreateFontString(nil, "OVERLAY")
  DNAFrameInstanceText[name]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  DNAFrameInstanceText[name]:SetPoint("CENTER", 0, -25)
  DNAFrameInstanceText[name]:SetText(longtext)

  --DNAFrameInstanceScript[name] = CreateFrame("Button", nil, DNAFrameInstance[name], "UIPanelButtonTemplate")
  DNAFrameInstanceScript[name] = CreateFrame("Button", nil, DNAFrameInstance[name])
  DNAFrameInstanceScript[name]:SetSize(140, 80)
  DNAFrameInstanceScript[name]:SetPoint("CENTER", 0, 2)
  DNAFrameInstanceScript[name]:SetScript("OnClick", function()
    clearNotifications()
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

local pages = {
  {"Assignment", 10},
  {"Raid Builder", 100},
  {"Config", 190},
  --{"DKP", 190},
  --{"Loot Log", 280},
  --{"Config", 370},
}

local function bottomTabToggle(name)
  for i,v in pairs(pages) do
    DNAFrameMainBottomTab[v[1]]:SetFrameStrata("LOW")
    DNAFrameMainBottomTab[v[1]].text:SetTextColor(0.7, 0.7, 0.7)
    page[v[1]]:Hide()
  end
  DNAFrameMainBottomTab[name]:SetFrameStrata("MEDIUM")
  DNAFrameMainBottomTab[name].text:SetTextColor(1.0, 1.0, 0.5)
  page[name]:Show()
end

local function bottomTab(name, pos_x, text_pos_x)
  DNAFrameMainBottomTab[name] = CreateFrame("Frame", nil, DNAFrameMain)
  DNAFrameMainBottomTab[name]:SetPoint("BOTTOMLEFT", pos_x, -39)
  DNAFrameMainBottomTab[name]:SetWidth(85)
  DNAFrameMainBottomTab[name]:SetHeight(60)
  DNAFrameMainBottomTab[name]:SetFrameStrata("LOW")
  DNAFrameMainBottomTab[name].text = DNAFrameMainBottomTab[name]:CreateFontString(nil, "ARTWORK")
  DNAFrameMainBottomTab[name].text:SetFont(DNAGlobal.font, 11, "OUTLINE")
  DNAFrameMainBottomTab[name].text:SetText(name)
  DNAFrameMainBottomTab[name].text:SetTextColor(0.8, 0.8, 0.8)
  DNAFrameMainBottomTab[name].text:SetPoint("CENTER", DNAFrameMainBottomTab[name], "CENTER", 9, 0)

  local botBorder = DNAFrameMainBottomTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  botBorder:SetTexture("Interface/PaperDollInfoFrame/UI-CHARACTER-ACTIVETAB")
  botBorder:SetSize(100, 35)
  botBorder:SetPoint("TOPLEFT", 0, -14)
  DNAFrameMainBottomTabScript={}
  DNAFrameMainBottomTabScript[name] = CreateFrame("Button", nil, DNAFrameMainBottomTab[name], "UIPanelButtonTemplate")
  DNAFrameMainBottomTabScript[name] = CreateFrame("Button", nil, DNAFrameMainBottomTab[name])
  DNAFrameMainBottomTabScript[name]:SetSize(85, 30)
  DNAFrameMainBottomTabScript[name]:SetPoint("CENTER", 0, 0)
  DNAFrameMainBottomTabScript[name]:SetScript("OnClick", function()
    clearNotifications()
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
local raidSlotOrgPoint_x={}
local raidSlotOrgPoint_y={}
local memberDrag = nil
local thisClass = nil

resetSwapQueues()

local clearQueuePrompt=""
local function clearQueue()
  if (IsInRaid()) then
    if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
      if (clearQueuePrompt == "Heal") then
        healSlotFrame:Hide()
        for i = 1, DNASlots.heal do
          healSlot[i].text:SetText("Empty")
        end
        healSlotFrameClear:Hide()
      end
      if (clearQueuePrompt == "Tank") then
        tankSlotFrame:Hide()
        for i = 1, DNASlots.tank do
          tankSlot[i].text:SetText("Empty")
        end
        tankSlotFrameClear:Hide()
      end
      DN:UpdateRaidRoster()
      DN:RaidSendAssignments()
      tankSlotFrame:Show()
      healSlotFrame:Show()
    else
      DN:Notification("You do not have raid permission to modify assignments.   [P6]", true)
    end
  else
    DN:Notification("You are not in a raid!     [E8]", true)
  end
end

local DNARaidScrollFrame = CreateFrame("Frame", DNARaidScrollFrame, page["Assignment"], "InsetFrameTemplate")
DNARaidScrollFrame:SetWidth(DNARaidScrollFrame_w+20) --add scroll frame width
DNARaidScrollFrame:SetHeight(DNARaidScrollFrame_h-7)
DNARaidScrollFrame:SetPoint("TOPLEFT", 210, -80)
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
    raidSlot[i]:SetParent(page["Assignment"])
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

DNAFrameMainAuthor = page["Assignment"]:CreateFontString(nil, "ARTWORK")
DNAFrameMainAuthor:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNAFrameMainAuthor:SetPoint("TOPLEFT", 250, -DNAGlobal.height+30)
DNAFrameMainAuthor:SetText("Last Update:")
DNAFrameMainAuthor:SetTextColor(0.9, 0.9, 0.9)
DNAFrameMainAuthor:Hide()

local slotDialog = CreateFrame("Frame", nil, DNAFrameMain)
slotDialog:SetWidth(400)
slotDialog:SetHeight(100)
slotDialog:SetPoint("CENTER", 0, 50)
slotDialog:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
slotDialog.text = slotDialog:CreateFontString(nil, "ARTWORK")
slotDialog.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
slotDialog.text:SetPoint("CENTER", slotDialog, "CENTER", 0, 20)
slotDialog.text:SetText("")
slotDialog:SetFrameLevel(150)
slotDialog:SetFrameStrata("FULLSCREEN_DIALOG")
local slotDialogNo = CreateFrame("Button", nil, slotDialog, "UIPanelButtonTemplate")
slotDialogNo:SetSize(100, 24)
slotDialogNo:SetPoint("CENTER", -60, -20)
slotDialogNo.text = slotDialogNo:CreateFontString(nil, "ARTWORK")
slotDialogNo.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
slotDialogNo.text:SetPoint("CENTER", slotDialogNo, "CENTER", 0, 0)
slotDialogNo.text:SetText("No")
slotDialogNo:SetScript('OnClick', function()
  slotDialog:Hide()
end)
local slotDialogYes = CreateFrame("Button", nil, slotDialog, "UIPanelButtonTemplate")
slotDialogYes:SetSize(100, 24)
slotDialogYes:SetPoint("CENTER", 60, -20)
slotDialogYes.text = slotDialogYes:CreateFontString(nil, "ARTWORK")
slotDialogYes.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
slotDialogYes.text:SetPoint("CENTER", slotDialogYes, "CENTER", 0, 0)
slotDialogYes.text:SetText("Yes")
slotDialogYes:SetScript('OnClick', function()
  clearQueue(true)
  slotDialog:Hide()
end)
slotDialog:Hide()

local tankSlotOrgPoint_x={}
local tankSlotOrgPoint_y={}
tankSlotFrame = CreateFrame("Frame", tankSlotFrame, page["Assignment"], "InsetFrameTemplate")
tankSlotFrame:SetWidth(DNARaidScrollFrame_w+6)
tankSlotFrame:SetHeight((DNASlots.tank*20)+4)
tankSlotFrame:SetPoint("TOPLEFT", 380, -80)
tankSlotFrame.text = tankSlotFrame:CreateFontString(nil, "ARTWORK")
tankSlotFrame.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
tankSlotFrame.text:SetPoint("CENTER", tankSlotFrame, "TOPLEFT", 71, 10)
tankSlotFrame.text:SetText("Tanks")
tankSlotFrame.icon = tankSlotFrame:CreateTexture(nil, "OVERLAY")
tankSlotFrame.icon:SetTexture(DNAGlobal.dir .. "images/role_tank")
tankSlotFrame.icon:SetPoint("TOPLEFT", 25, 20)
tankSlotFrame.icon:SetSize(20, 20)
tankSlotFrame:SetFrameLevel(2)
tankSlotFrameClear = CreateFrame("Button", nil, tankSlotFrame, "UIPanelButtonTemplate")
tankSlotFrameClear:SetPoint("TOPLEFT", DNARaidScrollFrame_w-20, 20)
tankSlotFrameClear:SetSize(20, 18)
local tankSlotFrameClearIcon = tankSlotFrameClear:CreateTexture(nil, "OVERLAY")
tankSlotFrameClearIcon:SetTexture("Interface/Buttons/CancelButton-Up")
tankSlotFrameClearIcon:SetPoint("CENTER", -1, -2)
tankSlotFrameClearIcon:SetSize(31, 31)
tankSlotFrameClear:SetScript("OnClick", function()
  clearQueuePrompt = "Tank"
  slotDialog.text:SetText("Clear out the Tank queue?\nThis will reset the raids assignments!")
  slotDialog:Show()
end)
tankSlotFrameClear:Hide()
--[==[
tankSlotFrame:SetScript('OnLeave', function()
  resetSwapQueues()
end)
]==]--
for i = 1, DNASlots.tank do
  tankSlot[i] = CreateFrame("Button", tankSlot[i], tankSlotFrame)
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
      swapQueue[TANK] = i
    end
  end)
  tankSlot[i]:SetScript("OnDragStop", function()
    tankSlot[i]:StopMovingOrSizing()
    tankSlot[i]:SetPoint("TOPLEFT", tankSlotOrgPoint_x[i], tankSlotOrgPoint_y[i])
    updateSlotPos(TANK, i, "Empty")
  end)
  tankSlot[i]:SetScript('OnEnter', function()
    if (tankSlot[i].text:GetText() ~= "Empty") then
      tankSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
      if (swapQueue[TANK] > 0) then
        prevQueue[TANK] = i
      end
    end
    if ((swapQueue[TANK] > 0) and (prevQueue[TANK] > 0)) then --swap positions
      if (swapQueue[TANK] ~= prevQueue[TANK]) then --dupe check
        if ((tankSlot[swapQueue[TANK]].text:GetText() ~= "Empty") and (tankSlot[prevQueue[TANK]].text:GetText() ~= "Empty")) then
          updateSlotPos(TANK, swapQueue[TANK], tankSlot[prevQueue[TANK]].text:GetText() )
          updateSlotPos(TANK, prevQueue[TANK], tankSlot[swapQueue[TANK]].text:GetText() )
        end
        resetSwapQueues()
        memberDrag = nil
      end
    else
      if (memberDrag) then
        for dupe = 1, DNASlots.tank do
          if (tankSlot[dupe].text:GetText() == memberDrag) then
            updateSlotPos(TANK, dupe, "Empty")
            updateSlotPos(TANK, i, memberDrag)
            return true
          end
        end
        updateSlotPos(TANK, i, memberDrag)
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


local function closeGaps(remove)
  local healSlots={}
  if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
    for i = 1, DNASlots.heal do
      if ((healSlot[i].text:GetText() ~= "Empty") and (healSlot[i].text:GetText() ~= remove)) then
        table.insert(healSlots, healSlot[i].text:GetText())
      end
    end
    for i = 1, DNASlots.heal do
      healSlot[i].text:SetText("Empty") --quick recycle
    end
    for i, v in ipairs(healSlots) do
      healSlot[i].text:SetText(v)
    end
    DN:UpdateRaidRoster()
    DN:RaidSendAssignments()
    --resetSwapQueues()
  else
    if (IsInRaid()) then
      DN:Notification("You do not have raid permission to modify assignments.   [P2]", true)
    else
      DN:Notification("You are not in a raid!     [E2]", true)
    end
  end
end

local function shiftSlot(current, pos)
  if (IsInRaid()) then
    if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
      local shiftFrom= healSlot[current].text:GetText()
      if (pos == "up") then
        local shiftTo = healSlot[current-1].text:GetText()
        local cr, cg, cb, ca = healSlot[current-1].text:GetTextColor()
        local sr, sg, sb, sa = healSlot[current].text:GetTextColor()
        healSlot[current-1].text:SetTextColor(sr, sg, sb)
        healSlot[current-1].text:SetText(shiftFrom)
        healSlot[current].text:SetText(shiftTo)
        healSlot[current].text:SetTextColor(cr, cg, cb)
      else
        local shiftTo = healSlot[current+1].text:GetText()
        local cr, cg, cb, ca = healSlot[current+1].text:GetTextColor()
        local sr, sg, sb, sa = healSlot[current].text:GetTextColor()
        healSlot[current+1].text:SetText(shiftFrom)
        healSlot[current+1].text:SetTextColor(sr, sg, sb)
        healSlot[current].text:SetText(shiftTo)
        healSlot[current].text:SetTextColor(cr, cg, cb)
      end
      DN:UpdateRaidRoster()
      DN:RaidSendAssignments()
      healSlotUp[1]:Hide()
      healSlotDown[DNASlots.heal]:Hide()
    else
      DN:Notification("You do not have raid permission to modify assignments.   [P3]", true)
    end
  else
    DN:Notification("You are not in a raid!     [E7]", true)
  end
end

local healSlotOrgPoint_x={}
local healSlotOrgPoint_y={}
healSlotFrame = CreateFrame("Frame", healSlotFrame, page["Assignment"], "InsetFrameTemplate")
healSlotFrame:SetWidth(DNARaidScrollFrame_w+6)
healSlotFrame:SetHeight((DNASlots.heal*20)-2)
healSlotFrame:SetPoint("TOPLEFT", 380, -240)
healSlotFrame.text = healSlotFrame:CreateFontString(nil, "ARTWORK")
healSlotFrame.text:SetFont(DNAGlobal.font, 14, "OUTLINE")
healSlotFrame.text:SetPoint("CENTER", healSlotFrame, "TOPLEFT", 75, 10)
healSlotFrame.text:SetText("Healers")
healSlotFrame.icon = healSlotFrame:CreateTexture(nil, "OVERLAY")
healSlotFrame.icon:SetTexture(DNAGlobal.dir .. "images/role_heal")
healSlotFrame.icon:SetPoint("TOPLEFT", 20, 20)
healSlotFrame.icon:SetSize(20, 20)
healSlotFrame:SetFrameLevel(2)
healSlotFrameClear = CreateFrame("Button", nil, healSlotFrame, "UIPanelButtonTemplate")
healSlotFrameClear:SetPoint("TOPLEFT", DNARaidScrollFrame_w-20, 20)
healSlotFrameClear:SetSize(20, 18)
local healSlotFrameClearIcon = healSlotFrameClear:CreateTexture(nil, "OVERLAY")
healSlotFrameClearIcon:SetTexture("Interface/Buttons/CancelButton-Up")
healSlotFrameClearIcon:SetPoint("CENTER", -1, -2)
healSlotFrameClearIcon:SetSize(31, 31)
healSlotFrameClear:SetScript("OnClick", function()
  clearQueuePrompt = "Heal"
  slotDialog.text:SetText("Clear out the Healer queue?\nThis will reset the raids assignments!")
  slotDialog:Show()
end)
healSlotFrameClear:Hide()

for i = 1, DNASlots.heal do
  healSlot[i] = CreateFrame("Button", healSlot[i], healSlotFrame)
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
  healSlotUp[i] = CreateFrame("Button", nil, healSlot[i], "UIPanelButtonTemplate")
  healSlotUp[i]:SetPoint("TOPLEFT", DNARaidScrollFrame_w+16, 0)
  healSlotUp[i]:SetSize(20, 18)
  healSlotUp[i]:SetScript("OnClick", function()
    shiftSlot(i, "up")
  end)
  local healSlotUpIcon = healSlotUp[i]:CreateTexture(nil, "OVERLAY")
  healSlotUpIcon:SetTexture("Interface/MainMenuBar/UI-MainMenu-ScrollUpButton-Up")
  healSlotUpIcon:SetPoint("TOPLEFT", -3, 5)
  healSlotUpIcon:SetSize(27, 30)
  healSlotDown[i] = CreateFrame("Button", nil, healSlot[i], "UIPanelButtonTemplate")
  healSlotDown[i]:SetPoint("TOPLEFT", DNARaidScrollFrame_w, 0)
  healSlotDown[i]:SetSize(20, 18)
  healSlotDown[i]:SetScript("OnClick", function()
    shiftSlot(i, "down")
  end)
  local healSlotDownIcon = healSlotDown[i]:CreateTexture(nil, "OVERLAY")
  healSlotDownIcon:SetTexture("Interface/MainMenuBar/UI-MainMenu-ScrollDownButton-Up")
  healSlotDownIcon:SetPoint("TOPLEFT", -3, 5)
  healSlotDownIcon:SetSize(27, 30)
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
      healSlotUp[i]:Hide()
      healSlotDown[i]:Hide()
      healSlot[i]:StartMoving()
      healSlot[i]:SetFrameStrata("DIALOG")
      resetSwapQueues()
      swapQueue[HEAL] = i
      memberDrag = healSlot[i].text:GetText()
    end
  end)
  healSlot[i]:SetScript("OnDragStop", function()
    healSlot[i]:StopMovingOrSizing()
    healSlot[i]:SetPoint("TOPLEFT", healSlotOrgPoint_x[i], healSlotOrgPoint_y[i])
    --updateSlotPos(HEAL, i, "Empty")
    closeGaps(memberDrag)
  end)
  healSlot[i]:SetScript('OnEnter', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
    end
    if (memberDrag) then
      updateSlotPos(HEAL, i, memberDrag)
    end
  end)

  --[==[
  healSlot[i]:SetScript('OnEnter', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
      if (swapQueue[HEAL] > 0) then
        prevQueue[HEAL] = i
      end
    end
    if ((swapQueue[HEAL] > 0) and (prevQueue[HEAL] > 0)) then --swap positions
      if (swapQueue[HEAL] ~= prevQueue[HEAL]) then --dupe check
        if ((healSlot[swapQueue[HEAL]].text:GetText() ~= "Empty") and (healSlot[prevQueue[HEAL]].text:GetText() ~= "Empty")) then
          updateSlotPos(HEAL, swapQueue[HEAL], healSlot[prevQueue[HEAL]].text:GetText() )
          updateSlotPos(HEAL, prevQueue[HEAL], healSlot[swapQueue[HEAL]].text:GetText() )
        end
        resetSwapQueues()
        memberDrag = nil
      end
    else
      if (memberDrag) then
        for dupe = 1, DNASlots.heal do
          if (healSlot[dupe].text:GetText() == memberDrag) then
            updateSlotPos(HEAL, dupe, "Empty")
            updateSlotPos(HEAL, i, memberDrag)
            return true
          end
        end
        updateSlotPos(HEAL, i, memberDrag)
      end
    end
  end)
  ]==]--

  healSlot[i]:SetScript('OnLeave', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
    end
    memberDrag = nil
  end)
end

healSlotUp[DNASlots.heal]:SetPoint("TOPLEFT", DNARaidScrollFrame_w, 0) --last up button slide to left

--build all 40 first
for i = 1, MAX_RAID_MEMBERS do
  raidSlotFrame(DNARaidScrollFrameScrollChildFrame, i, i*19)
  raidSlot[i]:Hide()
end

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
    DNAFrameClassAssignView:Show()
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
  local viewFrameBotTabScript={}
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
  --local icon = _G[button:GetName().."Icon"]
  ddBossList[DNAInstance[i][1]] = CreateFrame("frame", nil, page["Assignment"], "UIDropDownMenuTemplate")
  ddBossList[DNAInstance[i][1]]:SetPoint("TOPLEFT", 680, -90)
  --ddBossList[DNAInstance[i][1]].displayMode = "MENU"
  ddBossListText[DNAInstance[i][1]] = ddBossList[DNAInstance[i][1]]:CreateFontString(nil, "ARTWORK")
  ddBossListText[DNAInstance[i][1]]:SetFont(DNAGlobal.font, 12, "OUTLINE")
  ddBossListText[DNAInstance[i][1]]:SetPoint("TOPLEFT", ddBossList[DNAInstance[i][1]], "TOPLEFT", 25, -8);
  local instanceNum = multiKeyFromValue(DNAInstance, DNAInstance[i][1])
  ddBossListText[DNAInstance[i][1]]:SetText(DNARaidBosses[instanceNum][1])
  ddBossList[DNAInstance[i][1]].onClick = function(self, checked)
    ddBossListText[DNAInstance[i][1]]:SetText(self.value)
    clearFrameView()
    raidSelection = self.value
    debug("ddBossList " .. self.value)
    buildRaidAssignments(self.value, nil, "dropdown")
  end
  ddBossList[DNAInstance[i][1]]:Hide()
  ddBossList[DNAInstance[i][1]].initialize = function(self, level)
  	local info = UIDropDownMenu_CreateInfo()
    local i = 0
    for ddKey, ddVal in pairs(DNARaidBosses[instanceNum]) do
      --if (ddKey ~= 1) then --remove first key
        --i = i +1
        info.notCheckable = 1
        info.padding = 20
        info.text = ddVal[1]
        info.value= ddVal[1]
        info.icon = ""
        info.fontObject = GameFontNormal
        --info.notClickable = false
        info.colorCode = "|cffffffff"
        info.justifyH = "LEFT"
        info.disabled = false
        if (ddVal[3] == 1) then
          info.colorCode = "|cfff2bd63"
        end
        if (ddVal[3] == 2) then
          info.disabled = true
          --info.colorCode = "|cff868686"
          info.justifyH = "CENTER"
        end
        if (ddVal[2]) then
          info.icon = ddVal[2] --bossicon
        end
      	info.func = self.onClick
      	UIDropDownMenu_AddButton(info, level)
      --end
    end
  end
  UIDropDownMenu_SetWidth(ddBossList[DNAInstance[i][1]], 160)
end

--ddBossListText[DNARaidBosses[1][1]]:SetText("Select a boss")

local largePacket = nil
function DN:RaidSendAssignments()
  largePacket = "{"
  for i = 1, DNASlots.tank do
    if (tankSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. TANK .. i .. "," .. tankSlot[i].text:GetText() .. "}"
    end
  end
  DN:SendPacket(largePacket, true)

  largePacket = "{" --beginning key
  for i = 1, DNASlots.heal do
    if (healSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. HEAL .. i .. "," .. healSlot[i].text:GetText() .. "}"
    end
  end
  DN:SendPacket(largePacket, true)

  local getCode = multiKeyFromValue(netCode, "author")
  if (getCode) then
    local sendCode = netCode[getCode][2]
    DN:SendPacket(sendCode .. player.name, true)
  end
  local getCode = multiKeyFromValue(netCode, "version")
  if (getCode) then
    local sendCode = netCode[getCode][2]
    DN:SendPacket(sendCode .. DNAGlobal.version, true)
  end
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
    DN:Notification("You are not in a raid!     [E3]", true)
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
    DN:Notification("You do not have raid permission to modify assignments.   [P4]", true)
  else
    DN:Notification("You are not in a raid!     [E4]", true)
  end
end)

btnShareDis:Hide()

local btnPostRaid_x = DNAGlobal.width-260
local btnPostRaid_y = DNAGlobal.height-45

--DN:CheckBox("READYCHECK", "Ready Check", page["Assignment"], DNAGlobal.width-260, DNAGlobal.height-107)
--DNACheckbox["READYCHECK"]:SetChecked(true)

local btnPostRaid_t = "Post to Raid"
local btnPostRaid = CreateFrame("Button", nil, page["Assignment"], "UIPanelButtonTemplate")
btnPostRaid:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnPostRaid:SetPoint("TOPLEFT", btnPostRaid_x, -btnPostRaid_y)
btnPostRaid.text = btnPostRaid:CreateFontString(nil, "ARTWORK")
btnPostRaid.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
btnPostRaid.text:SetText(btnPostRaid_t)
btnPostRaid.text:SetPoint("CENTER", btnPostRaid)
btnPostRaid:SetScript("OnClick", function()
  if (IsInRaid()) then
    if ((total.tanks < 2) or (total.healers < 8)) then
      DN:Notification("Not enough tanks and healers assigned!     [L2]", true)
      return
    end
    DN:RaidSendAssignments()
    if (raidSelection == nil) then
      --DNAFrameViewScrollChild_tank[3]:SetText("Please select a boss or trash pack!")
      DN:Notification("Please select a boss or trash pack!          [E9]", true)
    else
      --class notes
      for i,v in ipairs(DNAClasses) do
        local getCode = multiKeyFromValue(netCode, v)
        if (DNAFrameClassAssignEdit[v]:GetText() ~= "") then
          DN:SendPacket(netCode[getCode][2] .. DNAFrameClassAssignEdit[v]:GetText(), false)
        end
      end

      local getCode = multiKeyFromValue(netCode, "posttoraid")
      DN:SendPacket(netCode[getCode][2] .. raidSelection .. "," .. player.name, true) --openassignments
      --if (DNACheckbox["READYCHECK"]:GetChecked()) then
        DoReadyCheck()
      --end
    end
  else
    DN:Notification("You are not in a raid!     [E5]", true)
  end
end)
local btnPostRaidDis = CreateFrame("Button", nil, page["Assignment"], "UIPanelButtonGrayTemplate")
btnPostRaidDis:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnPostRaidDis:SetPoint("TOPLEFT", btnPostRaid_x, -btnPostRaid_y)
btnPostRaidDis.text = btnPostRaidDis:CreateFontString(nil, "ARTWORK")
btnPostRaidDis.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
btnPostRaidDis.text:SetText(btnPostRaid_t)
btnPostRaidDis.text:SetPoint("CENTER", btnPostRaid)
btnPostRaidDis:SetScript("OnClick", function()
  if (IsInRaid()) then
    DN:Notification("You do not have raid permission to modify assignments.   [P5]", true)
  else
    DN:Notification("You are not in a raid!     [E6]", true)
  end
end)
-- EO PAGE ASSIGN

for i,v in pairs(pages) do
  bottomTab(pages[i][1], pages[i][2])
end

--default selection after drawn
bottomTabToggle("Assignment")
ddBossList[DNAInstance[1][1]]:Show() -- show first one

--[==[
--local secBtn = CreateFrame("Button", nil, page["Assignment"], 'SecureActionButtonTemplate')
--local secBtn = CreateFrame("Button", "secrun", page["Assignment"], 'InsecureActionButtonTemplate')
local secBtn = CreateFrame("Button", "secrun", page["Assignment"], 'InsecureActionButtonTemplate')
secBtn:SetSize(80, 20)
secBtn:SetPoint("TOPLEFT", 0, 0)
secBtn.text = secBtn:CreateFontString(nil, "ARTWORK")
secBtn.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
secBtn.text:SetPoint("CENTER", secBtn, "CENTER", 10, -30)
secBtn.text:SetText("| tank test |")
secBtn:SetAttribute("type", "macro")
secBtn:SetAttribute("macrotext", "/mt Krizzu")
secBtn:SetScript("OnClick", function()
  debug("test")
end)
]==]--

local function raidPermissions()
  clearNotifications()
  if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
    btnShareDis:Hide()
    --btnShare:Show()
    btnPostRaid:Show()
    btnPostRaidDis:Hide()
    tankSlotFrameClear:Show()
    healSlotFrameClear:Show()
  else
    --btnShareDis:Show()
    btnShare:Hide()
    btnPostRaid:Hide()
    btnPostRaidDis:Show()
    for i = 1, DNASlots.heal do
      healSlotUp[i]:Hide()
      healSlotDown[i]:Hide()
    end
  end
end

local function DNAOpenWindow()
  if (windowOpen) then
    DNACloseWindow()
  else
    windowOpen = true
    DNAFrameMain:Show()
    --DNAFrameAssign:Show() --DEBUG
    memberDrag = nil --bugfix
    DN:UpdateRaidRoster()
    DN:ProfileSaves()
    raidPermissions()
    raidDetails()
    resetSwapQueues() --sanity check on queues
  end
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
DNAMiniMap:SetFrameLevel(500)
DNAMiniMap:SetFrameStrata("TOOLTIP")
DNAMiniMap:SetSize(27, 27)
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
  DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 60 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 56)
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
    local point, relativeTo, relativePoint, xOfs, yOfs = DNAMiniMap:GetPoint()
    debug("MMI Saved : " .. math.ceil(xOfs) .. "," .. math.ceil(yOfs))
    debug("MMI Actual: " .. 60 - (80 * cos(myIconPos)) .. "," .. (80 * sin(myIconPos)) - 56)
    debug("MMI Setval: " .. math.ceil(xOfs)+130 .. "," .. math.ceil(yOfs)+22)
    DNA[player.combine]["CONFIG"]["ICONPOS"] = math.ceil(xOfs) .. "," .. math.ceil(yOfs)
    UpdateMapButton()
end)
DNAMiniMap:ClearAllPoints()
DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 60 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 56)
DNAMiniMap:SetScript("OnClick", function()
  DNAOpenWindow()
end)

local DNADialogMMIReset = CreateFrame("Frame", nil, UIParent)
DNADialogMMIReset:SetWidth(400)
DNADialogMMIReset:SetHeight(100)
DNADialogMMIReset:SetPoint("CENTER", 0, 50)
DNADialogMMIReset:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNADialogMMIReset.text = DNADialogMMIReset:CreateFontString(nil, "ARTWORK")
DNADialogMMIReset.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNADialogMMIReset.text:SetPoint("CENTER", DNADialogMMIReset, "CENTER", 0, 20)
DNADialogMMIReset.text:SetText("Reset the minimap icon position?")
DNADialogMMIReset:SetFrameLevel(150)
DNADialogMMIReset:SetFrameStrata("FULLSCREEN_DIALOG")
local DNADialogMMIResetNo = CreateFrame("Button", nil, DNADialogMMIReset, "UIPanelButtonTemplate")
DNADialogMMIResetNo:SetSize(100, 24)
DNADialogMMIResetNo:SetPoint("CENTER", -60, -20)
DNADialogMMIResetNo.text = DNADialogMMIResetNo:CreateFontString(nil, "ARTWORK")
DNADialogMMIResetNo.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNADialogMMIResetNo.text:SetPoint("CENTER", DNADialogMMIResetNo, "CENTER", 0, 0)
DNADialogMMIResetNo.text:SetText("No")
DNADialogMMIResetNo:SetScript('OnClick', function()
  DNADialogMMIReset:Hide()
end)
local DNADialogMMIResetYes = CreateFrame("Button", nil, DNADialogMMIReset, "UIPanelButtonTemplate")
DNADialogMMIResetYes:SetSize(100, 24)
DNADialogMMIResetYes:SetPoint("CENTER", 60, -20)
DNADialogMMIResetYes.text = DNADialogMMIResetYes:CreateFontString(nil, "ARTWORK")
DNADialogMMIResetYes.text:SetFont(DNAGlobal.font, 12, "OUTLINE")
DNADialogMMIResetYes.text:SetPoint("CENTER", DNADialogMMIResetYes, "CENTER", 0, 0)
DNADialogMMIResetYes.text:SetText("Yes")
DNADialogMMIResetYes:SetScript('OnClick', function()
  DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -3, -6)
  DNA[player.combine]["CONFIG"]["ICONPOS"] = "-133,-29"
  DNADialogMMIReset:Hide()
end)
DNADialogMMIReset:Hide()

local DNAMiniMapRestore = CreateFrame("Button", nil, page["Config"], "UIPanelButtonTemplate")
DNAMiniMapRestore:SetSize(DNAGlobal.btn_w+15, DNAGlobal.btn_h)
DNAMiniMapRestore:SetPoint("TOPLEFT", 20, -DNAGlobal.height+50)
DNAMiniMapRestore.text = DNAMiniMapRestore:CreateFontString(nil, "ARTWORK")
DNAMiniMapRestore.text:SetFont(DNAGlobal.font, 10, "OUTLINE")
DNAMiniMapRestore.text:SetText("Reset Minimap Position")
DNAMiniMapRestore.text:SetPoint("CENTER", DNAMiniMapRestore)
DNAMiniMapRestore:SetScript("OnClick", function()
  DNADialogMMIReset:Show()
end)
