function p = lin2srgb( L )
% Convert linear RGB to pixel values using sRGB non-linearity
% 
% p = lin2srgb( L )
%
% L - linear RGB (or luminance)
% p - pixel values
%
% (c) 2012 Rafal Mantiuk

p = zeros(size(L));

t = 0.0031308;
a = 0.055;

p(L<=t) = L(L<=t)*12.92;
p(L>t) = ((1+a)*L(L>t)).^(1/2.4) - a;

end