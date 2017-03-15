% Part 1
function [] = stereo()
    k=200; % the constant
    d=-1; % the distance from the surface, for convinience set to -1
    tol=0.05; % tolerance for pixel heights, if above, then the smoothing is applied
    
    v1=[0 0 d];
    v2=[1 1 d];
    v3=[1 -1 d];
    v4=[-1 1 d];
    v5=[-1 -1 d];
    
    V=k*cat(1,v1/norm(v1),v2/norm(v2),v3/norm(v3),v4/norm(v4),v5/norm(v5));
    n_im = 5; % number of images
    
    % reading images
    imgs=[];
    for i=1:n_im
        imgs=cat(3,imgs,double(imread(strcat('sphere',num2str(i),'.png'))));
    end
    
    x_s=size(imgs,1);
    y_s=size(imgs,2);
    
    % creating placeholders
    normals=zeros(x_s,y_s,3);
    albedos=zeros(x_s,y_s);
    q=zeros(x_s,y_s);
    p=zeros(x_s,y_s);
    
    for x=1:x_s
        for y=1:y_s
            % computing i's and I
            i=[];
            I=zeros(n_im);
            for j=1:n_im
                int = imgs(x,y,j); % intensity in our case is just the value itself
                i = cat(1,i,int);
                I(j,j) = int;
            end
            % computing : g, p, q, and normals
            % the following code has lots of if statements to avoid 
            % run-time errors
            A=I*V;
            if(rank(A)==0)
                g=0;
            else
                g= linsolve(V,i);
                %g= linsolve(A,I*i);
            end
            albedos(x,y)=norm(g);
            if(g==0) 
               normals(x,y,:)=[0;0;0];
               p(x,y)=0;
               q(x,y)=0;
            else
                normals(x,y,:)=g/albedos(x,y);
                if (normals(x,y,3)==0);
                    p(x,y)=0
                    q(x,y)=0  
                else
                    p(x,y)=normals(x,y,1)/normals(x,y,3);
                    q(x,y)=normals(x,y,2)/normals(x,y,3);
                end
            end
       end
    end
   
   
    
    % plotting albedos
    subplot(2,2,1),
    imshow(albedos),title('albedos')
    
    % computing matrices or partials
    p_der=partials(p,2);
    q_der=partials(q,1);
    
    diff= (p_der-q_der).^2;
    
    % simple smoothing based on integrability test
    q(diff>tol)=0;
    p(diff>tol)=0;
    
    % starting the computation of heights
    heights = zeros(x_s,y_s);
    
    % left column
    for y=2:y_s
        heights(1,y)=heights(1,y-1)+q(1,y);
    end
    
    for y=1:y_s
        for x=2:x_s
            heights(x,y)=heights(x-1,y)+p(x,y);
        end
    end

    x=1:20:512;
    y=1:20:512;
    [X,Y] = meshgrid(x, y);
    
    subplot(2,2,2),
    surf(X,Y,heights(x,y)),title('Surface')
    
    % reversing directions of normals
    normals=-1*normals;
    subplot(2,2,3),
    quiver3(X,Y,heights(x,y),normals(x,y,1),normals(x,y,2),normals(x,y,3),0.4),title('normals')

    
    % computes partials of matrices
    % dim: either 1(w.r.t rows) or 2 (wrt columns) 
    function P = partials(A,dim)
        
        if(dim~=1 && dim~=2)
            msg = 'dim argument has to be 1 or 2';
            error(msg)
        end
        
        [m,n]=size(A);
        P=zeros(m,n);

        if(dim==2)
            A=A';
        end
            
        % storing first column because it will have no derivatives wrt
        % prev elements
        P(:,1)=A(:,1);           
        for i=2:n
           P(:,i)=A(:,i)-A(:,i-1);
        end
        if(dim==2)
            P=P';
        end
        
    end
            
    
end