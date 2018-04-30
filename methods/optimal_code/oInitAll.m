function [lbF ] = oInitAll( nFrames, filedir )
%OINITALL Summary of this function goes here
%   Detailed explanation goes here

    lb = zeros(nFrames, 1, 'double'); 
    % loop through frames and create files
    % this is useful as can be parallelised trivially
    parfor i = 1:nFrames
        filename = sprintf('%.5d.exr', (i-1)); 
        hdr = exrread(fullfile(filedir, filename));                
        lb(i) = oInit(hdr);        
    end

    lbF = filterStream(lb); 
%     disp(lbF);  

end

