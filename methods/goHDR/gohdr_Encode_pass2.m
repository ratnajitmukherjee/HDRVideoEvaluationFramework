function  gohdr_Encode_pass2( frame_path, start_frame, frame_step, last_frame, write_path, qp )
%% gohdr encode pass2 for luma channel

%% header information
gamma = 2.2;
invgamma = 0.4545;
frames = start_frame:frame_step:last_frame;
ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');
res_fid = fopen(fullfile(write_path, 'res_temp_400.yuv'), 'r');
load(fullfile(write_path, 'aux.mat'));

%% processing second pass
    for i = 1 : length(frames)
        
        % reading and manipulating the hdr 
        if( exist( 'pfs_read_image', 'file' ) )
            hdr = pfs_read_image( sprintf( frame_path, frames(i) ) );
        else
            hdr = double(exrread([frame_path, sprintf('%.5d.exr', frames(i))]));
        end
        hdr = hdr.* frame_multFactor; 
        
        [height, width, ~] = size(hdr);
        
        % reading residual file
        res_frame = fread(res_fid, (width * height), 'uint8');
        res_frame = reshape(res_frame, [width height]);
        tmlum = uint8(permute(res_frame, [2 1]));
        
        % loading aux data
        s = aux_data(i);                   
        
        % creation of chroma stream
        templum = glogDecodeResidual(tmlum, s.rminVal, s.rmaxVal); 
        templum = templum ./ (1 - (templum * s.constMult)); 

        tempchroma = zeros(size(hdr), 'double');
        for j = 1:3
            tempchroma(:, :, j) = hdr(:, :, j) ./ templum;
        end
        chroma = tempchroma; 
      
        tmchroma = chroma ./ ((chroma) + 1); 
        tmchroma = uint8((real(tmchroma.^invgamma)*255)); 
        ycbcr = real(rgb2ycbcr(tmchroma));
        chroma_p= permute(ycbcr, [2 1 3]);
        fwrite(ldr_fid, chroma_p, 'uint8');
        fprintf('\n Chroma frame %d done', (i-1));
    end
    fclose(ldr_fid);  fclose(res_fid);     
end 
