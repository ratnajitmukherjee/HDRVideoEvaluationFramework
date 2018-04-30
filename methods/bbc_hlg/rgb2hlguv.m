function [ LUV, maxframe ] = rgb2hlguv( hdr, bitdepth )
%% RGB2HLG: Function converts linear RGB signal to Hybrid Log Gamma curve
%   Input: linear RGB frame (absolute graded)
%   Output: LUV - hybrid log gamma for L and u'v'

    % step 1: Clamp, normalize the frame and store the maxvalue
    hdr = double(ClampImg(hdr, 1e-5, max(hdr(:))));
    rgb_norm = hdr./max(hdr(:));
    maxframe = max(hdr(:));
    
    %step 2: convert rgb to yu'v'
    yuv = hlg_rgb2yuv(rgb_norm, bitdepth);            
    
    % step 4: log encode Y
    LUV = yuv;
    Lp = hybrid_log_gamma(yuv(:,:,1));            
    LUV(:,:,1) = Lp.*2^bitdepth;
    
    LUV = round(LUV); % this is the final representation

end

function [yuv] = hlg_rgb2yuv(rgb, bitdepth)

    conv_mtx = [0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.9505];    

    xyz = zeros(size(rgb));
    
    for i = 1 : 3
         xyz(:,:,i) = rgb(:,:,1) * conv_mtx(i,1) + rgb(:,:,2) * conv_mtx(i,2)+ rgb(:,:,3) * conv_mtx(i,3);
    end
    X = xyz(:,:,1); Y = xyz(:,:,2); Z = xyz(:,:,3);
    
    %% Calculating the multiplying factor for u' and v'
    multFactor = round((2^bitdepth)/0.62);
    u = multFactor.*((4*X)./(X + 15*Y + 3*Z)); % Converting Chroma1  to n-bits 
    v = multFactor.*((9*Y)./(X + 15*Y + 3*Z)); % Converting Chroma2  to n-bits     
    
    yuv(:,:,1) = Y; yuv(:,:,2) = u; yuv(:,:,3) = v; 

end

function [Lp] = hybrid_log_gamma(y_norm)
%% constants
    r = 0.5; a = 0.17883277; b = 0.28466892; c = 0.55991073;

%% forward conversion of Hybrid-log gamma
    Ys = y_norm .*12; % normalizing y=[0, 12] 
    Lp = zeros(size(Ys));
    Lp(Ys<=1) = r.*sqrt(Ys(Ys<=1));
    Lp(Ys>1) = a.*log(Ys(Ys>1) - b) + c;
    
    % raising it to the system gamma
    Lp = Lp.^(1/1.2);
end 

