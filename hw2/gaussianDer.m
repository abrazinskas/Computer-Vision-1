function [imOut Gd] = gaussianDer(im_path ,G, sigma)
    kl=size(G,1);
    pad=(kl-1)/2;
    Gd = zeros(1,kl)';
    for x=-pad:pad
       Gd(x+1+pad)=(-x*G(x+1+pad))/(sigma^2);
    end
    img = im2double(rgb2gray(imread(im_path)));
    imOut= conv2(img,Gd,'same'); 
end