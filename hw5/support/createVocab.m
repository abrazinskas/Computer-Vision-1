% returns a visual vocabulary
% input: 
%       descr: a matrix of m-n descriptors, note that rows (m) are descriptrs
%              and n are descriptor features
%       k: clusters number
function [vocab] = createVocab(descr,k)
    %[idx,vocab] = kmeans(descr,k,'MaxIter',20);
    [vocab,~] = vl_kmeans(descr',k, 'Initialization', 'plusplus','Algorithm','ANN','MaxNumIterations',500);
    vocab=vocab';
end