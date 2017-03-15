function colorSpaces( filename, cspace )

    %apply color space according to parameters
    if strcmp(cspace,'RGB')
        convertToRGB(imread(filename));
    elseif strcmp(cspace,'oRGB')
        convertToOpponent(imread(filename));
    elseif strcmp(cspace,'rgb')
        convertToNrgb(double(imread(filename)));
    elseif strcmp(cspace,'HSV')
        convertToHSV(imread(filename));
    else 
        error('Color space not recognized.');
    end
    
end