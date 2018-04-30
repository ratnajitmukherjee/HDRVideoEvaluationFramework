function X = keep(X,Ratio)
% Set all but the largest elements of X to zero

if size(X,3) > 1
   NumElements = numel(X);
   % Number of components to keep in the Y channel
   NumY = floor(NumElements*Ratio*0.92);
   % Number of components to keep in the Cb channel
   NumCb = floor(NumElements*Ratio*0.04);
   % Number of components to keep in the Cr channel
   NumCr = floor(NumElements*Ratio*0.04);

   X(:,:,1) = keep(X(:,:,1),NumY);
   X(:,:,2) = keep(X(:,:,2),NumCb);
   X(:,:,3) = keep(X(:,:,3),NumCr);
   return;
end

if Ratio > 1
   Num = Ratio;
else
   Num = floor(numel(X)*Ratio);
end

[tmp,i] = sort(abs(X(:)));
X(i(1:end-Num)) = 0;
return;