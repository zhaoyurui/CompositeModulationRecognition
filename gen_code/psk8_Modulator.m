function y = psk8_Modulator(x,sps)
% 8PSK modulator with RRC pulse shaping.
persistent filterCoeffs
if isempty(filterCoeffs)
  filterCoeffs = rcosdesign(0.35, 4, sps);
end
syms = pskmod(x,8);
y = filter(filterCoeffs, 1, upsample(syms,sps));
end
