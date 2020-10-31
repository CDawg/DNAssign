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

DNAGlobal = {}
DNAGlobal.name    = "Destructive Nature Assistant"
DNAGlobal.vmajor  = 1
DNAGlobal.vminor  = 15
DNAGlobal.width   = 980
DNAGlobal.height  = 550
DNAGlobal.font    = "Fonts/FRIZQT__.TTF"
--DNAGlobal.font    = "Fonts/ARIALN.TTF"
--DNAGlobal.font    = "Interface/Addons/DNAssistant/Fonts/cooline.ttf"
DNAGlobal.packet  = "dnassist"
DNAGlobal.version = DNAGlobal.vmajor .. "." .. DNAGlobal.vminor
DNAGlobal.background="Interface/FrameGeneral/UI-Background-Rock"

--DNAssign = LibStub("AceAddon-3.0"):NewAddon("DNAssign", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0", "AceTimer-3.0")
--local LSM3 = LibStub("LibSharedMedia-3.0")

--single array
function singleKeyFromValue(_array, value)
  for k,v in pairs(_array) do
    if v==value then return k end
  end
  return nil
end
--matrix array
function multiKeyFromValue(_array, value)
  for k,v in pairs(_array) do
    if v[1]==value then return k end
  end
  return nil
end

function reindexArray(input, remove)
  local n=#input
  for i=1,n do
    if remove[input[i]] then
      input[i]=nil
    end
  end
  local j=0
  for i=1,n do
    if input[i]~=nil then
      j=j+1
      input[j]=input[i]
    end
  end
  for i=j+1,n do
    input[i]=nil
  end
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

function removeValueFromArray(array, value)
  remove_key = singleKeyFromValue(array, value)
  array[remove_key] = nil
  reindexArray(array, array)
end

function DNASendPacket(bridge, packet)
  filteredPacket = nil
  if (bridge == "send") then
    filteredPacket = packet:gsub("%s+", "") --filter spaces
    C_ChatInfo.SendAddonMessage("dnassist", filteredPacket, "RAID")
  end
  --C_ChatInfo.SendAddonMessage("dnassist", player.combine, "WHISPER", "bankhoe")
end
