function [ puspace_barten ] = gdf_jnd( bitdepth )
%% obtaining luminance to luma mapping based on barten curve

%% constants        
    a = -1.3011877; b = -2.5840191E-2; c = 8.0242636E-2; d = -1.0320229E-1;
    e = 1.3646699E-1; f =2.8745620E-2; g = -2.5468404E-2; h = -3.1978977E-3; 
    k = 1.2992634E-4; m = 1.3635334E-3;
%% JND steps
    JND = [1:2^bitdepth-1];    
    loglum = zeros(size(JND));
    for i = 1 : numel(JND)
        j = JND(i);
        loglum(i) = (a + c*log(j) + e*(log(j)^2) + g*(log(j)^3) + m*(log(j)^4))./...
                    (1 + b*log(j) + d*(log(j)^2) + f*(log(j)^3) + h*(log(j)^4) + k*(log(j)^5));
    end 
    
    luminance = 10.^(loglum);
%     puspace_barten = zeros([2^bitdepth, 2]);
%     puspace_barten(1,1) = 1e-4; puspace_barten(1,2) = 0;    
    %puspace_barten(:,1) = luminance';
    %puspace_barten(:,2) = JND';
    puspace_barten = luminance;
    
end

