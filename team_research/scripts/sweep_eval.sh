#!/usr/bin/env bash
set -euo pipefail

# Usage:
# bash team_research/scripts/sweep_eval.sh \
#   team_research/configs/smolvla/eval_baseline.json \
#   team_research/results/train/smolvla_baseline \
#   team_research/results/eval/sweeps \
#   50

EVAL_CONFIG="${1:-team_research/configs/smolvla/eval_baseline.json}"
TRAIN_DIR="${2:-team_research/results/train/smolvla_baseline}"
SWEEP_OUT="${3:-team_research/results/eval/sweeps}"
N_EPISODES="${4:-50}"

mkdir -p "${SWEEP_OUT}"
CSV_PATH="${SWEEP_OUT}/leaderboard.csv"
echo "checkpoint,avg_sum_reward,avg_max_reward,pc_success,n_episodes,eval_s,eval_ep_s,metrics_json" > "${CSV_PATH}"

echo "[INFO] Eval config : ${EVAL_CONFIG}"
echo "[INFO] Train dir   : ${TRAIN_DIR}"
echo "[INFO] Sweep out   : ${SWEEP_OUT}"
echo "[INFO] n_episodes  : ${N_EPISODES}"

# Tìm checkpoints kiểu checkpoint-00050, checkpoint-05000, ...
mapfile -t CKPTS < <(find "${TRAIN_DIR}" -maxdepth 1 -type d -name "checkpoint-*" | sort -V)

if [ "${#CKPTS[@]}" -eq 0 ]; then
  echo "[ERROR] Không tìm thấy checkpoint-* trong ${TRAIN_DIR}"
  exit 1
fi

for CKPT in "${CKPTS[@]}"; do
  CKPT_NAME="$(basename "${CKPT}")"
  OUT_DIR="${SWEEP_OUT}/${CKPT_NAME}"
  mkdir -p "${OUT_DIR}"

  echo ""
  echo "=============================="
  echo "[INFO] Evaluating ${CKPT_NAME}"
  echo "=============================="

  PYTHONIOENCODING=utf-8 PYTHONUTF8=1 PYTHONPATH=src \
  python -u -X utf8 -m lerobot.scripts.lerobot_eval \
    --config_path "${EVAL_CONFIG}" \
    --policy.pretrained_path "${CKPT}" \
    --eval.n_episodes "${N_EPISODES}" \
    --output_dir "${OUT_DIR}"

  # Tìm metrics json trong OUT_DIR
  METRICS_JSON="$(find "${OUT_DIR}" -type f \( -name "*metrics*.json" -o -name "*eval*.json" -o -name "results.json" \) | head -n 1 || true)"
  if [ -z "${METRICS_JSON}" ]; then
    # fallback: file json bất kỳ
    METRICS_JSON="$(find "${OUT_DIR}" -type f -name "*.json" | head -n 1 || true)"
  fi

  if [ -z "${METRICS_JSON}" ]; then
    echo "[WARN] Không tìm thấy metrics json cho ${CKPT_NAME}"
    echo "${CKPT_NAME},,,,,,,," >> "${CSV_PATH}"
    continue
  fi

  # Parse các field bạn đã show: overall.avg_sum_reward, overall.avg_max_reward, overall.pc_success...
  python - "${CKPT_NAME}" "${METRICS_JSON}" "${CSV_PATH}" << 'PY'
import json,sys
ckpt, path, csv_path = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path, "r", encoding="utf-8") as f:
    d=json.load(f)
ov=d.get("overall",{})
row = [
    ckpt,
    ov.get("avg_sum_reward",""),
    ov.get("avg_max_reward",""),
    ov.get("pc_success",""),
    ov.get("n_episodes",""),
    ov.get("eval_s",""),
    ov.get("eval_ep_s",""),
    path.replace("\\","/"),
]
with open(csv_path, "a", encoding="utf-8") as f:
    f.write(",".join(map(str,row))+"\n")
print("[INFO] Added:", row)
PY

done

echo ""
echo "[INFO] Done sweep."
echo "[INFO] Leaderboard: ${CSV_PATH}"