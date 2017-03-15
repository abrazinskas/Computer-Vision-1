% support function that performs squared error test to align two images

function outImg = adjustImg(img1,img2,overlap_x,overlap_y)
    if(size(img1)~=size(img2))
        error('image sizes has to be equal');
    end
    x_r=-5:5; % those ranges can be changed
    y_r=-5:5;
    
    min_AE=9999999999; % absolute error
    best_x=0;
    best_y=0;
    for x=x_r
        for y=y_r
            temp_img = adjust(img2,x,y);
            dif = abs(temp_img(overlap_x,overlap_y) - img1(overlap_x,overlap_y));
            ae = sum(dif(:));
            if(ae<min_AE)
                min_AE=ae;
                best_x = x;
                best_y = y;
            end
        end
    end
    best_x
    best_y
    outImg = adjust(img2,best_x,best_y);
    
    % support function
    function img = adjust(img,x,y)
        [m,n]=size(img);
        % moving by x axis
        if(x>0)
            img = img(1:m-x,:);
            pad_x = zeros(x,n);
            img = [pad_x; img];
        else
            img = img(abs(x)+1:m,:);
            pad_x = zeros(abs(x),n);
            img = [img;pad_x];
        end
        
        % moving by y axis
        [m,n]=size(img);
        if(y>0)
            img = img(:,1:n-y);
            pad_y = zeros(m,y);
            img = [pad_y img];
        else
            img = img(:,abs(y)+1:n);
            pad_y = zeros(m,abs(y));
            img = [img pad_y];
        end
    end
end