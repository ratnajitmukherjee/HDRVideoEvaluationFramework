%% -- Logarithmically Encode Residual Data
%
%  [encResi, minVal, maxVal] = logEncodeResidual(resi)
%
% This function takes residual data and logarithmically encodes it.
%
% Input:
%   - resi:     residual input image
%
% Output:
%   - encResi:  encoded residuals
%   - minVal:   minimum value of original input
%   - maxVal:   maximum value of original input

function [encResi, s] = logEncodeResidual(resi)

s.minVal = min(resi(:));
s.maxVal = max(resi(:));

% shift image so it starts at 1 and than log scale
logResi = log10(resi+1-s.minVal);

logMaxVal = log10(s.maxVal+1-s.minVal);

% normalise gamma correct and quantise
nrmResi = real(logResi/logMaxVal);
% nrmResi = real(nrmResi.^(1/2.2));
encResi = uint8(round(nrmResi*255));
end 