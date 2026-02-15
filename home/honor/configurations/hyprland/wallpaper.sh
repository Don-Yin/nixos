#!/usr/bin/env bash
# Dynamic wallpaper rotation with swww.
# --init  : start daemon + set first wallpaper
# --next  : cycle to next random wallpaper
# --daemon: start daemon + rotate every WALLPAPER_INTERVAL seconds
#
# Primary source: ~/nix-configurations/assets/wallpapers/ (tracked via Git LFS)
# Fallback:       downloads from GitHub if the repo dir is empty/missing

set -euo pipefail

REPO_WALL_DIR="${HOME}/nix-configurations/assets/wallpapers"
STATE_DIR="${HOME}/.local/share/wallpapers"
CACHE="${STATE_DIR}/.current"
COUNT_FILE="${STATE_DIR}/.count"
INDICATOR="${STATE_DIR}/.indicator"
INTERVAL="${WALLPAPER_INTERVAL:-900}"

GITHUB_RAW="https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main"

# Use repo dir if it has wallpapers, otherwise fall back to local dir
resolve_wall_dir() {
    local count
    count=$(find "$REPO_WALL_DIR" -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.webp' \) -size +10k 2>/dev/null | wc -l)
    if (( count >= 1 )); then
        echo "$REPO_WALL_DIR"
    else
        echo "$STATE_DIR"
    fi
}

# Only downloads if neither repo nor local dir has enough wallpapers
fetch_wallpapers() {
    local dir
    dir=$(resolve_wall_dir)
    local count
    count=$(find "$dir" -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.webp' \) -size +10k 2>/dev/null | wc -l)
    (( count >= 3 )) && return

    mkdir -p "$STATE_DIR"
    local -a sources=(
        "${GITHUB_RAW}/landscapes/Clearnight.jpg"
        "${GITHUB_RAW}/landscapes/Rainnight.jpg"
        "${GITHUB_RAW}/landscapes/evening-sky.png"
        "${GITHUB_RAW}/landscapes/salty_mountains.png"
        "${GITHUB_RAW}/landscapes/Cloudsnight.jpg"
        "${GITHUB_RAW}/landscapes/shaded_landscape.png"
        "${GITHUB_RAW}/landscapes/tropic_island_night.jpg"
        "${GITHUB_RAW}/minimalistic/gradient-synth-cat.png"
    )

    for url in "${sources[@]}"; do
        local name
        name="ctp-$(basename "$url")"
        local out="${STATE_DIR}/${name}"
        [[ -f "$out" && $(stat -c%s "$out" 2>/dev/null || echo 0) -gt 10000 ]] && continue
        curl -sL --max-time 60 -o "$out" "$url" 2>/dev/null &
    done
    wait
    find "$STATE_DIR" -maxdepth 1 -type f -size -10k -delete 2>/dev/null || true
}

pick_random() {
    local dir
    dir=$(resolve_wall_dir)
    local -a walls
    mapfile -t walls < <(find "$dir" -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.webp' \) -size +10k 2>/dev/null)
    (( ${#walls[@]} == 0 )) && return 1

    local prev=""
    [[ -f "$CACHE" ]] && prev=$(cat "$CACHE")

    local pick="${walls[RANDOM % ${#walls[@]}]}"
    if (( ${#walls[@]} > 1 )); then
        while [[ "$pick" == "$prev" ]]; do
            pick="${walls[RANDOM % ${#walls[@]}]}"
        done
    fi
    echo "$pick"
}

update_indicator() {
    local img="$1"
    mkdir -p "$STATE_DIR"
    local c=0
    [[ -f "$COUNT_FILE" ]] && c=$(cat "$COUNT_FILE")
    c=$(( c + 1 ))
    echo "$c" > "$COUNT_FILE"

    local name
    name=$(basename "$img" | sed 's/^ctp-//;s/\.[^.]*$//')
    echo "󰸉 ${name}" > "$INDICATOR"
}

set_wallpaper() {
    local img="$1"
    swww img "$img" \
        --transition-type grow \
        --transition-pos "0.9,0.1" \
        --transition-duration 2 \
        --transition-fps 60 \
        --transition-bezier ".43,1.19,1,.4" 2>/dev/null || \
    swww img "$img" 2>/dev/null || true
    mkdir -p "$STATE_DIR"
    echo "$img" > "$CACHE"
    update_indicator "$img"
}

case "${1:-daemon}" in
    --init)
        fetch_wallpapers &
        swww-daemon &
        sleep 2
        wait
        img=$(pick_random) && set_wallpaper "$img"
        ;;
    --next)
        img=$(pick_random) && set_wallpaper "$img"
        ;;
    --daemon)
        fetch_wallpapers &
        swww-daemon &
        sleep 2
        wait
        while true; do
            img=$(pick_random) && set_wallpaper "$img"
            sleep "$INTERVAL"
        done
        ;;
esac
