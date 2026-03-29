Param(
    [ValidateSet("Release", "Dev")]
    [String]$Mode = "Release"
)

# Compilation Script for FSMP MCM Papyrus Scripts
# Requires Caprica/Caprica.exe to be present.

$CapricaExe = "Caprica/Caprica.exe"

if (-not (Test-Path $CapricaExe)) {
    Write-Warning "Caprica compiler not found at $CapricaExe"
    Write-Host "Please download Caprica.exe and place it in the Caprica/ folder."
    Write-Host "You can get it from: https://github.com/Orvid/Caprica/releases"
    exit 1
}

$OutputDir = "Scripts"
$FlagsFile = "Source/Scripts/Stubs/BaseGame/TESV_Papyrus_Flags.flg"

if ($Mode -eq "Release") {
    Write-Host "--- RELEASE BUILD (Using Stubs) ---"
    $Imports = @(
        "Source/Scripts",
        "Source/Scripts/SkyUI_SDK",
        "Source/Scripts/Stubs/BaseGame",
        "Source/Scripts/Stubs/SKSE",
        "Source/Scripts/Stubs/JContainers",
        "Source/Scripts/Stubs/PapyrusUtil",
        "Source/Scripts/Stubs/ConsoleUtil"
    ) -join ";"
} else {
    Write-Host "--- DEV BUILD (Using Local Scripts) ---"
    # These paths should match your skyrimse.dev.ppj
    # Adjust here if you update your local source locations.
    $FlagsFile = "F:\SteamLibrary\steamapps\common\Skyrim Special Edition\Data\Source\Scripts\TESV_Papyrus_Flags.flg"
    $Imports = @(
        "Source/Scripts",
        "F:\Vortex Mods\skyrimse\Skyrim Script Extender (SKSE64)-30379-2-2-6-1705522967\Data\Scripts\Source",
        "F:\SteamLibrary\steamapps\common\Skyrim Special Edition\Data\Source\Scripts",
        "E:\dev\Smp Benchmark Mod\SkyUI\skyui-master\dist\Data\Scripts\Source",
        "F:\Vortex Mods\skyrimse\PapyrusUtil AE SE - Scripting Utility Functions-13048-4-6-1705639805\Source\Scripts",
        "F:\Vortex Mods\skyrimse\ConsoleUtilSSE NG-76649-1-5-1-1704108553\Scripts\Source",
        "F:\Vortex Mods\skyrimse\JContainers SE-16495-4-2-9-1705929247\scripts\source"
    ) -join ";"
}

# Ensure output directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force
}

$SourceFiles = Get-ChildItem "Source/Scripts/*.psc" -Exclude "FSMPM_AutoBindings.psc"

foreach ($file in $SourceFiles) {
    Write-Host "Compiling $($file.Name)..."
    & $CapricaExe --game skyrim --flags $FlagsFile --import $Imports --output $OutputDir --ignorecwd "$($file.FullName)"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile $($file.Name)"
        exit 1
    }
}

Write-Host "All scripts compiled successfully."

# Optional: Run local deployment if in Dev mode and successful
if ($Mode -eq "Dev") {
    Write-Host "Running local deployment..."
    # Paths from your skyrimse.dev.ppj PostBuildEvent
    $DeployPaths = @(
        "C:\Games\Nolvus\Instances\Nolvus Natural Lighting\MODS\mods\FSMPM - The FSMP MCM Dev\",
        "C:\Games\Faster HDT-SMP\FSMPM - The FSMP MCM\"
    )
    
    foreach ($dest in $DeployPaths) {
        if (Test-Path $dest) {
            Write-Host "  Copying to $dest"
            xcopy "Scripts" "$($dest)Scripts\" /E/Y/Q
            xcopy "SKSE" "$($dest)SKSE\" /E/Y/Q
            xcopy "Source" "$($dest)Source\" /E/Y/Q
        }
    }
}
