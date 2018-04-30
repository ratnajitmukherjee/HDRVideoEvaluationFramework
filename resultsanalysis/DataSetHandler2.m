%% Script to Handle all the data set required for the paper

clear; clc;

load('RT20.mat');
methods = unique(RT.method);
scenes = unique(RT.scene);
codec = 'x265'; subsampling = '420';

qlevels = unique(RT.qp);

for i = 1 : length(scenes)
    scn = scenes{i};
    figure; 
    for j = 1 : length(methods)        
        method_name = methods{j};
        for k = 1 : length(qlevels)
            quality = qlevels(k);
            ds = RT(strcmp(RT.method, method_name) == 1 & strcmp(RT.scene, scn) == 1 & (RT.qp == quality),:);                
            per_scene(k, 1) = ds.rate;
            per_scene(k, 2) = ds.psnr_rgb;
            per_scene(k, 3) = ds.puPSNR;
            per_scene(k, 4) = ds.puSSIM;
            per_scene(k, 5) = ds.hdrvdp;
        end        
        plot(per_scene(:,1), per_scene(:,5), 'LineWidth', 3, 'MarkerSize', 10); hold on;         
        xlabel('Output bits/pixel (bpp)'); ylabel('HDR-VDP(Q)');
        title(scn);
    end
    legend(methods, 'Location', 'SouthEast', 'Orientation', 'horizontal');  
end     