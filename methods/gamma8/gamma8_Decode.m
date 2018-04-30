function gamma8_Decode( read_path, width, height, nFrames, dest_path, bitdepth, g_param )
%% Gamma 8 Decompression method
% Author: Jonathan Hatchett, University of Warwick, 2015
% Modification for framework: Ratnajit Mukherjee, University of Warwick, 2015

%% Header information
    
    ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
    load(fullfile(read_path, '_aux.mat'));
    
    for i = 1 : nFrames
        % fread frames and reshape
        yuv_p = fread(ldr_fid, (width * height * 3), 'uint16');
        yuv_p = uint16(reshape(yuv_p, [width height 3]));
        yuv = permute(yuv_p, [2 1 3]);
        
        % processing for decompression
        yuv_norm = double(yuv) ./ (2^bitdepth) ;
        rgb_norm = ycbcr2rgb(yuv_norm); 
        
        hdr_dec = (rgb_norm .^ g_param) .* max_peak;
        
        exrwrite(hdr_dec, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
        fprintf(' \n Decoding Frame %d', (i-1));
    end    
    fclose(ldr_fid);
end
