%--------------------------------------------------------------------------
% Generates terminal geometry given a tip radius of curvature R and total height H
% described in Huang & Moore 2022 paper
%
% Steven Zhang, Courant Institute
% Updated Jan 2023
%-------------------------------------------------------------------------- 

function [theoxxx,theoyyy,mindistance] = attractor3d(x,H,nnpt,updown,xxx,yyy)
    % R = 0.01; %radius of curvature, (cm)
    % H = 17; %total height, (cm)

    R = x(1);
    vershift = x(2);
    horishift = x(3); 
    
    t0 = asin(sqrt((R-sqrt(R^2 - 4*(R/4-H)*(3*R/4)))/(2*(R/4-H)))); %solve for final tangent angle
    theta = linspace(pi/2,t0,nnpt/2); %setup grid
    
    r = @(theta) R*(cos(theta)./sin(theta).^3); %r coordinate
    z = @(theta) H - R*(-1./sin(theta).^2 + (3/4)*1./sin(theta).^4 + (1/4)); %z coordinate

    xx = [-fliplr(r(theta)) r(theta)];
    yy = [fliplr(z(theta)) z(theta)];

    if updown == 2
        yy = -yy+H;
    end

    yy = yy + vershift;
    xx = xx + horishift; 

    % don't know why this happens
    [~,ind] = unique(xx);
    xx = xx(ind); yy = yy(ind);

    % == calculate totaldistance == %
    % equidistributed in x axis, not polar
    theoxxx = linspace(min(xx),max(xx),nnpt);
    theoyyy = interp1(xx,yy,theoxxx);
    mindistance = totaldistance(xxx,yyy,theoxxx,theoyyy);

end

function [tdd] = totaldistance(x1,y1,x2,y2)
    % x1,y1: experiment curve
    % x2,y2: theory curve
    assert(length(x1)==length(x2))
    tdd = 0; % pointwise total distance
    for i = 1:length(x1)
        pt = [x1(i),y1(i)];
        dist = sqrt((x2-pt(1)).^2+(y2-pt(2)).^2);
        mindist = min(dist);
        tdd = tdd + mindist;
    end
end


