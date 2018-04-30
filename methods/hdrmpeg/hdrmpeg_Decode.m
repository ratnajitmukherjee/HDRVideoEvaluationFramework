function hdrmpeg_Decode( read_path, width, height, nFrames, dest_path, qp )

%% HDR - MPEG decoder script

ldr_fid = fopen(fullfile(read_path, 'ldr.yuv'), 'r');
res_fid = fopen(fullfile(read_path, 'res.yuv'), 'r');
load( fullfile(read_path, sprintf('aux_QP%d.mat', qp)));
            
inv_mtx =[3.2406,-1.5372,-0.4986;...
         -0.9689,1.8757,0.0415;...
          0.0557,-0.2040,1.0569];
      
for i = 1:nFrames
    
% STEP 1: Conversion of YCbCr to LUV_LDR    
    ldr_frame = fread(ldr_fid, (width * height * 3), 'uint8');
    ldr_frame = uint8(reshape(ldr_frame, [width height 3]));
    
    res_frame = fread(res_fid, (width * height * 3), 'uint8');
    res_frame = reshape(res_frame, [width height 3]);
    RES_HDR = uint8(permute(res_frame, [2 1 3]));
    
    YCbCr = permute(ldr_frame, [2 1 3]);    
    sRGB = ycbcr2rgb(YCbCr);
    LDR_LUV = ColourLDR(sRGB);    
    
% ---------------------Expansion Operation for pHDR values----------------
    RF = aux_stream(1,:,i);    
    pHDR = lutEo(LDR_LUV, RF);
% ----------------------Manipulating the Residual Frame ----------------       
    RES_HDR = double(RES_HDR) - 127;
    imgRes = RES_HDR;
    
    q_frame = qfactor_stream(:,:,i);
    % De-quantization
    imgRes(:,:,1) = changem( LDR_LUV(:,:,1), q_frame(:,1), 0:255 ).*RES_HDR(:,:,1);
    
    HDR_LUV = pHDR + imgRes;
    L_HDR = HDR_LUV(:,:,1); 
    Lout = zeros(size(L_HDR));
% ---------Inverse Conversion of 12 bit Luma to Luminance-----------------%     
    Lout( L_HDR<98.381) = 0.056968*L_HDR(L_HDR<98.381);
    Lout((L_HDR>=98.381)&(L_HDR<1204.7)) = 7.3014e-30*((L_HDR((L_HDR>=98.381)&(L_HDR<1204.7))+884.17).^9.9872);
    Lout( L_HDR>=1204.7) = 32.994*exp(L_HDR(L_HDR>=1204.7)*0.0047811);
    
% -------------Inverse Conversion from LUV to XYZ to RGB-----------------%

   u_hdr = (HDR_LUV(:,:,2) + 0.05)./410;
   v_hdr = (HDR_LUV(:,:,3) + 0.05)./410;
   X_HDR = 9*u_hdr./ (6*u_hdr - 16*v_hdr + 12);
   Y_HDR = 4*v_hdr./ (6*u_hdr - 16*v_hdr + 12);
   Z_HDR = 1 - X_HDR - Y_HDR;
   
   normalization = Lout./Y_HDR;
   %normalization = RemoveSpecials(Lout./Y_HDR);
   XYZ_HDR = zeros(size(pHDR));
   
   XYZ_HDR(:,:,1) = X_HDR .* normalization;
   XYZ_HDR(:,:,2) = Lout;
   XYZ_HDR(:,:,3) = Z_HDR .* normalization;
   
   DEC_HDR = zeros(size(XYZ_HDR));
   
   for j = 1:3
        DEC_HDR(:,:,j) = XYZ_HDR(:,:,1) * inv_mtx(j,1) ...
                       + XYZ_HDR(:,:,2) * inv_mtx(j,2) ...
                       + XYZ_HDR(:,:,3) * inv_mtx(j,3);
   end     
         
   if( exist( 'pfs_write_image', 'file' ) )
        pfs_write_image( fullfile(dest_path, sprintf('frame_%05d.exr', (i-1)) ), DEC_HDR , '--fix-halfmax' );
   else
        exrwrite(DEC_HDR, fullfile(dest_path, sprintf('frame_%05d.exr', (i-1))));
   end    

end  
fclose(ldr_fid); fclose(res_fid);

end