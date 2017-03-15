
original = im2double(rgb2gray(imread('zebra.png')));

%Testing 1.1
g1=gaussian(1,11);
g2=fspecial ('gaussian',11,1);

% checking in our 1D filter is a liner combination of Matlab filter's
% basis.
x = linsolve(g2,g1)

% Testing 1.2
sigma = 2
g_f = gaussian(sigma,11); % gaussian filter
sm_1D_vert = conv2(original, g_f,'same');
sm_1D_hor = conv2(original, g_f','same');
sm_1D_vert_hor = conv2(sm_1D_hor, g_f','same');
sm_1D_both = gaussianConv('zebra.png',sigma,sigma,11);  
sm_2D = conv2(original,g_f*g_f','same');

subplot(3,2,1), imshow(original),title('original'); 
subplot(3,2,2),imshow(sm_1D_hor),title('1D smoothed vertically');
subplot(3,2,3), imshow(sm_1D_vert),title('1D smoothed horizontally');
subplot(3,2,4),imshow(sm_1D_vert_hor) ,title('1D smoothed horizontally then vetrically');
subplot(3,2,5),imshow(sm_1D_both) ,title('1D smoothed horizontally and vetrically');
subplot(3,2,6), imshow(sm_2D),title('2D smoothed'); 


'Checking numerical equivalence'
eqFloatMatrices(sm_2D,sm_1D_both,0.001) % those should be equivalent
eqFloatMatrices(sm_2D,sm_1D_vert_hor,0.001) % those should NOT be equivalent


% Testing 1.3
  sigmas=-5:5;
  kl=11;
  rndIdx=randperm(5);
  sample=sigmas(rndIdx(5)); % 5 samples
 
 for i=1:size(sample,2)
     G=gaussian(sample(i),11);
     [edges Gd] = gaussianDer('zebra.png',G,sample(i));
     %imshow(edges.*10)%, title(strcat('edges sigma_',int2str(sample(i))));
     imwrite(edges.*10, strcat('sigma_',int2str(sample(i)),'.png'));
end
     


 
 
