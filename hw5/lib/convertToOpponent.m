function outImg = convertToOpponent( im )
    %extract each channel
    R  = im(:,:,1);
    G  = im(:,:,2);
    B  = im(:,:,3);
    %convert to opponent space
    O1 = (R-G)./sqrt(2);
    O2 = (R+G-2*B)./sqrt(6);
    O3 = (R+G+B)./sqrt(3);

    outImg = cat(3, O1, O2, O3);
end