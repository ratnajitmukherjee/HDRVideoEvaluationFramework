function [ L ] = pu_encode( Y, mode, bitdepth )
%% function to perceptually encode luminance to luma and reverse
    bits = num2str(bitdepth);
    
    switch bits
        case '12'
            L_HDR = Y;  % true for all modes for 12 bit encoding
            Lout = zeros(size(L_HDR)); 
            switch mode
                case 'forward'                               
                    Lout( L_HDR<5.604) = 17.554*L_HDR(L_HDR<5.604);
                    Lout((L_HDR>=5.604)&(L_HDR<10469)) = 826.8*(L_HDR((L_HDR>=5.604)&(L_HDR<10469)).^0.10013)-884.17;
                    Lout( L_HDR>=10469) = 0.0000002*log(L_HDR(L_HDR>=10469))-731.28; 
                case 'backward'
                    Lout( L_HDR<98.381) = 0.056968*L_HDR(L_HDR<98.381);
                    Lout((L_HDR>=98.381)&(L_HDR<1204.7)) = 7.3014e-30*((L_HDR((L_HDR>=98.381)&(L_HDR<1204.7))+884.17).^9.9872);
                    Lout( L_HDR>=1204.7) = 32.994*exp(L_HDR(L_HDR>=1204.7)*0.0047811);
            end
            L = Lout;
        case '10'
            switch mode
                case 'forward'                    
                    pur = load('purafal.csv');
                    pur_mod = modify_lut(pur);
                    l_lut = log10(pur_mod(:,1));                                
                    P_lut = pur_mod(:,2);   
                    lin = log10(Y);
                    L = interp1(l_lut, P_lut, lin, 'pchip');
                    L = round(L);
                case 'backward'
                    pur = load('purafal.csv');
                    pur_mod = modify_lut(pur);
                    l_lut = log10(pur_mod(:,1));                                
                    P_lut = pur_mod(:,2);
                    luma = Y;
                    logL = interp1(P_lut, l_lut, luma, 'pchip');
                    L = 10.^logL;
            end 
    end
end

function [pur_m] = modify_lut(pur)
    pur_m(:,2) = linspace(0, 1023, 1024)';    
    pur_m(:,1) = pur(:,1);

end 