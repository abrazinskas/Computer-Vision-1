
R = 10; % radius as a threshold for inliers
img1 = im2double((imread('left.jpg'))); 
img2 = im2double((imread('right.jpg')));

% to grayscale
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

imageAlignment(img2,img1,10,R,3);

imageStitching(img1,img2,10,R,5);