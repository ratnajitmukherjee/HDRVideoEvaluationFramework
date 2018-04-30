function [ sRGB ] = LDRStream( HDR )
%LDRSTREAM : Tonemaps and encodes the LDR stream
%   Tonemap HDR images to LDR frames using Reinhard TMO and convert sRGB to
%   YCbCr.

 Y = get_luminance(HDR); 
    TMO = real(ReinhardTMO(HDR));
    sRGB = lin2srgb(TMO);
    sRGB = ClampImg(sRGB, 0, 1);
    sRGB = im2uint8(sRGB); % discretization of sRGB for encoding.
end

