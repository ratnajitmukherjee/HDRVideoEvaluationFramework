function hdr2 = oDecode(opt, lResi, s)

lb = s.lb;
rminVal = s.rminVal;
rmaxVal = s.rmaxVal; 


offset = 0.005;
%offset = 0;
multOff = 1 - offset; 

[~, ldrLum2, chroma2] = getLdrData(opt);

ldrLum2 = ldrLum2 - offset; 

y = ((ldrLum2 * (lb * 256)) + lb) / multOff; 

r = logDecodeResidual(lResi, rminVal, rmaxVal); 

y2 = y + r;

for i = 1:3
   hdr2(:, :, i) = chroma2(:, :, i) .* y2; 
end

end