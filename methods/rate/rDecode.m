function hdr = rDecode(ldrFrame, ratioFrame, s)   

epsilon = 0.05;     % as in the original paper
fSaturation = 0.6;  % as in the original paper
ratioMin = s.minVal;
ratioMax = s.maxVal;
    
% decompression of the LDR frame
    linRGB = srgb2lin(im2double(ldrFrame));
    schlickVal = 1.0/fSaturation;
    linRGB = ColorCorrection(linRGB, schlickVal); 

% decompression and expansion of the Ratio Frame    
    ratioFrame = im2double(ratioFrame);
    Y_ratio = double((ratioFrame .* (ratioMax - ratioMin)) + ratioMin);
    
% expanding luminance from the LDR frame
    Y_ldr = lum(linRGB);
    Y_hdr = (Y_ldr + epsilon) .* exp(Y_ratio);    
    
% reconstructing the HDR frame
      hdr = ChangeLuminance(linRGB, Y_ldr, Y_hdr);
      hdr = ClampImg(hdr, 1e-5, max(hdr(:)));
end