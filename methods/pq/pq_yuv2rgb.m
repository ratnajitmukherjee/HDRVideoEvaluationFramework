function [hdr] = pq_yuv2rgb(yuv, s, bitDepth)
%% PQ Decode function

%% allocation and normalisation of yuv files
    yuv = double(yuv) ./ (2^bitDepth);
    rgb = ycbcr2rgb(yuv);
    hdr = zeros(size(rgb));

%% Calculation of constants 
    m1 = (2610 / 4096) * (1 / 4);
    m2 = (2523 / 4096) * 128;
    
    c1 = 3424 / 4096;
    c2 = (2413 / 4096) * 32;
    c3 = (2392 / 4096) * 32;   
    
     mx = s.mx; 

%% Calculation of HDR frame
    for i = 1:3
        hdr(:,:,i) =  real(((rgb(:,:,i).^(1/m2) - c1) ./ (c2 - (c3 * (rgb(:,:,i).^(1 / m2))))).^(1 / m1));
        hdr(:,:,i) = hdr(:,:,i) .*mx(i);
    end
        
end
