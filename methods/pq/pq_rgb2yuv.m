function [yuv, s] = pq_rgb2yuv(hdr, bitDepth)
%% PQ encode function
    normalized_hdr = hdr; 
    for i=1:3
        mx(i) = max(max(hdr(:,:,i)));
        normalized_hdr(:,:,i) = hdr(:,:,i) / mx(i); 
    end
    
    m1 = (2610 / 4096) * (1 / 4);
    m2 = (2523 / 4096) * 128;
    
    c1 = 3424 / 4096;
    c2 = (2413 / 4096) * 32;
    c3 = (2392 / 4096) * 32;
            
    N = normalized_hdr; 
    for i=1:3
        N(:,:,i) = ((((normalized_hdr(:,:,i)).^m1 * c2) + c1) ./ (1 + ((normalized_hdr(:,:,i)).^m1 * c3))).^m2;
    end
    
    yuv = rgb2ycbcr(real(N));        
    yuv = uint16(round((yuv * 2^bitDepth)));
    s = struct('mx', mx);     
end
