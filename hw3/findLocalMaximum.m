% this function finds local miximums by scanning the matrix.
% the local maximums are computed by considering a surrounding neighbors
% inputs:
%   A: matrix of interest (e.g. image)
%   n: neighberhood , eg n =3 means that the neighbourhood is 3x3 

% outputs:
%   B: matrix of true/false
function [B] = findLocalMaximum (A,n)
    d1 = size(A,1);
    d2 = size(A,2);
    B = zeros(d1,d2);
    A=padarray(A,[n n]);
    for i = 1+n:d1+n % notice that we add some padding
        for j = 1+n:d2+n            
           NH = A((i-n):(i+n),(j-n):(j+n)); % neighbourhood
           [max_val, ind] = max(NH(:));
           [max_i,max_j]= ind2sub(size(NH),ind);
           % note that we are comparing the center pixel with all
           % neighbors
           if(max_i==n+1 && max_j==n+1)
              B(i-n,j-n)=1;
           end   
        end
    end
end