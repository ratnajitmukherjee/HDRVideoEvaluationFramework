function [ l_lut, P_lut ] = gdf( Lmin, Lmax)
%% constants
 A = 71.498068;  B = 94.593053; C = 41.912053;
 D = 9.8247004;  E = 0.28175407;  F = -1.1878455;
 G = -0.18014349;  H = 0.14710899; I = -0.017046845;
 
 % luminance space 
 if(Lmin<0.05)
     warning('The DICOM grayscale display function starts from 0.05 cd/m2');
     Lmin = 0.05;
 end 
	%Lmax = 4000  %Lmax can be anything but the original curve is 4000 cd/m2.
 JNDStep = 2^10; % this JND step will cover the entire range of luminance
 LinS = linspace(Lmin, Lmax, JNDStep);
 dL = zeros(size(LinS));
 % iteratively calculate the dL from the DICOM standard
 for i = 1 : numel(LinS)
     L = LinS(i);
     dL(i) = A + B*log10(L) + C*(log10(L))^2 + ...
         D*(log10(L))^3 + E*(log10(L))^4 + F*(log10(L))^5 + ....
         G*(log10(L))^6 + H*(log10(L))^7 + I*(log10(L))^8;
 end 
 l_lut = log10(LinS);
 P_lut = dL;  
end

