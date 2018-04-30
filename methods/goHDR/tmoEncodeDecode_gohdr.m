function [status_enc, status_dec] = tmoEncodeDecode_gohdr(write_path, width, height, nFrames, qp, codec, subsampling)
%% Pre-Corrected LDR file encoding
    inputfile = fullfile(write_path, 'ldr.yuv');
    outputfile = fullfile(write_path, ['ldr_' subsampling '_QP']);
    encoder_cmd = sprintf('x264 --preset fast --profile high444 --input-depth 8 --input-csp i%s --input-res %dx%d --output-csp i%s --bframes 0 --fps %d --qp %d -o %s%d.264 %s', subsampling, width, height, subsampling, codec.fps, qp, outputfile, qp, inputfile);
%     encoder_cmd = sprintf('x265 --preset fast --profile main444-8 --bframes 3 --b-adapt 2 --qp %d --frames %d --fps %d --input-csp i%s --input-depth 8 --input-res %dx%d -o %s%d.265 --input %s', qp, nFrames, codec.fps, subsampling, width, height, outputfile, qp, inputfile );
    system(encoder_cmd);
end