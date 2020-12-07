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

local instanceDetails = {
  "Naxx",
  "Naxxramas",
  "Interface/GLUES/LoadingScreens/LoadScreenNaxxramas",
  "Interface/EncounterJournal/UI-EJ-BOSS-KelThuzad",
  "Interface/EncounterJournal/UI-EJ-DUNGEONBUTTON-Naxxramas",
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-Naxxramas",
  DNAGlobal.dir .. "images/naxx",
}
local bossList = {
  {"- Abomination Wing -",   "", 2},
  {"Trash Wing:Abomination", "Interface/EncounterJournal/UI-EJ-BOSS-Patchwerk", 1},
  {"Patchwerk",              "Interface/EncounterJournal/UI-EJ-BOSS-Patchwerk", 0},
  {"Grobbulus",              "Interface/EncounterJournal/UI-EJ-BOSS-Grobbulus", 0},
  {"Gluth",                  "Interface/EncounterJournal/UI-EJ-BOSS-Gluth", 0},
  {"Thaddius",               "Interface/EncounterJournal/UI-EJ-BOSS-Thaddius", 0},

  {"- Plague Wing -",        "", 2},
  {"Trash Wing:Plague",      "Interface/EncounterJournal/UI-EJ-BOSS-Patchwerk", 1},
  {"Noth The Plaguebringer", "Interface/EncounterJournal/UI-EJ-BOSS-Noth the Plaguebringer", 0},
  {"Heigan The Unclean",     "Interface/EncounterJournal/UI-EJ-BOSS-Heigan the Unclean", 0},
  {"Loatheb",                "Interface/EncounterJournal/UI-EJ-BOSS-Loatheb", 0},

  {"- Spider Wing -",        "", 2},
  {"Trash Wing:Spider",      "Interface/EncounterJournal/UI-EJ-BOSS-Maexxna", 1},
  --{"Trash Ghouls",           "Interface/EncounterJournal/UI-EJ-BOSS-Timmy the Cruel", 1},
  {"Anub'Rekhan",            "Interface/EncounterJournal/UI-EJ-BOSS-AnubRekhan", 0},
  {"Grand Widow Faerlina",   "Interface/EncounterJournal/UI-EJ-BOSS-Grand Widow Faerlina", 0},
  {"Maexxna",                "Interface/EncounterJournal/UI-EJ-BOSS-Maexxna", 0},

  {"- Death Knight Wing -",  "", 2},
  {"Trash Wing:Death Knight","Interface/EncounterJournal/UI-EJ-BOSS-Instructor Razuvious", 1},
  {"Instructor Razuvious",   "Interface/EncounterJournal/UI-EJ-BOSS-Instructor Razuvious", 0},
  {"The Four Horsemen",      "Interface/EncounterJournal/UI-EJ-BOSS-Four Horseman", 0},

  {"- Frostwyrm Lair -",     "", 2},
  {"Sapphiron",              "Interface/EncounterJournal/UI-EJ-BOSS-Sapphiron", 0},
  {"Kel'Thuzad",             "Interface/EncounterJournal/UI-EJ-BOSS-KelThuzad", 0},
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceNaxx(assign, total, raid, mark, text, heal, tank, healer, cc)
  if (isItem(assign, "Trash Wing:Abomination")) then
    NUM_ADDS = 8
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Patchwerk")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Grobbulus")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Gluth")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Thaddius")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Trash Wing:Plague")) then
    NUM_ADDS = 8
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Noth The Plaguebringer")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Heigan The Unclean")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Loatheb")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Trash Wing:Spider")) then
    NUM_ADDS = 8
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Trash Ghouls")) then
    NUM_ADDS = 5
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Anub'Rekhan")) then
    NUM_ADDS = 2
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Grand Widow Faerlina")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    --heal[1] = healer.all[i]
    mark[2] = icon.skull
    text[2] = tank.all[2]
    mark[3] = icon.cross
    text[3] = tank.all[3]
    --heal[2] = healer.all[i]
  end

  if (isItem(assign, "Maexxna")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
  end

  if (isItem(assign, "Trash Wing:Death Knight")) then
    NUM_ADDS = 8
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Trash Wing:Death Knight")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
  end

  if (isItem(assign, "Instructor Razuvious")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
  end

  if (isItem(assign, "The Four Horsemen")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
  end

  if (isItem(assign, "Sapphiron")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_sapp_kel"
  end

  if (isItem(assign, "Kel'Thuzad")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_sapp_kel"
  end

end
