% returns a matrix of descriptors from the folder's subfolders
% can provide a limit on how many images to read from each subfolder
% Inputs :
%           folder :
%           subf :
%           s : from which image index to start reading
%           e : until which image's index to read. 
function [descr] = extractFeat(folder,subf,colorSpace,s,e)
    descr = [];
    for i = 1:size(subf,1)
        f = fullfile(folder,strcat(subf{i}));
        disp(f);
        images = dir(fullfile(f,'*.jpg'));
        images = {images.name}';
        m= size(images,1);
        start = 1;
        % limit the number of images to read from each subfolder
        if(nargin>=4)
            start = s;
        end
        if(nargin==5)
            m = e;
        end 
        for j=start:m
            img = imread(fullfile(f,images{j}));
            dsc = getDescr(img,colorSpace);
            descr = [descr;dsc]; % storing to a collection
        end
    end
end