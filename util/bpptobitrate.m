hdrmpeg_fs(:,1) = qp;
for i = 2 : 7
    channel = (i-1);
    if (i == 6)
        pixels = 1920*800;
    else 
        pixels = 1920 * 1080;
    end 
    bpp = eval_matrix(:,1, channel);
    bitrate = round((bpp * pixels * 24)/1024);
    hdrmpeg_fs(:,i) = bitrate;
end

hdrmpeg_psnr(:,1) = qp;
hdrmpeg_logpsnr(:,1) = qp;
hdrmpeg_vdp(:,1) = qp;

for i = 2 : 7
     channel = (i-1);
     hdrmpeg_psnr(:,i) = eval_matrix(:,2,(i-1));
     hdrmpeg_logpsnr(:,i) = eval_matrix(:,3,(i-1));
     hdrmpeg_vdp(:,i) = eval_matrix(:,4,(i-1));
end 