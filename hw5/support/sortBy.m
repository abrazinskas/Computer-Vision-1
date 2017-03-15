% sorts matrix/list A according to values of B
function sorted = sortBy(A,B)
       [~,I] = sort(B,'descend');
       if size(A,2)>1
           sorted = A(I,:);
       else
           sorted = A(I);
       end  
end