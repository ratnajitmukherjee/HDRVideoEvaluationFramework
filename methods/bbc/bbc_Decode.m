function  bbc_Decode( read_path, width, height, nFrames, dest_path, bitdepth)
%% BBC Compression method
% Author: Ratnajit Mukherjee, University of Warwick, 2015

%% header information
    ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
    load(fullfile(read_path, 'aux.mat'));         
    
%% processing
    for i = 1 : nFrames
        yuv_p = fread(ldr_fid, (width * height * 3), 'uint16');
        yuv_p = uint16(reshape(yuv_p, [width height 3]));
        LUV = double(permute(yuv_p, [2 1 3]));
        max_frame = aux_data(i);
        
        hdr = hlguv2rgb(LUV, max_frame, bitdepth);
                
        exrwrite(hdr, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
        fprintf(' \n Decoding Frame %d', (i-1));
    end 
    fclose(ldr_fid);
    
    fprintf('\nDecompression complete...\n');
end

