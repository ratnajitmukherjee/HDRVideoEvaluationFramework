%% -- Look-up Table for Mapping LDR values to HDR
%
% function lut = ldr2hdrLut(ldr, hdr)
%
% This function takes ldr and hdr image of the same view. It finds mapping
% between ldr and hdr values and stores results into the 1 x 256 look-up
% table. Attention is paid to the fact that some of 256 possible values
% may be missing in the LDR image. LUT is interpolated from neighbours in
% such case.
%
% Input:
%   - ldr:          input ldr image
%   - hdr:          input hdr image of the same view
%
% Output:
%   - lut:          output look-up table relating ldr to hdr values

function lut = ldr2hdrLut(ldr, hdr)

% LUT only for the luma channel
L_min = 1e-5;
l_hdr = max(hdr(:,:,1),L_min);
l_ldr = ldr(:,:,1);

lut = zeros(1, 256);

for v=1:length(lut)
    lut(v) = mean( l_hdr(l_ldr==v) );
    if( isnan(lut(v)) && v>1 )
        lut(v) = lut(v-1);
    end
end

%remove NaN at the head of the LUT
ind = find( isnan(lut), 1, 'last' );
if( ~isempty(ind) )
    lut(1:ind) = L_min;
end
   
% The code below is incorrect
%lut = zeros(3, 256);
%parfor i = 1 : 3       
%    ldrSlice = int32(ldr(:, :, i))+1;   % channel of LDR_LUV
%    hdrSlice = hdr(:, :, i);            % channel of HDR_LUV
%   
%   lutSlice = NaN(1, 256);
%   lutTemp = cell2mat(struct2cell(regionprops(ldrSlice, hdrSlice, 'MeanIntensity')));
%       
%   lutSlice(1, 1:length(lutTemp)) = lutTemp;
%   lutSlice(isnan(lutSlice)) = interp1(find(~isnan(lutSlice)), ...
%       lutSlice(~isnan(lutSlice)), find(isnan(lutSlice)), 'linear');
%   lut(i, :) = lutSlice;
%end 

end