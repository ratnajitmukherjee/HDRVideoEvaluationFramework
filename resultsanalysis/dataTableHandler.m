function dataTableHandler(DataTable, codec, subsampling, qlevels)
%% function to handle the data table and draw performance and CI graphs
% -Input:
%       - DataTable and the InputArguments
%       - InputArguments contain:
%               methods, sequences, codecs, subsampling, qp
% -Output:
%       - Performance vs Bitrate graphs with vertical 95 % Confidence Intervals
%       - QP vs Bitrate graphs with horizontal 95% Confidence Intervals
%
%   Author: Ratnajit Mukherjee, University of Warwick, 2015

%%  Processing the data table specific to a single argument       
    
%     DT = DataTable(~ismember(DataTable.method, { 'icam' }), : );
    DT = DataTable; clear DataTable;
    
    methods = unique(DT.method);
    scenes = unique(DT.scene);
    for i = 1 : length(methods)
        method = methods{i};        
        for j = 1 : length(scenes)
            scene = scenes{j};
            per_scene = zeros([length(qlevels) 6]);
            for k = 1 : length(qlevels)
                qp = qlevels(k);
                ds = DT(strcmp(DT.method, method) == 1 & strcmp(DT.scene, scene) == 1 & strcmp(DT.codec, codec) == 1 & strcmp(DT.subsampling, subsampling) == 1 & DT.qp == qp,:);
                per_scene(k, 1) = mean(ds.qp);
                per_scene(k, 2) = mean(ds.rate);
                per_scene(k, 3) = mean(ds.psnr_rgb);
                per_scene(k, 4) = mean(ds.puPSNR);
                per_scene(k, 5) = mean(ds.puSSIM);                
                per_scene(k, 6) = mean(ds.hdrvdp);               
            end
            per_method(:,:,j) = per_scene;
        end     
        all_res(:,:,:,i) = per_method;
        all_avg_res(:,:,i) = mean(per_method, 3);
    end  
    %% generalizing method mean evaluation
    
    markers = {'-*', '-s', '-o', '-d', '-x', 'k-p', '-+', '-p'};
    
    for i = 1 : length(methods)
        method.name = methods{i};
        method.matrix = all_avg_res(:,:,i);
        
        plot(method.matrix(:,2), method.matrix(:,6), markers{i}, 'LineWidth', 2.5, 'MarkerSize', 15);
        hold on;
    end 
    legend(methods, 'Orientation', 'vertical', 'Location','SouthEast');
    
%     mean_frn = all_avg_res(:,:,1);
%     mean_g8 = all_avg_res(:,:,2);
%     mean_hdrv = all_avg_res(:,:,3);    
%     mean_icam = all_avg_res(:,:,4);    
%     mean_pq = all_avg_res(:,:,5);
%     
%     % drawing the graphs
%     
%     % PSNR graphs
%     plot(mean_hdrv(:,2), mean_hdrv(:,3), '-*', mean_frn(:,2), mean_frn(:,3), '-s', mean_g8(:,2), mean_g8(:,3), '-o', mean_pq(:,2), mean_pq(:,3), '-x', mean_icam(:,2), mean_icam(:,3), 'k-p', 'LineWidth', 3, 'MarkerSize', 15);       
%     legend('hdrv', 'fraunhofer', 'gamma8', 'PQ', 'proposed',  'Location', 'southeast', 'Orientation', 'horizontal');
%     xlabel('Output bits/pixel (bpp)'); ylabel('PSNR - RGB');
%     figure;
%     
% %     % logPSNR - RGB graphs
% %     plot(mean_hdrv(:,2), mean_hdrv(:,4), '-*', mean_frn(:,2), mean_frn(:,4), '-s', mean_g8(:,2), mean_g8(:,4), '-o', mean_pq(:,2), mean_pq(:,4), '-x', mean_icam(:,2), mean_icam(:,4), 'k-p', 'LineWidth', 3, 'MarkerSize', 15); 
% %     legend('hdrv', 'fraunhofer', 'gamma8', 'PQ', 'proposed',  'Location', 'southeast', 'Orientation', 'horizontal');
% %     xlabel('Output bits/pixel (bpp)'); ylabel('logPSNR - RGB');
% %     figure;
%     
%     % pu2_psnr
%     plot(mean_hdrv(:,2), mean_hdrv(:,5), '-*', mean_frn(:,2), mean_frn(:,5), '-s', mean_g8(:,2), mean_g8(:,5), '-o', mean_pq(:,2), mean_pq(:,5), '-x', mean_icam(:,2), mean_icam(:,5), 'k-p', 'LineWidth', 3, 'MarkerSize', 15);
%     legend('hdrv', 'fraunhofer', 'gamma8', 'PQ', 'proposed',  'Location', 'southeast', 'Orientation', 'horizontal');
%     xlabel('Output bits/pixel (bpp)'); ylabel('puPSNR - luma');
%     figure;
%     
% %     % Weber MSE
% %     plot(mean_hdrv(:,2), mean_hdrv(:,6), '-*', mean_frn(:,2), mean_frn(:,6), '-s', mean_g8(:,2), mean_g8(:,6), '-o', mean_pq(:,2), mean_pq(:,6), '-x', mean_icam(:,2), mean_icam(:,6), 'k-p', 'LineWidth', 3, 'MarkerSize', 15); 
% %     legend('hdrv', 'fraunhofer', 'gamma8', 'PQ', 'proposed',  'Location', 'southeast', 'Orientation', 'horizontal');
% %     xlabel('Output bits/pixel (bpp)'); ylabel('Weber MSE - RGB');
% %     figure;
%     
%     % HDR-VDP
%     plot(mean_hdrv(:,2), mean_hdrv(:,7), '-*', mean_frn(:,2), mean_frn(:,7), '-s', mean_g8(:,2), mean_g8(:,7), '-o', mean_pq(:,2), mean_pq(:,7), '-x', mean_icam(:,2), mean_icam(:,7), 'k-p', 'LineWidth', 3, 'MarkerSize', 15);
%     legend('hdrv', 'fraunhofer', 'gamma8', 'PQ', 'proposed',  'Location', 'southeast', 'Orientation', 'horizontal');
%     xlabel('Output bits/pixel (bpp)'); ylabel('HDR-VDP (Q)');
        
end

