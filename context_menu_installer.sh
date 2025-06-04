#!/bin/bash
# Simple Context Menu Services Installer

SERVICES_DIR="$HOME/Library/Services"
mkdir -p "$SERVICES_DIR"

# Create simple shell script wrappers
create_service() {
    local name="$1"
    local flag="$2"
    local suffix="$3"
    
    mkdir -p "$SERVICES_DIR/$name.workflow/Contents"
    
    cat > "$SERVICES_DIR/$name.workflow/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>com.pdf-scanner.$suffix</string>
    <key>CFBundleName</key>
    <string>$name</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>NSServices</key>
    <array>
        <dict>
            <key>NSMenuItem</key>
            <dict>
                <key>default</key>
                <string>$name</string>
            </dict>
            <key>NSMessage</key>
            <string>runScript</string>
            <key>NSPortName</key>
            <string>$name</string>
            <key>NSRequiredContext</key>
            <dict>
                <key>NSApplicationIdentifier</key>
                <string>com.apple.finder</string>
            </dict>
            <key>NSSendFileTypes</key>
            <array>
                <string>com.adobe.pdf</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
EOF

    cat > "$SERVICES_DIR/$name.workflow/Contents/document.wflow" << EOF
#!/bin/bash
for f in "\$@"; do
    dir=\$(dirname "\$f")
    base=\$(basename "\$f" .pdf)
    /usr/local/bin/pdf-scanner $flag "\$f" "\$dir/\${base}_$suffix.pdf"
done
EOF
    
    chmod +x "$SERVICES_DIR/$name.workflow/Contents/document.wflow"
}

echo "Creating context menu services..."

create_service "Create Color Scan" "-c" "color_scan"
create_service "Create Grayscale Scan" "-g" "grayscale_scan"

echo "✅ Services installed!"
echo "Right-click PDF files to see the new options"
