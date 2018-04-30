function dec_hdr = wDecode(tm, lResi, s)
%% function to decode tm and resi files and merge them into hdr
gamma = 2.2;

imgTMO = ((double(tm)/255).^gamma);

imgRI = logDecodeResidual(lResi, s.minVal, s.maxVal); 

%% Decoded image
hdr = zeros(size(imgTMO));
for i=1:3
    hdr(:, :, i) = imgTMO(:, :, i).*imgRI;
end
dec_hdr = RemoveSpecials(hdr);
end 