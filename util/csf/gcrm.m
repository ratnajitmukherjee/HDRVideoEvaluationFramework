function [ Yout ] = gcrm( Yin, bitdepth )
%% function to generate the Y reconstruction of GCRM
% generate encoding from GCRM
    Smin = 0; Smax = 2^bitdepth - 1;    
    Lmax = max(Yin(:));
    Lmin = min(Yin(:));    
    L = Yin;
    Lmean = mean(Yin(:));
    c1 = (Smax - Smin)./((Lmax./(Lmax +17.4*Lmean^0.63)) - (Lmin./(Lmin +17.4*Lmean^0.63)));
    c2 = Smin - (c1*Lmin)./(Lmin + 17.4*Lmean^0.63);
    S = (c1.*L)./(L + 17.4*Lmean^0.63) + c2;           
    Lout = S;
    
% generate decoding from GCRM        
    S = Lout;        
    Z = 17.4*(Lmean)^0.63;
    Y = Z./((c1./(S - c2)) - 1);
    Yout = Y;    
end

