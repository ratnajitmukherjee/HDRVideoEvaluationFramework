function codec_Controller(codecMain, inputPath, outputPath, algo_type, width, height, QPLevels, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat, OS)
%% Main Function to control all the encoders 
% Author: Ratnajit Mukherjee, University of Warwick, 2015
    % -------- input parameters: 
    % -codecMain: instructs the function to use specific encoder (default
    % x264)
    % -inputPath: input yuv file path (will return)
    % -outputPath: output .264 / .265 files
    % width, height: the width and height of frames (in 444 format)
    % QPLevels: the quality at which they are to be encoded
    % Intraperiod: specifies size of GOP (default I-period = 30)
    % bitdepthLuma/bitdepthChroma: specify the bitdepth of luma and chroma
    % (default is 8)
    % subsampling format: 444/422/420 format. (default - 420 industry
    % standard)
    
    %% nargin check
    if (isempty(codecMain))
        codecMain = 'x264';
    end 
    
    if (isempty(inputPath) && isempty(outputPath))
        warning('ERROR: input or output path not specified.. Try again.');
        return;
    end 
    
    if(isempty(algo_type))
        algo_type = 'single';
    end 
    
    if (isempty(width) || isempty(height))
        warning('ERROR: Frame size not mentioned. Defaulting to 1920x1080');
        width = 1920; height = 1080;
    end 
    
    if (isempty(QPLevels))
        QPLevels = [1, 10, 20, 30, 40, 50];
    end 
    
    if (isempty(bitdepthLuma) || isempty(bitdepthChroma))
        bitdepthLuma = 8; bitdepthChroma = 8;
    end     
    if (isempty(subsamplingFormat))
        subsamplingFormat = '420';
    end 
    if(isempty(OS))
        OS = 'windows';
        % note: commands for linux and mac should be the same as they run
        % the same Unix shell.
    end     
    %% codec control
    switch codecMain
        case 'refH264'
            encode_refH264(inputPath, outputPath, algo_type, width, height, QPLevels, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat, OS);
        case 'x264'
            encode_x264(inputPath, outputPath, algo_type, width, height, QPLevels, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat, OS);
        case 'x265'
            encode_x265(inputPath, outputPath, algo_type, width, height, QPLevels, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat, OS);
        case 'vp9'
            warning('VP9 codec 10 bit is not complete AS OF NOW');
    end 
end 