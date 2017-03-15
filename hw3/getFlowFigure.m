% support function
% mode: on/off strings
function [f] = getFlowFigure(img,vel,mode)
        d1 = size(img,1); 
        d2 = size(img,2);
        [x,y]=meshgrid(1:d2,1:d1);
        f=figure('visible',mode),imagesc(img),hold on
        q=quiver(x,y,vel(:,:,1),vel(:,:,2),20);
        q.Color = 'red';
        hold off;
   
        % set the y-axis back to normal.
        %set(gca,'ydir','normal');
        % show no axes
        set(gca,'xtick',[],'ytick',[])
end