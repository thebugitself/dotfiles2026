#!/bin/bash

if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | tr -d ' ' || echo "0"
elif command -v nvtop >/dev/null 2>&1; then
    nvtop -s | jq -r '.[0].gpu_util' | tr -d '%'
else
    echo "0"
fi
