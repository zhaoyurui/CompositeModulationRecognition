# Compound Modulation Recognition — Dataset Generation

This repository contains the dataset generation code for the paper:
**"Compound Modulation Recognition via Tangent Space Disentanglement"**

## Requirements

- MATLAB R2021b or later
- Communications Toolbox
- Signal Processing Toolbox

## Quick Start

Run one of the main scripts to generate the corresponding dataset:

```matlab
>> main_dataset_simple    % 4 inner x 4 outer = 15 CM types
>> main_dataset_middle    % 6 inner x 5 outer = 29 CM types
>> main_dataset_hard      % 8 inner x 7 outer = 55 CM types
```

Generated `.mat` files are saved to the `./data/` folder.

## Dataset Specification

| Level  | Inner-layer modulations                          | Outer-layer modulations                    | CM types | Samples/type |
|--------|--------------------------------------------------|--------------------------------------------|----------|-------------|
| Simple | BPSK, QPSK, 8PSK, NONE                           | LFM, 2FSK, 4FSK, NONE                      | 15       | 2,000       |
| Middle | BPSK, QPSK, 8PSK, 16QAM, 32QAM, NONE             | LFM, 2FSK, 4FSK, 8FSK, NONE                | 29       | 2,000       |
| Hard   | BPSK, QPSK, 8PSK, 16QAM, 32QAM, 64QAM, 128QAM, NONE | LFM, 2FSK, 4FSK, 8FSK, MSK, GFSK, NONE | 55       | 2,000       |

### Common Parameters

| Parameter            | Value           |
|----------------------|-----------------|
| Sampling rate        | 200 MHz         |
| Pulse width          | 10 us           |
| Samples per frame    | 2,000           |
| Inner symbol rate    | 10 Msps         |
| Inner sps            | 20              |
| Outer symbol rate    | 2 Msps          |
| LFM bandwidth        | 50 MHz          |
| FSK freq. separation | 10 MHz (2/4FSK), 5 MHz (8FSK) |
| GFSK BT product      | 0.35            |
| MSK initial phase    | pi/4            |
| RRC roll-off         | 0.35            |

### Output Format

Each `.mat` file contains:
- `X`  : `[N, 2, 2000]` — real (channel 1) and imaginary (channel 2) parts
- `Y1` : `[N, 1]` — inner-layer label index (1-based)
- `Y2` : `[N, 1]` — outer-layer label index (1-based)

NONE modulation is represented as an all-ones vector.

## File Structure

```
gen_code/
├── README.md
├── main_dataset_simple.m
├── main_dataset_middle.m
├── main_dataset_hard.m
├── func_psk_qam.m           # Inner-layer signal generator
├── func_fsk.m                # Outer-layer signal generator
├── get_Source.m              # Random symbol source selector
├── get_Modulator.m           # Modulator function-handle selector
├── bpsk_Modulator.m
├── qpsk_Modulator.m
├── psk8_Modulator.m
├── qam16_Modulator.m
├── qam32_Modulator.m
├── qam64_Modulator.m
├── qam128_Modulator.m
├── msk_Modulator.m
└── gfsk_Modulator.m
```

## Citation

If you use this dataset in your research, please cite our paper.
