function dataHandlerCIHorizontal(data_table)
%% function to draw graphs with 95% confidence interval
persistent hArr;
    dt = data_table;    
    methods = unique(dt.method);
    scenes = unique(dt.scene);
    qlevels = unique(dt.qp);
%     markers = {'-*', '-s', '-o', '-d', '-x', 'k-p', '-+', '-p'};
    markers = {'-*', '-s', '-o', '-d', '-x', 'k-p',  '-+', '-p'};
    
    for i = 1 : length(methods)
        method_name = methods{i};
        fprintf('\nMETHOD: %s starting\n', method_name);
        for j = 1 : length(scenes)
            scn = scenes{j};
            for k = 1 : length(qlevels)
                qp = qlevels(k);
                ds = dt(strcmp(dt.method, method_name) == 1 & strcmp(dt.scene, scn) == 1 & dt.qp == qp,:);                
                per_scene(k, 1) = mean(ds.rate);                  
                per_scene(k, 2) = mean(ds.pussim);                                                                                                                                           
            end            
            fprintf('\nScene = %s done', scn);            
            avg_scene_interp = interpolate_per_scene(flipud(per_scene));             
            per_method(:,:,j) = avg_scene_interp;
        end    
        hArr{end + 1} = plotFunction(per_method, method_name, markers{i});                        
    end
    newn = strrep(methods, '_', '-');
    newn = strrep(newn, 'icam', 'proposed');
    newn = strrep(newn, 'hybrid', 'proposed');        
    flipxyview; grid on;        
    legend([hArr{1} hArr{2} hArr{3} hArr{4} hArr{5} hArr{6} hArr{7} hArr{8}], newn, 'Orientation', 'horizontal', 'Location', 'southeast', 'FontSize', 20);
    ax = gca;
    ax.FontSize = 20;    
    hold off;
end 

function [ interp_data ] = interpolate_per_scene(per_scene)
%%  interpolation of the data at specific query points 
    v_max = max(per_scene(:,2));
    xq = linspace(0.65,1, 12); % the query points
    x = per_scene(:,2); % current bpp markers
    [C,ia,idx] = unique(x,'stable');
    interp_data(:,2) = xq';
    v = per_scene(:,1);
    val = accumarray(idx, v, [], @mean);
    vq = interp1(C, val, xq, 'linear');     
    interp_data(:,1) = vq;          
end 

function [h1] = plotFunction(per_method, method_name, marker)
%% plots the interpolated graph    
    switch method_name
        case 'hdrv'            
            cc = 1;        
        case 'fraunhofer'
            cc = 2;
        case 'pq'
            cc = 3;
        case 'bbc_hlg' 
            cc = 4;
        case 'bbc'
            cc = 5;
        case 'gamma4'
            cc = 6;
        case 'gamma8'
            cc = 7;
        case 'pq_ipt'
            cc = 8;
    end 
    
    % create arrays
    M = zeros([size(per_method, 3), size(per_method, 1)]);
    for i = 1 : size(per_method, 3)
        rate = per_method(:,1,i);
        M(i, :) = rate';
    end    
    xq = per_method(:,2,1);
    smsz = sum(~isnan( M ));
    stderr = nanstd( M ) ./ sqrt(smsz);
    mean_r = nanmean( M );
    mean_r(smsz<1) = NaN;
    sel = (mod(cc-1,2)+1):2:length(xq);
    h = errorbar(xq(sel), mean_r(sel), 1.96*stderr(sel),  'x' , 'LineWidth', 2, 'MarkerSize', 10); %ylim([0, 12]);    
    hold on;
    h1 = plot(xq, mean_r, marker, 'Color', h.Color, 'LineWidth', 3, 'MarkerSize', 18);    
    xlabel('puSSIM','FontSize', 25, 'FontWeight', 'bold'); ylabel('Output bits/pixel (bpp) - log scale', 'FontSize', 25, 'FontWeight', 'bold');    
%     hold on;    
end