function [height, width] = AllCompressionMain( compression_method, frame_path, frame_info, write_path, codec, subsampling)
%% AllCompressionMain: 
% This function controls all the compression methods. Works as an entry
% point from where each function is called based on user input.
% NOTE: Stage Level Control: 2 

%% nargin check
    if(~(exist(write_path, 'dir')))
        mkdir(write_path);
    end           
    
%% switchable command line for calling different compression methods.

    switch compression_method,         
        case 'hdrv',
            hdrv_Encode( frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth );
        case 'fraunhofer',
            fraunhofer_Encode( frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth );
        case 'pq'
            pq_Encode( frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth );
        case 'pq_ipt'
            pq_ipt_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth );
        case 'tonemapping'
            tm_Encode( frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth );
        case 'hvs'
            hvs_Encode( frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth );
        %% several itreations of gamma
        case 'gamma2'
            g_param = 2.2;
            gamma8_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth, g_param);                        
        case 'gamma4'
            g_param = 4;
            gamma8_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth, g_param);            
        case 'gamma6'
            g_param = 6;
            gamma8_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth, g_param);            
        case 'gamma8'
            g_param = 8;
            gamma8_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth, g_param);
        %% end of iterations
        case 'icam'
            iCAM_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth);
        case 'hdrmpeg'
            hdrmpeg_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec, subsampling );
        case 'hdrjpeg'
            hdrjpeg_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec, subsampling );
        case 'gohdr'
            gohdr_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec, subsampling );
        case 'rate'
            rate_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec, subsampling);
        case 'bbc'            
            bbc_Encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth);
        case 'bbc_hlg'            
            bbc_hlg_encode(frame_path, frame_info.start_frame, frame_info.frame_step, frame_info.last_frame, write_path, codec.bitdepth);
        otherwise,                         
            error('Compression method ''%s'' unsupported!', compression_method);
    end
    
%% Obtain the height and width of the frames
    test_hdr = exrread(fullfile(frame_path, '00000.exr'));
    [height, width, ~] = size(test_hdr);
end

