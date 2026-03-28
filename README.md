# FSMP-MCM

![Build Status](https://github.com/KaninHop/FSMP-MCM/actions/workflows/build.yml/badge.svg)

The Faster Skinned Mesh Physics Mod Configuration Menu for Skyrim.

## Overview

FSMP-MCM is a SkyUI Mod Configuration Menu (MCM) designed for the [Faster HDT-SMP](https://www.nexusmods.com/skyrimspecialedition/mods/57339) (FSMP) physics engine plugin. It enables players to intuitively control and fine-tune physics settings directly from within the game.

## Features

Instead of direct memory injection, this MCM dynamically recompiles and overwrites the FSMP `configs.xml` on the fly, immediately followed by an `smp reset` console command so the backend picks up the changes seamlessly.

Key features broken down by menu pages:
- **Master Switch & Commands:** Easily toggle SMP globally, or trigger debug console commands like `smp list`, `smp detail`, and `smp dumptree` without manually typing them.
- **Simplification (Culling):** Save performance by disabling 1st-person physics, turning off SMP hair when wigs are equipped, or auto-adjusting the maximum active SMP skeletons based on allowed frame time.
- **Simulation Quality:** Dial in physics precision by tweaking iterations, substeps, ERP, and MLCP toggles. Includes rotation limits to prevent physics explosions on sharp turns.
- **Wind Parameters:** Enable and manipulate FSMP-native wind by setting wind strength scales and establishing distance cutoffs for wind calculation.
- **Logging & Presets:** Quickly adjust the hdtSMP64 log level (Fatal to Debug) or swap between saved XML presets in-game.

## Prerequisites

To build the Papyrus scripts from source, you will need:
- [Skyrim Script Extender (SKSE64)](http://skse.silverlock.org/) Scripts/Source
- [SkyUI SDK](https://github.com/schlangster/skyui/wiki/Downloads)
- Papyrus dependencies (adjust your paths in `skyrimse.ppj` accordingly):
  - PapyrusUtil
  - ConsoleUtilSSE
  - JContainers
- A suitable Papyrus compiler tool (like Caprica or the official Creation Kit compiler).

## Build Instructions

This project uses the `skyrimse.ppj` file for its build configuration. 
1. Open `skyrimse.ppj`.
2. Update the `<Imports>` paths to point to the correct locations of your mod dependencies on your system.
3. Update the `<PostBuildEvent>` sections if you wish to deploy automatically to your mod manager folders.
4. Compile the project using your preferred Papyrus compiler that reads `.ppj` files.

## License

See the [LICENSE](LICENSE) file for more details.
