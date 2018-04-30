function colourSpaceConversion8bit(inputPath, width, height, fps, subsampling)
%% conversion from 444p to 420p for 8 bit files
    subsampling = num2str(subsampling);
    color_cmd = sprintf('ffmpeg-10bit -y -pix_fmt yuv444p -s %dx%d -r %d -i %sldr.yuv -f rawvideo -pix_fmt yuv%sp -s %dx%d -r %d %sldr_temp.yuv', width, height, fps, inputPath, subsampling, width, height, fps, inputPath);
    system(color_cmd);       
end 