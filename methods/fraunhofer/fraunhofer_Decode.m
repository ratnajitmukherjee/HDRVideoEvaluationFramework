function fraunhofer_Decode( read_path, width, height, nFrames, dest_path, bitdepth )
%% Fraunhofer decode function
% Re-implementation: Ratnajit Mukherjee, University of Warwick, 2015

ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
load(fullfile(read_path, 'aux.mat'));

for i = 1:nFrames
    %% STEP 1: Reading 12:8:8 frames from the yuv file and loading aux data.
    ldr_frame = fread(ldr_fid, (width * height * 3), 'uint16');
    ldr_frame = uint16(reshape(ldr_frame, [width  height 3]));
    HDR_LUV = permute(ldr_frame, [2 1 3]); % transforms frame
    s = aux_data(i);
    
    %% decoding frames to 16 bit linear RGB
    hdr = frn_yuv2rgb(HDR_LUV, s, bitdepth, multfactor);
    
    %% Writing out frames
    exrwrite(hdr, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
    fprintf('\n Frame %d done', (i-1));
    
end     
    fprintf('\n\t DECODING COMPLETE...\n');
end 