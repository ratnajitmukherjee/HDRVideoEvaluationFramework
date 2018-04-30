function [ out ] = fraunhofer( in )
%FRAUNHOFER Summary of this function goes here
%   Detailed explanation goes here

    bitDepth = 10;
    Y_min = 1e-4;
    Y_max = 1e4;

    out = 2 .^ ((in + 0.5) * (log2(Y_max ./ Y_min) ./ ((2 .^ bitDepth) - 1)) + log2(Y_min));

end

