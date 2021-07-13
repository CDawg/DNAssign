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

MAX_MEMBER_PROFESSIONS = 800
MAX_MEMBER_RECIPES = 255 --we can't add more than the packet will allow us
MAX_REAGENT_RECIPE = 6 --have not found anything more than 6 per recipe
MAX_EXPANSION_CRAFT = 375

local DNAProfScrollFrame_w = 200
local DNAProfScrollFrame_h = 500

local cachedProf = DNAProfessions[1][1]

DNAButtonProf={}
DNAButtonProf_y=0
for k,v in ipairs(DNAProfessions) do
  DNAButtonProf_y = DNAButtonProf_y +24
  DNAButtonProf[v[1]] = CreateFrame("Button", nil, page["Professions"], "BackdropTemplate")
  DNAButtonProf[v[1]]:SetPoint("TOPLEFT", 25, -30-DNAButtonProf_y)
  DNAButtonProf[v[1]]:SetSize(DNAGlobal.btn_w+30, DNAGlobal.btn_h)
  DNAButtonProf[v[1]].text = DNAButtonProf[v[1]]:CreateFontString(nil, "ARTWORK")
  DNAButtonProf[v[1]].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
  DNAButtonProf[v[1]].text:SetPoint("TOPLEFT", 28, -6)
  DNAButtonProf[v[1]].text:SetText(v[1])
  DNAButtonProf[v[1]].icon = DNAButtonProf[v[1]]:CreateTexture(nil, "OVERLAY")
  DNAButtonProf[v[1]].icon:SetTexture("Interface/ICONS/" .. v[3])
  DNAButtonProf[v[1]].icon:SetPoint("TOPLEFT", 3, -3)
  DNAButtonProf[v[1]].icon:SetSize(20, 20)
  DNAButtonProf[v[1]]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  DNAButtonProf[v[1]]:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
  DNAButtonProf[v[1]]:SetScript("OnEnter", function(self)
    self:SetBackdropBorderColor(1,1,1,1)
  end)
  DNAButtonProf[v[1]]:SetScript("OnLeave", function(self)
    self:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
  end)
  DNAButtonProf[v[1]]:SetScript("OnClick", function()
    DN:GetGuildProfessions(v[1])
  end)
end

DNAProfScrollFrame = CreateFrame("Frame", DNAProfScrollFrame, page["Professions"], "InsetFrameTemplate")
DNAProfScrollFrame:SetWidth(DNAProfScrollFrame_w+20)
DNAProfScrollFrame:SetHeight(DNAProfScrollFrame_h)
DNAProfScrollFrame:SetPoint("TOPLEFT", 200, -50)
DNAProfScrollFrame:SetFrameLevel(5)
DNAProfScrollFrame.text = DNAProfScrollFrame:CreateFontString(nil, "ARTWORK")
DNAProfScrollFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAProfScrollFrame.text:SetPoint("TOPLEFT", DNAProfScrollFrame, "TOPLEFT", 0, 15)
DNAProfScrollFrame.text:SetText("Guild Members")
DNAProfScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAProfScrollFrame, "UIPanelScrollFrameTemplate")
DNAProfScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNAProfScrollFrame, "TOPLEFT", 3, -3)
DNAProfScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAProfScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNAProfScrollFrameScrollChildFrame = CreateFrame("Frame", DNAProfScrollFrameScrollChildFrame, DNAProfScrollFrame.ScrollFrame)
DNAProfScrollFrameScrollChildFrame:SetSize(DNAProfScrollFrame_w, DNAProfScrollFrame_h)
DNAProfScrollFrame.ScrollFrame:SetScrollChild(DNAProfScrollFrameScrollChildFrame)
DNAProfScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNAProfScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAProfScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNAProfScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAProfScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNAProfScrollFrame.MR = DNAProfScrollFrame:CreateTexture(nil, "BACKGROUND", DNAProfScrollFrame, -2)
DNAProfScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAProfScrollFrame.MR:SetPoint("TOPLEFT", DNAProfScrollFrame_w-5, 0)
DNAProfScrollFrame.MR:SetSize(24, DNAProfScrollFrame_h)

local DNAMemberProfDetailFrame = CreateFrame("Frame", "DNAMemberProfDetailFrame", page["Professions"])
DNAMemberProfDetailFrame:SetPoint("TOPLEFT", 450, -60)
DNAMemberProfDetailFrame:SetWidth(200)
DNAMemberProfDetailFrame:SetHeight(100)
DNAMemberProfDetailFrame:SetFrameLevel(5)
DNAMemberProfDetailFrame:Hide()
local memberProfDetailBar = {}
memberProfDetailBarBack =  CreateFrame("Frame", nil, DNAMemberProfDetailFrame, "InsetFrameTemplate")
memberProfDetailBarBack:SetPoint("TOPLEFT", 0, -10)
memberProfDetailBarBack:SetSize(378, 24)
memberProfDetailBar = CreateFrame("Button", nil, memberProfDetailBarBack, "BackdropTemplate")
memberProfDetailBar:SetPoint("TOPLEFT", 2, -1)
memberProfDetailBar:SetSize(1, 21)
memberProfDetailBar:SetBackdrop({
  bgFile = "Interface/Buttons/BlueGrad64",
  edgeFile = "",
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
})
memberProfDetailBar:SetFrameLevel(6)
memberProfDetailBar:SetBackdropColor(0.2, 0.2, 0.5, 1)

--bar text
local memberProfDetailText = {}
memberProfDetailText[1] = memberProfDetailBarBack:CreateFontString(nil, "TOOLTIP", 7)
memberProfDetailText[1]:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
memberProfDetailText[1]:SetPoint("CENTER", 0, 0)
memberProfDetailText[1]:SetText("")

--misc details
memberProfDetailTextName = DNAMemberProfDetailFrame:CreateFontString(nil, "ARTWORK")
memberProfDetailTextName:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
memberProfDetailTextName:SetPoint("TOPLEFT", 0, 10)
memberProfDetailTextName:SetText("")

local professionSlot={}
--local professionSlotText = {}
for i=1, MAX_MEMBER_PROFESSIONS do
  professionSlot[i] = {}
  professionSlot[i] = CreateFrame("button", professionSlot[i], DNAProfScrollFrameScrollChildFrame, "BackdropTemplate")
  professionSlot[i]:SetWidth(DNAProfScrollFrame_w-5)
  professionSlot[i]:SetHeight(raidSlot_h)
  professionSlot[i]:SetBackdrop({
    bgFile = DNAGlobal.slotbg,
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  professionSlot[i]:SetBackdropColor(1, 1, 1, 0.3)
  professionSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  professionSlot[i]:SetPoint("TOPLEFT", 0, (-i*18)+raidSlot_h-4)
  professionSlot[i].text = professionSlot[i]:CreateFontString(nil, "ARTWORK")
  professionSlot[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  professionSlot[i].text:SetPoint("TOPLEFT", 5, -4)
  professionSlot[i].text:SetText("")
  professionSlot[i].text:SetTextColor(0.6, 0.6, 0.6, 1)
  professionSlot[i]:SetScript('OnEnter', function()
    professionSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
  end)
  professionSlot[i]:SetScript('OnLeave', function()
    professionSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  end)
  professionSlot[i]:SetScript('OnClick', function(self)
    DN:GetMemberProf(cachedProf, self.text:GetText())
  end)
  professionSlot[i]:Hide()
end

local profCount = 0
local profName = {}
local profPacketString = ""
local sentMyProfs = 1
function DN:SendMyProfessions(notification, author)
  sentMyProfs = sentMyProfs +1
  local profPacketString = ""
  if (notification) then
    sentMyProfs = 4
  end
  if (sentMyProfs == 4) then
    if (IsInGuild()) then
      local guildName, guildRankName, guildRankIndex, realm = GetGuildInfo("player")
      for skillIndex = 1, GetNumSkillLines() do
        local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(skillIndex)
        for k,v in ipairs(DNAProfessions) do
          if (v[1] == skillName) then
            local skillId = v[2]
            profName[skillName] = skillRank
          end
        end
      end

      for k,v in pairs(profName) do
        profPacketString = profPacketString .. k .. "," .. v .. ","
      end

      if (profPacketString) then
        profPacketString = profPacketString:sub(1, string.len(profPacketString) -1)
        if (notification) then
          DN:SendPacket(packetPrefix.professionN .. player.name .. "," .. guildName .. "," .. author .. "," .. profPacketString, false, "GUILD")
        else
          DN:SendPacket(packetPrefix.profession .. player.name .. "," .. guildName .. "," .. author .. "," .. profPacketString, false, "GUILD")
        end
      end

    end
  end
end

function DN:SaveGuildProfessions(prof_data)
  local member= prof_data[1]
  local guild = prof_data[2]
  local author= prof_data[3]
  local profN1= prof_data[4]
  local profL1= prof_data[5]
  local profN2= prof_data[6]
  local profL2= prof_data[7]
  local profN3= prof_data[8]
  local profL3= prof_data[9]
  local profN4= prof_data[10]
  local profL4= prof_data[11]
  local profN5= prof_data[12]
  local profL5= prof_data[13]
  if (IsInGuild()) then
    DNAProfScrollFrame.text:SetText(guild)
  end
  if (DNA["PROFESSIONS"] == nil) then
    DNA["PROFESSIONS"] = {}
  end
  if (DNA["PROFESSIONS"][guild] == nil) then
    DNA["PROFESSIONS"][guild] = {}
  end
  DNA["PROFESSIONS"][guild][member] = {} --flush all profs from toon and restart
  if (profN1) then
    DNA["PROFESSIONS"][guild][member][profN1] = profL1
  end
  if (profN2) then
    DNA["PROFESSIONS"][guild][member][profN2] = profL2
  end
  if (profN3) then
    DNA["PROFESSIONS"][guild][member][profN3] = profL3
  end
  if (profN4) then
    DNA["PROFESSIONS"][guild][member][profN4] = profL4
  end
  if (profN5) then
    DNA["PROFESSIONS"][guild][member][profN5] = profL5
  end
end

function DN:GetGuildProfessions(prof)
  for i=1, MAX_MEMBER_PROFESSIONS do
    professionSlot[i].text:SetText("")
    professionSlot[i]:Hide()
  end
  local guildMemberSort={}
  local memberCount = 0
  if (IsInGuild()) then
    local guildName, guildRankName, guildRankIndex = GetGuildInfo("player")
    --print("clicking " .. prof)
    --print("guild " .. guildName)
    for k,v in ipairs(DNAProfessions) do
      --DNAButtonProf[v[1]]:SetBackdropBorderColor(0.7, 0.7, 0.7, 1)
      DNAButtonProf[v[1]]:SetBackdropColor(0.7, 0.7, 0.7, 1)
    end
    --DNAButtonProf[prof]:SetBackdropBorderColor(1, 1, 0.5, 1)
    DNAButtonProf[prof]:SetBackdropColor(1, 1, 0.2, 1)
    DNAMemberProfDetailFrame:Hide()
    cachedProf = prof
    DNAProfScrollFrame.text:SetText(guildName .. " - " .. prof)
    if (DNA["PROFESSIONS"][guildName]) then
      for k in pairs(guildMemberSort) do
        guildMemberSort[k] = nil
      end
      for member,v in pairs(DNA["PROFESSIONS"][guildName]) do
        --print(member)
        for k,v in pairs(DNA["PROFESSIONS"][guildName][member]) do
          if (k == prof) then
            table.insert(guildMemberSort, member)
          end
        end
      end
    end

    table.sort(guildMemberSort)
    for profession,v in ipairs(guildMemberSort) do
      memberCount = memberCount +1
      professionSlot[memberCount].text:SetText(v)
      professionSlot[memberCount]:Show()
      for i=1, GetNumGuildMembers() do
        local name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(i)
        local guild_member = split(name, "-") --remove server
        if (v == guild_member[1]) then
          DN:ClassColorText(professionSlot[memberCount].text, "Offline")
          if (online) then
            DN:ClassColorText(professionSlot[memberCount].text, class)
          end
        end
      end
    end

  end
end

function DN:GetMemberProf(prof, member)
  local guildName, guildRankName, guildRankIndex = GetGuildInfo("player")
  if (DNA["PROFESSIONS"][guildName][member][prof]) then
    local memberSkill = tonumber(DNA["PROFESSIONS"][guildName][member][prof])
    if (memberSkill >= MAX_EXPANSION_CRAFT) then
      memberSkill = MAX_EXPANSION_CRAFT
    end
    memberProfDetailText[1]:SetText(prof .. " ".. memberSkill .. "/" .. MAX_EXPANSION_CRAFT)
    memberProfDetailBar:SetSize(memberSkill, 21)
    memberProfDetailTextName:SetText(member)
    DNAMemberProfDetailFrame:Show()
    DN:UpdateProfessionList(prof, member, memberSkill)
  end
end

local guildRosterArray={}
local nextGuildName=1
local countGuildOnline = 0
local profSendDelayTimer = 0
function ProfDelayTimerFrame()
  profSendDelayTimer = profSendDelayTimer+1
  if (guildRosterArray[profSendDelayTimer]) then
    --print(guildRosterArray[profSendDelayTimer])
    DN:SendPacket(packetPrefix.profrequest .. guildRosterArray[profSendDelayTimer] .. "," .. player.name, false, "GUILD")
  end
end
profsendDelay = C_Timer.NewTicker(1, ProfDelayTimerFrame, 1)
profsendDelay:Cancel()

function DN:ProfSendAlphaSync()
  for k in pairs(guildRosterArray) do --clear array
    guildRosterArray[k] = nil
  end
  for i=1, GetNumGuildMembers() do
    local name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(i)
    local guild_member = split(name, "-") --remove server
    if (online) then
      countGuildOnline = countGuildOnline +1
      table.insert(guildRosterArray, guild_member[1])
    end
  end
  table.sort(guildRosterArray)
  --print("DN:ProfSendAlphaSync()")
end

DNAProfSyncGuild = CreateFrame("Button", nil, page["Professions"], "UIPanelButtonTemplate")
DNAProfSyncGuild:SetSize(150, 24)
DNAProfSyncGuild:SetPoint("TOPLEFT", 230, -555)
DNAProfSyncGuild.text = DNAProfSyncGuild:CreateFontString(nil, "ARTWORK")
DNAProfSyncGuild.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAProfSyncGuild.text:SetPoint("CENTER", 0, 0)
DNAProfSyncGuild.text:SetText("Sync Guild")
DNAProfSyncGuild:SetFrameLevel(5)
DNAProfSyncGuild:SetScript('OnClick', function(self)
  if (IsInGuild()) then
    profsendDelay:Cancel()
    DN:ProfSendAlphaSync()
    --print(countGuildOnline)
    profsendDelay = C_Timer.NewTicker(0.320, ProfDelayTimerFrame, countGuildOnline)
    DN:ChatNotification("Collecting Guild ["..DNAGlobal.color.."Professions|r]")
    self:Hide()
  else
    print("|cfffaff04You are not in a guild.")
  end
end)

--local spellID = 26746 -- NW Bag
--local spellID = 22757 --Ele Sharpening stone
--local spellID = 12046 --simple kilt
--local spellID = 20020 --ench greater stam

function DN:HasSkill(spellID)
  --local spellName = GetSpellInfo(spellID)
  local hasSpell = IsPlayerSpell(spellID)
  --[==[
  if (spellName) then
    print("|Hspell:" .. spellID .."|h|r|cfffaff04[" .. spellName .. "]|r|h")
    print(hasSpell)
  else
    print("unknown spell")
  end
  ]==]--
  return hasSpell
end

function DN:LinkSkill(spellID)
  --[==[
  local spellName = GetSpellInfo(spellID)
  if (spellName) then
    return "|Hspell:" .. spellID .."|h|r|cfffaff04[" .. spellName .. "]|r|h"
  else
    return "unknown"
  end
  ]==]--
end

local DNAProfRecipeScrollFrame_w = 358
local DNAProfRecipeScrollFrame_h = 230

DNAProfRecipeScrollFrame = CreateFrame("Frame", DNAProfRecipeScrollFrame, DNAMemberProfDetailFrame, "InsetFrameTemplate")
DNAProfRecipeScrollFrame:SetWidth(DNAProfRecipeScrollFrame_w+20)
DNAProfRecipeScrollFrame:SetHeight(DNAProfRecipeScrollFrame_h)
DNAProfRecipeScrollFrame:SetPoint("TOPLEFT", 0, -36)
--DNAProfRecipeScrollFrame:SetFrameLevel(5)
--[==[
DNAProfRecipeScrollFrame.text = DNAProfRecipeScrollFrame:CreateFontString(nil, "ARTWORK")
DNAProfRecipeScrollFrame.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize, "OUTLINE")
DNAProfRecipeScrollFrame.text:SetPoint("TOPLEFT", DNAProfRecipeScrollFrame, "TOPLEFT", 0, 15)
DNAProfRecipeScrollFrame.text:SetText("Recipes")
]==]--
DNAProfRecipeScrollFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAProfRecipeScrollFrame, "UIPanelScrollFrameTemplate")
DNAProfRecipeScrollFrame.ScrollFrame:SetPoint("TOPLEFT", DNAProfRecipeScrollFrame, "TOPLEFT", 3, -3)
DNAProfRecipeScrollFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAProfRecipeScrollFrame, "BOTTOMRIGHT", 10, 4)
local DNAProfRecipeScrollFrameScrollChildFrame = CreateFrame("Frame", DNAProfRecipeScrollFrameScrollChildFrame, DNAProfRecipeScrollFrame.ScrollFrame)
DNAProfRecipeScrollFrameScrollChildFrame:SetSize(DNAProfRecipeScrollFrame_w, DNAProfRecipeScrollFrame_h)
DNAProfRecipeScrollFrame.ScrollFrame:SetScrollChild(DNAProfRecipeScrollFrameScrollChildFrame)
DNAProfRecipeScrollFrame.ScrollFrame.ScrollBar:ClearAllPoints()
DNAProfRecipeScrollFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAProfRecipeScrollFrame.ScrollFrame, "TOPRIGHT", 0, -17)
DNAProfRecipeScrollFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAProfRecipeScrollFrame.ScrollFrame, "BOTTOMRIGHT", -42, 14)
DNAProfRecipeScrollFrame.MR = DNAProfRecipeScrollFrame:CreateTexture(nil, "BACKGROUND", DNAProfRecipeScrollFrame, -2)
DNAProfRecipeScrollFrame.MR:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAProfRecipeScrollFrame.MR:SetPoint("TOPLEFT", DNAProfRecipeScrollFrame_w-5, 0)
DNAProfRecipeScrollFrame.MR:SetSize(24, DNAProfRecipeScrollFrame_h)

DNAProfRecipeMatsFrame = CreateFrame("Frame", "DNAProfRecipeMatsFrame", DNAMemberProfDetailFrame, "InsetFrameTemplate")
DNAProfRecipeMatsFrame:SetWidth(DNAProfRecipeScrollFrame_w+20)
DNAProfRecipeMatsFrame:SetHeight(220)
DNAProfRecipeMatsFrame:SetPoint("TOPLEFT", 0, -DNAProfRecipeScrollFrame_h-38)

local DNAProfRecipeItem={}
DNAProfRecipeItem = CreateFrame("Frame", "DNAProfRecipeItem", DNAProfRecipeMatsFrame)
DNAProfRecipeItem:SetWidth(300)
DNAProfRecipeItem:SetHeight(30)
DNAProfRecipeItem:SetPoint("TOPLEFT", 30, -10)
DNAProfRecipeItem.icon = DNAProfRecipeItem:CreateTexture(nil, "OVERLAY", DNAProfRecipeItem)
DNAProfRecipeItem.icon:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
DNAProfRecipeItem.icon:SetPoint("TOPLEFT", 0, 0)
DNAProfRecipeItem.icon:SetSize(30, 30)
DNAProfRecipeItem.text = DNAProfRecipeItem:CreateFontString(nil, "ARTWORK")
DNAProfRecipeItem.text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
DNAProfRecipeItem.text:SetPoint("TOPLEFT", 35, -10)
DNAProfRecipeItem.text:SetText("")
DNAProfRecipeItem.text:SetTextColor(1, 1, 0.4, 1)
DNAProfRecipeItem:Hide()

local DNAProfReagent={}
local DNAProfReagentBorder = {
  bgFile = "",
  edgeFile = DNAGlobal.slotborder,
  edgeSize = 12,
  insets = {left=2, right=2, top=2, bottom=2},
}
for i=1, MAX_REAGENT_RECIPE do
  DNAProfReagent[i] = CreateFrame("Frame", "DNAProfReagent", DNAProfRecipeMatsFrame, "BackdropTemplate")
  DNAProfReagent[i]:SetWidth(160)
  DNAProfReagent[i]:SetHeight(32)
  DNAProfReagent[i]:SetBackdrop(DNAProfReagentBorder)
  DNAProfReagent[i]:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
  DNAProfReagent[i].text = DNAProfReagent[i]:CreateFontString(nil, "ARTWORK")
  DNAProfReagent[i].text:SetWidth(120)
  DNAProfReagent[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-2, "OUTLINE")
  DNAProfReagent[i].text:SetPoint("CENTER", 15, 0)
  DNAProfReagent[i].text:SetText("")
  DNAProfReagent[i].icon = DNAProfReagent[i]:CreateTexture(nil, "OVERLAY", DNAProfReagent[i])
  DNAProfReagent[i].icon:SetTexture(DNAGlobal.dir .. "images/scroll-mid-right")
  DNAProfReagent[i].icon:SetPoint("TOPLEFT", 1, -1)
  DNAProfReagent[i].icon:SetSize(29, 29)
  DNAProfReagent[i].count = DNAProfReagent[i]:CreateFontString(nil, "OVERLAY", 7)
  DNAProfReagent[i].count:SetFont(DNAGlobal.font, DNAGlobal.fontSize+1, "OUTLINE")
  DNAProfReagent[i].count:SetPoint("TOPLEFT", 2, -2)
  DNAProfReagent[i].count:SetText("1")
  DNAProfReagent[i].count:SetTextColor(1,1,0.8,1)
  DNAProfReagent[i]:Hide()
end
--row 1
local reagentPos = 0
for i=1, 2 do
  reagentPos = reagentPos+1
  DNAProfReagent[i]:SetPoint("TOPLEFT", -130+reagentPos*160, -60)
end
--row 2
local reagentPos = 0
for i=3, 4 do
  reagentPos = reagentPos+1
  DNAProfReagent[i]:SetPoint("TOPLEFT", -130+reagentPos*160, -100)
end
--row 3
local reagentPos = 0
for i=5, 6 do
  reagentPos = reagentPos+1
  DNAProfReagent[i]:SetPoint("TOPLEFT", -130+reagentPos*160, -140)
end

local recipeSlot={}
local recipeCount=0
for i=1, MAX_MEMBER_RECIPES  do
  recipeCount = recipeCount+1
  recipeSlot[i] = {}
  recipeSlot[i] = CreateFrame("button", recipeSlot[i], DNAProfRecipeScrollFrameScrollChildFrame, "BackdropTemplate")
  recipeSlot[i]:SetWidth(DNAProfRecipeScrollFrame_w-5)
  recipeSlot[i]:SetHeight(raidSlot_h)
  recipeSlot[i]:SetBackdrop({
    bgFile = "",
    edgeFile = DNAGlobal.slotborder,
    edgeSize = 12,
    insets = {left=2, right=2, top=2, bottom=2},
  })
  recipeSlot[i]:SetBackdropColor(1, 1, 1, 0.3)
  --recipeSlot[i]:SetBackdropBorderColor(1, 0.98, 0.98, 0.30)
  recipeSlot[i]:SetBackdropBorderColor(0, 0, 0, 0)
  recipeSlot[i]:SetPoint("TOPLEFT", 0, (-i*18)+raidSlot_h-4)
  recipeSlot[i].text = recipeSlot[i]:CreateFontString(nil, "ARTWORK")
  recipeSlot[i].text:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  recipeSlot[i].text:SetPoint("TOPLEFT", 15, -4)
  recipeSlot[i].text:SetText("-")

  recipeSlot[i].id = recipeSlot[i]:CreateFontString(nil, "ARTWORK")
  recipeSlot[i].id:SetFont(DNAGlobal.font, DNAGlobal.fontSize-1, "OUTLINE")
  recipeSlot[i].id:SetPoint("TOPLEFT", 115, -4)
  recipeSlot[i].id:SetText("-")
  recipeSlot[i]:SetScript('OnEnter', function()
    recipeSlot[i]:SetBackdropBorderColor(1, 1, 0.6, 1)
  end)
  recipeSlot[i]:SetScript('OnLeave', function()
    recipeSlot[i]:SetBackdropBorderColor(0, 0, 0, 0)
  end)
  recipeSlot[i]:SetScript('OnClick', function(self)
    DN:UpdateRecipeMats(self.text:GetText())
  end)
end

function DN:UpdateRecipeMats(array)
  local prof_data = split(array, " | ")
  local spellID = tonumber(prof_data[2])
  local itemID = DNAProfession.Reagents[spellID][1]
  if (itemID) then
  local itemIcon = GetItemIcon(itemID)
    DNAProfRecipeItem.icon:SetTexture(itemIcon)
  end
  DNAProfRecipeItem.text:SetText(prof_data[1])
  DNAProfRecipeItem:Show()
  local reagents = DNAProfession.Reagents[spellID][6]
  local reagentCount=DNAProfession.Reagents[spellID][7]
  for i=1, MAX_REAGENT_RECIPE do
    DNAProfReagent[i]:Hide()
  end
  for k,v in ipairs(reagents) do
    DNAProfReagent[k].text:SetText("Loading...")
    DNAProfReagent[k]:Show()
    if (v) then
      --local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(v)
      local itemName = GetItemInfo(v)
      local icon = GetItemIcon(v)
      --print(itemName)
      DNAProfReagent[k].text:SetText(itemName)
      --print("icon " .. icon)
      DNAProfReagent[k].icon:SetTexture(icon)
      --print("count " .. reagentCount[k])
      DNAProfReagent[k].count:SetText(reagentCount[k])
    end
  end
  -- [spellID] = { createdItemID, prof, minLvl, lowLvl, highLvl, reagents{}, reagentsCount{}, numCreatedItems }
end

function DN:UpdateProfessionList(prof, member, skillLevel)
  --print("prof: " .. prof)
  --print("member: " .. member)
  --print("skillLevel: " .. skillLevel)
  DNAProfRecipeItem:Hide()
  for i=1, MAX_MEMBER_RECIPES  do
    recipeSlot[i].text:SetText("")
    recipeSlot[i].id:SetText("")
    recipeSlot[i]:Hide()
  end

  for i=1, MAX_REAGENT_RECIPE do
    DNAProfReagent[i]:Hide()
  end

  --prediction recipes based off of their skill level
  local recipeCount=0
  local recipeAlpha={}
  for k in pairs(recipeAlpha) do
    recipeAlpha[k] = nil
  end
  for k,v in ipairs(DNAProfession[prof]) do
    if (v[2] <= skillLevel) then
      recipeCount = recipeCount+1
      local spellName = GetSpellInfo(v[1]) .. " | " .. v[1]
      table.insert(recipeAlpha, spellName)
    end
  end
  table.sort(recipeAlpha)
  for k,v in ipairs(recipeAlpha) do
    --local prof_data = split(array, " | ")
    recipeSlot[k].text:SetText(v)
    --recipeSlot[k].id:SetText(v)
    recipeSlot[k]:Show()
  end
end
