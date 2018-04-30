function [ HDR_FRAMES ] = ReadDirectory(read_path, hdrFiles, number_of_frames)
%<summary>
% Read all the HDR files in a directory and store in a 4 dimensional Matrix
%   To make the method more computationally efficient, it is better to read
%   all the frames from the given directory into a single 4 dimensional
%   matrix. This also helps to keep the workflow integrated since the
%   stored HDR_FRAMES (4D array) can be passed from function to function
%   without reading the frames repetitively. Other Matrix or temporal
%   operations can also be further added as the 4D Array is by default
%   sorted due to its construction.

% PARAMETERS FOR CONSTRUCTION OF THIS FUNCTION: 

% Input Parameters: 
%   1) Read Path
%   2) The structure for HDR Files
%   3) Number of Frames

% Output Parameters
%   1) 4-D array of HDR Frames
%   2) Bool variable to validate the results of the read operation
%</summary>

    % Read 1st Frame and estimate the Width and Height of each frame
        firstFileName = strcat(read_path, hdrFiles(1).name);
        firstFrame = hdrread(firstFileName);
        [frameHeight, frameWidth, frameChannels] = size(firstFrame);
    
    % Allocate a 4 Dimensional Matrix with Parameters:
    % [Height X Width X Channels X Number_of_Frames] = f(x,y,c,t)
    
        HDR_FRAMES = zeros([frameHeight frameWidth frameChannels number_of_frames]);
    
    % Read the frames from the files and store them in the array.
        
        parfor i=1:number_of_frames
            name = sprintf('%.5d',(i-1));
            currentFilename = strcat(read_path, name, '.hdr');
             hdrfile = RemoveSpecials(hdrread(currentFilename));
             HDR_FRAMES(:,:,:,i) = hdrfile;
            
        end 
        
        fprintf('\n STAGE 1: Reading file directory complete... \n');
end

