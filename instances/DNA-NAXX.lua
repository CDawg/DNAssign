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
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-Naxxramas",
  DNAGlobal.dir .. "images/naxx"
}
local bossList = {
  {"- Abomination Wing -", "", 2},
  {"Patchwerk",            "Interface/EncounterJournal/UI-EJ-BOSS-Patchwerk", 0},
  {"Grobbulus",            "Interface/EncounterJournal/UI-EJ-BOSS-Grobbulus", 0},
  {"Gluth",                "Interface/EncounterJournal/UI-EJ-BOSS-Gluth", 0},
  {"Thaddius",             "Interface/EncounterJournal/UI-EJ-BOSS-Thaddius", 0},
  {"- Plague Wing -",      "", 2},
  {"Noth The Plaguebringer","Interface/EncounterJournal/UI-EJ-BOSS-Noth the Plaguebringer", 0},
  {"Heigan The Unclean",   "Interface/EncounterJournal/UI-EJ-BOSS-Heigan the Unclean", 0},
  {"Loatheb",              "Interface/EncounterJournal/UI-EJ-BOSS-Loatheb", 0},
  {"- Spider Wing -",      "", 2},
  {"Anub'Rekhan",          "Interface/EncounterJournal/UI-EJ-BOSS-AnubRekhan", 0},
  {"Grand Widow Faerlina", "Interface/EncounterJournal/UI-EJ-BOSS-Grand Widow Faerlina", 0},
  {"Maexxna",              "Interface/EncounterJournal/UI-EJ-BOSS-Maexxna", 0},
  {"- Death Knight Wing -","", 2},
  {"Instructor Razuvious", "Interface/EncounterJournal/UI-EJ-BOSS-Instructor Razuvious", 0},
  {"The Four Horsemen",    "Interface/EncounterJournal/UI-EJ-BOSS-Four Horseman", 0},
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer)
  if (isItem(assign, "Patchwerk")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
  end
end
]==]--
