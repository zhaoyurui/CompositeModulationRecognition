function y = qam32_Modulator(x,sps)
% 32QAM modulator with unit average power and RRC pulse shaping.
persistent filterCoeffs
if isempty(filterCoeffs)
  filterCoeffs = rcosdesign(0.35, 4, sps);
end
syms = qammod(x,32,'UnitAveragePower',true);
y = filter(filterCoeffs, 1, upsample(syms,sps));
end
