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

fontstring = Frame:CreateFontString(["name" [, "layer" [, "inherits"]]])
https://wowwiki.fandom.com/wiki/UI_Object_UIDropDownMenu
https://www.wowinterface.com/forums/showthread.php?t=40444
-- notes: if unitid ~= "player" then return end

SendAddonMessage("prefix", "text", "type", "target");
]==]--

local DNAGlobal = {
  "Destructive Nature Assignment",
  "VER",    "1.13c",
  "WIDTH",  800,
  "HEIGHT", 550,
  --"FONT",   "Interface\\AddOns\\DNAssign\\fonts\\cooline.ttf",
  --DNAGlobal[9]
  "FONT",  "Fonts/FRIZQT__.TTF",
}

print("|cff00ffff" .. DNAGlobal[1] .. " v" .. DNAGlobal[3] .. " Initializing...");

--single array
local function get_key_from_value(_array, value)
  for k,v in pairs(_array) do
    if v==value then return k end
  end
  return nil
end
--matrix array
local function get_mkey_from_mvalue(_array, value)
  for k,v in pairs(_array) do
    if v[1]==value then return k end
  end
  return nil
end
--alpha sort
function sortArray(array)
  local t = {}
  for title,value in pairsByKeys(array) do
      table.insert(t, { title = title, value = value })
  end
  array = t
  return array
end

local function getPlayerInformation()
  player_name = UnitName("player")
  return player_name
end
local playerName = getPlayerInformation() .. "-" .. GetRealmName()

local raidMembers = {}
local raidTotal = GetNumGroupMembers();
local raidMember = {}
function getRaidMembers()
  if (raidTotal) then
    for i = 1, raidTotal do
        raidMembers[i] = GetRaidRosterInfo(i)
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
        raidMember[name] = class
        --print(class)
    end
  end
end

getRaidMembers()

--FAKE RAID
raidMember["Aellwyn"] = "Warrior"
raidMember["Porthios"] = "Warrior"
raidMember["Upya"] = "Warlock"
raidMember["Zarj"] = "Rogue"
raidMember["Cryonix"] = "Priest"
raidMember["Grayleaf"] = "Warrior"
raidMember["Droott"] = "Druid"
raidMember["Aquilla"] = "Mage"
raidMember["Neilsbhor"] = "Mage"
raidMember["Frosthunt"] = "Hunter"
raidMember["Nanodel"] = "Hunter"
raidMember["Crisis"] = "Warrior"
raidMember["Whistper"] = "Hunter"
raidMember["Zarianna"] = "Paladin"
raidMember["Whistper"] = "Hunter"
raidMember["Roaxe"] = "Paladin"
raidMember["Measles"] = "Warlock"
raidMember["Elderpen"] = "Warrior"
raidMember["Snibson"] = "Priest"
raidMember["Justwengit"] = "Mage"
raidMember["Daggerz"] = "Rogue"
raidMember["Mirrand"] = "Rogue"
raidMember["Corr"] = "Paladin"
raidMember["Valency"] = "Warlock"
raidMember["Nutty"] = "Paladin"
raidMember["Zatos"] = "Priest"
raidMember["Muppot"] = "Warlock"
raidMember["Gaelic"] = "Paladin"
raidMember["Chrundle"] = "Mage"
raidMember["Akilina"] = "Warrior"
raidMember["Mairakus"] = "Warrior"
raidMember["Sleapy"] = "Priest"
raidMember["Stumpymcaxe"] = "Warrior"
raidMember["Cahonez"] = "Rogue"
raidMember["Avarius"] = "Warrior"
raidMember["Blackprince"] = "Paladin"
raidMember["Sifer"] = "Warrior"
--FAKE RAID

local DNAMain = CreateFrame("Frame");
DNAMain:RegisterEvent("ADDON_LOADED");
DNAMain:RegisterEvent("PLAYER_LOGIN");
DNAMain:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "DNA" then
    if DNA == nil then
      DNA = {}
    end

    if DNA[playerName] == nil then
      DNA[playerName] = {}
      print("|cff00ffff" .. DNAGlobal[1] .. "Creating New Raid Profile: " .. playerName)
    else
      print("|cff00ffff" .. DNAGlobal[1] .. "Loading Last Raid Profile: " .. playerName)
      setDNAVars()
    end
  end

  --if event == "PLAYER_LOGIN" then
    --updateVars()
  --end
end)

SLASH_DNA1 = "/DNA"
SLASH_DNA2 = "/destructive"
function SlashCmdList.DNA(msg)
  -- print("debug " .. DNA)
end

function setDNAVars()
  --if (DNA[playerName]["ARSalv"]) then
    --checkbox["ARSalv"]:SetChecked(true);
  --end
end

--[==[
function saveDNAVars()
  DNA[playerName]["tank1"] = "Porthios"
  DNA[playerName]["tank2"] = "Aellwyn"
  DNA[playerName]["tank3"] = "Mairakus"
  DNA[playerName]["tank4"] = "Grayleaf"
  DNA[playerName]["tank5"] = "Stumpymcaxe"
end
]==]--

local function updateSlotPos(spec, i, name)
  local _spec = spec
  DNA[playerName][_spec] = name
end

local DNAframeMain = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
DNAframeMain:SetWidth(DNAGlobal[5])
DNAframeMain:SetHeight(DNAGlobal[7])
DNAframeMain:SetPoint("CENTER", 0, 0)
DNAframeMain:SetMovable(true)
DNAframeMain.text = DNAframeMain:CreateFontString(nil, "ARTWORK")
DNAframeMain.text:SetFont(DNAGlobal[9], 15, "OUTLINE")
DNAframeMain.text:SetPoint("TOPLEFT", DNAframeMain, "TOPLEFT", 12, -4)
DNAframeMain.text:SetText("|cffFF7D0A " .. DNAGlobal[1] .. " " .. DNAGlobal[3])
DNAframeMainBG = DNAframeMain:CreateTexture(nil, "BORDER", DNAframeMain, 0)
DNAframeMainBG:SetSize(DNAGlobal[5]-16, DNAGlobal[7]-34)
DNAframeMainBG:SetPoint("TOPLEFT", 8, -28)
DNAframeMainBG:SetColorTexture(0, 0, 0, 1)
local pageAssign = CreateFrame("Frame", nil, DNAframeMain)
pageAssign:SetWidth(DNAGlobal[5])
pageAssign:SetHeight(DNAGlobal[7])
pageAssign:SetPoint("TOPLEFT", 0, 0)
--pageAssign.bg = pageAssign:CreateTexture(nil, "BACKGROUND");
--pageAssign.bg:SetAllPoints(true);
--pageAssign.bg:SetColorTexture(0, 0.4, 0, 0.4);
local pageAssignDiv = pageAssign:CreateTexture(nil, "ARTWORK")
pageAssignDiv:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-Achievement-MetalBorder-Left")
pageAssignDiv:SetSize(10, DNAGlobal[7]+42)
pageAssignDiv:SetPoint("CENTER", 0, -40)
local pageDKP = CreateFrame("Frame", nil, DNAframeMain)
pageAssign:SetWidth(DNAGlobal[5])
pageAssign:SetHeight(DNAGlobal[7])
pageAssign:SetPoint("TOPLEFT", 0, 0)


--[==[
local UILeft = f:CreateTexture(nil, "BACKGROUND", nil, 0)
UILeft:SetTexture("Interface/COMMON/GreyBorder64-Left")
UILeft:SetSize(height, height)
UILeft:SetPoint("TOPLEFT", 0, 4)

pageAssign.ScrollFrame = CreateFrame("ScrollFrame", nil, pageAssign, "UIPanelScrollFrameTemplate");
pageAssign.ScrollFrame:SetPoint("TOPLEFT", pageAssign, "TOPLEFT", 10, -40);
pageAssign.ScrollFrame:SetPoint("BOTTOMRIGHT", pageAssign, "BOTTOMRIGHT", 10, 20);
local DNAScrollChildFrame = CreateFrame("Frame", nil, pageAssign.ScrollFrame);
DNAScrollChildFrame:SetSize(DNAGlobal[5]-20, DNAGlobal[7]);
DNAScrollChildFrame.bg = DNAScrollChildFrame:CreateTexture(nil, "BACKGROUND");
DNAScrollChildFrame.bg:SetAllPoints(true);
--DNAScrollChildFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.4);
pageAssign.ScrollFrame:SetScrollChild(DNAScrollChildFrame);

pageAssign.ScrollFrame.ScrollBar:ClearAllPoints();
pageAssign.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", pageAssign.ScrollFrame, "TOPRIGHT", -150, -10);
pageAssign.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", pageAssign.ScrollFrame, "BOTTOMRIGHT", 100, 10);

]==]--

--[==[
MULTILINE
local s = CreateFrame("ScrollFrame", nil, pageAssign, "UIPanelScrollFrameTemplate") -- or you actual parent instead
s:SetSize(300,200)
s:SetPoint("CENTER")
local e = CreateFrame("EditBox", nil, s)
e:SetMultiLine(true)
e:SetFontObject(ChatFontNormal)
e:SetWidth(300)
s:SetScrollChild(e)
--- demo multi line text
e:SetText("line 1\nline 2\nline 3\nmore...\n\n\n\n\n\nanother one\n"
.."some very long...dsf v asdf a sdf asd df as df asdf a sdfd as ddf as df asd f asd fd asd f asdf LONG LINE\n\n\nsome more.\nlast!")
e:HighlightText() -- select all (if to be used for copy paste)
-- optional/just to close that frame
e:SetScript("OnEscapePressed", function()
  s:Hide()
end)
]==]--

local function labelField(parentFrame, name, x, y, header)
  local t = CreateFrame("Frame", nil, parentFrame)
  t:SetWidth(150)
  t:SetHeight(30)
  t:SetPoint("TOPLEFT", x, -y)
  t.text = t:CreateFontString(nil, "ARTWORK")
  t.text:SetPoint("TOPLEFT", t, "TOPLEFT", 0, 0)
  if (header == true) then
    t.text:SetFont(DNAGlobal[9], 18, "OUTLINE")
    t.text:SetText("|cffFF7D0A" .. name)
  else
    t.text:SetFont(DNAGlobal[9], 15, "OUTLINE")
    t.text:SetText(name)
  end
end

local _editBox = {}
local function editField(parentFrame, name, x, y, width, placeholder)
  local height=26
  _editBox[name] = CreateFrame("Frame", nil, parentFrame)
  _editBox[name]:SetPoint("TOPLEFT", x, -y)
  _editBox[name]:SetWidth(width)
  _editBox[name]:SetHeight(height)
  local UIBack = _editBox[name]:CreateTexture(nil, "BACKGROUND", nil, 0)
  UIBack:SetColorTexture(0.1, 0.1, 0.1, 0.6);
  UIBack:SetSize(width+height*1.8, height-6)
  UIBack:SetPoint("TOPLEFT", 2, 0)
  local UILeft = _editBox[name]:CreateTexture(nil, "BACKGROUND", nil, 0)
  UILeft:SetTexture("Interface/COMMON/GreyBorder64-Left")
  UILeft:SetSize(height, height)
  UILeft:SetPoint("TOPLEFT", 0, 4)
  local UIMid = _editBox[name]:CreateTexture(nil, "BACKGROUND", nil, 0)
  UIMid:SetTexture("Interface/COMMON/GreyBorder64-Mid")
  UIMid:SetSize(width, height)
  UIMid:SetPoint("TOPLEFT", height, 4)
  local UIRight = _editBox[name]:CreateTexture(nil, "BACKGROUND", nil, 0)
  UIRight:SetTexture("Interface/COMMON/GreyBorder64-Right")
  UIRight:SetSize(height, height)
  UIRight:SetPoint("TOPLEFT", width+height, 4)

  _editBox[name].enter = CreateFrame("EditBox", nil, _editBox[name])
  _editBox[name].enter:SetWidth(width+40)
  _editBox[name].enter:SetHeight(height)
  _editBox[name].enter:SetFontObject("GameFontNormal")
  --_editBox[name].enter:SetNormalFontObject("GameFontNormal");
  --_editBox[name].enter:SetHighlightFontObject("GameFontHighlight");
  --_editBox[name].enter:SetBackdrop(GameTooltip:GetBackdrop()) --DEBUG
  _editBox[name].enter:SetBackdropColor(0, 0, 1, 0.8)
  _editBox[name].enter:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
  _editBox[name].enter:SetTextColor(1, 1, 1, 1)
  _editBox[name].enter:SetPoint("TOPLEFT", 6, 4)
  _editBox[name].enter:ClearFocus(self)
  _editBox[name].enter:SetAutoFocus(false)
  _editBox[name].enter:Insert(placeholder)
end

DNAframeMain:Hide();
pageDKP:Hide()

local instance={
  {"MC", "Molten Core", "Interface/GLUES/LoadingScreens/LoadScreenMoltenCore"},
  {"BWL", "Blackwing Lair", "Interface/GLUES/LoadingScreens/LoadScreenBlackWingLair"},
  {"AQ40","Ahn'Qiraj", "Interface/GLUES/LoadingScreens/LoadScreenAhnQiraj40man"},
  --{"NAXX","Naxxramas", "Interface/GLUES/LoadingScreens/LoadScreenNaxxramas"},
}
local raidBoss = {
  {"MC", "Trash", "Lucifron", "Dogpack", "Magmadar", "Gehennes", "All"},
  {"BWL", "Razergore", "Vaelestraz", "Dragon Pack", "All"},
  {"AQ40","Trash", "Prophet Skerem"},
}
local markers={
  {"{rt8}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8"}, --skull
  {"{rt7}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_7"}, --cross
  {"{rt4}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_4"}, --triangle
  {"{rt2}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_2"}, --circle
  {"{rt6}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_6"}, --square
  {"{rt3}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_3"}, --diamond
  {"{rt5}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_5"}, --moon
  {"{rt1}", "Interface/TARGETINGFRAME/UI-RaidTargetingIcon_1"}, --star
}

local function classColorText(frame, class)
  local rgb = {1.00, 1.00, 1.00} --priest default
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
  return frame.text:SetTextColor(rgb[1],rgb[2],rgb[3])
end

local sideTab = {}
local tabBack = {}
local tabBorder = {}
local tabSpark = {}
local pageTab = {}
local sidetab_w=42
local sidetab_h=30
local tabSelect = instance[1][1] --default tab
local ddBossList = {}
for i, v in ipairs(instance) do
  pageTab[instance[i][1]] = CreateFrame("Frame", nil, pageAssign)
  pageTab[instance[i][1]]:SetPoint("TOPLEFT", DNAGlobal[5]/2, 0)
  pageTab[instance[i][1]]:SetWidth(DNAGlobal[5]/2)
  pageTab[instance[i][1]]:SetHeight(DNAGlobal[7])
  local pageBanner = pageTab[instance[i][1]]:CreateTexture(nil, "BACKGROUND", pageTab[instance[i][1]], 0)
  pageBanner:SetTexture(instance[i][3]) --default
  pageBanner:SetTexCoord(0, 1, 0.25, 0.50)
  pageBanner:SetSize(DNAGlobal[5]/2-8, 54)
  pageBanner:SetPoint("TOPLEFT", 0, -28)
  local pageBannerBorder = pageTab[instance[i][1]]:CreateTexture(nil, "BACKGROUND", pageTab[instance[i][1]], 1)
  pageBannerBorder:SetTexture("Interface/ACHIEVEMENTFRAME/UI-Achievement-MetalBorder-Top")
  pageBannerBorder:SetSize(DNAGlobal[5]/2+42, 14)
  pageBannerBorder:SetPoint("TOPLEFT", 0, -75)
  pageBanner.text = pageTab[instance[i][1]]:CreateFontString(nil, "ARTWORK")
  pageBanner.text:SetFont("Fonts/MORPHEUS.ttf", 18, "OUTLINE")
  pageBanner.text:SetText("|cffffe9b0" .. instance[i][2])
  pageBanner.text:SetPoint("TOPLEFT", pageBanner, "TOPLEFT", 30, -8)
end

local function leftTab(name, pos_y)
  sideTab[name] = CreateFrame("Frame", nil, DNAframeMain)
  --sideTab[name]:SetFrameStrata("BACKGROUND") --DEBUG
  sideTab[name]:SetPoint("TOPLEFT", -sidetab_w, -pos_y)
  sideTab[name]:SetWidth(sidetab_w)
  sideTab[name]:SetHeight(sidetab_h)
  tabBack[name] = sideTab[name]:CreateTexture(nil, "BACKGROUND", nil, 0)
  --tabBack[name]:SetTexture("Interface/RAIDFRAME/UI-RaidFrame-GroupBg")
  --tabBack[name]:SetTexCoord(0, 1, 0, 0.50)
  tabBack[name]:SetColorTexture(0, 0, 0, 1)
  tabBack[name]:SetSize(sidetab_w, sidetab_h-4)
  tabBack[name]:SetPoint("TOPLEFT", 4, -2)
  sideTab[name].text = sideTab[name]:CreateFontString(nil, "ARTWORK")
  sideTab[name].text:SetFont(DNAGlobal[9], 12, "OUTLINE")
  sideTab[name].text:SetText("|cffb3b3b3" .. name)
  sideTab[name].text:SetPoint("TOPLEFT", sideTab[name], "TOPLEFT", 4, -10)
  tabBorder[name] = sideTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  tabBorder[name]:SetTexture("Interface/Glues/LoadingBar/Loading-BarBorder")
  tabBorder[name]:SetSize(71, 56)
  tabBorder[name]:SetPoint("TOPLEFT", -25, 12)
  tabBorder[name]:SetTexCoord(0, 0.15, 0, 1)
  tabSpark[name] = sideTab[name]:CreateTexture(nil, "OVERLAY", nil, 0)
  tabSpark[name]:SetTexture("Interface/Glues/LoadingBar/UI-LoadingBar-Spark")
  tabSpark[name]:SetSize(20, 8)
  tabSpark[name]:SetPoint("TOPLEFT", -27, -12)
  tabSpark[name]:Hide()
  tabScript = {}
  tabScript[name] = CreateFrame("Button", nil, sideTab[name], nil)
  tabScript[name]:SetSize(sidetab_w+20, sidetab_h+10)
  tabScript[name]:SetPoint("CENTER", 0, 0)
  tabScript[name]:SetScript("OnClick", function()
    for i, v in ipairs(instance) do
      tabDisable(instance[i][1])
      pageTab[instance[i][1]]:Hide() --disable all tabs first
      ddBossList[instance[i][1]]:Hide()
    end
    tabEnable(name)
    tabSelect = name
    local instanceNum = get_mkey_from_mvalue(instance, name)
    pageTab[instance[instanceNum][1]]:Show()
    ddBossList[name]:Show()
    --ddBossList[name].text:SetText(raidBoss[instanceNum][2]) --dont use primary value
    ddBossList[name].text:SetText("Select a boss")
  end)
end

local botTab = {}
local botBack = {}
local botBorder = {}
local function bottomTab(name, pos_x, text_pos_x)
  botTab[name] = CreateFrame("Frame", nil, DNAframeMain)
  botTab[name]:SetPoint("BOTTOMLEFT", pos_x, -40)
  botTab[name]:SetWidth(85)
  botTab[name]:SetHeight(60)
  botTab[name]:SetFrameStrata("LOW")
  botTab[name].text = botTab[name]:CreateFontString(nil, "ARTWORK")
  botTab[name].text:SetFont(DNAGlobal[9], 11, "OUTLINE")
  botTab[name].text:SetText("|cffb3b3b3" .. name)
  botTab[name].text:SetPoint("TOPLEFT", botTab[name], "TOPLEFT", text_pos_x, -23)
  botBorder[name] = botTab[name]:CreateTexture(nil, "BORDER", nil, 0)
  botBorder[name]:SetTexture("Interface/FriendsFrame/UI-FriendsFrameTab")
  botBorder[name]:SetSize(85, 60)
  botBorder[name]:SetPoint("TOPLEFT", 0, 0)
  botTabScript = {}
  --bottabScript[name] = CreateFrame("Button", nil, botTab[name], "UIPanelButtonTemplate")
  botTabScript[name] = CreateFrame("Button", nil, botTab[name])
  botTabScript[name]:SetSize(85, 30)
  botTabScript[name]:SetPoint("CENTER", 0, 0)
  botTabScript[name]:SetScript("OnClick", function()
    --print(name)
    if (name == "DKP") then
      botTab["Assignment"]:SetFrameStrata("LOW")
      botTab["DKP"]:SetFrameStrata("MEDIUM")
      botTab["Raid Comp"]:SetFrameStrata("LOW")
      pageAssign:Hide()
      pageDKP:Show()
    end
    if (name == "Assignment") then
      botTab["Assignment"]:SetFrameStrata("MEDIUM")
      botTab["DKP"]:SetFrameStrata("LOW")
      botTab["Raid Comp"]:SetFrameStrata("LOW")
      pageAssign:Show()
      pageDKP:Hide()
    end
    if (name == "Raid Comp") then
      botTab["Assignment"]:SetFrameStrata("LOW")
      botTab["DKP"]:SetFrameStrata("LOW")
      botTab["Raid Comp"]:SetFrameStrata("MEDIUM")
      pageAssign:Hide()
      pageDKP:Hide()
    end
  end)
end

for i, v in ipairs(instance) do
  leftTab(instance[i][1], i*40) --draw all tabs
end

function tabDisable(name)
  tabBorder[name]:SetSize(71, 56)
  tabBorder[name]:SetPoint("TOPLEFT", -25, 12)
  tabBack[name]:SetSize(sidetab_w, sidetab_h-4)
  tabBack[name]:SetPoint("TOPLEFT", 4, -2)
  sideTab[name].text:SetText("|cffb3b3b3" .. name)
  sideTab[name].text:SetPoint("TOPLEFT", sideTab[name], "TOPLEFT", 4, -10)
  tabSpark[name]:Hide()
end
function tabEnable(name)
  tabBorder[name]:SetSize(82, 56)
  tabBorder[name]:SetPoint("TOPLEFT", -34, 12)
  tabBack[name]:SetSize(sidetab_w+8, sidetab_h-4)
  tabBack[name]:SetPoint("TOPLEFT", 1, -2)
  sideTab[name].text:SetText("|cfffff499" .. name)
  sideTab[name].text:SetPoint("TOPLEFT", sideTab[name], "TOPLEFT", 0, -10)
  tabSpark[name]:Show()
end

for i, v in ipairs(instance) do
  pageTab[instance[i][1]]:Hide() --hide pages
end
tabEnable(instance[1][1]) --enable the first tab
pageTab[instance[1][1]]:Show() --show first page

-- BO PAGE ASSIGN

--[==[
local formX = 40
labelField(pageAssign, "Tanks", formX-15, 35, true)

labelField(pageAssign, "Warriors",formX, 60, false)
editField (pageAssign, "tanksw", formX+60, 60, 220, "")
labelField(pageAssign, "Druids", formX, 90, false)
editField (pageAssign, "tanksd", formX+60, 90, 220, "")

labelField(pageAssign, "Healers", formX-15, 115, true)

labelField(pageAssign, "Priests", formX, 140, false)
editField (pageAssign, "healerspr", formX+60, 140, 220, "")
labelField(pageAssign, "Paladins", formX, 170, false)
editField (pageAssign, "healerspa",formX+60, 170, 220, "")
labelField(pageAssign, "Druids", formX, 200, false)
editField (pageAssign, "healersdr", formX+60, 200, 220, "")

labelField(pageAssign, "DPS", formX-15, 235, true)

labelField(pageAssign, "Warriors", formX, 260, false)
editField (pageAssign, "warriors", formX+60, 260, 220, "")
labelField(pageAssign, "Warlocks", formX, 290, false)
editField (pageAssign, "warlocks", formX+60, 290, 220, "")
labelField(pageAssign, "Rogues", formX, 320, false)
editField (pageAssign, "rogues", formX+60, 320, 220, "")
labelField(pageAssign, "Mages", formX, 350, false)
editField (pageAssign, "mages", formX+60, 350, 220, "")
labelField(pageAssign, "Hunters", formX, 380, false)
editField (pageAssign, "hunters", formX+60, 380, 220, "")
labelField(pageAssign, "Paladins", formX, 410, false)
editField (pageAssign, "paladins", formX+60, 410, 220, "")
labelField(pageAssign, "Druids", formX, 440, false)
editField (pageAssign, "druids", formX+60, 440, 220, "")
labelField(pageAssign, "Priests", formX, 470, false)
editField (pageAssign, "priests", formX+60, 470, 220, "")
]==]--

local DNARaidList_w = 120
local DNARaidList_h = 406
local memberBox = {}
local memberBoxBG = {}
local memberBoxScript = {}
local memberBoxIcon = {}
local classCount = {}
local memberBox_h = 20

local DNARaidList = CreateFrame("Frame", DNARaidList, pageAssign, "InsetFrameTemplate3")
DNARaidList:SetWidth(DNARaidList_w+20) --add scroll frame width
DNARaidList:SetHeight(DNARaidList_h)
DNARaidList:SetPoint("TOPLEFT", 30, -80)
DNARaidList.ScrollFrame = CreateFrame("ScrollFrame", nil, DNARaidList, "UIPanelScrollFrameTemplate")
DNARaidList.ScrollFrame:SetPoint("TOPLEFT", DNARaidList, "TOPLEFT", 3, -10)
DNARaidList.ScrollFrame:SetPoint("BOTTOMRIGHT", DNARaidList, "BOTTOMRIGHT", 10, 20)
local DNARaidListScrollChildFrame = CreateFrame("Frame", DNARaidListScrollChildFrame, DNARaidList.ScrollFrame)
DNARaidListScrollChildFrame:SetSize(DNARaidList_w, DNARaidList_h)
DNARaidList.text = DNARaidList:CreateFontString(nil, "ARTWORK")
DNARaidList.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
DNARaidList.text:SetPoint("CENTER", DNARaidList, "TOPLEFT", 60, 10)
DNARaidList.text:SetText("Raid")
--DNARaidListScrollChildFrame.bg = DNARaidListScrollChildFrame:CreateTexture(nil, "BACKGROUND")
--DNARaidListScrollChildFrame.bg:SetAllPoints(true)
--DNARaidListScrollChildFrame.bg:SetColorTexture(0, 0.4, 0, 0.4); --DEBUG
DNARaidList.ScrollFrame:SetScrollChild(DNARaidListScrollChildFrame)
DNARaidList.ScrollFrame.ScrollBar:ClearAllPoints()
DNARaidList.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNARaidList.ScrollFrame, "TOPRIGHT", 0, -10)
DNARaidList.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNARaidList.ScrollFrame, "BOTTOMRIGHT", -40, -1)

local memberBoxOrgPoint_x = {}
local memberBoxOrgPoint_y = {}
local memberDrag = nil
function memberRow(parentFrame, name, class, y) --class?
  memberBox[name] = CreateFrame("Frame", memberBox[name], parentFrame, "InsetFrameTemplate3")
  memberBox[name]:SetFrameLevel(10)
  memberBox[name]:SetMovable(true)
  memberBox[name]:EnableMouse(true)
  memberBox[name]:RegisterForDrag("LeftButton")
  memberBoxOrgPoint_x[name] = 0
  memberBoxOrgPoint_y[name] = -y+22
  memberBox[name]:SetScript("OnDragStart", function()
      memberBox[name]:StartMoving()
      memberBox[name]:SetParent(pageAssign)
      memberBox[name]:SetWidth(DNARaidList_w-5) --preserve the width and height
      memberBox[name]:SetHeight(memberBox_h)
      memberDrag = name
      --memberBox[name]:SetScript("OnUpdate", UpdateMapButton)
  end)
  memberBox[name]:SetScript("OnDragStop", function()
      memberBox[name]:StopMovingOrSizing()
      memberBox[name]:SetParent(parentFrame)
      memberBox[name]:SetPoint("TOPLEFT", memberBoxOrgPoint_x[name], memberBoxOrgPoint_y[name])
      memberBox[name]:SetWidth(DNARaidList_w-5)
      memberBox[name]:SetHeight(memberBox_h)
  end)
  memberBox[name]:SetWidth(DNARaidList_w-5)
  memberBox[name]:SetHeight(memberBox_h)
  memberBox[name]:SetPoint("TOPLEFT", memberBoxOrgPoint_x[name], memberBoxOrgPoint_y[name])
  memberBox[name].text = memberBox[name]:CreateFontString(nil, "ARTWORK")
  memberBox[name].text:SetFont(DNAGlobal[9], 12, "OUTLINE")
  memberBox[name].text:SetPoint("CENTER", memberBox[name], "CENTER", 0, 0)
  memberBox[name].text:SetText(name)
  memberBoxBG[name] = memberBox[name]:CreateTexture(nil, "BACKGROUND", memberBox[name], 0)
  memberBoxBG[name]:SetSize(DNARaidList_w-5, memberBox_h+2)
  memberBoxBG[name]:SetPoint("TOPLEFT", 0, 0)
  classColorText(memberBox[name], class)
end

local tankSlots = 6
local tankFrame = CreateFrame("Frame", tankFrame, pageAssign, "InsetFrameTemplate3")
tankFrame:SetWidth(DNARaidList_w+6)
tankFrame:SetHeight((tankSlots*20)+4)
tankFrame:SetPoint("TOPLEFT", 200, -80)
tankFrame.text = tankFrame:CreateFontString(nil, "ARTWORK")
tankFrame.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
tankFrame.text:SetPoint("CENTER", tankFrame, "TOPLEFT", 60, 10)
tankFrame.text:SetText("Tanks")
tankFrame:SetFrameLevel(2)
--[==[
tankFrameIcon = tankFrame:CreateTexture(nil, "ARTWORK")
tankFrameIcon:SetTexture("Interface/Icons/inv_shield_06")
tankFrameIcon:SetSize(18, 18)
tankFrameIcon:SetPoint("TOPLEFT", 10, 18)
]==]--

local tankSlot = {}
--local tankSlotRemove = {}
local tankSlotOrgPoint_x = {}
local tankSlotOrgPoint_y = {}
for i = 1, tankSlots do
  tankSlot[i] = CreateFrame("Frame", tankSlot[i], tankFrame, "InsetFrameTemplate3")
  tankSlot[i]:SetWidth(DNARaidList_w)
  tankSlot[i]:SetHeight(20)
  tankSlotOrgPoint_x[i] = 3
  tankSlotOrgPoint_y[i] = (-i*20)+18
  --tankSlot[i]:SetPoint("TOPLEFT", 3, (-i*20)+18)
  tankSlot[i]:SetPoint("TOPLEFT", tankSlotOrgPoint_x[i], tankSlotOrgPoint_y[i])
  tankSlot[i].text = tankSlot[i]:CreateFontString(nil, "ARTWORK")
  tankSlot[i].text:SetFont(DNAGlobal[9], 12, "OUTLINE")
  tankSlot[i].text:SetPoint("CENTER", tankSlot[i], "TOPLEFT", 60, -10)
  tankSlot[i].text:SetText("Empty")
  tankSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  tankSlot[i]:EnableMouse()
  tankSlot[i]:SetMovable(true)
  tankSlot[i]:RegisterForDrag("LeftButton")
  tankSlot[i]:SetScript("OnDragStart", function()
    tankSlot[i]:StartMoving()
  end)
  tankSlot[i]:SetScript("OnDragStop", function()
    tankSlot[i]:StopMovingOrSizing()
    tankSlot[i].text:SetText("Empty")
    tankSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
    tankSlot[i]:SetPoint("TOPLEFT", tankSlotOrgPoint_x[i], tankSlotOrgPoint_y[i])
    updateSlotPos("tank", i, "-")
  end)
  tankSlot[i]:SetScript('OnEnter', function()
    --print("DEBUG: OVER tankSlot[" .. i .. "]")
    if (memberDrag) then
      tankSlot[i].text:SetText(memberDrag)
      --print(tankSlot[i].text:GetText())
      classColorText(tankSlot[i], raidMember[memberDrag])
      updateSlotPos("tank", i, memberDrag)
    end
  end)
  tankSlot[i]:SetScript('OnLeave', function()
    --print("DEBUG: OUT tankSlot[" .. i .. "]")
    memberDrag = nil
  end)
end

local healSlots = 12
local healFrame = CreateFrame("Frame", healFrame, pageAssign, "InsetFrameTemplate3")
healFrame:SetWidth(DNARaidList_w+6)
healFrame:SetHeight((healSlots*20)+4)
healFrame:SetPoint("TOPLEFT", 200, -240)
healFrame.text = healFrame:CreateFontString(nil, "ARTWORK")
healFrame.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
healFrame.text:SetPoint("CENTER", healFrame, "TOPLEFT", 62, 10)
healFrame.text:SetText("Healers")
healFrame:SetFrameLevel(2)
--[==[
healFrameIcon = healFrame:CreateTexture(nil, "ARTWORK")
healFrameIcon:SetTexture("Interface/Icons/spell_holy_greaterheal")
healFrameIcon:SetSize(18, 18)
healFrameIcon:SetPoint("TOPLEFT", 10, 18)
]==]--

local healSlot = {}
local healSlotOrgPoint_x = {}
local healSlotOrgPoint_y = {}
for i = 1, healSlots do
  healSlot[i] = CreateFrame("Frame", healSlot[i], healFrame, "InsetFrameTemplate3")
  healSlot[i]:SetWidth(DNARaidList_w)
  healSlot[i]:SetHeight(20)
  healSlotOrgPoint_x[i] = 3
  healSlotOrgPoint_y[i] = (-i*20)+18
  --healSlot[i]:SetPoint("TOPLEFT", 3, (-i*20)+18)
  healSlot[i]:SetPoint("TOPLEFT", healSlotOrgPoint_x[i], healSlotOrgPoint_y[i])
  healSlot[i].text = healSlot[i]:CreateFontString(nil, "ARTWORK")
  healSlot[i].text:SetFont(DNAGlobal[9], 12, "OUTLINE")
  healSlot[i].text:SetPoint("CENTER", healSlot[i], "TOPLEFT", 60, -10)
  healSlot[i].text:SetText("Empty")
  healSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
  healSlot[i]:EnableMouse()
  healSlot[i]:SetMovable(true)
  healSlot[i]:RegisterForDrag("LeftButton")
  healSlot[i]:SetScript("OnDragStart", function()
    healSlot[i]:StartMoving()
  end)
  healSlot[i]:SetScript("OnDragStop", function()
    healSlot[i]:StopMovingOrSizing()
    healSlot[i].text:SetText("Empty")
    healSlot[i].text:SetTextColor(0.3, 0.3, 0.3)
    healSlot[i]:SetPoint("TOPLEFT", healSlotOrgPoint_x[i], healSlotOrgPoint_y[i])
  end)
  healSlot[i]:SetScript('OnEnter', function()
    --print("DEBUG: OVER healSlot[" .. i .. "]")
    if (memberDrag) then
      healSlot[i].text:SetText(memberDrag)
      --print(healSlot[i].text:GetText())
      classColorText(healSlot[i], raidMember[memberDrag])
    end
  end)
  healSlot[i]:SetScript('OnLeave', function()
    --print("DEBUG: OUT healSlot[" .. i .. "]")
    memberDrag = nil
  end)
end

--alpha sort the member matrix
local raidMemberSorted = {}
local raidMemberA = {}
for k in pairs(raidMember) do
  table.insert(raidMemberSorted, k)
end
table.sort(raidMemberSorted)
local raidCounter = 0
for n,k in ipairs(raidMemberSorted) do
  raidCounter = raidCounter+1;
  memberRow(DNARaidListScrollChildFrame, k, raidMember[k], raidCounter*20)
end

--[==[
btnImport = CreateFrame("Button", nil, pageAssign, "UIPanelButtonTemplate")
btnImport:SetSize(100, 25)
btnImport:SetPoint("TOPLEFT", 20, -50)
btnImport.text = btnImport:CreateFontString(nil, "ARTWORK")
btnImport.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
btnImport.text:SetText("Import")
--btnImport.text:SetPoint("CENTER", btnImport, "TOPLEFT", 4, -8)
btnImport.text:SetPoint("CENTER", btnImport)
btnImport:SetScript("OnClick", function()
  print("Import")
end)
]==]--

--[==[
local largeTextBox = CreateFrame("Frame", nil, pageAssign)
largeTextBox:SetPoint("TOPLEFT", 500, 100)
largeTextBox:SetWidth(400)
largeTextBox:SetHeight(500)
largeTextBox.enter = CreateFrame("EditBox", nil, largeTextBox)
largeTextBox.enter:SetWidth(440)
largeTextBox.enter:SetHeight(500)
largeTextBox.enter:SetMultiLine(true)
largeTextBox.enter:SetFontObject("GameFontNormal")
--largeTextBox.enter:SetNormalFontObject("GameFontNormal");
--largeTextBox.enter:SetHighlightFontObject("GameFontHighlight");
largeTextBox.enter:SetBackdrop(GameTooltip:GetBackdrop()) --DEBUG
largeTextBox.enter:SetBackdropColor(0, 0, 1, 0.8)
largeTextBox.enter:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
largeTextBox.enter:SetTextColor(1, 1, 1, 1)
largeTextBox.enter:SetPoint("TOPLEFT", 6, 4)
largeTextBox.enter:ClearFocus(self)
largeTextBox.enter:SetAutoFocus(false)
largeTextBox.enter:Insert(placeholder)
]==]--

local ltb_w = 400
local ltb_h = 400
local ltb_x = 400
local ltb_y = 100
--local largeTextBoxFrame = CreateFrame("Frame", nil, pageAssign, "UIPanelDialogTemplate")
local largeTextBoxFrame = CreateFrame("Frame", nil, pageAssign, "InsetFrameTemplate3")
largeTextBoxFrame:SetWidth(ltb_w-20)
largeTextBoxFrame:SetHeight(ltb_h-20)
largeTextBoxFrame:SetPoint("TOPLEFT", ltb_x+5, -ltb_y-20)
largeTextBoxFrame:SetMovable(true)
--largeTextBoxFrame.text = largeTextBoxFrame:CreateFontString(nil,"ARTWORK")
--largeTextBoxFrame.text:SetFont(DNAGlobal[9], 15, "OUTLINE")
--largeTextBoxFrame.text:SetPoint("TOPLEFT", largeTextBoxFrame, "TOPLEFT", 10, -9)
--largeTextBoxFrame.text:SetText("test")
largeTextBoxFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, largeTextBoxFrame, "UIPanelScrollFrameTemplate")
largeTextBoxFrame.ScrollFrame:SetPoint("TOPLEFT", largeTextBoxFrame, "TOPLEFT", 5, -20)
largeTextBoxFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", largeTextBoxFrame, "BOTTOMRIGHT", 10, 20)
local LTBScrollChildFrame = CreateFrame("Frame", nil, largeTextBoxFrame.ScrollFrame)
LTBScrollChildFrame:SetSize(ltb_w, ltb_h)
LTBScrollChildFrame.bg = LTBScrollChildFrame:CreateTexture(nil, "BACKGROUND")
LTBScrollChildFrame.bg:SetAllPoints(true)
--DNAScrollChildFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.4)
largeTextBoxFrame.ScrollFrame:SetScrollChild(LTBScrollChildFrame)
largeTextBoxFrame.ScrollFrame.ScrollBar:ClearAllPoints()
largeTextBoxFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", largeTextBoxFrame.ScrollFrame, "TOPRIGHT", -150, -10)
largeTextBoxFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", largeTextBoxFrame.ScrollFrame, "BOTTOMRIGHT", 100, 10)
local largeTextBox = CreateFrame("Frame", nil, pageAssign)
largeTextBox:SetPoint("TOPLEFT", ltb_x, ltb_y)
largeTextBox:SetWidth(ltb_w+200)
largeTextBox:SetHeight(ltb_h)
largeTextBox.enter = CreateFrame("EditBox", nil, LTBScrollChildFrame)
largeTextBox.enter:SetWidth(ltb_w-60)
largeTextBox.enter:SetHeight(ltb_h)
largeTextBox.enter:SetMultiLine(true)
largeTextBox.enter:SetFontObject("GameFontNormal")
largeTextBox.enter:SetBackdrop(GameTooltip:GetBackdrop()) --DEBUG
largeTextBox.enter:SetBackdropColor(0, 0, 1, 0.8)
largeTextBox.enter:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
largeTextBox.enter:SetTextColor(1, 1, 1, 1)
largeTextBox.enter:SetPoint("TOPLEFT", 6, 0)
largeTextBox.enter:ClearFocus(self)
largeTextBox.enter:SetAutoFocus(false)
largeTextBox.enter:Insert(placeholder)

for i, v in ipairs(instance) do
  --pageTab[instance[i][1]]
  ddBossList[instance[i][1]] = CreateFrame("frame", nil, pageAssign, "UIDropDownMenuTemplate")
  ddBossList[instance[i][1]]:SetPoint("TOPLEFT", 500, -90)
  ddBossList[instance[i][1]].text = ddBossList[instance[i][1]]:CreateFontString(nil, "ARTWORK")
  ddBossList[instance[i][1]].text:SetFont(DNAGlobal[9], 12, "OUTLINE")
  ddBossList[instance[i][1]].text:SetPoint("TOPLEFT", ddBossList[instance[i][1]], "TOPLEFT", 25, -8);
  local instanceNum = get_mkey_from_mvalue(instance, instance[i][1])
  ddBossList[instance[i][1]].text:SetText(raidBoss[instanceNum][1])
  --print(raidBoss[instanceNum][1])
  ddBossList[instance[i][1]].onClick = function(self, checked)
  	-- print(app_global .. "Debug Notifications: " .. self.value)
    ddBossList[instance[i][1]].text:SetText(self.value)
    --saveDNAVars()
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
  UIDropDownMenu_SetWidth(ddBossList[instance[i][1]], 145)
end
-- on load set to second value
--ddBossList[raidBoss[1][1]].text:SetText(raidBoss[1][2])
ddBossList[raidBoss[1][1]].text:SetText("Select a boss")

btnShare = CreateFrame("Button", nil, pageAssign, "UIPanelButtonTemplate")
btnShare:SetSize(120, 28)
btnShare:SetPoint("TOPLEFT", 140, -DNAGlobal[7]+40)
btnShare.text = btnShare:CreateFontString(nil, "ARTWORK")
btnShare.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
btnShare.text:SetText("Update")
btnShare.text:SetPoint("CENTER", btnShare)
btnShare:SetScript("OnClick", function()
  print("Update")
end)

btnPostRaid = CreateFrame("Button", nil, pageAssign, "UIPanelButtonTemplate")
btnPostRaid:SetSize(120, 28)
btnPostRaid:SetPoint("TOPLEFT", DNAGlobal[5]-250, -DNAGlobal[7]+40)
btnPostRaid.text = btnPostRaid:CreateFontString(nil, "ARTWORK")
btnPostRaid.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
btnPostRaid.text:SetText("Post to Raid")
btnPostRaid.text:SetPoint("CENTER", btnPostRaid)
btnPostRaid:SetScript("OnClick", function()
  print("Post to Raid")
end)
-- EO PAGE ASSIGN

bottomTab("Assignment", 30, 6)
bottomTab("DKP", 120, 26)
bottomTab("Raid Comp", 210, 10)

-- INITIALIZE
botTab["Assignment"]:SetFrameStrata("MEDIUM") -- default selected
ddBossList[instance[1][1]]:Show() -- show first one

--[==[
function chat_message(msg, channel)
  SendChatMessage(DNAapp_global .. msg, channel);
end

profList = playerName;
profState = "Primary";
profCount = 0;
--debugList= "none";
local function pullProfessions()
  for skillIndex = 1, GetNumSkillLines() do
    local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(skillIndex)
    if (isAbandonable) then
      profCount = profCount + 1;
      if (profCount <= 2) then
  		  profList = profList .. GetSkillLineInfo(skillIndex);
      end
  	end
    if skillName == "Cooking" then
  		hasCooking = GetSkillLineInfo(skillIndex);
  	end
  	if skillName == "First Aid" then
  		hasFirstAid = GetSkillLineInfo(skillIndex);
  	end
  	if skillName == "Fishing" then
  		hasFishing = GetSkillLineInfo(skillIndex);
  	end
    -- debugList = debugList .. GetSkillLineInfo(skillIndex) .. "\n";
  end
  if (profCount == 2) then
    DEFAULT_CHAT_FRAME:AddMessage(DNAapp_global .. "Reading Professions [Primary] ...");
  end
  if (profCount == 4) then
    DEFAULT_CHAT_FRAME:AddMessage(DNAapp_global .. "Reading Professions [Secondary] ...");
  end
  --DEFAULT_CHAT_FRAME:AddMessage(DNAapp_global .. "Reading Professions [" .. profCount .. "]...");
end

local DNAframeMainLocal = CreateFrame("Frame");
DNAframeMainLocal:RegisterEvent("ADDON_LOADED");
DNAframeMainLocal:RegisterEvent("PLAYER_LOGIN");
DNAframeMainLocal:RegisterEvent("SKILL_LINES_CHANGED");

DNAframeMainLocal:SetScript("OnEvent", function(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "DNA" then
    if DNA == nil then
      DNA = {}
    end
  end
  if event == "SKILL_LINES_CHANGED" then
    pullProfessions();
  end
end)

SLASH_DNA1 = "/DNA"
function SlashCmdList.DNA(msg)
  -- print("debug " .. DNA)
end

local DNAframeMain = CreateFrame("Frame", nil, UIParent, "UIPanelDialogTemplate");
DNAframeMain:SetWidth(DNAGlobal[5]);
DNAframeMain:SetHeight(DNAGlobal[7]);
DNAframeMain:SetPoint("CENTER", -DNAGlobal[5], 100);
DNAframeMain:SetMovable(true);
DNAframeMain.text = DNAframeMain:CreateFontString(nil,"ARTWORK");
DNAframeMain.text:SetFont(DNAGlobal[9], 15, "OUTLINE");
DNAframeMain.text:SetPoint("TOPLEFT", DNAframeMain, "TOPLEFT", 10, -9);
DNAframeMain.text:SetText("|cffFF7D0A " .. DNAGlobal[1] .. " " .. DNAGlobal[3]);
DNAframeMain.ScrollFrame = CreateFrame("ScrollFrame", nil, DNAframeMain, "UIPanelScrollFrameTemplate");
DNAframeMain.ScrollFrame:SetPoint("TOPLEFT", DNAframeMain, "TOPLEFT", 10, -40);
DNAframeMain.ScrollFrame:SetPoint("BOTTOMRIGHT", DNAframeMain, "BOTTOMRIGHT", 10, 20);
local DNAScrollChildFrame = CreateFrame("Frame", nil, DNAframeMain.ScrollFrame);
DNAScrollChildFrame:SetSize(DNAGlobal[5]-20, DNAGlobal[7]);
DNAScrollChildFrame.bg = DNAScrollChildFrame:CreateTexture(nil, "BACKGROUND");
DNAScrollChildFrame.bg:SetAllPoints(true);
--DNAScrollChildFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.4);
DNAframeMain.ScrollFrame:SetScrollChild(DNAScrollChildFrame);

DNAframeMain.ScrollFrame.ScrollBar:ClearAllPoints();
DNAframeMain.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", DNAframeMain.ScrollFrame, "TOPRIGHT", -150, -10);
DNAframeMain.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", DNAframeMain.ScrollFrame, "BOTTOMRIGHT", 100, 10);

local frameHolder;
local self = frameHolder or CreateFrame("Frame", nil, UIParent); -- re-size this to whatever size you wish your ScrollFrame to be, at this point
self.scrollframe = self.scrollframe or CreateFrame("ScrollFrame", "ANewScrollFrame", self, "UIPanelScrollFrameTemplate");
self.scrollchild = self.scrollchild or CreateFrame("Frame"); -- not sure what happens if you do, but to be safe, don't parent this yet (or do anything with it)
local scrollbarName = self.scrollframe:GetName()
self.scrollbar = _G[scrollbarName.."ScrollBar"];
self.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
self.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];
self.scrollupbutton:ClearAllPoints();
self.scrollupbutton:SetPoint("TOPRIGHT", self.scrollframe, "TOPRIGHT", -2, -2);
self.scrolldownbutton:ClearAllPoints();
self.scrolldownbutton:SetPoint("BOTTOMRIGHT", self.scrollframe, "BOTTOMRIGHT", -2, 2);
self.scrollbar:ClearAllPoints();
self.scrollbar:SetPoint("TOP", self.scrollupbutton, "BOTTOM", 0, -2);
self.scrollbar:SetPoint("BOTTOM", self.scrolldownbutton, "TOP", 0, 2);
self.scrollframe:SetScrollChild(self.scrollchild);
self.scrollframe:SetAllPoints(self);
self.scrollchild:SetSize(self.scrollframe:GetWidth(), ( self.scrollframe:GetHeight() * 2 ));
self.moduleoptions = self.moduleoptions or CreateFrame("Frame", nil, self.scrollchild);
self.moduleoptions:SetAllPoints(self.scrollchild);
self.moduleoptions.fontstring:SetText("This is a test.");
self.moduleoptions.fontstring:SetPoint("BOTTOMLEFT", self.moduleoptions, "BOTTOMLEFT", 20, 60);

local profileText = CreateFrame("Frame",nil, DNAframeMain)
profileText:SetWidth(100)
profileText:SetHeight(30)
profileText:SetPoint("TOPLEFT", 10, -20)
profileText.text=profileText:CreateFontString(nil, "ARTWORK")
profileText.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
profileText.text:SetPoint("TOPLEFT", 10, -20)
profileText.text:SetText("Profile:")

checkbox = {}
function checkItem(checkID, checkName, icon, posY)
  local check_static = CreateFrame("CheckButton", nil, DNAframeMain, "ChatConfigCheckButtonTemplate");
  check_static:SetPoint("TOPLEFT", 30, posY)
  check_static.text = check_static:CreateFontString(nil,"ARTWORK");
  check_static.text:SetFont(DNAGlobal[9], 14, "OUTLINE");
  check_static.text:SetPoint("TOPLEFT", check_static, "TOPLEFT", 50, -5);
  check_static.text:SetText(checkName);
  -- check_static.tooltip = checkID
  local licon = check_static:CreateTexture(nil, "BACKGROUND", nil, -6)
  licon:SetTexture(icon)
  licon:SetSize(16, 16)
  licon:SetPoint("TOPLEFT", 30, -3)
  check_static:SetScript("OnClick",
    function()
     saveDNAVars()
    end
  )
  checkbox[checkID] = check_static
end

local frameText = CreateFrame("Frame",nil, DNAframeMain)
frameText:SetWidth(100)
frameText:SetHeight(30)
frameText:SetPoint("TOPLEFT", 10, -50)
frameText.text=frameText:CreateFontString(nil, "ARTWORK")
frameText.text:SetFont(DNAGlobal[9], 14, "OUTLINE")
frameText.text:SetPoint("TOPLEFT", 10, -50)
frameText.text:SetText("Auto Remove:")

checkItem("ARSalv", "Blessing of Salvation", "Interface/Icons/Spell_Holy_GreaterBlessingofSalvation", -120)
checkItem("ARMight","Blessing of Might", "Interface/Icons/Spell_Holy_GreaterBlessingofKings", -140)
checkItem("ARSanc", "Blessing of Sanctuary", "Interface/Icons/Spell_Holy_GreaterBlessingofSanctuary", -160)
checkItem("ARInt",  "Arcane of Intellect", "Interface/Icons/Spell_Holy_ArcaneIntellect", -180)
checkItem("ARPoS",  "Prayer of Spirit", "Interface/Icons/Spell_Holy_PrayerofSpirit", -200)
checkItem("ARThorns","Thorns", "Interface/Icons/Spell_Nature_Thorns", -220)

prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
Profession1 = GetProfessionInfo(1)
Profession2 = GetProfessionInfo(2)
Profession3 = GetProfessionInfo(archaeology)
Profession4 = GetProfessionInfo(fishing)
Profession5 = GetProfessionInfo(cooking)
Profession6 = GetProfessionInfo(firstAid)
]==]--

--[==[
self:RegisterEvent("PARTY_INVITE_REQUEST", "confirmPartyInvite")
function MyAddon:confirmPartyInvite(info, sender)
  if ( MyAddon:someTestOfSenderThatYouMakeUp(sender) ) then
    AcceptGroup();
    self:RegisterEvent("PARTY_MEMBERS_CHANGED", "closePopup")
  end
end

function MyAddon:closePopup()
  StaticPopup_Hide("PARTY_INVITE")
  self:UnregisterEvent("PARTY_MEMBERS_CHANGED")
end

local btn = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
btn:SetPoint("CENTER")
btn:SetSize(100, 40)
btn:SetText("Click me")
btn:HookScript("OnMouseDown", function(self, button)
	print("You clicked me with "..button)
end)
]==]--

function DNAopenWindow()
  getRaidMembers()
  DNAframeMain:Show()
end

function DNAcloseWindow()
  DNAframeMain:Hide()
end

SlashCmdList["DNA"] = function(msg)
  DNAopenWindow()
end

local DNAMiniMap = CreateFrame("Button", nil, Minimap)
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
    DNAMiniMap:StopMovingOrSizing();
    DNAMiniMap:SetScript("OnUpdate", nil)
    UpdateMapButton();
end)
DNAMiniMap:ClearAllPoints();
DNAMiniMap:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 62 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 62)
DNAMiniMap:SetScript("OnClick", function()
  DNAopenWindow()
end)
