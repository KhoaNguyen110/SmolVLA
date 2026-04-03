# SmolVLA Course Project (Forked from LeRobot)

> Current repository: `KhoaNguyen110/SmolVLA`  
> This project is forked from the original LeRobot repository and adapted for course implementation requirements.

## 1. Project Scope

This repository contains our course project implementation for **SmolVLA** with three required parts:

- **Implement (mini):** Train the model from scratch on tested datasets for at least 1 epoch.
- **Evaluation (yes):** Evaluate on the test split of all datasets used for training.
- **Ablation (yes):** Benchmark different hyperparameter/component settings.

## 2. Upstream Acknowledgement

- Original project: [huggingface/lerobot](https://github.com/huggingface/lerobot)
- This repo is a fork used for educational/research purposes.

## 3. What We Implemented (Team Contribution)

Our main contributions in this fork are:

1. Reproducible training/evaluation scripts for course experiments.
2. SmolVLA experiment configs for:
   - baseline
   - component ablations (language/state/vision)
   - selected hyperparameter ablations
3. Result collection and summary tables/plots.
4. Implementation-focused report explaining:
   - exact input representation
   - exact output representation
   - experiment setup and findings

## 4. Formulation Clarification (Implementation View)

SmolVLA is trained as a multimodal policy model:

- **Language input:** natural-language task instruction (tokenized text sequence).
- **Robot state input:** proprioceptive state vector (e.g., joints/end-effector/gripper signals, dataset-dependent), normalized.
- **Image input:** RGB image(s) from robot camera(s), resized and normalized.
- **Output:** action prediction sequence (continuous control actions over a horizon, depending on config/task).

## 5. Repository Structure (Added by Team)

```text
configs/
  smolvla/
    baseline.yaml
    ablation_no_language.yaml
    ablation_no_state.yaml
    ablation_single_view.yaml
scripts/
  train.sh
  eval.sh
  run_ablation.sh
results/
  metrics_summary.csv
  plots/
reports/
  final_implement.md
```

## 6. Reproducibility Workflow

### 6.1 Train (mini requirement)

Train from scratch for at least 1 epoch on selected tested dataset(s):

```bash
bash scripts/train.sh configs/smolvla/baseline.yaml
```

### 6.2 Evaluate (yes requirement)

Evaluate on test split of all datasets used for training:

```bash
bash scripts/eval.sh configs/smolvla/baseline.yaml
```

### 6.3 Ablation (yes requirement)

Run ablation settings:

```bash
bash scripts/run_ablation.sh
```

## 7. Reporting Outputs

Please collect and keep:

- train/val loss curves
- test metrics per dataset
- ablation comparison table
- notes on failure cases / qualitative observations

Suggested summary file:

- `results/metrics_summary.csv`

## 8. Team Notes

- We keep core upstream code changes minimal.
- Most modifications are isolated in `configs/`, `scripts/`, `results/`, and `reports/`.
- Any core-code modification should be documented in `reports/final_implement.md`.
