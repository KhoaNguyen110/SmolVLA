# Final Implement Report — SmolVLA

## 1. Objective

This report documents our implementation for the SmolVLA topic under course requirements:

1. Implement (mini): train from scratch for >= 1 epoch.
2. Evaluation (yes): evaluate on test split of all training datasets.
3. Ablation (yes): compare component/hyperparameter settings.

---

## 2. Implementation-Focused Formulation

### 2.1 Input Modalities

#### A) Language

- Format: natural-language instruction string.
- Processing: tokenization into discrete token IDs + attention masks.
- Role: task-level semantic conditioning.

#### B) Robot State (Proprioception)

- Format: continuous numeric vector (dataset-dependent), e.g. joint states / gripper / end-effector related signals.
- Processing: normalization/scaling as defined by pipeline.
- Role: robot internal state and kinematic context.

#### C) Vision

- Format: RGB image(s) from one or multiple camera views.
- Processing: resize + normalization (+ potential augmentation, config-dependent).
- Role: scene/object/context observation.

### 2.2 Output

- Predicted control action (continuous) over action horizon (config-dependent).
- Used as policy output for robot control / offline policy evaluation.

---

## 3. Experimental Setup

## 3.1 Datasets

List all datasets used for training:

1. `<dataset_1>`
2. `<dataset_2>`
3. ...

> Requirement alignment: each dataset used for training is evaluated on its **test split**.

## 3.2 Training Setup (Baseline)

- Model: SmolVLA
- Initialization: from scratch (as required)
- Epochs: >= 1
- Batch size: `<...>`
- Learning rate: `<...>`
- Seed(s): `<...>`
- Hardware: `<GPU/CPU info>`

Config file:

- `configs/smolvla/baseline.yaml`

---

## 4. Evaluation Protocol

For each training dataset:

- Run evaluation on test split.
- Record main metrics (task success / action error / loss, depending on benchmark support).

### 4.1 Main Results (Fill Table)

| Dataset       | Split | Metric 1 | Metric 2 | Notes |
| ------------- | ----- | -------: | -------: | ----- |
| `<dataset_1>` | test  |          |          |       |
| `<dataset_2>` | test  |          |          |       |

---

## 5. Ablation Study

## 5.1 Ablation Settings

1. **No Language**
   - Remove or neutralize language conditioning.
   - Config: `configs/smolvla/ablation_no_language.yaml`

2. **No State**
   - Remove robot-state conditioning.
   - Config: `configs/smolvla/ablation_no_state.yaml`

3. **Vision Change** (example: single-view or lower resolution)
   - Adjust visual input setting.
   - Config: `configs/smolvla/ablation_single_view.yaml`

4. _(Optional)_ Hyperparameter ablation (LR / horizon / batch size)

## 5.2 Ablation Results (Fill Table)

| Setting     | Dataset       | Metric 1 | Metric 2 | Δ vs Baseline | Observation |
| ----------- | ------------- | -------: | -------: | ------------: | ----------- |
| Baseline    | `<dataset_1>` |          |          |             0 |             |
| No Language | `<dataset_1>` |          |          |               |             |
| No State    | `<dataset_1>` |          |          |               |             |
| Single View | `<dataset_1>` |          |          |               |             |

---

## 6. Key Findings (to present in seminar)

1. Which input modality contributes most?
2. Which ablation causes largest degradation?
3. Is training stable at mini scale (>=1 epoch)?
4. What failure cases were observed?

---

## 7. Reproducibility Commands

```bash
# Baseline train
bash scripts/train.sh configs/smolvla/baseline.yaml

# Baseline eval
bash scripts/eval.sh configs/smolvla/baseline.yaml

# Full ablation sweep
bash scripts/run_ablation.sh
```

---

## 8. Deviations from Upstream

Document any modifications to core upstream code:

- File changed:
- Reason:
- Impact:

If none:

- “No core algorithmic modification; experiments are configured through external configs/scripts.”

---

## 9. Conclusion

This implementation satisfies all requested course levels:

- Implement (mini) ✅
- Evaluation (yes) ✅
- Ablation (yes) ✅

and provides an implementation-level explanation of SmolVLA I/O representation and empirical behavior.
