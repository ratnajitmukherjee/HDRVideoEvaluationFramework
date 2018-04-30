function [bounce_timings] = bouncePlots( filepath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        
    %% opening and reading a text file
    fid = fopen(fullfile(filepath), 'r');
    i = 1; j = 1; num_block = 1; 
    while ~feof(fid)
        textline = fgets(fid);
        words = strsplit(textline);
        if (numel(words) > 2)            
            x = str2num(words{3});
            y = str2num(words{1});
            block(i, 1) = x; 
            block(i,2) = y;
            i = i + 1;        
        else
            bounce_timings(:,:,j) = block;
            j = j + 1;
            clear block; i = 1;
        end         
    end
    fclose(fid);
    clearvars -except bounce_timings;
    
   
    for i = 1 : size(bounce_timings, 3)
        block = bounce_timings(:,:,i);
        block_names{i} = sprintf('block-%d', i);
        x = block(:,1);
        y = block(:,2);
        plot(x, y, '-*');
        hold on;
    end 
    xlabel('Number of Bounces'); ylabel('Total Time'); grid on;
    legend(block_names, 'Orientation', 'horizontal', 'Location', 'SouthEast');
    fprintf('\n Plot Creation complete...');
    
end

