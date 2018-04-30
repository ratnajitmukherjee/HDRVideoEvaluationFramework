function getObjectiveResultsAnalysis( results_path, comp_info)
%% This is a function to plot the evaluation results per sequence & averaged.
%
%   Input Parameters: 
%   results_path - the path where all the results are stored form the
%   evaluation
%   comp info:
%            method name, sequence name, codec name and
%            subsampling format.
% 
%   Output: A bunch of graphs which plots the results per sequence for each
%   of the subsampling formats and also the averaged results for each of
%   quality metrics
%
%   Author: Ratnajit Mukherjee, University of Warwick, 2015

%%  Header information
    methods = comp_info.methods;
    sequences = comp_info.sequences;
    codecs = comp_info.codecs;
    subsampling = comp_info.subsampling;    
    
    %% calling for averaged results graphs
    for i = 1 : length(methods) 
        method = methods{i};
        
        generateAveragedResults(results_path, method, sequences, codecs, subsampling);
    end
end


function generateAveragedResults(results_path, methods, sequences, codecs, subsampling)
%% function to calculate the averaged results
counter = 1;
    for i = 1 : length(methods)
        for j = 1 : length(sequences)
            for k = 1 : length(codecs)
                met = methods{i};
                seq = sequences{j};
                codec = codecs{k};
                file = fullfile(results_path, ['eval_' met '_' codec '_' subsampling '_' seq '.mat']);
                load(file);
                eval_results(:,:,counter) = eval_matrix;
            end 
        end 
    end 
end 

function generateSequenceWiseResults(method, sequence, codec, subsampling)
%% function to calculate sequence wise results
end 
