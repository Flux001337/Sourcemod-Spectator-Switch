# Changelog

## 1.2.0

- Fix the admin command checking the admin's team instead of the target's team.
- Apply the enable setting to self-switch commands as well as admin commands.
- Support admin commands from the server console and RCON.
- Exclude bot targets and report successful moves after changing the team.
- Only force suicide if the player remains alive after moving to spectator.
- Add feedback for disabled functionality, invalid targets, and existing spectators.
- Generate `cfg/sourcemod/plugin.spectatorswitch.cfg` automatically.
- Load common target-command translations.
- Modernize SourcePawn syntax and separate command handlers from team switching.

## 1.1.1 — 2014-12-04

- Fix the plugin version used by the Updater plugin.

## 1.1.0

- Optimize the code.
- Add Updater support.

## 1.0.0

- Initial release.
