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
  "Interface/Garrison/GarrisonShipMissionParchment",
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
  --{"Trash Wing:Ghouls",      "Interface/EncounterJournal/UI-EJ-BOSS-Timmy the Cruel", 1},
  {"Noth The Plaguebringer", "Interface/EncounterJournal/UI-EJ-BOSS-Noth the Plaguebringer", 0},
  {"Heigan The Unclean",     "Interface/EncounterJournal/UI-EJ-BOSS-Heigan the Unclean", 0},
  {"Loatheb",                "Interface/EncounterJournal/UI-EJ-BOSS-Loatheb", 0},

  {"- Spider Wing -",        "", 2},
  {"Trash Wing:Spider",      "Interface/EncounterJournal/UI-EJ-BOSS-Maexxna", 1},
  {"Trash Wing:Ghouls",      "Interface/EncounterJournal/UI-EJ-BOSS-Timmy the Cruel", 1},
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
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]

    text[2] = note_color .. "SOUTH WEST"
    heal[2] = tank.all[2] .. "," .. healer.priest[3]

    text[3] = note_color .. "SOUTH EAST"
    heal[3] = tank.all[3] .. "," .. healer.priest[4]

    text[4] = note_color .. "NORTH EAST"
    if (healer.priest[5]) then
      heal[4] = tank.all[4] .. "," .. healer.priest[5]
    else
      heal[4] = tank.all[4] .. "," .. healer.paladin[2]
    end
  end

  if (isItem(assign, "Heigan The Unclean")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    local remainder_heals = {}
    table.merge(remainder_heals, healer.all)
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," ..  healer.priest[3] .. "," .. healer.paladin[1]
    removeValueFromArray(remainder_heals, healer.priest[1])
    removeValueFromArray(remainder_heals, healer.priest[2])
    removeValueFromArray(remainder_heals, healer.priest[3])
    removeValueFromArray(remainder_heals, healer.paladin[1])

    for i=1, 4 do
      if (remainder_heals[i]) then
        text[i+2] = note_color .. "RAID DISPEL"
        heal[i+2] = remainder_heals[i]
      end
    end
    for i=5, 9 do
      if (remainder_heals[i]) then
        text[i+3] = note_color .. "RAID HEAL"
        heal[i+3] = remainder_heals[i]
      end
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

  if (isItem(assign, "Trash Wing:Ghouls")) then
    NUM_ADDS = 4
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
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    local remainder_heals = {}
    table.merge(remainder_heals, healer.all)
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.priest[3] .. "," .. healer.paladin[1]
    removeValueFromArray(remainder_heals, healer.priest[1])
    removeValueFromArray(remainder_heals, healer.priest[2])
    removeValueFromArray(remainder_heals, healer.priest[3])
    removeValueFromArray(remainder_heals, healer.paladin[1])

    mark[2] = icon.skull
    text[2] = tank.all[2]
    heal[2] = healer.priest[4] .. "," .. healer.paladin[2]
    removeValueFromArray(remainder_heals, healer.priest[4])
    removeValueFromArray(remainder_heals, healer.paladin[2])

    mark[3] = icon.cross
    text[3] = tank.all[3]
    heal[3] = remainder_heals[1] .. "," .. remainder_heals[2]
    removeValueFromArray(remainder_heals, remainder_heals[1])
    removeValueFromArray(remainder_heals, remainder_heals[2])
    remainder_heals = reindexArraySafe(remainder_heals)

    for i=1, table.getn(remainder_heals) do
      text[i+4] = note_color .. "RAID HEAL"
      heal[i+4] = remainder_heals[i]
    end

    text[10] = note_color .. "Use Slowfall/Levitate/Intercept if you get impaled!"
  end

  if (isItem(assign, "Grand Widow Faerlina")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    local remainder_heals = {}
    table.merge(remainder_heals, healer.all)
    --[==[
    if ((cc.main[1] == nil) or (cc.main[1] == "Empty")) then
      mark[2] = icon.alert
      text[2] = "|cffff0000MISSING MINDCONTROL IN THE DESIGNATED QUEUE!"
      return
    end
    ]==]--
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]
    removeValueFromArray(remainder_heals, healer.priest[1])
    removeValueFromArray(remainder_heals, healer.priest[2])
    removeValueFromArray(remainder_heals, healer.paladin[1])

    mark[2] = icon.skull
    text[2] = tank.all[4]
    heal[2] = healer.priest[3] .. "," .. healer.paladin[2]
    removeValueFromArray(remainder_heals, healer.priest[3])
    removeValueFromArray(remainder_heals, healer.paladin[2])

    mark[3] = icon.cross
    text[3] = tank.all[5]
    heal[3] = healer.priest[4] .. "," .. healer.paladin[3]
    removeValueFromArray(remainder_heals, healer.priest[4])
    removeValueFromArray(remainder_heals, healer.paladin[3])

    mark[5] = icon.triangle
    text[5] = tank.all[2]
    heal[5] = remainder_heals[1]

    mark[6] = icon.diamond
    text[6] = tank.all[2]
    heal[6] = remainder_heals[2]

    mark[8] = icon.star
    text[8] = tank.all[3]
    heal[8] = remainder_heals[3]
    mark[9] = icon.square
    text[9] = tank.all[3]
    heal[9] = remainder_heals[4]

    text[11] = note_color .. "Burn down skull and cross (Followers)."
    text[12] = note_color .. "2 Worshippers tanked left side away from boss."
    text[13] = note_color .. "2 Worshippers tanked right side away from boss."
  end

  if (isItem(assign, "Maexxna")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = note_color .. "ALL HEALERS"

    text[3] = note_color .. "WEB HEALER"
    heal[3] = healer.priest[1]
    text[4] = note_color .. "WEB HEALER"
    heal[4] = healer.priest[2]
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
