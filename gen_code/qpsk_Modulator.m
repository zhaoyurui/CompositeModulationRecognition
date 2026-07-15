function y = qpsk_Modulator(x,sps)
% QPSK modulator with pi/4 phase offset and RRC pulse shaping.
persistent filterCoeffs
if isempty(filterCoeffs)
  filterCoeffs = rcosdesign(0.35, 4, sps);
end
syms = pskmod(x,4,pi/4);
y = filter(filterCoeffs, 1, upsample(syms,sps));
end
