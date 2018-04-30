function [s] = funcGenerator( lmin, lmax, bitdepth)
%FUNCGENERATOR Summary of this function goes here
%   Detailed explanation goes here

    s.pub = bartenPTF(bitdepth);
    s.pur = hdrvPTF(lmin, lmax, bitdepth);
    s.puf = frnPTF(lmin, lmax, bitdepth);
    %s.pud = dolbyPTF(lmin, lmax, bitdepth);    
%     s.pus = srgbPTF(lmin, lmax, bitdepth);
    %s.pubbc = bbcPTF(lmin, lmax, bitdepth);
    s.pupr = proposedPTF(lmin, lmax, bitdepth);
    s.pugcrm = coneResponse(lmin, lmax, bitdepth);
%     s.pug = gamma4(lmin, lmax, bitdepth);
%     s.puvdp = vdp(lmin, lmax, bitdepth);
%     plottingFunction(s);
end

function [ pub ] = bartenPTF(bitdepth)
%% PU encoding using GDF
% constants        
    a = -1.3011877; b = -2.5840191E-2; c = 8.0242636E-2; d = -1.0320229E-1;
    e = 1.3646699E-1; f =2.8745620E-2; g = -2.5468404E-2; h = -3.1978977E-3; 
    k = 1.2992634E-4; m = 1.3635334E-3;
%% JND steps
    JND = [1:2^bitdepth-1];    
    loglum = zeros(size(JND));
    for i = 1 : numel(JND)
        j = JND(i);
        loglum(i) = (a + c*log(j) + e*(log(j)^2) + g*(log(j)^3) + m*(log(j)^4))./...
                    (1 + b*log(j) + d*(log(j)^2) + f*(log(j)^3) + h*(log(j)^4) + k*(log(j)^5));
    end     
    luminance = 10.^(loglum);   
    pub(:,1) = luminance';
    pub(:,2) = JND';
 
 
end

function [pur] = hdrvPTF(lmin, lmax, bitdepth)
%% perceptually uniform encoding using HDRV TVI data
    pu = csvread('purafal.csv');
    l_lut = log10(pu(:, 1));
    P_lut = pu(:,2);
    y = linspace(lmin, lmax, 2^bitdepth);    
    L = interp1(l_lut, P_lut, y, 'spline');
    pur(:,1) = 10.^y;
    pur(:,2) = L; % there is no scaling required for this.
end 

function [puf] = frnPTF(lmin, lmax, bitdepth)
%% luminance to luma mapping based on bitdepth
    Y = logspace(lmin, lmax, 2^bitdepth);    
    Y_min = min(Y); Y_max = max(Y);
    L =floor(((2^bitdepth - 1)./log2(Y_max/Y_min)) .* (log2(Y) - log2(Y_min)));
    puf(:,1) = Y;
    puf(:,2) = L;
end 

function [pud] = dolbyPTF(lmin, lmax, bitdepth)
%% Dolby PQ PTF
    y = linspace(0, 1, 2^bitdepth);
    
    % constants
    m1 = (2610 / 4096) * (1 / 4);
    m2 = (2523 / 4096) * 128;    
    c1 = 3424 / 4096;
    c2 = (2413 / 4096) * 32;
    c3 = (2392 / 4096) * 32;
          
    L = (((y.^m1 * c2) + c1) ./ (1 + (y.^m1 * c3))).^m2;
    
    % scaling function call
    Ls = scalingFunction(L);
    Y = logspace(lmin, lmax, 2^bitdepth);
    pud(:,1) = Y;
    pud(:,2) = Ls;
end 

function [pubbc] = bbcPTF(lmin, lmax, bitdepth)

    y = linspace(0, 1, 2^bitdepth);
    % constants
    r = 0.5; a = 0.17883277; b = 0.28466892; c = 0.55991073;

    % forward conversion of Hybrid-log gamma
    Ys = y .*12; % normalizing y=[0, 12] 
    Lp = zeros(size(Ys));
    Lp(Ys<=1) = r.*sqrt(Ys(Ys<=1));
    Lp(Ys>1) = a.*log(Ys(Ys>1) - b) + c;
    
    % raising it to the system gamma
    Lp = Lp.^(1/1.2);
    
    Y = logspace(lmin, lmax, 2^bitdepth);
    Ls = scalingFunction(Lp);
    
    pubbc(:,1) = Y;
    pubbc(:,2) = Ls;
end 

function [puproposed] = proposedPTF(lmin, lmax, bitdepth)
%% proposed Perceptual transfer function
    y = logspace(lmin, lmax, 2^bitdepth);
    L_HDR = y;  
    Lout1 = zeros(size(L_HDR));
    Lout1( L_HDR<0.007) = 2285.712*L_HDR(L_HDR<0.007);
    Lout1((L_HDR>=0.007)&(L_HDR<100)) = 224.1745*(L_HDR((L_HDR>=0.007)&(L_HDR<100)).^(1/5))-67.1009;
    Lout1( L_HDR>=100) = 263.5*log10(L_HDR(L_HDR>=100)) - 31;
%     Lout1( L_HDR<0.01) = 3199.99*L_HDR(L_HDR<0.01);
%     Lout1((L_HDR>=0.01)&(L_HDR<100)) = 274.5114*(L_HDR((L_HDR>=0.01)&(L_HDR<100)).^(1/6))-95.4169;
%     Lout1( L_HDR>=100) = 263.5*log10(L_HDR(L_HDR>=100)) - 31; 
    L = Lout1;    
    puproposed(:,1) = y;
    puproposed(:,2) = L;
end 

function [pugcrm] = coneResponse(lmin, lmax, bitdepth)
%% function to plot Global Cone Response model
    Y = logspace(lmin, lmax, 2^bitdepth);    
    Smin = 0; Smax = 2^bitdepth - 1;    
    Lmax = max(Y(:));
    Lmin = min(Y(:));    
    L = Y;
    Lmean = mean(Y(:));
    c1 = (Smax - Smin)./((Lmax./(Lmax +17.4*Lmean^0.63)) - (Lmin./(Lmin +17.4*Lmean^0.63)));
    c2 = Smin - (c1*Lmin)./(Lmin + 17.4*Lmean^0.63);
    S = (c1.*L)./(L + 17.4*Lmean^0.63) + c2;           
    Lout = S;
    pugcrm(:,1) = Y;
    pugcrm(:,2) = Lout;
end 


% function [pusrgb] = srgbPTF(lmin, lmax, bitdepth)
% %% srgb non-linearity based on average gamma
% 
%     y = linspace(lmin, lmax, 2^bitdepth);
%     p1 = 9.016e-08; p2 = 4.129e-06; p3 = 8.619e-05; p4 = 0.001237;
%     p5 = 0.01422; p6 = 0.1346; p7 = 1.019; p8 = 5.788; p9 = 21.91;
%     p10 = 41.48;
%     L = zeros(size(y));
%     for i = 1:numel(y)
%         x = y(i);
%         L(i) = p1*x^9 + p2*x^8 + p3*x^7 + p4*x^6 + p5*x^5 + p6*x^4 + p7*x^3 + p8*x^2 + p9*x + p10;
%     end
%     L(L<1e-5) = 1e-5;
%     Ls = scalingFunction(L);
%     
%     pusrgb(:,1) = 10.^(y);
%     pusrgb(:,2) = Ls;
% 
% end 
% 
% function [pug] = gamma4(lmin, lmax, bitdepth)
%     x = linspace(0, 1, 2^bitdepth);
%     y = x.^(1/4);
%     xs = linspace(10^lmin, 10^lmax, 2^bitdepth);
%     ys = scalingFunction(y);    
%     
%     pug(:,1) = xs;
%     pug(:,2) = ys;
% end 
% 
% function [puvdp] = vdp(lmin, lmax, bitdepth)
%     Y = linspace(10^lmin, 10^lmax, 2^bitdepth);
%     L_HDR = Y;
%     Lout1 = zeros(size(L_HDR));
%     Lout1( L_HDR<0.061843) = 769.18.*L_HDR(L_HDR<0.061843) - 1e-5;
%     Lout1((L_HDR>=0.061843)&(L_HDR<164.10)) = 449.12.*(L_HDR((L_HDR>=0.061843)&(L_HDR<164.10)).^0.16999)-232.25;
%     Lout1( L_HDR>=164.10) = 181.7.*log(L_HDR(L_HDR>=164.10)) - 90.160;
%     
%     Ls = scalingFunction(Lout1);
%     puvdp(:,1) = Y; puvdp(:,2) = Ls;
%         
% end 
%     

%% accessory utility functions

function [Ls] = scalingFunction(L)
%% this function scales the matrix such that the xdata and ydata is [0-10^4] and [0-1023] respectively
    newmin = 1e-5; newmax = 1023;
    Ls = (((L - min(L)).*(newmax - newmin))./(max(L) - min(L))) + newmin;
end


function plottingFunction(s)
    plot(s.pub(:,1), s.pub(:,2), s.pur(:,1), s.pur(:,2), s.puf(:,1), s.puf(:,2), s.pud(:,1), s.pud(:,2), s.pud(:,1), s.pud(:,2),s.pubbc(:,1), s.pubbc(:,2), s.pupr(:,1), s.pupr(:,2),  'LineWidth', 2);
%     plot(s.pub(:,1), s.pub(:,2), s.pur(:,1), s.pur(:,2), s.puf(:,1), s.puf(:,2), s.pud(:,1), s.pud(:,2), s.pus(:,1), s.pus(:,2), s.pubbc(:,1), s.pubbc(:,2), s.pupr(:,1), s.pupr(:,2), 'LineWidth', 2);
    xlabel('Luminance \in [10^{-5}, 10^4] cd/m^2', 'FontSize', 25, 'FontWeight', 'bold'); ylabel('luma \in [0, 1023]', 'FontSize', 25, 'FontWeight', 'bold');         
    set(gca, 'FontSize', 20); grid on;
    PTFs = {'GDF', 'hdrv', 'fraunhofer', 'PQ', 'bbc-hlg', 'proposed'};
    legend(PTFs, 'Orientation', 'horizontal', 'Location', 'southeast', 'FontSize', 20);    
end 