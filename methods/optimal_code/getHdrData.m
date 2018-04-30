%% -- Get HDR Data
%
% [lumi minLum maxLum chroma dr] = getHdrData(hdr)
%
% This function takes an HDR image and returns usefull data associatied
% with the image. Luminance and chrominance images are returned together
% with minimum and maximum values of luminance and image's dynamic range
%
% Input:
%   - hdr:      input HDR image to be analysed
%
% Output:
%   - lumi:     luminance of the input image; grayscale image
%   - minLum:   minimum luminance of the input image
%   - maxLum:   maximum luminance of the input image
%   - chroma:   chromaticity of the input image; contains 3 channels
%   - dr:       dynamic range of the input image in EVs

function [lumi minLum maxLum chroma dr] = getHdrData(hdr)

lumi = lum(hdr);
minLum = min(lumi(:));
maxLum = max(lumi(:));

%% make sure luminance does not contain zero to avoid division problems
%  swap zero with the next smalles value
if(minLum == 0)
    minLum = unique(lumi(:));
    minLum = minLum(2);
    lumi(lumi == 0) = minLum;
end

%% chroma is obtained by dividing HDR image with luminance
chroma = zeros(size(hdr), 'single');
for i = 1:3
    chroma(:, :, i) = hdr(:, :, i) ./ lumi;
end

%% for dynamic range "Ratio Contrast" (CR) is used
dr = log2(maxLum/minLum);