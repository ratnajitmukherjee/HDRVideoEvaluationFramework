function [ coding_error_matrix ] = controlCodingError(comp_methods, footage, fpath, write_path, frame_info, subsampling, codec)
%% this function evaluates the coding errors of all the compression methods and sequences
% function creates a database table which contains the coding error
% performance which can be used to draw confidence intervals

%%  Table attributes for data table to be created
    tblAttributes = {'method', 'sequence', 'psnr_rgb', 'psnr_y', 'logpsnr_rgb', 'logpsnr_y', 'pupsnr', 'pussim', 'wmse', 'hdrvdp', 'hdrvqm', 'norm_hdrvqm'};    
    RT = createTable(tblAttributes);
    
    for i = 1: length(comp_methods)
        method = comp_methods{i};
        for j = 1 : length(footage)
            sequence = footage{j};
            frame_path = fullfile(fpath, sequence,'/');            
            [frame_info.height, frame_info.width] =  AllCompressionMain(method, frame_path, frame_info, write_path, codec, subsampling);        
            read_path = write_path; dec_write_path = fullfile(write_path, 'dec_frames/');
            AllDecompressionMain(method, read_path, frame_info.width, frame_info.height, codec.nFrames, dec_write_path, codec.bitdepth, 0);
            qm = getObjectiveEvaluation(frame_path, dec_write_path, frame_info.start_frame, frame_info.last_frame);    
            cellArr = populateTable(method, sequence, qm);            
            Tnew = cell2table(cellArr);     % populate the data table slice 
            Tnew.Properties.VariableNames = tblAttributes;
            RT = [RT; Tnew];    % Vertical concatenation with existing table
        end 
    end
    
    coding_error_matrix = RT;    
    
end

function [ResultsTable] = createTable(tblAttributes)
    ResultsTable = cell2table(cell(0, length(tblAttributes)));
    ResultsTable.Properties.VariableNames = tblAttributes;    
end 

function [cellArr] = populateTable(method, sequence, qm)
    mtx = zeros(numel(qm));
    
    fields = fieldnames(qm);
    for i = 1 : numel(fields)
        mtx(i) = qm.(fields{i});
    end 
    
    cellArr = cell([size(mtx, 1), (2 + size(mtx, 2))]);
    cellArr(:,1) = cellstr(method);
    cellArr(:,2) = cellstr(sequence);
    for i = 1 : size(mtx, 2)
        cellArr(:, (i+2)) = num2cell(mtx(:,i));
    end     
end 