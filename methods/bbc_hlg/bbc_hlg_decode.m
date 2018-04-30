function bbc_hlg_decode(  read_path, width, height, nFrames, dest_path, bitdepth )
%% BBC HLG Encode - Hybrid Log Gamma (BBC) Encode
% Author: Jonathan Hatchett,
% Framework integration by Ratnajit Mukherjee
% University of Warwick, Copyright � 2015, All Rights reserved

%% constants
    r = 0.5;
    a = 0.17883277;
    b = 0.28466892;
    c = 0.55991073;
        
%% decompression code
    ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
    load(fullfile(read_path, 'aux.mat'));

    for i = 1 : nFrames
        yuv_p = fread(ldr_fid, (width * height * 3), 'uint16');
        yuv_p = uint16(reshape(yuv_p, [width  height 3]));
        yuv = permute(yuv_p, [2 1 3]); % transforms frame        
        yuv = double(yuv)./(2^bitdepth);
        rgb = ycbcr2rgb(yuv);
        
        out = zeros(size(rgb));
        
        % BBC code starts
        for j = 1 : size(rgb, 3)
            channel = rgb(:,:,j);
            chnl_out = zeros(size(channel));
            chnl_out(channel<=r) = (channel(channel<=r) ./ r) .^ 2;
            chnl_out(channel>r) = exp((channel(channel>r) - c) ./ a) + b;
            out(:,:,j) = chnl_out;
        end
        
        %if (rgb <= r)
        %    out = (rgb / r) .^ 2;
        %else
        %    out = exp((rgb - c) / a) + b;
        %end    
        hdr_norm = out ./ 12;
        % BBC code ends
        
        hdr = hdr_norm .* aux_data(i);
        exrwrite(hdr, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
        fprintf('\n Frame %d done', (i-1));
    end
    
    fprintf('\n Decoding complete...\n');
end
