function [ lbF ] = filterStream( lb )
%FILTERSTREAM Summary of this function goes here
%   Detailed explanation goes here

lbF = lb; 

nFrames = size(lb,1); 

% use average
%lbF = zeros(size(lb)); 
%lbF(:) = mean(lb(:)); 

% % currently use Gaussian 
% % although for 2D filter2 seems to work fine
filtsize = 11;
halffilt = uint32(filtsize/2);
% pad array for smoother filtering at edges
plb = padarray(lb, [double(halffilt) 0], 'replicate', 'both');
g = fspecial('average', [filtsize 1]);
plbF = filter2(g, plb);
lbF = plbF(halffilt:nFrames+halffilt-1); 

end

