function hdrmpeg_Encode( frame_path, start_frame, frame_step, last_frame, write_path,  codec, subsampling)
%% Backwards Compatible HDR MPEG
% Author: Rafal Mantiuk, 2006, Siggraph 2006
% Re-implementation Ratnajit Mukherjee, University of Warwick, 2014

%% Header information
frames = start_frame:frame_step:last_frame;
nFrames = length(frames);


%% this portion decides what to do in case of one & two pass encoding
    if (strcmp(codec.encoding_scheme, 'one_pass'))
        hdrmpeg_Encode_pass1(frame_path, start_frame, frame_step, last_frame, write_path); 
        hdrmpeg_Encode_pass2(frame_path, start_frame, frame_step, last_frame, write_path);
    elseif(strcmp(codec.encoding_scheme, 'two_pass'))
        [width, height] = hdrmpeg_Encode_pass1(frame_path, start_frame, frame_step, last_frame, write_path); 
%         colourSpaceConversion8bit(write_path, width, height, codec.fps, subsampling);
        for i = 1 : length(codec.quality_levels)            
            qp = codec.quality_levels(i);            
            nFrames = length(start_frame:frame_step:last_frame);               
            tmoEncodeDecode_hdrmpeg(write_path, width, height, nFrames, qp, codec, subsampling);
            hdrmpeg_Encode_pass2(frame_path, start_frame, frame_step, last_frame, write_path, qp);                        
            resEncodeDecode_hdrmpeg(write_path, width, height, nFrames, qp, codec, subsampling);
            delete(fullfile(write_path, 'res.yuv'));
        end 
        delete(fullfile(write_path, 'ldr.yuv'));
        delete(fullfile(write_path, 'ldr_temp.yuv'));
    end 
    
       
end 