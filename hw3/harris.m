% Inputs:
%   n1 : width and height of a patch for which we compute H value
%   n2 : width of the neihbourhood for finding local maximum
%   th: threshold for corners
%   sigma: for derivative and smoothing
%   plot: true/false
% Outputs:
%   H : Harris matrix
%   r : rows of detected corners
%   c : columns of detected corners
%   cm : binary corner map
function [H,r,c,cm] = harris(img, n1, n2, th, sigma,to_plot)

    error(nargchk(5,6,nargin)); % expect 5 or 6 arguments

    g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
    dx= gaussianDer(sigma,max(1,fix(6*sigma))); % the function from the previous hw
    dy = dx';
    
    % Note that if use gaussian derivative filter then we need to ampliphy
    % the intensity of edges
    Ix = imfilter(img, dx, 'replicate');    % Image derivatives
    Iy = imfilter(img, dy, 'replicate'); 
        
    Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g, 'same');
    
    % padding
    Ix2 = padarray(Ix2,[n1 n1]);
    Iy2 = padarray(Iy2,[n1 n1]);
    Ixy = padarray(Ixy,[n1 n1]);

     % 2. computing H
    d1 = size(img,1);
    d2 = size(img,2);
    H=zeros(d1,d2);
     for i = 1+n1:d1+n1
         for j = 1+n1:d2+n1
             A = Ix2((i-n1):(i+n1),(j-n1):(j+n1));
             C = Iy2((i-n1):(i+n1),(j-n1):(j+n1));
             B = Ixy((i-n1):(i+n1),(j-n1):(j+n1));
             
             % summing up 
             A=sum(A(:));
             B=sum(B(:));
             C=sum(C(:));

             H(i-n1,j-n1) = (A.*C-B.^2)-0.04*(A+C).^2; 

         end
     end 
   
    % 3. finding local maximas and their coordinates
    cm =H>th & findLocalMaximum(H,n2);
    [r,c] = find(cm); % Find row,col coords.

    %  4. visualization
    if nargin==6 & to_plot
        subplot(2,2,1),imshow(5*Iy), title('I_y');
        subplot(2,2,2),imshow(5*Ix), title('I_x'); 
        subplot(2,2,3),imagesc(img), axis image, colormap(gray), hold on
	    plot (c,r,'ys'), title('corners detected')
        hold off;
        set(gca,'xtick',[],'ytick',[]);
    end

end