close all

format long 

path = 'curve-out-data/';
S = dir(fullfile(path,'**','*.mat'));
names = {S.name};
figure('Renderer', 'painters', 'Position', [10 10 900 600])
hold on
for i = 1:length(names)
    name = names{i};
    data = load([path,name]).datacoll;
    time = data(:,1);
    curv_rad = data(:,2);
    disp(curv_rad)
    plot(time,curv_rad,'-o','LineWidth',2)
end
xlabel('Time (s)','FontSize',14)
ylabel('Radius of Curvature (cm)','FontSize',14)
% xlim([0,800])%Bobae
% yline(0.01,'--','LineWidth',2)%Bobae
% yline(0.06,'--','LineWidth',2)%Bobae
% ylim([0,0.07])%Bobae
legend([names],'Location','northwest')
title('Zoom-Out Radius of Curvature','FontSize',14)



