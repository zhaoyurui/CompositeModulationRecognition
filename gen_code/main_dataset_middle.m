%% main_dataset_middle.m
%% Generate the Middle-level Compound Modulation Recognition dataset.
%% Inner-layer: 6 types  (BPSK, QPSK, 8PSK, 16QAM, 32QAM, NONE)
%% Outer-layer: 5 types  (LFM, 2FSK, 4FSK, 8FSK, NONE)
%% Total: 6*5-1 = 29 CM types, 2000 samples per type = 58,000 samples.

clear; clc; close all;

ModuClass_01 = ["BPSK", "QPSK", "8PSK", "16QAM", "32QAM", "NONE"];
ModuClass_02 = ["LFM", "2FSK", "4FSK", "8FSK", "NONE"];

fs = 200e6;
fc = 0;
PW = 10e-6;

SampleNum = 2000;
SampleLen = floor(fs*PW);

N_total = SampleNum * (length(ModuClass_01) * length(ModuClass_02) - 1);
X  = zeros(N_total, 2, SampleLen);
Y1 = zeros(N_total, 1);
Y2 = zeros(N_total, 1);

for ModuIndex_01 = 1:length(ModuClass_01)
    for ModuIndex_02 = 1:length(ModuClass_02)
        if ModuIndex_01 == length(ModuClass_01) && ...
                ModuIndex_02 == length(ModuClass_02)
            break;
        end

        for SampleIndex = 1:SampleNum
            Index = ((ModuIndex_01-1)*length(ModuClass_02) + ModuIndex_02-1) * SampleNum + SampleIndex;

            if ModuIndex_01 == length(ModuClass_01)
                x_Modu_01 = ones(SampleLen, 1);
            else
                x_Modu_01 = func_psk_qam(ModuClass_01(ModuIndex_01), fs, fc, PW);
            end

            if ModuIndex_02 == length(ModuClass_02)
                x_Modu_02 = ones(SampleLen, 1);
            else
                x_Modu_02 = func_fsk(ModuClass_02(ModuIndex_02), fs, fc, PW)';
            end

            x_Modu = x_Modu_01 .* x_Modu_02;

            X(Index, 1, :) = squeeze(real(x_Modu));
            X(Index, 2, :) = squeeze(imag(x_Modu));

            Y1(Index, 1) = ModuIndex_01;
            Y2(Index, 1) = ModuIndex_02;
        end
    end
end

if ~isfolder('data'), mkdir('data'); end
save(['data/Modu01_6_Modu02_5_SampleNum_', num2str(SampleNum), '.mat'], ...
    'X', 'Y1', 'Y2', '-v7.3');
fprintf('Middle dataset saved: %d samples\n', N_total);
