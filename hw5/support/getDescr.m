% returns descriptors for the image in specified space
function [descr] = getDescr(img,space)
    valid_spaces = ['gray','RGB','rgb','opponent','dense_gray','harris_gray'];
    if (~any(strfind(valid_spaces,space)))
        error ('You have provided an invalid space');
    end
    switch space
        case 'gray'
            if size(img,3)==3 
                img = rgb2gray(img);
            end
       case 'dense_gray'
            if size(img,3)==3 
                img = rgb2gray(img);
            end
       case 'harris_gray'
            if size(img,3)==3 
                img = rgb2gray(img);
            end
        case 'rgb'
            if size(img,3)==3
                img = convertToNrgb(img);
            end
        case 'opponent'
            if size(img,3)==3
                img = convertToOpponent(img);
            end
    end
    %  harris
    if(strcmp(space,'harris_gray'))
       sigma=4; 
      thresh=3000;
      radius=3;
      disp=0;
      [cim, r, c] = harris2(img, sigma, thresh, radius, disp);
      sift_radius=6; % Radius around the corners to be considered for calculating SIFT vector
      circles=zeros([size(c,1),3]);
      circles(:,1)=c;
      circles(:,2)=r;
      circles(:,3)=sift_radius*ones([size(c,1),1]);
      descr = find_sift(img, circles, 1.5); % Find sift vector around the corner
    else
      % extracting SIFTS from each channel
      descr =[];
      img= single(img);
      for i = 1:size(img,3)
          if( strcmp(space,'dense_gray'))
             [~,d] = vl_dsift(img(:,:,i),'Fast','Step',10);
          else
             [~,d] = vl_sift(img(:,:,i));
          end
          descr = [descr;d'];
      end
    end

    

    descr = double(descr);
end