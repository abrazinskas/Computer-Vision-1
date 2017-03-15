function convertToNrgb(im)

    %extract each channel
    R  = im(:,:,1);
    G  = im(:,:,2);
    B  = im(:,:,3);

    %convert to normalized rgb space
    r = R./(R+G+B);
    g = G./(R+G+B);
    b = B./(R+G+B);
    
    a = zeros(size(im,1),size(im,2));

    %Build images according to components
    imN = cat(3, r, g, b);
    imNr = cat(3, r, a, a);
    imNg = cat(3, a, g, a);
    imNb = cat(3, a, a, b);

    %Plot images 
    figure; 
    subplot(2,2,1);
    imshow(imN), title('Normalized rgb');
    subplot(2, 2, 2);
    imshow(imNr), title('Channel 1');
    subplot(2,2,3);
    imshow(imNg), title('Channel 2');
    subplot(2,2,4);
    imshow(imNb), title('Channel 3');
end