function convertToHSV( im )
     
    %Convert to HSV
    hsv_im = rgb2hsv(im);
    
    %extract each channel
    H = hsv_im(:,:,1);
    S = hsv_im(:,:,2);
    V = hsv_im(:,:,3);
    
    a = zeros(size(im,1),size(im,2));
    
    %Rebuild matrixes with each component separate
    imH = cat(3, H, a, a);
    imS = cat(3, a, S, a);
    imV = cat(3, a, a, V);

    %Plot images 
    figure; 
    subplot(2,2,1);
    imshow(hsv_im, []), title('HSV');
    subplot(2, 2, 2);
    imshow(rgb2gray(imH)), title('Hue');
    subplot(2,2,3);
    imshow(rgb2gray(imS)), title('Saturation');
    subplot(2,2,4);
    imshow(rgb2gray(imV)), title('Value');


end