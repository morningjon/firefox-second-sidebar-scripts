# Firefox Second Sidebar Setup for Windows
# Run this in PowerShell as Administrator

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Firefox Second Sidebar Setup (Windows)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Check for Firefox
$firefoxPath = "C:\Program Files\Mozilla Firefox"
if (-not (Test-Path $firefoxPath)) {
    $firefoxPath = "C:\Program Files (x86)\Mozilla Firefox"
    if (-not (Test-Path $firefoxPath)) {
        Write-Host "ERROR: Firefox not found in Program Files" -ForegroundColor Red
        Write-Host "Make sure Firefox is installed (not from Windows Store)" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "Found Firefox at: $firefoxPath" -ForegroundColor Green

# Stop Firefox if running
Write-Host "Stopping Firefox..." -ForegroundColor Yellow
Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Find Firefox profile (most recently modified)
Write-Host "Detecting Firefox profile..." -ForegroundColor Yellow
$profileRoot = "$env:APPDATA\Mozilla\Firefox\Profiles"

if (-not (Test-Path $profileRoot)) {
    Write-Host "ERROR: Firefox profiles directory not found" -ForegroundColor Red
    Write-Host "Please run Firefox at least once to create a profile" -ForegroundColor Yellow
    exit 1
}

$profiles = Get-ChildItem -Path $profileRoot -Directory | Where-Object { $_.Name -match "\.(default-release|default)$" } | Sort-Object LastWriteTime -Descending

if ($profiles.Count -eq 0) {
    Write-Host "ERROR: No Firefox profile found" -ForegroundColor Red
    Write-Host "" -ForegroundColor Yellow
    Write-Host "Available directories in $profileRoot :" -ForegroundColor Yellow
    Get-ChildItem -Path $profileRoot -Directory | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Yellow }
    Write-Host "" -ForegroundColor Yellow
    Write-Host "Please run Firefox at least once to create a profile" -ForegroundColor Yellow
    exit 1
}

$profile = $profiles[0]
$profilePath = $profile.FullName
Write-Host "Using profile: $profilePath" -ForegroundColor Green
Write-Host ""

# Download and extract fx-autoconfig
Write-Host "Installing fx-autoconfig..." -ForegroundColor Yellow
$tempDir = "$env:TEMP\firefox-sidebar-setup"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

Invoke-WebRequest -Uri "https://github.com/MrOtherGuy/fx-autoconfig/archive/refs/heads/master.zip" -OutFile "$tempDir\fx.zip"

if (-not (Test-Path "$tempDir\fx.zip")) {
    Write-Host "ERROR: Failed to download fx-autoconfig" -ForegroundColor Red
    exit 1
}

Expand-Archive -Path "$tempDir\fx.zip" -DestinationPath $tempDir -Force

# Copy fx-autoconfig files to profile
Copy-Item -Path "$tempDir\fx-autoconfig-master\program\*" -Destination $profilePath -Recurse -Force
New-Item -ItemType Directory -Force -Path "$profilePath\chrome" | Out-Null
Copy-Item -Path "$tempDir\fx-autoconfig-master\profile\chrome\utils" -Destination "$profilePath\chrome\" -Recurse -Force
Copy-Item -Path "$tempDir\fx-autoconfig-master\profile\chrome\resources" -Destination "$profilePath\chrome\" -Recurse -Force

# Verify installation
if (-not (Test-Path "$profilePath\config.js") -or -not (Test-Path "$profilePath\chrome\utils")) {
    Write-Host "ERROR: fx-autoconfig installation failed" -ForegroundColor Red
    Write-Host "Missing files in $profilePath" -ForegroundColor Red
    exit 1
}
Write-Host "✓ fx-autoconfig installed" -ForegroundColor Green
Write-Host ""

# Download and extract second sidebar
Write-Host "Installing second sidebar..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://github.com/aminought/firefox-second-sidebar/archive/refs/heads/master.zip" -OutFile "$tempDir\sidebar.zip"

if (-not (Test-Path "$tempDir\sidebar.zip")) {
    Write-Host "ERROR: Failed to download second sidebar" -ForegroundColor Red
    exit 1
}

Expand-Archive -Path "$tempDir\sidebar.zip" -DestinationPath $tempDir -Force

New-Item -ItemType Directory -Force -Path "$profilePath\chrome\JS" | Out-Null
Copy-Item -Path "$tempDir\firefox-second-sidebar-master\src\*" -Destination "$profilePath\chrome\JS\" -Recurse -Force

# Verify installation
if (-not (Test-Path "$profilePath\chrome\JS\second_sidebar.uc.mjs")) {
    Write-Host "ERROR: second sidebar installation failed" -ForegroundColor Red
    Write-Host "Missing second_sidebar.uc.mjs in $profilePath\chrome\JS\" -ForegroundColor Red
    exit 1
}
Write-Host "✓ second sidebar installed" -ForegroundColor Green
Write-Host ""

# Add required prefs
Write-Host "Configuring preferences..." -ForegroundColor Yellow
$prefsFile = "$profilePath\prefs.js"
$prefs = Get-Content $prefsFile -ErrorAction SilentlyContinue

if ($prefs -notmatch "dom.allow_scripts_to_close_windows") {
    Add-Content -Path $prefsFile -Value 'user_pref("dom.allow_scripts_to_close_windows", true);'
}
if ($prefs -notmatch "toolkit.legacyUserProfileCustomizations.stylesheets") {
    Add-Content -Path $prefsFile -Value 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
}

# Create config files in Firefox installation
Write-Host "Installing system config files..." -ForegroundColor Yellow

$configJs = @'
// skip 1st line
try {
  let cmanifest = Cc['@mozilla.org/file/directory_service;1'].getService(Ci.nsIProperties).get('UChrm', Ci.nsIFile);
  cmanifest.append('utils');
  cmanifest.append('chrome.manifest');
  
  if(cmanifest.exists()){
    Components.manager.QueryInterface(Ci.nsIComponentRegistrar).autoRegister(cmanifest);
    ChromeUtils.importESModule('chrome://userchromejs/content/boot.sys.mjs');
  }
} catch(ex) {};
'@

$configPrefs = @'
pref("general.config.obscure_value", 0);
pref("general.config.filename", "config.js");
pref("general.config.sandbox_enabled", false);
'@

Set-Content -Path "$firefoxPath\config.js" -Value $configJs
New-Item -ItemType Directory -Force -Path "$firefoxPath\defaults\pref" | Out-Null
Set-Content -Path "$firefoxPath\defaults\pref\config-prefs.js" -Value $configPrefs

# Clean up
Remove-Item -Path $tempDir -Recurse -Force

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Start Firefox and you should see a second sidebar." -ForegroundColor Cyan
Write-Host "To add web panels, click the + button in the sidebar." -ForegroundColor Cyan
Write-Host ""
Write-Host "To enable vertical tabs:" -ForegroundColor Cyan
Write-Host "  Settings → Check 'Show sidebar' → Enable vertical tabs" -ForegroundColor Cyan
Write-Host ""
