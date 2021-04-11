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

--for debugging and development purposes
function buildDebugRaid()
  --build a fake raid for testing and demonstration purposes
  DNARaid["member"][1] = "Aellwyn"
  DNARaid["member"][2] = "Porthios"
  DNARaid["member"][3] = "Upya"
  DNARaid["member"][4] = "Zarj"
  DNARaid["member"][5] = "Cryonix"
  DNARaid["member"][6] = "Grayleaf"
  DNARaid["member"][7] = "Droott"
  DNARaid["member"][8] = "Aquilla"
  DNARaid["member"][9] = "Neilsbhor"
  DNARaid["member"][10] = "Frosthunt"
  DNARaid["member"][11] = "Nanodel"
  DNARaid["member"][12] = "Crisis"
  DNARaid["member"][13] = "Whistper"
  DNARaid["member"][14] = "Zarianna"
  DNARaid["member"][15] = "Averglade"
  DNARaid["member"][16] = "Addontesterc"
  DNARaid["member"][17] = "Krizzu"
  DNARaid["member"][18] = "Oogleboogle" --testing a fake character
  DNARaid["member"][19] = "Snibson"
  DNARaid["member"][20] = "Mandert"
  DNARaid["member"][21] = "Bibbi"
  DNARaid["member"][22] = "Lefti"
  DNARaid["member"][23] = "Corr"
  DNARaid["member"][24] = "Valency"
  DNARaid["member"][25] = "Twizzy"
  DNARaid["member"][26] = "Zatos"
  DNARaid["member"][27] = "Destructive"
  DNARaid["member"][28] = "Gaelic"
  DNARaid["member"][29] = "Overthere"
  DNARaid["member"][30] = "Akilina"
  DNARaid["member"][31] = "Mairakus"
  DNARaid["member"][32] = "Sleapy"
  DNARaid["member"][33] = "Stumpymcaxe"
  DNARaid["member"][34] = "Cahonez"
  DNARaid["member"][35] = "Devonwatnuts"
  DNARaid["member"][36] = "Vye"
  DNARaid["member"][37] = "Totemgoat"
  DNARaid["member"][38] = "Kelvarn"
  DNARaid["member"][39] = "Measles"

  DNARaid["class"]["Aellwyn"] = "Warrior"
  DNARaid["class"]["Porthios"] = "Warrior"
  DNARaid["class"]["Upya"] = "Warlock"
  DNARaid["class"]["Zarj"] = "Rogue"
  DNARaid["class"]["Cryonix"] = "Priest"
  DNARaid["class"]["Grayleaf"] = "Warrior"
  DNARaid["class"]["Droott"] = "Druid"
  DNARaid["class"]["Aquilla"] = "Mage"
  DNARaid["class"]["Neilsbhor"] = "Mage"
  DNARaid["class"]["Frosthunt"] = "Hunter"
  DNARaid["class"]["Nanodel"] = "Hunter"
  DNARaid["class"]["Crisis"] = "Warrior"
  DNARaid["class"]["Whistper"] = "Hunter"
  DNARaid["class"]["Zarianna"] = "Paladin"
  DNARaid["class"]["Krizzu"] = "Mage"
  DNARaid["class"]["Elderpen"] = "Warrior"
  DNARaid["class"]["Snibson"] = "Priest"
  DNARaid["class"]["Averglade"] = "Paladin"
  DNARaid["class"]["Mandert"] = "Warrior"
  DNARaid["class"]["Bibbi"] = "Rogue"
  DNARaid["class"]["Lefti"] = "Priest"
  DNARaid["class"]["Corr"] = "Paladin"
  DNARaid["class"]["Valency"] = "Warlock"
  DNARaid["class"]["Twizzy"] = "Paladin"
  DNARaid["class"]["Zatos"] = "Priest"
  DNARaid["class"]["Destructive"] = "Warlock"
  DNARaid["class"]["Gaelic"] = "Paladin"
  DNARaid["class"]["Overthere"] = "Rogue"
  DNARaid["class"]["Akilina"] = "Warrior"
  DNARaid["class"]["Sleapy"] = "Priest"
  DNARaid["class"]["Mairakus"] = "Warrior"
  DNARaid["class"]["Stumpymcaxe"] = "Warrior"
  DNARaid["class"]["Cahonez"] = "Rogue"
  DNARaid["class"]["Devonwatnuts"] = "Warrior"
  DNARaid["class"]["Vye"] = "Rogue"
  DNARaid["class"]["Measles"] = "Warlock"
  DNARaid["class"]["Totemgoat"] = "Shaman"
  DNARaid["class"]["Kelvarn"] = "Priest"
  DNARaid["class"]["Addontesterc"] = "Paladin"

  DNARaid["groupid"]["Aellwyn"] = 1
  DNARaid["groupid"]["Porthios"] = 1
  DNARaid["groupid"]["Zarianna"] = 1
  DNARaid["groupid"]["Upya"] = 1
  DNARaid["groupid"]["Zarj"] = 1
  DNARaid["groupid"]["Cryonix"] = 2
  DNARaid["groupid"]["Grayleaf"] = 2
  DNARaid["groupid"]["Droott"] = 2
  DNARaid["groupid"]["Aquilla"] = 2
  DNARaid["groupid"]["Neilsbhor"] = 2
  DNARaid["groupid"]["Frosthunt"] = 3
  DNARaid["groupid"]["Nanodel"] = 3
  DNARaid["groupid"]["Crisis"] = 3
  DNARaid["groupid"]["Whistper"] = 3
  DNARaid["groupid"]["Krizzu"] = 4
  DNARaid["groupid"]["Alectar"] = 4
  DNARaid["groupid"]["Snibson"] = 4
  DNARaid["groupid"]["Mandert"] = 4
  DNARaid["groupid"]["Bibbi"] = 4
  DNARaid["groupid"]["Lefti"] = 5
  DNARaid["groupid"]["Corr"] = 5
  DNARaid["groupid"]["Valency"] = 5
  DNARaid["groupid"]["Twizzy"] = 5
  DNARaid["groupid"]["Zatos"] = 5
  DNARaid["groupid"]["Destructive"] = 6
  DNARaid["groupid"]["Gaelic"] = 6
  DNARaid["groupid"]["Overthere"] = 6
  DNARaid["groupid"]["Akilina"] = 6
  DNARaid["groupid"]["Sleapy"] = 6
  DNARaid["groupid"]["Mairakus"] = 7
  DNARaid["groupid"]["Stumpymcaxe"] = 7
  DNARaid["groupid"]["Cahonez"] = 7
  DNARaid["groupid"]["Devonwatnuts"] = 7
  DNARaid["groupid"]["Vye"] = 7
  DNARaid["groupid"]["Measles"] = 8
  DNARaid["groupid"]["Totemgoat"] = 8
  DNARaid["groupid"]["Kelvarn"] = 8
  DNARaid["groupid"]["Averglade"] = 8

  DNARaid["race"]["Kelvarn"] = "Dwarf"
  DNARaid["race"]["Lefti"] = "Dwarf"
end
