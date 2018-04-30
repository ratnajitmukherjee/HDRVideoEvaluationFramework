%% -- Look-up Table Expansion Operator
%
% function eoHdr = lutEo(ldr, lut)
%
% This function expands dynamic range of the input image based on the
% look-up table provided. LUT is in the 3 x 256 form where each row
% contains values for each channel and indices represent to intensity
% values.
%
% Input:
%   - ldr:          input ldr image to be expanded; range: [0 255]
%   - lut:          look-up table which contains mapping
%
% Output:
%   - eoHdr:        HDR image obtained by expanding LDR input

function eoHdr = lutEo(ldr, lut)

    eoHdr = ldr;
    ldr = double(ldr);
    
    % Prediction only of the luma channel
    ldrSlice = ldr(:, :, 1);
    hdrSlice = changem(ldrSlice, lut, 0:255);
    eoHdr(:, :, 1) = hdrSlice;
end 