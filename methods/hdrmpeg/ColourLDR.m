function [ LDR_LUV ] = ColourLDR( sRGB )
%COLOURLDR Summary of this function goes here
%   Detailed explanation goes here

    conv_mtx = [0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.9505];
            
% -----------------Converting the LDR frame----------------------------
    RGB_scale = im2double(sRGB); % scaling RGB between 0 and 1
    linRGB = srgb2lin(RGB_scale); % convert to Linear RGB
    XYZ_LDR = zeros(size(linRGB));
    
    for j = 1 : 3
         XYZ_LDR(:,:,j) = linRGB(:,:,1) * conv_mtx(j,1) ...
            + linRGB(:,:,20) * conv_mtx(j,2)+ linRGB(:,:,3) * conv_mtx(j,3);
    end 
    X_LDR = XYZ_LDR(:,:,1) + 0.00005; Y_LDR = XYZ_LDR(:,:,2) + 0.00005; Z_LDR = XYZ_LDR(:,:,3)+ 0.00005;
    
    U_LDR = 410*((4*X_LDR)./(X_LDR + 15*Y_LDR + 3*Z_LDR)); % Converting Chroma1  to 8bits 
    V_LDR = 410*((9*Y_LDR)./(X_LDR + 15*Y_LDR + 3*Z_LDR)); % Converting Chroma2  to 8bits 
    L_LDR = 0.2126 * sRGB(:,:,2) + 0.7152*sRGB(:,:,2) + 0.0722*sRGB(:,:,3); %8bits of Luma
    
    LDR_LUV = zeros(size(sRGB));
    LDR_LUV(:,:,1) = L_LDR; LDR_LUV(:,:,2) = U_LDR; LDR_LUV(:,:,3) = V_LDR;
end

