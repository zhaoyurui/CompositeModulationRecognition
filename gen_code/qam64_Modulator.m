function y = qam64_Modulator(x,sps)
% 64QAM modulator with unit average power and RRC pulse shaping.
persistent filterCoeffs
if isempty(filterCoeffs)
  filterCoeffs = rcosdesign(0.35, 4, sps);
end
syms = qammod(x,64,'UnitAveragePower',true);
y = filter(filterCoeffs, 1, upsample(syms,sps));
end
