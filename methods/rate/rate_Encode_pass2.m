function rate_Encode_pass2( frame_path, start_frame, frame_step, last_frame, write_path, qp )
%% Construct the Ratio stream
frames = start_frame:frame_step:last_frame;
res_fid = fopen(fullfile(write_path, 'res_400.yuv'), 'w');

%% Lee and Kim TMO parameters
fSaturation = 0.6;  %as in the original paper
epsilon = 0.05;     %as in the original paper 

%% Read the LDR frame and construct the ratio frame
ldr_fid = fopen(fullfile(write_path, 'ldr_temp.yuv'), 'r');
for i = 1: length(frames) 
    if(exist('pfs_read_image', 'file'))
        hdr = pfs_read_image( sprintf( frame_path, frames(i) ) );
    else 
        hdr = exrread(fullfile(frame_path, sprintf('%05d.exr', frames(i))));
        [height, width, ~] = size(hdr);
    end     
        % retracing back some of the steps of the LDR frame
        ldr_frame = fread(ldr_fid, (width * height * 3), 'uint8');
        ldr_frame = reshape(ldr_frame, [width height 3]);
        ldr_frame = ycbcr2rgb(uint8(ldr_frame));
        tmo = permute(ldr_frame, [2 1 3]);         
        [res, s] = rEncode(hdr, tmo, epsilon, fSaturation);
        res = permute(res, [2 1]);
        aux_data(i) = s;                  
        fwrite(res_fid, res, 'uint8');    
        fprintf('\n Frame %d done', (i-1));
end 

%% Closing files and cleaning up
    fclose(ldr_fid); fclose(res_fid); 
    %% Saving the frame metadata
    save(fullfile(write_path, sprintf('aux_QP%d.mat', qp)), 'aux_data');
end

