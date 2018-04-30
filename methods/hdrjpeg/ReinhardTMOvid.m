function [width, height] = ReinhardTMOvid(frame_path, outputPath, tmo_alpha_coeff, tmo_dn_clamping, tmo_gamma, frames)
%% Author: Francesco Barntele (part of HDR Toolbox)
% Modified for use to output yuv: Ratnajit Mukherjee
% ---- Changes in this version as compared to the orginal implementation by
% Francesco-------------------------
% 1) Replaced the portion where he writes a video using matlab's own
% encoder with a yuv file creation.
%
% 2) He uses his own data structure to create the list of files. Now I use
% matlab's own directory structure and use exrread. 
%
% 3) Added nFrames: number of variables to process. NOTE: The frames has to
% be consequtive for the temporal coherence to work.
%
% -------------- Rest everything is same ----------------

%% Header Information
    if (~exist('outputPath', 'var'))
        error('Please mention output path');
    end 

    if(~exist('tmo_alpha_coeff','var'))
        tmo_alpha_coeff = 0.98;
    end

    if(~exist('tmo_dn_clamping','var'))
        tmo_dn_clamping = 0;
    end

    if(~exist('tmo_gamma','var'))
        tmo_gamma = 2.2;
    end

    if(tmo_gamma<0)
        bsRGB = 1;
    else
        bsRGB = 0;
    end
    
disp('Tone Mapping...');
tmo_alpha_coeff_c = 1.0 - tmo_alpha_coeff;

beta_clamping   = 0.999;
beta_clamping_c = (1.0-beta_clamping);

%% Opening ldr.yuv directory listing and calculating the number of frames    
    ldr_fid = fopen(fullfile(outputPath, 'ldr.yuv'), 'w');
%    hdr_files = dir(fullfile(inputPath, '*.exr')); % directory file listing
    
nFrames = length(frames);
for i=1:nFrames
    %% processing frames (Replaced by Ratnajit Mukherjee)
%    s = hdr_files(i);
    if( exist( 'pfs_read_image', 'file' ) )
        frame = pfs_read_image( sprintf( frame_path, frames(i) ) );
    else
        frame = exrread(fullfile(frame_path, sprintf('%05d.exr', (i-1))));
    end    
    
    %% Only physical values
    frame = RemoveSpecials(frame);
    frame(frame<0) = 0;
    
    if(tmo_dn_clamping)%Clamping black and white levels
        L = RemoveSpecials(lum(frame));
        %computing CDF's histogram 
        [histo,bound,~] = HistogramHDR(L,256,'log10',1);  
        histo_cdf = cumsum(histo);
        histo_cdf = histo_cdf/max(histo_cdf(:));
        [Y,ind] = min(abs(histo_cdf-beta_clamping));
        maxL = 10^(ind*(bound(2)-bound(1))/256 + bound(1));

        [Y,ind] = min(abs(histo_cdf-beta_clamping_c));
        minL = 10^(ind*(bound(2)-bound(1))/256 + bound(1));

        frame(frame>maxL) = maxL;
        frame(frame<minL) = minL;
        frame = frame - minL;
    end
   
    %% computing statistics for the current frame
    L = lum(frame);
    Lav = logMean(L);
    A = max(L(:)) - Lav;
    B = Lav - min(L(:));
   
    if(i==1)
        Aprev = A;
        Bprev = B;
        aprev = 0.18*2^(2*(B-A)/(A+B));
    end
    
    %temporal average
    An = tmo_alpha_coeff_c * Aprev + tmo_alpha_coeff * A;
    Bn = tmo_alpha_coeff_c * Bprev + tmo_alpha_coeff * B;

    a = 0.18*2^(2*(Bn-An)/(An+Bn));
    an = tmo_alpha_coeff_c * aprev + tmo_alpha_coeff * a;
    
    %tone mapping
    [frameOut,~,~] = ReinhardTMO(frame, an);
    
    % Gamma Correction clamping [0, 1] and discretization
    frameOut = im2uint8(ClampImg(lin2srgb(frameOut), 0, 1));

    
    %% Converting sRGB to YCbCr and writing out yuv file (Replaced by Ratnajit Mukherjee)
    ycbcr = uint8(rgb2ycbcr(frameOut));
    ycbcr_p = permute(ycbcr, [2 1 3]);
    fwrite(ldr_fid, ycbcr_p, 'uint8');       
    
    fprintf('\n LDR Frame %d processed.', (i-1));
    %% updating for the next frame
    Aprev = A;
    Bprev = B;
    aprev = a;   
end
%% Replaced closing of Matlab's video stream by .yuv file closing
fclose(ldr_fid); clear ldr_fid;

%% Final Width and Height returned so that the encoder can use this:
    width = size(ycbcr_p, 1); height = size(ycbcr_p, 2); 
end