function resEncodeDecode_hdrjpeg(write_path, width, height, nFrames, qp, codec, subsampling)
%% Pre-Corrected LDR file encoding
    inputfile = fullfile(write_path, 'ldr_precorrect.yuv');
    outputfile = fullfile(write_path, ['ldr_' subsampling '_QP']);
    encoder_cmd = sprintf('x264 --preset fast --profile high444 --input-depth 8 --input-csp i%s --input-res %dx%d --output-csp i%s --bframes 0 --fps %d --qp %d -o %s%d.264 %s', subsampling, width, height, subsampling, codec.fps, qp, outputfile, qp, inputfile);
%     encoder_cmd = sprintf('x265 --preset fast --profile main444-8 --bframes 3 --b-adapt 2 --qp %d --frames %d --fps %d --input-csp i%s --input-depth 8 --input-res %dx%d -o %s%d.265 --input %s', qp, nFrames, codec.fps, subsampling, width, height, outputfile, qp, inputfile );
    system(encoder_cmd);

%% Residual file encoding      
    inputfile = fullfile(write_path, 'res_400.yuv');
    newfile = fullfile(write_path, 'res.yuv');
    
    % color space conversion for x264 yuv400 to yuv420
    yuv2yuv(inputfile, width, height, '400', newfile, width, height, '420');    
    delete(inputfile);
    
    outputfile = fullfile(write_path, ['res_' subsampling '_QP']);
    subsampling = '420';
    encoder_cmd = sprintf('x264 --preset fast --profile high444 --input-depth 8 --input-csp i%s --input-res %dx%d --output-csp i%s --bframes 0 --fps %d --qp %d -o %s%d.264 %s', subsampling, width, height, subsampling, codec.fps, qp, outputfile, qp, newfile);
%     encoder_cmd = sprintf('x265 --preset fast --profile main444-8 --bframes 3 --b-adapt 2 --qp %d --frames %d --fps %d --input-csp i%s --input-depth 8 --input-res %dx%d -o %s%d.265 --input %s', qp, nFrames, codec.fps, subsampling, width, height, outputfile, qp, inputfile );
    system(encoder_cmd);
