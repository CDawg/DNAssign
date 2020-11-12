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
  "BWL",
  "Blackwing Lair",
  "Interface/GLUES/LoadingScreens/LoadScreenBlackWingLair",
  "Interface/EncounterJournal/UI-EJ-BOSS-Nefarian",
  "Interface/EncounterJournal/UI-EJ-DUNGEONBUTTON-BlackwingLair",
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-BlackwingLair"
}
local bossList = {
  {"Razorgore",           "Interface/EncounterJournal/UI-EJ-BOSS-Razorgore the Untamed", 0},
  {"Vaelestraz",          "Interface/EncounterJournal/UI-EJ-BOSS-Vaelastrasz the Corrupt", 0},
  {"Dragon Pack",         "Interface/EncounterJournal/UI-EJ-BOSS-Overlord Wyrmthalak", 1},
  {"Suppression Room",    "Interface/EncounterJournal/UI-EJ-BOSS-Flamebender Kagraz", 1},
  {"Goblin Pack",         "Interface/EncounterJournal/UI-EJ-BOSS-Pauli Rocketspark", 1},
  {"Firemaw",             "Interface/EncounterJournal/UI-EJ-BOSS-Firemaw", 0},
  {"Small Wyrmguards (4)","Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer", 1},
  {"Large Wyrmguards (3)","Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer", 1},
  {"Ebonroc",             "Interface/EncounterJournal/UI-EJ-BOSS-Ebonroc", 0},
  {"Flamegor",            "Interface/EncounterJournal/UI-EJ-BOSS-Flamegor", 0},
  {"Chromaggus",          "Interface/EncounterJournal/UI-EJ-BOSS-Chromaggus", 0},
  {"Nefarian",            "Interface/EncounterJournal/UI-EJ-BOSS-Nefarian", 0}
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

local note_color = "|cffbebebe"

function DNAInstanceBWL(assign, total, raid, mark, text, heal, tank, healer)
  local compass={"-ORB-", "NORTH", "EAST", "SOUTH", "WEST"}

  if (isItem(assign, "Razorgore")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_razorgore"
    for i=1, 5 do
      text[i] = compass[i]
      heal[i] = tank.all[i] .. "," .. healer.all[i]
    end
  end

  if (isItem(assign, "Vaelestraz")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_vaelastrasz"
    local healer_row = ""
    local vael_heals = {}
    table.merge(vael_heals, healer.priest)
    table.merge(vael_heals, healer.druid)
    for i=1, table.getn(healer.paladin) do
      --if (i <= 4) then --max at 4 pally healers
        healer_row = healer_row .. healer.paladin[i] .. ","
      --end
    end
    for i=1, 3 do
      text[i] = tank.all[i]
      heal[i] = healer_row
    end
    for i=1, table.getn(vael_heals) do
      text[i+4] = "RAID HEAL"
      heal[i+4] = vael_heals[i]
    end
  end

  if (isItem(assign, "Dragon Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_dragonpack"
    local healer_row = ""
    local dpack_heals = {}
    table.merge(dpack_heals, healer.paladin)
    table.merge(dpack_heals, healer.priest)
    --static shuffle
    if (dpack_heals[7]) then
      dpack_heals[2] = dpack_heals[7]
    end
    for i=1, 3 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = dpack_heals[i] -- don't assign druids
    end
    mark[4] = icon_circle
    mark[5] = icon_square
    if (raid.hunter[1]) then
      text[4] = raid.hunter[1]
    else
      text[4] = tank.all[4]
    end
    if (raid.hunter[2]) then
      text[5] = raid.hunter[2]
    else
      text[5] = tank.all[5]
    end
    if (healer.druid[1]) then
      mark[6] = icon_diamond
      text[6] = healer.druid[1]
      heal[6] = dpack_heals[4]
      if (heal[6] == healer.all[4]) then
        heal[6] = dpack_heals[5]
      end
    end
    if (healer.druid[2]) then
      mark[7] = icon_moon
      text[7] = healer.druid[2]
      heal[7] = dpack_heals[6]
      if (heal[7] == healer.all[6]) then
        heal[7] = dpack_heals[7]
      end
    end
    text[9] = "Extra marks provided for Crowd Control"
  end

  if (isItem(assign, "Suppression Room")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_goblinpack"
    NUM_ADDS = 3
    text[1] = "No AOE Tank assigned!" --default message
    for i=1, DNASlots.tank do
      if ((DNARaid["class"][tank.main[i]] == "Paladin") or (DNARaid["class"][tank.main[i]] == "Druid")) then
        text[1] = "Whelps"
        heal[1] = tank.main[i]
      end
    end
    for i=1, NUM_ADDS do
      mark[i+1] = DNARaidMarkers[i+1][2]
      text[i+1] = tank.all[i]
      heal[i+1] = healer.all[i]
    end
    for i=1, total.rogues do
      text[i+NUM_ADDS*2] = " - Device - "
      heal[i+NUM_ADDS*2] = raid.rogue[i]
    end
  end

  if (isItem(assign, "Goblin Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_broodlord"
    for i=1, 6 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    text[8] = note_color .. "-- PULL --"
    heal[8] = note_color .. "-- TANK --"

    for i=1, 4 do
      if (raid.hunter[i]) then
        mark[i+8] = DNARaidMarkers[i+1][2]
        text[i+8] = raid.hunter[i]
        heal[i+8] = tank.all[i]
      end
    end
  end

  if (isItem(assign, "Firemaw")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_firemaw"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]
    if (tank.all[3]) then
      text[3] = "-- STACK ROTATION RELIEF / RANGE SIDE --"
      mark[4] = DNABossIcon
      text[4] = tank.all[3]
      heal[4] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]
    end
    text[6] = "-- WINGBUFF / MELEE SIDE --"
    mark[7] = DNABossIcon
    text[7] = tank.all[2]
    heal[7] = healer.priest[3] .. "," .. healer.priest[4] .. "," .. healer.paladin[2]

    if (healer.paladin[3]) then
      text[9] = "RANGE HEAL"
      heal[9] = healer.paladin[3]
    end
    if (healer.druid[1]) then
      text[10] = "MELEE HEAL"
      heal[10] = healer.druid[1]
    end

    local firemaw_heals = {}
    table.merge(firemaw_heals, healer.all)
    --remove the assigned healers
    removeValueFromArray(firemaw_heals, healer.druid[1])
    removeValueFromArray(firemaw_heals, healer.paladin[1])
    removeValueFromArray(firemaw_heals, healer.paladin[2])
    removeValueFromArray(firemaw_heals, healer.paladin[3])
    removeValueFromArray(firemaw_heals, healer.priest[1])
    removeValueFromArray(firemaw_heals, healer.priest[2])
    removeValueFromArray(firemaw_heals, healer.priest[3])
    removeValueFromArray(firemaw_heals, healer.priest[4])
    for i=1, table.getn(firemaw_heals) do
      if (firemaw_heals[i]) then
        text[i+11] = "MELEE HEAL"
        heal[i+11] = firemaw_heals[i]
      end
    end
  end

  if (isItem(assign, "Small Wyrmguards (4)")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_firemaw"
    NUM_ADDS = 4
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Large Wyrmguards (3)")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_ebonroc"
    NUM_ADDS = 3
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i] .. "," .. healer.all[i+2]
    end
    text[5] = "-- BACKUP --"
    for i=1, NUM_ADDS do
      mark[i+5] = DNARaidMarkers[i+1][2]
      text[i+5] = tank.all[i+3]
      heal[i+5] = healer.all[i+5]
    end

    text[10] = "Tanks: Equip shields!"
  end

  if (isItem(assign, "Ebonroc")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_ebonroc"
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    text[3] = "-- WINGBUFF --"
    text[4] = tank.all[2]
    heal[4] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]
    text[6] = "-- CURSE RELIEF (OPTIONAL) --"
    text[7] = tank.all[3]
    heal[7] = healer.all[7] .. "," .. healer.all[8] .. "," .. healer.all[9]
  end

  if (isItem(assign, "Flamegor")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_flamegor"
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    text[3] = "-- WINGBUFF --"
    text[4] = tank.all[2]
    heal[4] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]

    for i=1, table.getn(raid.hunter) do
      mark[i+5] = "Interface/Icons/spell_nature_drowsy"
      text[i+5] = "Tranq Shot"
      heal[i+5] = raid.hunter[i]
    end
  end

  if (isItem(assign, "Chromaggus")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_Chromaggus"
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]
    text[3] = note_color .. "-- TIME LAPSE / MELEE --"
    text[4] = tank.all[2]
    heal[4] = healer.priest[3] .. "," .. healer.priest[4] .. "," .. healer.paladin[2]
  end

  if (isItem(assign, "Nefarian")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_Nefarian"
  end
end
