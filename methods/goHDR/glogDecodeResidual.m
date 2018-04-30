%% -- Logarithmically Decode Residual Data
%
%  resi = logDecodeResidual(encResi, minVal, maxVal)
%
% This function takes encoded residual data and logarithmically decodes it.
%
% Input:
%   - encResi:  encoded residual input image
%   - minVal:   minimum value of the output
%   - maxVal:   maximum value of the output
%
% Output:
%   - resi:     decoded residuals

function resi = glogDecodeResidual(encResi, minVal, maxVal)

nrmResi = double(encResi)/255;
nrmResi = nrmResi.^2.2; % reverse gamma correction

logMaxVal = log10(maxVal+1-minVal);

logResi = nrmResi*logMaxVal;

resi = (10.^logResi)-1+minVal;