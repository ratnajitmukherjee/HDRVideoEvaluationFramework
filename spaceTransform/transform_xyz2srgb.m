function [ sRGB ] = transform_xyz2srgb( XYZ )
%% This function performs the inverse conversion from XYZ to sRGB
% Input: Normalized XYZ [0, 1] range 
% Output: Discretized (8-bit) [0, 255] range

% convert XYZ to linRGB

    inv_mtx =[3.2406,-1.5372,-0.4986;...
            -0.9689,1.8757,0.0415;...
            0.0557,-0.2040,1.0569];
    
    linRGB = zeros(size(XYZ));
    
    for i = 1:3
        linRGB(:,:,i) = XYZ(:,:,1) * inv_mtx(i,1) ...
                        + XYZ(:,:,2) * inv_mtx(i,2) ...
                        + XYZ(:,:,3) * inv_mtx(i,3);
    end
   
% convert linRGB to sRGB
    sRGB = im2uint8(linRGB2sRGB(linRGB));
end

function [sRGB] = linRGB2sRGB( linRGB )
%% Function to convert linRGB to sRGB
sRGB = zeros(size(linRGB));

t = 0.0031308;
a = 0.055;

sRGB(linRGB <= t) = linRGB(linRGB<=t).*12.92;
sRGB(linRGB > t) = ((1+a)*linRGB(linRGB>t)).^(1/2.4) - a;
end