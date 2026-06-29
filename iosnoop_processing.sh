#!/bin/bash

# 1. Capture precise current wall-clock time (seconds.nanoseconds)
START_WALL=$(date +%s.%N)

INPUT_FILE="${1:-/dev/stdin}"

# 2. Extract columns relative to the end of the line to bypass variable command lengths
awk -v wall="$START_WALL" '
  /Tracing/ || /^STARTs/ { next }
  NF >= 7 { 
    if (base_uptime == "") {
      base_uptime = $1
    }
    
    offset = $1 - base_uptime
    exact_timestamp = wall + offset
    
    # $(NF-5) = PID, $(NF-4) = TYPE, $(NF-3) = DEV, $(NF-2) = BLOCK, $(NF-1) = BYTES, $NF = LATms
    printf "%.6f|%s|%s|%s|%s|%s|%s\n", exact_timestamp, $(NF-3), $(NF-5), $(NF-4), $(NF-2), $(NF-1), $NF
  }
' "$INPUT_FILE" | jq -R -s '
  split("\n") | map(select(length > 0) | split("|")) |
  map({
    "timestamp": (.[0] | tonumber),
    "device": .[1],
    "pid": .[2],
    "type": .[3],  # <-- "R" or "W" injected here
    "block": (.[4] | tonumber),
    "bytes": (.[5] | tonumber),
    "latency_ms": (.[6] | tonumber)
  })
'
