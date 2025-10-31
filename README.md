# Firefox Second Sidebar - Easy Setup Script

A one-command installation script to add a second sidebar with web panels to Firefox on Linux, similar to Microsoft Edge, Vivaldi, or Floorp.

## What This Does

This script gives you **two independent sidebars** in Firefox:
- **Left side**: Firefox's native vertical tabs
- **Right side**: Web panels for quick access to websites (Gmail, Twitter, Discord, etc.)

![Example setup](https://user-images.githubusercontent.com/yourusername/example.png)
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

- **System Firefox** (NOT Flatpak/Snap version)
- Firefox must have been run at least once to create a profile
- Supported distributions:
  - Debian/Ubuntu/Linux Mint
  - Arch Linux/Manjaro
  - Fedora
  - openSUSE

### Check Your Firefox Version

```bash
# This should show system Firefox, not flatpak/snap
flatpak list | grep firefox
snap list | grep firefox
```

If Flatpak or Snap Firefox is installed, the script will warn you and exit. Remove it first:

```bash
# For Flatpak
flatpak uninstall org.mozilla.firefox

# For Snap
sudo snap remove firefox
```

Then install system Firefox using your distro's package manager:

```bash
# Debian/Ubuntu/Mint
sudo apt install firefox

# Arch/Manjaro
sudo pacman -S firefox

# Fedora
sudo dnf install firefox

# openSUSE
sudo zypper install MozillaFirefox
```

## Installation

### Choose Your Distro

Download the appropriate script for your Linux distribution:

**Debian/Ubuntu/Linux Mint:**
```bash
wget https://raw.githubusercontent.com/yourusername/firefox-second-sidebar-setup/main/setup-firefox-sidebar-debian.sh
chmod +x setup-firefox-sidebar-debian.sh
./setup-firefox-sidebar-debian.sh
```

**Arch Linux/Manjaro:**
```bash
wget https://raw.githubusercontent.com/yourusername/firefox-second-sidebar-setup/main/setup-firefox-sidebar-arch.sh
chmod +x setup-firefox-sidebar-arch.sh
./setup-firefox-sidebar-arch.sh
```

**Fedora:**
```bash
wget https://raw.githubusercontent.com/yourusername/firefox-second-sidebar-setup/main/setup-firefox-sidebar-fedora.sh
chmod +x setup-firefox-sidebar-fedora.sh
./setup-firefox-sidebar-fedora.sh
```

**openSUSE:**
```bash
wget https://raw.githubusercontent.com/yourusername/firefox-second-sidebar-setup/main/setup-firefox-sidebar-opensuse.sh
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

1. Check Browser Console (`Ctrl+Shift+J`) for errors
2. Verify files were installed:
   ```bash
   ls -la ~/.mozilla/firefox/*.default-release/chrome/JS/second_sidebar.uc.mjs
   ls -la /usr/lib/firefox/config.js
   ```

### Flatpak Conflict

If you have both Flatpak and system Firefox:
```bash
# Remove Flatpak version
flatpak uninstall org.mozilla.firefox

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

To remove the second sidebar:

```bash
# Remove profile scripts
rm -rf ~/.mozilla/firefox/*.default-release/chrome/JS/second_sidebar*

# Remove system config (requires sudo)
sudo rm /usr/lib/firefox/config.js
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
- Support for other Linux distributions
- Additional automation
- Documentation improvements

---

**Note**: This modifies Firefox's internal configuration files and requires sudo access. Use at your own risk. Always backup your Firefox profile before running scripts that modify it.
