function [ RGB_HDR ] = frn_yuv2rgb( HDR_LUV, s, bitDepth, multfactor)
%% yuv2rgb: conversion from decoded LUV to 16 RGB

%% header information
    inv_mtx =[  3.2406,-1.5372,-0.4986;...
                -0.9689,1.8757,0.0415;...
                0.0557,-0.2040,1.0569   ];
            
    Y_min = double(s.ymin); Y_max = double(s.ymax);
      
%% extraction of LUV channels
    L_HDR = double(HDR_LUV(:,:,1));
    U_HDR = double(HDR_LUV(:,:,2));
    V_HDR = double(HDR_LUV(:,:,3));

%% expansion of 12 but luma to 16 bit luminance
   Y = 2.^((L_HDR + 0.5)*(log2(Y_max/Y_min)./(2^bitDepth -1)) + log2(Y_min));

%% Conversion and expansion of chroma channels
   U_HDR = (U_HDR+0.05)./multfactor;
   V_HDR = (V_HDR+0.05)./multfactor;

%% XYZ creation
   X_HDR = 9*U_HDR./ (6*U_HDR - 16*V_HDR + 12);
   Y_HDR = 4*V_HDR./ (6*U_HDR - 16*V_HDR + 12);
   Z_HDR = 1 - X_HDR - Y_HDR;
   
   normalization = RemoveSpecials(Y./Y_HDR);
   XYZ_HDR = zeros(size(HDR_LUV));
   
   XYZ_HDR(:,:,1) = X_HDR .* normalization;
   XYZ_HDR(:,:,2) = Y;
   XYZ_HDR(:,:,3) = Z_HDR .* normalization;

%% Final decoded RGB creation
   RGB_HDR = zeros(size(XYZ_HDR));
   
   for j = 1:3
        RGB_HDR(:,:,j) = XYZ_HDR(:,:,1) * inv_mtx(j,1) ...
                       + XYZ_HDR(:,:,2) * inv_mtx(j,2) ...
                       + XYZ_HDR(:,:,3) * inv_mtx(j,3);
   end 
   
end

