function hdrview( hdr )
%% function to view hdr files in matlab natively. 
% This function is specifically created for windows since imshow is
% terrible and compiling pfstools in windows is difficult.

% Author: Ratnajit Mukherjee, University of Warwick, 2015

%% Check whether the hdr file is stored in workspace
    if (isa(hdr, 'char'))
        hdr = parsePathAndLoad(hdr);           
    end 

%% Store current path
    current_path = [pwd '\'];

%% Write the image file to the temporary windows folder
    write_file = 'C:\Windows\Temp\tmp.exr';
    exrwrite(hdr, write_file);
% check which viewer is present in the system
    if (exist('qt4Image.exe', 'file')) 
        cd 'C:\Program Files\Cornell PCG\HDRITools\bin';
        cmdv = ['qt4Image.exe' ' ' write_file ' &'];
        system(cmdv);
        delete(write_file);
    elseif(exist('C:\Program Files (x86)\Luminance HDR\luminance-hdr.exe', 'file'))        
        cd 'C:\Program Files (x86)\Luminance HDR\luminance-hdr.exe';
        cmdv = ['luminance-hdr.exe' ' ' write_file];
        system(cmdv); 
        delete(write_file);
    else 
        warning('Sorry no HDR viewer could be found in your system or added to matlab path. Displaying HDR frame using imshow(). Please install QT4Image or Luminance HDR to the path');
        imshow(hdr);
    end
    % return to current path (from where the program was called)
    cd(fullfile(current_path));
    
end

function hdr = parsePathAndLoad(hdrfilename)
% using ~ symbol for the pathstring and filename as they are not required.
    [~, ~, ext] = fileparts(hdrfilename);
    switch ext
        case '.hdr'
            hdr = hdrread(hdrfilename);
        case '.exr'
            hdr = exrread(hdrfilename);
        case '.pfm'
            hdr = hdrimread(hdrfilename);
    end 
end 

