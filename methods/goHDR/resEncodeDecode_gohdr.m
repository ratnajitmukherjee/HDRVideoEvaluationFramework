function [status_enc, status_dec] = resEncodeDecode_gohdr( write_path, width, height, nFrames, qp, codec, subsampling )
%% Residual file encoding      
    inputfile = fullfile(write_path, 'res_400.yuv'); % this is the permanent file
    newfile = fullfile(write_path, 'res.yuv');
    
    % color space conversion for x264 yuv400 to yuv420 
    subsampling_out = '420'; % this is trick to the codec
    yuv2yuv(inputfile, width, height, '400', newfile, width, height, '420');    
    
    outputfile = fullfile(write_path, ['res_' subsampling '_QP']);   
    encoder_cmd = sprintf('x264 --preset fast --profile high444 --input-depth 8 --input-csp i%s --input-res %dx%d --output-csp i%s --bframes 0 --fps %d --qp %d -o %s%d.264 %s', subsampling_out, width, height, subsampling_out, codec.fps, qp, outputfile, qp, newfile);
%     encoder_cmd = sprintf('x265 --preset fast --profile main444-8 --bframes 3 --b-adapt 2 --qp %d --frames %d --fps %d --input-csp i%s --input-depth 8 --input-res %dx%d -o %s%d.265 --input %s', qp, nFrames, codec.fps, subsampling, width, height, outputfile, qp, inputfile );
    system(encoder_cmd);
    delete(newfile);
    
%% Interupted RES decode for TMO prediction 
    encoded_file = [outputfile num2str(qp) '.264'];
%     dec_cmd = sprintf('HMDec -b %s -o %sldr_temp.yuv', outputfile, write_path);
    dec_cmd =  sprintf('ffmpeg-10bit -y -i %s -c:v rawvideo -pix_fmt yuv444p %sres_temp.yuv', encoded_file, write_path);
    system(dec_cmd);    
%     delete(encoded_file);

%% converting res file
    inputfile = fullfile(write_path, 'res_temp.yuv');
    newfile = fullfile(write_path, 'res_temp_400.yuv');
    
    % color space conversion for x264 yuv400 to yuv420
    yuv2yuv(inputfile, width, height, '444', newfile, width, height, '400');    
    delete(inputfile);
end