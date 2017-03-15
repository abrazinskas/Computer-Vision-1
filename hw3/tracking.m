% this is a function that performs a tracking of object corners
% using Lukas-Kanade and Harris corner detector
function [] = tracking(folder)

    images = dir(fullfile(folder,'*.jpeg'));
    images = {images.name}';

    outputVideo = VideoWriter(fullfile(strcat(folder,'.avi')));
    outputVideo.FrameRate = 10;
    open(outputVideo) 
    
    for i=2:length(images)
        p_img = im2double(imread(fullfile(folder,images{i-1})));
        c_img = im2double(imread(fullfile(folder,images{i})));
        
        % resize (as translation of objects can be too big)
        p_img = imresize(p_img,0.5);
        c_img = imresize(c_img,0.5);
        
        
        % applying harris corner detector and lukas-canade 
        [H,r,c,cm] = harris(sum(c_img,3),4,4,1,1.5,true);
        [vel,vel_dens] = LK(sum(p_img,3),sum(c_img,3),4,0.1);
      
        
        % For production purposes this has to be changed to a more
        % efficient way to do the alignment
        d1 = size(c_img,1);
        d2 = size(c_img,2);
        temp_vel = zeros(d1,d2,2);
        for j = 1:length(r)
            temp_vel(r(j),c(j),:)=vel_dens(r(j),c(j),:);
        end

        % a workaround that requires to save images and reading them again
        % for production purposes it has to be changed to a more efficient
        % way
        f = getFlowFigure(c_img,temp_vel,'off');
        print(f, '-r100', '-dtiff', 'temp.tif');
        img = imread('temp.tif');
        writeVideo(outputVideo,img);
    end
    close(outputVideo)
end