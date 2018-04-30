function dataHandlerCodingError( codingErrorTable )
%% This script handles and draws the coding error bars.

    dt = codingErrorTable;
    methods = unique(dt.method);     
    for i = 1 : numel(methods)        
        method = methods{i};
        if(strcmp(method, 'bbc_hlg')==1)
            labels{i} = 'bbc-hlg';
        elseif(strcmp(method, 'icam')==1)
            labels{i} = 'proposed';
        else 
            labels{i} = method;
        end 
        % extracting resutls
        ds = dt(strcmp(dt.method, method) == 1,:);
        
        % creating data sets
        psnr = ds.psnr_rgb; psnr_y = ds.psnr_y;
        pupsnr = ds.pupsnr; pussim = ds.pussim;
        vdp = ds.hdrvdp; vqm = ds.hdrvqm;
        
        % creating mean data
        psnr_mean(i) = mean(psnr);
        psnr_y_mean(i) = mean(psnr_y);        
        pupsnr_mean(i) = mean(pupsnr);
        pussim_mean(i) = mean(pussim);       
        vdp_mean(i) = mean(vdp);  
        vqm_mean(i) = mean(vqm);
        
        % creating standard errors
        stderr_psnr(i) = (std(psnr)/sqrt(length(psnr)));
        stderr_psnr_y(i) = (std(psnr_y)/sqrt(length(psnr_y)));
        stderr_pupsnr(i) = (std(pupsnr)/sqrt(length(pupsnr)));
        stderr_pussim(i) = (std(pussim)/sqrt(length(pussim)));      
        stderr_vdp(i) = (std(vdp)/sqrt(length(vdp)));   
        sterr_vqm(i) = (std(vqm)/sqrt(length(vqm)));
    end           
    x = 1:numel(methods);
    %% Results display
    
    % PSNR results
    bar(psnr_mean, 0.4); hold on; errorbar(x, psnr_mean, 1.96*stderr_psnr, 'x'); hold off;
    set(gca, 'XTickLabels', labels, 'FontSize', 20); ylabel('PSNR-RGB [dB]'); grid on;
    figure;
    
    % logPSNR results
    bar(psnr_y_mean, 0.4); hold on; errorbar(x, psnr_y_mean, 1.96*stderr_psnr_y, 'x'); hold off;
    set(gca, 'XTickLabels', labels, 'FontSize', 20); ylabel('PSNR-Y [dB]'); grid on;
    figure;
    
    % puPSNR results
    bar(pupsnr_mean, 0.4); hold on; errorbar(x, pupsnr_mean, 1.96*stderr_pupsnr, 'x'); hold off;    
    set(gca, 'XTickLabels', labels, 'FontSize', 20); ylabel('puPSNR [dB]'); 
    figure;
    
    % puSSIM results
     bar(pussim_mean, 0.4); hold on; errorbar(x, pussim_mean, 1.96*stderr_pussim, 'x'); hold off;    
    set(gca, 'XTickLabels', labels, 'FontSize', 20); ylabel('puSSIM');
    figure;
        
    % HDR-VDP results
    bar(vdp_mean, 0.4); hold on; errorbar(x, vdp_mean, 1.96*stderr_vdp, 'x'); hold off;    
    set(gca, 'XTickLabels', labels, 'FontSize', 20); ylabel('HDR-VDP (Q)');     
    
    % HDR-VQM results
    bar(vqm_mean, 0.4); hold on; errorbar(x, vqm_mean, 1.96*stderr_vqm, 'x'); hold off;    
    set(gca, 'XTickLabels', labels, 'FontSize', 20); ylabel('HDR-VQM');     
    %% status message
    clc;
    fprintf('\n\n Mean Data created');    
end
