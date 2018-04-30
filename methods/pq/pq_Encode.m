function pq_Encode(frame_path, start_frame, frame_step, last_frame, write_path, bitdepth )
%% PQ Method compression code
%  Reimplementation: Ratnajit Mukherjee, University of Warwick, 2015

%% Header information
frames = start_frame:frame_step:last_frame;
ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');

%% Compression Code
for i = 1: length(frames)
    hdr = exrread(fullfile(frame_path, sprintf('%.5d.exr', frames(i))));
    [yuv, s] = pq_rgb2yuv(hdr, bitdepth);   
    aux_data(i) = s;    
    yuv_p = permute(yuv, [2 1 3]);
    fwrite(ldr_fid, yuv_p, 'uint16');    
    fprintf('Frame %d done \n', (i-1));
end 
save(fullfile(write_path, 'aux.mat'), 'aux_data');
fclose(ldr_fid); clear ldr_fid;

fprintf('\n Compression Complete...');
