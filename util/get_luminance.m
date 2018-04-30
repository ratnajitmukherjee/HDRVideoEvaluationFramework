function Y = get_luminance( img )
% Return 2D matrix of luminance or luma values for 3D matrix for the RGB
% image (assuming Rec. 709 primaries)
%
% (c) 2012 Rafal Mantiuk

if( size(img,3)== 3 )
    Y = img(:,:,1) * 0.212656 + img(:,:,2) * 0.715158 + img(:,:,3) * 0.072186;
elseif( size(img,3) == 1 )
    Y = img;
else
    error( 'get_luminance: wrong matrix dimension' );
end

end