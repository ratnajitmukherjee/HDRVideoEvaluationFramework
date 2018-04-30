function bbc_hlg_encode(frame_path, start_frame, frame_step, last_frame, write_path, bitdepth)
%% BBC HLG Encode - Hybrid Log Gamma (BBC) Encode
% Author: Jonathan Hatchett,
% Framework integration by Ratnajit Mukherjee
% University of Warwick, Copyright � 2015, All Rights reserved

%% constants
    r = 0.5;
    a = 0.17883277;
    b = 0.28466892;
    c = 0.55991073;
    
    frames = start_frame:frame_step:last_frame;
    ldr_fid = fopen(fullfile(write_path, 'ldr.yuv'), 'w');

%% Compression Code
    for i = 1: length(frames)
        hdr = exrread(fullfile(frame_path, sprintf('%.5d.exr', frames(i))));
        hdr_norm = hdr./max(hdr(:)); 
        aux_data(i) = max(hdr(:));
        
        % BBC code starts
            hdr_mod = real(hdr_norm .* 12);             
            
            out = zeros(size(hdr_mod));
            
            for j = 1 : size(hdr_mod, 3)
                channel = hdr_mod(:,:,j);
                chnl_out = zeros(size(channel));
                chnl_out(channel<=1) = r * sqrt(channel(channel<=1));
                chnl_out(channel>1) = a * log(channel(channel>1) - b) + c;
                out(:,:,j) = chnl_out;
            end
                            
        % BBC code ends
        yuv = rgb2ycbcr(real(out));
        yuv = uint16(round(yuv.*2^bitdepth));
        yuv_p = permute(yuv, [2 1 3]);
        fwrite(ldr_fid, yuv_p, 'uint16');    
        fprintf('Frame %d done \n', (i-1));
    end 
    save(fullfile(write_path, 'aux.mat'), 'aux_data');
    fclose(ldr_fid); clear ldr_fid;

    fprintf('\n Compression Complete...');
        

end
