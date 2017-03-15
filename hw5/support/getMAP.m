% matches should be sorted by prob binary vector
function MAP = getMAP(matches,c)
    m = length(matches);
    cur_i =0;
    MAP=0;
    for i=1:m
        if(matches(i)==1)
            cur_i = cur_i + 1;
            j = cur_i;
        else
            j =0;
        end
        MAP=MAP+j/i;
    end
    MAP =MAP/c;
end