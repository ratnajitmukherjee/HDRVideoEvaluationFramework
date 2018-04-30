function encode_refH264(algo_type, inputPath, outputPath, width, height, nFrames, QPLevels, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat, OS )
%% ENCODE_REFH264: Script for invoking parallel encoding using the reference H.264 script
% Author: Ratnajit Mukherjee, University of Warwick, 2015

%% Generate H.264 command scripts based on Inputs.
encoder_file = 'encoder_yuv422.cfg'; % anything else cam also be used but all options
profileidc = 244; levelidc = 51;

    switch OS
        case 'windows'            
            parallelizer = 'START ';
        case 'linux'
            parallelizer = 'gnome-terminal --tab-x ';
    end     

    for i = 1 : length(QPLevels)
        qp = QPLevels(i);
        switch algo_type            
            case 'single'
                % encoding only ldr yuv file 
                infile = fullfile(inputPath, 'ldr.yuv');
                outfile = fullfile(outputPath, 'ldr_QP');
                enc_cmd= generateH264Script(encoder_file, profileidc, levelidc, infile, outfile, qp, width, height, nFrames, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat);
                enc_ldr_cmd = [parallelizer enc_cmd ' &'];
                system(enc_ldr_cmd);
            case 'double'
                % encoding first ldr file
                infile = fullfile(inputPath, 'ldr.yuv');
                outfile = fullfile(outputPath, 'ldr_QP');
                enc_cmd= generateH264Script(encoder_file, profileidc, levelidc, infile, outfile, qp, width, height, nFrames, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat);
                enc_ldr_cmd = [parallelizer enc_cmd ' &'];
                system(enc_ldr_cmd);
                
                % encoding residual file
                subsamplingFormat = '400';
                infile = fullfile(inputPath, 'res.yuv');
                outfile = fullfile(outputPath, 'res_QP');                
                enc_cmd= generateH264Script(encoder_file, profileidc, levelidc, infile, outfile, qp, width, height, nFrames, IntraPeriod, bitdepthLuma, bitdepthChroma, subsamplingFormat);
                enc_res_cmd = [parallelizer enc_cmd ' &'];
                system(enc_res_cmd);
        end 
    end
end 

function [enc_cmd] = generateH264Script(encoder_file, profileidc, levelidc, inputfile, outputfile, qp, width, height, nFrames, intraperiod, bitdepthLuma, bitdepthChroma, subsamplingFormat)
 %% function to generate the command line arguments   
    encoder_main = 'lencod.exe';
    config_file = [' -f ' encoder_file];
    profileIDC = [' -p ProfileIDC = ' num2str(profileidc)];
    levelIDC = [' -p LevelIDC = ' num2str(levelidc)];
    inputfile = [' -p InputFile = ' inputfile];
    outputfile = [' -p OutputFile = ' outputfile num2str(qp) '.264'];
    srcWidth = [' -p SourceWidth = ' num2str(width)]; 
    srcHeight = [' -p SourceHeight = ' num2str(height)]; 
    outWidth =  [' -p OutputWidth = ' num2str(width)]; 
    outHeight =  [' -p OutputHeight = ' num2str(height)]; 
    frmEncoded = [' -p FramesToBeEncoded = ' num2str(nFrames)]; 
    gopStruct = [' -p IntraPeriod = ' num2str(intraperiod)]; 
    srcLuma = [' -p SourceBitDepthLuma = ' num2str(bitdepthLuma)];
    srcChroma = [' -p SourceBitDepthChroma = ' num2str(bitdepthChroma)];
    outLuma = [' -p OutputBitDepthLuma = ' num2str(bitdepthLuma)];
    outChroma = [' -p OutputBitDepthChroma = ' num2str(bitdepthChroma)];
    qpi = [' -p QPISlice = ' num2str(qp)];
    qpp = [' -p QPPSlice = ' num2str(qp)];
    
    switch subsamplingFormat 
        case '400'            
            sFormat = 0;
            yuvFormat = [' -p YUVFormat = ' num2str(sFormat)];
        case '420'
            sFormat = 1;
            yuvFormat = [' -p YUVFormat = ' num2str(sFormat)];
        case '422'
            sFormat = 2;
            yuvFormat = [' -p YUVFormat = ' num2str(sFormat)];
        case '444'
            sFormat = 3;
            yuvFormat = [' -p YUVFormat = ' num2str(sFormat)];
    end 
    enc_cmd = strcat(encoder_main, config_file, profileIDC, levelIDC, inputfile, ...
                    outputfile, srcWidth, srcHeight, outWidth, outHeight, ...
                    frmEncoded, gopStruct, srcLuma, srcChroma, outLuma, outChroma,...
                    yuvFormat, qpi, qpp);
end 
