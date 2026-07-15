function y = msk_Modulator(x,sps)
% MSK modulator with InitialPhaseOffset = pi/4.
persistent mod
if isempty(mod)
  mod = comm.MSKModulator(...
    'BitInput', true, ...
    'InitialPhaseOffset', pi/4, ...
    'SamplesPerSymbol', sps);
end
y = mod(x);
end
