function y = bpsk_Modulator(x,sps)
% BPSK modulator with root-raised-cosine pulse shaping.
persistent filterCoeffs
if isempty(filterCoeffs)
  filterCoeffs = rcosdesign(0.35, 4, sps);
end
syms = pskmod(x,2);
y = filter(filterCoeffs, 1, upsample(syms,sps));
end
