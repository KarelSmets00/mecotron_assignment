close all; clear all;

% file = ".\measured data\Q_tuning\Q1e-9_R0.000000095199_K100.csv";
%         
%         csvfile = file;
%         labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
%         labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
%         data = dlmread(csvfile, ',', 2, 0); % Data follows the labels

[data,files,t,Ts,len] = Data_Preprocessing_b('.\measured data\Q_tuning\', 690);

VoltA = data(:,2,:);
VoltB = data(:,3,:);
DesiredVelocity = data(:,4,:);
xA = data(:,5,:);
xB = data(:,6,:);
vA = data(:,7,:);
vB = data(:,8,:);
FrontDistance = data(:,9,:);
xhat = data(:,10,:);
phat = data(:,11,:);
nu = data(:,12,:);
S = data(:,13,:);


desired_plots = [1 4 5]
titles = ["Q = 1e-1m^2" "Q = 1e-8m^2" "Q = 1e-9m^2"]
figure
hold on 
for i = 1:3
    subplot(3,1,i)
    hold on
    plot(t, xhat(:,1,desired_plots(i)))
    plot(t, -FrontDistance(:,1,desired_plots(i)))
    xlabel("t [s]",'Interpreter','Latex')
    ylabel('-$\hat{x}$ [m] , y [m]','Interpreter','Latex')
    title(titles(i))
    legend('Estimated state', 'Measured front distance')
end