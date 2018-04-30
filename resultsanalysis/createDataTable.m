function [ ResultsTable ] = createDataTable( tblAttributes, resultsPath, inputArguments)
%% Function to create a data table for objective analysis
%  This table takes in the tableAttributes, resultsPath, input arguments
%  and creates a database which can be used to draw rate distortion graphs
%  and confidence intervals
%   
%   Input: 1) tblAttributes - a cell array which creates the data table
%   where the results will be stored
%                   a) method b) scene c) codec d) subsampling
%                   e) qp f) rate g) psnr h) logpsnr etc.
%
%          2) resultsPath = <path where the mat files are stored'>
%
%          3) inputArguments - a structure with multiple cell arrays
%                   a) methods in an array i.e. methods = {'m1', m2', ...}
%                   b) codecs = {'x264', 'x265', etc}
%                   c) subsampling = {'420', '422', '444'}
%                   d) sequences = {'s01', 's02', ...}
%
%  Author: Ratnajit Mukherjee, University of Warwick 2015
% 

%% First create the blank table based on table attributes
    ResultsTable = cell2table(cell(0, length(tblAttributes)));
    ResultsTable.Properties.VariableNames = tblAttributes;
    
%% Obtain the results from .mat files from the results path based on input arguments
% NOTE: there might a more elegant solution rather than this horrendous
% O(4) loop but will deal with that later.

    %abbreviation
    ia = inputArguments;
    
    for i = 1: length(ia.methods)
        method = ia.methods{i};             % method = compression algo
        for j = 1 : length(ia.codecs)
            codec = ia.codecs{j};           % codec = encoder
            for k = 1 : length(ia.subsampling)
                yuv_fmt = ia.subsampling{k}; % yuv_fmt = subsampling format
                for l = 1 : length(ia.sequences)
                    seq = ia.sequences{l};  % sequences
                    res = load(fullfile(resultsPath, ['eval_' method '_' codec '_' yuv_fmt '_' seq '.mat']));
                    mtx = flipud(res.eval_matrix);  % flipping table up down                    
                    cellArr = tableProcessing(mtx, method, seq, codec, yuv_fmt); % table processing function call
                    Tnew = cell2table(cellArr);     % populate the data table slice 
                    Tnew.Properties.VariableNames = tblAttributes;
                    ResultsTable = [ResultsTable; Tnew];    % Vertical concatenation with existing table
                    fprintf('\n\t Sequence %s done..', seq);
                end
            end
        end 
    end 
end


function [cellArr] = tableProcessing(eval_matrix, method, seq, codec, fmt)
%% function to process evaluation matrix to form a proper cell array    
    % step 1: check whether eval matrix has 9 columns which includes QP if
    % not add to the table
    
    if(size(eval_matrix, 2) == 4)
        mtx = zeros([11, 4]);
        mtx(:,1) = [0:5:50];
        mtx(:,2:end) = eval_matrix(:,2:end);
    elseif(size(eval_matrix, 2) > 4)
        mtx = eval_matrix;
    else
        error('Unknown table format');
    end 
    
    % step 2: processing the results 
    cellArr = cell([size(mtx, 1), (4 + size(mtx, 2))]);
    cellArr(:,1) = cellstr(method);
    cellArr(:,2) = cellstr(seq);
    cellArr(:,3) = cellstr(codec);
    cellArr(:,4) = cellstr(fmt);
    for i = 1 : size(mtx, 2)
        cellArr(:,(i+4)) = num2cell(mtx(:,i));
    end 
end 
