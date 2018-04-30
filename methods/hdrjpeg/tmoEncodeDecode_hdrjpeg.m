function [status_enc, status_dec] = tmoEncodeDecode_hdrjpeg(  write_path, width, height, nFrames, qp, codec, subsampling )
%% Interrupted TMO encode for Residual prediction  
% reference encoder   
    inputfile = fullfile(write_path, 'ldr.yuv');
    outputfile = fullfile(write_path, ['ldr_' subsampling '_QP']);
    encoder_cmd = sprintf('x264 --preset fast --profile high444 --input-depth 8 --input-csp i%s --input-res %dx%d --output-csp i%s --bframes 0 --fps %d --qp %d -o %s%d.264 %s', subsampling, width, height, subsampling, codec.fps, qp, outputfile, qp, inputfile);
%     encoder_cmd = sprintf('x265 --preset fast --profile main444-8 --bframes 3 --b-adapt 2 --qp %d --frames %d --fps %d --input-csp i%s --input-depth 8 --input-res %dx%d -o %s%d.265 --input %s', qp, nFrames, codec.fps, subsampling, width, height, outputfile, qp, inputfile );
    system(encoder_cmd);
%     delete(inputfile);

%% Interupted TMO decode for Residual prediction 
    encoded_file = [outputfile num2str(qp) '.264'];
%     dec_cmd = sprintf('HMDec -b %s -o %sldr_temp.yuv', outputfile, write_path);
    dec_cmd =  sprintf('ffmpeg-10bit -y -i %s -c:v rawvideo -pix_fmt yuv444p %sldr_temp.yuv', encoded_file, write_path);
    system(dec_cmd);    
    delete(encoded_file);
end