% Lucas-Kanade algorithm implementation
% inputs:
%   image_paths
%   n: neighbourhood
%   th: threshold for It

% outputs:
%   vel: velocity matrix where first component in every entry is an x component. 
%       (this matrix is sparse) so only 1 vector for each region
%   vel_dens : same matrix but a velocity vector for each pixel in regions.
%   
function [vel,vel_dens]= LK(p_img,c_img,n,th)
    
    d1=size(p_img,1);
    d2=size(c_img,2);
    if(mod(d1,n)~=0 || mod(d2,n)~=0)
        error('Please specify n(neighbourhood) to split image into equal regions without leftovers');
    end
    
    % to remove salt and paper noise (does not work well for sphere and synth)
    %p_img = medfilt2(p_img);
    %c_img = medfilt2(p_img);
    [Ix, Iy, It] = compDer(p_img, c_img);
     
    % splitting our main matrices into submatatrices (i.e. regions)
    rep1 = repmat(n,1,d1/n);
    rep2 = repmat(n,1,d2/n);
    
    Ix_reg = mat2cell(Ix,rep1,rep2);
    Iy_reg = mat2cell(Iy,rep1,rep2);
    It_reg = mat2cell(It,rep1,rep2);
    
    % Placeholders
    velx=zeros(d1,d2);
    vely=zeros(d1,d2);
    % dense velocity 
    velx_den_reg = mat2cell(zeros(d1,d2),rep1,rep2);
    vely_den_reg = mat2cell(zeros(d1,d2),rep1,rep2);
    
    for i = 1:d1/n
        for j = 1:d2/n
            A = [Ix_reg{i,j}(:) Iy_reg{i,j}(:)];
            b = - It_reg{i,j}(:);
            % we threshold to avoid problems associated with noise.
            no = norm(b);
            if(rank(A)==0 || no<th)
                v=[0;0];
            else
                v= pinv(A'*A)*A'*b; 
            end
            
             % since we use patch we say that
             % vectors originate in the center of
             % patches
             if (mod(n,2)==0)
                 in_x = n/2;
                 in_y= n/2;
             else
                 in_x = (n+1)/2;
                 in_y = (n+1)/2;
             end
             
            velx((i-1)*n+in_x,(j-1)*n+in_y)=v(1);
            vely((i-1)*n+in_x,(j-1)*n+in_y)=v(2);
            
            velx_den_reg{i,j} = repmat(v(1),n,n);
            vely_den_reg{i,j} = repmat(v(2),n,n);
            
        end
    end
    
    % final velocity matrices
    vel = cat(3,velx,vely);
    vel_dens = cat(3,cell2mat(velx_den_reg),cell2mat(vely_den_reg));

    
    %% SUPPORT function %% 
    function [dx, dy, dt] = compDer(im1, im2)
        %ComputeDerivatives	Compute horizontal, vertical and time derivative
        if (size(im1,1) ~= size(im2,1)) || (size(im1,2) ~= size(im2,2))
           error('input images are not the same size');
        end;

        % We use sobel like filter filter, as it seem to work better in practice
        dx = conv2(im1,0.25* [-1 1; -1 1]) + conv2(im2, 0.25*[-1 1; -1 1]);
        dy = conv2(im1, 0.25*[-1 -1; 1 1]) + conv2(im2, 0.25*[-1 -1; 1 1]);
        dt = conv2(im1, 0.25*ones(2)) + conv2(im2, -0.25*ones(2));

        % make same size as input
        dx=dx(1:size(dx,1)-1, 1:size(dx,2)-1);
        dy=dy(1:size(dy,1)-1, 1:size(dy,2)-1);
        dt=dt(1:size(dt,1)-1, 1:size(dt,2)-1);
    end
end