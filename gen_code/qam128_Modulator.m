function y = qam128_Modulator(x,sps)
% 128QAM modulator with unit average power and RRC pulse shaping.
persistent filterCoeffs
if isempty(filterCoeffs)
  filterCoeffs = rcosdesign(0.35, 4, sps);
end
syms = qammod(x,128,'UnitAveragePower',true);
y = filter(filterCoeffs, 1, upsample(syms,sps));
end
