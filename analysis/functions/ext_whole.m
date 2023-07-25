function [newbdx,newbdy] = ext_whole(xx,yy,xdim,ydim,sparthold)
    newbdx = []; newbdy = [];
    yy = round(yy); % round to the closest pixel
    ind = 1;
    ygrid = min(yy):ind:max(yy);
    for i = 1:length(ygrid)
        ygg = ygrid(i);
        cind = (yy == ygg);
        cinx = xx(cind);
        if length(cinx) > 3
            dcinx = diff(cinx);
            [xpeak,locs] = findpeaks(dcinx);
            if length(xpeak) >= 2
                fpt = cinx(1:locs(1));
                spt = cinx(locs(end):end);
                newbdx = [newbdx,fpt];
                newbdx = [newbdx,spt];
                ll = length(fpt)+length(spt);
                newbdy = [newbdy,ones(1,ll)*ygg];
            else
                newbdx = [newbdx,cinx];
                newbdy = [newbdy,ones(1,length(cinx))*ygg]; 
            end
        end
    end

    [newbdx,newbdy] = rm_outliers(newbdx,newbdy,xdim,ydim,25,sparthold/2);

end