%--------------------------------------------------------------------------
% Main function of data analysis of pinnacle experiment (zoomed out view)
%
% Steven Zhang, Courant Institute
% Updated Mar 2023
%--------------------------------------------------------------------------

close all
clear

RR = 0.01; % cm
HH = 17; % cm
conv_index = 2;

% color
lightBLUE = [0.356862745098039,0.811764705882353,0.956862745098039];
darkBLUE = [0.0196078431372549,0.0745098039215686,0.670588235294118];
blueGRADIENTflexible = @(i,N) lightBLUE + (darkBLUE-lightBLUE)*((i-1)/(N-1));

basepath = '../../experiments/';
filepath = '2023-04-05-b/';
basepath = [basepath,filepath];
subfolder = 'zoomout/';

convratio = calibra(basepath,subfolder,1); % pixel -> cm ratio

dt = 10; % s
path = [basepath,subfolder];
S = dir(fullfile(path,'**','*.JPG'));
names = {S.name};
names = names(1:end-1); 

upptime = 1200; % ending time (s)
intv = 10; 
callen = round((upptime/dt - 5)/intv); % 
boundcoll = cell(1,callen); % save tracking result
datacoll = []; % data registeration

% functionality index
overlay = 1; 
inorout = 1;
intplot = 1; 

% main loop
lln = length(names);
cnt = 1; 
for i = 1:lln
    cctime = i * dt; 
    spimage = char(names(i));
    if i ~= lln && (mod(i,intv) == 5) && i < upptime/dt
        pic = imread([basepath,subfolder,spimage]);
        disp(['==',spimage,'=='])
        % dimension
        xdim = size(pic,1); 
        ydim = size(pic,2);
        % cutoff dimension, relates to size of pinnacle
        leftcut = 50; 
        rightcut = ydim-leftcut;
        % [HYPER]: ignore part of bottom which is likely to be unclear
        basecut = 500; 
        
        pic = rgb2gray(pic);
        pic = imadjust(pic);
        pic = imsharpen(pic);
        pic = imrotate(pic,90);
        
        [BW,~,Gh,Gv] = edge(pic,'sobel');
        G = Gh.^2 + Gv.^2;
        
        % find contour line
        ll = contourc(double(G)); 
        sub = ll(1,:) <= 0 | ll(2,:) <= 0 | ll(1,:) >= xdim | ll(2,:) >= ydim ...
            | ll(1,:) <= leftcut | ll(1,:) >= rightcut | ll(2,:) >= ydim-basecut; % ignore base
        
        xx = ll(1,~sub);
        yy = ll(2,~sub);
        
        [xx,idx] = sort(xx); yy = yy(idx);

        % clear out noise
        [newbdx,newbdy] = ext_xmost(xx,yy);
        
        % find peak
        rangx = max(newbdx) - min(newbdx);
        lcc = min(newbdx) + 0.45 * rangx;
        rcc = min(newbdx) + 0.55 * rangx;
        cuy = newbdy((newbdx > lcc) & (newbdx < rcc));
        cpeak = min(cuy); 
        
        % [HYPER]
        % actual cutoff by design (use the height of pinnacle)
        % only use 90% in case some shaping error at bottom
        actualcut = cpeak + 0.9 * HH / convratio; 
        inddd = (newbdy <= actualcut);
        % change to cm
        newbdx = newbdx(inddd) * convratio;
        newbdy = newbdy(inddd) * convratio;

        assert (length(newbdx) == length(newbdy)); 

        datacoll(end+1,1) = cctime;
        
        % optimization of family of curve [Huang & Moore]
        if intplot == 1
            optparamfit = zo_intp(newbdx,newbdy,filepath,cctime);
            close
            
            datacoll(end,2) = optparamfit(1); 
            datacoll(end,3) = optparamfit(2);
            datacoll(end,4) = optparamfit(3);

        end

        % save the tracking result
        boundcoll{1,cnt} = [newbdx; newbdy]; 
        % loop
        cnt = cnt + 1; 
    end
end

% overlay function
overlay_func(boundcoll,overlay,datacoll,filepath(1:end-1),inorout)

if intplot == 1
    save(['curve-out-data/',filepath(1:end-1)],'datacoll')
end

