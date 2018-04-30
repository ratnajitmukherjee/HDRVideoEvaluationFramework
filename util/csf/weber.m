function [ out ] = weber( gamma, values, displayluma )
%WEBER Summary of this function goes here
%   Detailed explanation goes here

    out = (gamma ./ values) .* (1 ./ (displayluma .^ (1 ./ gamma)));

end
