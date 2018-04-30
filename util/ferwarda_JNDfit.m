function [ L, T ] = ferwarda_JNDfit( lmin, lmax, bitdepth )
%FERWARDA_JNDFIT: This fit is from the Ward...
   
   L = linspace(10^lmin, 10^lmax, 2^bitdepth);
   logL = log10(L);
   logT = zeros(size(logL));
    logT( logL<-3.94) = -2.86;
    logT((logL>=-3.94)&(logL<-1.44)) = (0.405.*logL((logL>=-3.94)&(logL<-1.44)) + 1.6).^2.18 - 2.86;
    logT((logL>=-1.44)&(logL<-0.0184)) = logL((logL>=-1.44)&(logL<-0.0184)) - 0.395;
    logT((logL>=-0.0184)&(logL<1.9)) = (0.249.*logL((logL>=-0.0184)&(logL<1.9)) + 0.65).^2.7 - 0.72;
    logT(logL>=1.9) = logL(logL>=1.9) - 1.255;
    
    T = 10.^(logT - 0.95);

end

