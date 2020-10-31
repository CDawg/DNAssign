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

function instanceMC(assign, total, tank_all, healer, markers, mark, tank, text, heal)

  if (isItem(assign, "Trash MC")) then
    NUM_ADDS = 3
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-BaelGar"
    for i=1, NUM_ADDS+1 do
      mark[i] = markers[i+1][2]
      text[i] = tank_all[i]
      heal[i] = healer[i]
    end
  end

  if (isItem(assign, "Lucifron")) then
    num_adds = 2
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Lucifron"
    for i=1, num_adds+1 do
      mark[i] = markers[i][2]
      text[i] = tank_all[i]
      heal[i] = healer[i]
    end
    --assign up to 5 healers to dispel
    for i=1, 5 do
      if (raidClass[healer[i+num_adds+1]] ~= "Druid") then
        mark[i+num_adds+1] = "Interface/Icons/spell_holy_dispelmagic"
        text[i+num_adds+1] = "MC Dispells"
        heal[i+num_adds+1] = healer[i+num_adds+1]
      end
    end
    mark[1] = boss_icon
  end

  if (isItem(assign, "Gehennas")) then
    num_adds = 2
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Gehennas"
    for i=1, num_adds+1 do
      mark[i] = markers[i][2]
      text[i] = tank_all[i]
      heal[i] = healer[i]
    end
    num_healers_dr = table.getn(healer_dr)
    for i=1, num_healers_dr do
      mark[i+num_adds+2] = "Interface/Icons/spell_holy_removecurse"
      text[i+num_adds+2] = "Decurse"
      heal[i+num_adds+2] = healer_dr[i]
    end
    for i=1, total.mages do
      mark[i+num_adds+num_healers_dr+2] = "Interface/Icons/spell_nature_removecurse"
      text[i+num_adds+num_healers_dr+2] = "Decurse"
      heal[i+num_adds+num_healers_dr+2] = mage[i]
    end
    mark[1] = boss_icon
  end

  if (isItem(assign, "Dogpack")) then
    num_adds = 5
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Son of the Beast"
    for i=1, num_adds do
      mark[i] = markers[i+1][2]
      text[i] = tank_all[i]
    end
  end

  if (isItem(assign, "Magmadar")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Magmadar"
    mark[1] = boss_icon
    text[1] = tank_all[1]
    heal[1] = healer[1]
    --fear warders
    for i=1, healSlots do
      if ((raidClass[healer[i]] == "Priest") and (raidRace[healer[i]] == "Dwarf")) then
        fear_ward[i] = healer[i]
      end
    end
    for k,v in pairs(fear_ward) do
      text[3] = "Fear Ward: "
      heal[3] = v
    end
  end

  if (isItem(assign, "Garr")) then
    num_adds = 8
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Lord Roccor"
    for i=1, num_adds do
      mark[i] = markers[i][2]
      text[i] = tank_banish[i]
      if (raidClass[tank_banish[i]] ~= "Warlock") then
        heal[i] = healer[i] --we dont need healers for banishers
      end
    end
    mark[1] = boss_icon
  end

  if (isItem(assign, "Lava Pack")) then
    num_adds = 3 --minimum, last for a banisher
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Garr"
    for i=1, num_adds do
      mark[i] = markers[i+1][2]
      text[i] = tank_banish[i]
      heal[i] = healer[i]
    end
    if (warlock[1]) then
      mark[4] = markers[5][2]
      text[4] = warlock[1]
    else
      text[4] = tank_all[4]
    end

    text[6] = "-- Backup --"

    if (warlock[2]) then
      mark[7] = markers[6][2]
      text[7] = warlock[2]
    else
      text[7] = tank_all[5]
    end
  end

  if (isItem(assign, "Sulfuron")) then
    num_adds = 5
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Sulfuron Harbinger"
    for i=1, num_adds do
      mark[i] = markers[i][2]
      text[i] = tank_all[i]
      heal[i] = healer[i]
    end
    text[7] = "-- Rogue Kicks / Warrior Pummels -- " --add a space
    if (rogue[1]) then
      mark[8] = markers[2][2]
      text[8] = rogue[1]
    else
      if (warrior[5]) then
        mark[8] = markers[2][2]
        text[8] = warrior[5]
      end
    end
    if (rogue[2]) then
      mark[9] = markers[3][2]
      text[9] = rogue[2]
    else
      if (warrior[6]) then
        mark[8] = markers[2][2]
        text[8] = warrior[6]
      end
    end
    if (rogue[3]) then
      mark[10] = markers[4][2]
      text[10] = rogue[3]
    else
      if (warrior[7]) then
        mark[8] = markers[2][2]
        text[8] = warrior[7]
      end
    end
    if (rogue[4]) then
      mark[11] = markers[5][2]
      text[11] = rogue[4]
    else
      if (warrior[8]) then
        mark[8] = markers[2][2]
        text[8] = warrior[8]
      end
    end

    mark[1] = boss_icon
  end

  if (isItem(assign, "Golemagg")) then
    num_adds = 2
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Golemagg the Incinerator"
    for i=1, num_adds+1 do
      mark[i] = markers[i+1][2]
      text[i] = tank_all[i]
      heal[i] = healer[i] .. "," .. healer[i+num_adds+1]
    end
  end

  if (isItem(assign, "Majordomo Executus")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Majordomo Executus"
    mark[1] = boss_icon
    text[1] = tank_all[1]
    heal[1] = healer[1]
    mark[2] = icon_skull
    text[2] = tank_all[2]
    heal[2] = healer[2]
    mark[3] = icon_cross
    text[3] = tank_all[3]
    heal[3] = healer[3]
    mark[4] = icon_triangle
    text[4] = tank_all[4]
    heal[4] = healer[4]
    mark[5] = icon_circle
    text[5] = tank_all[5]
    heal[5] = healer[5]
    mark[6] = icon_square
    if (mage[1]) then
      text[6] = mage[1]
    else
      text[6] = tank_all[6]
      heal[6] = healer[6]
    end
    mark[7] = icon_diamond
    if (mage[2]) then
      text[7] = mage[2]
    else
      text[7] = tank_all[7]
      heal[7] = healer[7]
    end
    mark[8] = icon_moon
    if (mage[3]) then
      text[8] = mage[3]
    else
      text[8] = tank_all[8]
      heal[8] = healer[8]
    end
    mark[9] = icon_star
    if (mage[4]) then
      text[9] = mage[4]
    else
      text[9] = tank_all[9]
      heal[9] = healer[9]
    end
    if (hunter[1]) then
      mark[11] = boss_icon
      text[11] = "Distracting"
      heal[11] = hunter[1]
    end
  end

  if (isItem(assign, "Ragnaros")) then
    boss_icon = "Interface/EncounterJournal/UI-EJ-BOSS-Ragnaros"
    mark[1] = boss_icon
    text[1] = tank[1]
    heal[1] = healer_pa[1] .. "," .. healer_pa[2] .. "," .. healer_pr[1]
    if (tank[2]) then
      mark[2] = boss_icon
      text[2] = tank[2]
      heal[2] = healer_pa[1] .. "," .. healer_pa[2] .. "," .. healer_pr[1]
    end
    if (tank[3]) then --is there a third tank
      mark[3] = boss_icon
      text[3] = tank[3]
      heal[3] = healer_pa[1] .. "," .. healer_pa[2] .. "," .. healer_pr[1]
    end
    text[5] = "Melee Heals"
    heal[5] = healer[4] .. "," .. healer[5]
  end
end
