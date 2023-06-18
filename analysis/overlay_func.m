%--------------------------------------------------------------------------
% Function of overlay boundaries at different t at the same y coordinate
%
% Steven Zhang, Courant Institute
% Updated Mar 2023
%--------------------------------------------------------------------------

function [] = overlay_func(boundcoll,overlay,cctime,name,inorout)
    % zoom out view
    if overlay == 1 && inorout == 1
        sourcepath = 'zoomout-overlay-result/';
        ax1 = 1;
        ay1 = [-0.1,2];
        ax2 = 0.5;
        ay2 = [-0.1,1];
        chaname = char('out');
    elseif overlay == 1 && inorout == 0
        sourcepath = 'zoomin-overlay-result/';
        ax1 = 0.2;
        ay1 = [-0.05,0.15];
        ax2 = 0.1;
        ay2 = [-0.05,0.1];
        chaname = char('in');
    end

    figure()
    hold on
    axis equal
    for i = 1:length(boundcoll)
        data = boundcoll{i}; 
        xx = data(1,:); yy = data(2,:);
        [~,pp] = min(yy);
        peakpt = [xx(pp),yy(pp)];
        shiftdata = [xx-peakpt(1);yy-peakpt(2)]; % shift
        plot(shiftdata(1,:),shiftdata(2,:),'o','MarkerSize',1,'Color',...
            rb_color(i,length(boundcoll)))
    end

    hold off
    legendCell = eval(['{' sprintf('''N=%d s'' ',cctime) '}']);
    [~,objh] = legend(legendCell);
    objhl = findobj(objh, 'type', 'line');
    set(objhl, 'Markersize', 12);
    title(['Zoom ',chaname, ' Overlay Result (in cm)'],'FontSize',12)
    saveas(gcf,[sourcepath,name,'-zoomout-overall.jpg'])
    disp([sourcepath,name,'-zoomout-overall.jpg'])

    % plot tip around
    xlim([-ax1 +ax1])
    ylim(ay1)
    title(['Zoom ',chaname, ' Overlay Result (in cm) - Large Peak Area'],'FontSize',12)
    saveas(gcf,[sourcepath,name,'-zoomout-largetiparound.jpg'])

    xlim([-ax2 +ax2])
    ylim(ay2)
    title(['Zoom ',chaname, ' Overlay Result (in cm) - Small Peak Area'],'FontSize',12)
    saveas(gcf,[sourcepath,name,'-zoomout-smalltiparound.jpg'])
end


