%--------------------------------------------------------------------------
% Optimization function to the family of curve (Huang & Moore, 2022) in zoom-out view
%
% Steven Zhang, Courant Institute
% Updated Jan 2023
%--------------------------------------------------------------------------

function [param] = zo_intp(bdx,bdy,filepath,cctime)
    t1 = datetime('now');
    % theory of curve generated upside down
    updown = 2; 
    bdx_cm = bdx; bdy_cm = bdy; 
    % num of interpolation pt
    numpt = 1000; 
    [~,ia] = unique(bdx_cm);
    bdx_cm = bdx_cm(ia); bdy_cm = bdy_cm(ia); 
    % linearly interpolation result
    xxx = linspace(min(bdx_cm),max(bdx_cm),numpt); 
    yyy = interp1(bdx_cm,bdy_cm,xxx);
    % height of current pinnacle
    hei = max(yyy)-min(yyy); 
    minval = [min(yyy)-0.001,min(yyy)+0.001];
    % might have multiple values if the tip is unclear/blunted
    ind = (yyy > minval(1) & yyy < minval(2));
    shiftx = xxx(ind);
    if length(shiftx) > 1
        shiftx = mean(shiftx); % peak mean value
    end
    xxx = xxx-shiftx; % x-axis centered at 0
    bdx_cm = bdx_cm-shiftx; 

    index = 1; 
    if index == 1
        % brute force, param setup
        % r accuracy: 0.0005cm
        % radius range
        rrrange = linspace(0.0005,0.03,60); 
        % x-y accuracy: 0.05cm 
        % vertical shift range
        vhrange = linspace(4,20,321); 
        % horizontal shift
        xhrange = linspace(-0.1,0.1,41); 
        [m,n,x] = ndgrid(rrrange,vhrange,xhrange);
        Z = [m(:),n(:),x(:)];
        mindistset = zeros(length(Z),1);

        % parallel computing
        parfor  (i=1:length(Z),20)
            param = Z(i,:);
            [fxx,fyy,dist] = attractor3d(param,hei,numpt,updown,xxx,yyy);
            mindistset(i) = dist;
        end
    
        % choose the optimal param set
        optind = (mindistset == min(mindistset));
        assert(sum(optind) == 1);
        param = Z(optind,:);
        [opttheoxxx,opttheoyyy,~] = attractor3d(param,hei,numpt,updown,xxx,yyy);

    elseif index == 2
        x0 = [0.01,5,0.1];
        f = @(x)attractor3d(x0,hei,numpt,updown,xxx,yyy);
        [x,fval,exitflag,output,grad] = fminunc(f,x0);

    end

    % plot
    figure()
    plot(bdx_cm, bdy_cm,'o'); axis equal; 
    hold on
    plot(xxx,yyy,'o');
    plot(opttheoxxx,opttheoyyy,'*')
    legend('experimental data','interp result','optimal theory')
    figpath = ['curve-out-intp-result/',filepath,num2str(cctime),'.jpg'];
    disp(figpath)
    saveas(gcf,figpath)

    % plot tip around
    xlim([-0.5 0.5])
    ylim([min(yyy)-0.3 min(yyy)+0.3])
    figpath2 = ['curve-out-intp-result/',filepath,num2str(cctime),'-zoomin.jpg'];
    saveas(gcf,figpath2)

    t2 = datetime('now');
    dt = between(t1,t2);
    disp(dt)


end




