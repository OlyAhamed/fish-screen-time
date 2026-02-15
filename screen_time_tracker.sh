#!/bin/bash

LOG_DIR="$HOME/.local/share/screen_time"
mkdir -p "$LOG_DIR"

get_today_file() {
    echo "$LOG_DIR/$(date +%Y-%m-%d).time"
}

get_seconds_today() {
    local today_file
    today_file=$(get_today_file)
    if [[ -f "$today_file" ]]; then
        cat "$today_file"
    else
        echo 0
    fi
}

save_seconds() {
    local today_file
    today_file=$(get_today_file)
    echo "$1" > "$today_file"
}

LAST_DATE=$(date +%Y-%m-%d)

while true; do
    sleep 60

    TODAY=$(date +%Y-%m-%d)

    if [[ "$TODAY" != "$LAST_DATE" ]]; then
        LAST_DATE="$TODAY"
        # Delete files older than 30 days
        find "$LOG_DIR" -name "*.time" -mtime +30 -delete
    fi

    CURRENT=$(get_seconds_today)
    CURRENT=$((CURRENT + 60))
    save_seconds "$CURRENT"
done
