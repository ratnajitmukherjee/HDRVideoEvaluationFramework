%function hdr = gohdrDecode(tmlum, tmchroma, logAverageLum, maxLum, maxRGB, logbase)

function hdr = gLogDecode(tmchroma, tmlum, s)

gamma = 2.2;

constMult = s.constMult; 

rminVal = s.rminVal;
rmaxVal = s.rmaxVal; 

dtmlum = double(glogDecodeResidual(tmlum, rminVal, rmaxVal)); 
%dtmlum = double(tmlum) ./ 255;
%dtmlum = dtmlum.^gamma;


dtmchroma = double(tmchroma) ./ 255;
dtmchroma = dtmchroma.^gamma;

% this silly number
%chroma = dtmchroma .*8;

% inverse sigmoid for retrieving chroma
chroma = dtmchroma ./ (1 - dtmchroma); 

% re-open lumhdr
% inverse sigmoid
lumhdr = (dtmlum ./ (1 - (dtmlum * constMult)));
%lumhdr = ((1 ./ dtmlum) - 1) ./ constMult; 
%lumhdr = dtmlum; 


% inverse Reinhard
%lumhdr = invReinTMOLum(dtmlum, logAverageLum, maxLum);

for i = 1:3
    hdr(:,:,i) = chroma(:,:,i) .* lumhdr; 
end


%hdr(isnan(hdr)|isinf(hdr))=max(dtmlum(:));
%hdr = RemoveSpecials(hdr);

end