%% Script to resize and absolute grade HDR images downloaded from the dataset

parent_folder = 'C:\Users\PC\Downloads\HDRDataset\precalib';
filenames = dir(fullfile(parent_folder, '*.exr'));

% parfor i = 1 : numel(filenames)
%     hdr = exrread(fullfile(filenames(i).folder, filenames(i).name));
%     hdr_res = imresize(hdr, [1080 1920], 'lanczos3');
%     mult_factor = 4000/max(hdr_res(:));
%     hdr_res = hdr_res .*mult_factor;
%     hdr_final = ClampImg(hdr_res, 1e-5, max(hdr_res(:)));
%     exrwrite(hdr_final, fullfile(parent_folder, sprintf('s%02d.exr', (i+9))));
%     fprintf('\n File %02d written to disk', (i+9));
% end 

parfor i = 1 : numel(filenames)
    hdr = exrread(fullfile(filenames(i).folder, filenames(i).name));
    dr(i) = log2(max(hdr(:))/min(hdr(:)));
end