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

function resi = logDecodeResidual(encResi, minVal, maxVal)

nrmResi = single(encResi)/255;
%nrmResi = nrmResi.^(1/2.2);

logMaxVal = log10(maxVal+1-minVal);

logResi = nrmResi*logMaxVal;

resi = (10.^logResi)-1+minVal;