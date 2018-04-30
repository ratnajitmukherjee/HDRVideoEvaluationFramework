function  [width, height] = hdrjpeg_Encode_pass1( frame_path, start_frame, frame_step, last_frame, write_path )
%% HDRJPEG PASS 1:
%  This function calls Reinhard TMOVid
    frames = start_frame:frame_step:last_frame;

%% STEP 1: Generating LDR Stream using KiserTMOv -renamed as ReinhardTMOvid
    % header information for Temporally Coherent Reinhard same as the
    % original implementation
    tmo_alpha_coefficient = 0.98; tmo_clamp = 0; gamma = 2.2;      
    [width, height] = ReinhardTMOvid(frame_path, write_path, tmo_alpha_coefficient, tmo_clamp, gamma, frames);


end

