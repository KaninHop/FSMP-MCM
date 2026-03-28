---
description: Build the FSMP MCM Papyrus scripts using Caprica
---

# Build FSMP MCM

Compiles the Papyrus source scripts (`.psc`) into compiled Papyrus executables (`.pex`) using the Caprica compiler.

## Prerequisites

- **Caprica** compiler at `Caprica/Caprica.exe` (already in the repo)
- Import dependencies installed at the paths specified in `skyrimse.ppj`:
  - SKSE64 Scripts/Source
  - Skyrim SE Data/Source/Scripts  
  - SkyUI SDK (skyui-master)
  - PapyrusUtil
  - ConsoleUtilSSE
  - JContainers

## Build Command

// turbo
1. Run the Caprica compiler with all import paths:

```
./Caprica/Caprica.exe --game skyrim --flags "F:\SteamLibrary\steamapps\common\Skyrim Special Edition\Data\Source\Scripts\TESV_Papyrus_Flags.flg" --import "E:\dev\FSMP-MCM\Source\Scripts;F:\Vortex Mods\skyrimse\Skyrim Script Extender (SKSE64)-30379-2-2-6-1705522967\Data\Scripts\Source;F:\SteamLibrary\steamapps\common\Skyrim Special Edition\Data\Source\Scripts;E:\dev\Smp Benchmark Mod\SkyUI\skyui-master\dist\Data\Scripts\Source;F:\Vortex Mods\skyrimse\PapyrusUtil AE SE - Scripting Utility Functions-13048-4-6-1705639805\Source\Scripts;F:\Vortex Mods\skyrimse\ConsoleUtilSSE NG-76649-1-5-1-1704108553\Scripts\Source;F:\Vortex Mods\skyrimse\JContainers SE-16495-4-2-9-1705929247\scripts\source" --output "E:\dev\FSMP-MCM\Scripts" --ignorecwd "E:\dev\FSMP-MCM\Source\Scripts\FSMPM.psc"
```

The compiled `FSMPM.pex` will be placed in the `Scripts/` directory.

## Notes

- The `--ignorecwd` flag prevents Caprica from auto-adding the CWD to imports, which avoids namespace conflicts (Caprica treats relative paths as namespaces).
- The `--game skyrim` flag enables Skyrim-specific compatibility options (e.g. `--allow-unknown-events`).
- The source file must be passed as an **absolute path** to avoid Caprica interpreting directory prefixes as namespaces.
- Warning W4007 about `loadConfigDone` being unused is expected and harmless.
- Caprica is stricter than the original Papyrus compiler. Use `OnOptionHighlight` instead of `OnHighlight` for event names.
