function [XYZ] = transform_srgb2xyz(sRGB)
%% This function transforms sRGB images to XYZ color space
% Input: disretized sRGB (unit8) [0, 255] range
% Output: normalized XYZ [0, 1] range

% Normalize and linearize
    srgb_norm = im2double(sRGB);
    linRGB = sRGB2linRGB(srgb_norm);

% Convert linRGB to XYZ

   conv_mtx = [0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.9505]; % constant conversion matrix D65
    
    XYZ = zeros(size(linRGB)); % space allocation for XYZ
    
    for i = 1 : 3
         XYZ(:,:,i) = linRGB(:,:,1) * conv_mtx(i,1) ...
            + linRGB(:,:,2) * conv_mtx(i,2)+ linRGB(:,:,3) * conv_mtx(i,3);
    end
    
    XYZ = ClampImg(XYZ, 0, 1); % clamp for assertion to normalization
end

function linRGB = sRGB2linRGB( sRGB )
%% conversion from srgb to linear RGB
linRGB = zeros(size(sRGB));
t = 0.04045;
a = 0.055;
linRGB(sRGB<=t) = sRGB(sRGB<=t)/12.92;
linRGB(sRGB>t) = ((sRGB(sRGB > t) + a)/(1+a)).^2.4;
end