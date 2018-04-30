function [sIPT, s] = pq_rgb2ipt(hdr, bitdepth)
%% This function converts RGB frames to IPT frames and applies the PQ curve on LMS color space
% The function can be divided into 4 steps a) normalization b) color space
% transform till LMS c) application of the PQ curve instead of Hunt-Pointer
% Estevez space and finally d) transformation and scaling to IPT space.

% STEP 1: Normalization of HDR frame
    [normalized_hdr, s.norm_factor] = pq_normalization(hdr);
    
% STEP 2: Conversion to LMS 
    lms = pq_rgb2lms(normalized_hdr);
    
% STEP 3: Application of the PQ curve
    pq_lms = applyPQnonlinearity(lms);

% STEP 4: Conversion from L'M'S' (non-linear LMS) to IPT
    pq_ipt = pq_lms2ipt(pq_lms);

% STEP 5: Preparing the 10 bit LDR frame
    [sIPT, s]  = scale_pqIPTframe(pq_ipt, s, bitdepth);               
end

function [norm_hdr, norm_factor] = pq_normalization(hdr)
%% this function calculates the frame max and performs normalization
    norm_factor = 1e4; % max(hdr(:)) // per frame normalization
    norm_hdr = hdr./norm_factor;

end 

function [lms] = pq_rgb2lms(norm_hdr)
%% this function converts RGB to XYZ to LMS
% NOTE: The conversion matrices in this function is different to that
% mentioned in the original paper because this works with BT. 709 and the
% sequences used in the paper is for BT. 2020. 

% In case of BT. 2020 the conversion matrices are to be replaced with
% correct matrices for that conversion.

    rgb = norm_hdr;
    xyz = zeros(size(rgb));
    lms = zeros(size(xyz));
    
    % conversion from RGB to XYZ
    rec709 = [  0.4124, 0.3576, 0.1805;...
                0.2126, 0.7152, 0.0722;...
                0.0193, 0.1192, 0.9505  ];
        
    for i = 1 : size(rgb, 3)        
        xyz(:,:,i) = rgb(:,:,1) * rec709(i, 1) + ...
                     rgb(:,:,2) * rec709(i, 2) + ...
                     rgb(:,:,3) * rec709(i, 3);
    end 
    
    % conversion from XYZ to LMS
    lms_conv = [0.4002, 0.7075, -0.0807;...
                -0.2280, 1.1500, 0.0612;...
                 0.0000, 0.0000, 0.9184];         
     
     for i = 1 : size(xyz, 3)        
        lms(:,:,i) = xyz(:,:,1) * lms_conv(i, 1) + ...
                     xyz(:,:,2) * lms_conv(i, 2) + ...
                     xyz(:,:,3) * lms_conv(i, 3);
     end    
end 

function [pq_lms] = applyPQnonlinearity(lms)
%% this function applies the PQ non-linearity to the LMS frame
    N = lms;
    
   % PQ constants
    m1 = (2610 / 4096) * (1 / 4);
    m2 = (2523 / 4096) * 128;    
    c1 = 3424 / 4096;
    c2 = (2413 / 4096) * 32;
    c3 = (2392 / 4096) * 32;
               
    for i=1:3
        N(:,:,i) = ((((lms(:,:,i)).^m1 * c2) + c1) ./ (1 + ((lms(:,:,i)).^m1 * c3))).^m2;
    end
    
    % storing the non-linear PQ curve applied LMS spectral response frame.
    pq_lms = N;
end 

function pq_ipt = pq_lms2ipt(pq_lms)
%% conversion from LMS to IPT colourspace
% this function converts PQ-LMS space to IPT space with BT. 709 matrix.
% Conversion matrix changes in case of BT. 2020.

    pq_ipt = zeros(size(pq_lms));
    ipt_conv = [0.4000, 0.4000, 0.2000;...
                4.4550, -4.8510, 0.3960;...
                0.8056, 0.3572, -1.1628];                
    
    for i = 1 : size(pq_lms, 3)        
        pq_ipt(:,:,i) = pq_lms(:,:,1) * ipt_conv(i, 1) + ...
                        pq_lms(:,:,2) * ipt_conv(i, 2) + ...
                        pq_lms(:,:,3) * ipt_conv(i, 3);
    end         
end 

function [sIPT, s] = scale_pqIPTframe(pq_ipt, s, bitdepth)
%% This function scales the PQ applied for codec suitability
    sIPT = zeros(size(pq_ipt));
    % separate channels
    p = pq_ipt(:,:,2); t = pq_ipt(:,:,3); 
    
    % obtain the maxima and minima
    s.minP = min(p(:)); s.maxP = max(p(:));
    s.minT = min(t(:)); s.maxT = max(t(:)); 
    
    % scale the channels
    P = (p - min(p(:)))./(max(p(:)) - min(p(:)));
    T = (t - min(t(:)))./(max(t(:)) - min(t(:)));
    
    % store scaled frame
    sIPT(:,:,1) = pq_ipt(:,:,1);
    sIPT(:,:,2) = P;
    sIPT(:,:,3) = T;
    
    % conversion to bitdepth
    sIPT = round(sIPT.*(2^bitdepth - 1));
end
