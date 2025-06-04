# PDF Scanner Effect

A bash/zsh script for macOS that transforms PDF documents to look like scanned copies with realistic noise, slight page rotations, and scanning artifacts.

## Features

- Realistic scanner/xerox effects
- Gaussian noise and grain
- Random slight page rotations (±0.5°)
- Color or grayscale modes
- Mixed mode (grayscale document + color signature on last page)
- PDF compression

## Installation

### Dependencies

```bash
brew install imagemagick ghostscript
```

### Download

```bash
git clone https://github.com/yourusername/pdf-scanner-effect.git
cd pdf-scanner-effect
chmod +x simple_scanner.sh
```

## Usage

### Basic Usage

```bash
# Color scan (default)
./simple_scanner.sh input.pdf output.pdf

# Grayscale scan
./simple_scanner.sh -g input.pdf output.pdf

# Mixed mode: grayscale + color signature on last page
./simple_scanner.sh -s input.pdf output.pdf
```

### Options

- `-c, --color` - Color scan (default)
- `-g, --gray` - Grayscale scan
- `-s, --signature` - Grayscale document with color signature on last page
- `-h, --help` - Show help

## Examples

```bash
# Process a contract with color signature
./simple_scanner.sh -s contract.pdf scanned_contract.pdf

# Create grayscale scan
./simple_scanner.sh -g document.pdf document_scan.pdf
```

## Effects Applied

- **Noise**: Gaussian noise for realistic grain
- **Rotation**: Random rotation ±0.5° per page
- **Blur**: Slight blur to simulate scanner movement
- **Contrast**: Adjusted contrast for authentic look
- **Compression**: Reduced quality for realistic file size

## Technical Details

- Input: PDF files
- Output: PDF with scanning effects
- Processing: Converts to PNG at 300 DPI, applies effects, converts back to PDF
- Temp files: Automatically cleaned up

## Requirements

- macOS
- ImageMagick 7+
- Ghostscript 9+
- Bash/Zsh

## License

MIT License

## Contributing

Pull requests welcome. Please test on various PDF types before submitting.

## Troubleshooting

**Error: "Unknown device: png16malpha"**
```bash
brew install ghostscript
```

**Error: "magick: command not found"**
```bash
brew install imagemagick
```

**Pages rotated too much**
- Rotation is limited to ±0.5° to prevent pages going out of bounds

## Acknowledgments

Uses ImageMagick and Ghostscript for PDF processing and image manipulation.
