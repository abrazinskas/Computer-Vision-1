% A task specific implementation of RANSAC algorithm
% computes parameters for img with frame1 to fit an image with frame2
% Inputs:
%   frames1: frames of the first image (from SIFT funct)
%   frames2: frames of the second image (from SIFT funct)
%   matches: matches of SIFT descriptors
%   N: how many samples to take during each iteration
%   R: maximum radium for a datapoint to be considers as an outlier
%   iter: number of iterations to run 
function [best_params] = RANSAC(frames1,frames2,matches,N,R,iter)
    max_inliers=0;
    best_params=0;
    for i = 1:iter
        % random permuation
        matches=matches(randperm(size(matches,1)),:);
        selected = matches(1:N,:);
        A=[];
        b=[];
        % computing matrix A and vector b;
        for j = 1:size(selected,1)
            a_temp = frames1(1:2,selected(j,1))';
            b = [b;(frames2(1:2,selected(j,2)))];
            A_temp=[a_temp 0 0 1 0; 0 0 a_temp 0 1];
            A=[A;A_temp];
        end
        % computing x parameters
        x = pinv(A'*A)*A'*b;

        % here we measure how well we fit
       inliers=0;
       for j = 1:size(matches,1)
           a_temp = frames1(1:2,matches(j,1))';
           b = frames2(1:2,matches(j,2));
           A = [a_temp 0 0 1 0; 0 0 a_temp 0 1];
           proj = A*x;
           % test for inliers
           if(sqrt(sum((proj - b).^2))<=R)
               inliers = inliers + 1;
           end
       end

       if(inliers>max_inliers)
           max_inliers = inliers;
           best_params=x;
       end
    end
    'max inliers'
    max_inliers
    'out of'
    size(matches,1)
end