#!/usr/bin/env bash

set -euo pipefail

DATE_SECONDS=$(date +%S)
echo "Segundos: $DATE_SECONDS"
RESTO=$(expr $DATE_SECONDS % 2)
echo $RESTO
