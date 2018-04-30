function rate_Encode(frame_path, start_frame, frame_step, last_frame, write_path, codec, subsampling)
%% Rate Distortion Optimized Compression of High Dynamic Range Videos
% Author: Chul Lee and Kim, 2008
% Re-Implementation: Ratnajit Mukherjee, University of Warwick, 2014                      
%% Header information
frames = start_frame:frame_step:last_frame;
nFrames = numel(frames);

%% rate distortion pass 1:
    [width, height] = rate_Encode_pass1(frame_path, write_path, nFrames);
   
%% rate distortion pass 2:
    for i = 1 : numel(codec.quality_levels)
        qp = codec.quality_levels(i);
        tmoEncodeDecode_rate(write_path, width, height, nFrames, qp, codec, subsampling);
        rate_Encode_pass2(frame_path, start_frame, frame_step, last_frame, write_path, qp);
        resEncodeDecode_rate( write_path, width, height, nFrames, qp, codec, subsampling);
        delete(fullfile(write_path, 'ldr_temp.yuv'));
    end 

%% Status message printout
fprintf('\n\n Encoding Complete..\n');
end 