function gohdr_Decode( read_path, width, height, nFrames, dest_path, qp )
%% subsampling conversion for x264
inputfile = fullfile(read_path, 'res.yuv');
newfile = fullfile(read_path, 'res_400.yuv');
    
% color space conversion for x264 yuv444 to yuv400
yuv2yuv(inputfile, width, height, '444', newfile, width, height, '400');    
delete(inputfile);
%% goHDR decoder main function
ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
res_fid = fopen(fullfile(read_path, 'res_400.yuv'), 'r');
load( fullfile(read_path, 'aux.mat') );

%% processing the frames
    for i = 1:nFrames
        ldr_frame = fread(ldr_fid, (width * height * 3), 'uint8');
        ldr_frame = reshape(ldr_frame, [width height 3]);
        chroma = ycbcr2rgb(uint8(permute(ldr_frame, [2 1 3])));

        res_frame = fread(res_fid, (width * height), 'uint8');
        res_frame = reshape(res_frame, [width height]);
        luma = uint8(permute(res_frame, [2 1]));
        
        s = aux_data(i);
        dec_hdr = RemoveSpecials(gLogDecode(chroma, luma, s));                
        dec_hdr = dec_hdr ./frame_multFactor;
        
        if( exist( 'pfs_write_image', 'file' ) )            
            pfs_write_image( fullfile(dest_path, sprintf('frame_%05d.exr', (i-1)) ), dec_hdr, '--fix-halfmax' );
        else
            exrwrite(dec_hdr, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
        end
    end
    
% The files need to be explcitly closed and cleared from the workspace
% because they cannot be deleted unless matlab workspace closes.
fclose(ldr_fid); fclose(res_fid); clear ldr_fid; clear res_fid;
end

