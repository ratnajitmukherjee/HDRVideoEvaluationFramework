function [ hdr ] = hlguv2rgb( LUV, maxframe, bitdepth )
%% RGB2HLG: Function converts YUV signal to RGB curve using inverse hybrid log-gamma
%   Input: L'u'v'
%   Output: linear RGB

    % step1: linearizing Y
    Ys = inverse_hybrid_log_gamma(LUV(:,:,1), bitdepth);
    
    % step2: converting yuv 2 rgb
    yuv = LUV;
    yuv(:,:,1) = Ys;
    rgb_norm = hlg_yuv2rgb(yuv, bitdepth);
    
    % step3: getting the original RGB
    hdr = rgb_norm .* maxframe;

end

function [rgb_norm] = hlg_yuv2rgb(yuv, bitdepth)

    inv_mtx =[  3.2406,-1.5372,-0.4986;...
                -0.9689,1.8757,0.0415;...
                0.0557,-0.2040,1.0569   ];
            
    multfactor = round((2^bitdepth)./0.62);
            
    Y = double(yuv(:,:,1)); % y[0-1]
    u = double(yuv(:,:,2)./multfactor);
    v = double(yuv(:,:,3)./multfactor); %u'v' [0, 0.62]
    
    x_hdr = 9*u./ (6*u - 16*v + 12);
    y_hdr = 4*v./ (6*u - 16*v + 12);
    z_hdr = 1 - x_hdr - y_hdr;
   
   normalization = RemoveSpecials(Y./y_hdr);
   xyz = zeros(size(yuv));
   
   xyz(:,:,1) = x_hdr .* normalization;
   xyz(:,:,2) = Y;
   xyz(:,:,3) = z_hdr .* normalization;

%% Final decoded RGB creation
   rgb = zeros(size(xyz));
   
   for j = 1:3
        rgb(:,:,j) = xyz(:,:,1) * inv_mtx(j,1) ...
                       + xyz(:,:,2) * inv_mtx(j,2) ...
                       + xyz(:,:,3) * inv_mtx(j,3);
   end
   
   rgb_norm = rgb;

end 

function [Ys] = inverse_hybrid_log_gamma(Lp, bitdepth)
%% constants
    r = 0.5; a = 0.17883277; b = 0.28466892; c = 0.55991073;
    
    % processing of luminance
    Ys = zeros(size(Lp));
    
    Lp = Lp./(2^bitdepth);
    Lp = Lp.^1.2;
        
    Ys(Lp<=r) = (Lp(Lp<=r)./r).^2;
    Ys(Lp>r) = exp((Lp(Lp>r) - c)./a) + b; 
    Ys = Ys./12; % this is the linear signal
end 