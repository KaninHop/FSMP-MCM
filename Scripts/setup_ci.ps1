# setup_ci.ps1 - Prepare CI environment for FSMP-MCM build
#
# Base game, SKSE, and mod dependency scripts are provided as minimal stubs
# in Source/Scripts/Stubs/ (committed to the repo).
# Only the Caprica compiler and SkyUI SDK need to be downloaded.

$ErrorActionPreference = "Stop"
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
    Write-Host "Downloading $Name from $Url ..."
    $zipFile = Join-Path $env:TEMP "$Name.zip"
    $outDir = Join-Path $env:TEMP "$Name-extracted"
    
    Invoke-WebRequest -Uri $Url -OutFile $zipFile -UseBasicParsing
    if (Test-Path $outDir) { Remove-Item -Recurse -Force $outDir }
    Expand-Archive -Path $zipFile -DestinationPath $outDir
    
    $sourcePath = if ($ExtractSubPath) { Join-Path $outDir $ExtractSubPath } else { $outDir }
    return $sourcePath
}

# ── 1. Download Caprica compiler ──────────────────────────────────────────────

$capricaPath = Download-And-Extract "https://github.com/KrisV-777/Caprica/releases/download/0.3.0a/Caprica.zip" "Caprica"
Get-ChildItem -Path $capricaPath -Filter "Caprica.exe" -Recurse | Select-Object -First 1 | Copy-Item -Destination (Join-Path $toolDir "Caprica.exe")
Write-Host "Caprica installed."

# ── 2. Download SkyUI SDK (MCM framework) ─────────────────────────────────────

$skyuiSdk = Download-And-Extract "https://github.com/schlangster/skyui/archive/refs/heads/master.zip" "SkyUISDK" "skyui-master/dist/Data/Scripts/Source"
Copy-Item (Join-Path $skyuiSdk "*.psc") $depDir
Write-Host "SkyUI SDK installed."

# ── Done ──────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "CI dependency setup complete."
Write-Host "  Tools:        $toolDir"
Write-Host "  Dependencies: $depDir"
Write-Host "  Stubs:        Source/Scripts/Stubs/ (in repo)"
