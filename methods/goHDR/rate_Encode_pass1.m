function [width, height] = rate_Encode_pass1(frame_path, write_path, nFrames)
%% function to prepare the ldr video stream

% split the frame path to get the root path and sequence name
base = '/'; fpath = '';
tokens = strsplit(frame_path, '/');
new_tokens = tokens(~cellfun('isempty',tokens));
for i = 1: numel(new_tokens) -1 
    fpath = strcat(fpath, base, new_tokens{i});
end 
%% selecting paths for moving the files
fpath = strcat(fpath, base); %% root_path
root_file = fullfile(fpath, 'yuvs-30frames',  [new_tokens{end},'_ldr.yuv']); % the actual file

%% obtaining width and height and converting to yuv444
testhdr = exrread(fullfile(frame_path, '00000.exr'));
[height, width, ~] = size(testhdr);

%% opening file and extracting 30 frames
ldr_fid1 = fopen(root_file, 'r');
ldr_fid2 = fopen(fullfile(write_path, 'ldr.yuv'), 'w');
for i = 1 : nFrames
    ldr_frame = fread(ldr_fid1, (width * height * 3), 'uint8');
    ldr_frame = uint8(reshape(ldr_frame, [width height 3]));   
    fwrite(ldr_fid2, ldr_frame, 'uint8'); 
end 
fclose(ldr_fid1); fclose(ldr_fid2); 
end 
