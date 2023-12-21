% close all

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
    disp(curv_rad);
    plot(time,curv_rad,'-o','LineWidth',2)    
end
xlabel('Time (s)','FontSize',14)
ylabel('Radius of Curvature (cm)','FontSize',14)

% xlim([0,800])%Bobae
yline(0.01,'--','LineWidth',2)%Bobae
yline(0.06,'--','LineWidth',2)%Bobae
ylim([0,0.07])%Bobae
% legend([names],'Location','northwest')
legend({'2023-02-28-a','2023-03-01-a','2023-03-02-a','2023-03-07-a','2023-03-16-a','2023-03-16-b','2023-03-16-c','2023-03-16-d','2023-03-16-e','2023-04-05-a','2023-04-05-b','2023-40-05-c','2023-04-05-d'},'Location','northwest')
title('Zoom-Out Radius of Curvature','FontSize',14)



