function [ HDR_LUV ] = hdrv_rgb2yuv( HDR, bitdepth )
%COLOURHDR Summary of this function goes here
%   Detailed explanation goes here

     conv_mtx = [0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.9505];


% -----------------Converting the HDR frame------------------------------

    HDR = ClampImg(HDR, 1e-4, max(HDR(:)));

    XYZ_HDR = zeros(size(HDR));
    
    for j = 1 : 3
         XYZ_HDR(:,:,j) = HDR(:,:,1) * conv_mtx(j,1) ...
            + HDR(:,:,2) * conv_mtx(j,2)+ HDR(:,:,3) * conv_mtx(j,3);
    end 
    X_HDR = XYZ_HDR(:,:,1); Y_HDR = XYZ_HDR(:,:,2); Z_HDR = XYZ_HDR(:,:,3);
    
    %% Calculating the multiplying factor for u' and v'
    multFactor = round((2^bitdepth)/0.62);
    U_HDR = multFactor.*((4*X_HDR)./(X_HDR + 15*Y_HDR + 3*Z_HDR)); % Converting Chroma1  to n-bits 
    V_HDR = multFactor.*((9*Y_HDR)./(X_HDR + 15*Y_HDR + 3*Z_HDR)); % Converting Chroma2  to n-bits     
    
    %% getting 16 bit luminance
    Y_HDR = get_luminance(HDR); % Passing this luminance
    HDR_LUV = zeros(size(HDR));
    HDR_LUV(:,:,1) = Y_HDR; HDR_LUV(:,:,2) = U_HDR; HDR_LUV(:,:,3) = V_HDR;    

% -------------------------End of Colourspace Conversion----------------%

end

