function convertToRGB( im )
    %extract RGB
    R = im(:,:,1);
    G = im(:,:,2);
    B = im(:,:,3);
    
    a = zeros(size(im,1),size(im,2));
    
    %Rebuild matrixes with each component separate
    imR = cat(3, R, a, a);
    imG = cat(3, a, G, a);
    imB = cat(3, a, a, B);
    
    %Plot images 
    figure; 
    subplot(2,2,1);
    imshow(im), title('Original');
    subplot(2, 2, 2);
    imshow(imR), title('Red channel');
    subplot(2,2,3);
    imshow(imG), title('Green channel');
    subplot(2,2,4);
    imshow(imB), title('Blue channel');


end