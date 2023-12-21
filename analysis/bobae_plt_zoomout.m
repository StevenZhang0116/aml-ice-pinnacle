%% Plots zoom-out view with experimental data and simulation data
% best-fit zoomed-out view
% [param_cells,x_cells,y_cells] = zo_intp_bobae(Xsave,spacing,h0,epsilon);
% sample: spacing = 12, h0 = 10, epsilon = .03;
function [] = bobae_plt_zoomout(param_cells)
%     close all

    format long 

    path = 'curve-out-data/';
    S = dir(fullfile(path,'**','*.mat'));
    names = {S.name};
%     figure('Renderer', 'painters', 'Position', [10 10 900 600])
    hold on
    % p.Color = '#00841a';
    for i = 1:length(names)
        name = names{i};
        data = load([path,name]).datacoll;
        time = data(:,1);
        curv_rad = data(:,2); %size(curv_rad)
        if i == 1
            avg_rad = curv_rad;
            time = data(:,1); %only for average
        elseif length(avg_rad) == length(curv_rad)
            avg_rad = avg_rad + curv_rad;
            time = data(:,1); %only for average
        elseif length(curv_rad) < length(avg_rad)
            avg_rad(1:length(curv_rad)) = avg_rad(1:length(curv_rad)) + curv_rad;
        else
            'hi'
        end
%         disp(curv_rad);
        %Uncomment out to get all experimental data different colors:
%                 plot(time,curv_rad,'-o','Linewidth',1.2)    
        %Uncomment out to get all experimental data yellow:        
        plot(time,curv_rad,'-o','Color',[0.9290 0.6940 0.1250]	,'Linewidth',1.2)    
    end
    %Uncomment out to get average of radii of curvature over time
%     plot(time,avg_rad/length(names),'-o','Color',[0.9290 0.6940 0.1250],'Linewidth',1.2)
    
    xlabel('Time (s)','FontSize',14)
    ylabel('Radius of Curvature (cm)','FontSize',14)

    %Uncomment out to plot simulation best-fit data:
    tt = linspace(50,1150,length(param_cells));
    roc = zeros(1,length(param_cells));
    for j = 1:length(param_cells)
        roc(j) = param_cells{j}(1);
    end
    plot(tt,roc,'-o','Color',[0.6350 0.0780 0.1840],'Linewidth',1.2)

    % xlim([0,800])%Bobae
    xline(800,'Linewidth',2)
    yline(0.01,'--','LineWidth',2)%Bobae
    yline(0.06,'--','LineWidth',2)%Bobae

    ylim([0,0.07])%Bobae
    
    %Uncomment out to have all experimental data marked:
    % legend({'2023-02-28-a','2023-03-01-a','2023-03-02-a','2023-03-07-a','2023-03-16-a','2023-03-16-b','2023-03-16-c','2023-03-16-d','2023-03-16-e','2023-04-05-a','2023-04-05-b','2023-40-05-c','2023-04-05-d','3/4 Time'},'Location','northwest')
    
    %Uncomment out to have all experimental trials marked one color:
    legend({'Experimental Trials','','','','','','','','','','','','','Simulation Best Fit','3/4 Time'},'Location','northwest')

    %Uncomment out to have average experimental trials marked in legend
%     legend({'Average of Experimental Trials','Simulation Best Fit','2/3 Time'},'Location','northwest')

    %Uncomment out for Simulation by itself
%     legend({'Simulation Best Fit','2/3 Time'},'Location','northwest')
    
    
    title('Zoom-Out Best Fit Radius of Curvature','FontSize',14)


    %Plots to make:
    %1. All experimental trials by themselves with 900 xline with proper
    %linewidth Done.
    %2. All experimental trials (in gray) with computed information with 900
    %xline
    %3. Average of experimental trials with computed information with 900
    %xline.
end