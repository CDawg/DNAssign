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
  "Interface/EncounterJournal/UI-EJ-BACKGROUND-TempleofAhnQiraj",
  DNAGlobal.dir .. "images/aq40",
  "Classic",
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
  {"Champion Pack",      "Interface/EncounterJournal/UI-EJ-BOSS-General Rajaxx", 1},
  {"Obsidian Pack",      "Interface/EncounterJournal/UI-EJ-BOSS-Moam", 1},
  {"C'Thun",             "Interface/EncounterJournal/UI-EJ-BOSS-CThun", 0}
}

table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer, cc)

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
        text[i+NUM_ADDS+1] = textcolor.note .. "Detect Magic"
        heal[i+NUM_ADDS+1] = raid.mage[i]
      end
    end
  end

  if (isItem(assign, "Prophet Skeram")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    text[1] = textcolor.note .. "- MIDDLE -"
    mark[2] = icon.diamond
    text[2] = tank.all[1]
    heal[2] = tank.all[4] .. "," .. healer.priest[1] .. "," .. healer.paladin[1]

    text[4] = textcolor.note .. "- LEFT -"
    mark[5] = icon.cross
    text[5] = tank.all[2]
    heal[5] = tank.all[5] .. "," .. healer.priest[2] .. "," .. healer.paladin[2]

    text[7] = textcolor.note .. "- RIGHT -"
    mark[8] = icon.triangle
    text[8] = tank.all[3]
    heal[8] = tank.all[6] .. "," .. healer.priest[3] .. "," .. healer.paladin[3]

    text[10] = textcolor.note .. "|cffFFF569ROGUES|r: " .. textcolor.note .. "Mind dumbing poison offhand."
    for i=1, total.rogues do
      if (raid.rogue[i]) then
        text[i+10] = textcolor.note .. "KICKS"
        heal[i+10] = raid.rogue[i]
      end
    end

   text[total.rogues+12] = textcolor.note .. "|cff8787EDWARLOCKS|r: " .. textcolor.note .. "Curse of Tongues"
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
    for i=1, NUM_BOSSES-1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.nodruid[i] .. "," .. healer.nodruid[i+3]
    end

    mark[3] = icon.triangle
    text[3] = tank.all[3]
    heal[3] = healer.nodruid[3] .. "," .. healer.nodruid[6]

    for i=1, table.getn(raid.fearward) do
      mark[i+NUM_BOSSES] = icon.triangle
      text[i+NUM_BOSSES] = textcolor.note .. "Fear Ward"
      heal[i+NUM_BOSSES] = raid.fearward[i]
    end

    local extra_tanks = ""
    for i=1, 2 do
      if (tank.all[i+3]) then
        extra_tanks = extra_tanks .. tank.all[i+3] .. ","
      end
    end
    mark[NUM_BOSSES+table.getn(raid.fearward)+1] = icon.triangle
    text[NUM_BOSSES+table.getn(raid.fearward)+1] = textcolor.note .. "Yauj Interrupts"
    heal[NUM_BOSSES+table.getn(raid.fearward)+1] = extra_tanks

    local extra_rogues = ""
    for i=1, 2 do
      if (cc.main[i]) then
        extra_rogues = extra_rogues .. cc.main[i] .. ","
      end
      if (raid.rogue[i]) then
        extra_rogues = extra_rogues .. raid.rogue[i] .. ","
      end
    end
    mark[NUM_BOSSES+table.getn(raid.fearward)+2] = icon.triangle
    text[NUM_BOSSES+table.getn(raid.fearward)+2] = textcolor.note .. "Yauj Interrupts"
    heal[NUM_BOSSES+table.getn(raid.fearward)+2] = extra_rogues

    local poison_cleanse = ""
    for i=1, 3 do
      if (healer.druid[i]) then
        poison_cleanse = poison_cleanse .. healer.druid[i] .. ","
      end
    end
    for i=1, 3 do
      if (healer.paladin[i+2]) then
        poison_cleanse = poison_cleanse .. healer.paladin[i+2] .. ","
      end
    end
    text[NUM_BOSSES+table.getn(raid.fearward)+4] = textcolor.note .. "Poison Cleanse"
    heal[NUM_BOSSES+table.getn(raid.fearward)+4] = poison_cleanse
  end

  if (isItem(assign, "Vekniss Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    for i=1, 8 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    text[10] = textcolor.note .. "Extra marks are only for backup!"
  end

  if (isItem(assign, "Battleguard Sartura")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.paladin[1] .. "," .. healer.priest[1]
    mark[2] = DNABossIcon
    text[2] = tank.all[2]
    heal[2] = healer.paladin[2] .. "," .. healer.priest[2]

    text[4] = "-- BOSS ADDS -- "
    mark[5] = DNARaidMarkers[2][2]
    text[5] = tank.all[3]
    heal[5] = healer.paladin[3]
    mark[6] = DNARaidMarkers[3][2]
    text[6] = tank.all[4]
    heal[6] = healer.priest[3]
    mark[7] = DNARaidMarkers[4][2]
    text[7] = tank.all[5]
    heal[7] = healer.priest[4]

    text[9] = "-- ADD PULLS -- "
    if (raid.hunter[1]) then
      mark[10] = DNARaidMarkers[2][2]
      text[10] = tank.all[3]
      heal[10] = raid.hunter[1]
    end
    if (raid.hunter[2]) then
      mark[11] = DNARaidMarkers[3][2]
      text[11] = tank.all[4]
      heal[11] = raid.hunter[2]
    end
    if (raid.hunter[3]) then
      mark[12] = DNARaidMarkers[4][2]
      text[12] = tank.all[5]
      heal[12] = raid.hunter[3]
    end
    if (cc.main[1]) then
      mark[14] = DNARaidMarkers[2][2]
      text[14] = cc.main[1]
    else
      if (raid.rogue[1]) then
        mark[14] = DNARaidMarkers[2][2]
        text[14] = raid.rogue[1]
      end
    end
    if (cc.main[2]) then
      mark[15] = DNARaidMarkers[3][2]
      text[15] = cc.main[2]
    else
      if (raid.rogue[2]) then
        mark[15] = DNARaidMarkers[3][2]
        text[15] = raid.rogue[2]
      end
    end
    if (cc.main[3]) then
      mark[16] = DNARaidMarkers[4][2]
      text[16] = cc.main[3]
    else
      if (raid.rogue[3]) then
        mark[16] = DNARaidMarkers[4][2]
        text[16] = raid.rogue[3]
      end
    end
    local extra_mages = ""
    for i=1, 3 do
      if (raid.mage[i]) then
        extra_mages = extra_mages .. raid.mage[i] .. ","
      end
    end
    text[18] = textcolor.note .. "Amplify Magic"
    heal[18] = extra_mages
  end

  if (isItem(assign, "Fankriss")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    mark[2] = DNABossIcon
    text[2] = tank.all[2]
    heal[2] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]

    text[4] = textcolor.note .. "Boss Trash"
    heal[4] = tank.all[3]
    text[5] = textcolor.note .. "Boss Trash"
    heal[5] = tank.all[4]
  end

  if (isItem(assign, "Stinger Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, 4 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.nodruid[i]
    end

    text[6] = textcolor.note .. "Poison Cleanse"
    if (healer.druid[1]) then
      heal[6] = healer.druid[1]  .. "," ..  healer.paladin[1]
    else
      heal[6] = healer.paladin[1] .. "," .. healer.paladin[2]
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
      text[i+3] = textcolor.note .. "Raid Heals"
      heal[i+3] = priest_druids[i]
    end

    text[13] = textcolor.note .. "PRE POT NATURE POTS"
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
      mark[2] = icon.alert
      text[2] = "|cffff0000MISSING WARLOCKS IN THE TANK QUEUE!"
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
      text[7] = textcolor.note .. "Bugs"
      heal[7] = remaining_tank[1]
    end
    if (remaining_tank[2]) then
      mark[8] = "Interface/EncounterJournal/UI-EJ-BOSS-Silithid Royalty"
      text[8] = textcolor.note .."Bugs"
      heal[8] = remaining_tank[2]
    end

    text[10] = textcolor.note .. "TANKS: Greater Stoneshield Pots"
    text[12] = textcolor.note .. "NO AOE!!!"

    --[==[
    for i=1, 3 do
      if (tank.all[i+4]) then
        text[i+9] = "MELEE ABSORB"
        heal[i+9] = tank.all[i+4]
      end
    end
    text[14] = textcolor.note .. "TANKS: Greater Stoneshield Pots"
    text[15] = textcolor.note .. "NO AOE!!!"
    ]==]--
  end

  if (isItem(assign, "Champion Pack")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    local tank_all_paladin = {}
    table.merge(tank_all_paladin, tank.all)
    table.merge(tank_all_paladin, raid.paladin_dps)
    for i=1, 5 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank_all_paladin[i]
      heal[i] = healer.all[i]
    end
    text[6] = "-- BACKUP --"
    for i=1, 5 do
      mark[i+6] = DNARaidMarkers[i+1][2]
      if (tank_all_paladin[i+6]) then
        text[i+6] =  tank_all_paladin[i+5]
      end
    end

    local num_fearwards = table.getn(raid.fearward)
    for i=1, num_fearwards do
      mark[i+12] = icon.cross
      text[i+12] = textcolor.note .. "Fear Ward"
      heal[i+12] = raid.fearward[i]
    end
    for i=1, table.getn(raid.hunter) do
      mark[i+12+num_fearwards] = "Interface/Icons/spell_nature_drowsy"
      text[i+12+num_fearwards] = textcolor.note .. "Tranq Shot"
      heal[i+12+num_fearwards] = raid.hunter[i]
    end
  end


  if (isItem(assign, "Obsidian Pack")) then
    NUM_ADDS = 3
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      if (healer.paladin[i]) then
        heal[i] = healer.paladin[i]
      end
    end

    if (raid.priest[1]) then
      mark[1+NUM_ADDS+1] = icon.skull
      text[1+NUM_ADDS+1] = textcolor.note .. "MANA DRAIN"
      heal[1+NUM_ADDS+1] = raid.priest[1]
    end
    if (raid.priest[2]) then
      mark[1+NUM_ADDS+2] = icon.cross
      text[1+NUM_ADDS+2] = textcolor.note .. "MANA DRAIN"
      heal[1+NUM_ADDS+2] = raid.priest[2]
    end
    if (raid.priest[3]) then
      mark[1+NUM_ADDS+3] = icon.skull
      text[1+NUM_ADDS+3] = textcolor.note .. "MANA DRAIN"
      heal[1+NUM_ADDS+3] = raid.priest[3]
    end
    if (raid.priest[4]) then
      mark[1+NUM_ADDS+4] = icon.cross
      text[1+NUM_ADDS+4] = textcolor.note .. "MANA DRAIN"
      heal[1+NUM_ADDS+4] = raid.priest[4]
    end
  end

  if (isItem(assign, "C'Thun")) then
    DNABossMap = DNAGlobal.dir .. "images/aq40_cthun_groups"
    mark[2] = icon.left
    text[2] = textcolor.note .. "View the map for your group positioning and"
    text[3] = textcolor.note .. "your group number!"
    text[5] = textcolor.note .. "RANGE: Little Eye Tentacles"
    text[7] = textcolor.note .. "MELEE: Interrupts Large Eye Tentacles"
  end
end
