classdef Method < handle
    %METHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = '';
    end
    
    methods
        function obj = Method(name)
           obj.name = name; 
        end
        
        function out = Compress(obj, in)
            out = in;
        end
        
        function out = Decompress(obj, in)
            out = in;
        end
    end
    
end

