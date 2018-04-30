function [hdr] = pq_ipt2rgb(sIPT, s, bitdepth)
%% This function converts the scaled IPT frame to HDR-RGB
% The function can be divided into 5 steps, a) Normalization of frames,
% b) descaling and color space tranform from IPT to LMS (and inverse PQ),
% c) color space transform from LMS to RGB and finally d) multiplication by
% the normalization factor

% STEP 1: inverse 10-bit normalization and rescaling of IPT frames    
    pq_ipt = inverse_scale_pqIPTframe(sIPT, s, bitdepth);
    
% STEP 2: pq-IPT to pq-L'M'S' with PQ non-linearity
    pq_lms = pq_ipt2lms(pq_ipt);
    
% STEP 3: Apply inverse PQ non-linearity to convert to linear LMS
    lms = inversePQnonlinearity(pq_lms);
    
% STEP 4: linear LMS to linear RGB conversion
    rgb = pq_lms2rgb(lms);
    
% STEP 5: Multiplying the RGB with the normalization factor
    hdr = rgb.*s.norm_factor;
end

function [pq_ipt] = inverse_scale_pqIPTframe(sIPT, s, bitdepth)
%% this function     
    sIPT = double(sIPT) ./ (2^bitdepth);
    
    % separate the P and T channels
    P = sIPT(:,:,2); T = sIPT(:, :, 3);       
    
    % scale P and T channels with stored min and max P&T respectively;
    p = (P.* (s.maxP - s.minP)) + s.minP;
    t = (T .* (s.maxT - s.minT)) + s.minT;
    
    % store the scaled IPT matrix
    pq_ipt = sIPT(:,:,1); pq_ipt(:,:,2) = p; pq_ipt(:,:,3) = t;
end

function [pq_lms] = pq_ipt2lms(pq_ipt)
%% This function converts from IPT to LMS
    inv_ipt = [1.0000, 0.0976, 0.2052;...
              1.0000, -0.1139, 0.1332;...
              1.0000, 0.0326, -0.6769];
          
    pq_lms = zeros(size(pq_ipt));
    
    for i = 1 : 3
        pq_lms(:,:,i) = pq_ipt(:,:,1) * inv_ipt(i, 1) + ...
                        pq_ipt(:,:,2) * inv_ipt(i, 2) + ...
                        pq_ipt(:,:,3) * inv_ipt(i, 3);
    end             
end 

function [lms] = inversePQnonlinearity(pq_lms)
%% This function applies the inverse PQ non-linearity
% Function to convert non-linear L'M'S' to linear LMS but reversing the PQ
% non-linear curve

% Declaration of the Linear LMS matrix
    lms = zeros(size(pq_lms));

% Calculation of constants 
    m1 = (2610 / 4096) * (1 / 4);
    m2 = (2523 / 4096) * 128;
    
    c1 = 3424 / 4096;
    c2 = (2413 / 4096) * 32;
    c3 = (2392 / 4096) * 32;           

% Calculation of linear LMS frame
    for i = 1:3
        lms(:,:,i) =  real(((pq_lms(:,:,i).^(1/m2) - c1) ./ (c2 - (c3 * (pq_lms(:,:,i).^(1 / m2))))).^(1 / m1));        
    end
end

function [rgb] = pq_lms2rgb(lms)
%% This function converts from linear LMS to RGB via XYZ

% Declaration of XYZ and RGB matrix
    xyz = zeros(size(lms));
    rgb = zeros(size(xyz));
    
% Conversion from linear LMS to XYZ
    inv_lms = [1.8502,   -1.1383,    0.2384;...
               0.3668,    0.6439,   -0.0107;...
                0,         0,    1.0889];
            
    for i = 1 : 3
        xyz(:,:,i) = lms(:,:,1) * inv_lms(i, 1) + ...
                     lms(:,:,2) * inv_lms(i, 2) + ...
                     lms(:,:,3) * inv_lms(i, 3);
    end 
    
% Conversion of XYZ to RGB

    inv_rec709 =    [3.2406,   -1.5372,   -0.4986;...
                    -0.9689,    1.8758,    0.0415;...
                     0.0557,   -0.2040,    1.0570];
                 
    for i = 1 : 3        
        rgb(:,:,i) = xyz(:,:,1) * inv_rec709(i, 1) + ...
                     xyz(:,:,2) * inv_rec709(i, 2) + ...
                     xyz(:,:,3) * inv_rec709(i, 3);
    end         
end 


