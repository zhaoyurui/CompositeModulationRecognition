function src = get_Source(modType, sps, spf, fs)
% get_Source  Return a random symbol source for a given modulation type.
%   SRC = get_Source(TYPE, SPS, SPF, FS) returns a function handle that,
%   when called, generates a random M-ary integer column vector.
%   M is determined by the modulation order of TYPE.

switch modType
  case {"BPSK","GFSK","2FSK","MSK","GMSK","DBPSK","2ASK"}
    M = 2;
    src = @()randi([0 M-1],spf/sps,1);
  case {"QPSK","PAM4","4FSK","OQPSK","DQPSK","4ASK"}
    M = 4;
    src = @()randi([0 M-1],spf/sps,1);
  case {"8PSK","PAM8","D8PSK"}
    M = 8;
    src = @()randi([0 M-1],spf/sps,1);
  case {"16QAM","16APSK","16PSK"}
    M = 16;
    src = @()randi([0 M-1],spf/sps,1);
  case {"32APSK","32PSK","32QAM"}
    M = 32;
    src = @()randi([0 M-1],spf/sps,1);
  case "64QAM"
    M = 64;
    src = @()randi([0 M-1],spf/sps,1);
  case "128QAM"
    M = 128;
    src = @()randi([0 M-1],spf/sps,1);
  case "256QAM"
    M = 256;
    src = @()randi([0 M-1],spf/sps,1);
  case {"B-FM","DSB-AM","SSB-AM"}
    src = @()get_Audio(spf,fs);
end
end
