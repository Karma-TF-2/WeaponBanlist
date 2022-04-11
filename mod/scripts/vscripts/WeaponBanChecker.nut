global function WeaponBanChecker_Init

array<string> banListArray = []

void function WeaponBanChecker_Init(){
	InitializeBanList()
	thread WeaponBanChecker_Main()
}

void function WeaponBanChecker_Main()
{
	for(;;){
		if(GetConVarFloat("wb_interval") > 0.0)
			wait GetConVarFloat("wb_interval")
		else
			WaitFrame()

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
				player.GiveWeapon(GetConVarString("wb_default_weapon"))
				player.SetActiveWeaponByName(GetConVarString("wb_default_weapon"))
			}
		}
	} catch(e){}
}

void function CheckIfNoWeapons(entity player){
	if(player.GetMainWeapons().len() <= 0){
		try{
			player.GiveWeapon(GetConVarString("wb_default_weapon"))
			player.SetActiveWeaponByName(GetConVarString("wb_default_weapon"))
		} catch(e){}
	}
}

void function ChangeWeapon(entity player, string takingWeapon){
	try {
		player.TakeWeaponNow(player.GetMainWeapons()[0].GetWeaponClassName())
		player.GiveWeapon(GetConVarString("wb_default_weapon"))
		player.SetActiveWeaponByName(GetConVarString("wb_default_weapon"))
	} catch(e){printl("[WB] Failed giving weapons")}

}

void function InitializeBanList(){
	string cvar = GetConVarString( "wb_ban_list" )

    array<string> dirtyList = split( cvar, "," )
    foreach (string ban in dirtyList)
        banListArray.append(strip(ban))
}
