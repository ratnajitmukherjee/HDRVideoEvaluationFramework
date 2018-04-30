%% function to create luv from rgb
function [LUV_HDR, s] = frn_rgb2yuv(hdr, prev_s, frame_type, bits)
    %% luma encoding
    switch frame_type                 
        case 'iframe'
            %% This is for 1st and subsequently every 15th frame
            Y = get_luminance(hdr);
            Y = ClampImg(Y, 1e-8, max(max(Y)));
            
            %calculating ymax and ymin
            Y_min = min(Y(:)); Y_max = max(Y(:));             
            luma =floor(((2^bits - 1)./log2(Y_max/Y_min)) .* (log2(Y) - log2(Y_min)));
            s.ymin = Y_min; s.ymax = Y_max;
        case 'pframe'
            %% This is for all other frames where previous info is required
            Y = get_luminance(hdr);
            Y = ClampImg(Y, 1e-8, max(max(Y)));
            Y_maxL = max(Y(:)); Y_minL = min(Y(:));
            Y_minK = prev_s.ymin; Y_maxK = prev_s.ymax;
             % ------Calculating the range w--------
            logWD = 5; % where logWD belongs [0, 7]
            LD = 2.^logWD;
            w = (log2(Y_maxK/Y_minK)/log2(Y_maxL/Y_minL))*LD;           
            % ------Calculating the offset o-------
            o = (log2(Y_minK/Y_minL)/log2(Y_maxL/Y_minL))*((2^bits - 1)/2^(bits-8));                        
            % Finally solving for Y_max and Y_min for the current frame
            Y_min = 2.^(log2(Y_minK) - (o*LD*2^(bits-8)/(w*2^bits - 1)) * log2(Y_maxK/Y_minK));
            Y_max = 2.^(LD/w * log2(Y_maxK/Y_minK) + log2(Y_minL)); 
            luma = floor(((2^bits - 1)./log2(Y_max/Y_min)) .* (log2(Y) - log2(Y_min)));        
            luma = ClampImg(luma, 0, (2^bits -1));
            s.ymin = Y_min; s.ymax = Y_max;
    end 
    L_HDR = luma;
    
    %% Conversion Matrix
    conv_mtx = [0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.9505];
    %% Chroma encoding 
    
    XYZ_HDR = zeros(size(hdr));         
    for j = 1 : 3
        XYZ_HDR(:,:,j) = hdr(:,:,1) * conv_mtx(j,1) ...
                        + hdr(:,:,2) * conv_mtx(j,2) ...
                        + hdr(:,:,3) * conv_mtx(j,3);
    end 
    multFactor = round((2^bits - 1)/0.62);
        
        X_HDR = XYZ_HDR(:,:,1); Y_HDR = XYZ_HDR(:,:,2); Z_HDR = XYZ_HDR(:,:,3);    
        U_HDR = multFactor.*((4*X_HDR)./(X_HDR + 15*Y_HDR + 3*Z_HDR)); % Converting Chroma1  to n-bits 
        V_HDR = multFactor.*((9*Y_HDR)./(X_HDR + 15*Y_HDR + 3*Z_HDR)); % Converting Chroma2  to n-bits
   %% Creating LUV frame
        LUV_HDR = zeros(size(hdr));
        LUV_HDR(:,:,1) = L_HDR; LUV_HDR(:,:,2) = U_HDR; LUV_HDR(:,:,3) = V_HDR;
end