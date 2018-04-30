function  gamma8_Encode( frame_path, start_frame, frame_step, last_frame, write_path, bitdepth, g_param )
%% Gamma 8 Compression method
% Author: Jonathan Hatchett, University of Warwick, 2015
% Modification for framework: Ratnajit Mukherjee, University of Warwick, 2015

%% header information
    frames = start_frame:frame_step:last_frame;
    ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');
    
    parfor i = 1 : length(frames)
        hdr = exrread(fullfile(frame_path, sprintf('%05d.exr', frames(i))));
        max_arr(i) = max(hdr(:));
    end 
    
    max_peak = max(max_arr);
    
    for i = 1 : length(frames)
        % read exr
        hdr = exrread(fullfile(frame_path, sprintf('%05d.exr', frames(i))));
        
        % normalize and and apply transfer function
        hdr_norm = hdr ./ max_peak; 
        hdr_norm = ClampImg(hdr_norm, 0, 1);
        
        rgb_norm = real(hdr_norm .^ (1 / g_param));
%         aux_data(i) = max(hdr(:));
        % Apply rgb2ycbcr and write file
        yuv = rgb2ycbcr(rgb_norm);
        yuv = uint16(floor(yuv.* (2^bitdepth)));
        yuv_p = permute(yuv, [2 1 3]);        
        fwrite(ldr_fid, yuv_p, 'uint16');
        fprintf('\n Frame %d done', (i-1));
    end 
    fclose(ldr_fid);
    save(fullfile(write_path, '_aux.mat'), 'max_peak');
end
