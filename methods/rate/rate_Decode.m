function rate_Decode(read_path, width, height, nFrames, dest_path, qp)
%% Rate Distortion Decoder function
oldfile = fullfile(read_path, 'res.yuv');
newfile = fullfile(read_path, 'res_400.yuv');
yuv2yuv(oldfile, width, height, '444', newfile, width, height, '400');

ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
res_fid = fopen(fullfile(read_path, 'res_400.yuv'), 'r');
load( fullfile(read_path, sprintf('aux_QP%d.mat', qp)));

for i = 1: nFrames
    ldr_frame = fread(ldr_fid, (width * height * 3), 'uint8');
    ldr_frame = reshape(ldr_frame, [width height 3]);
    tm_frame = ycbcr2rgb(uint8(ldr_frame));    
    tmo = permute(tm_frame, [2 1 3]);
    
    res_frame = fread(res_fid, (width * height), 'uint8');
    res_frame = reshape(res_frame, [width height]);
    res_frame = uint8(permute(res_frame, [2 1])); 
    
    s = aux_data(i);    
    hdr = rDecode(tmo, res_frame, s);    
    if (exist('pfs_write_image', 'file'))    
        pfs_write_image(fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))), hdr, '--fix-halfmax');
    else 
        exrwrite(hdr, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
    end 
end 
fprintf('\n\n Decoding Complete...\n');
end 