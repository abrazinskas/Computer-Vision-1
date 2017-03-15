% returns a gaussian kernal vector
function G = gaussian(sigma,kl)
    % this is done for convinience if we have say 3 x 1 filter then we know
    % that at position 2 is the center (i.e. a peak)
    if(mod(kl,2)==0)
        error('please specify an uneven length kernal')
    end
    pad=(kl-1)/2;
    x=(-pad:pad)';
    G=exp(-x.^2/(2*sigma^2))./(sigma*sqrt(2*pi));  
    G=G/norm(G);
end