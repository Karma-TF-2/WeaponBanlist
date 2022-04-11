global function WeaponBanChecker_Init

array<string> banListArray = []
array<string> mods

void function WeaponBanChecker_Init(){
	InitializeBanList()
	InitializeModList()
	thread WeaponBanChecker_Main()
}

void function WeaponBanChecker_Main()
{
	for(;;){
		if(GetConVarFloat("wb_interval") > 0.0)
			wait GetConVarFloat("wb_interval")
		else
			WaitFrame()

		// InitializeBanList() // uncomment if you wanna change allowed weapons live, still buggy but for weapon events 

		try {
			foreach (entity player in GetPlayerArray()) {
				CheckIfNoWeapons(player)
				for(int i = 0; i < player.GetMainWeapons().len(); i++){
					if(i != 0) WeaponChecker(player, player.GetMainWeapons()[i])
					else WeaponChecker(player, player.GetMainWeapons()[i], true)
				}
			}
		} catch(e){printl("[WB] Failed loop")}
	}
}

/*
 *	HELPER FUNCTIONS
 */

void function WeaponChecker(entity player, entity weapon, bool replace = false){
	try{
		if(banListArray.contains(weapon.GetWeaponClassName())){
			player.TakeWeaponNow(weapon.GetWeaponClassName())
			if(replace){
				player.GiveWeapon(GetConVarString("wb_default_weapon"), mods)
				player.SetActiveWeaponByName(GetConVarString("wb_default_weapon"))
			}
		}
	} catch(e){}
}

void function CheckIfNoWeapons(entity player){
	if(player.GetMainWeapons().len() <= 0){
		try{
			player.GiveWeapon(GetConVarString("wb_default_weapon"), mods)
			player.SetActiveWeaponByName(GetConVarString("wb_default_weapon"))
		} catch(e){}
	}
}

void function InitializeBanList(){
	string cvar = GetConVarString("wb_ban_list")

    array<string> dirtyList = split( cvar, "," )
    foreach (string ban in dirtyList)
        banListArray.append(strip(ban))
}

void function InitializeModList(){
	string cvar = GetConVarString("wb_default_mods")

    array<string> dirtyList = split( cvar, "," )
    foreach (string mod in dirtyList)
        mods.append(strip(mod))
}
