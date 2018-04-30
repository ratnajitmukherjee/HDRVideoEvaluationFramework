function [width, height] = hdrmpeg_Encode_pass1( frame_path, start_frame, frame_step, last_frame, write_path )
%% Backwards Compatible HDR MPEG
% Author: Rafal Mantiuk, 2006, Siggraph 2006
% Re-implementation Ratnajit Mukherjee, University of Warwick, 2014

%% Header information
frames = start_frame:frame_step:last_frame;

%% STEP 1: Generating LDR Stream using KiserTMOv -renamed as ReinhardTMOvid
    % header information for Temporally Coherent Reinhard same as the
    % original implementation
    tmo_alpha_coefficient = 0.98; tmo_clamp = 0; gamma = 2.2;      
    [width, height] = ReinhardTMOvid(frame_path, write_path, tmo_alpha_coefficient, tmo_clamp, gamma, frames);
end 
