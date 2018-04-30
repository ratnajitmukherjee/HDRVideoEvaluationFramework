% Calculate Peak Signal-to-Noise Ratio 
%       - This function calculates PSNR value between two input images
%
% Usage:    
%           psnr = qm_psnr(org, dec)
%
% Input:   
%           org  - Reference image.
%           dec  - Decoded image.
%           mode    - 'rgb' or 'yuv' or 'lum'(just Y)
%
% Output:
%           psnr    - value of PSNR metric averaged or just Y.
%
%     Copyright (C) 2014  Ratnajit Mukherjee
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/

function [ psnr ] = qm_psnr( org, dec, mode )
%% Calculates PSNR between original and decoded images in 3 different modes viz. psnr_rgb, psnr_y and psnr_yuv
% Input 3 channel image.
    avgPSNR = zeros([1 3]);
        %% Yu'v' mode
       if (strcmp(mode, 'yuv') == true)        
        org_yuv = RemoveSpecials(rgb2yuv(org));                
        dec_yuv = RemoveSpecials(rgb2yuv(dec));
            for i = 1:3
                avgPSNR(i) = calculatePSNR(org_yuv(:,:,i), dec_yuv(:,:,i));
            end  
        psnr = mean(avgPSNR, 2);        
        %% RGB mode
       elseif(strcmp(mode, 'rgb') == true)
           for i = 1:3
                avgPSNR(i) = calculatePSNR(org(:,:,i), dec(:,:,i));
           end
        psnr = mean(avgPSNR, 2);
        %% luminance mode
       elseif(strcmp(mode, 'lum') == true)
           orgY = 0.2126*org(:,:,1) + 0.7152*org(:,:,2) + 0.0722*org(:,:,3);
           decY = 0.2126*dec(:,:,1) + 0.7152*dec(:,:,2) + 0.0722*dec(:,:,3);
           psnr = calculatePSNR(orgY, decY);
       end                                     
end 

% Calculates PSNR of each channel
function [psnrChannel] = calculatePSNR(orgChannel, decChannel)

    % Calculate Mean Square error
    [height , width] = size(orgChannel);
    rmse = (double(orgChannel) - double(decChannel)).^2;
    rmse = RemoveSpecials(rmse); 
    rmse = sum(rmse(:));
    rmse = sqrt(rmse/(height*width));
    
    psnrChannel = 20*log10(max(orgChannel(:))/rmse);
    
end 

%% Colour space Conversion from RGB to YU'V'
function [YUV] = rgb2yuv(RGB)

conv_mtx = [0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.9505];
            
XYZ = zeros(size(RGB));

for j = 1 : 3
         XYZ(:,:,j) = RGB(:,:,1) * conv_mtx(j,1) ...
            + RGB(:,:,2) * conv_mtx(j,2)+ RGB(:,:,3) * conv_mtx(j,3);
end 
    X = XYZ(:,:,1); Y = XYZ(:,:,2); Z = XYZ(:,:,3);
    
    U = 410*((4*X)./(X + 15*Y + 3*Z)); % Converting Chroma1  to 8bits 
    V = 410*((9*Y)./(X + 15*Y + 3*Z)); % Converting Chroma2  to 8bits 
    
    Y = 0.2126 * RGB(:,:,1) + 0.7152*RGB(:,:,2) + 0.0722*RGB(:,:,3);     
    YUV = zeros(size(RGB));
    
    YUV(:,:,1) = Y; YUV(:,:,2) = U; YUV(:,:,3) = V;
    
end 