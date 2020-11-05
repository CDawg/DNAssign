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

local bossList = {
  "BWL", --key
  "Razorgore",
  "Vaelestraz",
  "Dragon Pack",
  "Suppression Room",
  "Goblin Pack",
  "Firemaw",
  "Small Wyrmguards (4)",
  "Large Wyrmguards (3)",
  "Ebonroc",
  "Flamegor",
  "Chromaggus",
  "Nefarian"
}
local instanceDetails = {
  "BWL", --key
  "Blackwing Lair",
  "Interface/GLUES/LoadingScreens/LoadScreenBlackWingLair",
  "Interface/EncounterJournal/UI-EJ-BOSS-Nefarian",
  "Interface/EncounterJournal/UI-EJ-LOREBG-BlackwingLair"
}
table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceBWL(assign, total, raid, mark, text, heal, tank, healer)
  local compass={"-ORB-", "NORTH", "EAST", "SOUTH", "WEST"}

  if ((total.tanks) and (total.healers)) then
    mark[3] = "Interface/DialogFrame/UI-Dialog-Icon-AlertNew"
    text[3] = "No Tanks or Healers are assigned!"
    DNABossMap = ""
    return
  end

  if (isItem(assign, "Razorgore")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Razorgore the Untamed"
    DNABossMap = DNAGlobal.dir .. "images/bwl_razorgore"
    for i=1, 5 do
      text[i] = compass[i]
      heal[i] = tank.all[i] .. "," .. healer.all[i]
    end
  end

  if (isItem(assign, "Vaelestraz")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Vaelastrasz the Corrupt"
    DNABossMap = DNAGlobal.dir .. "images/bwl_vaelastrasz"
    local healer_row = ""
    local vael_heals = {}
    table.merge(vael_heals, healer.priest)
    table.merge(vael_heals, healer.druid)
    for i=1, table.getn(healer.paladin) do
      if (i <= 4) then --max at 4 pally healers
        healer_row = healer_row .. healer.paladin[i] .. ","
      end
    end
    for i=1, 3 do
      text[i] = tank.all[i]
      heal[i] = healer_row
    end
    text[5] = "-- RAID HEALS --"
    for i=1, table.getn(vael_heals) do
      text[i+5] = vael_heals[i]
    end
  end

  if (isItem(assign, "Dragon Pack")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Overlord Wyrmthalak"
    DNABossMap = DNAGlobal.dir .. "images/bwl_dragonpack"
    for i=1, 3 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
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
      heal[6] = healer.all[4]
      if (heal[6] == healer.all[4]) then
        heal[6] = healer.all[5]
      end
    end
    if (healer.druid[2]) then
      mark[7] = icon_moon
      text[7] = healer.druid[2]
      heal[7] = healer.all[6]
      if (heal[7] == healer.all[6]) then
        heal[7] = healer.all[7]
      end
    end
    text[9] = "Extra marks provided for Crowd Control"
  end

  if (isItem(assign, "Suppression Room")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Flamebender Kagraz"
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
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Pauli Rocketspark"
    DNABossMap = DNAGlobal.dir .. "images/bwl_broodlord"
    for i=1, 6 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    text[8] = "-- PULL --"
    heal[8] = "-- TANK --"

    for i=1, 4 do
      if (raid.hunter[i]) then
        mark[i+8] = DNARaidMarkers[i+1][2]
        text[i+8] = raid.hunter[i]
        heal[i+8] = tank.all[i]
      end
    end
  end

  if (isItem(assign, "Firemaw")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Firemaw"
    DNABossMap = DNAGlobal.dir .. "images/bwl_firemaw"
    text[1] = tank.all[1]
    heal[1] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    if (tank.all[3]) then
      text[3] = "-- Stack Rotation Relief --"
      text[4] = tank.all[3]
      heal[4] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    end
    text[6] = "-- Wingbuff --"
    text[7] = tank.all[2]
    heal[7] = healer.paladin[3] .. "," .. healer.priest[2] .. "," .. healer.priest[3]

    text[9] = "-- RANGE HEALERS --"
    text[10] = healer.priest[4]

    text[12] = "-- MELEE HEALERS --"
    local firemaw_heals = {}
    table.merge(firemaw_heals, healer.all)
    --[==[
    for i=1, table.getn(firemaw_heals) do
      print("before :" .. i .. firemaw_heals[i])
    end
    ]==]--
    --remove the assigned healers
    removeValueFromArray(firemaw_heals, healer.paladin[1])
    removeValueFromArray(firemaw_heals, healer.paladin[2])
    removeValueFromArray(firemaw_heals, healer.paladin[3])
    removeValueFromArray(firemaw_heals, healer.priest[1])
    removeValueFromArray(firemaw_heals, healer.priest[2])
    removeValueFromArray(firemaw_heals, healer.priest[3])
    removeValueFromArray(firemaw_heals, healer.priest[4])

    --[==[
    for i=1, table.getn(firemaw_heals) do
      print("after :" .. i .. firemaw_heals[i])
    end
    ]==]--
    for i=1, table.getn(firemaw_heals) do
      if (firemaw_heals[i]) then
        text[i+12] = firemaw_heals[i]
      end
    end
  end

  if (isItem(assign, "Small Wyrmguards (4)")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer"
    DNABossMap = DNAGlobal.dir .. "images/bwl_firemaw"
    NUM_ADDS = 4
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Large Wyrmguards (3)")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer"
    DNABossMap = DNAGlobal.dir .. "images/bwl_ebonroc"
    NUM_ADDS = 3
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    text[5] = "-- BACKUP --"
    for i=1, NUM_ADDS do
      mark[i+5] = DNARaidMarkers[i+1][2]
      text[i+5] = tank.all[i+3]
      heal[i+5] = healer.all[i+3]
    end
  end

  if (isItem(assign, "Ebonroc")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Ebonroc"
    DNABossMap = DNAGlobal.dir .. "images/bwl_ebonroc"
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    text[3] = "-- Wingbuff --"
    text[4] = tank.all[2]
    heal[4] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]
  end

  if (isItem(assign, "Flamegor")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Flamegor"
    DNABossMap = DNAGlobal.dir .. "images/bwl_flamegor"
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    text[3] = "-- Wingbuff --"
    text[4] = tank.all[2]
    heal[4] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]

    for i=1, table.getn(raid.hunter) do
      mark[i+5] = "Interface/Icons/spell_nature_drowsy"
      text[i+5] = "Tranq Shot"
      heal[i+5] = raid.hunter[i]
    end
  end

  if (isItem(assign, "Chromaggus")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Chromaggus"
    DNABossMap = DNAGlobal.dir .. "images/bwl_Chromaggus"
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    text[3] = "-- Time Lapse --"
    text[4] = tank.all[2]
    heal[4] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]
  end

  if (isItem(assign, "Nefarian")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Nefarian"
    DNABossMap = DNAGlobal.dir .. "images/bwl_Nefarian"
  end
end
