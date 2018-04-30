    
function [ldrLum lb] = getOptExp(hdrLum, dr, minLum, maxLum, optExp)

 %   %[dr minLum maxLum] = getData(hdrLum);

%     %% generate HDR histogram
%     binNo = 1000;
%     hst = hist(log2(hdrLum(:)), binNo);
% 
%     %% traverse histogram looking for the best single exposure
%     best = 0;
%     step = int32(round(binNo/dr*8));
%     for i = 1:(binNo - step)
%         count = sum(hst(i:i+step));
%         if(count > best)
%             best = count;
%             bstBnd = i;
%         end
%     end
% 
% 
%     %% determine boundary values, extract single exposure lum and normalise it
%     lb = 2^(((double(bstBnd) * dr)/binNo) + log2(minLum));
if (optExp == -1)
    lb = calcOptExp(hdrLum, dr, minLum);
else
    lb = optExp;
end

    ub = lb*256;
    ldrLum = hdrLum;
    ue = ldrLum < lb;
    oe = ldrLum > ub;
    ldrLum(ldrLum < lb) = lb;
    ldrLum(ldrLum > ub) = ub;
   % ldrLum = (ldrLum-lb)/ub;
    
end