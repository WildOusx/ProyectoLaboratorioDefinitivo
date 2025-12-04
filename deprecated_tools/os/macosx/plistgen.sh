#!/bin/sh

# sets VERSION to the value if RELEASE if there are any,
# otherwise it sets VERSION to revision number
if [ "$3" ]; then
VERSION="$3"
else
VERSION="$2"
fi
date=`date +%Y`

# Generates Info.plist while applying $VERSION

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" 
\"http://www.apple.com/DTDs/Prop$
<plist version=\"1.0\">\n<dict>\n        <key>CFBundleDevelopmentRegion</key>\n        <string>English</string>\n        <key>CFBundleDisplayName</key>\n        <string>OpenDUNE</string>\n        <key>CFBundleExecutable</key>\n        <string>opendune</string>\n        <key>CFBundleGetInfoString</key>\n        <string>$VERSION, Copyright 2009-$date The OpenDUNE team</string>\n        <key>CFBundleIconFile</key>\n        <string>opendune.icns</string>\n        <key>CFBundleIdentifier</key>\n        <string>org.opendune.opendune</string>\n        <key>CFBundleInfoDictionaryVersion</key>\n        <string>6.0</string>\n        <key>CFBundleName</key>\n        <string>OpenDUNE</string>\n        <key>CFBundlePackageType</key>\n        <string>APPL</string>\n        <key>CFBundleShortVersionString</key>\n        <string>$VERSION</string>\n        <key>CFBundleVersion</key>\n        <string>$VERSION</string>\n        <key>NSHumanReadableCopyright</key>\n        <string>Copyright 2009-$date The OpenDUNE team</string>\n        <key>NSPrincipalClass</key>\n        <string>NSApplication</string>\n</dict>\n</plist>" > "$1"/Contents/Info.plist
