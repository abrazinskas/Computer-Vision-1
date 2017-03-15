function [Gd] = gaussianDer(sigma,kl)
    G=gaussian(sigma,kl);
    kl=size(G,1);
    pad=(kl-1)/2;
    Gd = zeros(1,kl)';
    for x=-pad:pad
       Gd(x+1+pad)=(-x*G(x+1+pad))/(sigma^2);
    end
end