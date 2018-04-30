function hdrjpeg_Encode( frame_path, start_frame, frame_step, last_frame, write_path, codec, subsampling )
%% Subband compression of HDR-JPEG
% Author: Greg Ward and Simmons, 2004 Siggraph
% Modified for video Re-implementation: Kurt Debattista and Ratnajit
% Mukherjee, 2014

%% Header information
    nFrames = length(start_frame:frame_step:last_frame);
    %% hdrjpeg pass 1:
        [width, height] = hdrjpeg_Encode_pass1( frame_path, start_frame, frame_step, last_frame, write_path );
        
    %%  Tone Mapped frame encode - decode commented for cluster run
%     colourSpaceConversion(write_path, width, height, codec.fps, subsampling);
    for i = 1 : numel(codec.quality_levels)
        qp = codec.quality_levels(i);
        tmoEncodeDecode_hdrjpeg(write_path, width, height, nFrames, qp, codec, subsampling);        
        %% hdrjpeg pass 2:
        hdrjpeg_Encode_pass2( frame_path, start_frame, frame_step, last_frame, write_path, qp );
        resEncodeDecode_hdrjpeg(write_path, width, height, nFrames, qp, codec, subsampling);
        delete(fullfile(write_path, 'ldr_precorrect.yuv'));
        delete(fullfile(write_path, 'res.yuv'));
    end 
    delete(fullfile(write_path, 'ldr.vuv'));
%% Final Status Message
fprintf('\n\n HDR-JPEG COMPRESSION COMPLETE...\n');  

%% commented for cluster run
% fEncodeDecode(write_path, 1920, 1080, nFrames, 2);
end 