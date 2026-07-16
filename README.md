# TSDN: Tangent Space Disentanglement Network for Compositional Zero-Shot Composite Modulation Recognition

Official implementation of the paper **"Compositional Zero-Shot Recognition based on Tangent Space Disentanglement for Composite Modulation Signals"** (IEEE TCCN, 2026, under review).

ARXIV: https://arxiv.org/pdf/2607.13463

## Overview

Automatic Composite Modulation Recognition (ACMR) is critical for Integrated Sensing and Communication (ISAC) systems. This repository provides:

- **Dataset generation code** (MATLAB): Composite modulation signal generation with logarithmic projection preprocessing
- **Method implementation** (PyTorch): Tangent Space Disentanglement Network (TSDN) for compositional zero-shot recognition
- **Experiment results**: Comprehensive benchmark against 9 baselines with ablation studies

TSDN achieves **>93% compositional zero-shot recognition accuracy** and maintains robust performance under joint channel fading and hardware imperfections down to 4 dB SNR.

## Key Idea

Composite modulation (CM) signals are formed by multiplying an inner communication modulation (e.g., 16QAM, BPSK) with an outer sensing modulation (e.g., LFM, FSK). TSDN tackles three challenges:

1. **Logarithmic projection** linearizes the multiplicative coupling between modulation layers
2. **Spatial Transformer Network (STN)** learns a geometric transformation to disentangle layer-wise semantic features
3. **Multi-objective loss** (CrossEntropy + CenterLoss + DiffLoss) balances intra-class discrimination with cross-domain generalization

---

## Repository Structure

| Directory          | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| gen_code/          | MATLAB scripts for composite modulation signal generation    |
| Dataset/           | Pre-generated composite modulation dataset (.mat format)     |
| code/              | PyTorch implementation of TSDN and baseline models           |
| ResultPlot/        | Experiment result visualization                              |

---

## Dataset Generation

### Composite Modulation Signals

The dataset consists of composite modulation signals formed by pairing:

| Layer                 | Type    | Modulation Schemes     |
| --------------------- | ------- | ---------------------- |
| Inner (communication) | PSK/QAM | 16QAM, MSK, BPSK, QPSK |
| Outer (sensing)       | LFM/FSK | LFM, 2FSK, 4FSK        |

A "NONE" layer is included for each side, enabling single-modulation baselines. Total: 4 × 3 = 12 composite types + 7 single-modulation types.

### Signal Generation

Run gen_code/main_01.m to generate the dataset:

`matlab
% Key parameters
fs = 200e6;          % Sampling frequency (200 MHz)
PW = 10e-6;          % Pulse width (10 μs)
SampleNum = 1000;    % Samples per modulation type
SampleLen = 2000;    % Time-domain samples per pulse
`
### Output

The generated dataset is saved as Dataset/Modu01_4_Modu02_3_SampleNum_1000.mat:

- X: signal data, shape [N, 2, SampleLen] (I/Q channels)
- Y1: inner modulation label (5 classes)
- Y2: outer modulation label (4 classes)

---

## Method: TSDN

### Architecture

TSDN is built on the Domain Separation Networks (DSN) framework with three key innovations:

`
Input [B, 2, L]  ──►  log(·)  ──►  ┌─ STN_Y ──► Encoder_Y ──► Branch_Y ──► ŷ_inner
                                     │
                                     └─ STN_Z ──► Encoder_Z ──► Branch_Z ──► ŷ_outer
`

### Key Components

| Component                 | File                         | Description                                                  |
| ------------------------- | ---------------------------- | ------------------------------------------------------------ |
| Logarithmic Mapping       | rain_simple.py:train_epoch() | orch.log(data + 1e-8) applied to I/Q input                   |
| Spatial Transformer (STN) | stn_model.py                 | TimeSeriesSTN: learnable 2D affine geometric transformation for time-series data |
| TSDN Model (with STN)     | model_compat_stn.py          | DSN_Conv1D, DSN_ResNet18, DSN_Transformer variants with separate Y/Z branches |
| Ablation Models (no STN)  | model_compat_no_stn.py       | Same architectures without spatial transform for ablation study |
| Baseline Models           | model_compat.py              | DSN, DSN_Conv1D, DSN_RNN, DSN_LSTM, DSN_GRU, DSN_BiLSTM, DSN_Transformer |
| Hyperbolic Geometry       | hyperbolic_trans.py          | Lorentz model projection (lorentz_expmap0/lorentz_logmap0) for geometric disentanglement |

### Loss Functions

| Loss             | File             | Purpose                                                 |
| ---------------- | ---------------- | ------------------------------------------------------- |
| CrossEntropyLoss | PyTorch built-in | Classification accuracy on each branch                  |
| CenterLoss       | unctions.py      | Intra-class compactness                                 |
| DiffLoss         | unctions.py      | Orthogonality constraint between Y and Z feature spaces |
| MSE / SIMSE      | unctions.py      | Reconstruction loss (auxiliary)                         |

Training follows a **two-phase schedule**:

- **Phase 1**: L = L_CE + L_Center (discrimination)
- **Phase 2**: L = L_CE + L_Center + L_Diff (add disentanglement)

### Channel Impairments

The dd_channel_impairments_advanced() function in 	rain_simple.py simulates realistic ISAC channel conditions:

- AWGN (configurable SNR range)
- Carrier frequency offset
- Phase noise


---

## Citation

If you find this work useful, please cite:

`bibtex
@article{zhao2025compositional,
  title={Compositional Zero-Shot Recognition based on Tangent Space Disentanglement for Composite Modulation Signals},
  author={Zhao, Yurui and Wang, Xiang and Huang, Zhitao and Li, Baoguo},
  journal={IEEE Transactions on Cognitive Communications and Networking},
  year={2026},
  note={Under review, IEEE Transactions on Cognitive Communications and Networking}
}
`

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

**Authors**: Yurui Zhao, Xiang Wang, Zhitao Huang, Baoguo Li  
**Affiliation**: College of Electronic Science and Technology, National University of Defense Technology, Changsha, China  
**Contact**: xwang@nudt.edu.cn
