function outImg = convertToNrgb(im)
    %extract each channel
    R  = im(:,:,1);
    G  = im(:,:,2);
    B  = im(:,:,3);
    %convert to normalized rgb space
    r = R./(R+G+B);
    g = G./(R+G+B);
    b = B./(R+G+B);
    
    outImg = cat(3, r, g, b);
end