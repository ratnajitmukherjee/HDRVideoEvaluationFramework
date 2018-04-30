function [I] = proposed(L)
%% function to test the proposed PTF - CVI plot
        Lout = L;
        y = zeros(size(L));    
        y(Lout<16) = Lout(Lout<16)./2285.712;
        y((Lout>=16)&(Lout<496)) = ((Lout((Lout>=16)&(Lout<496)) + 67.1009)/224.1745).^5;
        y(Lout>=496) = 10.^((Lout(Lout>=496) + 31)./263.5);
        I = y; 
        
        
% Lout1( L_HDR<0.007) = 2285.712*L_HDR(L_HDR<0.007);
% Lout1((L_HDR>=0.007)&(L_HDR<100)) = 224.1745*(L_HDR((L_HDR>=0.007)&(L_HDR<100)).^(1/5))-67.1009;
% Lout1( L_HDR>=100) = 263.5*log10(L_HDR(L_HDR>=100)) - 31;
            

end
 