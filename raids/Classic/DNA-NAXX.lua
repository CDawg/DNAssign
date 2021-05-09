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
  "Naxx",
  "Naxxramas",
  "Interface/GLUES/LoadingScreens/LoadScreenNaxxramas",
  "Interface/EncounterJournal/UI-EJ-BOSS-KelThuzad",
  "Interface/EncounterJournal/UI-EJ-DUNGEONBUTTON-Naxxramas",
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-Naxxramas",
  DNAGlobal.dir .. "images/naxx",
  "Classic",
}
local bossList = {
  {"- The Abomination Quarter -","", 2},
  {"Trash Wing:Abomination", "Interface/EncounterJournal/UI-EJ-BOSS-Patchwerk", 1},
  {"Patchwerk",              "Interface/EncounterJournal/UI-EJ-BOSS-Patchwerk", 0},
  {"Grobbulus",              "Interface/EncounterJournal/UI-EJ-BOSS-Grobbulus", 0},
  {"Gluth",                  "Interface/EncounterJournal/UI-EJ-BOSS-Gluth", 0},
  {"Thaddius",               "Interface/EncounterJournal/UI-EJ-BOSS-Thaddius", 0},

  {"", "", 2},
  {"- The Plague Quarter -", "", 2},
  {"Trash Wing:Plague",      "Interface/EncounterJournal/UI-EJ-BOSS-Viscidus", 1},
  {"Noth the Plaguebringer", "Interface/EncounterJournal/UI-EJ-BOSS-Noth the Plaguebringer", 0},
  {"Heigan the Unclean",     "Interface/EncounterJournal/UI-EJ-BOSS-Heigan the Unclean", 0},
  {"Loatheb",                "Interface/EncounterJournal/UI-EJ-BOSS-Loatheb", 0},

  {"", "", 2},
  {"- The Arachnid Quarter -","", 2},
  {"Trash Wing:Spiders",     "Interface/EncounterJournal/UI-EJ-BOSS-Maexxna", 1},
  {"Trash Wing:Ghouls",      "Interface/EncounterJournal/UI-EJ-BOSS-Timmy the Cruel", 1},
  {"Anub'Rekhan",            "Interface/EncounterJournal/UI-EJ-BOSS-AnubRekhan", 0},
  {"Grand Widow Faerlina",   "Interface/EncounterJournal/UI-EJ-BOSS-Grand Widow Faerlina", 0},
  {"Maexxna",                "Interface/EncounterJournal/UI-EJ-BOSS-Maexxna", 0},

  {"", "", 2},
  {"- The Military Quarter -","", 2},
  {"Trash Wing:Military",    "Interface/EncounterJournal/UI-EJ-BOSS-Instructor Razuvious", 1},
  {"Instructor Razuvious",   "Interface/EncounterJournal/UI-EJ-BOSS-Instructor Razuvious", 0},
  {"Gothik the Harvester",   "Interface/EncounterJournal/UI-EJ-BOSS-Gothik the Harvester", 0},
  {"The Four Horsemen",      "Interface/EncounterJournal/UI-EJ-BOSS-Four Horseman", 0},

  {"", "", 2},
  {"- Frostwyrm Lair -",     "", 2},
  {"Sapphiron",              "Interface/EncounterJournal/UI-EJ-BOSS-Sapphiron", 0},
  {"Kel'Thuzad",             "Interface/EncounterJournal/UI-EJ-BOSS-KelThuzad", 0},
}
table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DN:Instance_Naxx(assign, total, raid, mark, text, heal, tank, healer, cc)
  if (isItem(assign, "Trash Wing:Abomination")) then
    NUM_ADDS = 4
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Patchwerk")) then
    NUM_TANKS = 4
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2]
    mark[2] = DNABossIcon
    text[2] = tank.all[2]
    heal[2] = healer.all[3] .. "," .. healer.all[4] .. "," .. healer.all[5]
    mark[3] = DNABossIcon
    text[3] = tank.all[3]
    heal[3] = healer.all[6] .. "," .. healer.all[7] .. "," .. healer.all[8]
    mark[4] = DNABossIcon
    text[4] = tank.all[4]
    if (healer.all[9]) then
      heal[4] = healer.all[9] .. "," .. healer.all[10] .. "," .. healer.all[11]
    end
  end

  if (isItem(assign, "Grobbulus")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]

    text[3] = "-- SLIMES --"
    text[4] = tank.all[2]
    heal[4] = healer.paladin[2]

    text[6] = "-- DISPELLS --"
    text[7] = healer.paladin[3]
  end

  if (isItem(assign, "Gluth")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Thaddius")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_construct"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Trash Wing:Plague")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Noth the Plaguebringer")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]

    text[2] = textcolor.note .. "ADD TANK"
    heal[2] = tank.all[2] .. "," .. healer.priest[3]

    text[3] = textcolor.note .. "ADD TANK"
    heal[3] = tank.all[3] .. "," .. healer.priest[4]

    text[4] = textcolor.note .. "ADD TANK"
    if (healer.priest[5]) then
      heal[4] = tank.all[4] .. "," .. healer.priest[5]
    else
      heal[4] = tank.all[4] .. "," .. healer.paladin[2]
    end

    for i=1, total.mages do
      if (raid.mage[i]) then
        mark[i+5] = "Interface/Icons/spell_nature_removecurse"
        text[i+5] = "Decurse"
        heal[i+5] = raid.mage[i]
      end
    end
    for i=1, total.druids do
      if (raid.druid[i]) then
        mark[i+5+total.mages] = "Interface/Icons/spell_nature_removecurse"
        text[i+5+total.mages] = "Decurse"
        heal[i+5+total.mages] = raid.druid[i]
      end
    end
  end

  if (isItem(assign, "Heigan the Unclean")) then
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
        text[i+2] = textcolor.note .. "RAID DISPEL"
        heal[i+2] = remainder_heals[i]
      end
    end
    for i=5, 9 do
      if (remainder_heals[i]) then
        text[i+3] = textcolor.note .. "RAID HEAL"
        heal[i+3] = remainder_heals[i]
      end
    end
  end

  if (isItem(assign, "Loatheb")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_plague"
    mark[1] = DNABossIcon
    text[1] = tank.main[1]
    heal[1] = "HEALER ROTATION"
  end

  if (isItem(assign, "Trash Wing:Spiders")) then
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
      text[i+4] = textcolor.note .. "RAID HEAL"
      heal[i+4] = remainder_heals[i]
    end

    text[10] = textcolor.note .. "Use Slowfall/Levitate/Intercept if you get impaled!"
  end

  if (isItem(assign, "Grand Widow Faerlina")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    local remainder_heals = {}
    table.merge(remainder_heals, healer.all)

    removeValueFromArray(remainder_heals, healer.priest[1]) --remove the first priest for MC

    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = remainder_heals[1] .. "," .. remainder_heals[2] .. "," .. remainder_heals[3]
    mark[2] = icon.skull
    text[2] = tank.all[2]
    heal[2] = remainder_heals[4]
    mark[3] = icon.cross
    text[3] = tank.all[3]
    heal[3] = remainder_heals[5]

    mark[5] = icon.triangle
    text[5] = tank.all[4]
    heal[5] = remainder_heals[6]
    mark[6] = icon.diamond
    text[6] = tank.all[4]
    heal[6] = remainder_heals[6]
    mark[8] = icon.star
    text[8] = tank.all[4]
    heal[8] = remainder_heals[7]
    mark[9] = icon.square
    text[9] = tank.all[4]
    heal[9] = remainder_heals[7]

    mark[11] = "Interface/Icons/spell_shadow_shadowworddominate"
    text[11] = textcolor.note .. "Mind Control"
    heal[11] = healer.priest[1]

    text[13] = textcolor.note .. "Burn down {skull} and {cross} (Followers)."
    text[14] = textcolor.note .. "Worshippers tanked away from boss."
    --text[15] = textcolor.note .. "2 Worshippers tanked right side away from boss."
  end

  if (isItem(assign, "Maexxna")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_arachnid"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = textcolor.note .. "ALL HEALERS"

    text[3] = textcolor.note .. "WEB HEALER"
    heal[3] = healer.priest[1]
    text[4] = textcolor.note .. "WEB HEALER"
    heal[4] = healer.priest[2]
  end

  if (isItem(assign, "Trash Wing:Military")) then
    NUM_ADDS = 4
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Instructor Razuvious")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
  end

  if (isItem(assign, "Gothik the Harvester")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
    local shackle_count = 0
    local SHACKLE_WAVES = {
      "WAVE 8",
      "WAVE 11",
      "WAVE 13",
      "WAVE 16",
      "WAVE 18",
    }
    local SHACKLE_SYMBOLS = {
      icon.triangle,
      icon.star,
      icon.square,
      icon.cross,
      icon.diamond,
    }
    local priest_queue = {} --pull from healer queue first
    local priest_count = 0
    local MAX_SHACKLES = table.getn(SHACKLE_WAVES)

    for i=1, DNASlots.heal do
      if (DNARaid["class"][healer.all[i]] == "Priest") then
        priest_count = priest_count +1
        priest_queue[priest_count] = healer.all[i]
      end
    end
    for k,v in pairs(priest_queue) do
      shackle_count = shackle_count + 1
      if (shackle_count <= MAX_SHACKLES) then
        mark[k] = SHACKLE_SYMBOLS[k]
        text[k] = textcolor.note .. SHACKLE_WAVES[k]
        heal[k] = v
      end
    end
    DN:Debug(shackle_count)
  end

  if (isItem(assign, "The Four Horsemen")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_military"
    if ((cc.main[1]) and (cc.main[2])) then
      mark[1] = icon.skull
      text[1] = "PULL"
      heal[1] = tank.all[1]
      mark[2] = icon.skull
      text[2] = textcolor.green .. "SAFE ZONE"
      heal[2] = tank.all[2]

      mark[3] = icon.cross
      text[3] = "PULL"
      heal[3] = tank.all[3]
      mark[4] = icon.cross
      text[4] = textcolor.green .. "SAFE ZONE"
      heal[4] = tank.all[4]

      mark[5] = icon.circle
      text[5] = "PULL"
      heal[5] = tank.all[5]
      mark[6] = icon.circle
      text[6] = textcolor.green .. "SAFE ZONE"
      heal[6] = tank.all[6]

      mark[7] = icon.triangle
      text[7] = "PULL"
      heal[7] = cc.main[1]
      mark[8] = icon.triangle
      text[8] = textcolor.green .. "SAFE ZONE"
      heal[8] = cc.main[2]
    else
      mark[1] = icon.alert
      text[1] = "|cffff0000MISSING TANKS IN DESIGNATED QUEUE!"
    end
  end

  if (isItem(assign, "Sapphiron")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_sapp_kel"
    text[1] = textcolor.note .. "Frost Resist gear on"
  end

  if (isItem(assign, "Kel'Thuzad")) then
    DNABossMap = DNAGlobal.dir .. "images/naxx_sapp_kel"
  end

end
