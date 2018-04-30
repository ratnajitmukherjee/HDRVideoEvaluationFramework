function [opt, lResi, s] = oEncode(hdr, varargin)

%gamma = 1;
gamma = 2.2;

% if opt Exp = -1 then it is calculated by getOptExp
% otherwise the one passed is used
% this is so that the lb can be temporally filtered 

optExp = -1; 

if (nargin > 1) 
    oE = varargin{1};
    index = varargin{2}; 
    optExp = oE(index); 
end;

% if(~exist('optExp', 'var'))
%    optExp = -1; 
% end

offset = 0.005;
%offset = 0;
multOff = 1 - offset; 

[l minLum maxLum chroma dr] = getHdrData(hdr);

[ldrLum lb] = getOptExp(l, dr, minLum, maxLum, optExp);

r = l - ldrLum;
[lResi rminVal rmaxVal] = logEncodeResidual(r);

% the offset ensures that all values have at least 1
y = ((ldrLum-lb)/(lb * (256))) * multOff;

y = y + offset; 

for i = 1:3
   dtm(:, :, i) = chroma(:, :, i) .* y; 
end

opt = uint8(round((dtm.^(1/gamma))*(255)));

% 
% psnr = PSNR2(hdr, hdr2); 
% disp(psnr); 

s = struct('lb', lb, 'rminVal',rminVal,'rmaxVal',rmaxVal);

return