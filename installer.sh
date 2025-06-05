#!/bin/bash
#
# PDF Scanner Effect v2.0 Installer
# Copyright (c) 2025
#

echo "Don't use, under construction!"
exit 1

set -e

SCRIPT_NAME="pdf-scanner"
INSTALL_DIR="/usr/local/bin"
SCRIPT_FILE="pdf-scanner.sh"

echo "PDF Scanner Effect v2.0 Installer"
echo "=================================="

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This installer is for macOS only"
    exit 1
fi

# Check if script file exists
if [ ! -f "$SCRIPT_FILE" ]; then
    echo "❌ Error: $SCRIPT_FILE not found in current directory"
    echo "Please download the script first"
    exit 1
fi

# Check for existing installation
if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    echo "⚠️  Existing installation found"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
fi

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install dependencies
echo "📦 Installing dependencies..."
echo "  - ImageMagick"
echo "  - Ghostscript"
brew install imagemagick ghostscript

# Install script
echo "📄 Installing PDF Scanner Effect..."
sudo cp "$SCRIPT_FILE" "$INSTALL_DIR/$SCRIPT_NAME"
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Verify installation
if command -v "$SCRIPT_NAME" &> /dev/null; then
    echo "✅ Installation successful!"
else
    echo "❌ Installation failed"
    exit 1
fi

echo ""
echo "🚀 Usage:"
echo "  $SCRIPT_NAME input.pdf output.pdf        # Color scan"
echo "  $SCRIPT_NAME -g input.pdf output.pdf     # Grayscale"
echo "  $SCRIPT_NAME -s contract.pdf scan.pdf    # Mixed mode"
echo "  $SCRIPT_NAME -h                          # Help"
echo ""
echo "The script is now available system-wide as '$SCRIPT_NAME'"

# Optional: Create uninstaller
cat > uninstall.sh << 'EOF'
#!/bin/bash
echo "Uninstalling PDF Scanner Effect..."
sudo rm -f /usr/local/bin/pdf-scanner
echo "Uninstalled successfully"
rm -- "$0"
EOF
chmod +x uninstall.sh
echo "📝 Uninstaller created: ./uninstall.sh"
