#!/bin/bash
# Simple PDF Scanner Effect Script for macOS
set -e

# Default parameters
COLOR_MODE="color"
LAST_PAGE_COLOR=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--color)
            COLOR_MODE="color"
            shift
            ;;
        -g|--gray|--grey)
            COLOR_MODE="gray"
            shift
            ;;
        -s|--signature)
            COLOR_MODE="gray"
            LAST_PAGE_COLOR=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [options] <input.pdf> <output.pdf>"
            echo "Options:"
            echo "  -c, --color      Color scan (default)"
            echo "  -g, --gray       Grayscale scan"
            echo "  -s, --signature  Grayscale + last page in color"
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            if [ -z "$INPUT_PDF" ]; then
                INPUT_PDF="$1"
            elif [ -z "$OUTPUT_PDF" ]; then
                OUTPUT_PDF="$1"
            else
                echo "Too many arguments"
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -z "$INPUT_PDF" ] || [ -z "$OUTPUT_PDF" ]; then
    echo "Usage: $0 [options] <input.pdf> <output.pdf>"
    echo "Use -h for help"
    exit 1
fi

if [ ! -f "$INPUT_PDF" ]; then
    echo "File not found: $INPUT_PDF"
    exit 1
fi

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "Converting PDF to images..."
gs -dNOPAUSE -dBATCH -sDEVICE=png16m -r300 -sOutputFile="$TEMP_DIR/page_%03d.png" "$INPUT_PDF"

echo "Applying scanning effects..."

# Count total pages
total_pages=$(ls "$TEMP_DIR"/page_*.png | wc -l | tr -d ' ')

current_page=0
for page in "$TEMP_DIR"/page_*.png; do
    if [ -f "$page" ]; then
        current_page=$((current_page + 1))
        basename=$(basename "$page" .png)
        processed="$TEMP_DIR/${basename}_processed.png"

        # Generate very small random rotation from -0.5 to +0.5 degrees
        rotation=$(awk 'BEGIN{srand(); print (rand()-0.5)*1}')

        # Determine mode for current page
        page_mode="$COLOR_MODE"
        if [ "$LAST_PAGE_COLOR" = true ] && [ "$current_page" -eq "$total_pages" ]; then
            page_mode="color"
        fi

        echo "Processing $(basename "$page") ($current_page/$total_pages) - mode: $page_mode"

        if [ "$page_mode" = "gray" ]; then
            # Grayscale scan
            magick "$page" \
                -background white -flatten \
                -modulate 94,115,97 \
                +noise Gaussian \
                -blur 0x0.4 \
                -contrast-stretch 2%x1% \
                -rotate "$rotation" \
                -background white -gravity center -extent 101%x101% \
                -colorspace Gray \
                -quality 75 \
                "$processed"
        else
            # Color scan
            magick "$page" \
                -background white -flatten \
                -modulate 96,108,98 \
                +noise Gaussian \
                -blur 0x0.3 \
                -contrast-stretch 1%x1% \
                -rotate "$rotation" \
                -background white -gravity center -extent 101%x101% \
                -quality 80 \
                "$processed"
        fi
    fi
done

echo "Creating PDF..."
magick "$TEMP_DIR"/*_processed.png "$OUTPUT_PDF"

output_mode="$COLOR_MODE"
if [ "$LAST_PAGE_COLOR" = true ]; then
    output_mode="mixed (grayscale + color signature)"
fi

echo "Done: $OUTPUT_PDF (mode: $output_mode)"

# Compress PDF
echo "Compressing PDF..."
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile="temp_compressed.pdf" "$OUTPUT_PDF"
mv "temp_compressed.pdf" "$OUTPUT_PDF"

open "$OUTPUT_PDF"
#EOF#
