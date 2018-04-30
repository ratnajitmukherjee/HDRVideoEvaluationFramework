function [tmPC, lResi, s] = wEncode(hdr, imTM)
gamma = 2.2;
invgamma = 1.0/gamma;
const = 1e-4;
%% linearise the tm to used for ratio calculation
    imTM = im2double(imTM);
    imTM = imTM .^gamma;

%% Ratio image
imgRI = lum(hdr)./(lum(imTM) + const);
[lResi, s] = logEncodeResidual(imgRI); 
%% Dividing the hdr with residial to get a corrected tm frame
tm = zeros(size(hdr));
for i=1:3
    tm(:, :, i) = hdr(:, :, i)./imgRI;
end

%% Removing Inf and NaN clamping and discretization of tmo frame
tm = RemoveSpecials(tm);
tm = ClampImg(tm, 0, 1);
%% Taking the real part is important if -ve value to avoid complex numbers
tmPC = uint8(real(tm.^invgamma) * 255); 
return