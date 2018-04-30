function [ L ] = barten( bitdepth )
%BARTEN Summary of this function goes here
%   Detailed explanation goes here

    %% PU encoding using barten PTF
    A = 71.498068;  B = 94.593053; C = 41.912053;
    D = 9.8247004;  E = 0.28175407;  F = -1.1878455;
    G = -0.18014349;  H = 0.14710899; I = -0.017046845;

    x = linspace(1e-1, 4000, 1e4);
    %x = 0:1/(2^bitdepth - 1):1;

    for i = 1 : numel(x)
        L = x(i);
        dL(i) = A + B*log10(L) + C*(log10(L))^2 + ...
            D*(log10(L))^3 + E*(log10(L))^4 + F*(log10(L))^5 + ....
            G*(log10(L))^6 + H*(log10(L))^7 + I*(log10(L))^8;
    end
    L = interp1(dL, x, 1:1:1024, 'spline');
end
