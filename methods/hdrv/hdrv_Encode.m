function hdrv_Encode( frame_path, start_frame, frame_step, last_frame, write_path, bitdepth )
%% Perception Motivated High Dynamic Range Video Encoding 2004
% Authors: Rafal Mantiuk 2004, Siggraph
% Re-implementation: Ratnajit Mukherjee, University of Warwick, 2014

%% Header information     
frames = start_frame:frame_step:last_frame;
nFrames = length(frames);
ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');
mf = 2^(16 - bitdepth);
%% STEP 1: Reading HDR directory.
for i = 1: nFrames
   if( exist( 'pfs_read_image', 'file' ) )
        HDR = pfs_read_image( sprintf( frame_path, frames(i) ) );
    else
        HDR = exrread([frame_path, sprintf('%.5d.exr', frames(i))]);
   end
    hdr_yuv = hdrv_rgb2yuv(HDR, bitdepth);
    if(bitdepth == 12)
        y = hdr_yuv(:,:,1).*mf;
    else
        y = hdr_yuv(:,:,1).*1;
    end 
    luma = pu_encode(y, 'forward', bitdepth);     
    hdr_yuv(:,:,1) = luma; % now the frame is n:n:n LUV format
    
    %% Write yuv file to disk
    luv_p = uint16(permute(hdr_yuv, [2 1 3]));
    fwrite(ldr_fid, round(luv_p), 'uint16');
    fprintf(strcat('\nFrame ', num2str(i-1), ' done.'));
       
end 
fclose(ldr_fid); 
fprintf('\n\n\tENCODING COMPLETE... \n');
end 