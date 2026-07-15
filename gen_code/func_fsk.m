function y = func_fsk(modu_name, fs, fc, T)
% func_fsk  Generate FSK/LFM/MSK/GFSK modulated signal at baseband.
%   y = func_fsk(MODU_NAME, FS, FC, T) returns the complex baseband
%   signal for sensing modulation type MODU_NAME.
%
%   Supported: LFM, 2FSK, 4FSK, 8FSK, MSK, GMSK, GFSK

switch modu_name
    case "LFM"
        B = 50e6;                     % Bandwidth: 50 MHz
        t = (0:1/fs:T-1/fs);          % Time vector
        K = B/T;                      % Chirp rate
        s_baseband = exp(1i*pi*K*t.^2);
        y = s_baseband .* exp(-1i*2*pi*B*t/2);

    case "2FSK"
        freq_sep = 10e6;              % Frequency separation: 10 MHz
        data_2fsk = randi([0,1], 1, 20);  % 20 binary symbols
        symbol_duration = T/length(data_2fsk);
        samples_per_symbol = round(fs * symbol_duration);
        f0_2fsk = fc - freq_sep/2;
        f1_2fsk = fc + freq_sep/2;
        s_2fsk = [];
        for i = 1:length(data_2fsk)
            t_symbol = (0:samples_per_symbol-1)/fs;
            if data_2fsk(i) == 0
                symbol = exp(1i*2*pi*f0_2fsk*t_symbol);
            else
                symbol = exp(1i*2*pi*f1_2fsk*t_symbol);
            end
            s_2fsk = [s_2fsk symbol];
        end
        y = s_2fsk;

    case "4FSK"
        freq_sep = 10e6;              % Frequency separation: 10 MHz
        data_4fsk = randi([0,3], 1, 10);  % 10 quaternary symbols
        symbol_duration_4fsk = T/length(data_4fsk);
        samples_per_symbol_4fsk = round(fs * symbol_duration_4fsk);
        freq_4fsk = fc + [-3*freq_sep/2, -freq_sep/2, freq_sep/2, 3*freq_sep/2];
        s_4fsk = [];
        for i = 1:length(data_4fsk)
            t_symbol = (0:samples_per_symbol_4fsk-1)/fs;
            freq_idx = data_4fsk(i) + 1;
            symbol = exp(1i*2*pi*freq_4fsk(freq_idx)*t_symbol);
            s_4fsk = [s_4fsk symbol];
        end
        y = s_4fsk;

    case "8FSK"
        freq_sep = 5e6;               % Frequency separation: 5 MHz
        data_8fsk = randi([0,7], 1, 10);  % 10 octal symbols
        symbol_duration_8fsk = T/length(data_8fsk);
        samples_per_symbol_8fsk = round(fs * symbol_duration_8fsk);
        freq_8fsk = fc + [-7*freq_sep/2, -5*freq_sep/2, -3*freq_sep/2, -freq_sep/2, ...
                           freq_sep/2, 3*freq_sep/2, 5*freq_sep/2, 7*freq_sep/2];
        s_8fsk = [];
        for i = 1:length(data_8fsk)
            t_symbol = (0:samples_per_symbol_8fsk-1)/fs;
            freq_idx = data_8fsk(i) + 1;
            symbol = exp(1i*2*pi*freq_8fsk(freq_idx)*t_symbol);
            s_8fsk = [s_8fsk symbol];
        end
        y = s_8fsk;

    case {"MSK", "GMSK", "GFSK"}
        spf = floor(T*fs);
        Tbite = T/10;
        sps = round(fs * Tbite);
        t = (0:1/fs:T-1/fs)';
        dataSrc = get_Source(modu_name, sps, spf, fs);
        modulator = get_Modulator(modu_name, sps, fs);
        x = dataSrc();
        y = modulator(x);
        y = y .* exp(1i*2*pi*fc*t);
        y = y';
end
