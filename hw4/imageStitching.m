function [] = imageStitching(img1,img2,N,R,iter)

    % SETTING SIFT
    run vlfeat-0.9.20/toolbox/vl_setup.m
   
    % adjusting sizes of two images
    [img1,img2] = adjustSize(img1,img2);
    
    % Get image interest point descriptors
    % we switch the order of images because RANSAC will find
    % parameters for aligning img2 to img1  
    [frames1, desc1] = vl_sift(single(img2));
    [frames2, desc2] = vl_sift(single(img1));

    % Get matches
    [matches] = (vl_ubcmatch(desc1,desc2))';
    
    % running RANSAC
    % we use the first image as a reference point
    params = RANSAC(frames1,frames2,matches,6,R,iter);
    
    % transforming image 2 (1st is the reference)
    tImg2 = NNInt(img2,params);
    
    
    % estimating the panarama size based on corners
    panorama = img1;
    [m,n]=size(panorama);
    M=[params(1) params(3); params(2) params(4)];
    cor = M *[1 1 m m; 1 n 1 n];
    max_x = round(max(cor(1,:)));
    min_x = round(min(cor(1,:)));
    max_y = round(max(cor(2,:)));
    min_y = round(min(cor(2,:)));
    
    
    % padding x
    if(max_x>m)
        pad_x = zeros(max_x-m,n);
        panorama = [panorama; pad_x];
    end
    if(min_x<0)
        pad_x = zeros(abs(min_x),n);
        panorama = [ pad_x ; panorama];
    end
    
    % padding y
    [m,n]=size(panorama);
    if(max_y>n)
        pad_y1 = zeros(m,max_y-n);
        panorama = [panorama pad_y1];
    end
    if(min_y<0)
        pad_y1 = zeros(m,abs(min_y));
        panorama = [pad_y1 panorama];
    end
    
    % padding the transition
    t1 = ceil(params(5)); % x trans
    t2 = ceil(params(6)); % y trans
    m1=size(panorama,1);
    m2=size(tImg2,1);

    pad_y1 = zeros(m1,abs(t1));
    pad_y2 = zeros(m2,abs(t1));
    if(t1>0)
        panorama = [panorama pad_y1];
        tImg2 = [pad_y2 tImg2];
    else
        panorama = [pad_y1 panorama];
        tImg2 = [tImg2 pad_y2];
    end
    
    n1=size(panorama,2);
    n2=size(tImg2,2);
    pad_x1 = zeros(abs(t2),n1);
    pad_x2 = zeros(abs(t2),n2);
    if (t2>0)
        panorama = [panorama; pad_x1];
        tImg2 = [pad_x2; tImg2];  
    else
        panorama = [pad_x1;panorama];
        tImg2 = [tImg2;pad_x2];  
    end
    
    % minor position adjustment due to approximations using squared error
    [m,n]=size(panorama);
    o_x= round(m/3);
    o_y = round(m/3);
    [panorama, tImg2]= adjustSize(panorama,tImg2);
    tImg2 = adjustImg(panorama,tImg2,o_x:2*o_x,o_y:2*o_y);
    
    % blending
    panorama1 = blend(panorama,tImg2);
    figure(1),imshow(panorama1)%,title('blended');
 
    % now we project our first image to panorama
    panorama2 = imfuse(panorama,tImg2);
    
    figure(2),imshow(panorama2)%,title('infused');
    
    
    
end