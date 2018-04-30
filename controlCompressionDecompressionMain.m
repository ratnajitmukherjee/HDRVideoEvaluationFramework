function [eval_matrix] = controlCompressionDecompressionMain(method, frame_path, write_path, frame_info, subsampling, codec)
%% Reserved for further comments


    %% Calling the compression Script
    [frame_info.height, frame_info.width] =  AllCompressionMain(method, frame_path, frame_info, write_path, codec, subsampling);        
    %% Calling Encoders (the encoders are only called if QP >=0 else we are checking coding errors)
                      
        % deciding algo type i.e. single / double stream
        if (strcmp(method, 'pq') || strcmp(method, 'pq_ipt') || strcmp(method, 'hdrv')|| strcmp(method, 'fraunhofer')|| strcmp(method, 'pq') || strcmp(method, 'gamma2')  || strcmp(method, 'gamma4') || strcmp(method, 'gamma6') || strcmp(method, 'gamma8') || strcmp(method, 'bbc') || strcmp(method, 'icam') || strcmp(method, 'bbc_hlg'))
            algotype = 'single';
        else 
            algotype = 'double';            
        end 
        
        % setting encoder parameters - encoding         
        if (~strcmp(codec.encoding_scheme, 'two_pass'))
            switch codec.name
                case 'x264'            
                    encode_x264(algotype, write_path, write_path, frame_info.width, frame_info.height, codec.quality_levels, codec.bitdepth, codec.nFrames, codec.fps, subsampling, codec.OS, codec.encoding_scheme);
                case 'x265'
                    colourSpaceConversion(write_path, frame_info.width, frame_info.height, codec.fps, subsampling);
                    encode_x265(algotype, write_path, write_path, frame_info.width, frame_info.height, codec.quality_levels, codec.bitdepth, codec.nFrames, codec.fps, subsampling, codec.OS, codec.encoding_scheme);
                case 'vp9'
                    encode_vp9(algotype, write_path, write_path,frame_info.width, frame_info.height, codec.quality_levels, codec.bitdepth, codec.nFrames, codec.fps, subsampling, codec.OS);
            end
        end 
        
        % delete ldr.yuv because that will be used during reconstruction
        delete(fullfile(write_path, 'ldr.yuv'));        
        
%% Evaluation Starts from here
        % step 1: Decode Convert the video file to yuv444 by upsampling         
        % step 3: Decompress the yuv444p to resultant exrs
        % step 4: Evaluate the yuv444p against a multitude of metrics
                
        QPLevels = codec.quality_levels;        
        for i = 1 : length(QPLevels)
            qp = QPLevels(i);
            % decoding the encoded file
            switch codec.name
                case 'x264'
                    ffmpeg_decode(write_path, qp, codec.name, subsampling, algotype);                        
                case 'x265'
                    refH265_decode(write_path, qp, codec.name, subsampling, algotype, frame_info, codec.fps, codec.bitdepth);
            end 
            
            % Decompression to exrfiles - dest path
            read_path = write_path; 
            dec_write_path = fullfile(write_path, 'dec_frames/');            
            %checking whether decoded write path exists or not
            if(~exist(dec_write_path, 'dir'))
                mkdir(dec_write_path);
            end 
           
            AllDecompressionMain(method, read_path, frame_info.width, frame_info.height, codec.nFrames, dec_write_path, codec.bitdepth, qp);
            
%% Evaluation using a multitude of metrics
            [bpp, qm] = evaluation_control(method, frame_path, write_path, dec_write_path, frame_info, subsampling, qp, codec.name, algotype);                                               
            eval_metrics(i, 1) = qp; eval_metrics(i,2) = bpp; eval_metrics(i,3) = qm.psnr_rgb; 
            eval_metrics(i,4) = qm.psnr_y;eval_metrics(i,5) =qm.logpsnr_rgb; 
            eval_metrics(i,6) = qm.logpsnr_y;eval_metrics(i,7) = qm.pupsnr_y;
            eval_metrics(i, 8) = qm.pussim_y; eval_metrics(i,9) = qm.weber_mse;
            eval_metrics(i,10) = qm.vdp_Q; 
            eval_metrics(i,11) = qm.hdrvqm;eval_metrics(i, 12) = qm.hdrvqm_norm;         
        end 
                
        eval_matrix = flipud(eval_metrics); % imp step to flip matrix
        
%% Cleanup the yuv and mat from the Evaluation folder
        delete(fullfile(write_path, '*.yuv'));
        delete(fullfile(write_path, '*.mat'));
        delete(fullfile(write_path, '*.265')); % delete this later

end

function [bpp, qm] = evaluation_control(method, frame_path, write_path, dec_write_path, frame_info, subsampling, qp, ext_name, algotype)
    % calculation bits/pixel or bitrate
    switch ext_name
        case 'x264'
            ext = '.264';
        case 'x265'
            ext = '.265';
        case 'vp9'
            ext = '.vp9';
        otherwise 
            error('Invalid File Extension');
    end 
    f_det = dir(fullfile(write_path, sprintf('ldr_%s_QP%d%s', subsampling, qp, ext)));    
    fsize = f_det.bytes; 
    if(strcmp(algotype, 'double'))
        f_det = dir(fullfile(write_path, sprintf('res_%s_QP%d%s', subsampling, qp, ext)));    
        fsize = fsize + f_det.bytes;         
    end 
    nFrames = length(frame_info.start_frame:frame_info.last_frame);
    bpp = ((fsize/nFrames)/(frame_info.width * frame_info.height)) * 8;
    qm = getObjectiveEvaluation(frame_path, dec_write_path, frame_info.start_frame, frame_info.last_frame);    
    
%% Only unlock this section to create subjective experiment files
            outputpath = '/mnt/scratch/experimentfiles/';
            substr = strsplit(frame_path, '/');
            seq = substr{numel(substr)-1}; % this extracts the last token
            outputpath = fullfile(outputpath, method, seq);
            copyOutputSubjective(dec_write_path, outputpath, 'normal');
%% cleanup of the exr frames from write folder and subfolders
    delete(fullfile(dec_write_path, '*.exr'));
    delete(fullfile(write_path, sprintf('ldr_%s_QP%d%s', subsampling, qp, ext)));
    if (strcmp(algotype, 'double'))
        delete(fullfile(write_path, sprintf('res_%s_QP%d%s', subsampling, qp, ext)));
    end
end 

