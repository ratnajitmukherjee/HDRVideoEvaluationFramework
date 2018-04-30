function optimalEncoderMain(frame_path, start_frame, frame_step, last_frame, write_path, bitdepth)
%% Optimal Compression Method
% Author: Kurt Debattista, University of Warwick, 2014
% Integration into the framework: Ratnajit Mukherjee, 2015

%% Calculate Optimal Exposure for the whole sequence
    frames = start_frame:frame_step:last_frame;
    nFrames = numel(frames);
    optExpArr = oInitAll(nFrames, frame_path);
%% batch process optimal exposure
    for i = 1 : nFrames
        hdr = exrread(fullfile(frame_path, sprintf('%.5d.exr', frames(i))));        
        [opt, lResi, s] = oEncode(hdr, optExpArr, i); 
        LDR_FRAMES(:,:,:,i) = opt;    
        RES_FRAMES(:,:,i) = lResi;
        aux(i) = s;
    end 
%% Writing yuv file

%% this portion is for the HDR-LDR experiment - comment for other works
parfor i = 1: nFrames
    ldr_frame = LDR_FRAMES(:,:,:,i);
    %imwrite(ldr_frame, fullfile(write_path, sprintf('%.5d.jpg', (i-1))), 'quality', 100);
    %fprintf('File %.5d.jpg written', (i-1));    
    
    %% uncomment the previous code and comment the following ones to output gamma corrected JPG files
    ldr_lin = (im2double(ldr_frame)).^2.2;     
    hdrwrite(ldr_lin, fullfile(write_path, sprintf('%.5d.hdr', (i-1))));
end 

%% Status message
fprintf('Compression Completed\n');