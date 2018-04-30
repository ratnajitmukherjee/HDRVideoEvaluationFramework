function hdrSequenceRename( inputfolder, outputfolder )
%% this is the definitive version of file sequence rename

    fileList = getAllFiles(inputfolder);    
    parfor i = 1 : length(fileList)
      hdr = exrread(fullfile(inputfolder, fileList{i}));
      exrwrite(hdr, fullfile(outputfolder, sprintf('ungraded_%05d.exr', (i-1))));
    end 

end

function fileList = getAllFiles(dirName)
  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files  
end 

