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

function [encResi, minVal, maxVal] = glogEncodeResidual(resi)

minVal = min(resi(:));
maxVal = max(resi(:));

% shift image so it starts at 1 and than log scale
logResi = log10(resi+1-minVal);

logMaxVal = log10(maxVal+1-minVal);

% normalise, quantise and gamma correct
nrmResi = logResi/logMaxVal;
nrmResi = real(nrmResi.^(1/2.2));
encResi = uint8(round(nrmResi*255));
end 