function tmoEncodeDecode_hdrmpeg( write_path, width, height, nFrames, qp, codec, subsampling )
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
    
%% Colorspace conversion by ffmpeg
%     color_cmd = sprintf('ffmpeg-10bit -y -pix_fmt yuv%sp -s %dx%d -r %d -i %sldr_temp.yuv -f rawvideo -pix_fmt yuv444p -s %dx%d -r %d %sldr_temp444.yuv', subsampling, width, height, codec.fps, write_path, width, height, codec.fps, write_path);
%     system(color_cmd);
%     delete(fullfile(write_path, 'ldr_temp.yuv'));
%     movefile(fullfile(write_path, 'ldr_temp444.yuv'), fullfile(write_path, 'ldr_temp.yuv'));
        
end