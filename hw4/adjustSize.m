% adjusts sizes of two images
function [img1,img2] = adjustSize(img1,img2)

    [m1,n1,tDim1] = size(img1);
    [m2,n2,tDim2] = size(img2);
    
    % assuming that both are rgb
    if (tDim1~=tDim2)
        error('two images have to be either grayscale or rgb');
    end
    
    % making sure that images are of the same size
    if(m1<m2)
        dif_m = ceil((m2-m1)/2);
        pad_m = zeros(dif_m,n1,tDim1);
        img1 = [pad_m;img1;pad_m];
    else
        dif_m = ceil((m1-m2)/2);
        pad_m = zeros(dif_m,n2,tDim2);
        img2 = [pad_m;img2;pad_m];
    end
    
    [m1,n1,tDim1] = size(img1);
    [m2,n2,tDim2] = size(img2);
    
    if(n1<n2)
        dif_n = ceil((n2-n1)/2);
        pad_n = zeros(m1,dif_n,tDim1);
        img1 = [pad_n img1 pad_n];
    else
        dif_n = ceil((n1-n2)/2);
        pad_n = zeros(m2,dif_n,tDim2);
        img2 = [pad_n img2 pad_n];
    end
end
