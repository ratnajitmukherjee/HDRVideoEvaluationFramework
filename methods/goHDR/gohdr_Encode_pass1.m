function [width, height] = gohdr_Encode_pass1(frame_path, start_frame, frame_step, last_frame, write_path)
%% gohdr encode pass for luma channel
frames = start_frame:frame_step:last_frame;
res_fid = fopen(fullfile(write_path, 'res_400.yuv'), 'w');
frame_multFactor = 1e-1;

    for i = 1:length(frames)
        if( exist( 'pfs_read_image', 'file' ) )
            hdr = pfs_read_image( sprintf( frame_path, frames(i) ) );
        else
            hdr = double(exrread([frame_path, sprintf('%.5d.exr', frames(i))]));
            [height, width, ~] = size(hdr);
        end
        
        %% manipulation and data retrieval from hdr
        hdr = hdr.* frame_multFactor;        
        %% luminance manupulation
        lumhdr = 0.213*hdr(:,:,1) + 0.715*hdr(:,:,2) + 0.072*hdr(:,:,3);
        constMult = harmmean(lumhdr(:)); % harmonic mean of the luminance
        tmlum = log2(1 + lumhdr); 

        %make smooth
        tmlumfil = shiftableBF(tmlum, 4, 2, 5, 0);
        tmlumfil = (2.^(tmlumfil)) - 1;
        % use sigmoid for TM luminance
        tmlum = tmlumfil ./ (1 + (constMult * tmlumfil));

        [tmlum ,rminVal, rmaxVal] = glogEncodeResidual(tmlum);        
        s = struct('rminVal',rminVal,'rmaxVal',rmaxVal, 'constMult', constMult);
        aux_data(i) = s;
        luma_p = permute(tmlum , [2 1]);
        fwrite(res_fid, luma_p, 'uint8');
        fprintf('\n Luma frame %d processed.', (i-1));
    end 
    save(fullfile(write_path, 'aux.mat'), 'aux_data', 'frame_multFactor');
end 