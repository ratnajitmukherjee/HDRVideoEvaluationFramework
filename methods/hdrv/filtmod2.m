%
function dBVM12 = filtmod2() 

% visible contrast energy with masking by a homogeneous background

% Observer contrast sensitivity
% Here we set the observer's best possible contrast energy sensitivity to 0 dBB.
% This is unusually good, but not exceeding rare, sensitivity (Watson, 2000 Optics Express).
% For a duration of 0.25 sec and an area of 1 deg^2, it corresponds to a contrast sensitivity
% of 500 (a contrast threshold of 0.002).
% Relative to this standard, the ModelFest observers had approximately
%  a mean sensitivity of -6 dB with a standard deviation of 3 dB.
   dBObs = 0 ;
% images are assumed to be space-time separable with an equivalent energy duration of
   duration = 0.25 ;

% Outline
% 1) Example input images
% 2) Example parameters
% 3) Example computation of visible masked contrast energy

% 1) Example images
% Example: grating increment detection
% Background or pedestal (image1) with a contrast of 0.1,
% backgound + increment (image2) with a contrast of 0.2,
% 16 pixels in each dimension and a
% grating frequency of 3 cycles per image.
% Background level (irrelevant) set to 128
% image size

  rows = 16; cols = 16;

   image1 = ones(1,rows)'*(128*(1.0 + 0.1*sin(2*pi*3*[1:cols]/cols))) ;
   image2 = ones(1,rows)'*(128*(1.0 + 0.2*sin(2*pi*3*[1:cols]/cols))) ;

%show images (all 11 lines may be commented out)
figure(1)
subplot(1,2,1)
image(uint8(image1)) ;
axis image ;
title('image1','FontSize',14);
subplot(1,2,2)
image(uint8(image2)) ;
axis image ;
title('image2','FontSize',14);
gamma = 2;% viewing parameter only
colormap(gray(256).^(1/gamma)) ;

% 2) Example  parameters
% Viewing parameters:
% a) image resolution in pixels per degree

  rowpixperdeg = 30 ; colpixperdeg = 30 ;

%  Image width or length is 16/30. =  0.5333 deg
%  Grating frequency is 5.625  cycles per deg
%  ((3 cycles per image/16 pixels per image)) * 30 pixels per deg )

% The pixel area in degrees squared is

  pixelArea = 1/(rowpixperdeg*colpixperdeg) ;

% b) contrast sensitivity filter
% contrast sensitivity function with unity peak gain
%  The Difference of Gaussians filter with unity peak gain has
%    three parameters:
%  i) the frequency cutoff in cycles per degree

  freqcutcpd = 15.4 ;

%  ii) the ratio of surround spread to center spread

  spreadratio = 15.4/1.35 ;

%  iii) the ratio of surround DC amplitude to center DC amplitude

  ampratio = 0.76 ;

%   The above parameter values are a DOG fit to Barten's contrast sensitivity
%    function for a luminance of 50 cd/m^2

%  Using the image size and resolution parameters,
%  the frequency cut in cycles per degree is converted to
%  row and column frequency cut offs in cycles per image.

  rowfreqcut = rows * freqcutcpd / rowpixperdeg ;
  colfreqcut = cols * freqcutcpd / colpixperdeg ;

%  The unscaled contrast sensitivity filter  is
 
  csf = filtdog(rows, cols, rowfreqcut, colfreqcut, ampratio, spreadratio) ;

%  The unity peak gain contrast sensitivity filter is
 
   csf = csf/max(max(csf)) ;

% show csf (all 13 lines may be commented out)
figure(2)
subplot(1,2,1)
csffreq = sqrt(ones(rows/2,1)*([0:cols/2-1]*(colpixperdeg/cols)).^2 ...
            + (ones(cols/2,1)*([0:rows/2-1]*(rowpixperdeg/rows)).^2)') ;
plot(csffreq,csf(1:rows/2,1:cols/2),'k.','MarkerSize',24,'LineWidth',2) ;
xlabel('spatial frequency, cycles/degree','FontSize',14) ;
title('csf','FontSize',16);
ylabel('contrast gain','FontSize',14) ;
subplot(1,2,2)
plot(csffreq,20*log10(csf(1:rows/2,1:cols/2)),'k.','MarkerSize',24,'LineWidth',2) ;
xlabel('spatial frequency, cycles/degree','FontSize',14) ;
title('csf','FontSize',16);
ylabel('contrast gain, dB','FontSize',14) ;

% c) contrast masking threshold

      maskconthresh=0.05 ; % 5% rms contrast raises threshold by 3 dB
 
%  3) Example computation of visible masked contrast energy

% convert images to contrast images
  meanlum = mean(image1(:)) ;
   con1 = image1/meanlum - 1 ;
   con2 = image2/meanlum - 1 ;

%         contrast energy in difference signal is 25.5091 dB
dBB12  =          dBB(con1-con2,pixelArea,duration)
% visible contrast energy in difference signal is 24.7525 dB
dBV12  = dBObs +  dBV(con1-con2,pixelArea,duration,csf)
% contrast energy in difference signal masked by background is 20.4708 dB
dBVM12 = dBObs + dBVM(con1,con2,pixelArea,duration,csf,maskconthresh)

% Example dprime value d = 10^(dBVM12/20) ;10.5570 ;

% Example conversion from d' to threshold increment.
% image1 had a contrast of 0.1, image2 had a contrast of 0.2,
%  so the model predicts the contrast difference threshold
%  for a base contrast of 0.1 is
%  (0.2 - 0.1)/ d = 0.0095 ;

%  dBVM, the masked visible contrast energy subroutine
 
function dB = dBVM(conImage1,conImage2,pixelArea,duration,csf,maskConThresh)
         dB =  dBV(conImage1-conImage2,pixelArea,duration,csf)...
          - dBVMask(conImage1,                             csf,maskConThresh);

%-----end  of dBVM--------------

%  dBV, the visible contrast energy subroutine
 
function dB = dBV(conImage,pixelArea,duration,csf)
n = prod(size(conImage));
fcon = abs(fft2(conImage).*csf) ;
dB = 60 + 10*log10(pixelArea*duration*sum(fcon(:).^2)/n) ;

%-----end  of dBV--------------

%  dBVMask, the masking factor subroutine
 
function dB = dBVMask(conImage,csf,maskConThresh)
n = prod(size(conImage));
fcon = abs(fft2(conImage).*csf) ;
dB = 10*log10(1+mean(fcon(:).^2)/(n*maskConThresh*maskConThresh));

%-----end  of dBVMask--------------

%  dBB, the visible contrast energy subroutine
 
function dB = dBB(conImage,pixelArea,duration)
dB = 60 + 10*log10(pixelArea*duration*sum(conImage(:).^2)) ;

%-----end  of dBB--------------

%    filtdog makes a Difference of Gaussians filter
%     r,c: # of rows and columns
%     rf,cf: row and column high frequency cutoffs
%     sr (spread ratio):  wide spatial spread / narrow one
%     ar (amplitude ratio): surround DC level / center DC level

 function result =  filtdog(r, c, rf, cf, ar, sr)
  result=filtgaus(r,c,rf,cf)-ar*filtgaus(r,c,rf/sr,cf/sr) ;

%---------end filtdog-------------------------

%   2D Gaussian filter (outer product of two 1D Gaussians) 

 function  result = filtgaus(r, c, rf, cf)
   result=fltgaus1(r,rf)'*fltgaus1(c,cf);

%---------end filtgaus-------------------------

%   fltgaus1 generates a 1D Gaussian low pass filter
%   n: spatial image length (must be even)
%   f: 1/e frequency cutoff in cycles per image

  function result = fltgaus1( n, f)
  result = [[0:n/2] [1:n/2-1]-n/2];
  result = exp(-(result.*result)/(f*f))  ;

 %   For a sequence of length N (N even) Matlab orders
 %     the Discrete Fourier Transform coefficients
 %     by their frequencies in cycles per image
 %     [0 (DC) 1 2 3 ... N/2 -N/2+1 ...  -2  -1]
%---------end fltgaus1-------------------------

% 
% 