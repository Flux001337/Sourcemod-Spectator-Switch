# SourceMod - Spectator Switch

SourceMod plugin by HSFighter that lets players move themselves to spectator and admins move other players.
Especially useful for deathmatch servers, where players can take a break by moving to spectator.

Current version: **1.2.0**. See [CHANGELOG.md](CHANGELOG.md) for the complete version history.

## Features

- Players can switch to spectator with `!afk`, `/afk`, or `sm_afk`.
- Admins with `ADMFLAG_KICK` access can move a player with `sm_spec <#userid|name>`.
- The admin command supports the server console and RCON and respects target immunity.
- Clear feedback for disabled functionality and players already in spectator.
- Optional Updater integration.

## Requirements

- [SourceMod](https://www.sourcemod.net/downloads.php) and SDK Tools.
- A game supporting `ChangeClientTeam`, with spectator team ID `1`.
- `scripting/include/updater.inc` is bundled for compilation; the [Updater plugin](https://forums.alliedmods.net/showthread.php?p=1570806) is optional at runtime.

Compiled with SourceMod 1.12.0.7253 without errors or warnings. Version 1.2.0 has not yet been tested on a game server.

## Installation

Copy `plugins/spectatorswitch.smx` to the server's `addons/sourcemod/plugins/` directory. Load it with `sm plugins load spectatorswitch` or change the map.
Configuration is generated at `cfg/sourcemod/plugin.spectatorswitch.cfg`.

For updates, replace the SMX and run `sm plugins reload spectatorswitch`.

## Commands

| Command | Access | Description |
| --- | --- | --- |
| `!afk` / `/afk` | Players | Move yourself to spectator |
| `sm_afk` | Player console | Move yourself to spectator |
| `sm_spec <#userid|name>` | Kick flag; server console / RCON | Move a human player to spectator |

Bots cannot be moved through this plugin. Both commands respect `sm_spec_enable`.

## Configuration

| ConVar | Default | Description |
| --- | --- | --- |
| `sm_spec_version` | `1.2.0` | Plugin version |
| `sm_spec_enable` | `1` | Enable or disable the plugin |

## Build

Run from this repository directory. In the current workspace, the shared compiler and standard includes are three directories above. For a standalone checkout, replace those paths with your SourceMod installation path.

Linux:

```sh
mkdir -p plugins
../../../spcomp64 scripting/spectatorswitch.sp -iscripting/include -i../../../include -oplugins/spectatorswitch.smx
```

Windows CMD:

```bat
if not exist plugins mkdir plugins
../../../spcomp64.exe scripting/spectatorswitch.sp -iscripting/include -i../../../include -oplugins/spectatorswitch.smx
```

## Repository structure

```text
scripting/
├── spectatorswitch.sp
└── include/
    └── updater.inc
```

Compiled plugins are stored locally in `plugins/` and excluded from Git. A release ZIP contains `plugins/spectatorswitch.smx` and `scripting/`; extract it into `addons/sourcemod/`.

## Author and source notices

HSFighter — http://www.hsfighter.net

The plugin source does not currently declare a license. The bundled Updater include retains its existing notices.
Optional updates use the existing endpoint: `http://update.hsfighter.net/sourcemod/spectatorswitch/spectatorswitch.txt`.
