#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_multimodal_port info
PYTHONPATH=src python -m gbt_multimodal_port check --payload '{}'
PYTHONPATH=src python -m gbt_multimodal_port run   --payload '{}'
