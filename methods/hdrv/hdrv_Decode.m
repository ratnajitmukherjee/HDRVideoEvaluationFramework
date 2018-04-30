function hdrv_Decode( read_path, width, height, nFrames, dest_path, bitdepth )
%% Perception Motivated HDR Video Decoding 2004
% Author: Rafal Mantiuk, 2004 Siggraph
% Re-implementation; Ratnajit Mukherjee, University of Warwick 2015
%% Header information 
ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
mf = 2^(16 - bitdepth);

for i = 1:nFrames
    ldr_frame = fread(ldr_fid, (width * height * 3), 'uint16');
    ldr_frame = reshape(ldr_frame, [width height 3]);
    ldr_rs = double(permute(ldr_frame, [2 1 3])); %ldr_rs = reshaped ldr
    
    if(bitdepth == 12)
        HDR16 = hdrv_yuv2rgb(ldr_rs,bitdepth, mf);
    else
        HDR16 = hdrv_yuv2rgb(ldr_rs,bitdepth, 1);
    end 
        
    if( exist( 'pfs_write_image', 'file' ) )
        pfs_write_image( fullfile(dest_path, sprintf('frame_%05d.exr', (i-1)) ), HDR16, '--fix-halfmax' );
    else
        exrwrite(HDR16, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
    end
    
end 
fprintf('\n DECOMPRESSION COMPLETED AND RECONSTRUCTED FRAMES WRITTEN \n');