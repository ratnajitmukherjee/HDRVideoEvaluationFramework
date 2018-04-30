classdef HLG < TFMethod
    %HLG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        r = 0.5;
        a = 0.17883277;
        b = 0.28466892;
        c = 0.55991073;
    end
    
    methods
        function obj = HLG()
            obj@TFMethod('HLG');
        end
        
        function out = Compress(obj, in)
            %for i = 1:length(input)
                %in = input(i);
                
                in = real(in .* 12);

                %if in <= 1
                %    out(i) = obj.r * sqrt(in);
                %else
                %    out(i) = obj.a * log(in - obj.b) + obj.c;
                %end
                
                index = in <= 1;
                
                out(index) = obj.r .* in(index);
                out(~index) = obj.a .* log(in(~index) - obj.b) + obj.c;
            %end
        end
        
        function out = Decompress(obj, in)
            %for i = 1:length(input)
            %    in = input(i);
            
            %    if in <= obj.r
            %        out(i) = (in / obj.r) .^ 2;
            %    else
            %        out(i) = exp((in - obj.c) / obj.a) + obj.b;
            %    end
            
                index = in <= obj.r;
                
                out(index) = (in(index) ./ obj.r) .^ 2;
                out(~index) = exp((in(~index) - obj.c) ./ obj.a) + obj.b;

                out = out ./ 12;
            %end
        end
    end
    
end
