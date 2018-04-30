function [ qm ] = getObjectiveEvaluation( org_path, dec_path, start_frame, last_frame )
%% Comprehensive evaluation function
nFrames = length(start_frame:last_frame);
psnr_rgb = 0; psnr_y = 0; logpsnr_rgb = 0; logpsnr_y = 0; pupsnr_y = 0; pussim_y = 0;
weber_mse =0; vdp_Q =0; count = 0;

parfor i = 1: nFrames
    % read frames
    org = RemoveSpecials(double(exrread(fullfile(org_path, sprintf('%05d.exr', (i-1))))));
    dec = RemoveSpecials(double(exrread(fullfile(dec_path, sprintf('frame_%05d.exr', (i-1))))));
    
    % calculate results
    psnr_rgb = psnr_rgb + qm_psnr(org, dec, 'rgb');
    psnr_y = psnr_y + RemoveSpecials(qm_psnr(org, dec, 'lum'));
    logpsnr_rgb = logpsnr_rgb + RemoveSpecials(qm_log_psnr_rgb(org, dec));
    logpsnr_y = logpsnr_y + RemoveSpecials(qm_log_psnr_y(org, dec));
    pupsnr_y = pupsnr_y + qm_pu2_psnr(org, dec);
    pussim_y = pussim_y + qm_pu2_ssim(org, dec);
    weber_mse = weber_mse + qm_weber_rmse(org, dec);
    if (i == 1 || mod(i,30) == 0)
        vdp_Q = vdp_Q + RemoveSpecials(qm_hdrvdp(org, dec, 'rgb-bt.709', 59));
        count = count + 1;
    end 
end
%% special command for HDRVQM 
% needs creation of directories
%     org_emitted_path = org_path;
%     dec_emitted_path = dec_path;
    org_emitted_path = fullfile(dec_path, 'src_emitted/');
    dec_emitted_path = fullfile(dec_path, 'hrc_emitted/');
    
    if(~exist(org_emitted_path, 'dir'))
        mkdir(org_emitted_path);
    end
    
    if(~exist(dec_emitted_path, 'dir'))
        mkdir(dec_emitted_path);
    end     
    
    [hdrvqm, n_hdrvqm] = hdr_vqm(org_path, dec_path, org_emitted_path, dec_emitted_path);
    delete(fullfile(org_emitted_path, '*.exr'));
    delete(fullfile(dec_emitted_path, '*.exr'));
% ------------------End of HDRVQM--------------------------%

    % calculate avg results
    qm.psnr_rgb = psnr_rgb ./ nFrames;
    qm.psnr_y = psnr_y ./ nFrames;
    qm.logpsnr_rgb = logpsnr_rgb ./ nFrames;
    qm.logpsnr_y = logpsnr_y ./ nFrames;
    qm.pupsnr_y = pupsnr_y ./ nFrames;
    qm.pussim_y = pussim_y ./ nFrames;
    qm.weber_mse = weber_mse ./ nFrames;
    qm.vdp_Q = vdp_Q./count;
    qm.hdrvqm = hdrvqm;
    qm.hdrvqm_norm = n_hdrvqm;    
end 