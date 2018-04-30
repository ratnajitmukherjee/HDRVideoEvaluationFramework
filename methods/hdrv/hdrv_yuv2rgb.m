function [ HDR16 ] = hdrv_yuv2rgb( HDR11, bits, mf)
%YUV2RGB Summary of this function goes here
%   Detailed explanation goes here

    inv_mtx =[3.2406,-1.5372,-0.4986;...
         -0.9689,1.8757,0.0415;...
          0.0557,-0.2040,1.0569];

    L_HDR = HDR11(:,:,1); % Extracting Luminance Channel         
    U_LDR = HDR11(:,:,2); % Extracting Chrominance Channel 2
    V_LDR = HDR11(:,:,3); % Extracting Chrominance Channel 3       
    
   % ---------Inverse Conversion of 11 bit Luma to Luminance-----------------%
   L_HDR16 = pu_encode(L_HDR, 'backward', bits);
   L_HDR16 = L_HDR16./mf;
    % -------------Inverse Conversion from LUV to XYZ to RGB-----------------%
    
    % extraction of chroma channels
    multfactor = round(2^bits/0.62);

    u_hdr = (U_LDR + 0.05)./multfactor; % uv conversion [0 - 1]
    v_hdr = (V_LDR + 0.05)./multfactor; 
    
    X_HDR = 9*u_hdr./ (6*u_hdr - 16*v_hdr + 12);
    Y_HDR = 4*v_hdr./ (6*u_hdr - 16*v_hdr + 12);
    Z_HDR = 1 - X_HDR - Y_HDR;
   
   normalization = RemoveSpecials(L_HDR16./Y_HDR);
   XYZ_HDR = zeros(size(HDR11));
   
   XYZ_HDR(:,:,1) = X_HDR .* normalization;
   XYZ_HDR(:,:,2) = L_HDR16;
   XYZ_HDR(:,:,3) = Z_HDR .* normalization;
   
   DEC_HDR = zeros(size(XYZ_HDR));
   
   for j = 1:3
        DEC_HDR(:,:,j) = XYZ_HDR(:,:,1) * inv_mtx(j,1) ...
                       + XYZ_HDR(:,:,2) * inv_mtx(j,2) ...
                       + XYZ_HDR(:,:,3) * inv_mtx(j,3);
   end    
      
   HDR16 = DEC_HDR; % decoded 16 bit hdr
   
end

