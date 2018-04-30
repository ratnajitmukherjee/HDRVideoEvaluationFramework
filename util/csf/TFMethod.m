classdef TFMethod < Method
    %TFMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        depth = 8;
        normalisation = @sequence;
    end
    
    methods
        function obj = TFMethod(name)
            obj@Method(name)
        end
    end
    
end
