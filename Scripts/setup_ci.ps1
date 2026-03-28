# setup_ci.ps1 - Prepare CI environment for FSMP-MCM build

$rootDir = Get-Location
$depDir = Join-Path $rootDir "ci_dependencies"
$toolDir = Join-Path $rootDir "ci_tools"

if (!(Test-Path $depDir)) { New-Item -ItemType Directory -Path $depDir }
if (!(Test-Path $toolDir)) { New-Item -ItemType Directory -Path $toolDir }

function Download-And-Extract {
    param (
        [string]$Url,
        [string]$Name,
        [string]$ExtractSubPath = ""
    )
    Write-Host "Downloading $Name..."
    $zipFile = Join-Path $env:TEMP "$Name.zip"
    $outDir = Join-Path $env:TEMP "$Name-extracted"
    
    Invoke-WebRequest -Uri $Url -OutFile $zipFile
    if (Test-Path $outDir) { Remove-Item -Recurse -Force $outDir }
    Expand-Archive -Path $zipFile -DestinationPath $outDir
    
    $sourcePath = if ($ExtractSubPath) { Join-Path $outDir $ExtractSubPath } else { $outDir }
    return $sourcePath
}

# 1. Download Tools
# Caprica
$capricaPath = Download-And-Extract "https://github.com/Orvid/Caprica/releases/latest/download/Caprica.zip" "Caprica"
Copy-Item (Join-Path $capricaPath "Caprica.exe") (Join-Path $toolDir "Caprica.exe")

# Pyro
$pyroPath = Download-And-Extract "https://github.com/fireundubh/pyro/releases/latest/download/pyro.zip" "Pyro"
Copy-Item (Join-Path $pyroPath "pyro.exe") (Join-Path $toolDir "pyro.exe")

# 2. Download Dependencies
# Base Game Scripts (Stubs)
$gameSdk = Download-And-Extract "https://github.com/Mr-S-E/Papyrus-SDK-Skyrim/archive/refs/heads/master.zip" "GameSDK" "Papyrus-SDK-Skyrim-master"
Copy-Item -Recurse (Join-Path $gameSdk "*") $depDir

# SKSE Scripts
$skseSdk = Download-And-Extract "https://github.com/ianpatt/skse64/archive/refs/heads/master.zip" "SKSESDK" "skse64-master/skse64/Scripts/Source"
Copy-Item -Recurse (Join-Path $skseSdk "*.psc") $depDir

# SkyUI SDK
$skyuiSdk = Download-And-Extract "https://github.com/schlangster/skyui/archive/refs/heads/master.zip" "SkyUISDK" "skyui-master/dist/Data/Scripts/Source"
Copy-Item -Recurse (Join-Path $skyuiSdk "*.psc") $depDir

# PapyrusUtil
$papyrusUtil = Download-And-Extract "https://github.com/exoticretard/PapyrusUtil/archive/refs/heads/master.zip" "PapyrusUtil" "PapyrusUtil-master/Source/Scripts"
Copy-Item -Recurse (Join-Path $papyrusUtil "*.psc") $depDir

# JContainers
$jcontainers = Download-And-Extract "https://github.com/silverlockteam/JContainers/archive/refs/heads/master.zip" "JContainers" "JContainers-master/scripts/source"
Copy-Item -Recurse (Join-Path $jcontainers "*.psc") $depDir

# ConsoleUtil
$consoleUtil = Download-And-Extract "https://github.com/Ryan-S-S/ConsoleUtilSSE/archive/refs/heads/master.zip" "ConsoleUtil" "ConsoleUtilSSE-master/Scripts/Source"
Copy-Item -Recurse (Join-Path $consoleUtil "*.psc") $depDir

# 3. Create Flags File
$flagsContent = @"
[ExternalElement]
0=Hidden
1=Conditional
2=Debug

[Property]
0=Hidden
1=Conditional

[Variable]
0=Hidden
1=Conditional
"@
$flagsContent | Out-File -FilePath (Join-Path $depDir "TESV_Papyrus_Flags.flg") -Encoding ascii

Write-Host "CI dependency setup complete."
