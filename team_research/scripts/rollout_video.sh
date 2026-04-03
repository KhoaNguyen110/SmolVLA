#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-team_research/configs/smolvla/train_baseline.json}"
CKPT_PATH="${2:-team_research/outputs/train/smolvla_baseline/checkpoint-00050}"
OUT_VIDEO="${3:-team_research/results/plots/rollout_ckpt50.mp4}"
FPS="${4:-10}"

mkdir -p "$(dirname "${OUT_VIDEO}")"

echo "[INFO] Config     : ${CONFIG_PATH}"
echo "[INFO] Checkpoint : ${CKPT_PATH}"
echo "[INFO] Out video  : ${OUT_VIDEO}"

# Ghi toàn bộ log ra file để làm báo cáo
LOG_PATH="${OUT_VIDEO%.mp4}.log"

PYTHONIOENCODING=utf-8 PYTHONUTF8=1 PYTHONPATH=src \
python -u -X utf8 -m lerobot.scripts.lerobot_record \
  --config_path "${CONFIG_PATH}" \
  --policy.pretrained_path "${CKPT_PATH}" \
  --output_path "${OUT_VIDEO}" \
  --fps "${FPS}" \
  2>&1 | tee "${LOG_PATH}"

echo "[INFO] Rollout done."
echo "[INFO] Video: ${OUT_VIDEO}"
echo "[INFO] Log  : ${LOG_PATH}"