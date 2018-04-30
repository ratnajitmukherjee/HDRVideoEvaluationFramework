function copyOutputSubjective(inputpath, outputpath, mode)
%% This function copies the output exr files to an output folder
% To be used only in case of subjective experiment material preparation
% NOTE: The experiment files should always be HDRs/ just keeping them exrs
% for now. If experiment files are successful change output extension to
% .hdrs

%% Body of the function 

    % create output dir in case it does not exist
    if(~exist(outputpath, 'dir'))
        mkdir(outputpath);
    end 
    
    % read filename from the input directory
    filelist = dir(fullfile(inputpath, '*exr'));
    
    % check whether files need to converted to directly moved
    if (strcmp(mode, 'convert') == 1)
        parfor i = 1 : numel(filelist)
            filename = filelist(i).name;
            hdr = exrread(fullfile(inputpath, filename));
            hdrimwrite(hdr, fullfile(outputpath, filename));
        end 
    else
        movefile(fullfile(inputpath, '*.exr'), outputpath);
    end
    
    fprintf('\n Experiment files dumped to specified folder\n');
    
end 