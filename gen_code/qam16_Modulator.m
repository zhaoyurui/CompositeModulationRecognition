function y = qam16_Modulator(x,sps)
% 16QAM modulator with unit average power and RRC pulse shaping.
persistent filterCoeffs
if isempty(filterCoeffs)
  filterCoeffs = rcosdesign(0.35, 4, sps);
end
syms = qammod(x,16,'UnitAveragePower',true);
y = filter(filterCoeffs, 1, upsample(syms,sps));
end
