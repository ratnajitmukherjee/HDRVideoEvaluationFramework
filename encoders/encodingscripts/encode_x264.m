function encode_x264(algo_type, inputPath, outputPath, width, height, QPLevels, bitdepth, nFrames, fps, subsamplingFormat, OS, encoding_scheme )
%ENCODE_X264: Invoking parallel encoding using x264 encoder
%   Author: Ratnajit Mukherjee, University of Warwick

    %% switch parallel struct
     switch OS
        case 'windows'            
            parallelizer = 'START ';
        case 'linux'
            parallelizer = 'gnome-terminal --tab-x ';
    end     

    parfor i = 1 : length(QPLevels)
        qp = QPLevels(i);
        switch algo_type            
            case 'single'
                % encoding only ldr yuv file 
                infile = fullfile(inputPath, 'ldr.yuv');
                outfile = fullfile(outputPath, ['ldr_' subsamplingFormat '_QP']);
                enc_cmd= generateX264Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat);
                %enc_ldr_cmd = [parallelizer enc_cmd];
                system(enc_cmd);
            case 'double'
                if (strcmp(encoding_scheme, 'one_pass'))
                    % encoding first ldr file
                    infile = fullfile(inputPath, 'ldr.yuv');
                    outfile = fullfile(outputPath, ['ldr_' subsamplingFormat '_QP']);
                    enc_cmd= generateX264Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat);
                    enc_ldr_cmd = [parallelizer enc_cmd];
                    system(enc_ldr_cmd);

                    % encoding residual file                
                    infile = fullfile(inputPath, 'res.yuv');
                    outfile = fullfile(outputPath, ['res_' subsamplingFormat '_QP']);              
                    enc_cmd= generateX264Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat);
                    enc_res_cmd = [parallelizer enc_cmd];
                    system(enc_res_cmd);  
                    
                elseif(strcmp(encoding_scheme, 'two_pass'))
                    % encoding residual file                
                    infile = fullfile(inputPath, 'res.yuv');
                    outfile = fullfile(outputPath, ['res_' subsamplingFormat '_QP']);              
                    enc_cmd= generateX264Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat);
                    enc_res_cmd = [parallelizer enc_cmd];
                    system(enc_res_cmd);
                end 
        end 
    end
end

function [enc_cmd] = generateX264Script(infile, outfile, qp, width, height, bitdepth, nFrames, fps, subsamplingFormat)
        
    switch num2str(bitdepth)
        case '8'
            encoder_main = 'x264';
        case '10'
            encoder_main = 'x264-10bit';
    end 
    
    profileIDC = ' --profile high444';
    preset = ' --preset veryslow';
    bframes = ' --bframes 3 --b-adapt 2';
    tune = ' --tune psnr';
    quality = sprintf(' --qp %d', qp);
    frameDet = sprintf(' --frames %d --fps %d', nFrames, fps);
    inputDepth = sprintf(' --input-depth %d', bitdepth);    
    inputCSP =sprintf(' --input-csp i444');
    inputRES = sprintf(' --input-res %dx%d', width, height);
    outputCSP = sprintf(' --output-csp i%s', subsamplingFormat);
    outputPath = sprintf(' -o %s%d.264 ', outfile, qp);
    infile = [' ' infile];
    
    enc_cmd = strcat(encoder_main, profileIDC, preset, bframes, tune, quality, frameDet,...
                    inputDepth, inputCSP, inputRES, outputCSP, outputPath, infile);
                                
end 
