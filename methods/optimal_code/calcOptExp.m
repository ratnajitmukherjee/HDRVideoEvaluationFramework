function [lb] = calcOptExp(hdrLum, dr, minLum)
   %% generate HDR histogram
 %   binNo = 1000;
    h = (2 * iqr(log2(hdrLum(:)))) /size(log2(hdrLum(:)),1).^0.33;
    binNo = double(round(max(log2(hdrLum(:))) - min(log2(hdrLum(:))) / h)); 
    
    hst = hist(log2(hdrLum(:)), binNo);

    %% traverse histogram looking for the best single exposure
    best = 0;
    bstBnd = 1;
    step = int32(round(binNo/dr*8));
    for i = 1:(binNo - step)
        count = sum(hst(i:i+step));
        if(count > best)
            best = count;
            bstBnd = i;
        end
    end


    %% determine boundary values, extract single exposure lum and normalise it
    lb = 2^(((double(bstBnd) * dr)/binNo) + log2(minLum));

return 