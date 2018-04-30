function hdrmpeg_Encode_pass2( frame_path, start_frame, frame_step, last_frame, write_path, qp )
%% Backwards Compatible HDR MPEG
% Author: Rafal Mantiuk, 2006, Siggraph 2006
% Re-implementation Ratnajit Mukherjee, University of Warwick, 2014

%% Header information
frames = start_frame:frame_step:last_frame;
nFrames = length(frames);
res_fid = fopen(fullfile(write_path, 'res.yuv'), 'w');
aux_stream = zeros([3 256 nFrames]);
qfactor_stream = zeros([256 3 nFrames]);
ldr_temp_fid = fopen(fullfile(write_path, 'ldr_temp.yuv'), 'r'); 

%% STEP 3: Reading back YCbCr from the decoded temp file    
    %% reading the HDR Frames
    for i = 1 : nFrames
        if( exist( 'pfs_read_image', 'file' ) )
            HDR = pfs_read_image( sprintf( frame_path, frames(i) ) );
        else
            HDR = exrread(fullfile(frame_path, sprintf('%05d.exr', (i-1))));
        end
        width = size(HDR,2); height = size(HDR,1);
        
    %% reading back ycbcr using the width height from the earlier encoding
        YCbCr_return = fread(ldr_temp_fid, (width * height * 3), 'uint8');
        YCbCr_return = reshape(YCbCr_return, [width, height, 3]);
        YCbCr_res = uint8(permute(YCbCr_return, [2 1 3]));                   
        
    %% STEP 4: Transforming LDR and HDR into compatible colour space.
        LDR_LUV = ColourLDR(ycbcr2rgb(YCbCr_res));  % was sRGB
        HDR_LUV = ColourHDR(HDR);

    %% STEP 5: Find Reconstruction function and construct residual stream
        RF = ldr2hdrLut(LDR_LUV, HDR_LUV);
        aux_stream(1,:,i) = RF;
        [imgRes, q_factor] = ResidualStream(LDR_LUV, HDR_LUV, RF);
        res_p = uint8(permute(imgRes, [2 1 3]));
        fwrite(res_fid, res_p, 'uint8'); % YUV monochrome stream.
        qfactor_stream(:,:,i) = q_factor;

    %% Status Message
    fprintf(strcat('\nResidual Frame ', num2str(i-1), ' done.'));
    end 
fclose(res_fid); 

%% saving the workspace as an auxiliary file
save(fullfile(write_path, sprintf('aux_QP%d.mat', qp)), 'aux_stream', 'qfactor_stream'); 
fprintf('\n\n\t ENCODING COMPLETE & AUXILIARY STREAM WRITTEN \n');

%% closing deleting the ldr_temp.yuv
    fclose(ldr_temp_fid);
%    delete(fullfile(write_path, 'ldr_temp.yuv'));          
end 
