# fivem-flight-game (WIP)
FiveM Flight Simulator with plane UI.

<img alt="Coming in next update" src="https://github.com/Psykopaten/fivem-flight-game/assets/104300989/f450b0f9-9eee-43fa-8a23-9b2c21e570ca">

## Requirements
- [NativeUI](https://github.com/FrazzIe/NativeUILua/archive/refs/tags/2.1.0.zip)
- Go into NativeUI/NativeUI.lua and goto line 2676 and change `if Item() == "UIMenuItem" then` to `if type(Item) == "table" and Item.__index == UIMenuItem then`

## Add this to server.cfg
```
ensure InteractionMenu
ensure vehicleControls
ensure planehud
```

## Optional
You can also add this if you want the players to spawn at the airport
Step 1. Go into `[gamemodes]/[maps]/fivem-map-hipster` or `[gamemodes]/[maps]/fivem-map-skater`
Step 2. Go into the map.lua files and remove all lines that have a `spawnpoint` in the start and replace them with this:
```
spawnpoint 's_m_m_pilot_01' { x = -933.1028, y = -2967.3000, z = 13.9451 }
spawnpoint 's_m_m_pilot_01' { x = -934.6771, y = -2966.3225, z = 13.9451 }
spawnpoint 's_m_m_pilot_01' { x = -935.4889, y = -2967.6309, z = 13.9451 }
spawnpoint 's_m_m_pilot_01' { x = -933.5282, y = -2969.0061, z = 13.9451 }
```

### Coming up next update
- Radio with radio channels
- A label that tells you the closest airports so you know when to change radio frequency.

## Socials
Joina my new discord server for support and updates
https://discord.gg/TJCKedg8SB

# Visitor Count
  <img src="https://profile-counter.glitch.me/fivem-flight-game/count.svg" />
