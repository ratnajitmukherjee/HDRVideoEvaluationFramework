function [imgRes, Q] = quantizeResidual(LDR_LUV, RES_HDR)
%% QUANTIZE RESIDUAL: Quantisation of residual frame
    q_min = 2;
    imgRes = RES_HDR;
    Q = ones(256,3);
    c = 1;
    ldr_c = LDR_LUV(:,:,c);
    res_c = RES_HDR(:,:,c);
    for i=1:256
        indx = find(ldr_c==(i-1));
        if(~isempty(indx))
            q_factor = max(abs(res_c(indx)))/127;
            Q(i, c) = max(q_min,q_factor);
            res_c(indx) = res_c(indx)/Q(i,c);
        else
            Q(i,c) = q_min;
        end
    end
    imgRes(:,:,c) = res_c;
    

end

