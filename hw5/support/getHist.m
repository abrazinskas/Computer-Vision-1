% represents an image as a histogram
function [h] = getHist(imgDsc,vocab,kdtree)
    h= zeros(kdtree.numData,1);
    [idx,~] = vl_kdtreequery(kdtree,vocab',imgDsc');
    % TODO : can improve by properly using hist function
    %h = hist(idx,1:kdtree.numData); 
     idx=idx';
     for i = 1:size(idx,1)
         id = idx(i);
         h(id)= h(id)+1; 
     end
    h = h/sum(h); % normalization
end