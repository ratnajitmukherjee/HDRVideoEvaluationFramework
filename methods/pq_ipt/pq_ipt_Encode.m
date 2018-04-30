function pq_ipt_Encode(frame_path, start_frame, frame_step, last_frame, write_path, bitdepth )
%% PQ Algrorithm with IPT color space compression code
% Reimplementation: Ratnajit Mukherjee, 
% University of Warwick, 2017

%% Header information
frames = start_frame:frame_step:last_frame;
ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');

%% Compression Code call

for i = 1: length(frames)
    hdr = exrread(fullfile(frame_path, sprintf('%.5d.exr', frames(i))));
    [sIPT, s] = pq_rgb2ipt(hdr, bitdepth);   
    aux_data(i) = s;    
    pq_ipt_final = permute(sIPT, [2 1 3]);    
    fwrite(ldr_fid, pq_ipt_final, 'uint16');    
    fprintf('Frame %d compressed..\n', (i-1));
end 

%% saving auxiliary data
save(fullfile(write_path, 'aux.mat'), 'aux_data');
fclose(ldr_fid); clear ldr_fid;

fprintf('\n PQ-IPT Transformation Complete...');
