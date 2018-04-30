function [res, s] = rEncode(hdr, tmo, epsilon, fSaturation)

    tmo = srgb2lin(im2double(tmo));
    schlickVal = 1.0/fSaturation;
    tmo = ColorCorrection(tmo, schlickVal);                
    [res, minR, maxR] = ComputeRatioFrames(hdr, tmo, epsilon);
    res = im2uint8(res);
    s.minVal = minR;
    s.maxVal = maxR;
end 