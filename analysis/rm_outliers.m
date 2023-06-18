%--------------------------------------------------------------------------
% Remove outlier points using the number of auxiliary pts
%
% Steven Zhang, Courant Institute
% Updated Jan 2023
%--------------------------------------------------------------------------

function [rmnewbdx,rmnewbdy] = rm_outliers(newbdx,newbdy,xdim,ydim,boxL,nearpt)
    assert(length(newbdx) == length(newbdy))
    sideL = round((boxL-1)/2);
    totalelem = sideL^2; 
    assert(totalelem >= nearpt) 
    cntlst = zeros(length(newbdx),1); 
    parfor (i = 1:length(newbdx),10)
        ptx = newbdx(i); pty = newbdy(i); 
        % box around target point with side length sideL
        v1 = [max(0,ptx-sideL),min(xdim,ptx+sideL)];
        v2 = [max(0,pty-sideL),min(ydim,pty+sideL)];
        cnt = 0; 
        for j = 1:length(newbdx)
            auxptx = newbdx(j); auxpty = newbdy(j);
            if auxptx >= v1(1) && auxptx <= v1(2) && auxpty >= v2(1) && auxpty <= v2(2)
                cnt = cnt + 1;
            end
        end
        cntlst(i) = cnt;
    end
    ind = cntlst > nearpt;
    rmnewbdx = newbdx(ind);
    rmnewbdy = newbdy(ind);

end