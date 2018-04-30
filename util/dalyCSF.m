function [ L ] = dalyCSF( Y, mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
            L_HDR = Y;  % true for all modes for 12 bit encoding
            Lout = zeros(size(L_HDR)); 
            switch mode
                case 'forward'                               
                    Lout( L_HDR<0.061843) = 769.18*L_HDR( L_HDR<0.061843);
                    Lout((L_HDR>=0.061843)&(L_HDR<164.10)) = 449.12*(L_HDR((L_HDR>=0.061843)&(L_HDR<164.10)).^0.16999)-232.25;
                    Lout( L_HDR>=164.10) = 181.7*log(L_HDR(L_HDR>=164.10))-90.16; 
                case 'backward'
                    Lout( L_HDR<98.381) = 0.056968*L_HDR(L_HDR<98.381);
                    Lout((L_HDR>=98.381)&(L_HDR<1204.7)) = 7.3014e-30*((L_HDR((L_HDR>=98.381)&(L_HDR<1204.7))+884.17).^9.9872);
                    Lout( L_HDR>=1204.7) = 32.994*exp(L_HDR(L_HDR>=1204.7)*0.0047811);
            end
            L = Lout;

end

