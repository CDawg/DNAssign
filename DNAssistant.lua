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

local DNAFrameAssign = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
DNAFrameAssign:SetWidth(DNAFrameAssign_w)
DNAFrameAssign:SetHeight(DNAFrameAssign_h)
DNAFrameAssign:SetPoint("CENTER", 0, 0)
DNAFrameAssign:SetMovable(true)
DNAFrameAssign:EnableMouse(true)
DNAFrameAssign:SetFrameStrata("DIALOG")
DNAFrameAssign:SetFrameLevel(150)
DNAFrameAssign:RegisterForDrag("LeftButton")
local DNAFrameAssignTitle = CreateFrame("Frame", nil, DNAFrameAssign, "BackdropTemplate")
DNAFrameAssignTitle:SetWidth(DNAFrameAssign_w)
DNAFrameAssignTitle:SetHeight(35)
DNAFrameAssignTitle:SetPoint("TOPLEFT", 0, 12)
DNAFrameAssignTitle:SetBackdrop({
  bgFile = "Interface/HelpFrame/DarkSandstone-Tile",
  edgeFile = DNAGlobal.border,
  edgeSize = 26,
  insets = {left=8, right=8, top=8, bottom=8},
})
local DNAFrameAssignTitleText = DNAFrameAssignTitle:CreateFontString(nil, "ARTWORK")
DNAFrameAssignTitleText:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAFrameAssignTitleText:SetPoint("TOPLEFT", DNAFrameAssignTitle, "TOPLEFT", 15, -12)
DNAFrameAssignTitleText:SetText("Assignments   [" .. DNAGlobal.sub .. " v" .. DNAGlobal.version .. "]")
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
DNAFrameAssignBossText:SetFont("Fonts/MORPHEUS.ttf", 22, "OUTLINE")
DNAFrameAssignBossText:SetPoint("TOPLEFT", DNAFrameAssignPage["assign"], "TOPLEFT", 110, -40)
DNAFrameAssignBossText:SetText("Empty")
DNAFrameAssignBossIcon = DNAFrameAssignPage["assign"]:CreateTexture(nil, "OVERLAY", nil, 2)
DNAFrameAssignBossIcon:SetSize(90, 50)
DNAFrameAssignBossIcon:SetPoint("TOPLEFT", 25, -20)
DNAFrameAssignBossIcon:SetTexture("")

DNAFrameAssignPersonal = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
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
  local point, relativeTo, relativePoint, xOfs, yOfs = DNAFrameAssignPersonal:GetPoint()
  DN:Debug("PAW Pos: " .. point .. "," .. xOfs .. "," .. yOfs)
  DNA[player.combine]["CONFIG"]["PAWPOS"] = point .. "," .. xOfs .. "," .. yOfs
end)
DNAFrameAssignPersonal:SetBackdropColor(0, 0, 0, 1)
DNAFrameAssignPersonal.header = CreateFrame("Frame", nil, DNAFrameAssignPersonal, "BackdropTemplate")
DNAFrameAssignPersonal.header:SetWidth(DNAFrameAssignPersonal_w)
DNAFrameAssignPersonal.header:SetHeight(18)
DNAFrameAssignPersonal.header:SetPoint("TOPLEFT", 0, 0)
DNAFrameAssignPersonal.header:SetBackdrop({
  bgFile = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  insets = {left=0, right=0, top=0, bottom=0},
})
DNAFrameAssignPersonal.headerText = DNAFrameAssignPersonal.header:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonal.headerText:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAFrameAssignPersonal.headerText:SetPoint("TOPLEFT", 5, -3)
DNAFrameAssignPersonal.headerText:SetText(player.name .. "'s Assignment         DNA v" .. DNAGlobal.version)
DNAFrameAssignPersonal.headerText:SetTextColor(1, 1, 0.4)
DNAFrameAssignPersonal.close = CreateFrame("Button", nil, DNAFrameAssignPersonal, "BackdropTemplate")
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

DNAFrameAssignPersonalMark = DNAFrameAssignPersonal:CreateTexture(nil, "ARTWORK")
DNAFrameAssignPersonalMark:SetSize(16, 16)
DNAFrameAssignPersonalMark:SetPoint("TOPLEFT", 6, -22)
DNAFrameAssignPersonalMark:SetTexture("")
DNAFrameAssignPersonalColOne = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalColOne:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAFrameAssignPersonalColOne:SetPoint("TOPLEFT", 25, -25)
DNAFrameAssignPersonalColOne:SetText("")
DNAFrameAssignPersonalColTwo = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalColTwo:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAFrameAssignPersonalColTwo:SetPoint("TOPLEFT", 125, -25)
DNAFrameAssignPersonalColTwo:SetText("")
DNAFrameAssignPersonalClass = DNAFrameAssignPersonal:CreateFontString(nil, "ARTWORK")
DNAFrameAssignPersonalClass:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
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
  bgFile = DNAGlobal.backdrop,
  edgeFile = DNAGlobal.border,
  edgeSize = 26,
  insets = {left=8, right=8, top=8, bottom=8},
})

DNAFrameAssignMapGroupID = DNAFrameAssignPage["map"]:CreateFontString(nil, "ARTWORK")
DNAFrameAssignMapGroupID:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
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

DNAFrameAssign:SetScript("OnDragStart", function()
  DNAFrameAssign:StartMoving()
end)
DNAFrameAssign:SetScript("OnDragStop", function()
  DNAFrameAssign:StopMovingOrSizing()
end)
for i=1, MAX_FRAME_LINES do
  DNAFrameAssignScrollChild_mark[i] = DNAFrameAssignScrollChild:CreateTexture(nil, "ARTWORK")
  DNAFrameAssignScrollChild_mark[i]:SetSize(16, 16)
  DNAFrameAssignScrollChild_mark[i]:SetPoint("TOPLEFT", 20, (-i*18)+12)
  DNAFrameAssignScrollChild_mark[i]:SetTexture("")

  DNAFrameAssignScrollChild_tank[i] = DNAFrameAssignScrollChild:CreateFontString(nil, "ARTWORK")
  DNAFrameAssignScrollChild_tank[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNAFrameAssignScrollChild_tank[i]:SetText("")
  DNAFrameAssignScrollChild_tank[i]:SetPoint("TOPLEFT", 45, (-i*18)+10)

  DNAFrameAssignScrollChild_heal[i] = DNAFrameAssignScrollChild:CreateFontString(nil, "ARTWORK")
  DNAFrameAssignScrollChild_heal[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNAFrameAssignScrollChild_heal[i]:SetText("")
  DNAFrameAssignScrollChild_heal[i]:SetPoint("TOPLEFT", 145, (-i*18)+10)
end

local DNAFrameAssignReady = {}
DNAFrameAssignReady = CreateFrame("Button", nil, DNAFrameAssign, "BackdropTemplate")
DNAFrameAssignReady:SetPoint("TOPLEFT", 70, -DNAFrameAssign_h+65)
DNAFrameAssignReady:SetBackdropColor(0.8, 0.8, 0.8, 1)
DNAFrameAssignReady:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
DNAFrameAssignReady.text = DNAFrameAssignReady:CreateFontString(nil, "OVERLAY")
DNAFrameAssignReady.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAFrameAssignReady.text:SetText("Ready")
DNAFrameAssignReady.text:SetPoint("CENTER", 0, 0)
DN:ButtonFrame(DNAFrameAssignReady, "green")
DNAFrameAssignReady:SetScript("OnClick", function()
  ConfirmReadyCheck(1) --ready
  DN:HideGlobalReadyCheck()
  DN:SendPacket(packetPrefix.readyyes .. player.name, true)
  DNAFrameAssign:Hide()
  print("|cfffaff04You have marked yourself as Ready.")
end)

local DNAFrameAssignNotReady={}
DNAFrameAssignNotReady = CreateFrame("Button", nil, DNAFrameAssign, "BackdropTemplate")
DNAFrameAssignNotReady:SetPoint("TOPLEFT", 210, -DNAFrameAssign_h+65)
DNAFrameAssignNotReady.text = DNAFrameAssignNotReady:CreateFontString(nil, "OVERLAY")
DNAFrameAssignNotReady.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAFrameAssignNotReady.text:SetText("Not Ready")
DNAFrameAssignNotReady.text:SetPoint("CENTER", 0, 0)
DN:ButtonFrame(DNAFrameAssignNotReady, "red")
DNAFrameAssignNotReady:SetScript("OnClick", function()
  ConfirmReadyCheck() --not ready
  DN:SendPacket(packetPrefix.readyno .. player.name, true)
  DNAFrameAssign:Hide()
end)
DNAFrameAssignAuthor = DNAFrameAssign:CreateFontString(nil, "ARTWORK")
DNAFrameAssignAuthor:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
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
  DNAFrameAssignTabBG:SetTexture(DNAGlobal.backdrop)
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

DN:ChatNotification("v" .. DNAGlobal.version .. " Initializing by " ..DNAGlobal.color.. DNAGlobal.author)

-- BUILD THE RAID PER BOSS
local function buildRaidAssignments(packet, author, source)
  local assign = packet
  local tank={}
  tank.main={}
  tank.banish={}
  tank.all={}
  local cc={}
  cc.main={}
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

  DN:Debug("buildRaidAssignments()")

  DN:ClearNotifications()
  DN:UpdateRaidRoster()
  DN:ClearFrameView() --clear out the current text
  DN:ClearFrameAssign()
  DN:ClearFrameAssignPersonal()
  DNAFrameAssignPersonal:Hide()

  if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
    tankSlotFrameClear:Show()
    healSlotFrameClear:Show()
    ccSlotFrameClear:Show()
  else
    for i=1, DNASlots.heal do
      healSlotUp[i]:Hide()
      healSlotDown[i]:Hide()
    end
    tankSlotFrameClear:Hide()
    healSlotFrameClear:Hide()
    ccSlotFrameClear:Hide()
  end

  if (total.raid < 12) then
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

  for i=1, DNASlots.cc do
    if (ccSlot[i].text:GetText() ~= "Empty") then
      cc.main[i] = ccSlot[i].text:GetText()
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
  for i=1, MAX_RAID_MEMBERS do
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

  DN:Instance_MC(assign, total, raid, mark, text, heal, tank, healer, cc)
  DN:Instance_BWL(assign, total, raid, mark, text, heal, tank, healer, cc)
  DN:Instance_AQ40(assign, total, raid, mark, text, heal, tank, healer, cc)
  DN:Instance_Naxx(assign, total, raid, mark, text, heal, tank, healer, cc)

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
        --DN:Debug("DEBUG :" .. healer_row[n])
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
            --DN:Debug("Personal Window Width " .. string.len(filter_row)) --increase the width of the window
            if (string.len(filter_row) > 40) then
              DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w + string.len(filter_row)+40)
              DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-24, 4)
              if (DNACheckbox["SMALLASSIGNCOMBAT"]:GetChecked()) then
                DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w -140 + string.len(filter_row)+40 /2)
                DNAFrameAssignPersonal.close:SetPoint("TOPLEFT", DNAFrameAssignPersonal:GetWidth()-12, 2)
              end
              DNAFrameAssignPersonal.header:SetWidth(DNAFrameAssignPersonal:GetWidth())
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
      class_message = string.gsub(class_message, "%.", "\n") --add a carriage return?
      local max_class_message_length = class_message:sub(1, 80)
      if (string.len(max_class_message_length)) then
        DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w + string.len(max_class_message_length)*3)
        if (DNACheckbox["SMALLASSIGNCOMBAT"]:GetChecked()) then
          DNAFrameAssignPersonal:SetWidth(DNAFrameAssignPersonal_w -140 + string.len(max_class_message_length)*3)
        end
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
      if (IsInRaid()) then
        if (DNABossPacket) then
          if (author == player.name) then
            SendChatMessage("===" .. DNABossPacket .. "===", "RAID", nil, "RAID")
          end
        end
      end
      for i=1, MAX_FRAME_LINES do
        local this_key = 0
        local text_line = ""
        if (text[i]) then
         --filter the colors
          text[i] = string.gsub(text[i], textcolor.white, "")
          text[i] = string.gsub(text[i], textcolor.note, "")
          text[i] = string.gsub(text[i], textcolor.red, "")
          text[i] = string.gsub(text[i], textcolor.green, "")
          text[i] = string.gsub(text[i], textcolor.blue, "")
          text[i] = string.gsub(text[i], textcolor.yellow, "")
          if (mark[i]) then
            this_key = multiKeyFromValue(DNARaidMarkers, mark[i], 2)
          end
          if ((this_key == nil) or (this_key == 0)) then
            this_key = 1
          end
          --DN:Debug(this_key)
          if (DNARaidMarkers[this_key][1]) then
            text_line = text_line .. DNARaidMarkers[this_key][1] .. " "
          else
            text_line = text_line
          end
          if (heal[i]) then
            text_line = text_line .. text[i] .. " [" .. heal[i] .. "]"
          else
            text_line = text_line .. text[i]
          end
          if (author == player.name) then
            if (IsInRaid()) then
              SendChatMessage(text_line, "RAID", nil, "RAID")
            end
          end
        end
      end
    end
  end

  pageBossIcon:SetTexture(DNABossIcon)
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

local bidTimerProg = 0
local function bidTimerFrame()
  bidTimerProg = bidTimerProg+1
  local get_ml_bid_timer = tonumber(DNABidWindowMLTimer:GetText()) + 1
  local countdown = tonumber(string.format("%d", get_ml_bid_timer-bidTimerProg/20))
  local countend = bidTimerProg/20
  local formulaBarPos = tonumber(bidTimerProg-1)*(13.8/get_ml_bid_timer)
  if ((countend >= get_ml_bid_timer-1.05) or (formulaBarPos >= 248)) then
    DNABidTimerProg:SetWidth(248)
    DNABidTimerSpark:Hide()
  else
    DNABidTimerProg:SetWidth(formulaBarPos)
  end
  DNABidTimerProg:Show()

  DNABidTimerSpark:SetPoint("TOPLEFT", formulaBarPos-15, 12)
  DNABidTimerSpark:Hide()
  if ((formulaBarPos > 5) and (formulaBarPos < 249)) then
    DNABidTimerSpark:Show()
  end
  DNABidTimerCount:SetText(countdown)
  --DN:Debug(formulaBarPos)
  if (countend == get_ml_bid_timer-1.05) then
    PlaySound(bidSound.expire)
    DN:Debug("sound called")
    DNABidControlFrame:Hide()
    if (DNABidWindowBidderName[1]:GetText()) then
      DNABidControlWinner:SetText(DNABidWindowBidderName[1]:GetText())
      DN:ClassColorText(DNABidControlWinner, DNARaid["class"][DNABidWindowBidderName[1]:GetText()])
      DNABidControlWinner:Show()
    end
    --DNABidWindowBidderNum[1]
  end
  if (countend >= get_ml_bid_timer-1.05) then
    DNABidTimerSpark:Hide()
  end
end
local bidTimer = C_Timer.NewTicker(1, bidTimerFrame, 10)
bidTimer:Cancel()

local DNAMain = CreateFrame("Frame")
local success = C_ChatInfo.RegisterAddonMessagePrefix(DNAGlobal.prefix)
DNAMain:RegisterEvent("ADDON_LOADED")
DNAMain:RegisterEvent("PLAYER_LOGIN")
DNAMain:RegisterEvent("PLAYER_ENTERING_WORLD")
DNAMain:RegisterEvent("CHAT_MSG_ADDON")
DNAMain:RegisterEvent("ZONE_CHANGED")
DNAMain:RegisterEvent("ZONE_CHANGED_NEW_AREA")
DNAMain:RegisterEvent("GROUP_ROSTER_UPDATE")
DNAMain:RegisterEvent("GUILD_ROSTER_UPDATE")
DNAMain:RegisterEvent("PLAYER_REGEN_ENABLED")
DNAMain:RegisterEvent("PLAYER_REGEN_DISABLED")
DNAMain:RegisterEvent("CHAT_MSG_LOOT")
DNAMain:RegisterEvent("TRADE_ACCEPT_UPDATE")
DNAMain:RegisterEvent("LOOT_OPENED")
DNAMain:RegisterEvent("LOOT_CLOSED")

DNAMain:SetScript("OnEvent", function(self, event, prefix, netpacket)
  if ((event == "ADDON_LOADED") and (prefix == "DNA")) then
    DN:BuildGlobalVars()
    DN:Debug(event)
  end

  --DN:Debug(prefix)

  if (event == "PLAYER_LOGIN") then
    DN:BuildGlobalVars()
    DN:GetProfileVars()

    DN:GetAttendanceLogs()
    DN:ChatNotification("Loading Raid History ["..DNAGlobal.color.."Attendance|r]")
    if (DNA["ATTENDANCE"]) then
      local sortAttendance = {}
      for k,v in pairs(attendance) do
        table.insert(sortAttendance, k)
      end
      table.sort(sortAttendance, function(a,b) return a>b end)
      for k,v in ipairs(sortAttendance) do
        numAttendanceLogs = numAttendanceLogs + 1
        --create the number of log frames from the log count
        local filterLogName = string.gsub(v, "}", "")
        attendanceLogSlotFrame(numAttendanceLogs, filterLogName, v)
      end
    end

    DN:GetLootLogs()
    DN:ChatNotification("Loading Raid History ["..DNAGlobal.color.."Loot|r]")
    if (DNA["LOOTLOG"]) then
      local sortLoot = {}
      for k,v in pairs(lootlog) do
        table.insert(sortLoot, k)
      end
      table.sort(sortLoot, function(a,b) return a>b end)
      for k,v in ipairs(sortLoot) do
        numLootLogs.init = numLootLogs.init + 1
        local filterLogName = string.gsub(v, "}", "")
        DN:Debug(filterLogName .. " and " .. v)
        lootLogSlotFrame(numLootLogs.init, filterLogName, v)
      end
    end

    if (IsInGuild()) then
      DN:GetDKPLogs()
      DN:ChatNotification("Collecting Guild ["..DNAGlobal.color.."DKP|r]")
      if (DNA["DKP"]) then
        local sortDKP = {}
        for k,v in pairs(dnadkp) do
          table.insert(sortDKP, k)
        end
        table.sort(sortDKP, function(a,b) return a>b end)
        for k,v in ipairs(sortDKP) do
          numDKPLogs = numDKPLogs + 1
          --create the number of log frames from the log count
          local filterLogName = string.gsub(v, "}", "")
          --DKPLogSlotFrame(numDKPLogs, filterLogName, v)
        end
      end

      DN:SendPacket(packetPrefix.version .. DNAGlobal.version, true, "GUILD")

      --delay the guild roster from being built, then build the frames ONE time.
      local numTotalMembers, numOnlineMaxLevelMembers, numOnlineMembers = GetNumGuildMembers()
      if (DNAGuildDataBuilder) then
        DNAGuildDataBuilder = numTotalMembers
        DN:GetGuildComp()
        for i=1, numTotalMembers do
          guildSlotFrame(DNARaidScrollFrameScrollChildFrame, i, i*19)
          guildSlot[i]:Hide()
        end
        DN:ChatNotification("Collecting Guild ["..DNAGlobal.color.."Roster|r]")
      end
      DN:ChatNotification("Collecting Guild ["..DNAGlobal.color.."Professions|r]")

      --cache to memory
      for k,v in pairs(DNAProfession.Reagents) do
        local reagents = v[6]
        for i=1, 6 do
          if (reagents[i]) then
            local itemName = GetItemInfo(reagents[i])
            local icon = GetItemIcon(reagents[i])
          end
        end
      end

    end
  end

  if (event == "GUILD_ROSTER_UPDATE") then --profrequest onload
    DN:GetGuildDKP()
    DN:SendMyProfessions(false, player.name)
  end

  if (event == "LOOT_OPENED") then
    DN:Debug("loot opened")
    DN:Debug(date("%Y%m%d%H%M%S")) --old comparison
    if (IsInRaid()) then
      if (IsMasterLooter()) then
        local dnalootslot = 0
        DN:ClearLootWindow()
        for i = GetNumLootItems(), 1, -1 do
    		  local slotType = GetLootSlotType(i)
          --local lootIcon, lootName, lootQuantity, lootQuality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
          if (slotType == LOOT_SLOT_ITEM) then --dont show or calc currency
            local itemLink = GetLootSlotLink(i)
            local itemString = string.match(itemLink, "item[%-?%d:]+")
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemString)
            DN:Debug(itemName)
            DN:Debug(itemRarity)
            if (itemRarity >= MIN_LOOT_QUALITY) then
              dnalootslot = dnalootslot+1 --qualified items
              --end
              DNAlootWindowItemID[dnalootslot]:SetText(itemName)
              DNAlootWindowItem[dnalootslot]:SetText(itemName)
              DNAlootWindowItem[dnalootslot]:Show()
              DNAlootWindowItemBidBtn[dnalootslot]:Show()
              DNAlootWindowItemQuality[dnalootslot]:SetText(itemRarity)
              DN:ItemQualityColorText(DNAlootWindowItem[dnalootslot], itemRarity)
            end
          end
        end
        if (dnalootslot >= 1) then
          --local point, relativeTo, relativePoint, xOfs, yOfs = LootFrame:GetPoint()
          DNALootWindow:Show()
        end
      end
    end
  end
  if (event == "LOOT_CLOSED") then
    DN:Debug("loot closed")
    DNALootWindow:Hide()
  end

  if (event == "GROUP_ROSTER_UPDATE") then
    DN:UpdateRaidRoster()
  end

  if (event== "PLAYER_REGEN_DISABLED") then --entered combat
    DN:RaidReadyClear()
    DN:BuildAttendance()
    DN:Debug("Entered Combat!")
  end
  if (event == "PLAYER_REGEN_ENABLED") then --left combat
    if (DNACheckbox["HIDEASSIGNCOMBAT"]:GetChecked()) then
      DNAFrameAssignPersonal:Hide()
      DN:Debug("Left Combat!")
    end
  end

  -- DEBUG purposes only
  if (DEBUG) then
    if (event == "CHAT_MSG_LOOT") then --SEND
      local itemLink = string.match(prefix,"|%x+|Hitem:.-|h.-|h|r")
      local itemString = string.match(itemLink, "item[%-?%d:]+")
      local itemParse = split(itemString, ":")
      local itemID = GetItemIcon(itemParse[2])
      local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemString)
      local inInstance, instanceType = IsInInstance()
      local lootMethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
      --DN:Debug("lootMethod = " .. lootMethod)
      DN:Debug(packetPrefix.lootitem .. itemName .. "," .. itemRarity .. "," .. player.name .. "," .. itemID)
    end
  end

  if (event == "CHAT_MSG_ADDON") then
    if (prefix == DNAGlobal.prefix) then
      DN:Debug("Reading netpacket " .. netpacket)
      if (string.sub(netpacket, 1, 1) == "@") then --DKP
        local DKPPacket = string.gsub(netpacket, "@", "")
        --pageDKPViewScrollChild_colOne[1]:SetText(DKPPacket)
        return true
      end

      if (version_alerted == 0) then
        local getPacket = DN:ParsePacket(netpacket, packetPrefix.version)
        if (getPacket) then
          local latest_version = tonumber(getPacket)
          local my_version = tonumber(DNAGlobal.version)
          if (latest_version > my_version+0.002) then --if its greater than 2 minor releases, error out
            DN:ChatNotification("|cfff7440bYou have an outdated version!\nUpdate to version " .. latest_version)
            version_alerted = tonumber(latest_version)
          end
          return true
        end
      end

      DN:PresetClear()
      DN:AlignSlotText()

      --parse incoming large packet chunk
      if (string.sub(netpacket, 1, 1) == "{") then
        netpacket = netpacket .. "EOL"
        netpacket = string.gsub(netpacket, '}EOL', "")
        local filteredPacket={}
        packetChunk = split(netpacket, "}")
        for x=1, table.getn(packetChunk) do
          filteredPacket[x] = string.gsub(packetChunk[x], "{", "")
          DN:ParseSlotPacket(packet, filteredPacket[x])
        end
        DN:RaidReadyClear()
        return true
      end

      --class notes
      local hasClassAssigns = false
      for i,v in ipairs(DNAClasses) do
        local getPacket = DN:ParsePacket(netpacket, packetPrefix[v])
        if (getPacket) then
          DNAFrameClassAssignEdit[v]:SetText(getPacket)
          hasClassAssigns = true
        end
      end

      --LOOT LOG (receive)
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.lootitem)
      if (getPacket) then
        local loot_data = split(getPacket, ",")
        local lootQuality = tonumber(loot_data[2])
        local inInstance, instanceType = IsInInstance()
        DN:Debug("loot_data[1] " .. loot_data[1]) --item
        DN:Debug("loot_data[2] " .. loot_data[2]) --quality
        DN:Debug("loot_data[3] " .. loot_data[3]) --who [ML]
        --DN:Debug("loot_data[4] " .. loot_data[4]) --itemID
        if (DNA["LOOTLOG"] == nil) then
          DNA["LOOTLOG"]={}
        end
        if (DNA["LOOTLOG"][timestamp.date] == nil) then
          DNA["LOOTLOG"][timestamp.date]={}
        end
        if (inInstance) then
          local instanceName = GetInstanceInfo()
          if (instanceName) then
            if (DNA["LOOTLOG"][timestamp.date][instanceName] == nil) then
              DNA["LOOTLOG"][timestamp.date][instanceName] = {}

              --create a live ONE TIME buffer
              DN:GetLootLogs()
              local sortLoot = {}
              for k,v in pairs(lootlog) do
                table.insert(sortLoot, k)
              end
              table.sort(sortLoot, function(a,b) return a>b end)
              for k,v in ipairs(sortLoot) do
                if (numLootLogs.init > 0) then
                  numLootLogs.cache = numLootLogs.init + 1
                else
                  numLootLogs.cache = numLootLogs.cache + 1
                end
              end
              lootLogSlotFrame(numLootLogs.cache, timestamp.date .. " " .. instanceName, timestamp.date .. "} " .. instanceName)
            end
            if (DNA["LOOTLOG"][timestamp.date][instanceName][date("%Y%m%d%H%M%S") .. "" .. loot_data[1]] == nil) then
              DNA["LOOTLOG"][timestamp.date][instanceName][date("%Y%m%d%H%M%S") .. "" .. loot_data[1]] = {lootQuality}
              DN:Debug(loot_data[1] .. " from " .. loot_data[3])
            end
          end
        end
        return true
      end

      -- Get the Raid Assistant that pushed
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.author)
      if (getPacket) then
        DNAFrameMainAuthor:SetText("Last Update: " .. getPacket)
        DNAFrameMainAuthor:Show()
        return true
      end

      -- POST TO RAID
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.posttoraid)
      if (getPacket) then
        local raid_assignment = split(getPacket, ",")
        DN:Debug(raid_assignment[1])
        DN:Debug(raid_assignment[2])
        buildRaidAssignments(raid_assignment[1], raid_assignment[2], "network")
        DNAFrameAssign:Show()
        DN:RaidReadyClear()
        DN:HideGlobalReadyCheck()
        DN:Debug("ReadyCheckFrame:Hide")
        return true
      end

      if (hasClassAssigns) then
        return true
      end

      --READYCHECK
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.readyyes)
      if (getPacket) then
        DN:RaidReadyMember(getPacket, true)
        DN:ClearFrameClassAssign()
        return true
      end
      --NOT READY
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.readyno)
      if (getPacket) then
        DN:RaidReadyMember(getPacket, false)
        DN:ClearFrameClassAssign()
        return true
      end

      --ML Pauses bidding
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.stopbid)
      if (getPacket) then
        local get_msg= split(getPacket, ",")
        local get_ml = get_msg[2]
        --DNABidWindow:Show()
        clearBidding()
        bidTimer:Cancel()
        DNABidControlWinner:Show()
        DNABidControlWinner:SetText("BIDDING PAUSED")
        DNABidControlFrame:Hide()
        DN:ChatNotification("|cfffff000Bidding Paused by " ..DNAGlobal.color.. get_ml)
        PlaySound(bidSound.expire)
        return true
      end

      --individual bidding
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.lootbid)
      if (getPacket) then
        local get_bid = split(getPacket, ",")
        local get_bid_name= get_bid[1]
        local get_bid_num = tonumber(get_bid[2])
        --sort by bid number
        table.insert(bidderTable, {get_bid_num, get_bid_name}) --bid order, not alpha name order
        table.sort(bidderTable, function(lhs, rhs) return lhs[1] > rhs[1] end)
        for k,v in pairs(bidderTable) do
          DN:Debug(k .. " - " .. v[1] .. " - " .. v[2])
          DNABidWindowBidderName[k]:SetText(v[2])
          DN:ClassColorText(DNABidWindowBidderName[k], DNARaid["class"][v[2]])
          DNABidWindowBidderNum[k]:SetText(v[1])
          DNABidWindowBidderNum[1]:SetTextColor(1, 1, 0.4)
        end
        PlaySoundFile(bidSound.placed)
        bidTimer:Cancel() --reset bidding
        bidTimerProg = 0
        local get_ml_bid_timer = DNABidWindowMLTimer:GetText()
        tonumber(get_ml_bid_timer)
        --bidTimer = C_Timer.NewTicker(0.060, bidTimerFrame, 20*get_ml_bid_timer)
        bidTimer = C_Timer.NewTicker(0.060, bidTimerFrame, 20*get_ml_bid_timer)
        return true
      end

      --open bid window (receive)
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.openbid)
      if (getPacket) then
        local loot_data = split(getPacket, ",")
        local lootItem = loot_data[1]
        local lootQuality = tonumber(loot_data[2])
        local lootMaster = loot_data[3]
        local get_bid_timer=tonumber(loot_data[4])
        DNABidWindow:Show()
        clearBidding()
        DNABidNumber:SetText("0") --default to on open
        myBid = 1
        --local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(lootItem)
        --local itemID, itemType, itemSubType, itemEquipLoc, icon, itemClassID, itemSubClassID = GetItemInfoInstant(lootItem)
        DNABidWindowItem:SetText(lootItem)
        if (get_bid_timer) then
          tonumber(get_bid_timer)
          DNABidWindowMLTimer:SetText(get_bid_timer)
        else
          DNABidWindowMLTimer:SetText(BID_TIMER) --fail safe, in case idiots decide to push alpha data
        end
        bidTimerProg = 0
        DNABidTimerCount:SetText("0")
        DNABidTimerProg:Hide()
        DNABidTimerSpark:Hide()
        DN:ItemQualityColorText(DNABidWindowItem, lootQuality)
        PlaySound(bidSound.start)
        bidTimer:Cancel()
        DNABidControlWinner:Hide()
        DNABidControlFrame:Show()
        return true
      end

      --individual bidding
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.lootbid)
      if (getPacket) then
        local get_bid = split(getPacket, ",")
        local get_bid_name= get_bid[1]
        local get_bid_num = tonumber(get_bid[2])
        --sort by bid number
        table.insert(bidderTable, {get_bid_num, get_bid_name}) --bid order, not alpha name order
        table.sort(bidderTable, function(lhs, rhs) return lhs[1] > rhs[1] end)
        for k,v in pairs(bidderTable) do
          DN:Debug(k .. " - " .. v[1] .. " - " .. v[2])
          DNABidWindowBidderName[k]:SetText(v[2])
          DN:ClassColorText(DNABidWindowBidderName[k], DNARaid["class"][v[2]])
          DNABidWindowBidderNum[k]:SetText(v[1])
          DNABidWindowBidderNum[1]:SetTextColor(1, 1, 0.4)
        end
        PlaySoundFile(bidSound.placed)
        bidTimer:Cancel()
        bidTimerProg = 0
        local get_ml_bid_timer = DNABidWindowMLTimer:GetText()
        tonumber(get_ml_bid_timer)
        --bidTimer = C_Timer.NewTicker(0.060, bidTimerFrame, 20*get_ml_bid_timer)
        bidTimer = C_Timer.NewTicker(0.060, bidTimerFrame, 20*get_ml_bid_timer)
        return true
      end

      --get tradeskills
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.profession)
      if (getPacket) then
        local prof_data = split(getPacket, ",")
        DN:SaveGuildProfessions(prof_data)
        return true
      end

      --get tradeskills - with a notification on a sync
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.professionN)
      if (getPacket) then
        local prof_data = split(getPacket, ",")
        local guild_member = prof_data[1]
        local guild_author = prof_data[3] --whos pulling, spam only the requester
        DN:SaveGuildProfessions(prof_data)
        --if (guild_author == player.name) then
        --print("guild_author " .. guild_author)
          --DN:ChatNotification("Reading Profession Data ["..DNAGlobal.color..guild_member.."|r]")
        --end
        return true
      end

      --send tradeskills
      local getPacket = DN:ParsePacket(netpacket, packetPrefix.profrequest)
      if (getPacket) then
        local prof_data = split(getPacket, ",")
        if (prof_data[1] == player.name) then
          DN:SendMyProfessions(true, prof_data[2])
        end
        return true
      end

      --single slot update, parse individual packets
      DN:ParseSlotPacket(packet, netpacket)
    end
  end
end)

function DN_Hook_GiveMasterLoot(slot, index)
	if (not slot) then
    DN:Debug("no slot")
    return
  end
	if (not index) then
    DN:Debug("no slot")
    return
  end
	DN:Debug("DN_Hook_GiveMasterLoot called - Slot=" .. slot .. " - Index=" .. index)
	local itemLink = GetLootSlotLink(slot)
	if (not itemLink) then
		DN:Debug("No item found for given index.")
		return
	else
		DN:Debug("Itemlink: " .. itemLink)
	end

	local candidate = GetMasterLootCandidate(slot, index)
	if (not candidate) then
		DN:Debug("No candidate returned...")
		return
	else
		DN:Debug("Candidate: "..candidate)
	end

  local itemString = string.match(itemLink, "item[%-?%d:]+")
  local itemParse = split(itemString, ":")
  local itemID = itemParse[2]
  local itemIcon = GetItemIcon(itemID)
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemString)
  local inInstance, instanceType = IsInInstance()
  local lootMethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
  if (inInstance) then
    if (IsInRaid()) then
      if (itemRarity >= MIN_LOOT_QUALITY) then
        if (IsMasterLooter()) then
          DN:SendPacket(packetPrefix.lootitem .. itemName .. "," .. itemRarity .. "," .. player.name .. "," .. itemID, false)
          DN:Debug("ML = " .. player.name)
          DN:Debug(packetPrefix.lootitem .. itemName .. "," .. itemRarity .. "," .. player.name .. "," .. itemID)
        end
      end
    end --in raid
  end
end
hooksecurefunc("GiveMasterLoot", DN_Hook_GiveMasterLoot)

--build the cached array
DN:GetRaidComp()

function DN:GetProfileVars()
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
        tankSlot[getsave.slot].text:SetPoint("TOPLEFT", 20, -4)
        tankSlot[getsave.slot]:SetFrameLevel(3)
        tankSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        tankSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(tankSlot[getsave.slot].text, thisClass)
      end
    end
    if (getsave.role == CC) then
      if ((getsave.name == nil) or (getsave.name == "Empty")) then
        ccSlot[getsave.slot].text:SetText("Empty")
        ccSlot[getsave.slot]:SetFrameLevel(2)
        ccSlot[getsave.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        ccSlot[getsave.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(ccSlot[getsave.slot].text, "Empty")
      else
        ccSlot[getsave.slot].text:SetText(getsave.name)
        ccSlot[getsave.slot].text:SetPoint("TOPLEFT", 20, -4)
        ccSlot[getsave.slot]:SetFrameLevel(3)
        ccSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        ccSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(ccSlot[getsave.slot].text, thisClass)
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
        healSlot[getsave.slot].text:SetPoint("TOPLEFT", 20, -4)
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

    if ((UnitIsGroupLeader(player.name)) or (UnitIsGroupAssistant(player.name))) then
      if (IsInRaid()) then
        tankSlotFrameClear:Show()
        healSlotFrameClear:Show()
        ccSlotFrameClear:Show()
      end
    else
      for i=1, DNASlots.heal do
        healSlotUp[i]:Hide()
        healSlotDown[i]:Hide()
      end
      tankSlotFrameClear:Hide()
      healSlotFrameClear:Hide()
      ccSlotFrameClear:Hide()
    end
  end

  if (DNA[player.combine]["CONFIG"]["AUTOPROMOTE"] == "ON") then
    DNACheckbox["AUTOPROMOTE"]:SetChecked(true)
  end

  --[==[
  if (DNA[player.combine]["CONFIG"]["AUTOPROMOTEC"] == "ON") then
    DNACheckbox["AUTOPROMOTEC"]:SetChecked(true)
  end
  ]==]--

  if (DNA[player.combine]["CONFIG"]["HIDEASSIGNCOMBAT"] == "ON") then
    DNACheckbox["HIDEASSIGNCOMBAT"]:SetChecked(true)
  end
  if (DNA[player.combine]["CONFIG"]["SMALLASSIGNCOMBAT"] == "ON") then
    DNACheckbox["SMALLASSIGNCOMBAT"]:SetChecked(true)
  end

  if (DNA[player.combine]["CONFIG"]["LOGATTENDANCE"] == "ON") then
    DNACheckbox["LOGATTENDANCE"]:SetChecked(true)
  end

  if (DNA[player.combine]["CONFIG"]["MMICONHIDE"] == "ON") then
    DNACheckbox["MMICONHIDE"]:SetChecked(true)
    DNAMiniMap:Hide()
  end

  if (DNA[player.combine]["CONFIG"]["MMICONPOS"]) then
    local minimapIconPos = {}
    minimapIconPos = split(DNA[player.combine]["CONFIG"]["MMICONPOS"], ",")
    DNAMiniMap:ClearAllPoints()
    DNAMiniMap:SetPoint(minimapIconPos[1], tonumber(minimapIconPos[2]), tonumber(minimapIconPos[3]))
  end

  if (DNA[player.combine]["CONFIG"]["MAINPOS"]) then
    local DNAFrameMainPos = {}
    DNAFrameMainPos = split(DNA[player.combine]["CONFIG"]["MAINPOS"], ",")
    DN:Debug("DNAFrameMainPos: " .. DNAFrameMainPos[1] .. "," .. tonumber(DNAFrameMainPos[2]) .. "," .. tonumber(DNAFrameMainPos[3]))
    DNAFrameMain:ClearAllPoints()
    DNAFrameMain:SetPoint(DNAFrameMainPos[1], tonumber(DNAFrameMainPos[2]), tonumber(DNAFrameMainPos[3]))
  end

  if (DNA[player.combine]["CONFIG"]["PAWPOS"]) then
    local DNAFrameAssignPersonalPos = {}
    DNAFrameAssignPersonalPos = split(DNA[player.combine]["CONFIG"]["PAWPOS"], ",")
    DN:Debug("DNAFrameAssignPersonalPos: " .. DNAFrameAssignPersonalPos[1] .. "," .. tonumber(DNAFrameAssignPersonalPos[2]) .. "," .. tonumber(DNAFrameAssignPersonalPos[3]))
    DNAFrameAssignPersonal:ClearAllPoints()
    DNAFrameAssignPersonal:SetPoint(DNAFrameAssignPersonalPos[1], tonumber(DNAFrameAssignPersonalPos[2]), tonumber(DNAFrameAssignPersonalPos[3]))
  end

  if (DNA[player.combine]["CONFIG"]["BWPOS"]) then
    local DNABidWindowPos = {}
    DNABidWindowPos = split(DNA[player.combine]["CONFIG"]["BWPOS"], ",")
    DN:Debug("DNABidWindowPos: " .. DNABidWindowPos[1] .. "," .. tonumber(DNABidWindowPos[2]) .. "," .. tonumber(DNABidWindowPos[3]))
    DNABidWindow:ClearAllPoints()
    DNABidWindow:SetPoint(DNABidWindowPos[1], tonumber(DNABidWindowPos[2]), tonumber(DNABidWindowPos[3]))
  end

  if (DNA[player.combine]["CONFIG"]["LWPOS"]) then
    local DNALootWindowPos = {}
    DNALootWindowPos = split(DNA[player.combine]["CONFIG"]["LWPOS"], ",")
    DN:Debug("DNALootWindowPos: " .. DNALootWindowPos[1] .. "," .. tonumber(DNALootWindowPos[2]) .. "," .. tonumber(DNALootWindowPos[3]))
    DNALootWindow:ClearAllPoints()
    DNALootWindow:SetPoint(DNALootWindowPos[1], tonumber(DNALootWindowPos[2]), tonumber(DNALootWindowPos[3]))
  end

  if (DNA[player.combine]["CONFIG"]["RAIDCHAT"] == "ON") then
    DNACheckbox["RAIDCHAT"]:SetChecked(true)
  end

  if (DNA[player.combine]["CONFIG"]["EXP"]) then
    expTabActive(DNA[player.combine]["CONFIG"]["EXP"])
  end

  if (DNA[player.combine]["CONFIG"]["RAID"]) then
    local instanceNum = multiKeyFromValue(DNAInstance, DNA[player.combine]["CONFIG"]["RAID"])
    DN:InstanceButtonToggle(DNAInstance[instanceNum][1], DNAInstance[instanceNum][5])
    for i, v in ipairs(DNAInstance) do
      ddBossList[DNAInstance[i][1]]:Hide()
      DN:Notification("Please select a boss or trash pack!          [P2]", true)
    end
    ddBossList[DNAInstance[instanceNum][1]]:Show()
  end

  DN:Debug("DN:GetProfileVars()")
end

DNAFrameMain = CreateFrame("Frame", "DNAFrameMain", UIParent, "BackdropTemplate")
DNAFrameMain:SetWidth(DNAGlobal.width)
DNAFrameMain:SetHeight(DNAGlobal.height)
DNAFrameMain:SetPoint("CENTER", 20, 60)
DNAFrameMain.title = CreateFrame("Frame", nil, DNAFrameMain, "BackdropTemplate")
DNAFrameMain.title:SetWidth(DNAGlobal.width)
DNAFrameMain.title:SetHeight(34)
DNAFrameMain.title:SetPoint("TOPLEFT", 0, 5)
DNAFrameMain.title:SetFrameLevel(3)
DNAFrameMain.title:SetBackdrop({
  bgFile = DNAGlobal.backdrop,
  edgeFile = DNAGlobal.border,
  edgeSize = 26,
  tile = true,
  insets = {left=2, right=2, top=2, bottom=2},
})
DNAFrameMain.title:SetBackdropColor(0.5, 0.5, 0.5)
DNAFrameMain.text = DNAFrameMain.title:CreateFontString(nil, "ARTWORK")
DNAFrameMain.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize+1, "OUTLINE")
DNAFrameMain.text:SetPoint("TOPLEFT", 20, -10)
DNAFrameMain.text:SetText(DNAGlobal.name)
DNAFrameMain.text:SetTextColor(1.0, 1.0, 0.5)
DNAFrameMain.version = DNAFrameMain.title:CreateFontString(nil, "ARTWORK")
DNAFrameMain.version:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DNAFrameMain.version:SetPoint("TOPLEFT", 250, -12)
DNAFrameMain.version:SetText("v" .. DNAGlobal.version)
DNAFrameMain.version:SetTextColor(0.8, 0.8, 0.8)
DNAFrameMain:SetBackdrop({
  bgFile = DNAGlobal.backdrop,
  edgeFile = DNAGlobal.border,
  edgeSize = 26,
  tile = true,
  tileSize = 480,
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
  DN:Close()
end)
--[==[
DNAButtonMainSettings = CreateFrame("Button", nil, DNAFrameMain.title, "UIPanelButtonTemplate")
DNAButtonMainSettings:SetSize(25, 24)
DNAButtonMainSettings:SetPoint("TOPLEFT", DNAGlobal.width-52, -4)
DNAButtonMainSettingsIcon= DNAButtonMainSettings:CreateTexture(nil, "ARTWORK")
DNAButtonMainSettingsIcon:SetTexture("Interface/Buttons/UI-OptionsButton")
DNAButtonMainSettingsIcon:SetSize(14, 14)
DNAButtonMainSettingsIcon:SetPoint("TOPLEFT", 5, -5)
DNAButtonMainSettings:SetScript("OnClick", function()
  DN:Close()
end)
]==]--

DNAFrameMain:SetMovable(true)
DNAFrameMain:EnableMouse(true)
DNAFrameMain:RegisterForDrag("LeftButton")
DNAFrameMain:SetScript("OnDragStart", function()
  DNAFrameMain:StartMoving()
end)
DNAFrameMain:SetScript("OnDragStop", function()
  DNAFrameMain:StopMovingOrSizing()
  local point, relativeTo, relativePoint, xOfs, yOfs = DNAFrameMain:GetPoint()
  DN:Debug("MAIN Pos: " .. point .. "," .. xOfs .. "," .. yOfs)
  DNA[player.combine]["CONFIG"]["MAINPOS"] = point .. "," .. xOfs .. "," .. yOfs
end)
DNAFrameMain:EnableKeyboard(true)
tinsert(UISpecialFrames, "DNAFrameMain")
DNAFrameMain.enter = CreateFrame("EditBox", nil, DNAFrameMain, "BackdropTemplate")
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

for i,v in pairs(DNAPages) do
  page[v] = CreateFrame("Frame", nil, DNAFrameMain)
  page[v]:SetWidth(DNAGlobal.width)
  page[v]:SetHeight(DNAGlobal.height)
  page[v]:SetPoint("TOPLEFT", 0, 0)
  page[v]:Hide()
  --DN:Debug(v[1])
end

--pagePreBuildDisable = CreateFrame("Frame", pagePreBuildDisable, page["Assignment"], "ThinBorderTemplate")
pagePreBuildDisable = CreateFrame("Frame", pagePreBuildDisable, page["Assignment"])
pagePreBuildDisable:SetWidth(100)
pagePreBuildDisable:SetHeight(100)
pagePreBuildDisable:SetPoint("TOPLEFT", 0, 0)

local pageAssignBtnDiv={}

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
pageBanner.text:SetFont("Fonts/MORPHEUS.ttf", 23, "OUTLINE")
pageBanner.text:SetText(DNAInstance[1][2]) --default
pageBanner.text:SetTextColor(1.00, 1.00, 0.60)
pageBanner.text:SetPoint("TOPLEFT", pageBanner, "TOPLEFT", 20, -8)
pageBossIcon = page["Assignment"]:CreateTexture(nil, "ARTWORK")
pageBossIcon:SetTexture(DNAInstance[1][4]) --default
pageBossIcon:SetSize(134, 70)
pageBossIcon:SetPoint("TOPLEFT", 590, -52)

DNAFrameMainNotif = CreateFrame("Frame", nil, DNAFrameMain, "BackdropTemplate")
DNAFrameMainNotif:SetSize(500, 40)
DNAFrameMainNotif:SetPoint("CENTER", 0, 300)
DNAFrameMainNotif:SetFrameStrata("DIALOG")
DNAFrameMainNotifText = DNAFrameMainNotif:CreateFontString(nil, "OVERLAY")
DNAFrameMainNotifText:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
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


--[==[
local DNAFrameRaidSettingsBG = CreateFrame("Frame", nil, page["Settings"], "InsetFrameTemplate")
DNAFrameRaidSettingsBG:SetSize(DNAGlobal.width-10, DNAGlobal.height-5)
DNAFrameRaidSettingsBG:SetPoint("TOPLEFT", 6, 0)
DNAFrameRaidSettingsBG:SetFrameLevel(2)
]==]--

DN:FrameBorder("PROFILE", page["Settings"], 20, 50, 350, 30)
local profileMessage = page["Settings"]:CreateFontString(nil, "ARTWORK")
profileMessage:SetFont(DNAGlobal.font, DNAGlobal.fontSize+1, "OUTLINE")
profileMessage:SetText(player.combine)
profileMessage:SetPoint("TOPLEFT", 30, -60)

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

for i=1, MAX_FRAME_LINES do
  DNAFrameViewScrollChild_mark[i] = DNAViewScrollChildFrame:CreateTexture(nil, "ARTWORK")
  DNAFrameViewScrollChild_mark[i]:SetSize(16, 16)
  DNAFrameViewScrollChild_mark[i]:SetPoint("TOPLEFT", 5, (-i*18)+13)
  DNAFrameViewScrollChild_mark[i]:SetTexture("")

  DNAFrameViewScrollChild_tank[i] = DNAViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAFrameViewScrollChild_tank[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNAFrameViewScrollChild_tank[i]:SetText("")
  DNAFrameViewScrollChild_tank[i]:SetPoint("TOPLEFT", 25, (-i*18)+10)

  DNAFrameViewScrollChild_heal[i] = DNAViewScrollChildFrame:CreateFontString(nil, "ARTWORK")
  DNAFrameViewScrollChild_heal[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
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

DNAFramePreset = CreateFrame("Frame", nil, page["Assignment"], "InsetFrameTemplate")
DNAFramePreset:SetWidth(viewFrame_w-20)
DNAFramePreset:SetHeight(viewFrame_h-80)
DNAFramePreset:SetPoint("TOPLEFT", viewFrame_x+5, -viewFrame_y-20)

local DNAFramePresetDivider = DNAFramePreset:CreateTexture(nil, "ARTWORK")
DNAFramePresetDivider:SetTexture("Interface/FrameGeneral/!UI-Frame")
DNAFramePresetDivider:SetSize(10, 320)
DNAFramePresetDivider:SetPoint("TOPLEFT", 180, 0)

function DNAFrameClassAssignTextbox(name, pos_y)
  local edit_w = 225
  local edit_h = 25
  local DNAFrameClassAssignBorder = CreateFrame("Frame", nil, DNAFrameClassAssignView, "BackdropTemplate")
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
  DNAFrameClassAssignLabel:SetFont(DNAGlobal.font, DNAGlobal.fontSize+1, "OUTLINE")
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

function DN:CheckBox(checkID, checkName, parentFrame, posX, posY, tooltip)
  local check_static = CreateFrame("CheckButton", nil, parentFrame, "ChatConfigCheckButtonTemplate")
  check_static:SetPoint("TOPLEFT", posX+10, -posY-5)
  check_static.text = check_static:CreateFontString(nil,"ARTWORK")
  check_static.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  check_static.text:SetPoint("TOPLEFT", check_static, "TOPLEFT", 25, -5)
  check_static.text:SetText(checkName)
  --check_static.tooltip = checkName
  check_static:SetScript("OnClick", function()
    if (DNA[player.combine]["CONFIG"][checkID] == "ON") then
      DNA[player.combine]["CONFIG"][checkID] = "OFF"
      if (checkID == "MMICONHIDE") then
        DNAMiniMap:Show()
      end
      if (checkID == "MMICONUNLOCK") then
        DN:ResetMiniMapIcon()
        DN:Debug("UNLOCKICON disabled")
      end
    else
      DNA[player.combine]["CONFIG"][checkID] = "ON"
      if (checkID == "MMICONHIDE") then
        DNAMiniMap:Hide()
      end
      if (checkID == "MMICONUNLOCK") then
        DN:Debug("UNLOCKICON enabled")
      end
    end
  end)
  DNACheckbox[checkID] = check_static
  if (tooltip) then
    DN:ToolTip(DNACheckbox[checkID], tooltip, 110, -10)
  end
end

local frameBorderName = "RAID OPTIONS"
DN:FrameBorder(frameBorderName, page["Settings"], 20, 110, 350, 100)
DN:CheckBox("AUTOPROMOTE", "Auto Promote Guild Officers in Raid", DNAFrameBackBorder[frameBorderName], 0, 0, "Auto Promote guild officers to raid assistants.\nMust be Raid Lead.")
DN:CheckBox("RAIDCHAT", "Assign Marks To Raid Chat", DNAFrameBackBorder[frameBorderName], 0, 20, "Post to Raid chat as well as the screen assignments.")
DN:CheckBox("LOGATTENDANCE", "Log Raid Attendance", DNAFrameBackBorder[frameBorderName], 0, 40, " Log Raid Attendance ")

local frameBorderName = "DIALOG / UI"
DN:FrameBorder("DIALOG / UI", page["Settings"], 20, 240, 350, 110)
DN:CheckBox("HIDEASSIGNCOMBAT", "Hide Personal Assignments After Combat", DNAFrameBackBorder[frameBorderName], 0, 0, "Hide the Personal Assignments window once combat has ended.")
DN:CheckBox("SMALLASSIGNCOMBAT", "Small Personal Assignment Window", DNAFrameBackBorder[frameBorderName], 0, 20, "Size down the Personal Assignments window.")
DN:CheckBox("MMICONHIDE", "Hide The Minimap Icon", DNAFrameBackBorder[frameBorderName], 0, 40, "Hide the minimap icon.\nMust use '/dna' to re-enable.")

local DNAFrameRaidDetailsBG = CreateFrame("Frame", nil, page["Attendance"], "InsetFrameTemplate")
DNAFrameRaidDetailsBG:SetSize(190, DNAGlobal.height-100)
DNAFrameRaidDetailsBG:SetPoint("TOPLEFT", 20, -50)
DNAFrameRaidDetailsBG:SetFrameLevel(2)
local DNAFrameRaidDetailsText = page["Attendance"]:CreateFontString(nil, "ARTWORK")
DNAFrameRaidDetailsText:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAFrameRaidDetailsText:SetPoint("TOPLEFT", page["Attendance"], "TOPLEFT", 40, -33)
DNAFrameRaidDetailsText:SetText("CURRENT RAID COMP")
DNAFrameRaidDetailsText:SetTextColor(1, 1, 1)

for i=1, 50 do
  pageRaidDetailsColOne[i] = page["Attendance"]:CreateFontString(nil, "ARTWORK")
  pageRaidDetailsColOne[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  pageRaidDetailsColOne[i]:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", 30, (-i*14)-50)
  pageRaidDetailsColOne[i]:SetText("")
  pageRaidDetailsColOne[i]:SetTextColor(1, 1, 1)

  pageRaidDetailsColTwo[i] = page["Attendance"]:CreateFontString(nil, "ARTWORK")
  pageRaidDetailsColTwo[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  pageRaidDetailsColTwo[i]:SetPoint("TOPLEFT", DNAFrameMain, "TOPLEFT", 170, (-i*14)-50)
  pageRaidDetailsColTwo[i]:SetText("")
  pageRaidDetailsColTwo[i]:SetTextColor(0.9, 0.9, 0.9)
end

--send the network data, then save after
local function updateSlotPos(role, i, name)
  if (DN:RaidPermission()) then
    DN:SendPacket(role .. i .. "," .. name, true)
    DN:SendPacket(packetPrefix.author .. player.name, true)
    DN:SendPacket(packetPrefix.version .. DNAGlobal.version, true)
    DN:Debug("updateSlotPos(...)")
  end
end

DNAFrameMain:Hide()

local DNAFrameInstanceBG = CreateFrame("Frame", nil, page["Assignment"], "InsetFrameTemplate")
DNAFrameInstanceBG:SetSize(194, DNAGlobal.height-6)
DNAFrameInstanceBG:SetPoint("TOPLEFT", 6, 0)
DNAFrameInstanceBG:SetFrameLevel(2)

local instanceButton_x = 22
function DN:InstanceButton(name, pos_y, longtext, icon)
  local instanceButton_w = 160
  local instanceButton_h = 70
  DNAFrameInstance[name] = CreateFrame("Frame", nil, page["Assignment"], "BackdropTemplate")
  DNAFrameInstance[name]:SetSize(instanceButton_w, instanceButton_h)
  DNAFrameInstance[name]:SetPoint("TOPLEFT", instanceButton_x, -pos_y+42)
  DNAFrameInstanceText[name] = DNAFrameInstance[name]:CreateFontString(nil, "OVERLAY")
  DNAFrameInstanceText[name]:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNAFrameInstanceText[name]:SetPoint("CENTER", 0, -22)
  DNAFrameInstanceText[name]:SetText(longtext)
  DNAFrameInstanceText[name]:SetTextColor(1, 1, 1)
  DNAFrameInstanceScript[name] = CreateFrame("Button", nil, DNAFrameInstance[name])
  DNAFrameInstanceScript[name]:SetSize(instanceButton_w, instanceButton_h)
  DNAFrameInstanceScript[name]:SetPoint("CENTER", 0, 2)
  DNAFrameInstanceScript[name]:SetScript("OnClick", function()
    DN:ClearNotifications()
    for i, v in ipairs(DNAInstance) do
      ddBossList[DNAInstance[i][1]]:Hide() --hide all dropdowns
    end
    local instanceNum = multiKeyFromValue(DNAInstance, name)
    DN:ClearFrameView()
    DN:InstanceButtonToggle(name, icon)
    DNA[player.combine]["CONFIG"]["RAID"] = name
    ddBossList[name]:Show()
    ddBossListText[name]:SetText("")
  end)
  DNAFrameInstanceShadow[name] = DNAFrameInstance[name]:CreateTexture(nil, "BACKGROUND", DNAFrameInstance[name], 1)
  DNAFrameInstanceShadow[name]:SetTexture("Interface/ACHIEVEMENTFRAME/UI-Achievement-HorizontalShadow")
  DNAFrameInstanceShadow[name]:SetSize(instanceButton_w-4, instanceButton_h-4)
  DNAFrameInstanceShadow[name]:SetPoint("TOPLEFT", 2, -2)
  DNAFrameInstanceShadow[name]:Hide()
end

--draw all tabs in order
for i, v in ipairs(DNAInstance) do
  DN:InstanceButton(DNAInstance[i][1], i*72, DNAInstance[i][2], DNAInstance[i][5])
end

local expInstanceButtonPos=1
for i, v in ipairs(DNAInstance) do
  if (DNAInstance[i][8] == expansionTabs[2][1]) then
    expInstanceButtonPos=expInstanceButtonPos+1
    DNAFrameInstance[DNAInstance[i][1]]:SetPoint("TOPLEFT", instanceButton_x, -(expInstanceButtonPos*72)+114)
  end
end

local function bottomTabToggle(name)
  for i,v in pairs(DNAPages) do
    DNAFrameMainBottomTab[v]:SetFrameStrata("LOW")
    DNAFrameMainBottomTab[v].text:SetTextColor(0.7, 0.7, 0.7)
    page[v]:Hide()
  end
  DNAFrameMainBottomTab[name]:SetFrameStrata("MEDIUM")
  DNAFrameMainBottomTab[name].text:SetTextColor(1.0, 1.0, 0.5)
  page[name]:Show()

  pagePreBuildDisable:Hide()

  --onPage = name
  --DN:Debug("Page: " .. onPage)
  for i,v in pairs(expansionTabs) do
    expTab[v[1]]:Hide()
  end
  if (name == "Assignment") then
    for i,v in pairs(expansionTabs) do
      expTab[v[1]]:Show()
    end
  end
end

local bottomTabCount = 1
local function bottomTab(name)
  local tabWidth = 110
  local tabHeight = 30
  if (bottomTabCount > 1) then
    bottomTabCount = bottomTabCount + tabWidth-14
  else
    bottomTabCount = bottomTabCount +8
  end
  DN:Debug(bottomTabCount)
  DNAFrameMainBottomTab[name] = CreateFrame("Frame", nil, DNAFrameMain)
  DNAFrameMainBottomTab[name]:SetPoint("BOTTOMLEFT", bottomTabCount, -39)
  DNAFrameMainBottomTab[name]:SetWidth(tabWidth)
  DNAFrameMainBottomTab[name]:SetHeight(tabHeight*2)
  DNAFrameMainBottomTab[name]:SetFrameStrata("LOW")
  DNAFrameMainBottomTab[name].text = DNAFrameMainBottomTab[name]:CreateFontString(nil, "ARTWORK")
  DNAFrameMainBottomTab[name].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNAFrameMainBottomTab[name].text:SetText(name)
  DNAFrameMainBottomTab[name].text:SetTextColor(0.8, 0.8, 0.8)
  DNAFrameMainBottomTab[name].text:SetPoint("CENTER", DNAFrameMainBottomTab[name], "CENTER", 0, 0)

  local botBorder = DNAFrameMainBottomTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  botBorder:SetTexture(DNAGlobal.tabborder)
  botBorder:SetSize(tabWidth, tabHeight+8)
  botBorder:SetPoint("TOPLEFT", 0, -13)
  DNAFrameMainBottomTabScript={}
  DNAFrameMainBottomTabScript[name] = CreateFrame("Button", nil, DNAFrameMainBottomTab[name])
  DNAFrameMainBottomTabScript[name]:SetSize(tabWidth-14, tabHeight)
  DNAFrameMainBottomTabScript[name]:SetPoint("CENTER", 0, 0)
  DNAFrameMainBottomTabScript[name]:SetScript("OnClick", function()
    DN:ClearNotifications()
    bottomTabToggle(name)
  end)
  --[==[
  DNAFrameMainBottomTabScript[name]:SetBackdrop({
    bgFile="green",
    edgeFile="",
    edgeSize = 2,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  ]==]--
end

local tabBack = {}
local tabLogo = {}
function expTabInactive()
  for i,v in pairs(expansionTabs) do
    expTab[v[1]]:SetFrameLevel(0)
  end
end
function expTabActive(name)
  expTabInactive() --reset all
  expTab[name]:SetFrameLevel(5)
  for i, v in ipairs(DNAInstance) do
    DNAFrameInstance[DNAInstance[i][1]]:Hide()
  end
  for i, v in ipairs(DNAInstance) do
    if (DNAInstance[i][8] == name) then
      DNAFrameInstance[DNAInstance[i][1]]:Show()
    end
  end
end

function expansionTab(name, backdrop, pos_y)
  expTab[name] = CreateFrame("Frame", nil, DNAFrameMain)
  expTab[name]:SetPoint("TOPLEFT", -31, -pos_y+55)
  expTab[name]:SetSize(50, 94)
  expTab[name]:SetFrameLevel(0)
  tabBack[name] = expTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  tabBack[name]:SetTexture(DNAGlobal.tabborder)
  tabBack[name]:SetSize(100, 40)
  tabBack[name]:SetPoint("TOPLEFT", -30, -28)
  tabBack[name]:SetRotation(math.rad(270))
  tabLogo[name] = expTab[name]:CreateTexture(nil, "OVERLAY", nil, 0)
  tabLogo[name]:SetTexture(backdrop)
  tabLogo[name]:SetSize(70, 45)
  tabLogo[name]:SetPoint("TOPLEFT", -10, -25)
  tabLogo[name]:SetRotation(math.rad(90))
  tabScript = {}
  tabScript[name] = CreateFrame("Button", nil, expTab[name], nil)
  tabScript[name]:SetSize(40, 90)
  tabScript[name]:SetPoint("CENTER", -4, -2)
  tabScript[name]:SetScript("OnClick", function()
    expTabActive(name)
    DNA[player.combine]["CONFIG"]["EXP"] = name
  end)
  --[==[
  tabScript[name]:SetBackdrop({
    bgFile="green",
    edgeFile="",
    edgeSize = 2,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  ]==]--
end

for i,v in pairs(expansionTabs) do
  expansionTab(v[1], v[2], i*90)
end
expTabActive("Classic") --default

DN:ResetQueueTransposing()

local clearQueuePrompt=""
local function clearQueue()
  if (DN:RaidPermission()) then
    if (clearQueuePrompt == "Heal") then
      healSlotFrame:Hide()
      for i=1, DNASlots.heal do
        healSlot[i].text:SetText("Empty")
      end
      healSlotFrameClear:Hide()
    end
    if (clearQueuePrompt == "Tank") then
      tankSlotFrame:Hide()
      for i=1, DNASlots.tank do
        tankSlot[i].text:SetText("Empty")
      end
      tankSlotFrameClear:Hide()
    end
    if (clearQueuePrompt == "CC") then
      ccSlotFrame:Hide()
      for i=1, DNASlots.cc do
        ccSlot[i].text:SetText("Empty")
      end
      ccSlotFrameClear:Hide()
    end
    DN:UpdateRaidRoster()
    DN:RaidSendAssignments()
    tankSlotFrame:Show()
    healSlotFrame:Show()
    ccSlotFrame:Show()
  end
end

ddPreBuildMenu = {"Raid", "Guild"}
ddPreBuild = CreateFrame("Frame", nil, page["Assignment"], "UIDropDownMenuTemplate")
--ddPreBuild:SetFrameLevel(50)
ddPreBuild:SetPoint("TOPLEFT", 193, -24)
--ddBossList[DNAInstance[i][1]].displayMode = "MENU"
ddPreBuild.text = ddPreBuild:CreateFontString(nil, "ARTWORK")
ddPreBuild.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
ddPreBuild.text:SetPoint("TOPLEFT", ddPreBuild, "TOPLEFT", 25, -8)
ddPreBuild.text:SetText(ddPreBuildMenu[1])
ddPreBuild.onClick = function(self, checked)
  ddPreBuild.text:SetText(self.value)
  --print("click")
end
ddPreBuild.initialize = function(self, level)
  local info = UIDropDownMenu_CreateInfo()
  local i = 0
  for k,v in pairs(ddPreBuildMenu) do
    info.notCheckable = 1
    info.padding = 100
    info.text = v
    info.value= v
    info.fontObject = GameFontWhite
    info.justifyH = "LEFT"
    info.disabled = false
    info.func = self.onClick
    UIDropDownMenu_AddButton(info, level)
  end
end
UIDropDownMenu_SetWidth(ddPreBuild, DNARaidScrollFrame_w+4)

DNARaidScrollFrame = CreateFrame("Frame", DNARaidScrollFrame, page["Assignment"], "InsetFrameTemplate")
DNARaidScrollFrame:SetWidth(DNARaidScrollFrame_w+20) --add scroll frame width
DNARaidScrollFrame:SetHeight(DNARaidScrollFrame_h-4)
DNARaidScrollFrame:SetPoint("TOPLEFT", 210, -50)
--[==[
DNARaidScrollFrame.icon = DNARaidScrollFrame:CreateTexture(nil, "OVERLAY")
DNARaidScrollFrame.icon:SetTexture(DNAGlobal.dir .. "images/role_dps")
DNARaidScrollFrame.icon:SetPoint("TOPLEFT", 35, 20)
DNARaidScrollFrame.icon:SetSize(20, 20)
]==]--
DNARaidScrollFrame:SetFrameLevel(5)
DNARaidScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNARaidScrollFrame, "UIPanelScrollFrameTemplate")
DNARaidScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNARaidScrollFrame, "TOPLEFT", 3, -3)
DNARaidScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNARaidScrollFrame, "BOTTOMRIGHT", 10, 4)
DNARaidScrollFrameScrollChildFrame = CreateFrame("Frame", DNARaidScrollFrameScrollChildFrame, DNARaidScrollFrame.ScrollFrame)
DNARaidScrollFrameScrollChildFrame:SetSize(DNARaidScrollFrame_w, DNARaidScrollFrame_h)
--[==[
DNARaidScrollFrame.text = DNARaidScrollFrame:CreateFontString(nil, "ARTWORK")
DNARaidScrollFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNARaidScrollFrame.text:SetPoint("CENTER", DNARaidScrollFrame, "TOPLEFT", 75, 10)
DNARaidScrollFrame.text:SetText("Raid")
]==]--

DNARaidScrollFrame.ScrollFrame:SetScrollChild(DNARaidScrollFrameScrollChildFrame)
DNARaidScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNARaidScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNARaidScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNARaidScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNARaidScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNARaidScrollFrame.MR = DNARaidScrollFrame:CreateTexture(nil, "BACKGROUND", DNARaidScrollFrame, -2)
DNARaidScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNARaidScrollFrame.MR:SetPoint("TOPLEFT", DNARaidScrollFrame_w-5, 0)
DNARaidScrollFrame.MR:SetSize(24, DNARaidScrollFrame_h-5)
DNARaidScrollFrame:SetScript("OnEnter", function()
  DN:ResetQueueTransposing()
end)
DNARaidScrollFrame:SetScript("OnLeave", function()
  DN:ResetQueueTransposing()
end)

DNAFrameMainAuthor = page["Assignment"]:CreateFontString(nil, "ARTWORK")
DNAFrameMainAuthor:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DNAFrameMainAuthor:SetPoint("TOPLEFT", 210, -DNAGlobal.height+25)
DNAFrameMainAuthor:SetText("Last Update:")
DNAFrameMainAuthor:SetTextColor(0.9, 0.9, 0.9)
DNAFrameMainAuthor:Hide()

local slotDialog = CreateFrame("Frame", nil, DNAFrameMain, "BackdropTemplate")
slotDialog:SetWidth(400)
slotDialog:SetHeight(100)
slotDialog:SetPoint("CENTER", 0, 50)
slotDialog:SetBackdrop({
  bgFile   = "Interface/Tooltips/CHATBUBBLE-BACKGROUND",
  edgeFile = DNAGlobal.border,
  edgeSize = 22,
  insets = {left=2, right=2, top=2, bottom=2},
})
slotDialog.text = slotDialog:CreateFontString(nil, "ARTWORK")
slotDialog.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
slotDialog.text:SetPoint("CENTER", slotDialog, "CENTER", 0, 20)
slotDialog.text:SetText("")
slotDialog:SetFrameLevel(150)
slotDialog:SetFrameStrata("FULLSCREEN_DIALOG")
local slotDialogNo = CreateFrame("Button", nil, slotDialog, "UIPanelButtonTemplate")
slotDialogNo:SetSize(100, 24)
slotDialogNo:SetPoint("CENTER", -60, -20)
slotDialogNo.text = slotDialogNo:CreateFontString(nil, "ARTWORK")
slotDialogNo.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
slotDialogNo.text:SetPoint("CENTER", slotDialogNo, "CENTER", 0, 0)
slotDialogNo.text:SetText("No")
slotDialogNo:SetScript('OnClick', function()
  slotDialog:Hide()
end)
local slotDialogYes = CreateFrame("Button", nil, slotDialog, "UIPanelButtonTemplate")
slotDialogYes:SetSize(100, 24)
slotDialogYes:SetPoint("CENTER", 60, -20)
slotDialogYes.text = slotDialogYes:CreateFontString(nil, "ARTWORK")
slotDialogYes.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
slotDialogYes.text:SetPoint("CENTER", slotDialogYes, "CENTER", 0, 0)
slotDialogYes.text:SetText("Yes")
slotDialogYes:SetScript('OnClick', function()
  clearQueue(true)
  slotDialog:Hide()
end)
slotDialog:Hide()

local function shiftSlot(current, pos)
  if (DN:RaidPermission()) then
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
  end
end

local tankSlotOrgPoint_x={}
local tankSlotOrgPoint_y={}
tankSlotFrame = CreateFrame("Frame", tankSlotFrame, page["Assignment"], "InsetFrameTemplate")
tankSlotFrame:SetWidth(DNARaidScrollFrame_w+6)
tankSlotFrame:SetHeight((DNASlots.tank*19)+1)
tankSlotFrame:SetPoint("TOPLEFT", 380, -50)
tankSlotFrame.text = tankSlotFrame:CreateFontString(nil, "ARTWORK")
tankSlotFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
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

for i=1, DNASlots.tank do
  tankSlot[i] = CreateFrame("Button", tankSlot[i], tankSlotFrame, "BackdropTemplate")
  tankSlot[i]:SetWidth(DNARaidScrollFrame_w)
  tankSlot[i]:SetHeight(raidSlot_h)
  tankSlotOrgPoint_y[i] = (-i*18)+16 --top padding
  tankSlot[i]:SetPoint("TOPLEFT", 3, tankSlotOrgPoint_y[i])
  tankSlot[i].icon = tankSlot[i]:CreateTexture(nil, "OVERLAY")
  tankSlot[i].icon:SetTexture("")
  tankSlot[i].icon:SetPoint("TOPLEFT", 4, -4)
  tankSlot[i].icon:SetSize(12, 12)
  tankSlot[i].text = tankSlot[i]:CreateFontString(tankSlot[i], "ARTWORK")
  tankSlot[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  tankSlot[i].text:SetPoint("CENTER", 0, 0)
  tankSlot[i].text:SetText("Empty")
  tankSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  tankSlot[i]:SetBackdrop({
    bgFile   = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
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
      DN:ResetQueueTransposing()
      swapQueue[TANK] = i
    end
  end)
  tankSlot[i]:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", 3, tankSlotOrgPoint_y[i])
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
        DN:ResetQueueTransposing()
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
DN:ToolTip(tankSlotFrameClear, "Clear Tank Queue")

local healSlotOrgPoint_x={}
local healSlotOrgPoint_y={}
healSlotFrame = CreateFrame("Frame", healSlotFrame, page["Assignment"], "InsetFrameTemplate")
healSlotFrame:SetWidth(DNARaidScrollFrame_w+6)
healSlotFrame:SetHeight((DNASlots.heal*19)-4)
healSlotFrame:SetPoint("TOPLEFT", 380, -192)
healSlotFrame.text = healSlotFrame:CreateFontString(nil, "ARTWORK")
healSlotFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
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
DN:ToolTip(healSlotFrameClear, "Clear Healer Queue")

for i=1, DNASlots.heal do
  healSlot[i] = CreateFrame("Button", healSlot[i], healSlotFrame, "BackdropTemplate")
  healSlot[i]:SetWidth(DNARaidScrollFrame_w)
  healSlot[i]:SetHeight(raidSlot_h)
  healSlotOrgPoint_y[i] = (-i*18)+16
  healSlot[i]:SetPoint("TOPLEFT", 3, healSlotOrgPoint_y[i])
  healSlot[i].icon = healSlot[i]:CreateTexture(nil, "OVERLAY")
  healSlot[i].icon:SetTexture("")
  healSlot[i].icon:SetPoint("TOPLEFT", 4, -4)
  healSlot[i].icon:SetSize(12, 12)
  healSlot[i].text = healSlot[i]:CreateFontString(healSlot[i], "ARTWORK")
  healSlot[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  healSlot[i].text:SetPoint("CENTER", 0, 0)
  healSlot[i].text:SetText("Empty")
  healSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  healSlotUp[i] = CreateFrame("Button", nil, healSlot[i], "UIPanelButtonTemplate")
  healSlotUp[i]:SetPoint("TOPLEFT", DNARaidScrollFrame_w+16, 0)
  healSlotUp[i]:SetSize(20, 18)
  healSlotUp[i]:SetScript("OnClick", function()
    shiftSlot(i, "up")
  end)
  DN:ToolTip(healSlotUp[i], "Move Up")
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
  DN:ToolTip(healSlotDown[i], "Move Down")
  local healSlotDownIcon = healSlotDown[i]:CreateTexture(nil, "OVERLAY")
  healSlotDownIcon:SetTexture("Interface/MainMenuBar/UI-MainMenu-ScrollDownButton-Up")
  healSlotDownIcon:SetPoint("TOPLEFT", -3, 5)
  healSlotDownIcon:SetSize(27, 30)
  healSlot[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
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
      DN:ResetQueueTransposing()
      swapQueue[HEAL] = i
      memberDrag = healSlot[i].text:GetText()
    end
  end)
  healSlot[i]:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", 3, healSlotOrgPoint_y[i])
    updateSlotPos(HEAL, i, "Empty")
  end)
  healSlot[i]:SetScript('OnEnter', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
    end
    if (memberDrag) then
      updateSlotPos(HEAL, i, memberDrag)
    end
  end)
  healSlot[i]:SetScript('OnLeave', function()
    if (healSlot[i].text:GetText() ~= "Empty") then
      healSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
    end
    memberDrag = nil
  end)
end

healSlotUp[DNASlots.heal]:SetPoint("TOPLEFT", DNARaidScrollFrame_w, 0) --last up button slide to left


local ccSlotOrgPoint_x={}
local ccSlotOrgPoint_y={}
ccSlotFrame = CreateFrame("Frame", ccSlotFrame, page["Assignment"], "InsetFrameTemplate")
ccSlotFrame:SetWidth(DNARaidScrollFrame_w+6)
ccSlotFrame:SetHeight((DNASlots.cc*19)+1)
ccSlotFrame:SetPoint("TOPLEFT", 380, -450)
ccSlotFrame.text = ccSlotFrame:CreateFontString(nil, "ARTWORK")
ccSlotFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
ccSlotFrame.text:SetPoint("CENTER", ccSlotFrame, "TOPLEFT", 71, 10)
ccSlotFrame.text:SetText("Designated")
ccSlotFrame.icon = ccSlotFrame:CreateTexture(nil, "OVERLAY")
ccSlotFrame.icon:SetTexture(DNAGlobal.dir .. "images/role_raid")
ccSlotFrame.icon:SetPoint("TOPLEFT", 5, 20)
ccSlotFrame.icon:SetSize(20, 20)
ccSlotFrame:SetFrameLevel(2)
ccSlotFrameClear = CreateFrame("Button", nil, ccSlotFrame, "UIPanelButtonTemplate")
ccSlotFrameClear:SetPoint("TOPLEFT", DNARaidScrollFrame_w-20, 20)
ccSlotFrameClear:SetSize(20, 18)
local ccSlotFrameClearIcon = ccSlotFrameClear:CreateTexture(nil, "OVERLAY")
ccSlotFrameClearIcon:SetTexture("Interface/Buttons/CancelButton-Up")
ccSlotFrameClearIcon:SetPoint("CENTER", -1, -2)
ccSlotFrameClearIcon:SetSize(31, 31)
ccSlotFrameClear:SetScript("OnClick", function()
  clearQueuePrompt = "CC"
  slotDialog.text:SetText("Clear out the Designated queue?\nThis will reset the raids assignments!")
  slotDialog:Show()
end)
ccSlotFrameClear:Hide()

for i=1, DNASlots.cc do
  ccSlot[i] = CreateFrame("Button", ccSlot[i], ccSlotFrame, "BackdropTemplate")
  ccSlot[i]:SetWidth(DNARaidScrollFrame_w)
  ccSlot[i]:SetHeight(raidSlot_h)
  ccSlotOrgPoint_y[i] = (-i*18)+16 --top padding
  ccSlot[i]:SetPoint("TOPLEFT", 3, ccSlotOrgPoint_y[i])
  ccSlot[i].icon = ccSlot[i]:CreateTexture(nil, "OVERLAY")
  ccSlot[i].icon:SetTexture("")
  ccSlot[i].icon:SetPoint("TOPLEFT", 4, -4)
  ccSlot[i].icon:SetSize(12, 12)
  ccSlot[i].text = ccSlot[i]:CreateFontString(ccSlot[i], "ARTWORK")
  ccSlot[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  ccSlot[i].text:SetPoint("CENTER", 0, 0)
  ccSlot[i].text:SetText("Empty")
  ccSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  ccSlot[i]:SetBackdrop({
    bgFile   = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
  	insets = {left=2, right=2, top=2, bottom=2},
  })
  ccSlot[i].ready = ccSlot[i]:CreateTexture(nil, "OVERLAY")
  ccSlot[i].ready:SetTexture("")
  ccSlot[i].ready:SetPoint("TOPLEFT", DNARaidScrollFrame_w-21, -4)
  ccSlot[i].ready:SetSize(12, 12)

  --ccSlot[i]:SetBackdropColor(1, 1, 1, 0.6)
  ccSlot[i]:SetBackdropColor(0.2, 0.2, 0.2, 1)
  ccSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  ccSlot[i]:SetFrameLevel(2)
  ccSlot[i]:EnableMouse()
  ccSlot[i]:SetMovable(true)
  ccSlot[i]:RegisterForDrag("LeftButton")
  ccSlot[i]:SetScript("OnDragStart", function()
    if (ccSlot[i].text:GetText() ~= "Empty") then
      ccSlot[i]:StartMoving()
      ccSlot[i]:SetFrameStrata("DIALOG")
      DN:ResetQueueTransposing()
      swapQueue[CC] = i
    end
  end)
  ccSlot[i]:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", 3, ccSlotOrgPoint_y[i])
    updateSlotPos(CC, i, "Empty")
  end)
  ccSlot[i]:SetScript('OnEnter', function()
    if (ccSlot[i].text:GetText() ~= "Empty") then
      ccSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
      if (swapQueue[CC] > 0) then
        prevQueue[CC] = i
      end
    end
    if ((swapQueue[CC] > 0) and (prevQueue[CC] > 0)) then --swap positions
      if (swapQueue[CC] ~= prevQueue[CC]) then --dupe check
        if ((ccSlot[swapQueue[CC]].text:GetText() ~= "Empty") and (ccSlot[prevQueue[CC]].text:GetText() ~= "Empty")) then
          updateSlotPos(CC, swapQueue[CC], ccSlot[prevQueue[CC]].text:GetText() )
          updateSlotPos(CC, prevQueue[CC], ccSlot[swapQueue[CC]].text:GetText() )
        end
        DN:ResetQueueTransposing()
        memberDrag = nil
      end
    else
      if (memberDrag) then
        for dupe = 1, DNASlots.tank do
          if (ccSlot[dupe].text:GetText() == memberDrag) then
            updateSlotPos(CC, dupe, "Empty")
            updateSlotPos(CC, i, memberDrag)
            return true
          end
        end
        updateSlotPos(CC, i, memberDrag)
      end
    end
  end)
  ccSlot[i]:SetScript('OnLeave', function()
    if (ccSlot[i].text:GetText() ~= "Empty") then
      ccSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
    end
    memberDrag = nil
  end)
end
DN:ToolTip(ccSlotFrameClear, "Clear Designated Queue")

for i=1, MAX_RAID_SLOTS do
  raidSlotFrame(DNARaidScrollFrameScrollChildFrame, i, i*19)
  raidSlot[i]:Hide()
end

local function viewFrameBottomTabToggle(name)
  viewFrameBotTab["Markers"]:SetFrameLevel(2)
  viewFrameBotTab["Markers"].text:SetTextColor(0.7, 0.7, 0.7)
  viewFrameBotTab["Map"]:SetFrameLevel(2)
  viewFrameBotTab["Map"].text:SetTextColor(0.7, 0.7, 0.7)
  viewFrameBotTab["Preset"]:SetFrameLevel(2)
  viewFrameBotTab["Preset"].text:SetTextColor(0.7, 0.7, 0.7)
  viewFrameBotTab["Class"]:SetFrameLevel(2)
  viewFrameBotTab["Class"].text:SetTextColor(0.7, 0.7, 0.7)
  viewFrameBotTab[name]:SetFrameLevel(5)
  viewFrameBotTab[name].text:SetTextColor(1.0, 1.0, 0.5)
  if (name == "Markers") then
    DNAViewScrollChildFrame:Show()
    DNAFrameView.ScrollFrame:Show()
    DNAFrameViewBossMap:Hide()
    DNAFrameClassAssignView:Hide()
    DNAFramePreset:Hide()
  end
  if (name == "Map") then
    DNAViewScrollChildFrame:Hide()
    DNAFrameView.ScrollFrame:Hide()
    DNAFrameViewBossMap:Show()
    DNAFrameClassAssignView:Hide()
    DNAFramePreset:Hide()
  end
  if (name == "Preset") then
    DNAViewScrollChildFrame:Hide()
    DNAFrameView.ScrollFrame:Hide()
    DNAFrameViewBossMap:Hide()
    DNAFrameClassAssignView:Hide()
    DNAFramePreset:Show()
  end
  if (name == "Class") then
    DNAViewScrollChildFrame:Hide()
    DNAFrameView.ScrollFrame:Hide()
    DNAFrameViewBossMap:Hide()
    DNAFrameClassAssignView:Show()
    DNAFramePreset:Hide()
  end
end

function DN:PresetDuplicate()
  for i=1, DNASlots.tank do
    currentViewTank[i]:SetText(tankSlot[i].text:GetText())
    presetViewTank[i]:SetText(tankSlot[i].text:GetText())
    thisClass = DNARaid["class"][tankSlot[i].text:GetText()]
    DN:ClassColorText(currentViewTank[i], thisClass)
    DN:ClassColorText(presetViewTank[i], thisClass)
    if (tankSlot[i].text:GetText() == "Empty") then
      currentViewTank[i]:SetText("")
      presetViewTank[i]:SetText("")
    end
  end
  for i=1, DNASlots.heal do
    currentViewHeal[i]:SetText(healSlot[i].text:GetText())
    presetViewHeal[i]:SetText(healSlot[i].text:GetText())
    thisClass = DNARaid["class"][healSlot[i].text:GetText()]
    DN:ClassColorText(currentViewHeal[i], thisClass)
    DN:ClassColorText(presetViewHeal[i], thisClass)
    if (healSlot[i].text:GetText() == "Empty") then
      currentViewHeal[i]:SetText("")
      presetViewHeal[i]:SetText("")
    end
  end
  for i=1, DNASlots.cc do
    currentViewCC[i]:SetText(ccSlot[i].text:GetText())
    presetViewCC[i]:SetText(ccSlot[i].text:GetText())
    thisClass = DNARaid["class"][ccSlot[i].text:GetText()]
    DN:ClassColorText(currentViewCC[i], thisClass)
    DN:ClassColorText(presetViewCC[i], thisClass)
    if (ccSlot[i].text:GetText() == "Empty") then
      currentViewCC[i]:SetText("")
      presetViewCC[i]:SetText("")
    end
  end

  DN:Debug("DN:PresetDuplicate()")
end

function DN:PresetClear()
  for i=1, DNASlots.tank do
    currentViewTank[i]:SetText("")
    thisSlot = tankSlot[i].text:GetText()
    if (thisSlot ~= "Empty") then
      currentViewTank[i]:SetText(thisSlot)
      thisClass = DNARaid["class"][thisSlot]
      DN:ClassColorText(currentViewTank[i], thisClass)
    end
    presetViewTank[i]:SetText("")
  end
  for i=1, DNASlots.heal do
    currentViewHeal[i]:SetText("")
    thisSlot = healSlot[i].text:GetText()
    if (thisSlot ~= "Empty") then
      currentViewHeal[i]:SetText(thisSlot)
      thisClass = DNARaid["class"][thisSlot]
      DN:ClassColorText(currentViewHeal[i], thisClass)
    end
    presetViewHeal[i]:SetText("")
  end
  for i=1, DNASlots.cc do
    currentViewCC[i]:SetText("")
    thisSlot = ccSlot[i].text:GetText()
    if (thisSlot ~= "Empty") then
      currentViewCC[i]:SetText(thisSlot)
      thisClass = DNARaid["class"][thisSlot]
      DN:ClassColorText(currentViewCC[i], thisClass)
    end
    presetViewCC[i]:SetText("")
  end
  raidSelection = nil
  btnLoadRaid:Hide()
  noLoadRaidText:Show()
  DN:Debug("DN:PresetClear()")
end

function DN:PresetSelect(selection)
  local getsave={}

  for k,v in pairs(DNA[player.combine]["SAVECONF"][selection]) do
    getsave.key = k
    getsave.role = string.gsub(k, "[^a-zA-Z]", "") --remove numbers
    getsave.slot = string.gsub(k, getsave.role, "")
    getsave.slot = tonumber(getsave.slot)
    getsave.name = v

    if (getsave.role == TANK) then
      if ((getsave.name ~= nil) and (getsave.name ~= "Empty")) then
        presetViewTank[getsave.slot]:SetText(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(presetViewTank[getsave.slot], thisClass)
      end
    end
    if (getsave.role == HEAL) then
      if ((getsave.name ~= nil) and (getsave.name ~= "Empty")) then
        presetViewHeal[getsave.slot]:SetText(getsave.name)
        if (DNARaid["class"][getsave.name]) then
          thisClass = DNARaid["class"][getsave.name]
          DN:ClassColorText(presetViewHeal[getsave.slot], thisClass)
        end
      end
    end
    if (getsave.role == CC) then
      if ((getsave.name ~= nil) and (getsave.name ~= "Empty")) then
        presetViewCC[getsave.slot]:SetText(getsave.name)
        if (DNARaid["class"][getsave.name]) then
          thisClass = DNARaid["class"][getsave.name]
          DN:ClassColorText(presetViewCC[getsave.slot], thisClass)
        end
      end
    end
  end
  healSlotUp[1]:Hide()
  healSlotDown[DNASlots.heal]:Hide()
  DN:Debug("DN:PresetSelect('" .. selection .. "')")
end

local function viewFrameBottomTab(name, pos_x, text_pos_x)
  viewFrameBotTab[name] = CreateFrame("Frame", nil, DNAFrameView)
  viewFrameBotTab[name]:SetPoint("BOTTOMLEFT", pos_x, -44)
  viewFrameBotTab[name]:SetWidth(85)
  viewFrameBotTab[name]:SetHeight(60)
  viewFrameBotTab[name]:SetFrameLevel(2)
  viewFrameBotTab[name].text = viewFrameBotTab[name]:CreateFontString(nil, "ARTWORK")
  viewFrameBotTab[name].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  viewFrameBotTab[name].text:SetText(name)
  viewFrameBotTab[name].text:SetTextColor(0.8, 0.8, 0.8)
  viewFrameBotTab[name].text:SetPoint("CENTER", viewFrameBotTab[name], "CENTER", 9, 0)
  local viewFrameBotBorder ={}
  viewFrameBotBorder[name] = viewFrameBotTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  viewFrameBotBorder[name]:SetTexture(DNAGlobal.tabborder)
  viewFrameBotBorder[name]:SetSize(100, 35)
  viewFrameBotBorder[name]:SetPoint("TOPLEFT", 0, -14)
  local viewFrameBotTabScript={}
  --viewFrameBotTabScript[name] = CreateFrame("Button", nil, viewFrameBotTab[name], "UIPanelButtonTemplate")
  viewFrameBotTabScript[name] = CreateFrame("Button", nil, viewFrameBotTab[name])
  viewFrameBotTabScript[name]:SetSize(85, 30)
  viewFrameBotTabScript[name]:SetPoint("CENTER", 0, 0)
  viewFrameBotTabScript[name]:SetScript("OnClick", function()
    viewFrameBottomTabToggle(name)
  end)
end

viewFrameBottomTab("Markers", 0, 0)
viewFrameBottomTab("Map", 88, 0)
viewFrameBottomTab("Preset", 176, 0)
viewFrameBottomTab("Class", 264, 0)
viewFrameBottomTabToggle("Markers") --default enabled

for i, v in ipairs(DNAInstance) do
  --local icon = _G[button:GetName().."Icon"]
  ddBossList[DNAInstance[i][1]] = CreateFrame("Frame", nil, page["Assignment"], "UIDropDownMenuTemplate")
  ddBossList[DNAInstance[i][1]]:SetPoint("TOPLEFT", 680, -90)
  --ddBossList[DNAInstance[i][1]].displayMode = "MENU"
  ddBossListText[DNAInstance[i][1]] = ddBossList[DNAInstance[i][1]]:CreateFontString(nil, "ARTWORK")
  ddBossListText[DNAInstance[i][1]]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  ddBossListText[DNAInstance[i][1]]:SetPoint("TOPLEFT", ddBossList[DNAInstance[i][1]], "TOPLEFT", 25, -8);
  local instanceNum = multiKeyFromValue(DNAInstance, DNAInstance[i][1])
  ddBossListText[DNAInstance[i][1]]:SetText(DNARaidBosses[instanceNum][1])
  ddBossList[DNAInstance[i][1]].onClick = function(self, checked)
    ddBossListText[DNAInstance[i][1]]:SetText(self.value)
    DN:ClearFrameView()

    DN:PresetClear()
    raidSelection = self.value
    if ((tankSlot[1]:GetText() ~= "Empty") and (tankSlot[2]:GetText() ~= "Empty")) then
      if ((healSlot[1]:GetText() ~= "Empty") and (healSlot[2]:GetText() ~= "Empty")) then
        btnSaveRaid:Show()
      end
    end
    if (DNA[player.combine]["SAVECONF"] ~= nil) then
      if (DNA[player.combine]["SAVECONF"][raidSelection]) then
        --if (onPage == "Assignment") then
          btnLoadRaid:Show()
          noLoadRaidText:Hide()
          DN:PresetSelect(raidSelection)
        --end
      end
    end
    DN:Debug("ddBossList " .. self.value)
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

local largePacket = nil
function DN:RaidSendAssignments()
  largePacket = "{"
  for i=1, DNASlots.tank do
    if (tankSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. TANK .. i .. "," .. tankSlot[i].text:GetText() .. "}"
    end
  end
  DN:SendPacket(largePacket, true)

  largePacket = "{" --beginning key
  for i=1, DNASlots.heal do
    if (healSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. HEAL .. i .. "," .. healSlot[i].text:GetText() .. "}"
    end
  end
  DN:SendPacket(largePacket, true)

  largePacket = "{"
  for i=1, DNASlots.cc do
    if (ccSlot[i].text:GetText() ~= nil) then
      largePacket = largePacket .. CC .. i .. "," .. ccSlot[i].text:GetText() .. "}"
    end
  end
  DN:SendPacket(largePacket, true)
  DN:SendPacket(packetPrefix.author .. player.name, true)
  DN:SendPacket(packetPrefix.version .. DNAGlobal.version, true)
end

local btnShare_x = 300
local btnShare_y = DNAGlobal.height-45
local btnShare_t = "Push Assignments"
local btnShare = CreateFrame("Button", nil, page["Assignment"], "UIPanelButtonTemplate")
btnShare:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnShare:SetPoint("TOPLEFT", btnShare_x, -btnShare_y)
btnShare.text = btnShare:CreateFontString(nil, "ARTWORK")
btnShare.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
btnShare.text:SetText(btnShare_t)
btnShare.text:SetPoint("CENTER", btnShare)
btnShare:SetScript("OnClick", function()
  if (DN:RaidPermission()) then
    DN:UpdateRaidRoster()
    DN:RaidSendAssignments()
  end
end)
btnShare:Hide()
local btnShareDis = CreateFrame("Button", nil, page["Assignment"], "UIPanelButtonGrayTemplate")
btnShareDis:SetSize(DNAGlobal.btn_w, DNAGlobal.btn_h)
btnShareDis:SetPoint("TOPLEFT", btnShare_x, -btnShare_y)
btnShareDis.text = btnShareDis:CreateFontString(nil, "ARTWORK")
btnShareDis.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
btnShareDis.text:SetText(btnShare_t)
btnShareDis.text:SetPoint("CENTER", btnShare)
btnShareDis:SetScript("OnClick", function()
  DN:RaidPermission()
end)

btnShareDis:Hide()

local btnPostRaid_x = DNAGlobal.width-270
local btnPostRaid_y = DNAGlobal.height-45

--DN:CheckBox("READYCHECK", "Ready Check", page["Assignment"], btnPostRaid_x, DNAGlobal.height-107)
--DNACheckbox["READYCHECK"]:SetChecked(true)

btnPostRaid = CreateFrame("Button", nil, page["Assignment"], "BackdropTemplate")
btnPostRaid:SetPoint("TOPLEFT", btnPostRaid_x, -btnPostRaid_y)
btnPostRaid.text = btnPostRaid:CreateFontString(nil, "ARTWORK")
btnPostRaid.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
btnPostRaid.text:SetText("Post to Raid")
btnPostRaid.text:SetPoint("CENTER", btnPostRaid)
DN:ButtonFrame(btnPostRaid, "green")
btnPostRaid:SetScript("OnClick", function()
  if (DN:RaidPermission()) then
    if ((total.tanks < 2) or (total.healers < 8)) then
      DN:Notification("Not enough tanks and healers assigned!     [L2]", true)
      return
    end
    DN:RaidSendAssignments()
    if ((raidSelection == nil) or (raidSelection == "")) then
      DN:Notification("Please select a boss or trash pack!          [P3]", true)
    else
      --class notes
      for i,v in ipairs(DNAClasses) do
        if (DNAFrameClassAssignEdit[v]:GetText() ~= "") then
          DN:SendPacket(packetPrefix[v] .. DNAFrameClassAssignEdit[v]:GetText(), false)
        end
      end
      viewFrameBottomTabToggle("Markers") --default enabled
      DN:SendPacket(packetPrefix.posttoraid .. raidSelection .. "," .. player.name, true) --openassignments
      --if (DNACheckbox["READYCHECK"]:GetChecked()) then
        DoReadyCheck()
      --end
      DN:Close()
    end
  end
end)

function DN:PresetLoad(selection)
  local getsave={}

  for k,v in pairs(DNA[player.combine]["SAVECONF"][selection]) do
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
        tankSlot[getsave.slot].text:SetPoint("TOPLEFT", 20, -4)
        tankSlot[getsave.slot]:SetFrameLevel(3)
        tankSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        tankSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(tankSlot[getsave.slot].text, thisClass)
      end
    end
    if (getsave.role == CC) then
      if ((getsave.name == nil) or (getsave.name == "Empty")) then
        ccSlot[getsave.slot].text:SetText("Empty")
        ccSlot[getsave.slot]:SetFrameLevel(2)
        ccSlot[getsave.slot]:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.5)
        ccSlot[getsave.slot]:SetBackdropColor(0.2, 0.2, 0.2, 1)
        DN:ClassColorText(ccSlot[getsave.slot].text, "Empty")
      else
        ccSlot[getsave.slot].text:SetText(getsave.name)
        ccSlot[getsave.slot].text:SetPoint("TOPLEFT", 20, -4)
        ccSlot[getsave.slot]:SetFrameLevel(3)
        ccSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        ccSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
        --thisClass = UnitClass(getsave.name)
        thisClass = DNARaid["class"][getsave.name]
        DN:ClassColorText(ccSlot[getsave.slot].text, thisClass)
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
        healSlot[getsave.slot].text:SetPoint("TOPLEFT", 20, -4)
        healSlot[getsave.slot]:SetFrameLevel(3)
        healSlot[getsave.slot]:SetBackdropColor(1, 1, 1, 0.6)
        healSlot[getsave.slot]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
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
  end
  healSlotUp[1]:Hide()
  healSlotDown[DNASlots.heal]:Hide()
  DN:PresetSelect(selection)
  DN:AlignSlotText()
  DN:Debug("DN:PresetLoad(".. selection ..")")
end

btnSaveRaid = CreateFrame("Button", nil, DNAFramePreset, "BackdropTemplate")
btnSaveRaid:SetPoint("TOPLEFT", 30, -290)
btnSaveRaid.text = btnSaveRaid:CreateFontString(nil, "ARTWORK")
btnSaveRaid.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
btnSaveRaid.text:SetText("Save Raid Comp")
btnSaveRaid.text:SetPoint("CENTER", btnSaveRaid)
DN:ButtonFrame(btnSaveRaid, "red")
btnSaveRaid:SetScript("OnClick", function()
  if ((raidSelection == nil) or (raidSelection == "")) then
    DN:Notification("Please select a boss or trash pack!          [P4]", true)
    return
  else
    if (raidSelection) then
      if (DNA[player.combine]["SAVECONF"] == nil) then
        DNA[player.combine]["SAVECONF"] = {}
      end
      DN:PresetDuplicate()
      if (DNA[player.combine]["SAVECONF"][raidSelection] == nil) then
        DNA[player.combine]["SAVECONF"][raidSelection] = {}
      end
      for i=1, DNASlots.tank do
        DNA[player.combine]["SAVECONF"][raidSelection]["T" .. i] = tankSlot[i].text:GetText()
      end
      for i=1, DNASlots.heal do
        DNA[player.combine]["SAVECONF"][raidSelection]["H" .. i] = healSlot[i].text:GetText()
      end
      for i=1, DNASlots.cc do
        DNA[player.combine]["SAVECONF"][raidSelection]["C" .. i] = ccSlot[i].text:GetText()
      end
      DN:ChatNotification("Raid Comp Saved: "..DNAGlobal.color..raidSelection)
      noLoadRaidText:Hide()
    end
  end
end)
btnSaveRaid:Hide()

btnLoadRaid = CreateFrame("Button", nil, DNAFramePreset, "BackdropTemplate")
btnLoadRaid:SetPoint("TOPLEFT", 210, -290)
btnLoadRaid.text = btnLoadRaid:CreateFontString(nil, "ARTWORK")
btnLoadRaid.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
btnLoadRaid.text:SetText("Load Raid Comp")
btnLoadRaid.text:SetPoint("CENTER", btnLoadRaid)
DN:ButtonFrame(btnLoadRaid, "green")
btnLoadRaid:SetScript("OnClick", function()
  if ((raidSelection == nil) or (raidSelection == "")) then
    DN:Notification("Please select a boss or trash pack!          [P5]", true)
    return
  else
    if (raidSelection) then
      if (DNA[player.combine]["SAVECONF"][raidSelection] == nil) then
        --DN:ChatNotification("Raid Comp Set: " .. raidSelection)
        DN:Notification("This configuration was never saved!        [N1]", true)
        return
      else
        if (DN:RaidPermission()) then --need perms to set
          DN:Debug("Load Preset " .. raidSelection)
          DNA[player.combine]["ASSIGN"] = DNA[player.combine]["SAVECONF"][raidSelection]
          DN:PresetLoad(raidSelection)
          DN:ChatNotification("Raid Comp Loaded: " ..DNAGlobal.color.. raidSelection)
          DN:PresetDuplicate()
        end
      end
    end
  end
end)
btnLoadRaid:Hide()

noLoadRaidText = DNAFramePreset:CreateFontString(nil, "ARTWORK")
noLoadRaidText:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
noLoadRaidText:SetText("Configuration not saved!")
noLoadRaidText:SetPoint("TOPLEFT", 195, -150)

for i=1, DNASlots.tank do
  currentViewTank[i] = DNAFramePreset:CreateFontString(nil, "ARTWORK")
  currentViewTank[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  currentViewTank[i]:SetText("")
  currentViewTank[i]:SetPoint("TOPLEFT", 10, (-i*12)+5)
  currentViewTank[i]:SetTextColor(0.5, 0.5, 0.5)
end
for i=1, DNASlots.heal do
  currentViewHeal[i] = DNAFramePreset:CreateFontString(nil, "ARTWORK")
  currentViewHeal[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  currentViewHeal[i]:SetText("")
  currentViewHeal[i]:SetPoint("TOPLEFT", 10, (-i*12)-80)
  currentViewHeal[i]:SetTextColor(0.5, 0.5, 0.5)
end
for i=1, DNASlots.cc do
  currentViewCC[i] = DNAFramePreset:CreateFontString(nil, "ARTWORK")
  currentViewCC[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  currentViewCC[i]:SetText("")
  currentViewCC[i]:SetPoint("TOPLEFT", 10, (-i*12)-230)
  currentViewCC[i]:SetTextColor(0.5, 0.5, 0.5)
end

for i=1, DNASlots.tank do
  presetViewTank[i] = DNAFramePreset:CreateFontString(nil, "ARTWORK")
  presetViewTank[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  presetViewTank[i]:SetText("")
  presetViewTank[i]:SetPoint("TOPLEFT", 190, (-i*12)+5)
  presetViewTank[i]:SetTextColor(0.5, 0.5, 0.5)
end
for i=1, DNASlots.heal do
  presetViewHeal[i] = DNAFramePreset:CreateFontString(nil, "ARTWORK")
  presetViewHeal[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  presetViewHeal[i]:SetText("")
  presetViewHeal[i]:SetPoint("TOPLEFT", 190, (-i*12)-80)
  presetViewHeal[i]:SetTextColor(0.5, 0.5, 0.5)
end
for i=1, DNASlots.cc do
  presetViewCC[i] = DNAFramePreset:CreateFontString(nil, "ARTWORK")
  presetViewCC[i]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  presetViewCC[i]:SetText("")
  presetViewCC[i]:SetPoint("TOPLEFT", 190, (-i*12)-230)
  presetViewCC[i]:SetTextColor(0.5, 0.5, 0.5)
end

for i,v in pairs(DNAPages) do
  bottomTab(v)
end

--default selection after drawn
bottomTabToggle(DNAPages[1])
ddBossList[DNAInstance[1][1]]:Show() -- show first one

function DN:PermissionVisibility()
  DN:ClearNotifications()
  if (UnitIsGroupLeader(player.name) or UnitIsGroupAssistant(player.name)) then
    btnShareDis:Hide()
    --btnShare:Show()
    btnPostRaid:Show()
    tankSlotFrameClear:Show()
    healSlotFrameClear:Show()
    ccSlotFrameClear:Show()
  else
    --btnShareDis:Show()
    btnShare:Hide()
    btnPostRaid:Hide()
    for i=1, DNASlots.heal do
      healSlotUp[i]:Hide()
      healSlotDown[i]:Hide()
    end
  end
end

DN:InstanceButtonToggle(DNAInstance[1][1], DNAInstance[1][5]) --toggle first button

SLASH_DNA1 = "/dna"
function DNASlashCommands(msg)
  DN:Close()
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if (msg == "debug") then
    DEBUG = true
    DN:Debug("DEBUG MODE ON")
    DN:Open()
  elseif (string.sub(msg, 1, 1) == "m") then
    local raidSelection = msg:sub(7, 80) -- remove the first space and double quote
    raidSelection = raidSelection:gsub('%"', '')
    DN:Debug("== " .. raidSelection)
    if (raidSelection) then
      DN:RaidSendAssignments()
      DN:ChatNotification("Boss Assignment " ..DNAGlobal.color.. raidSelection)
      DN:SendPacket(packetPrefix.posttoraid .. raidSelection .. "," .. player.name, true) --openassignments
      DoReadyCheck()
    else
      DN:ChatNotification("Invalid Boss Entry")
    end
  elseif (msg == "bid") then
    DNABidWindow:Show()
  else
    DN:Open()
  end
end

SlashCmdList.DNA = DNASlashCommands
