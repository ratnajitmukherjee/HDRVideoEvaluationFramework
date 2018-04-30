function hdrjpeg_Encode_pass2( frame_path, start_frame, frame_step, last_frame, write_path, qp)

    %% new files to be written
    
    ldr_fid = fopen(fullfile(write_path, 'ldr_precorrect.yuv'), 'w');
    res_fid = fopen(fullfile(write_path, 'res_400.yuv'), 'w');
    
    %% old files to be read back and processed
    ldr_temp_fid = fopen(fullfile(write_path, 'ldr_temp.yuv'), 'r');
    frames = start_frame:frame_step:last_frame;
    
    for i = 1:length(frames)    
        %% reading the frames
        if( exist( 'pfs_read_image', 'file' ) )
            hdr = pfs_read_image( sprintf( frame_path, frames(i) ) );
        else
            hdr = exrread([frame_path, sprintf('%.5d.exr', frames(i))]);
        end
        
        [height, width, ~] = size(hdr);

        %% Reading back frames from decoded ldr_temp.yuv
        YCbCr_return = fread(ldr_temp_fid, (width * height * 3), 'uint8');
        YCbCr_return = reshape(YCbCr_return, [width, height, 3]);
        YCbCr_res = uint8(permute(YCbCr_return, [2 1 3]));                 
        imTM = ycbcr2rgb(YCbCr_res);
        
        %% processing the frames
        [tmPC, lResi, s] = wEncode(hdr, imTM);    
        ycbcr = uint8(rgb2ycbcr(tmPC));

        %% writing the frames    
        ycbcr_p = permute(ycbcr, [2 1 3]);
        lResi_p = permute(lResi, [2 1]);

        fwrite(ldr_fid, ycbcr_p, 'uint8');
        fwrite(res_fid, lResi_p, 'uint8');
        aux_data(i) = s;        
        fprintf('\nFrame %d done. ',(i-1));
    
    end 
    fclose(ldr_fid); fclose(res_fid); fclose(ldr_temp_fid);    
    delete(fullfile(write_path, 'ldr_temp.yuv'));
%% Writing meta-data file
    save(fullfile(write_path, sprintf('aux_QP%d.mat', qp)), 'aux_data');
    
    fprintf('\n Auxiliary Data Written');
end 