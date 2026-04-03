#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-team_research/configs/smolvla/eval_baseline.json}"
PYTHON_BIN="${PYTHON_BIN:-python}"


echo "[INFO] Eval config: ${CONFIG_PATH}"
echo "[INFO] Python: ${PYTHON_BIN}"

PYTHONIOENCODING=utf-8 PYTHONUTF8=1 PYTHONPATH=src \
"${PYTHON_BIN}" -u -X utf8 -m lerobot.scripts.lerobot_eval \
  --config_path "${CONFIG_PATH}"