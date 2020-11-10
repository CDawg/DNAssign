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
  "MC", --key
  "_Trash MC_",
  "Lucifron",
  "_Dogpack_",
  "Magmadar",
  "Gehennas",
  "Garr",
  "_Lava Pack_",
  "Sulfuron",
  "Golemagg",
  "Majordomo Executus",
  "Ragnaros"
}
local instanceDetails = {
  "MC", --key
  "Molten Core",
  "Interface/GLUES/LoadingScreens/LoadScreenMoltenCore",
  "Interface/EncounterJournal/UI-EJ-BOSS-Ragnaros",
  "Interface/EncounterJournal/UI-EJ-LOREBG-MoltenCore",
}

table.insert(DNARaidBossesNew, bossList)
table.insert(DNARaidBosses, bossList)
table.insert(DNAInstance, instanceDetails)

function DNAInstanceMC(assign, total, raid, mark, text, heal, tank, healer)
  local fearward={}

  if (isItem(assign, "Trash MC")) then
    NUM_ADDS = 3
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-BaelGar"
    DNABossMap = DNAGlobal.dir .. "images/mc"
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
  end

  if (isItem(assign, "Lucifron")) then
    NUM_ADDS = 2
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Lucifron"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.paladin[i] .. "," .. healer.priest[i]
    end

    for i=1, 3 do --assign 3 priests
      mark[i+NUM_ADDS*2] = "Interface/Icons/spell_holy_dispelmagic"
      text[i+NUM_ADDS*2] = "MC Dispells"
      heal[i+NUM_ADDS*2] = healer.priest[i]
    end
    mark[1] = DNABossIcon
  end

  if (isItem(assign, "Dogpack")) then
    NUM_ADDS = 5
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Son of the Beast"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
    end
  end

  if (isItem(assign, "Magmadar")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Magmadar"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    mark[1] = DNABossIcon
    text[1] = tank.all[1]
    heal[1] = healer.all[1] .. "," .. healer.all[2]
    --fear warders
    for i=1, DNASlots.heal do
      if ((DNARaid["class"][healer.all[i]] == "Priest") and (DNARaid["race"][healer.all[i]] == "Dwarf")) then
        fearward[i] = healer.all[i]
      end
    end

    local i = 0
    for k,v in pairs(fearward) do
      i = i + 1
      mark[i+1] = "Interface/Icons/spell_holy_excorcism"
      text[i+1] = "Fear Ward"
      heal[i+1] = v
    end

    for i=1, table.getn(raid.hunter) do
      mark[i+4] = "Interface/Icons/spell_nature_drowsy"
      text[i+4] = "Tranq Shot"
      heal[i+4] = raid.hunter[i]
    end

  end

  if (isItem(assign, "Gehennas")) then
    NUM_ADDS = 2
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Gehennas"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.paladin[i] .. "," .. healer.priest[i]
    end

    text[5] = "Raid: Mages & Druids decurse!"

    for i=1, NUM_ADDS+1 do
      --mark[i] = DNARaidMarkers[i][2]
      text[i+5] = tank.all[i]
      if (raid.mage[i]) then
        heal[i+5] = raid.mage[i]
      else
        if (healer.druid[i]) then
          heal[i+5] = healer.druid[i]
        end
      end
    end

    --[==[
    num_healers_dr = table.getn(healer.druid)
    for i=1, num_healers_dr do
      mark[i+NUM_ADDS+2] = "Interface/Icons/spell_holy_removecurse"
      text[i+NUM_ADDS+2] = "Decurse"
      heal[i+NUM_ADDS+2] = healer.druid[i]
    end
    for i=1, total.mages do
      mark[i+NUM_ADDS+num_healers_dr+2] = "Interface/Icons/spell_nature_removecurse"
      text[i+NUM_ADDS+num_healers_dr+2] = "Decurse"
      heal[i+NUM_ADDS+num_healers_dr+2] = raid.mage[i]
    end
    ]==]--
    mark[1] = DNABossIcon
  end

  if (isItem(assign, "Garr")) then
    NUM_ADDS = 8
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Lord Roccor"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i][2]
      text[i] = tank.banish[i]
      if (DNARaid["class"][tank.banish[i]] ~= "Warlock") then
        heal[i] = healer.all[i] --we dont need healers for banishers
      end
    end
    mark[1] = DNABossIcon
  end

  if (isItem(assign, "Lava Pack")) then
    NUM_ADDS = 3 --minimum, last for a banisher
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Garr"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, NUM_ADDS do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.banish[i]
      heal[i] = healer.all[i]
    end
    if (raid.warlock[1]) then
      mark[4] = DNARaidMarkers[5][2]
      text[4] = raid.warlock[1]
    else
      text[4] = tank.all[4]
    end

    if (raid.warlock[2]) then
      text[6] = "-- Backup --"
      mark[7] = DNARaidMarkers[5][2]
      text[7] = raid.warlock[2]
    else
      text[7] = tank.all[5]
    end
  end

  if (isItem(assign, "Sulfuron")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Sulfuron Harbinger"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, 5 do -- 4 adds and the boss
      mark[i] = DNARaidMarkers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end
    text[7] = "-- Rogue Kicks / Warrior Pummels/Bashes -- "
    if (raid.rogue[1]) then
      mark[8] = DNARaidMarkers[2][2]
      text[8] = raid.rogue[1]
      if (raid.warrior[1]) then
        heal[8] = raid.warrior[1]
      end
    end
    if (raid.rogue[2]) then
      mark[9] = DNARaidMarkers[3][2]
      text[9] = raid.rogue[2]
      if (raid.warrior[2]) then
        heal[9] = raid.warrior[2]
      end
    end
    if (raid.rogue[3]) then
      mark[10] = DNARaidMarkers[4][2]
      text[10] = raid.rogue[3]
      if (raid.warrior[3]) then
        heal[10] = raid.warrior[3]
      end
    end
    if (raid.rogue[4]) then
      mark[11] = DNARaidMarkers[5][2]
      text[11] = raid.rogue[4]
      if (raid.warrior[4]) then
        heal[11] = raid.warrior[4]
      end
    end

    --[==[
    text[13] = "-- Warrior Pummels/Bashes -- "
    if (raid.warrior[1]) then
      mark[14] = DNARaidMarkers[2][2]
      text[14] = raid.warrior[1]
    end
    if (raid.warrior[2]) then
      mark[15] = DNARaidMarkers[3][2]
      text[15] = raid.warrior[2]
    end
    if (raid.warrior[3]) then
      mark[16] = DNARaidMarkers[4][2]
      text[16] = raid.warrior[3]
    end
    if (raid.warrior[4]) then
      mark[17] = DNARaidMarkers[5][2]
      text[17] = raid.warrior[4]
    end
    ]==]--

    mark[1] = DNABossIcon
  end

  if (isItem(assign, "Golemagg")) then
    NUM_ADDS = 2
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Golemagg the Incinerator"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, NUM_ADDS+1 do
      mark[i] = DNARaidMarkers[i+1][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i] .. "," .. healer.all[i+NUM_ADDS+1]
    end
  end

  if (isItem(assign, "Majordomo Executus")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Majordomo Executus"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    for i=1, 5 do
      mark[i] = DNARaidMarkers[i][2]
      text[i] = tank.all[i]
      heal[i] = healer.all[i]
    end

    mark[1] = DNABossIcon

    mark[6] = icon_square
    if (raid.mage[1]) then
      text[6] = raid.mage[1]
    else
      text[6] = tank.all[6]
      heal[6] = healer.all[6]
    end
    mark[7] = icon_diamond
    if (raid.mage[2]) then
      text[7] = raid.mage[2]
    else
      text[7] = tank.all[7]
      heal[7] = healer.all[7]
    end
    mark[8] = icon_moon
    if (raid.mage[3]) then
      text[8] = raid.mage[3]
    else
      text[8] = tank.all[8]
      heal[8] = healer.all[8]
    end
    mark[9] = icon_star
    if (raid.mage[4]) then
      text[9] = raid.mage[4]
    else
      text[9] = tank.all[9]
      heal[9] = healer.all[9]
    end
    if (raid.hunter[1]) then
      mark[11] = DNABossIcon
      text[11] = "Distracting"
      heal[11] = raid.hunter[1]
    end
  end

  if (isItem(assign, "Ragnaros")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Ragnaros"
    DNABossMap = DNAGlobal.dir .. "images/mc" --default
    mark[1] = DNABossIcon
    text[1] = tank.main[1]
    heal[1] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    if (tank.main[2]) then
      mark[2] = DNABossIcon
      text[2] = tank.main[2]
      heal[2] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    end
    if (tank.main[3]) then --is there a third tank
      mark[3] = DNABossIcon
      text[3] = tank.main[3]
      heal[3] = healer.paladin[1] .. "," .. healer.paladin[2] .. "," .. healer.priest[1]
    end
    text[5] = "Melee Heals:"
    heal[5] = healer.all[4] .. "," .. healer.all[5]

    text[6] = "Raid Heals:"
    heal[6] = healer.all[6] .. "," .. healer.all[7] .. "," .. healer.all[8]
  end
end
