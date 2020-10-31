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
local DNAGlobal = {}
DNAGlobal.name    = "Destructive Nature Assistant"
DNAGlobal.vmajor  = 1
DNAGlobal.vminor  = 15
DNAGlobal.width   = 980
DNAGlobal.height  = 550
DNAGlobal.font    = "Fonts/FRIZQT__.TTF"
DNAGlobal.packet  = "dnassist"
DNAGlobal.version = DNAGlobal.vmajor .. "." .. DNAGlobal.vminor
DNAGlobal.background="Interface/FrameGeneral/UI-Background-Rock"

--DNAssign = LibStub("AceAddon-3.0"):NewAddon("DNAssign", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0", "AceTimer-3.0")
--local LSM3 = LibStub("LibSharedMedia-3.0")

local DEBUG = true

local function globalNotification(msg)
  print("|cff00ffff" .. DNAGlobal.name .. "|r " .. msg)
end

--single array
local function singleKeyFromValue(_array, value)
  for k,v in pairs(_array) do
    if v==value then return k end
  end
  return nil
end
--matrix array
local function multiKeyFromValue(_array, value)
  for k,v in pairs(_array) do
    if v[1]==value then return k end
  end
  return nil
end

function split(s, delimiter)
  result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result;
end

local function isempty(s)
  return s == nil or s == ''
end

function table.merge(t1, t2)
 for k,v in ipairs(t2) do
    table.insert(t1, v)
 end
  return t1
end

local function sendPacket(bridge, packet)
  filteredPacket = nil
  if (bridge == "send") then
    filteredPacket = packet:gsub("%s+", "") --filter spaces
    C_ChatInfo.SendAddonMessage("dnassist", filteredPacket, "RAID")
  end
  --C_ChatInfo.SendAddonMessage("dnassist", player.combine, "WHISPER", "bankhoe")
end

local packet = {}
packet.role = nil
packet.slot = nil
packet.name = nil

local player = {}
player.name = UnitName("player")
player.realm = GetRealmName()
player.combine=player.name .. "-" .. player.realm

local getsave = {}
getsave.role = nil
getsave.slot = nil
getsave.name = nil
local lastSelection = nil

local raidSlot = {}
local raidSlot_h = 20

local tankSlots = 6
local tankSlot = {}

local healSlots = 12
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

local warriors = {}
local druids = {}
local priests = {}
local hunters = {}
local warlocks = {}
local rogues = {}
local mages = {}
local paladins = {}

local raidSelection = nil

local viewFrameLines = 20

local botTab = {}
local botBack = {}
local botBorder = {}

local pages = {
  {"Assignment", 10},
  {"Raid Details", 100},
  {"DKP", 190},
  {"Config", 280},
}

local page={}
local pageBanner = {}
local pageBossIcon = {}

local DNAFrameViewScrollChild_tank = {}
local DNAFrameViewScrollChild_mark = {}
--local DNAFrameViewScrollChild_spec = {}
local DNAFrameViewScrollChild_heal = {}
local DNAFrameAssignScrollChild_tank = {}
local DNAFrameAssignScrollChild_mark = {}
--local DNAFrameAssignScrollChild_spec = {}
local DNAFrameAssignScrollChild_heal = {}
local DNAFrameAssignIcon = {}
local DNAFrameAssignText = {}

local pageDKPView={}
local pageDKPViewScrollChild_colOne = {}
local pageDKPViewScrollChild_colTwo = {}
local pageDKPViewScrollChild_colThree= {}

local version_checked = 0
function isItem(compare, item) --dropdown packets that are filtered from spaces
  --(lava pack)
  filteredItem = item:gsub("%s+", "")
  if ((compare == item) or (compare == filteredItem)) then
    DNAFrameAssignText:SetText(item)
    return true
  else
    return false
  end
end
