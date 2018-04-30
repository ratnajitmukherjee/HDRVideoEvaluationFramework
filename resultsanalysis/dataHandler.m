function dataHandler(data_table)
%% function to draw graphs with 95% confidence interval
    dt = data_table;
    dt = dt(~ismember(dt.method, {'bbc_hlg', 'hdrv-org', 'gamma2', 'gamma4', 'gamma6', 'gamma8'}), :);
    methods = unique(dt.method);   
    scenes= unique(dt.scene);
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
                if (strcmp(method_name, 'icam') == 1)
                    per_scene(k,2) = mean(ds.webermse);
                else
                    per_scene(k,2) = mean(ds.webermse);
                end 
            end                        
            fprintf('\nScene = %s done', scn);                         
            per_method(:,:,j) = per_scene;
        end 
        mean_method = mean(per_method, 3);
        plotFunction(mean_method, markers{i});                        
    end
    newn = strrep(methods, '_', '-');
    newn = strrep(newn, 'icam', 'proposed');
    newn = strrep(newn, 'hybrid', 'proposed');
    legend(newn, 'Orientation', 'horizontal', 'Location', 'southeast', 'FontSize', 20);    
    hold off;
end 

function plotFunction(mean_method, marker)
%% plots the interpolated graph                
    loglog(mean_method(:,1), mean_method(:,2), marker, 'LineWidth', 2.5, 'MarkerSize', 15);    
    xlabel('Output bits/pixel (bpp) - log scale', 'FontSize', 25, 'FontWeight', 'bold'); ylabel('logPSNR-RGB [dB]', 'FontSize', 25, 'FontWeight', 'bold');         
    set(gca, 'FontSize', 20); grid on;
    hold on;
end