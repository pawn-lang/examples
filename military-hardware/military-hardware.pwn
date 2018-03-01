/*
   ============================================

   Military Hardware.  A team based progressive
           assault script for SA:MP 0.1

           By Alex "Y_Less" Cole (2006)

    Code parts based on "Da Nang Thang" by Cam
                and "CNG" by Kyeman

   ============================================

================================================================================

                                IMPORTANT!
                               ------------

                                READ FIRST!
                               ------------

This script supports a settings file system.  To use, create a file
in samp/scriptfiles called "milhdset.txt".  There are 3 settings you can set
in there, round time, capture time and military start point (from 0 - 3)

Example settings file:

captime = 10
rndtime = 1200
strtpnt = 0

captime and rndtime are in seconds.

================================================================================

Story:

A group of militant fighters have stolen a piece of military
technology and hidden it high up on a mountain.  Unfortunately
they have AA defences in place so parachuting on is impossible,
so the only way to get there is fighting up from the base.

A SWAT team have been sent in via the beach to retake the kit.

SWAT objectives:

1) Capture the resupply and tech center in a sawmill.
2) Gain a foothold at the base of the mountain.
3) Capture the log cabin being used as a staging post.
3) Get to the top of the mountain to retake the kit.

Millitant objectives:

1) Stop the SWAT capturing the technology and other checkpoints.

*/

#include <a_samp>
#include <core>
#include <float>
#include <file>

static gTeam[MAX_PLAYERS];
new gPlayerClass[MAX_PLAYERS];

#define TEAM_SWAT 1
#define TEAM_MILL 2
#define TEAM_SWAT_COLOR 0x33AA33AA
#define TEAM_MILL_COLOR 0x3333AAAA
#define OBJECTIVE_COLOR 0xAA3333FF
#define CHECK_CAP_LOOPS 10 // Time to capture in SECONDS
//#define GAME_LENGTH 1200 // Seconds (900 = 15 mins)

new gPrefs[3] = {1200, 10, 0}; // Round time, Capture seconds, Start point// gRoundTime
//new gPrefs[1] = 10; // gCapLoops
//new gPrefs[2] = 0; // gAssaultPos
new gPlayerCheck = -1;
new gTimer, gGameTimer; //, gGameStart;
new gMinsGone = 0;
new gTimerLoops = 0;
new gObjectiveReached = 0;
//new File:hFile;// = fopen("coords.txt", io_readwrite);


// Define all the spawn and check points

new Float:gTargets[4][3] =
{
	{-2046.0, -2391.0, 30.0},
	{-2394.0, -2205.0, 33.0},
	{-2816.0, -1521.0, 140.0},
	{-2318.0, -1627.0, 483.0}
};

new Float:gAllSpawnPoints[5][10][4] =
{
	{
		{-2789.0, -2324.0, 5.0, -88.0},
		{-2777.0, -2500.0, 4.0, -67.0},
		{-2727.0, -2717.0, 2.0, -21.0},
		{-2551.0, -2803.0, 4.0, 12.0},
		{-2356.0, -2846.0, 1.0, 3.0},
		{-2291.0, -2843.0, 2.0, -74.0},
		{-2081.0, -2840.0, 3.0, 0.0},
		{-1800.0, -2726.0, 2.0, -243.0},
		{-1898.0, -2780.0, 5.0, -265.0},
		{-2640.0, -2187.0, 3.0, -208.0}
	},
	{
		{-1994.0, -2381.0, 31.0, -29.0},
		{-2100.0, -2516.0, 31.0, 50.0},
		{-2189.0, -2510.0, 32.0, -33.0},
		{-2301.0, -2360.0, 36.0, 79.0},
		{-2193.0, -2256.0, 31.0, -213.0},
		{-2088.0, -2344.0, 31.0, -220.0},
		{-2144.0, -2444.0, 31.0, -216.0},
		{-2108.0, -2401.0, 32.0, -130.0},
		{-2100.0, -2230.0, 31.0, -206.0},
		{-2232.0, -2556.0, 32.0, 56.0}
	},
	{
		{-2094.0, -1874.0, 111.0, -217.0},
		{-2445.0, -2134.0, 60.0, -142.0},
		{-2490.0, -2275.0, 30.0, -55.0},
		{-2330.0, -2209.0, 33.0, -120.0},
		{-2193.0, -2125.0, 51.0, -181.0},
		{-2412.0, -2171.0, 33.0, -96.0},
		{-2402.0, -2268.0, 16.0, -68.0},
		{-2282.0, -2162.0, 37.0, -135.0},
		{-2417.0, -2229.0, 34.0, -68.0},
		{-2352.0, -2153.0, 48.0, -149.0}
	},
	{
		{-2730.0, -1851.0, 149.0, -151.0},
		{-2877.0, -1520.0, 138.0, -101.0},
		{-2771.0, -1253.0, 125.0, -196.0},
		{-2675.0, -1363.0, 251.0, -243.0},
		{-2773.0, -1906.0, 118.0, -117.0},
		{-2820.0, -1452.0, 136.0, -176.0},
		{-2681.0, -1231.0, 161.0, -216.0},
		{-2698.0, -1725.0, 254.0, -203.0},
		{-2770.0, -1636.0, 142.0, -183.0},
		{-2720.0, -1888.0, 136.0, -170.0}
	},
	{
		{-2230.0, -1743.0, 481.0, 38.0},
		{-2647.0, -1465.0, 312.0, 62.0},
		{-2517.0, -1818.0, 380.0, 41.0},
		{-2560.0, -1478.0, 361.0, -159.0},
		{-2281.0, -1545.0, 433.0, -31.0},
		{-2407.0, -1695.0, 456.0, 80.0},
		{-2360.0, -1851.0, 418.0, -36.0},
		{-2432.0, -1620.0, 527.0, -196.0},
		{-2279.0, -1507.0, 407.0, 47.0},
		{-2401.0, -1859.0, 408.0, 12.0}
	}
};

main()
{
	print("\n ============================================\n");//\n");
	print(" Military Hardware.  A team based progressive\n");
	print("         assault script for SA:MP 0.1\n");//\n");
	print("         By Alex \"Y_Less\" Cole (2006)\n");//\n");
	//print("  Code parts based on \"Da Nang Thang\" by Cam\n");
	//print("              and \"CNG\" by Kyeman\n\n");
	print(" ============================================\n");
}

public OnGameModeInit()
{
	//print("GameModeInit()");
	SetGameModeText("Military Hardware");

	// Swat classes (team 0)
	AddPlayerClass(285, -2371.5, -1918.0, 0.0, 0.0, 4, 0, 23, 50, 28, 200);
	AddPlayerClass(285, -2371.5, -1918.0, 0.0, 0.0, 4, 0, 23, 50, 29, 200);
	AddPlayerClass(285, -2371.5, -1918.0, 0.0, 0.0, 3, 0, 22, 30, 34, 20);
	AddPlayerClass(285, -2371.5, -1918.0, 0.0, 0.0, 3, 0, 22, 50, 27, 25);
	AddPlayerClass(285, -2371.5, -1918.0, 0.0, 0.0, 3, 0, 39, 5, 31, 70);

	// Militant classes (team 1)
	AddPlayerClass(157, -2371.5, -1918.0, 0.0, 0.0, 6, 0, 22, 50, 28, 200);
	AddPlayerClass(161, -2371.5, -1918.0, 0.0, 0.0, 7, 0, 22, 50, 29, 200);
	AddPlayerClass(198, -2371.5, -1918.0, 0.0, 0.0, 5, 0, 22, 30, 33, 20);
	AddPlayerClass(201, -2371.5, -1918.0, 0.0, 0.0, 2, 0, 24, 20, 25, 25);
	AddPlayerClass(202, -2371.5, -1918.0, 0.0, 0.0, 42, 0, 39, 5, 30, 70);

	// Hydra
	AddStaticVehicle(520, -2318.0, -1627.0, 483.0, 0.0, -1, -1);

	// Vehicles
	AddStaticVehicle(539, -2355.0, -2850.0, 1.0, 3.0, -1, -1);
	AddStaticVehicle(422, -1926.0, -2738.0, 14.0, -240.0, -1, -1);
	AddStaticVehicle(483, -2544.0, -2173.0, 30.0, -6.0, -1, -1);
	AddStaticVehicle(468, -2414.0, -2194.0, 33.0, -97.0, -1, -1);
	AddStaticVehicle(525, -2219.0, -2147.0, 44.0, -235.0, -1, -1);
	AddStaticVehicle(499, -2113.0, -2241.0, 30.0, -44.0, -1, -1);
	AddStaticVehicle(507, -2089.0, -2241.0, 31.0, -226.0, -1, -1);
	AddStaticVehicle(515, -1968.0, -2434.0, 30.0, -222.0, -1, -1);
	AddStaticVehicle(500, -2096.0, -2542.0, 30.0, -47.0, 0, 0); // Black Mesa (Half Life :p)
	AddStaticVehicle(466, -2125.0, -2503.0, 30.0, -126.0, -1, -1);
	AddStaticVehicle(458, -2234.0, -2571.0, 31.0, 67.0, -1, -1);
	AddStaticVehicle(522, -2208.0, -2508.0, 30.0, -40.0, -1, -1);
	AddStaticVehicle(517, -2151.7, -2441.0, 30.0, -216.0, -1, -1);
	AddStaticVehicle(481, -2550.0, -2674.0, 8.0, 48.0, -1, -1);
	AddStaticVehicle(588, -2222.0, -2767.0, 36.0, -260.0, -1, -1);
	AddStaticVehicle(573, -1735.0, -1916.0, 98.0, 89.0, -1, -1);
	AddStaticVehicle(470, -1912.0, -1671.0, 23.0, -90.0, -1, -1);
	AddStaticVehicle(486, -1852.0, -1614.0, 21.0, -209.0, -1, -1);
	AddStaticVehicle(478, -2206.0, -2254.0, 30.0, -129.0, -1, -1);
	AddStaticVehicle(510, -2381.0, -2204.0, 33.0, -24.0, -1, -1);
	AddStaticVehicle(510, -2383.0, -2211.0, 33.0, -32.0, -1, -1);
	AddStaticVehicle(495, -1996.0, -1560.0, 85.0, -188.0, -1, -1);
	AddStaticVehicle(468, -2215.0, -1918.0, 237.0, -85.0, -1, -1);
	AddStaticVehicle(471, -2686.0, -1726.0, 253.0, 26.0, -1, -1);
	AddStaticVehicle(422, -2816.0, -1536.0, 139.0, -85.0, -1, -1);
	AddStaticVehicle(426, -2784.0, -1525.0, 139.0, -177.0, -1, -1);
	AddStaticVehicle(404, -2522.0, -1125.0, 178.0, -208.0, -1, -1);
	AddStaticVehicle(471, -2330.0, -1091.0, 94.0, 217.0, -1, -1);
	AddStaticVehicle(468, -2667.0, -1548.0, 305.0, 45.0, -1, -1);
	AddStaticVehicle(510, -2528.0, -1704.0, 401.0, -161.0, -1, -1);
	AddStaticVehicle(489, -2353.0, -1468.0, 391.0, -268.0, -1, -1);
	AddStaticVehicle(587, -2345.0, -1823.0, 433.0, -89.0, -1, -1);
	AddStaticVehicle(580, -2252.0, -1712.0, 480.0, 40.0, -1, -1);
	AddStaticVehicle(413, -2334.0, -1579.0, 483.0, -128.0, -1, -1);
	AddStaticVehicle(531, -2849.0, -1548.0, 139.0, -54.0, -1, -1);
	AddStaticVehicle(414, -2615.0, -2156.0, 68.0, 69.0, -1, -1);

	/*if (fexist("coords.txt"))
	{
		fremove("coords.txt");
	}*/
	//hFile = fopen("coords.txt", io_readwrite);

	//gGameTimer = SetTimer("TimeUp", gPrefs[0], 0);
	//gGameStart = GetTickCount();
	ReadPrefs();
	new mintime;
	if (gPrefs[0] > 300)
	{
		mintime = (gPrefs[0] - ((gPrefs[0] / 300) * 300)) * 1000;
	}
	else // Assume they have a round longer than 1 min.
	{
		mintime = (gPrefs[0] - ((gPrefs[0] / 60) * 60)) * 1000;
	}
	if (mintime == 0)
	{
		mintime = 60000; // If they have an exact time, set it to the 1 min default.
	}
	gGameTimer = SetTimer("TimeGone", mintime, 0); // Start checking
	//TimeGone();
	return 1;
}

public ReadPrefs()
{
	new prefnm[3][8] =
	{
		"rndtime",
		"captime",
		"strtpnt"
		//"svtm"
	};
	new tmpval;
	for (new i = 0; i < 3; i++)
	{
		tmpval = GetStatsValue(prefnm[i], "milhdset.txt");
		//tmpval = strval("1");
		if (tmpval != -1)
		{
			gPrefs[i] = tmpval;
		}
		//printf("gPrefs[%d] = %d", i, gPrefs[i]);
		//new tmpstr[256];
		//format(tmpstr, 256, "%s = %d", prefnm[i], gPrefs[i]);
	}
	if (gPrefs[2] > 3)
	{
		gPrefs[2] = 0;
		//print("gPrefs[2] now = 0");
	}
}

public GetStatsValue(const paramname[], const statname[])
{
	if (fexist(statname))
	{
		new File:file = fopen(statname, io_read);
		new tmpbuf[256];
		new splitbuf[4][256];
		while (fread(file, tmpbuf, sizeof (tmpbuf)))
		{
	   		split(tmpbuf, splitbuf, ' ');
			if (!strcmp(paramname, splitbuf[0]))
			{
				fclose(file);
				if (splitbuf[1][0] == '=')
				{
					if (splitbuf[2][0])
					{
						return strval(splitbuf[2]);
					}
					else
					{
						return -1;
					}
				}
				else
				{
					if (splitbuf[1][0])
					{
						return strval(splitbuf[1]);
					}
					else
					{
						return -1;
					}
				}
	 		}
		}
		fclose(file);
	}
	return -1;
}

public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while (i <= strlen(strsrc))
	{
		if ((strsrc[i] == delimiter) || (i == strlen(strsrc)))
		{
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i + 1;
			aNum++;
		}
		i++;
	}
	return 1;
}

public TimeGone()
{
	//KillTimer(gGameTimer);
	if (gObjectiveReached == 0)
	{
		//new timestr2[256];
		//format(timestr2, 256, "gPrefs[0]: %d", gPrefs[0]);
	   	//SendClientMessageToAll(TEAM_SWAT_COLOR, timestr2);
		new timestr[256];
		if (gPrefs[0] > 300)
		{
			gPrefs[0] -= 60;
			gMinsGone++;
			if (gMinsGone == 5)
			{
				format(timestr, 256, "~w~%d minutes remaining.", (gPrefs[0] / 60));
				GameTextForAll(timestr, 5000, 3);
				gMinsGone = 0;
			}
			gGameTimer = SetTimer("TimeGone", 60000, 0);
		}
		else if (gPrefs[0] > 120)
		{
			gPrefs[0] -= 60;
			format(timestr, 256, "~w~%d minutes remaining.", (gPrefs[0] / 60));
			GameTextForAll(timestr, 5000, 3);
			gGameTimer = SetTimer("TimeGone", 60000, 0);
		}
		else if (gPrefs[0] == 120)
		{
			gPrefs[0] -= 60;
			GameTextForAll("~w~1 minute remaining.", 5000, 3);
			gGameTimer = SetTimer("TimeGone", 10000, 0);
		}
		else if (gPrefs[0] > 20)
		{
			gPrefs[0] -= 10;
			gGameTimer = SetTimer("TimeGone", 10000, 0);
		}
		else if (gPrefs[0] == 20)
		{
			gPrefs[0] -= 10;
			GameTextForAll("~w~10", 1200, 3);
			gGameTimer = SetTimer("TimeGone", 1000, 0);
		}
		else if (gPrefs[0] > 1)
		{
			gPrefs[0] -= 1;
			format(timestr, 256, "~w~%d", gPrefs[0]);
			GameTextForAll(timestr, 1200, 3);
			gGameTimer = SetTimer("TimeGone", 1000, 0);
		}
		else
		{
			TimeUp();
		}
	}
}

public TimeUp()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (gTeam[i] == TEAM_SWAT)
		{
			GameTextForPlayer(i, "~g~You failed to retrieve the Equipment, you have lost.", 5000, 3);
		}
		else if (gTeam[i] == TEAM_MILL)
		{
			GameTextForPlayer(i, "~b~You successfully defended the plane, you have won.", 5000, 3);
		}
	}
	SetTimer("ExitTheGameMode", 5000, 0);
	ResetTimer();
	KillCheck();
}

public SetPlayerTeamFromClass(playerid, classid)
{
	// Set their team number based on the class they selected.
	//if (gTeam[playerid] == 0)
	//{
	if (classid < 5)
	{
		gTeam[playerid] = TEAM_SWAT;
	}
	else
	{
		gTeam[playerid] = TEAM_MILL;
	}
	/*}
	else
	// Keep the teams (don't know if this will work).
	{
		if ((classid == 0) && (gTeam[playerid] != TEAM_SWAT))
		{
			classid = 1;
		}
		else if ((classid == 1) && (gTeam[playerid] != TEAM_MILL))
		{
			classid = 0;
		}
	}*/
}

public SetPlayerToTeamColor(playerid)
{
	if (gTeam[playerid] == TEAM_SWAT)
	{
		SetPlayerColor(playerid, TEAM_SWAT_COLOR);
	}
	else if (gTeam[playerid] == TEAM_MILL)
	{
		SetPlayerColor(playerid, TEAM_MILL_COLOR);
	}
	//printf(" SetPlayerToTeamColor(%d, %d)", playerid, GetPlayerColor(playerid));
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerTeamFromClass(playerid, classid);
	SetupPlayerForClassSelection(playerid);
	gPlayerClass[playerid] = classid;
   	if (classid < 5)
	{
		GameTextForPlayer(playerid, "~w~Military Hardware~n~~g~Attack", 500000, 6);
	}
	else
	{
		GameTextForPlayer(playerid, "~w~Military Hardware~n~~b~Defend", 500000, 6);
	}
	return 1;
}

public SetupPlayerForClassSelection(playerid)
{
	SetPlayerInterior(playerid, 6);
	SetPlayerPos(playerid, 2336.0, -1066.0, 1049.0);
	SetPlayerFacingAngle(playerid, 43);
	SetPlayerCameraPos(playerid, 2333.0, -1063.0, 1050.0);
	SetPlayerCameraLookAt(playerid, 2336.0, -1066.0, 1049.0);
}

public ExitTheGameMode()
{
	GameModeExit();
}

public OnGameModeExit()
{
	KillCheck();
	return 1;
}

public KillCheck()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		DisablePlayerCheckpoint(i);
 	}
 	gObjectiveReached = 1;
	KillTimer(gGameTimer);
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
  	if (gObjectiveReached)
	{
		return 1;
	}
	else
	{
		if (newstate > 1)
		{
			if (playerid == gPlayerCheck)
			{
				ResetTimer();
			}
			return 1;
		}
		else if ((gPlayerCheck == -1) && (IsPlayerInCheckpoint(playerid)))
		{
			gPlayerCheck = playerid;
			gTimer = SetTimer("CheckCheckpoint", 1000, gPrefs[1]);
			FormatTimeText(gPrefs[1]);
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	//printf("OnPlayerConnect(%d)", playerid);
	GameTextForPlayer(playerid, "Military Hardware", 2500, 5);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	if (playerid == gPlayerCheck)
	{
		ResetTimer();
	}
	gTeam[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//printf("OnPlayerSpawn(%d)", playerid);
	SetPlayerInterior(playerid,0);
	SetPlayerToTeamColor(playerid);
	SetPlayerRandomSpawn(playerid);
	NewCheckpointText(playerid);
	GivePlayerMoney(playerid, 1000);
	SetPlayerWorldBounds(playerid, -1694.0, -3049.0, -887.0, -2949.0);
	SetVehicleParamsForPlayer(1, playerid, 0, 1);
	DisablePlayerCheckpoint(playerid);
	if (gTeam[playerid] == TEAM_SWAT)
	{
		SetPlayerCheckpoint(playerid, gTargets[gPrefs[2]][0], gTargets[gPrefs[2]][1], gTargets[gPrefs[2]][2], 5.0); // -2394.0, -2205.0, 33.0, 5.0);
	}
	//GetPlayerPos()
	return 1;
}

public ResetTimer()
{
	KillTimer(gTimer);
	gPlayerCheck = -1;
	gTimerLoops = 0;
}

public ChangeCheckpoint()
{
	if (gTimer)
	{
		ResetTimer();
	}
	if (gPrefs[2] < 3)
	{
		gPrefs[2]++;
		SetTimer("CheckpointText", 5000, 0);
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			DisablePlayerCheckpoint(i);
			if (gTeam[i] == TEAM_SWAT)
			{
				//DisablePlayerCheckpoint(i);
				SetPlayerCheckpoint(i, gTargets[gPrefs[2]][0], gTargets[gPrefs[2]][1], gTargets[gPrefs[2]][2], 5.0);
			}
	 	}
 	}
 	else
 	{
		for (new i = 0; i < MAX_PLAYERS; i++)
		{
			DisablePlayerCheckpoint(i);
	 	}
	 	SetTimer("ExitTheGameMode", 5000, 0);
	 	//gObjectiveReached = 1;
	 	KillCheck();
	 	ResetTimer();
 	}
	return 0;
}

public SetPlayerRandomSpawn(playerid)
{
	//printf("SetPlayerRandomSpawn(%d)", playerid);
	new pos = gTeam[playerid] + gPrefs[2] - 1;
	new rand = random(10); // Choose a random number within the array of random spawns
 	SetPlayerPos(playerid, gAllSpawnPoints[pos][rand][0], gAllSpawnPoints[pos][rand][1], gAllSpawnPoints[pos][rand][2]); // Warp the player
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if (playerid == gPlayerCheck)
	{
		ResetTimer();
	}
	new deathstr[256];
	new whodiedname[MAX_PLAYER_NAME+1];
	new whokilledname[MAX_PLAYER_NAME+1];
	new deathreasonstr[256];
	GetPlayerName(playerid, whodiedname, MAX_PLAYER_NAME);
	GetWeaponName(reason, deathreasonstr, 255);
	if (killerid == INVALID_PLAYER_ID)
	{
		if (strlen(deathreasonstr))
		{
			format(deathstr, 256, "%s died (%s)", whodiedname, deathreasonstr);
		}
		else
		{
			format(deathstr, 256, "%s died", whodiedname);
		}
		SendClientMessageToAll(OBJECTIVE_COLOR, deathstr);
	}
	else
	{
		GetPlayerName(killerid, whokilledname, MAX_PLAYER_NAME);
		if (gTeam[killerid] != gTeam[playerid])
		{
			// Valid kill
			if (strlen(deathreasonstr))
			{
				format(deathstr, 256, "%s was killed by %s (%s)", whodiedname, whokilledname, deathreasonstr);
			}
			else
			{
				format(deathstr, 256, "%s was killed by %s", whodiedname, whokilledname);
			}
			SendClientMessageToAll(OBJECTIVE_COLOR, deathstr);
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
	 	}
		else
		{
			// Team kill
			format(deathstr, 256, "%s killed team-mate %s (%s)", whokilledname, whodiedname, deathreasonstr);
			SendClientMessageToAll(OBJECTIVE_COLOR, deathstr);
		}
	}
 	return 1;
}

/*public OnPlayerCommandText(playerid, cmdtext[])
{
	if (IsPlayerAdmin(playerid))
	{
		if (strcmp(cmdtext, "/inctarget", true)==0)
		{
			print("Entered /inctarget");
			ChangeCheckpoint();
			CheckpointText();
			return 1;
		}
	}
		else if (strcmp(cmdtext, "/gc", true)==0)
		{
			print("Entered /gc");
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			new coordsstring[256];
			//new File:hFile = fopen("coords.txt", io_readwrite);
			//new readstr[flength(hFile)];
			//fread(hFile, readstr, flength(hFile), false);
			format(coordsstring, 256, "\nAddStaticVehicle(0, %.1f, %.1f, %.1f, 93.0, -1, -1);\n", x, y, z);
			//fwrite(hFile, coordsstring);
			for (new i = 0; i < 256; i++)
			{
				fputchar(hFile, coordsstring[i], true);
			}
			//fclose(hFile);
			//fwrite(hFile, "hi");
			return 1;
		}
		else if (strcmp(cmdtext, "/kill", true)==0)
		{
			SetPlayerHealth(playerid, 0.0);
		}
	//}
	//else
	//{
		//printf ("Player %d entered: %s.", playerid, cmdtext);
	//}
	return 0;
}*/

public OnPlayerEnterCheckpoint(playerid)
{
  	if (gObjectiveReached)
	{
		return 1;
	}
	if ((gPlayerCheck == -1) && (!IsPlayerInAnyVehicle(playerid)))
	{
		gPlayerCheck = playerid;
	   	gTimer = SetTimer("CheckCheckpoint", 1000, gPrefs[1]);
	   	FormatTimeText(gPrefs[1]);
	}
	return 1;
}

public CheckCheckpoint()
{
	if (IsPlayerInCheckpoint(gPlayerCheck) && !IsPlayerInAnyVehicle(gPlayerCheck))
	{
	
		gTimerLoops++;
		if (gTimerLoops == gPrefs[1])
		{
			CaptureText();
			ChangeCheckpoint();
		}
		else
		{
			new timeremain = gPrefs[1] - gTimerLoops;
			FormatTimeText(timeremain);
		}
	}
	else
	{
		ResetTimer();
	}
}

public CheckpointText()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		NewCheckpointText(i);
	}
}

public NewCheckpointText(n)
{
	if (gTeam[n] == TEAM_SWAT)
	{
		switch (gPrefs[2])
		{
			case 0:
			{
				GameTextForPlayer(n, "~g~Capture the ~r~Logging Works ~g~being used as a headquaters.", 5000, 3);
			}
			case 1:
			{
				GameTextForPlayer(n, "~g~Gain a foothold at the ~r~base of the mountain.", 5000, 3);
			}
			case 2:
			{
				GameTextForPlayer(n, "~g~Capture the ~r~log cabin ~g~being used as a staging post.", 5000, 3);
			}
			case 3:
			{
				GameTextForPlayer(n, "~g~Retake the piece of ~r~Military Hardware.", 5000, 3);
			}
		}
	}
	else if (gTeam[n] == TEAM_MILL)
	{
		switch (gPrefs[2])
		{
			case 0:
			{
				GameTextForPlayer(n, "~b~Defend the Headquaters in the Logging Works.", 5000, 3);
			}
			case 1:
			{
				GameTextForPlayer(n, "~b~Stop the SWAT gaining foothold at the base of the mountain.", 5000, 3);
			}
			case 2:
			{
				GameTextForPlayer(n, "~b~Defend the log cabin staging post.", 5000, 3);
			}
			case 3:
			{
				GameTextForPlayer(n, "~b~Defend the plane at ALL costs.", 5000, 3);
			}
		}
	}
}

public CaptureText()
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i == gPlayerCheck)
		{
			switch (gPrefs[2])
			{
				case 0:
				{
					GameTextForPlayer(i, "~g~You captured the Logging Works HQ.", 5000, 3);
				}
				case 1:
				{
					GameTextForPlayer(i, "~g~You secured the base of the mountain.", 5000, 3);
				}
				case 2:
				{
					GameTextForPlayer(i, "~g~You captured the staging post.", 5000, 3);
				}
				case 3:
				{
					GameTextForPlayer(i, "~g~Congratulations!  You retrieved the plane.~n~You have won.", 5000, 3);
				}
			}
			SetPlayerScore(i, GetPlayerScore(i) + 10);
		}
		else if (gTeam[i] == TEAM_SWAT)
		{
			switch (gPrefs[2])
			{
				case 0:
				{
					GameTextForPlayer(i, "~g~Logging Works captured.", 5000, 3);
				}
				case 1:
				{
					GameTextForPlayer(i, "~g~Foothold established.", 5000, 3);
				}
				case 2:
				{
					GameTextForPlayer(i, "~g~Staging post secured.", 5000, 3);
				}
				case 3:
				{
					GameTextForPlayer(i, "~g~Hydra retrieved.~n~You have won.", 5000, 3);
				}
			}
		}
		else if (gTeam[i] == TEAM_MILL)
		{
			switch (gPrefs[2])
			{
				case 0:
				{
					GameTextForPlayer(i, "~b~Our headquaters have been captured.", 5000, 3);
				}
				case 1:
				{
					GameTextForPlayer(i, "~b~They're coming up the mountain.", 5000, 3);
				}
				case 2:
				{
					GameTextForPlayer(i, "~b~The cabin is lost.", 5000, 3);
				}
				case 3:
				{
					GameTextForPlayer(i, "~b~Hydra retrieved.~n~You have lost.", 5000, 3);
				}
			}
		}
	}
}

public FormatTimeText(n)
{
	new numstring[3][256];
	format(numstring[1], 256, "~g~Protect the capture!~n~Time Remaining: %d", n);
	format(numstring[2], 256, "~b~Stop the capture!~n~Time Remaining: %d", n);
	format(numstring[0], 256, "~g~You are in the capture zone!~n~Time Remaining: %d", n);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (i == gPlayerCheck)
		{
			GameTextForPlayer(i, numstring[0], 1200, 3);
		}
		else if (gTeam[i])
		{
			GameTextForPlayer(i, numstring[gTeam[i]], 1200, 3);
		}
	}
}

public OnPlayerLeaveCheckpoint(playerid)
{
	if (playerid == gPlayerCheck)
	{
		ResetTimer();
	}
	return 1;
}

