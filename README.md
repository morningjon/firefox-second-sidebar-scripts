# Firefox Second Sidebar - Easy Setup Script

A one-command installation script to add a second sidebar with web panels to Firefox, similar to Microsoft Edge, Vivaldi, or Floorp.

**Works on Windows, macOS, and Linux!**

## What This Does

This script gives you **two independent sidebars** in Firefox:
- **Left side**: Firefox's native vertical tabs
- **Right side**: Web panels for quick access to websites (Gmail, Twitter, Discord, etc.)

![Example setup](https://user-images.githubusercontent.com/morningjon/example.png)
*Vertical tabs on the left, web panels on the right - just like Edge!*

## Features

- ✅ Web panels for any website
- ✅ Multiple panels with quick switching
- ✅ Mobile view support
- ✅ Auto-hide sidebar option
- ✅ Works alongside Firefox's native vertical tabs
- ✅ Container support
- ✅ Customizable position (left/right)

## Prerequisites

### All Platforms
- **System Firefox** (NOT from Microsoft Store, Mac App Store, Flatpak, or Snap)
- Firefox must have been run at least once to create a profile

### Platform-Specific

**Windows:**
- Download Firefox from [mozilla.org](https://www.mozilla.org/firefox/)
- Run PowerShell as Administrator

**macOS:**
- Download Firefox from [mozilla.org](https://www.mozilla.org/firefox/)
- May need to allow script in System Preferences → Security & Privacy

**Linux:**
- Supported distributions: Debian/Ubuntu/Mint, Arch/Manjaro, Fedora, openSUSE
- Remove Flatpak/Snap versions and use system package manager

### Checking for Problematic Installations

**Linux:**
```bash
# Check for Flatpak/Snap (remove if found)
flatpak list | grep firefox
snap list | grep firefox
```

**Windows:**
Check that Firefox is installed in `C:\Program Files\Mozilla Firefox\` (not from Microsoft Store)

**macOS:**
Check that Firefox.app is in `/Applications/` (not from Mac App Store)

## Installation

### Windows

1. Download the PowerShell script:
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/morningjon/firefox-second-sidebar-setup/main/setup-firefox-sidebar-windows.ps1" -OutFile "setup-firefox-sidebar-windows.ps1"
   ```

2. Right-click PowerShell and select **"Run as Administrator"**

3. Run the script:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   .\setup-firefox-sidebar-windows.ps1
   ```

4. Restart Firefox

### macOS

1. Open Terminal and download the script:
   ```bash
   curl -O https://raw.githubusercontent.com/morningjon/firefox-second-sidebar-setup/main/setup-firefox-sidebar-macos.sh
   ```

2. Make it executable and run:
   ```bash
   chmod +x setup-firefox-sidebar-macos.sh
   ./setup-firefox-sidebar-macos.sh
   ```

3. Restart Firefox

### Linux

Choose your distribution:

**Debian/Ubuntu/Linux Mint:**
```bash
wget https://raw.githubusercontent.com/morningjon/firefox-second-sidebar-setup/main/setup-firefox-sidebar-debian.sh
chmod +x setup-firefox-sidebar-debian.sh
./setup-firefox-sidebar-debian.sh
```

**Arch Linux/Manjaro:**
```bash
wget https://raw.githubusercontent.com/morningjon/firefox-second-sidebar-setup/main/setup-firefox-sidebar-arch.sh
chmod +x setup-firefox-sidebar-arch.sh
./setup-firefox-sidebar-arch.sh
```

**Fedora:**
```bash
wget https://raw.githubusercontent.com/morningjon/firefox-second-sidebar-setup/main/setup-firefox-sidebar-fedora.sh
chmod +x setup-firefox-sidebar-fedora.sh
./setup-firefox-sidebar-fedora.sh
```

**openSUSE:**
```bash
wget https://raw.githubusercontent.com/morningjon/firefox-second-sidebar-setup/main/setup-firefox-sidebar-opensuse.sh
chmod +x setup-firefox-sidebar-opensuse.sh
./setup-firefox-sidebar-opensuse.sh
```

Then restart Firefox - the second sidebar should now appear!

## Usage

### Adding Web Panels

1. Click the **+** button in the second sidebar
2. Enter the website URL
3. Customize settings (mobile view, auto-hide, etc.)
4. Click save

### Enabling Vertical Tabs

1. Go to Firefox **Settings**
2. Check **"Show sidebar"**
3. Enable **"Vertical tabs"**

Now you have vertical tabs on one side and web panels on the other!

### Customization

Right-click the sidebar to access:
- Position (left/right)
- Auto-hide settings
- Width adjustments
- Container settings

## Troubleshooting

### Sidebar Not Appearing

1. Check Browser Console (`Ctrl+Shift+J` on Windows/Linux, `Cmd+Option+J` on Mac) for errors
2. Verify files were installed:

**Windows (PowerShell):**
```powershell
Test-Path "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\chrome\JS\second_sidebar.uc.mjs"
Test-Path "C:\Program Files\Mozilla Firefox\config.js"
```

**macOS/Linux:**
```bash
ls -la ~/.mozilla/firefox/*.default-release/chrome/JS/second_sidebar.uc.mjs
# macOS:
ls -la /Applications/Firefox.app/Contents/Resources/config.js
# Linux:
ls -la /usr/lib/firefox/config.js
```

### Windows-Specific Issues

**"Execution Policy" Error:**
Run PowerShell as Administrator and set:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

**Access Denied:**
Make sure you're running PowerShell as Administrator

### macOS-Specific Issues

**"Cannot be opened because it is from an unidentified developer":**
```bash
xattr -d com.apple.quarantine setup-firefox-sidebar-macos.sh
```

**Permission Denied on Firefox.app:**
Make sure you have admin rights and entered your password when prompted

### Linux-Specific Issues

**Flatpak/Snap Conflict:**
If you have both Flatpak/Snap and system Firefox:
```bash
# Remove Flatpak version
flatpak uninstall org.mozilla.firefox

# Remove Snap version
sudo snap remove firefox

# Verify system version is being used
which firefox  # Should show /usr/bin/firefox
```

### Firefox Updates Breaking It

After Firefox updates, you may need to:
```bash
sudo cp ~/.mozilla/firefox/*.default-release/config.js /usr/lib/firefox/
```

## How It Works

This script installs two components:

1. **[fx-autoconfig](https://github.com/MrOtherGuy/fx-autoconfig)** - Enables userChrome.js scripts in Firefox
2. **[firefox-second-sidebar](https://github.com/aminought/firefox-second-sidebar)** - Adds the web panel sidebar functionality

The script:
- Detects your Firefox profile
- Installs fx-autoconfig to enable custom scripts
- Installs the second sidebar script
- Configures Firefox to load the scripts on startup
- Sets required preferences

## Uninstallation

### Windows (PowerShell as Administrator)

```powershell
# Find your profile
$profile = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter "*.default-release" | Select-Object -First 1

# Remove profile scripts
Remove-Item -Path "$($profile.FullName)\chrome\JS\second_sidebar*" -Recurse -Force

# Remove system config
Remove-Item "C:\Program Files\Mozilla Firefox\config.js"
Remove-Item "C:\Program Files\Mozilla Firefox\defaults\pref\config-prefs.js"

# Restart Firefox
```

### macOS

```bash
# Remove profile scripts
rm -rf ~/Library/Application\ Support/Firefox/Profiles/*.default-release/chrome/JS/second_sidebar*

# Remove system config (requires sudo)
sudo rm /Applications/Firefox.app/Contents/Resources/config.js
sudo rm /Applications/Firefox.app/Contents/Resources/defaults/pref/config-prefs.js

# Restart Firefox
```

### Linux

```bash
# Remove profile scripts
rm -rf ~/.mozilla/firefox/*.default-release/chrome/JS/second_sidebar*

# Remove system config (requires sudo)
sudo rm /usr/lib/firefox/config.js  # or /usr/lib64/firefox/ on some distros
sudo rm /usr/lib/firefox/defaults/pref/config-prefs.js

# Restart Firefox
```

## Credits

This script automates the installation of:
- **[fx-autoconfig](https://github.com/MrOtherGuy/fx-autoconfig)** by MrOtherGuy
- **[firefox-second-sidebar](https://github.com/aminought/firefox-second-sidebar)** by aminought

Inspired by:
- Microsoft Edge's sidebar functionality
- Vivaldi's web panels
- Floorp Browser's web panel implementation

## License

This setup script is released under the MIT License.

The underlying components (fx-autoconfig and firefox-second-sidebar) are licensed under their respective licenses.

## Contributing

Found a bug or have a suggestion? Please open an issue!

Pull requests are welcome for:
- Support for other platforms
- Additional automation
- Documentation improvements

## Why This Exists

Edge has had this feature for years. Vivaldi has had it forever. Even Floorp added it. But major browsers like Firefox, Chrome, and Brave still don't offer native web panels + vertical tabs.

This project makes it easy for anyone to get this functionality in Firefox **right now**, without waiting for browser vendors to catch up. If enough people use this, maybe it'll light a fire under browsers like Brave to finally add this feature natively.

**Browsers should compete on features, not just privacy claims.** Let's show there's demand for better sidebar functionality!

---

**Note**: This modifies Firefox's internal configuration files. On Windows and macOS, it requires administrator/sudo access. Always backup your Firefox profile before running scripts that modify it.
