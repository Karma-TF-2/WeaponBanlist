global function WeaponBanChecker_Init

array<string> banListArray = []

void function WeaponBanChecker_Init(){
	InitializeBanList()
	thread WeaponBanChecker()
}

void function WeaponBanChecker()
{
	for(;;){
		if(GetConVarFloat("wb_interval") > 0.0)
			wait GetConVarFloat("wb_interval")
		else
			WaitFrame()

		foreach (entity player in GetPlayerArray()){	
			if(player.GetMainWeapons().len() > 0){
				if(banListArray.find(player.GetMainWeapons()[0].GetWeaponClassName())!=-1){
					ChangeWeapon(player,player.GetMainWeapons()[0].GetWeaponClassName())
				}
			}
		}
	}
}

/*
 *	HELPER FUNCTIONS
 */

void function InitializeBanList(){
	string cvar = GetConVarString( "wb_ban_list" )

    array<string> dirtyList = split( cvar, "," )
    foreach (string ban in dirtyList)
        banListArray.append(strip(ban))
}

void function ChangeWeapon( entity player, string takingWeapon){
	string defaultWeapon = GetConVarString("wb_default_weapon")
	player.TakeWeaponNow( takingWeapon )

	try {
		player.GiveWeapon( defaultWeapon )
		player.SetActiveWeaponByName( defaultWeapon )
		string playername = player.GetPlayerName();
	} catch(e){}

}

