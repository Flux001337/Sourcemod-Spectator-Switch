//////////////////////////////////////////////////////////////////
// Spectator Switch By HSFighter / www.hsfighter.net
//////////////////////////////////////////////////////////////////

#include <sourcemod>
#include <sdktools>
#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.2.0"
#define TEAM_SPECTATOR 1

#undef REQUIRE_PLUGIN
#include <updater>
#define UPDATE_URL "http://update.hsfighter.net/sourcemod/spectatorswitch/spectatorswitch.txt"

ConVar g_SpecMoveEnabled;

public Plugin myinfo =
{
    name = "Spectator Switch",
    author = "HSFighter",
    description = "Allows players and admins to move players to spectator",
    version = PLUGIN_VERSION,
    url = "http://www.hsfighter.net"
};

public void OnPluginStart()
{
    LoadTranslations("common.phrases");
    CreateConVar("sm_spec_version", PLUGIN_VERSION, "Spectator Switch Version", FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY | FCVAR_DONTRECORD);
    g_SpecMoveEnabled = CreateConVar("sm_spec_enable", "1", "Enable/Disable Spectator Switch", FCVAR_NONE, true, 0.0, true, 1.0);

    RegAdminCmd("sm_spec", Command_Move, ADMFLAG_KICK, "sm_spec <#userid|name>");
    RegConsoleCmd("sm_afk", Command_Afk, "Move yourself to spectator");
    AutoExecConfig(true, "plugin.spectatorswitch");

    if (LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
}

public void OnLibraryAdded(const char[] name)
{
    if (StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
}

public Action Command_Move(int client, int args)
{
    if (!g_SpecMoveEnabled.BoolValue)
    {
        ReplyToCommand(client, "[Spectator Switch] The plugin is disabled.");
        return Plugin_Handled;
    }

    if (client != 0 && !IsValidPlayer(client))
    {
        return Plugin_Handled;
    }

    if (args < 1)
    {
        ReplyToCommand(client, "Usage: sm_spec <#userid|name>");
        return Plugin_Handled;
    }

    char targetName[MAX_TARGET_LENGTH];
    GetCmdArg(1, targetName, sizeof(targetName));
    int target = FindTarget(client, targetName, true);
    if (target == -1)
    {
        return Plugin_Handled;
    }

    if (!IsValidPlayer(target))
    {
        ReplyToCommand(client, "[Spectator Switch] The target must be an in-game human player.");
        return Plugin_Handled;
    }

    if (GetClientTeam(target) == TEAM_SPECTATOR)
    {
        ReplyToCommand(client, "[Spectator Switch] %N is already a spectator.", target);
        return Plugin_Handled;
    }

    if (!MoveToSpectator(target))
    {
        ReplyToCommand(client, "[Spectator Switch] Could not move %N to spectator.", target);
        return Plugin_Handled;
    }

    if (client == 0)
    {
        PrintToChatAll("\x01[Spectator Switch] \x03%N\x04 was moved to spectator by the server console.", target);
    }
    else
    {
        PrintToChatAll("\x01[Spectator Switch] \x03%N\x04 was moved to spectator by: \x03%N", target, client);
    }
    return Plugin_Handled;
}

public Action Command_Afk(int client, int args)
{
    if (client == 0)
    {
        ReplyToCommand(client, "[Spectator Switch] This command is only available to players.");
        return Plugin_Handled;
    }

    if (!IsValidPlayer(client))
    {
        return Plugin_Handled;
    }

    if (!g_SpecMoveEnabled.BoolValue)
    {
        ReplyToCommand(client, "[Spectator Switch] The plugin is disabled.");
        return Plugin_Handled;
    }

    if (GetClientTeam(client) == TEAM_SPECTATOR)
    {
        ReplyToCommand(client, "[Spectator Switch] You are already a spectator.");
        return Plugin_Handled;
    }

    if (MoveToSpectator(client))
    {
        ReplyToCommand(client, "[Spectator Switch] You moved to spectator.");
    }
    else
    {
        ReplyToCommand(client, "[Spectator Switch] Could not move you to spectator.");
    }
    return Plugin_Handled;
}

bool MoveToSpectator(int client)
{
    if (!g_SpecMoveEnabled.BoolValue || !IsValidPlayer(client))
    {
        return false;
    }

    ChangeClientTeam(client, TEAM_SPECTATOR);

    // CS:S already kills players on team changes. Other mods may leave them alive.
    if (GetClientTeam(client) != TEAM_SPECTATOR)
    {
        return false;
    }
    if (IsPlayerAlive(client))
    {
        ForcePlayerSuicide(client);
    }
    return true;
}

bool IsValidPlayer(int client)
{
    return client >= 1 && client <= MaxClients && IsClientInGame(client) && !IsFakeClient(client);
}
