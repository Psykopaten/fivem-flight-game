# fivem-flight-game (WIP)
Simple FiveM Flight Simulator with simple plane UI.

## Requirements
- [NativeUI](https://github.com/Guad/NativeUI/releases/download/1.9.1/Release.zip)

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

## Socials
Joina my new discord server for support and updates
https://discord.gg/TJCKedg8SB

# Visitor Count
  <img src="https://profile-counter.glitch.me/vulix-load/count.svg" />
