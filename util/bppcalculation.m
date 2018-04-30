function [ bpp_filesize ] = bppcalculation( video_path, method_type, qplevels, frame_info, ext, method )
%% function to calculate the bpp of files at given QPs
% Input:
%   video_path = path where all video files are stores
%   method_type = single/double based on which ldr and res files calculated
%   qplevels = the quality levels at which the files are encoded
%   frame_info = a structure containing start frame, frame step and last
%   frame, width and height of each frame
%   ext = for 264 / 265 / vp9

%%  processing
    bpp_filesize = zeros([length(qplevels), 1]);
    for i = 1 : length(qplevels)
        qp = qplevels(i);
        if(strcmp(method_type, 'single') == 1)
            f_ldr = dir(fullfile(video_path, sprintf('ldr_qp%d.%s', qp, ext)));
            fsize = f_ldr.bytes; 
            nFrames = length(frame_info.start_frame:frame_info.last_frame);
            bpp = ((fsize/nFrames)/(frame_info.width * frame_info.height)) * 8;    
        elseif(strcmp(method_type, 'double') == 1)
            f_ldr = dir(fullfile(video_path, sprintf('ldr_qp%d.%s', qp, ext)));
            if(strcmp(method, 'rate') == 1) 
                qpr = floor(0.77 * qp + 13.42);
            else 
                qpr = qp;
            end 
            f_res = dir(fullfile(video_path, sprintf('res_qp%d.%s', qpr, ext)));
            fsize = f_ldr.bytes + f_res.bytes; 
            nFrames = length(frame_info.start_frame:frame_info.last_frame);
            bpp = ((fsize/nFrames)/(frame_info.width * frame_info.height)) * 8; 
        end 
        bpp_filesize(i, 1) = bpp;
    end 
end
