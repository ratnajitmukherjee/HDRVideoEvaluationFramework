function [ vdp_q ] = qm_hdrvdp( org, dec, displaycolour, displayheight )
%% HDR-VDP: Summary of this function goes here
% <summary>
% Input: original frame, decoded frame, display colour space, height of the display
% Output: Calculates Q correlate by calling HDR-VDP
% Note: this code only works for HDR-VDP > 2.2.1 (the Q correlate is absent in the previous versions)
% Author: Ratnajit Mukherjee, University of Warwick, 2015
% </summary>

%     if (~exist(displaycolour, 'var'))
% 		cSpace = 'rgb-bt.709';
%     end       
    cSpace = displaycolour;
    view_dis = (displayheight * 3.2)/100;     
    ppd = hdrvdp_pix_per_deg(47, [size(org,2), size(org, 1)], view_dis);     
    res = hdrvdp(dec, org, cSpace , ppd);
    vdp_q = res.Q;
end
