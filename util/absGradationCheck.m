function [ gradationArray ] = absGradationCheck( ref_path )
%% function to test the absolute gradation of the footages  
    d = dir(ref_path);
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];
    ga = cell(numel(nameFolds), 5);
    for i = 1 : numel(nameFolds) 
        frame_path = fullfile(ref_path, nameFolds{i});
        files = dir([frame_path, '/*.exr']);         
        for j = 1 : numel(files)
            hdr = RemoveSpecials(exrread(fullfile(frame_path, sprintf('%05d.exr', (j-1)))));
            min_val(j) = min(min(lum(hdr)));
            max_val(j) = max(max(hdr(:)));
            dr(j) = log2(max_val(j)/min_val(j));
        end
    % calculating the mean stats
        minv = mean(min_val);
        maxv = mean(max_val);
        drv = mean(dr);
        
        ga{i, 1} = nameFolds{i}; 
        ga{i, 2} = numel(files);
        ga{i, 3} = minv;
        ga{i, 4} = round(maxv);
        ga{i, 5} = drv;
        fprintf('\n\t Sequence: %s checked.', nameFolds{i});
    end 
    gradationArray = ga;

end