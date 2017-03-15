% N: how many samples to take each time
% iter : how many iterations to run? 
function [] = imageAlignment(img1,img2,N,R,iter)

    % SETING SIFT
    run vlfeat-0.9.20/toolbox/vl_setup.m
    
    % adjusting sizes of two images
    [img1,img2] = adjustSize(img1,img2);
    
    if(size(img1,3) ==3 && size(img2,3)==3)
        t_img1 = rgb2gray(img1);
        t_img2 = rgb2gray(img2);
        dim = 3;
    else
        t_img1 = img1;
        t_img2 = img2;
        dim = 1;
    end
    
    % Get image interest point descriptors
    [frames1, desc1] = vl_sift(single(t_img1));
    [frames2, desc2] = vl_sift(single(t_img2));

    % Get matches
    [matches] = (vl_ubcmatch(desc1,desc2,2.5))';
    % runing RANSAC
    best_params= RANSAC(frames1,frames2,matches,6,R,iter);

    % random permuation
    matches=matches(randperm(size(matches,1)),:);
    matches = matches(1:N,:); % we take N points to make visualization clearer
    
    % transforming points with the best parameters
    proj=[];
    for j = 1:size(matches,1)
        a_temp = frames1(1:2,matches(j,1))';
        A = [a_temp 0 0 1 0; 0 0 a_temp 0 1];
        proj = [proj;(A*best_params)'];
    end

    x1 = frames1(1,matches(:,1));
    %x2 = proj(:,1)' + size(img1,2);
    x2 = frames2(1,matches(:,2)) + size(img1,2);
    y1 = frames1(2,matches(:,1));
    %y2 = proj(:,2)';
    y2 = (frames2(2,matches(:,2)));
    
    
    % visualizing
    figure(1) ; clf ;
    f_img = cat(2, img1, img2);
    imshow(f_img)%,title('matching descriptors');

    hold on;
    h = line([x1 ; x2], [y1 ; y2]);
    set(h,'linewidth', 0.2, 'color', 'b');
    plot (x1,y1,'ys')
    plot (x2,y2,'ys')
    axis image off ;
    hold off;
    set(gca,'xtick',[],'ytick',[]);


     A=[ best_params(1) best_params(3) 0;
         best_params(2) best_params(4) 0;
         best_params(5) best_params(6) 1];
     
     
     
    % Matlabs tranformation
    t = maketform('affine', A);
    mlTrans = imtransform(img1,t,'nearest');
    figure(2),imshow(mlTrans) ,title('Matlabs transformation'); 

    % Custom transformation (self-implemented)
    if(dim==3)
       r = NNInt(img1(:,:,1),best_params);
       g = NNInt(img1(:,:,2),best_params);
       b = NNInt(img1(:,:,3),best_params);
       cusTrans = cat(3,r,g,b);
    else
       cusTrans = NNInt(img1,best_params);
    end
    
    figure(3),imshow(cusTrans) ,title('Custom transformation');
    

end