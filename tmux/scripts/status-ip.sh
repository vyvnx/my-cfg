#!/usr/bin/env bash
# public IP + city, cached so the status bar doesn't hit the network on every redraw
set -euo pipefail

cache="${TMPDIR:-/tmp}/tmux-ip-location-$(id -u)"
max_age=30 # seconds

if [[ -f "$cache" ]]; then
  age=$(( $(date +%s) - $(stat -c %Y "$cache") ))
  if (( age < max_age )); then
    cat "$cache"
    exit 0
  fi
fi

info=$(curl -s --max-time 5 https://ipinfo.io/json) || true
ip=$(jq -r '.ip // empty' <<<"$info" 2>/dev/null)

if [[ -n "$ip" ]]; then
  city=$(jq -r '.city // empty' <<<"$info")
  country=$(jq -r '.country // empty' <<<"$info")
  out="$ip · $city, $country"
  echo "$out" > "$cache"
  echo "$out"
elif [[ -f "$cache" ]]; then
  touch "$cache" # network hiccup: serve stale cache, bump mtime so we don't curl again for max_age
  cat "$cache"
else
  echo "offline" > "$cache" # cache the miss too, else every redraw re-curls while offline
  echo "offline"
fi
