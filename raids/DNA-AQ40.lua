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

function DNAInstanceAQ40(assign, total, raid, mark, text, heal, tank, healer)

  if (isItem(assign, "Anubisath Sentinels")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-Setesh"
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
  end

  if (isItem(assign, "C'Thun")) then
    DNABossIcon = "Interface/EncounterJournal/UI-EJ-BOSS-CThun"
    DNABossMap = DNAGlobal.dir .. "images/aq40_cthun_groups"
  end
end
