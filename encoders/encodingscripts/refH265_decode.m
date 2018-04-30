function refH265_decode( write_path, qp, codec, subsampling, algotype, frame_info, fps, bitdepth )
%% REFH265_DECODE Summary of this function goes here
%   Reference H.265 decoder

    switch codec
        case 'x264';
            ext = '.264';
        case 'x265'
            ext = '.265';
        case 'vp9'
            ext = '.vp9';
    end 

    encoded_file = fullfile(write_path, ['ldr_' subsampling '_QP' num2str(qp) ext]);
    dec_cmd = sprintf('HMDec -b %s -o %sldr_temp.yuv', encoded_file, write_path);
    system(dec_cmd);
    
    % colorspace conversion for the base stream
    if(bitdepth == 10)
        color_cmd = sprintf('ffmpeg-10bit -y -pix_fmt yuv%sp10le -s %dx%d -r %d -i %sldr_temp.yuv -f rawvideo -pix_fmt yuv444p10le -s %dx%d -r %d %sldr.yuv', subsampling, frame_info.width, frame_info.height, fps, write_path,frame_info.width, frame_info.height, fps, write_path);
        system(color_cmd);
        delete(fullfile(write_path, 'ldr_temp.yuv'));    
    elseif(bitdepth == 8)
        color_cmd = sprintf('ffmpeg-10bit -y -pix_fmt yuv%sp -s %dx%d -r %d -i %sldr_temp.yuv -f rawvideo -pix_fmt yuv444p -s %dx%d -r %d %sldr.yuv', subsampling, frame_info.width, frame_info.height, fps, write_path,frame_info.width, frame_info.height, fps, write_path);
        system(color_cmd);
        delete(fullfile(write_path, 'ldr_temp.yuv'));       
    end 
    
    %% decoding and colorspace conversion for residual stream
    if (strcmp(algotype, 'double'))
        encoded_file = fullfile(write_path, ['res_' subsampling '_QP' num2str(qp) ext]);
        dec_cmd = sprintf('HMDec -b %s -o %sres_temp.yuv', encoded_file, write_path);        
        system(dec_cmd);
        
        color_cmd = sprintf('ffmpeg-10bit -y -pix_fmt yuv%sp -s %dx%d -r %d -i %sres_temp.yuv -f rawvideo -pix_fmt yuv444p -s %dx%d -r %d %sres.yuv', subsampling, frame_info.width, frame_info.height, fps, write_path,frame_info.width, frame_info.height, fps, write_path);
        system(color_cmd);
        delete(fullfile(write_path, 'res_temp.yuv')); 
    end 
    
    
    
end

