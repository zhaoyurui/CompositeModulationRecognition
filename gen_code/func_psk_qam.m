function y = func_psk_qam(modu_name, fs, fc, T)
% func_psk_qam  Generate PSK/QAM modulated signal at baseband.
%   y = func_psk_qam(MODU_NAME, FS, FC, T) returns the complex baseband
%   signal for modulation type MODU_NAME, with sampling rate FS (Hz),
%   carrier frequency FC (Hz), and pulse width T (seconds).
%
%   Supported types: BPSK, QPSK, 8PSK, 16QAM, 32QAM, 64QAM, 128QAM,
%                    16PSK, 32PSK, 256QAM (extendable via get_Modulator).

spf = floor(T*fs);             % Samples per frame
Rbite = 10e6;                  % Symbol rate: 10 Msps
Tbite = 1/Rbite;
sps = floor(Tbite*fs);         % Samples per symbol
t = (0:1/fs:T-1/fs)';          % Time vector

% Generate random M-ary symbol sequence
dataSrc = get_Source(modu_name, sps, spf, fs);
% Create modulator function handle
modulator = get_Modulator(modu_name, sps, fs);

x = dataSrc();                 % Random symbol sequence
y = modulator(x);              % Modulated waveform
y = y .* exp(1i*2*pi*fc*t);   % Frequency shift (fc=0 for baseband)
