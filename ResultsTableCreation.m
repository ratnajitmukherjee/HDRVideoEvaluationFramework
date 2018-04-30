%% This is a script to call the CreateDataTable function in the results analysis section

clear all;
tblAttributes = {'method', 'scene', 'codec', 'subsampling', 'qp', 'rate', 'hdrvqm', 'norm_hdrvqm'};
% resultsPath = '/home/visualisation/Desktop/10bitEval/results/';
resultsPath = '/mnt/scratch/vqm_results/';
ia.methods = {'bbc_hlg', 'icam', 'pq', 'fraunhofer', 'hdrv'};
ia.codecs = {'x265'};
ia.subsampling = {'420'};

fpath = '/home/visualisation/Dropbox/sequences/';
root_folder = dir(fpath);
isub = [root_folder(:).isdir]; %# returns logical vector
nameFolds = {root_folder(isub).name};
nameFolds(ismember(nameFolds,{'.','..', 's07', 's09', 's11', 'yuvs-30frames'})) = [];
ia.sequences = nameFolds;

clearvars -except tblAttributes resultsPath ia

RT = createDataTable(tblAttributes, resultsPath, ia);

