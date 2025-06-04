# PDF Scanner Effect

A second generation of  bash/zsh script for macOS that transforms PDF documents to look like scanned copies with realistic noise, slight page rotations, and scanning artifacts.
First version you can see [here](https://geekjob.medium.com/imagemagick-emulate-the-effect-of-a-scanned-document-a820d6a0d15b)

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
git clone https://github.com/frontdevops/pdf-scanner-effect.git
cd pdf-scanner-effect
chmod +x scan.sh
```

## Usage

### Basic Usage

```bash
# Color scan (default)
./scan.sh input.pdf output.pdf

# Grayscale scan
./scan.sh -g input.pdf output.pdf

# Mixed mode: grayscale + color signature on last page
./scan.sh -s input.pdf output.pdf
```

### Options

- `-c, --color` - Color scan (default)
- `-g, --gray` - Grayscale scan
- `-s, --signature` - Grayscale document with color signature on last page
- `-h, --help` - Show help

## Examples

```bash
# Process a contract with color signature
./scan.sh -s contract.pdf scanned_contract.pdf

# Create grayscale scan
./scan.sh -g document.pdf document_scan.pdf
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
