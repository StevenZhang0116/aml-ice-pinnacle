%--------------------------------------------------------------------------
% Draw the background attractor of pinnacle iceberg
%
% Steven Zhang, Courant Institute
% Updated Nov 2022
% Adopted from Scott Weady's code, Flatiron Institute
%-------------------------------------------------------------------------- 

close all

disp('start')
set(0,'units','pixels');
res = get(0,'screensize'); %full screen resolution

global Nx Ny params
Nx = res(4); Ny = res(3);

R0 = 0.001; 

R = log(R0); %LOG
X = 0.5; %initial center (normalized by 20cm)
Y = -(Ny/Nx)/2; %initial bottom
dn = 1e-3;
ss = 0.1; 
cal = 0; % binary

params = struct('R',R,'X',X,'Y',Y,'dn',dn,'ss',ss,'cal',cal);

% Setup for controller
x = 160; y = 210;
dx = 140;
xlen = 200; ylen = 20;
pix = 1/Nx;
step = [pix 12*pix];
step2 = [1/100,1]; % binary value setting

txt_shift = 0;
bg = 'w';

ctrl = figure;
set(ctrl,'Position',[500 500 2*xlen 12*ylen],'Color',bg,'MenuBar','none','ToolBar','none')

fn = 'Cambria'; %font
fs = 12; %fontsize

% Width slider
str = 'Radius of curvature';
loc = [x y xlen ylen];
sl = uicontrol('style','slide','Position',loc,'Value',R,'SliderStep',step,...
                          'CallBack',{@changeWidth},'BackgroundColor',bg,...
                          'Min',-9,'Max',-3);                    
loc = [x-dx y-txt_shift dx 20];
uicontrol('style','text','FontName',fn,'Position',loc,'String',str,...
                         'FontSize',fs,'BackgroundColor',bg);

% Horizontal translator
str = 'X-coordinate of tip';
loc = [x y-2*ylen xlen ylen];
uicontrol('style','slide','Position',loc,'Value',X,'SliderStep',step,...
                          'CallBack',{@changeX},'BackgroundColor',bg);                    
loc = [x-dx y-2*ylen-txt_shift dx 20];
uicontrol('style','text','FontName',fn,'Position',loc,'String',str,...
                         'FontSize',fs,'BackgroundColor',bg);

% Vertical translator
str = 'Z-coordinate of tip';
loc = [x y-4*ylen xlen ylen];
uicontrol('style','slide','Position',loc,'Value',Y,'SliderStep',step,...
                          'CallBack',{@changeY},'BackgroundColor',bg,...
                          'Min',-Ny/Nx,'Max',0.1);
loc = [x-dx y-4*ylen-txt_shift dx 20];
uicontrol('style','text','FontName',fn,'Position',loc,'String',str,...
                         'FontSize',fs,'BackgroundColor',bg);
% Fuzziness translator
str = 'Fuzziness';
loc = [x y-6*ylen xlen ylen];
uicontrol('style','slide','Position',loc,'Value',dn,'SliderStep',step,...
                          'CallBack',{@changeFuzz},'BackgroundColor',bg,...
                          'Min',1e-4,'Max',10e-3);
loc = [x-dx y-6*ylen-txt_shift dx 20];
uicontrol('style','text','FontName',fn,'Position',loc,'String',str,...
                         'FontSize',fs,'BackgroundColor',bg);

% Interval translator
str = 'Interval';
loc = [x y-8*ylen xlen ylen];
uicontrol('style','slide','Position',loc,'Value',ss,'SliderStep',step,...
                          'CallBack',{@changeIntervalWidth},'BackgroundColor',bg,...
                          'Min',0.01,'Max',0.2);
loc = [x-dx y-8*ylen-txt_shift dx 20];
uicontrol('style','text','FontName',fn,'Position',loc,'String',str,...
                         'FontSize',fs,'BackgroundColor',bg);

% Calibration Line (check whether the background is centered)
str = 'Calibration';
loc = [x y-10*ylen xlen ylen];
uicontrol('style','slide','Position',loc,'Value',cal,'SliderStep',step2,...
                          'CallBack',{@changeCalibration},'BackgroundColor',bg,...
                          'Min',0,'Max',1);
loc = [x-dx y-10*ylen-txt_shift dx 20];
uicontrol('style','text','FontName',fn,'Position',loc,'String',str,...
                         'FontSize',fs,'BackgroundColor',bg);



% Initialize figure
fig = figure(2);
set(fig,'Units','normalized','OuterPosition',[0.1 0.1 0.4 0.4],'Color','k',...
        'MenuBar', 'none','ToolBar', 'none')

calcI(R,X,Y,dn,ss,cal);

% Function registeration of incrementation function
function changeWidth(source,~)
    global params
    R = get(source,'value');

    % update
    params.R = R; % 
    X = params.X;
    Y = params.Y;
    dn = params.dn;
    ss = params.ss;
    cal = params.cal;

    calcI(R,X,Y,dn,ss,cal);
    disp(params)
    disp('======')
end

function changeX(source,~)
    global params
    X = get(source,'value');

    % update
    R = params.R;
    params.X = X; % 
    Y = params.Y;
    dn = params.dn;
    ss = params.ss;
    cal = params.cal;

    calcI(R,X,Y,dn,ss,cal);
    disp(params)
    disp('======')
end

function changeY(source,~)
    global params
    Y = get(source,'value');

    % update
    R = params.R;
    X = params.X;
    params.Y = Y; % 
    dn = params.dn;
    ss = params.ss;
    cal = params.cal;

    calcI(R,X,Y,dn,ss,cal);
    disp(params)
    disp('======')
end

function changeFuzz(source,~)
    global params
    dn = get(source,'value');

    % update
    R = params.R;
    X = params.X;
    Y = params.Y;
    params.dn = dn; % 
    ss = params.ss;
    cal = params.cal;

    calcI(R,X,Y,dn,ss,cal);
    disp(params)
    disp('======')
end

function changeIntervalWidth(source,~)
    global params
    ss = get(source,'value');

    % update
    R = params.R;
    X = params.X;
    Y = params.Y;
    dn = params.dn;
    params.ss = ss; % 
    cal = params.cal;

    calcI(R,X,Y,dn,ss,cal);
    disp(params)
    disp('======')
end

function changeCalibration(source,~)
    global params
    cal = get(source,'value');

    % update
    R = params.R;
    X = params.X;
    Y = params.Y;
    dn = params.dn;
    ss = params.ss;
    params.cal = cal;

    calcI(R,X,Y,dn,ss,cal);
    disp(params)
    disp('======')
end

function calcI(R,X,Y,dn,ss,cal)
    global Nx Ny
    [r,z,t0] = finalshape(exp(R));
    theta = linspace(pi/2,t0); %setup grid
    
    bx = [r(theta) r(t0) -r(t0) -fliplr(r(theta))] + (1-X);
    by = [z(theta) z(t0) z(t0) fliplr(z(theta))] + Y;
    
    % steven add
    bysmall = [z(theta) z(t0) z(t0) fliplr(z(theta))] + Y + ss; % shrink interface
    bylarge = [z(theta) z(t0) z(t0) fliplr(z(theta))] + Y + (-ss); % outer interface
    %
    
    nx = [cos(theta) 1 -1 -fliplr(cos(theta))];
    ny = [sin(theta) 0 0 fliplr(sin(theta))];
    
    N = 64;
    figure(2)
    cla
    ax = gca;
    
    hold on
    whitecolor = [1,1,1];
    kk = linspace(ss,-ss,ss/(dn*5)*2);
    for nn = 1:length(kk)
        cntw = kk(nn);
        bycountour = [z(theta) z(t0) z(t0) fliplr(z(theta))] + cntw + Y;
        fill(bycountour,bx,whitecolor*nn/length(kk),'EdgeColor','none','FaceAlpha',1);
    end

    % for illustration purpose
    illu = 0;
    if illu == 1
        fill(bysmall,bx,whitecolor,'EdgeColor','r','LineWidth',2,'LineStyle','--','FaceAlpha',0)
        fill(by,bx,whitecolor,'EdgeColor','g','LineWidth',2,'LineStyle','--','FaceAlpha',0)
        fill(bylarge,bx,whitecolor,'EdgeColor','b','LineWidth',2,'LineStyle','--','FaceAlpha',0)
    end

    if cal == 1
        yline(1-X,'color','red','LineStyle','--','LineWidth',1)
    end

    hold off
    disp('FILLED DONE')

    fig = gcf;
    fig.Color = 'k';
    axis equal off
    axis([0 Ny/Nx 0 1])
    ax.Units = 'inches';
    fig.Units = 'inches';
    ax.Position([1 2]) = 0; ax.Position([3 4]) = fig.Position([3 4]);
  
end

function [r,z,t0] = finalshape(R)
    global Nx Ny
    H = Ny/Nx;
    t0 = asin(sqrt((R-sqrt(R^2 - 4*(R/4-H)*(3*R/4)))/(2*(R/4-H)))); %solve for final tangent angle
    r = @(theta) R*(cos(theta)./sin(theta).^3); %r coordinate
    z = @(theta) H - R*(-1./sin(theta).^2 + (3/4)*1./sin(theta).^4 + (1/4)); %z coordinate
end








