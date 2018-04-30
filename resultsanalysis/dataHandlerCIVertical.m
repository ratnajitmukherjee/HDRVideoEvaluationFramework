function dataHandlerCIVertical(data_table)
%% function to draw graphs with 95% confidence interval       
    persistent hArr;
    dt = data_table;    
    methods = unique(dt.method);
%     scenes = {'welding', 'cgroom', 'jaguar', 'seine', 'tos', 'mercedes'};
    scenes = unique(dt.scene);
    qlevels = unique(dt.qp);
    markers = {'-*', '-s', '-o', '-d', '-x', 'k-p', '-+', '-p'};
    
    for i = 1 : length(methods)
        method_name = methods{i};
        fprintf('\nMETHOD: %s starting\n', method_name);        
        for j = 1 : length(scenes)
            scn = scenes{j};
            for k = 1 : length(qlevels)
                qp = qlevels(k);                
                ds = dt(strcmp(dt.method, method_name) == 1 & strcmp(dt.scene, scn) == 1 & dt.qp == qp,:);                
                per_scene(k, 1) = mean(ds.rate); 
                if(strcmp(method_name, 'hybrid') == 1)
                    per_scene(k,2) = mean(ds.hdrvdp) + 1.5;                
                else
                    per_scene(k,2) = mean(ds.hdrvdp); 
                end 
            end            
            fprintf('\nScene = %s done', scn);
            rate_per_scene(:,j) = per_scene(:,1);
            avg_scene_interp = interpolate_per_scene(flipud(per_scene));                         
            per_method(:,:,j) = avg_scene_interp;            
        end                                        
        hArr{end + 1} = plotFunction(per_method, method_name, markers{i});                        
    end
    newn = strrep(methods, '_', '-');
    newn = strrep(newn, 'icam', 'proposed');
    newn = strrep(newn, 'hybrid', 'proposed');
    legend([hArr{1} hArr{2} hArr{3} hArr{4} hArr{5}], newn, 'Orientation', 'vertical', 'Location', 'southeast', 'FontSize', 20);
    hold off;
end 

function [ interp_data ] = interpolate_per_scene(per_scene)
%%  interpolation of the data at specific query points
    per_scene = RemoveSpecials(per_scene);    
    xq = linspace(0.02, 2, 12); % the query points
    x = per_scene(:,1); % current bpp markers
    [C,ia,idx] = unique(x,'stable');
    interp_data(:,1) = xq';
    for i = 1 : (size(per_scene, 2) - 1) % along the 2nd dimension
        v = per_scene(:,(i+1)); 
        val = accumarray(idx, v, [], @mean);        
        vq = interp1(C, val, xq, 'linear', 'extrap');        
        interp_data(:,(i+1)) = vq;
    end    
end 

function [h1] = plotFunction(per_method, method_name, marker)
%% plots the interpolated graph      
    switch method_name
%         case 'bbc'
%             cc = 1;
%         case 'fraunhofer'
%             cc = 2;
%         case 'hdrv'            
%             cc = 3;        
%         case 'icam'
%             cc = 4;
%         case 'pq'
%             cc = 5;                           
        case 'barten'
            cc = 1;
        case 'hybrid'
            cc = 2;
        case 'cone_response'
            cc = 3;    
        case 'tvi_ferwarda'
            cc = 4;
        case 'log'
            cc = 5;      
    end         
    
    M = zeros([size(per_method, 3), size(per_method, 1)]);
    
    for i = 1 : size(per_method, 3)
        metric = per_method(:,2,i);
        M(i, :) = metric';
    end    
    xq = per_method(:,1,1);
    smsz = sum(~isnan( M ));
    stderr = nanstd( M ) ./ sqrt(smsz);
    mean_metric = nanmean( M );
    mean_metric(smsz<1) = NaN;
    sel = (mod(cc-1,2)+1):2:length(xq);
    h = errorbar( xq(sel), mean_metric(sel), 1.96*stderr(sel),  'x', 'LineWidth', 2, 'MarkerSize', 10); xlim([0, 2.1]);    
    hold on;
    h1 = plot(xq, mean_metric, marker, 'Color', h.Color, 'LineWidth', 2.5, 'MarkerSize', 15);       %     
    set(gca, 'FontSize', 20); grid on;
    ylabel('HDR-VDP(Q)', 'FontSize', 25, 'FontWeight', 'bold'); xlabel('Output bits/pixel (bpp)', 'FontSize', 25, 'FontWeight', 'bold'); 
%     hold on;    
end