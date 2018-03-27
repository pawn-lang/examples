
#include <a_samp>

//Plugins
#include <streamer>

//YSI
#include <YSI\y_classes>
#include <YSI\y_groups>
#include <YSI\y_commands>
#include <YSI\y_iterate>
#include <YSI\y_va>

//Other includes

//TEAM COLOURS
#define COLOUR_GREEN 0x77CC77FF
#define COLOUR_BLUE 0x7777DDFF

main()
{
	print("Rivershell New Version");
	
	SetGameModeText("Rivershell New Version");
}

new 
	Group:g_TeamGreen,
	Group:g_TeamBlue
;


public OnGameModeInit()
{
	//Create Groups
	g_TeamGreen = Group_Create("Team Green");
	g_TeamBlue = Group_Create("Team Blue");

	//Green Team Classes
//	Class_AddWithGroupSet(gSet, 0, 0.0, 0.0, 5.0, 0.0);
	Class_AddWithGroupSet(g_TeamGreen, 162,2117.0129,-224.4389,8.15,0.0,31,100,29,200,34,10);
	Class_AddWithGroupSet(g_TeamGreen, 157,2148.6606,-224.3336,8.15,347.1396,31,100,29,200,34,10);
	
	//Blue Team classes
	Class_AddWithGroupSet(g_TeamBlue, 154,2352.9873,580.3051,7.7813,178.1424,31,100,29,200,34,10);
	Class_AddWithGroupSet(g_TeamBlue, 138,2281.1504,567.6248,7.7813,163.7289,31,100,29,200,34,10);

	//Mapping

	// Green Base Section
	CreateMapObject(9090, 2148.64, -222.88, -20.60, 0.00, 0.00, 179.70);

	// Green resupply hut
	CreateMapObject(12991, 2140.83, -235.13, 7.13, 0.00, 0.00, -89.94);

	// Blue Base Section
	CreateMapObject(9090, 2317.09, 572.27, -20.97, 0.00, 0.00, 0.00);
	
	// Blue resupply hut
	CreateMapObject(12991, 2318.73, 590.96, 6.75, 0.00, 0.00, 89.88);

	// General mapping
	CreateMapObject(12991, 2140.83, -235.13, 7.13,   0.00, 0.00, -89.94);
	CreateMapObject(19300, 2137.33, -237.17, 46.61,   0.00, 0.00, 180.00);
	CreateMapObject(12991, 2318.73, 590.96, 6.75,   0.00, 0.00, 89.88);
	CreateMapObject(19300, 2325.41, 587.93, 47.37,   0.00, 0.00, 180.00);
	CreateMapObject(12991, 2140.83, -235.13, 7.13,   0.00, 0.00, -89.94);
	CreateMapObject(12991, 2318.73, 590.96, 6.75,   0.00, 0.00, 89.88);
	CreateMapObject(12991, 2140.83, -235.13, 7.13,   0.00, 0.00, -89.94);
	CreateMapObject(12991, 2318.73, 590.96, 6.75,   0.00, 0.00, 89.88);
	CreateMapObject(18228, 1887.93, -59.78, -2.14,   0.00, 0.00, 20.34);
	CreateMapObject(17031, 1990.19, 541.37, -22.32,   0.00, 0.00, 0.00);
	CreateMapObject(18227, 2000.82, 494.15, -7.53,   11.70, -25.74, 154.38);
	CreateMapObject(17031, 1992.35, 539.80, -2.97,   9.12, 30.66, 0.00);
	CreateMapObject(17031, 1991.88, 483.77, -0.66,   -2.94, -5.22, 12.78);
	CreateMapObject(17029, 2070.57, -235.87, -6.05,   -7.20, 4.08, 114.30);
	CreateMapObject(17029, 2056.50, -228.77, -19.67,   14.16, 19.68, 106.56);
	CreateMapObject(17029, 2074.00, -205.33, -18.60,   16.02, 60.60, 118.86);
	CreateMapObject(17029, 2230.39, -242.59, -11.41,   5.94, 7.56, 471.24);
	CreateMapObject(17029, 2252.53, -213.17, -20.81,   18.90, -6.30, -202.38);
	CreateMapObject(17029, 2233.04, -234.08, -19.00,   21.84, -8.88, -252.06);
	CreateMapObject(17027, 2235.05, -201.49, -11.90,   -11.94, -4.08, 136.32);
	CreateMapObject(17029, 2226.11, -237.07, -2.45,   8.46, 2.10, 471.24);
	CreateMapObject(4368, 2433.79, 446.26, 4.67,   -8.04, -9.30, 61.02);
	CreateMapObject(4368, 2031.23, 489.92, -13.20,   -8.04, -9.30, -108.18);
	CreateMapObject(17031, 2458.36, 551.10, -6.95,   0.00, 0.00, 0.00);
	CreateMapObject(17031, 2465.37, 511.35, -7.70,   0.00, 0.00, 0.00);
	CreateMapObject(17031, 2474.80, 457.71, -5.17,   0.00, 0.00, 172.74);
	CreateMapObject(17031, 2466.03, 426.28, -5.17,   0.00, 0.00, 0.00);
	CreateMapObject(791, 2310.45, -229.38, 7.41,   0.00, 0.00, 0.00);
	CreateMapObject(791, 2294.00, -180.15, 7.41,   0.00, 0.00, 60.90);
	CreateMapObject(791, 2017.50, -305.30, 7.29,   0.00, 0.00, 60.90);
	CreateMapObject(791, 2106.45, -279.86, 20.05,   0.00, 0.00, 60.90);
	CreateMapObject(706, 2159.13, -263.71, 19.22,   356.86, 0.00, -17.18);
	CreateMapObject(706, 2055.75, -291.53, 13.98,   356.86, 0.00, -66.50);
	CreateMapObject(791, 1932.65, -315.88, 6.77,   0.00, 0.00, -35.76);
	CreateMapObject(790, 2429.40, 575.79, 10.42,   0.00, 0.00, 3.14);
	CreateMapObject(790, 2403.40, 581.56, 10.42,   0.00, 0.00, 29.48);
	CreateMapObject(791, 2083.44, 365.48, 13.19,   356.86, 0.00, -1.95);
	CreateMapObject(791, 2040.15, 406.02, 13.33,   356.86, 0.00, -1.95);
	CreateMapObject(791, 1995.36, 588.10, 7.50,   356.86, 0.00, -1.95);
	CreateMapObject(791, 2126.11, 595.15, 5.99,   0.00, 0.00, -35.82);
	CreateMapObject(791, 2188.35, 588.90, 6.04,   0.00, 0.00, 0.00);
	CreateMapObject(791, 2068.56, 595.58, 5.99,   0.00, 0.00, 52.62);
	CreateMapObject(698, 2385.32, 606.16, 9.79,   0.00, 0.00, 34.62);
	CreateMapObject(698, 2309.29, 606.92, 9.79,   0.00, 0.00, -54.54);
	CreateMapObject(790, 2347.14, 619.77, 9.94,   0.00, 0.00, 3.14);
	CreateMapObject(698, 2255.28, 606.94, 9.79,   0.00, 0.00, -92.76);
	CreateMapObject(4298, 2121.37, 544.12, -5.74,   -10.86, 6.66, 3.90);
	CreateMapObject(4368, 2273.18, 475.02, -15.30,   4.80, 8.10, 266.34);
	CreateMapObject(18227, 2232.38, 451.61, -30.71,   -18.54, -6.06, 154.38);
	CreateMapObject(17031, 2228.15, 518.87, -16.51,   13.14, -1.32, -20.10);
	CreateMapObject(17031, 2230.42, 558.52, -18.38,   -2.94, -5.22, 12.78);
	CreateMapObject(17031, 2228.97, 573.62, 5.17,   17.94, -15.60, -4.08);
	CreateMapObject(17029, 2116.67, -87.71, -2.31,   5.94, 7.56, 215.22);
	CreateMapObject(17029, 2078.66, -83.87, -27.30,   13.02, -53.94, -0.30);
	CreateMapObject(17029, 2044.80, -36.91, -9.26,   -13.74, 27.90, 293.76);
	CreateMapObject(17029, 2242.41, 426.16, -15.43,   -21.54, 22.26, 154.80);
	CreateMapObject(17029, 2220.06, 450.07, -34.78,   -1.32, 10.20, -45.84);
	CreateMapObject(17029, 2252.49, 439.08, -19.47,   -41.40, 20.16, 331.86);
	CreateMapObject(17031, 2241.41, 431.93, -5.62,   -2.22, -4.80, 53.64);
	CreateMapObject(17029, 2141.10, -81.30, -2.41,   5.94, 7.56, 39.54);
	CreateMapObject(17031, 2277.07, 399.31, -1.65,   -2.22, -4.80, -121.74);
	CreateMapObject(17026, 2072.75, -224.40, -5.25,   0.00, 0.00, -41.22);

 	// Ramps
	CreateMapObject(1632, 2131.97, 110.24, 0.00,   0.00, 0.00, 153.72);
	CreateMapObject(1632, 2124.59, 113.69, 0.00,   0.00, 0.00, 157.56);
	CreateMapObject(1632, 2116.31, 116.44, 0.00,   0.00, 0.00, 160.08);
	CreateMapObject(1632, 2113.22, 108.48, 0.00,   0.00, 0.00, 340.20);
	CreateMapObject(1632, 2121.21, 105.21, 0.00,   0.00, 0.00, 340.20);
	CreateMapObject(1632, 2127.84, 102.06, 0.00,   0.00, 0.00, 334.68);
	CreateMapObject(1632, 2090.09, 40.90, 0.00,   0.00, 0.00, 348.36);
	CreateMapObject(1632, 2098.73, 39.12, 0.00,   0.00, 0.00, 348.36);
	CreateMapObject(1632, 2107.17, 37.94, 0.00,   0.00, 0.00, 348.36);
	CreateMapObject(1632, 2115.88, 36.47, 0.00,   0.00, 0.00, 348.36);
	CreateMapObject(1632, 2117.46, 45.86, 0.00,   0.00, 0.00, 529.20);
	CreateMapObject(1632, 2108.98, 46.95, 0.00,   0.00, 0.00, 529.20);
	CreateMapObject(1632, 2100.42, 48.11, 0.00,   0.00, 0.00, 526.68);
	CreateMapObject(1632, 2091.63, 50.02, 0.00,   0.00, 0.00, 526.80);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);

	switch(classid)
	{
		case 0, 1:
		{
			GameTextForPlayer(playerid,"~g~GREEN ~w~TEAM",1000,5);
		}
		case 2, 3:
		{
			GameTextForPlayer(playerid,"~b~BLUE ~w~TEAM",1000,5);
		}
	}

	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerTeamColour(playerid);

	return 1;
}

SetupPlayerForClassSelection(playerid)
{
	//Remove From All Groups
	Group_SetPlayer(g_TeamBlue, playerid, false);
	Group_SetPlayer(g_TeamGreen, playerid, false);
	//

	SetPlayerPos(playerid,1984.4445,157.9501,55.9384);
    SetPlayerCameraPos(playerid,1984.4445,160.9501,55.9384);
	SetPlayerCameraLookAt(playerid,1984.4445,157.9501,55.9384);
	SetPlayerFacingAngle(playerid,0.0);
}

SetPlayerTeamColour(playerid)
{
	if(Group_GetPlayer(g_TeamGreen, playerid))
	{
	    SetPlayerColor(playerid, COLOUR_GREEN);
	}
	else if(Group_GetPlayer(g_TeamBlue, playerid))
	{
	    SetPlayerColor(playerid, COLOUR_BLUE);
	}
}

CreateMapObject(modelid, Float:fX, Float:fY, Float:fZ, Float:fRX, Float:fRY, Float:fRZ)
{
	return CreateDynamicObjectEx(modelid, fX, fY, fZ, fRX, fRY, fRZ, .streamdistance = 500.0);
}

YCMD:amigreen(playerid, params[], help)
{
	if(help) SendClientMessage(playerid, -1, "Checks If You Are In Green Team");
	else va_SendClientMessage(playerid, -1, "You are%sin Green Team", (Group_GetPlayer(g_TeamGreen, playerid)) ? (" ") : (" not "));
	return 1;
}
	
YCMD:amiblue(playerid, params[], help)
{
	if(help) SendClientMessage(playerid, -1, "Checks If You Are In Blue Team");
	else va_SendClientMessage(playerid, -1, "You are%sin Blue Team", (Group_GetPlayer(g_TeamBlue, playerid)) ? (" ") : (" not "));
	return 1;
}
