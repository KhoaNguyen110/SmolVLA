#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-team_research/configs/smolvla/train_baseline.json}"

echo "[INFO] Config: ${CONFIG_PATH}"
PYTHONWARNINGS="ignore:The video decoding and encoding capabilities of torchvision are deprecated.*:UserWarning:torchvision\\.io\\._video_deprecation_warning" \
PYTHONIOENCODING=utf-8 PYTHONUTF8=1 PYTHONPATH=src \
python -u -X utf8 -m lerobot.scripts.lerobot_train \
  --config_path "${CONFIG_PATH}" \
  --optimizer.lr 5e-5
echo "[INFO] Training done."