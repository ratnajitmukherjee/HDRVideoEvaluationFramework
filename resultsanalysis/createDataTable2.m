function [ datatable ] = createDataTable2( cellArr )
%% this function takes in a cell array and creates a data table

    [length, breadth] = size(cellArr);
    %create a new destination cell array
    destArray = cell([length breadth]);
    % removing the commas (automatically imported from the CSV file)
    for i = 1 : length
        for j = 1: breadth
           cellContent = cellArr{i,j};
           cellContent_mod = strrep(cellContent, ',', ''); 
           if (j==3)
               cellContent_mod = str2double(cellContent_mod);
           end
           destArray{i, j} = cellContent_mod;
        end 
    end
    
    
    datatable = cell2table(destArray, 'VariableNames', {'codec', 'scene', 'quality_lev', 'rate', 'hdrvqm'});
    

end

