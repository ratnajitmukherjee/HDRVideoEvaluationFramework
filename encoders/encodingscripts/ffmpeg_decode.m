function ffmpeg_decode( write_path, qp, codec, subsampling, algotype)
%% FFMPEG_DECODE: Decoding script .264/.265/.vp9 to .yuv
%   ffmpeg decoders decodes faster than reference H.264/H.265
    switch codec
        case 'x264';
            ext = '.264';
        case 'x265'
            ext = '.265';
        case 'vp9'
            ext = '.vp9';
    end 
    if (strcmp(algotype, 'single'))    
        encoded_file = fullfile(write_path, ['ldr_' subsampling '_QP' num2str(qp) ext]);    
        dec_cmd = sprintf('ffmpeg-10bit -y -i %s -c:v rawvideo -pix_fmt yuv444p10le %sldr.yuv', encoded_file, write_path);  
        system(dec_cmd);
    end 
    
    if (strcmp(algotype, 'double'))        
        encoded_file = fullfile(write_path, ['ldr_' subsampling '_QP' num2str(qp) ext]);    
        dec_cmd = sprintf('ffmpeg-10bit -y -i %s -c:v rawvideo -pix_fmt yuv444p %sldr.yuv', encoded_file, write_path);  
        system(dec_cmd);
        
        encoded_file = fullfile(write_path, ['res_' subsampling '_QP' num2str(qp) ext]);
        dec_cmd = sprintf('ffmpeg-10bit -y -i %s -c:v rawvideo -pix_fmt yuv444p %sres.yuv', encoded_file, write_path);
        system(dec_cmd);
    end 
end

