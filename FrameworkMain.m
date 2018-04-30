%% Main Script of the framework
% Framework Controls: 
%       a) Compression Methods
%       b) Codec Controllers: for Encoding and Decoding using multiple
%       encoders and decoders
%       c) Decompression Methods
%       d) Evaluation Methods
%       e) Final Results analysis //this is under construction
%
% Author: Ratnajit Mukherjee, University of Warwick, 2015

%% Clearing all previous workspace and command window
    clear all; clc;

%% header information 

    fprintf('\n\n ************FRAMEWORK STARTING**************\n\n');
    fpath = '/mnt/scratch/reference/';   
    % destination directory for .yuv and .264/.265 files
    write_path = '/mnt/scratch/10bitEval/';     
    footage = {'s01', 's02', 's03', 's04', 's05', 's06',  's08', 's10', 's12', 's13', 's14', 's15', ...
                's16', 's17', 's18', 's19','s20', 's21', 's22', 's23', 's24', 's25', 's26', 's27', ...
                's28', 's29','s30','s31', 's32', 's33', 's34', 's35', 's36', 's37', 's38', 's39', 's40'};    
    % final results path: should be a different path - write_path files
    % will be deleted for compaction for efficiency
    results_path = '/home/visualisation/Desktop/EvalResults/';
    % compression methods to be evaluated    
    comp_methods = {'hdrv', 'pq', 'gamma4', 'bbc_hlg'};
    
    % Subsampling Formats to be used for evaluations
    yuv_fmt = [420]; % this could have been a part of codec structure but it would be difficult to uncouple
    
    % Frame Information - structure
    frame_info.start_frame = 0; frame_info.frame_step = 1; frame_info.last_frame = 29;
    
    % Encoder to be called - structure 
    encoders = {'x265'};
    codec.bitdepth = 10; % this is either 8 or 10
    nFrames = length(frame_info.start_frame:frame_info.frame_step:frame_info.last_frame);
    codec.nFrames = nFrames;    
    codec.fps = 30; codec.OS = 'linux';
    codec.quality_levels = [0:5:50];      
    codec.encoding_scheme = 'one_pass';  % this is either 1 pass or 2 pass
    
    %% Calling Controller Scripts 
    
    if(codec.quality_levels(1) == -1)
        tbl_coding_error = controlCodingError(comp_methods, footage, fpath, write_path, frame_info, 0, codec);
        save(fullfile(results_path, 'tbl_coding_errors.mat'), 'tbl_coding_error');
        return;
    end 
    
    for i = 1 : length(comp_methods)
        method = comp_methods{i};
        for j = 1 : length(footage)
            sequence = footage{j};
            frame_path = fullfile(fpath, sequence, '/');             
            for k = 1 : length(encoders)
                codec.name = encoders{k};
                for s = 1 : length(yuv_fmt)
                    subsampling = num2str(yuv_fmt(s));            
                    eval_matrix = controlCompressionDecompressionMain(method, frame_path, write_path, frame_info, subsampling, codec);            
                    if(~exist(results_path, 'dir'))
                        mkdir(results_path);
                    end 
                    save(fullfile(results_path, ['eval_' method '_' codec.name '_' subsampling '_' sequence '.mat']), 'eval_matrix');
                end 
            end             
        end 
    end 
    
%% Results analysis to be integrated later for end to end compression results 
% (check resultsanalysis folder for current version)