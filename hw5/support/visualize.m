function [] = visualize(img_names,probs,per_class)
   [m,c] = size(probs);
   ids =(1:m)';
   figure; 
   for i = 1:c
       s_ids = sortBy(ids,probs(:,i));
       for j =1:per_class 
           s_id = s_ids(j);
           full_name = img_names{s_id};
           im = imread(full_name);
           subplot(per_class,c,i+ c*(j-1)),imshow(im);
       end
   end
end