function [ luma ] = luminance2luma( Y, minluma, maxluma, bits, encoding_mode, encoding_type )   
    
    switch encoding_type
        %% 12 bit log encoding luminance
        case 'log' 
            % calculation of constants 'a' and 'b'
            Ymin = minluma;
            Ymax = maxluma;            
            a = (2.^bits -1)/ (log2(Ymax/Ymin));
            b = -((2.^bits -1)/ log2(Ymax/Ymin)) * log2(Ymin);            
            % calculation of 16 bit luminance to 11 bit luma
            if (strcmp(encoding_mode, 'forward') == true)
                luma = a*log2(Y) + b + 0.5;
                % calculation of 11 bit luma space to 16 bit luminance
            elseif(strcmp(encoding_mode, 'backward') == true)
                luma = 2.^((Y-b)/a);
            end
        %% 12 bit perceptual luminance encoding
        case 'perceptual' 
        L_HDR = Y; Lout = zeros(size(L_HDR));
        if (strcmp(encoding_mode, 'forward') == true)            
            Lout( L_HDR<5.604) = 17.554*L_HDR(L_HDR<5.604);
            Lout((L_HDR>=5.604)&(L_HDR<10469)) = 826.8*(L_HDR((L_HDR>=5.604)&(L_HDR<10469)).^0.10013)-884.17;
            Lout( L_HDR>=10469) = 209.16*log(L_HDR(L_HDR>=10469))-731.28;                    
        elseif(strcmp(encoding_mode, 'backward') == true)
            Lout( L_HDR<98.381) = 0.056968*L_HDR(L_HDR<98.381);
            Lout((L_HDR>=98.381)&(L_HDR<1204.7)) = 7.3014e-30*((L_HDR((L_HDR>=98.381)&(L_HDR<1204.7))+884.17).^9.9872);
            Lout( L_HDR>=1204.7) = 32.994*exp(L_HDR(L_HDR>=1204.7)*0.0047811);
        end
        luma = Lout; 
    end
end

