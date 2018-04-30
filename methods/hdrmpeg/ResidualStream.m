function [ imgRes, q_factor ] = ResidualStream( LDR_LUV, HDR_LUV, RF )
%% RESIDUALSTREAM: Construct the Residual Frame by using the expansion
%operation

    pHDR_LUV = lutEo(LDR_LUV, RF); % predict HDR_LUV from LDR_LUV        
    RES_HDR = HDR_LUV - pHDR_LUV;   
    
%% Commenting out the entire noise reduction function
% Noise Reduction of the RES_HDR frame
%         DCS = waveletcdf97(RES_HDR, 5);
%         DCS = keep(DCS, 1/4);
%         RCS = waveletcdf97(DCS, -5);
%         RES_HDR = RCS;    
%% Quantizing and clamping Residual Frame from -127 to 127  
    [imgRes, Q] = quantizeResidual(LDR_LUV, RES_HDR);
    imgRes = ClampImg(imgRes,-127,127);
    imgRes = imgRes + 127; % adding 127 to shift the range from 0-255
    q_factor = Q;    
end

