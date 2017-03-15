% performs a nearest neighbour interpolated affine transformation
% input:
%   img: original image we wish to transform
%   A: a matrix for affine transformation
%   trans: true/false do you want to take into account transition or
%          m1,m2,m3,m4 parameters
function [outImg] = NNInt(img,A,trans)
    M=[A(1) A(3); A(2) A(4)];
    % we translace corners to understand how much we should padd our canvas
    [m,n]=size(img);
    cor = M *[1 1 m m; 1 n 1 n];
    width = round(max(cor(1,:))-min(cor(1,:)));
    height = round(max(cor(2,:)) - min(cor(2,:)));
    outImg = zeros(width, height);
    % we do an extra procedure to avoid negative coordinates
    min_x = ceil(min(cor(1,:)));
    offset_x = 0;
    if(min_x<0)
        offset_x = abs(min_x);
    end
    
    min_y = ceil(min(cor(2,:)));
    offset_y = 0;
    if(min_y<0)
        offset_y = abs(min_y);
    end
    
    for i = 1:m
        for j = 1:n
            % Applying affine transformation
            % Please note that for presentation transition might not 
            % matter much, so we can ignore t vector and in the end do some
            % extra padding if the user has passed "trans" parameter. 
            new_coord = M*[i; j]; %+ t;
            new_x = round(new_coord(1))+offset_x;
            new_y = round(new_coord(2))+offset_y;
            if(new_x > 0 && new_y > 0)
                outImg(new_x,new_y) = img(i,j);
            end

        end
    end
    
    % Filling gaps using nearest-neighbour procedure
    N = 1; % a number of neighbours from each side 
    in = find(outImg==0);
    [m,n]=size(outImg);
    [I,J] = ind2sub([m,n],in);
    % pad the image to avoid edge exceptions
    outImg = padarray(outImg,[N N]);
    for i=1:size(in)
         nh = outImg(I(i):I(i)+2*N,J(i):J(i)+2*N);
         l = sub2ind(size(nh),N+1,N+1);
         nh=nh(:);
         nh(l)=[]; % ignoring the actual pixel when we compute the average if it's black
         % we don't want to interpolate corners of the image
         if(sum(nh==0)<3*N)
             outImg(I(i)+N,J(i)+N)= median(nh(:));
         end
    end
    outImg=outImg(N:m,N:n);
    
    % add extra padding corresponding to transition
    if(nargin == 3 && trans == true)
       x_tr = ceil(A(6));
       y_tr = ceil(A(5));
       y_pad = zeros(size(outImg,1),abs(y_tr));
       if(y_tr>0)
           outImg = [y_pad outImg];
       else
           outImg = [outImg y_pad];
       end
       
       x_pad = zeros(abs(x_tr),size(outImg,2));
       if(x_tr>0)
           outImg = [x_pad; outImg];
       else
           outImg = [outImg; x_pad];
       end
    end
    
    
end