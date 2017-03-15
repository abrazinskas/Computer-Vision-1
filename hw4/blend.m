% blends two images together
function outImg = blend(img1,img2)
    if(size(img1)~=size(img2))
        error('image sizes has to be equal');
    end
    [m,n]=size(img1);
    outImg = zeros(m,n);
    for i = 1:m
        for j = 1:n
            img1Val = img1(i,j);
            img2Val = img2(i,j);
            if(img1Val==0 && img2Val~=0)
                outImg(i,j) = img2Val;
            end
            if(img1Val~=0 && img2Val==0)
                outImg(i,j) = img1(i,j);
            end
            if(img1Val~=0 && img2Val~=0)
                outImg(i,j) =(img1Val+img2Val)/2;
            end
        end
    end
end