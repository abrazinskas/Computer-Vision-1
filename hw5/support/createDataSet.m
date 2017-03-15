% converts an image collection to a dataset with labels
% rows will be instances and columns will be different features
%           s : from which image index to start reading
%           e : until which image's index to read.
function [DS,imgNames] = createDataSet(folder,subf,vocab,kdtree,color_space,include_labels,s,e)
   DS={};
   imgNames={};
   % creating records of all images
   for i = 1:size(subf,1)
        c_f = fullfile(folder,subf{i});
        imgs = dir(fullfile(c_f,'*.jpg'));
        imgs = {imgs.name}';
        data = [];
        start = 1;
        m = size(imgs,1);        
        % limiting the number of images that has to be read
        if(nargin >= 7)
            start = s;
        end
        if(nargin == 8 && e<=m)
            m = e;
        end
        
        % storing full image names
        imgNames=cat(1,imgNames,strcat(folder,'/',subf{i},'/',{imgs{start:m}}'));
        
        for j = start:m
           img = imread(fullfile(c_f,imgs{j}));
           d = getDescr(img,color_space);        
           rec = getHist(d,vocab,kdtree)';
           if(nargin >= 6 && include_labels)
               rec = [rec i];
           end
           data = cat(1,data,rec);
        end
        DS=cat(2,DS,data);
   end
end