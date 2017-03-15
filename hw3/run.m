% Testing 1 (Harris corner detector)
img_path='pong.jpeg';
img = im2double(imread(img_path));
img = sum(img,3);
%[H,r,c,cm] = harris(img,4,4,15,1.5,true); 

% Testing 3 (Lucas-Kanade) 
img_path1= 'sphere1.ppm';
img_path2= 'sphere2.ppm';

%   loading images
p_img = im2double(imread(img_path1));
c_img = im2double(imread(img_path2));
[vel, vel_dens]=LK(sum(p_img,3),sum(c_img,3),8,0);
%   Visualizing
getFlowFigure(c_img,vel,'on');

% Testing 4
tracking('pingpong');