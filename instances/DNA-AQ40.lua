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
  "AQ40",
  "Temple of Ahn'Qiraj",
  "Interface/GLUES/LoadingScreens/LoadScreenAhnQiraj40man",
  "Interface/EncounterJournal/UI-EJ-BOSS-CThun",
  "Interface/EncounterJournal/UI-EJ-DUNGEONBUTTON-TempleofAhnQiraj",
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-TempleofAhnQiraj"
}
local bossList = {
  {"Anubisath Sentinels",DNAGlobal.dir .. "images/boss_anubisath2", 1},
  {"Prophet Skeram",     "Interface/EncounterJournal/UI-EJ-BOSS-The Prophet Skeram", 0},
  {"Mindflayer Pack",    "Interface/EncounterJournal/UI-EJ-BOSS-Harbinger Skyriss", 1},
  {"Bug Trio",           "Interface/EncounterJournal/UI-EJ-BOSS-Silithid Royalty", 0},
  {"Vekniss Pack",       DNAGlobal.dir .. "images/boss_vekniss", 1},
  {"Battleguard Sartura","Interface/EncounterJournal/UI-EJ-BOSS-Battleguard Sartura", 0},
  {"Fankriss",           "Interface/EncounterJournal/UI-EJ-BOSS-Fankriss the Unyielding", 0},
  {"Stinger Pack",       DNAGlobal.dir .. "images/boss_wasps", 1},
  {"Princess Huhuran",   "Interface/EncounterJournal/UI-EJ-BOSS-Princess Huhuran", 0},
  {"Twin Emperors",      "Interface/EncounterJournal/UI-EJ-BOSS-Twin Emperors", 0},
  {"Champion Pack",      "Interface/EncounterJournal/UI-EJ-BOSS-General Rajaxx", 0},
  {"C'Thun",             "Interface/EncounterJournal/UI-EJ-BOSS-CThun", 0}
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer)
  local fearward={}

  if (isItem(assign, "Anubisath Sentinels")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    NUM_ADDS = 4
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]

      if (raid.mage[i]) then
        --mark[i+NUM_ADDS+1] = "Interface/Icons/spell_holy_dizzy"
        mark[i+NUM_ADDS+1] = DNARaidMarkers[i+1][2]
        text[i+NUM_ADDS+1] = "Detect Magic"
        heal[i+NUM_ADDS+1] = raid.mage[i]
      end
    end
  end

  if (isItem(assign, "Prophet Skeram")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    --local PLATFORMS = {"MIDDLE", "LEFT", "RIGHT"}
    text[1] = note_color .. "- MIDDLE -"
    text[2] = tank.all[1]
    heal[2] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]

    text[4] = note_color .. "- LEFT -"
    text[5] = tank.all[2]
    heal[5] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]

    text[7] = note_color .. "- RIGHT -"
    text[8] = tank.all[3]
    if (healer.all[9]) then
      heal[8] = healer.all[7] .. "," .. healer.all[8] .. "," .. healer.all[9]
    else
      heal[8] = healer.all[7] .. "," .. healer.all[8]
    end
  end

  if (isItem(assign, "Mindflayer Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, 4 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Bug Trio")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    NUM_BOSSES=3
    local interrupts={}
    table.merge(interrupts, raid.warrior)
    table.merge(interrupts, raid.rogue)
    local num_interrupts = table.getn(interrupts)
    for i=1, NUM_BOSSES do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i] .. "," .. healer.all[i+3]
    end

    for i=1, num_interrupts do
      if (interrupts[i]) then
        text[i+NUM_BOSSES+1] = "Yauj Interrupts"
        heal[i+NUM_BOSSES+1] = interrupts[i]
      end
    end

    for i=1, table.getn(raid.priest) do
      if ((DNARaid["class"][raid.priest[i]] == "Priest") and (DNARaid["race"][raid.priest[i]] == "Dwarf")) then
        fearward[i] = raid.priest[i]
      end
    end
    local i = 0
    for k,v in pairs(fearward) do
      i = i + 1
      mark[i+NUM_BOSSES+num_interrupts+2] = "Interface/Icons/spell_holy_excorcism"
      text[i+NUM_BOSSES+num_interrupts+2] = "Fear Ward"
      heal[i+NUM_BOSSES+num_interrupts+2] = v
    end
  end

  if (isItem(assign, "Vekniss Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    for i=1, 8 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    text[10] = note_color .. "Extra marks are only for backup!"
  end

  if (isItem(assign, "Battleguard Sartura")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    NUM_ADDS = 3
    for i=1, 2 do --first 2 primary tanks
      mark[i] = DNABossIcon
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    for i=1, NUM_ADDS do
      mark[i+NUM_ADDS] = DNARaidMarkers[i+1][2]
      text[i+NUM_ADDS] = tank.all[i+2]
      heal[i+NUM_ADDS] = healer.all[i+2]
    end
  end

  if (isItem(assign, "Fankriss")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    mark[2] = DNABossIcon
    text[2] = tank.all[2]
    heal[2] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]

    text[4] = note_color .. "Boss Adds"
    heal[4] = tank.all[3]
    text[5] = note_color .. "Boss Adds"
    heal[5] = tank.all[4]
  end

  if (isItem(assign, "Stinger Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, 4 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Princess Huhuran")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    local priest_druids={}
    table.merge(priest_druids, healer.priest)
    table.merge(priest_druids, healer.druid)
    mark[1] = DNABossIcon
    mark[2] = DNABossIcon
    text[1] = tank.all[1]
    text[2] = tank.all[2]
    if (healer.paladin[4]) then
      heal[1] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.paladin[3] .. "," .. healer.paladin[4]
      heal[2] = heal[1]
    else
      heal[1] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.paladin[3]
      heal[2] = heal[1]
    end
    for i=1, table.getn(priest_druids) do
      text[i+3] = "Raid Heals"
      heal[i+3] = priest_druids[i]
    end
  end

  if (isItem(assign, "Twin Emperors")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    local warlock_assigned = 0
    local warlock_tank = {}
    local remaining_tank = {}
    for i=1, DNASlots.tank do --count all the current tanks in main queue, then check for warlocks
      if (DNARaid["class"][tank.main[i]] == "Warlock") then
        table.insert(warlock_tank, tank.main[i])
        warlock_assigned = 1
      end
    end

    if (warlock_assigned ~= 1) then
      text[3] = "No warlocks assigned in tank queue!"
    end

    for i=1, table.getn(tank.main) do
      if (DNARaid["class"][tank.main[i]] ~= "Warlock") then
        table.insert(remaining_tank, tank.main[i])
      end
    end

    removeValueFromArray(remaining_tank, tank.main[1])
    removeValueFromArray(remaining_tank, tank.main[2])

    if (warlock_tank[1]) then
      mark[1] = DNABossIcon
      text[1] = tank.all[1]
      heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3] .. "," .. healer.all[4]
      mark[2] = DNABossIcon
      text[2] = warlock_tank[1]
      heal[2] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3] .. "," .. healer.all[4]
    end

    if (warlock_tank[2]) then
      mark[4] = DNABossIcon
      text[4] = tank.all[2]
      heal[4] = healer.all[5] .. "," .. healer.all[6] .. "," .. healer.all[7] .. "," .. healer.all[8]
      mark[5] = DNABossIcon
      text[5] = warlock_tank[2]
      heal[5] = healer.all[5] .. "," .. healer.all[6] .. "," .. healer.all[7] .. "," .. healer.all[8]
    end

    if (remaining_tank[1]) then
      mark[7] = "Interface/EncounterJournal/UI-EJ-BOSS-Silithid Royalty"
      text[7] = note_color .. "Bugs"
      heal[7] = remaining_tank[1]
    end
    if (remaining_tank[2]) then
      mark[8] = "Interface/EncounterJournal/UI-EJ-BOSS-Silithid Royalty"
      text[8] = note_color .."Bugs"
      heal[8] = remaining_tank[2]
    end

    text[10] = note_color .. "NO AOE!!!"
  end

  if (isItem(assign, "Champion Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    NUM_ADDS = 5
    for i=1, NUM_ADDS+1 do
      if (tank.main[i]) then
        mark[i] = DNARaidMarkers[i+1][2]
        text[i] = tank.all[i]
        heal[i] = healer.all[i]
      end

      text[NUM_ADDS+2] = "-- BACKUP --"
      if (raid.warrior[i]) then
        mark[i+NUM_ADDS+2] = DNARaidMarkers[i+1][2]
        text[i+NUM_ADDS+2] = raid.warrior[i]
        --heal[i+8] = healer.all[i]
      end
    end

    --fear warders
    for i=1, DNASlots.heal do
      if ((DNARaid["class"][raid.priest[i]] == "Priest") and (DNARaid["race"][raid.priest[i]] == "Dwarf")) then
        fearward[i] = raid.priest[i]
      end
    end

    local i = 0
    for k,v in pairs(fearward) do
      i = i + 1
      mark[i+NUM_ADDS+8] = "Interface/Icons/spell_holy_excorcism"
      text[i+NUM_ADDS+8] = "Fear Ward"
      heal[i+NUM_ADDS+8] = v
    end
  end

  if (isItem(assign, "C'Thun")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40_cthun_groups"
    for i=1, table.getn(raid.range) do
      text[i] = "Eye Tentacle"
      heal[i] = raid.range[i]
    end
  end
end
