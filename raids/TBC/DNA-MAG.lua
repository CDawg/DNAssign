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
]==]--

local instanceDetails = {
  "Mag",
  "Magtheridon's Lair",
  "Interface/GLUES/LoadingScreens/LOADSCREENHELLFIRECITADELRAID",
  "Interface/EncounterJournal/UI-EJ-BOSS-Magtheridon",
  "Interface/EncounterJournal/UI-EJ-DUNGEONBUTTON-MagtheridonsLair",
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-MagtheridonsLair",
  DNAGlobal.dir .. "images/naxx",
  "TBC",
}
local bossList = {
  {"Magtheridon",          "Interface/EncounterJournal/UI-EJ-BOSS-Magtheridon", 0},
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)
