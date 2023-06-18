function [newbdx,newbdy] = ext_xmost(xx,yy)
    newbdx = []; newbdy = [];
    yy = round(yy); % round to the closest pixel
    ind = 1;
    ygrid = min(yy):ind:max(yy);
    for i = 1:length(ygrid)
        ygg = ygrid(i);
        cind = (yy == ygg);
        cinx = xx(cind);
        if length(cinx) >= 2
            newbdx(end+1) = cinx(1);
            newbdx(end+1) = cinx(end);
            newbdy(end+1) = ygg;
            newbdy(end+1) = ygg;
        elseif length(cinx) == 1
            newbdx(end+1) = cinx(1);
            newbdy(end+1) = ygg;
        end
    end

end

