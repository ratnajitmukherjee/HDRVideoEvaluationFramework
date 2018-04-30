function  bbc_Encode( frame_path, start_frame, frame_step, last_frame, write_path, bitdepth)
%% BBC Compression method
% Author: Ratnajit, University of Warwick, 2015

%% header information
    frames = start_frame:frame_step:last_frame;
    ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');     
    
%% processing
    for i = 1 : length(frames)    
        hdr = exrread(fullfile(frame_path, sprintf('%05d.exr', frames(i))));
        [LUV, maxframe]  = rgb2hlguv(hdr, bitdepth);
        yuv = uint16(LUV);
        yuv_p = permute(yuv, [2 1 3]);        
        fwrite(ldr_fid,yuv_p, 'uint16');
        aux_data(i) = maxframe;
        fprintf('\n Frame %d done', (i-1));
    end
    save(fullfile(write_path, 'aux.mat'), 'aux_data');
    fprintf('\nCompression complete...\n');
end

