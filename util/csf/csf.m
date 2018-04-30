function csf

    gamma = 8.0;
    depth = 10;
    black = 1e-4;
    white = 1e4;
    steps = 2 .^ depth;
    
    % We want to plot luminance to Weber luminance or to weber percent.
    
    % X is our input luminance space from our black level to our white
    % level in fine quantisation.
    x = linspace(black, white, steps);
    
    i = 1;
    
    % Weber's law dictates that we want to not exceed 1% of the input
    % luminance.
    % Therefore 
    y(i,:) = x .* 0.01;
    leg{i} = 'Weber';
    i = i + 1;
    
    s = struct();
    s.trough = black;
    s.peak = white;
    s.gamma = gamma;
    
    % For Gamma however we need to encode, quantise and decode to get
    % quantised representable luminance.
    % We need to put that in a table and then look at the step size.
    %norm = normalize(x, s);
    %gam = gcompress(norm, s);
    %quant = quantize(gam, depth);
    quant = 0:1:(2 ^ depth) - 1;
    dequant = dequantize(quant, depth);
    lin = gdecompress(dequant, s);
    lum = denormalize(lin, s);
    %y(i,:) = 2.2 .* norm .^ (1.2);
    y(i,1) = 0;
    for a = 2 : steps
        y(i,a) = lum(a) - lum(a - 1);
    end
    leg{i} = 'Gamma';
    i = i + 1;
    
    %scatter(x,y(1,:));
    %hold on;
    %scatter(x,y(2,:));
    loglog(x,y);
    xlabel('Luminance');
    ylabel('Weber Luminance');
    %legend(leg);

end

% function testing
% 
%     gamma = 2.2;
%     
%     black = 1e-5;
%     white = 1e5;
%     
%     bitvalues = 256;
%     
%     x = 0:1/bitvalues:(bitvalues - 1)/bitvalues;
%     
%     i = 1;
%     y(i,:) = ((x * (white - black)) + black) .* 0.01;
%     leg{i} = 'Weber';
%     i = i + 1;
%     
%     y(i,:) = (((x .^ gamma) * (white - black)) + black) - ((((x - (1 ./ bitvalues)) .^ gamma) * (white - black)) + black);
%     leg{i} = 'Gamma Derivative';
%     i = i + 1;
%     
%     loglog(x, y);
%     xlabel('Luma');
%     ylabel('Luminance');
%     legend(leg);
% 
% end
