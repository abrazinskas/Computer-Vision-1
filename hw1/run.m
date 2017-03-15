%1. Stereo

stereo()


%2. COLOR SPACES

%Create function called with image name, color space
    %colorSpaces(filename, color space)
    %Vizualizes given image and its 3 channels
    
fname = 'bricks.jpg';

%RGB
colorSpaces(fname, 'RGB');

%rgb normalized
colorSpaces(fname, 'rgb');

%Opponent Color Space
colorSpaces(fname, 'oRGB');

%HSV
colorSpaces('bricks.jpg', 'HSV');

%Function with none of the color spaces above will throw an error
