function [ lb ] = oInit( hdr )
%OINIT Summary of this function goes here
%   Detailed explanation goes here
    [hdrLum, minLum, ~, ~, dr] = getHdrData(hdr);
    lb = calcOptExp(hdrLum, dr, minLum);
end

