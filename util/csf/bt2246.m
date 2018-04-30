function [ o ] = bt2246( u )
%BT2246 Summary of this function goes here
%   Detailed explanation goes here

    k = 3.0;
    T = 0.1;
    n = 0.03;
    sigma = 0.5;
    Xmax = 12;
    Phi0 = 3e-8;
    %Cab = 0.08;
    Nmax = 15;
    u0 = 7;
    X0 = 60;
    p = 1.2274e6;

    Mopt = exp(-2 * (pi^2) * (sigma^2) * (u^2));
    Fu = exp(-((u / u0) ^ 2));

    o = (Mopt / k) ./ sqrt((2 / T) * ((1 / (X0 ^ 2)) + (1 / (Xmax ^ 2)) + ((u ^ 2) / (Nmax ^ 2))) * (1 / (n * p * E) + (Phi0 / (1 - Fu))));

end
