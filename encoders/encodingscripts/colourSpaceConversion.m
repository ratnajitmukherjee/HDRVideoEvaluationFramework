function colourSpaceConversion(inputPath, width, height, fps, subsampling)
    subsampling = num2str(subsampling);
    color_cmd = sprintf('ffmpeg-10bit -y -pix_fmt yuv444p10le -s %dx%d -r %d -i %sldr.yuv -f rawvideo -pix_fmt yuv%sp10le -s %dx%d -r %d %sldr_%s.yuv', width, height, fps, inputPath, subsampling, width, height, fps, inputPath, subsampling);
    system(color_cmd);
    delete(fullfile(inputPath, 'ldr.yuv'));
    movefile(fullfile(inputPath, sprintf('ldr_%s.yuv', subsampling)), fullfile(inputPath, 'ldr.yuv'));
end 