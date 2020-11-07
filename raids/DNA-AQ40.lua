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

--wow-ui-textures/EncounterJournal/UI-EJ-BOSS-Harbinger Skyriss.PNG
--UI-EJ-BOSS-General Rajaxx.PNG
--UI-EJ-BOSS-Ayamiss the Hunter.PNG
--UI-EJ-BOSS-Ossirian the Unscarred
--UI-EJ-BOSS-Setesh

local bossList = {
  "AQ40", --key
  "Anubisath Sentinels",
  "Prophet Skeram",
  "Mindflayer Pack",
  "Bug Trio",
  "Vekniss Pack",
  "Battleguard Sartura",
  "Fankriss",
  "Stinger Pack",
  "Princess Huhuran",
  "Twin Emperors",
  "Champion Pack",
  "C'Thun"
}

local bossDetails = {
  {"C'Thun",
  "DPS\nThe entire raid has to have impeccable positioning during Phase 1, to avoid deaths from Eye Beam and Dark Glare. The raid should be well prepared and have players assigned to various locations in the room around C'thun, ensuring an even distribution of players at max distance from one another, to avoid doubling and tripling the damage from Eye Beam, and setting the raid up for an easier rotation around the room during Dark Glare.\nDuring Phase 2, damage dealers should be looking to do\nas much damage while in C'thun's stomach as they can before receiving too much damage and having to leave the stomach. If any damage dealer is inside the stomach, they should communicate how much health the remaining Flesh Tentacle has, ensuring they wait to kill it until the raid is in position and all adds have been cleaned up around C'thun, so the raid can focus target C'thun when the Carapace goes away.\n\nTanks\nThe entire raid has to have impeccable positioning during Phase 1, to\navoid deaths from Eye Beam and Dark Glare. The raid should be well prepared and have players assigned to various locations in the room around C'thun, ensuring an even distribution of players at max distance from one another, to avoid doubling and tripling the damage from Eye Beam, and setting the raid up for an easier rotation around the room during Dark Glare.\nIf a tank is devoured into C'thun's stomach, they should immediately leave as they are too important for being up top, to pick\nup any Giant Claw Tentacles that may spawn, as their melee damage will do too much to a melee damage dealer or a caster if there isn't a tank holding threat. To exit, just jump on the launch pad in between the two Flesh Tentacles.\n\nHealers\nThe entire raid has to have impeccable positioning during Phase 1, to avoid deaths from Eye Beam and Dark Glare. The raid should be well prepared and have players assigned to various locations in the room around C'thun, ensuring an even\ndistribution of players at max distance from one another, to avoid doubling and tripling the damage from Eye Beam, and setting the raid up for an easier rotation around the room during Dark Glare.\nIn the event a healer is devoured and sent to C'thun's stomach, they should immediately heal anyone inside the stomach and top them off, before leaving the stomach and joining the rest of the raid up top. To exit, just jump on the launch pad in between the two Flesh Tentacles.\n"
  },
}

local instanceDetails = {
  "AQ40", --key
  "Temple of Ahn'Qiraj",
  "Interface/GLUES/LoadingScreens/LoadScreenAhnQiraj40man",
  "Interface/EncounterJournal/UI-EJ-BOSS-CThun",
  "Interface/EncounterJournal/UI-EJ-LOREBG-TempleofAhnQiraj"
}
table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer)

  if (isItem(assign, "Anubisath Sentinels")) then
    --DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Setesh"
    DNABossIcon = DNAGlobal.dir .. "images/boss_anubisath2"
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    NUM_ADDS = 4
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]

      if (raid.mage[i]) then
        mark[i+NUM_ADDS+1] = "Interface/Icons/spell_holy_dizzy"
        text[i+NUM_ADDS+1] = "Detect Magic"
        heal[i+NUM_ADDS+1] = raid.mage[i]
      end
    end
  end

  if (isItem(assign, "Prophet Skeram")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-The Prophet Skeram"
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    local PLATFORMS = {"MIDDLE", "LEFT", "RIGHT"}
    for i=1, table.getn(PLATFORMS) do
      text[i] = "-" .. PLATFORMS[i] .. "-"
      heal[i] = tank.all[i]
    end

    text[6] = "Rogues use mind numbing poison on offhand."
  end

  if (isItem(assign, "Prophet Skeram")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-The Prophet Skeram"
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    local PLATFORMS = {"MIDDLE", "LEFT", "RIGHT"}
    for i=1, table.getn(PLATFORMS) do
      text[i] = "-" .. PLATFORMS[i] .. "-"
      heal[i] = tank.all[i]
    end

    text[6] = "Rogues use mind numbing poison on offhand."
  end

  if (isItem(assign, "Mindflayer Pack")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Harbinger Skyriss"
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, 4 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Bug Trio")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Silithid Royalty"
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    NUM_BOSSES=3
    for i=1, NUM_BOSSES do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    for i=1, 5 do
      text[i+NUM_BOSSES+1] = "Yauj Interrupts"
      heal[i+NUM_BOSSES+1] = tank.all[i+NUM_BOSSES]
    end
  end

  if (isItem(assign, "Vekniss Pack")) then
    DNABossIcon = DNAGlobal.dir .. "images/boss_vekniss"
    DNABossMap = DNAGlobal.dir .. "images/aq40_entrance"
    for i=1, 6 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Battleguard Sartura")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Battleguard Sartura"
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, 4 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Fankriss")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Fankriss the Unyielding"
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    text[2] = tank.all[2]
    heal[2] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]
  end

  if (isItem(assign, "Stinger Pack")) then
    DNABossIcon = DNAGlobal.dir .. "images/boss_wasps"
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, 4 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Princess Huhuran")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Princess Huhuran"
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3]
    text[2] = tank.all[2]
    heal[2] = healer.all[4] .. "," .. healer.all[5] .. "," .. healer.all[6]
  end

  if (isItem(assign, "Twin Emperors")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Twin Emperors"
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
      mark[1] = "Interface/EncounterJournal/UI-EJ-BOSS-Twin Emperors"
      text[1] = tank.all[1]
      heal[1] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3] .. "," .. healer.all[4]
      mark[2] = "Interface/EncounterJournal/UI-EJ-BOSS-Twin Emperors"
      text[2] = warlock_tank[1]
      heal[2] = healer.all[1] .. "," .. healer.all[2] .. "," .. healer.all[3] .. "," .. healer.all[4]
    end

    if (warlock_tank[2]) then
      mark[4] = "Interface/EncounterJournal/UI-EJ-BOSS-Twin Emperors"
      text[4] = tank.all[2]
      heal[4] = healer.all[5] .. "," .. healer.all[6] .. "," .. healer.all[7] .. "," .. healer.all[8]
      mark[5] = "Interface/EncounterJournal/UI-EJ-BOSS-Twin Emperors"
      text[5] = warlock_tank[2]
      heal[5] = healer.all[5] .. "," .. healer.all[6] .. "," .. healer.all[7] .. "," .. healer.all[8]
    end

    if (remaining_tank[1]) then
      mark[7] = "Interface/EncounterJournal/UI-EJ-BOSS-Silithid Royalty"
      text[7] = "Bugs"
      heal[7] = remaining_tank[1]
    end
    if (remaining_tank[2]) then
      mark[8] = "Interface/EncounterJournal/UI-EJ-BOSS-Silithid Royalty"
      text[8] = "Bugs"
      heal[8] = remaining_tank[2]
    end
  end

  if (isItem(assign, "Champion Pack")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Harbinger Skyriss"
    DNABossMap = DNAGlobal.dir .. "images/aq40"
    for i=1, 5 do
      if (tank.main[i]) then
        mark[i] = DNARaidMarkers[i+1][2]
        text[i] = tank.all[i]
        heal[i] = healer.all[i]
      end

      text[7] = "-- BACKUP --"
      if (raid.warrior[i]) then
        mark[i+8] = DNARaidMarkers[i+1][2]
        text[i+8] = raid.warrior[i]
        --heal[i+8] = healer.all[i]
      end
    end
  end

  if (isItem(assign, "C'Thun")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-CThun"
    DNABossMap = DNAGlobal.dir .. "images/aq40_cthun_groups"
    for i=1, table.getn(raid.range) do
      text[i] = "Eye Tentacle"
      heal[i] = raid.range[i]
    end
  end
end
