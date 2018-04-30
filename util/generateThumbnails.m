function generateThumbnails( fpath, opath)
%% this function generates thumbnails using a tone-mapping operation and bicubic downsampling

    dir_info = dir(fullfile(fpath));
    list = setdiff({dir_info.name},{'.','..'})';
    
    parfor i = 1 : length(list)
        input_file = fullfile(fpath, list{i}, '00030.exr');
        output_file = fullfile(opath, [list{i} '.png']);
        tmo_command = sprintf('pfsin %s | pfstmo_mantiuk08 -d pd=lcd_bright | pfssize -r 0.25 | pfsout %s', input_file, output_file);
        system(tmo_command);        
        fprintf('Sequence %d done', i);
    end 
end

