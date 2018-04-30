function fraunhofer_Encode( frame_path, start_frame, frame_step, last_frame, write_path, bitdepth )
%% Temporally Coherent Luminance to Luma mapping for High Dynamic Range
% Videos with H.264/AVC
% Authors: Jen Uwe Garbas, Herbert Thoma
% Re-implementation: Ratnajit Mukherjee, University of Warwick
 
%% Header information
frames = start_frame:frame_step:last_frame;
ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');   
multfactor = round(2^bitdepth /0.62);
%% setting initial previous frame parameters
    prev_s.ymin = 0; prev_s.ymax = 0;
    
%% Processing Frames
for i = 1:length(frames)
    if( exist( 'pfs_read_image', 'file' ) )
        hdr = pfs_read_image( sprintf( frame_path, frames(i) ) );
    else
        hdr = exrread(fullfile(frame_path, sprintf('%.5d.exr', frames(i))));
    end
    hdr = ClampImg(hdr, 1e-4, max(hdr(:)));
    
    if ((i==1) || (mod(i, 15) == 0))
        frame_type = 'iframe';
    else 
        frame_type = 'pframe';
    end     
    [LUV_HDR, s] = frn_rgb2yuv(hdr, prev_s, frame_type, bitdepth); 
    prev_s = s;  
    aux_data(i) = s; % updating the lookup table
    luv_p = permute(LUV_HDR, [2 1 3]);
    luv_p = uint16(round(luv_p));
    fwrite(ldr_fid, luv_p, 'uint16');
    fprintf('\n Frame %.5d done', (i-1));
end 
fclose(ldr_fid);
save(fullfile(write_path, 'aux.mat'), 'aux_data', 'multfactor');

%% Final status print    
fprintf('\n\n\tENCODING COMPLETE..\n');
end