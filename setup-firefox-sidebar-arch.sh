#!/bin/bash
set -e

echo "=========================================="
echo "Firefox Second Sidebar Setup (Arch/Manjaro)"
echo "=========================================="

# Check for Flatpak Firefox (must use system Firefox)
if flatpak list 2>/dev/null | grep -q firefox; then
    echo "ERROR: Flatpak Firefox detected!"
    echo "This script requires system Firefox. Remove Flatpak version:"
    echo "  flatpak uninstall org.mozilla.firefox"
    exit 1
fi

# Check for Snap Firefox
if snap list 2>/dev/null | grep -q firefox; then
    echo "ERROR: Snap Firefox detected!"
    echo "This script requires system Firefox. Remove Snap version:"
    echo "  sudo snap remove firefox"
    exit 1
fi

# Kill Firefox if running
echo "Stopping Firefox..."
killall firefox 2>/dev/null || true
sleep 2

# Find Firefox profile
PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -name "*.default-release" -o -name "*.default" 2>/dev/null | head -1)
if [ -z "$PROFILE" ]; then
    echo "ERROR: Firefox profile not found. Run Firefox at least once first."
    exit 1
fi

echo "Using profile: $PROFILE"

# Install fx-autoconfig
echo "Installing fx-autoconfig..."
cd /tmp
wget -q https://github.com/MrOtherGuy/fx-autoconfig/archive/refs/heads/master.zip -O fx.zip
unzip -q fx.zip
cd "$PROFILE"
cp -r /tmp/fx-autoconfig-master/program/* .
mkdir -p chrome
cp -r /tmp/fx-autoconfig-master/profile/chrome/utils chrome/
cp -r /tmp/fx-autoconfig-master/profile/chrome/resources chrome/
rm -rf /tmp/fx-autoconfig-master /tmp/fx.zip

# Install second sidebar
echo "Installing second sidebar..."
cd /tmp
wget -q https://github.com/aminought/firefox-second-sidebar/archive/refs/heads/master.zip -O sidebar.zip
unzip -q sidebar.zip
mkdir -p "$PROFILE/chrome/JS"
cp -r firefox-second-sidebar-master/src/* "$PROFILE/chrome/JS/"
rm -rf firefox-second-sidebar-master sidebar.zip

# Add required prefs to profile
echo "Configuring preferences..."
grep -q "dom.allow_scripts_to_close_windows" "$PROFILE/prefs.js" || \
    echo 'user_pref("dom.allow_scripts_to_close_windows", true);' >> "$PROFILE/prefs.js"
grep -q "toolkit.legacyUserProfileCustomizations.stylesheets" "$PROFILE/prefs.js" || \
    echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$PROFILE/prefs.js"

# Create config files for system Firefox
echo "Installing system config files (requires sudo)..."
sudo tee /usr/lib/firefox/config.js > /dev/null << 'EOF'
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
EOF

sudo tee /usr/lib/firefox/defaults/pref/config-prefs.js > /dev/null << 'EOF'
pref("general.config.obscure_value", 0);
pref("general.config.filename", "config.js");
pref("general.config.sandbox_enabled", false);
EOF

echo ""
echo "=========================================="
echo "Installation complete!"
echo "=========================================="
echo ""
echo "Start Firefox and you should see a second sidebar."
echo "To add web panels, click the + button in the sidebar."
echo ""
echo "To enable vertical tabs:"
echo "  Settings → Check 'Show sidebar' → Enable vertical tabs"
echo ""
