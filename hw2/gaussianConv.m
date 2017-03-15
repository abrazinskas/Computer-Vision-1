function imgOut = gaussianConv(im_path ,sigma_x ,sigma_y,kernal_length)
        k1 = gaussian(sigma_x,kernal_length);
        k2 = gaussian(sigma_y,kernal_length);
        img = im2double(rgb2gray(imread(im_path)));
        imgOut=conv2(k1,k2,img,'same');
end