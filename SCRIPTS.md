# Firefox Second Sidebar Setup - Repository Contents

This repository contains automated installation scripts for adding a second sidebar with web panels to Firefox across all major platforms.

## Files

### Documentation
- `README.md` - Main documentation with installation instructions for all platforms

### Windows
- `setup-firefox-sidebar-windows.ps1` - PowerShell script for Windows 10/11

### macOS
- `setup-firefox-sidebar-macos.sh` - Bash script for macOS (Intel & Apple Silicon)

### Linux
- `setup-firefox-sidebar-debian.sh` - For Debian/Ubuntu/Linux Mint
- `setup-firefox-sidebar-arch.sh` - For Arch Linux/Manjaro
- `setup-firefox-sidebar-fedora.sh` - For Fedora
- `setup-firefox-sidebar-opensuse.sh` - For openSUSE

## Quick Start

Choose your platform and run one command:

**Windows:** Download and run `setup-firefox-sidebar-windows.ps1` as Administrator

**macOS:** Download and run `setup-firefox-sidebar-macos.sh`

**Linux:** Download and run the appropriate script for your distribution

See README.md for detailed instructions.

## What Gets Installed

All scripts install:
1. **fx-autoconfig** - Enables userChrome.js scripts in Firefox
2. **firefox-second-sidebar** - Adds web panel functionality

## Credits

- [fx-autoconfig](https://github.com/MrOtherGuy/fx-autoconfig) by MrOtherGuy
- [firefox-second-sidebar](https://github.com/aminought/firefox-second-sidebar) by aminought

## License

MIT License - See individual component licenses for fx-autoconfig and firefox-second-sidebar
