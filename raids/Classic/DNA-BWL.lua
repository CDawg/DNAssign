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
  "BWL",
  "Blackwing Lair",
  "Interface/GLUES/LoadingScreens/LoadScreenBlackWingLair",
  "Interface/EncounterJournal/UI-EJ-BOSS-Nefarian",
  "Interface/EncounterJournal/UI-EJ-DUNGEONBUTTON-BlackwingLair",
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-BlackwingLair",
  DNAGlobal.dir .. "images/bwl_goblinpack",
  "Classic",
}
local bossList = {
  {"Razorgore",           "Interface/EncounterJournal/UI-EJ-BOSS-Razorgore the Untamed", 0},
  {"Vaelestraz",          "Interface/EncounterJournal/UI-EJ-BOSS-Vaelastrasz the Corrupt", 0},
  {"- Second Floor -",    "", 2},
  {"Dragon Pack",         "Interface/EncounterJournal/UI-EJ-BOSS-Overlord Wyrmthalak", 1},
  {"Suppression Room",    "Interface/EncounterJournal/UI-EJ-BOSS-Flamebender Kagraz", 1},
  {"Goblin Pack",         "Interface/EncounterJournal/UI-EJ-BOSS-Pauli Rocketspark", 1},
  {"Firemaw",             "Interface/EncounterJournal/UI-EJ-BOSS-Firemaw", 0},
  {"Small Wyrmguards (4)","Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer", 1},
  {"- Third Floor -",     "", 2},
  {"Large Wyrmguards (3)","Interface/EncounterJournal/UI-EJ-BOSS-Broodlord Lashlayer", 1},
  {"Ebonroc",             "Interface/EncounterJournal/UI-EJ-BOSS-Ebonroc", 0},
  {"Flamegor",            "Interface/EncounterJournal/UI-EJ-BOSS-Flamegor", 0},
  {"- Fourth Floor -",    "", 2},
  {"Chromaggus",          "Interface/EncounterJournal/UI-EJ-BOSS-Chromaggus", 0},
  {"Nefarian",            "Interface/EncounterJournal/UI-EJ-BOSS-Nefarian", 0}
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DN:Instance_BWL(assign, total, raid, mark, text, heal, tank, healer, cc)
  local compass={"-ORB-", "NORTH", "EAST", "SOUTH", "WEST"}

  if (isItem(assign, "Razorgore")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_razorgore"
    for i=1, 5 do
      text[i] = textcolor.note .. compass[i]
      heal[i] = tank.all[i] .. "," .. healer.all[i]
    end
    text[7] = textcolor.note .. "EVENS - NORTH"
    text[8] = textcolor.note .. "ODDS - SOUTH"

    text[10] = textcolor.note .. "CONFLAG"
    heal[10] = tank.all[2] .. "," .. healer.all[2]
    text[12] = textcolor.note .. "FREE ACTION POT FOR CONFLAG TANK!"
  end

  if (isItem(assign, "Vaelestraz")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_vaelastrasz"
    local healer_row = ""
    local vael_heals = {}
    table.merge(vael_heals, healer.priest)
    table.merge(vael_heals, healer.druid)
    for i=1, table.getn(healer.paladin) do
      healer_row = healer_row .. healer.paladin[i] .. ","
    end
    for i=1, 3 do
      mark[i] = DNABossIcon
      text[i] = tank.all[i]
      heal[i] = healer_row
    end
    for i=1, table.getn(vael_heals) do
      text[i+4] = textcolor.note .. "RAID HEAL"
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
    mark[4] = icon.circle
    mark[5] = icon.square
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
    if (raid.druid[1]) then
      mark[6] = icon.diamond
      text[6] = raid.druid[1]
      heal[6] = dpack_heals[4]
      if (heal[6] == healer.all[4]) then
        heal[6] = dpack_heals[5]
      end
    end
    if (raid.druid[2]) then
      mark[7] = icon.moon
      text[7] = raid.druid[2]
      heal[7] = dpack_heals[6]
      if (heal[7] == healer.all[6]) then
        heal[7] = dpack_heals[7]
      end
    end
    text[9] = textcolor.note .. "Extra marks provided for crowd control"
  end

  if (isItem(assign, "Suppression Room")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_goblinpack"
    NUM_ADDS = 3
    mark[1] = icon.alert
    text[1] = "|cffff0000 MISSING AOE TANK IN TANK QUEUE!" --default message
    for i=1, DNASlots.tank do
      if ((DNARaid["class"][tank.main[i]] == "Paladin") or (DNARaid["class"][tank.main[i]] == "Druid")) then
        text[1] = textcolor.note .. "Whelps"
        heal[1] = tank.main[i] .. "," .. healer.all[4]
      end
    end
    for i=1, NUM_ADDS do
      mark[i+1] = DNARaidMarkers[i+1][2]
      text[i+1] = tank.all[i]
      heal[i+1] = healer.all[i]
    end
    for i=1, total.rogues do
      text[i+NUM_ADDS*2] = textcolor.note .. " - Device - "
      heal[i+NUM_ADDS*2] = raid.rogue[i]
    end
  end

  if (isItem(assign, "Goblin Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_broodlord"
    for i=1, 6 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.nodruid[i]
    end

    text[8] = textcolor.note .. "-- PULL --"
    heal[8] = textcolor.note .. "-- TANK --"

    for i=1, 4 do
      if (raid.hunter[i]) then
        mark[i+8] = DNARaidMarkers[i+1][2]
        text[i+8] = raid.hunter[i]
        heal[i+8] = tank.all[i]
      end
    end
    for i=7, DNASlots.heal do
      if (healer.nodruid[i]) then
        text[i+6] = textcolor.note .. "Mage heal"
        heal[i+6] = healer.nodruid[i]
      end
    end
  end

  if (isItem(assign, "Firemaw")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_firemaw"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]

    text[3] = "-- WINGBUFF / MELEE SIDE --"
    mark[4] = DNABossIcon
    text[4] = tank.all[2]
    heal[4] = healer.priest[3] .. "," .. healer.priest[4] .. "," .. healer.paladin[2]

    if (healer.druid[1]) then
      text[6] = textcolor.note .. "MELEE HEAL"
      heal[6] = healer.druid[1]
    end

    local firemaw_heals = {}
    table.merge(firemaw_heals, healer.all)
    --remove the assigned healers
    removeValueFromArray(firemaw_heals, healer.druid[1])
    removeValueFromArray(firemaw_heals, healer.paladin[1])
    removeValueFromArray(firemaw_heals, healer.paladin[2])
    removeValueFromArray(firemaw_heals, healer.priest[1])
    removeValueFromArray(firemaw_heals, healer.priest[2])
    removeValueFromArray(firemaw_heals, healer.priest[3])
    removeValueFromArray(firemaw_heals, healer.priest[4])
    for i=1, table.getn(firemaw_heals) do
      if (firemaw_heals[i]) then
        text[i+6] = textcolor.note .. "RANGE HEAL"
        heal[i+6] = firemaw_heals[i]
      end
    end

    text[table.getn(firemaw_heals)+10] = textcolor.note .. "ONYXIA SCALE CLOAKS ON!!!"
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
      heal[i] = healer.all[i] .. "," .. healer.all[i+3]
    end
    text[5] = "-- BACKUP --"
    for i=1, NUM_ADDS do
      mark[i+5] = DNARaidMarkers[i+1][2]
      text[i+5] = tank.all[i+3]
      if (healer.all[i+6]) then
        heal[i+5] = healer.all[i+6]
      end
    end

    text[10] = "TANKS: Equip Shields and use Free Action Pots!"
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
    if (healer.all[7]) then
      heal[7] = healer.all[7]
      if (healer.all[8]) then
          heal[7] = healer.all[7] .. "," .. healer.all[8]
        if (healer.all[9]) then
          heal[7] = healer.all[7] .. "," .. healer.all[8] .. "," .. healer.all[9]
        end
      end
    end

    text[10] = textcolor.note .. "ONYXIA SCALE CLOAKS ON!!!"
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

    text[10] = textcolor.note .. "ONYXIA SCALE CLOAKS ON!!!"
  end

  if (isItem(assign, "Chromaggus")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_Chromaggus"
    text[1] = tank.all[1]
    heal[1] = healer.priest[1] .. "," .. healer.priest[2] .. "," .. healer.paladin[1]
    text[3] = textcolor.note .. "-- TIME LAPSE / MELEE --"
    text[4] = tank.all[2]
    if (healer.druid[1]) then
      heal[4] = healer.druid[1] .. "," .. healer.paladin[2]
    else
      heal[4] = healer.priest[3] .. "," .. healer.paladin[2]
    end
    text[6] = textcolor.note .. "Rest of healers on range side."
    text[7] = textcolor.note .. "Paladins/Druids cleanse poison."
    for i=1, total.mages do
      if (raid.mage[i]) then
        text[i+8] = textcolor.note .. "DECURSE"
        heal[i+8] = raid.mage[i]
      end
    end
  end

  if (isItem(assign, "Nefarian")) then
    DNABossMap = DNAGlobal.dir .. "images/bwl_nefarian"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]

    --fear warders
    for i=1, table.getn(raid.fearward) do
      mark[i+2] = "Interface/Icons/spell_holy_excorcism"
      text[i+2] = tank.all[1]
      heal[i+2] = raid.fearward[i]
    end

    if (raid.mage[1]) then
      mark[6] = "Interface/Icons/spell_nature_removecurse"
      text[6] = "Decruse"
      heal[6] = raid.mage[1]
    end
    if (raid.mage[2]) then
      mark[7] = "Interface/Icons/spell_nature_removecurse"
      text[7] = "Decruse"
      heal[7] = raid.mage[2]
    end
    if (raid.mage[3]) then
      mark[8] = "Interface/Icons/spell_nature_removecurse"
      text[8] = "Decruse"
      heal[8] = raid.mage[3]
    end

    text[10] = textcolor.note .. "ONYXIA SCALE CLOAKS ON!!!"
  end
end
