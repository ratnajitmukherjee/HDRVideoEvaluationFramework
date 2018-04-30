function [scaleFrame, minRatio, maxRatio] = ComputeRatioFrames(HDR, LDR, epsilon)
                                           
        Y_HDR = double(lum(HDR));                                        
        Y_LDR = lum(LDR);                        
        ratioFrame = real(log(Y_HDR./(Y_LDR + epsilon))); % scale for 0 - 1        
        scaleFrame = (ratioFrame - min(ratioFrame(:)))/(max(ratioFrame(:)) - min(ratioFrame(:)));               
        % normalization of reference image        
        scaleFrame = jbfilter2(scaleFrame,Y_HDR, 4, [8 0.1]);
        minRatio = min(ratioFrame(:)); maxRatio = max(ratioFrame(:));         
end