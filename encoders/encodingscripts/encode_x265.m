function encode_x265(algo_type, inputPath, outputPath, width, height, QPLevels, bitdepth, nFrames, fps, subsamplingFormat, OS, encoding_scheme )
%ENCODE_X264: Invoking parallel encoding using x265 encoder
%   Author: Ratnajit Mukherjee, University of Warwick

    %% switch parallel struct
     switch OS
        case 'windows'            
            parallelizer = 'START ';
        case 'linux'
            parallelizer = 'gnome-terminal --tab -x ';
    end     
    
    parfor i = 1 : length(QPLevels)
        qp = QPLevels(i);
        switch algo_type            
            case 'single'
                % encoding only ldr yuv file 
                infile = fullfile(inputPath, 'ldr.yuv');
                outfile = fullfile(outputPath, ['ldr_' subsamplingFormat '_QP']);                
                enc_cmd= generateX265Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat);                
%                 enc_ldr_cmd = [parallelizer enc_cmd];
                system(enc_cmd);
            case 'double'
                % encoding first ldr file
                infile = fullfile(inputPath, 'ldr.yuv');
                outfile = fullfile(outputPath, ['ldr_' subsamplingFormat '_QP']);
                enc_cmd= generateX265Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat);
                enc_ldr_cmd = [parallelizer enc_cmd];
                system(enc_ldr_cmd);
                
                % encoding residual file                
                infile = fullfile(inputPath, 'res.yuv');
                outfile = fullfile(outputPath, ['res_' subsamplingFormat '_QP']);              
                enc_cmd= generateX265Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat);
                enc_res_cmd = [parallelizer enc_cmd];
                system(enc_res_cmd);
        end 
    end
end

function [enc_cmd] = generateX265Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat)

    % change exe and profile
    switch num2str(bitdepth)
        case '8'
            encoder_main = 'x265';
            profileIDC = ' --profile main444-8';
        case '10'
            encoder_main = 'x265-10bit';
            profileIDC = ' --profile main444-10';
    end   
    % rest of the parameters
    preset = ' --preset medium';
    bframes = ' --bframes 3 --b-adapt 2';
    tune = ' --tune psnr';    
    quality = sprintf(' --qp %d', qp);        
    frameDet = sprintf(' --frames %d --fps %d', nFrames, fps);
    inputCSP =sprintf(' --input-csp i%s', subsamplingFormat);
    inputDepth = sprintf(' --input-depth %d', bitdepth);    
    inputRES = sprintf(' --input-res %dx%d', width, height);
    outputPath = sprintf(' -o %s%d.265 ', outfile, qp);
    inputPath = sprintf(' --input %s', infile);
    
    % encoding script generation
    enc_cmd = strcat(encoder_main, profileIDC, preset, bframes, tune, quality,frameDet,...
                    inputDepth, inputCSP, inputRES, outputPath, inputPath);
                                
end 
