function pq_ipt_Decode( read_path, width, height, nFrames, dest_path, bitdepth )
%% PQ Method Decompression Code

%% load file and metadata information
ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
load(fullfile(read_path, 'aux.mat'));
%% process and write out output frames
for i = 1 : nFrames
    yuv = fread(ldr_fid, (width * height * 3), 'uint16');
    yuv = uint16(reshape(yuv, [width  height 3]));
    luv = permute(yuv, [2 1 3]); % transforms frame
    s = aux_data(i);      
    hdr = pq_ipt2rgb(luv, s, bitdepth);
    
    exrwrite(hdr, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
    fprintf('\n Frame %d decompressed..', (i-1));
end 
fprintf('\n PQ-IPT decompression complete...\n');
end 
