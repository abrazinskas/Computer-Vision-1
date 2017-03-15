function convertToOpponent( im )

    %extract each channel
    R  = im(:,:,1);
    G  = im(:,:,2);
    B  = im(:,:,3);

    %convert to opponent space
    O1 = (R-G)./sqrt(2);
    O2 = (R+G-2*B)./sqrt(6);
    O3 = (R+G+B)./sqrt(3);

    a = zeros(size(im,1),size(im,2));

    %Build images according to components
    imO = cat(3, O1, O2, O3);
    imO1 = cat(3, O1, a, a);
    imO2 = cat(3, a, O2, a);
    imO3 = cat(3, a, a, O3);

    %Plot images 
    figure; 
    subplot(2,2,1);
    imshow(imO), title('Opponent');
    subplot(2, 2, 2);
    imshow(imO1), title('Channel 1');
    subplot(2,2,3);
    imshow(imO2), title('Channel 2');
    subplot(2,2,4);
    imshow(imO3), title('Channel 3');

end