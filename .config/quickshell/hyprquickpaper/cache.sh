#!/usr/bin/env bash


CONFIG="$1/config.json"



wallpaper_path=$(jq -r '.wallpaper_path' "$CONFIG")
cache_path=$(jq -r '.cache_path' "$CONFIG")
cache_batch_size=$(jq -r '.cache_batch_size' "$CONFIG")

mkdir -p "$cache_path"

echo "Wallpaper path: $wallpaper_path"
echo "Cache path: $cache_path"

# Thumbnail generator: prefer vips (lighter), fallback to ImageMagick convert
make_thumb() {
    local src="$1" out="$2"
    if command -v vips >/dev/null 2>&1; then
        vips thumbnail "$src" "$out" 500 2>/dev/null
    elif command -v convert >/dev/null 2>&1; then
        convert "$src" -thumbnail x500 -strip -quality 85 "$out"
    else
        echo "ERROR: neither vips nor convert found" >&2
        return 1
    fi
}

find "$wallpaper_path" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" \
\) | while read -r img; do

    filename=$(basename "$img")
    out="$cache_path/$filename"

    if [[ -f "$out" ]]; then
        continue
    fi

    echo "Generating thumbnail for $filename"

    make_thumb "$img" "$out" &

    # Only limit jobs if batch_size > 0
    if (( cache_batch_size > 0 )); then
        while (( $(jobs -rp | wc -l) >= cache_batch_size )); do
            wait -n
        done
    fi

done

wait

echo "Thumbnail generation complete."
