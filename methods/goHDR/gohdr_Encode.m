function gohdr_Encode( frame_path, start_frame, frame_step, last_frame, write_path, codec, subsampling )
%% goHDR compression method
% Author: Francesco Barntele, 2009
% Re-implementation: Kurt Debattista and Ratnajit Mukherjee, 2014

%% gohdr Encode pass1:     
        [width, height] = gohdr_Encode_pass1(frame_path, start_frame, frame_step, last_frame, write_path);

%% gohdr pass 2
    for i = 1 : numel(codec.quality_levels)
        qp = codec.quality_levels(i);
        nFrames = numel(start_frame:frame_step:last_frame);
        resEncodeDecode_gohdr(write_path, width, height, nFrames, qp, codec, subsampling);        
        %% hdrjpeg pass 2:
        gohdr_Encode_pass2( frame_path, start_frame, frame_step, last_frame, write_path, qp );
        tmoEncodeDecode_gohdr(write_path, width, height, nFrames, qp, codec, subsampling);       
        delete(fullfile(write_path, 'res_temp_400.yuv'));
    end 
    delete(fullfile(write_path, 'res_400.yuv'));
    delete(fullfile(write_path, 'ldr.vuv'));
end
