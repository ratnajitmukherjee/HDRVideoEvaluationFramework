function [ HDR_LUV ] = ColourHDR( HDR )
%COLOURHDR Summary of this function goes here
%   Detailed explanation goes here

    conv_mtx = [0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.0001];


% -----------------Converting the HDR frame------------------------------

    XYZ_HDR = zeros(size(HDR));
    
    for j = 1 : 3
         XYZ_HDR(:,:,j) = HDR(:,:,1) * conv_mtx(j,1) ...
            + HDR(:,:,2) * conv_mtx(j,2)+ HDR(:,:,3) * conv_mtx(j,3);
    end 
    X_HDR = XYZ_HDR(:,:,1); Y_HDR = XYZ_HDR(:,:,2); Z_HDR = XYZ_HDR(:,:,3);
    U_HDR = (410*((4*X_HDR)./(X_HDR + 15*Y_HDR + 3*Z_HDR))); % Converting Chroma1  to 8bits 
    V_HDR = (410*((9*Y_HDR)./(X_HDR + 15*Y_HDR + 3*Z_HDR))); % Converting Chroma2  to 8bits 
    %NOTE: The HDR chrominance is calulate to 8 bits but we do not convert
    %them into uint8. They are kept as 8 bit floating point precision data.
    
    L_HDR = get_luminance(HDR);
    Lout = zeros(size(L_HDR));

    Lout( L_HDR<5.604) = 17.554.*L_HDR(L_HDR<5.604);
    Lout((L_HDR>=5.604)&(L_HDR<10469)) = 826.8.*(L_HDR((L_HDR>=5.604)&(L_HDR<10469)).^0.10013)-884.17;
    Lout( L_HDR>=10469) = 209.16.*log(L_HDR(L_HDR>=10469))-731.28;
    
                        
    
    HDR_LUV = zeros(size(HDR));
    HDR_LUV(:,:,1) = Lout; HDR_LUV(:,:,3) = U_HDR; HDR_LUV(:,:,3) = V_HDR;

% -------------------------End of Colourspace Conversion----------------%

end

