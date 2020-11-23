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

--[==[
local instanceDetails = {
  "Naxx",
  "Naxxramas",
  "Interface/GLUES/LoadingScreens/LoadScreenNaxxramas",
  "Interface/EncounterJournal/UI-EJ-BOSS-KelThuzad",
  "Interface/EncounterJournal/UI-EJ-DUNGEONBUTTON-Naxxramas",
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-Naxxramas"
}
local bossList = {
  {"- Abomination Wing -","", 2},
  {"Patchwerk",           "Interface/EncounterJournal/UI-EJ-BOSS-Patchwerk", 0},
  {"Grobbulus",           "Interface/EncounterJournal/UI-EJ-BOSS-Grobbulus", 0},
  {"Gluth",               "Interface/EncounterJournal/UI-EJ-BOSS-Gluth", 0},
  {"Thaddius",            "Interface/EncounterJournal/UI-EJ-BOSS-Thaddius", 0},
  {"- Plague Wing -",     "", 2}, --Noth > Heigan > Loatheb
  {"Noth",               "Interface/EncounterJournal/UI-EJ-BOSS-Noth", 0},
  {"Heigan",             "Interface/EncounterJournal/UI-EJ-BOSS-Heigan", 0},
  {"Fankriss",           "Interface/EncounterJournal/UI-EJ-BOSS-Fankriss the Unyielding", 0},
  {"Stinger Pack",       DNAGlobal.dir .. "images/boss_wasps", 1},
  {"Princess Huhuran",   "Interface/EncounterJournal/UI-EJ-BOSS-Princess Huhuran", 0},
  {"Twin Emperors",      "Interface/EncounterJournal/UI-EJ-BOSS-Twin Emperors", 0},
  {"Champion Pack",      "Interface/EncounterJournal/UI-EJ-BOSS-General Rajaxx", 1},
  {"Obsidian Pack",      "Interface/EncounterJournal/UI-EJ-BOSS-Moam", 1},
  {"C'Thun",             "Interface/EncounterJournal/UI-EJ-BOSS-CThun", 0}
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer)
  if (isItem(assign, "Patchwerk")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
  end
end
]==]--
