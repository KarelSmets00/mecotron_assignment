close all; clear all;

file = ".\measured data\Q_tuning\Q1e-8_R0.000000095199_K100.csv";
        
        csvfile = file;
        labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
        labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
        data = dlmread(csvfile, ',', 2, 0); % Data follows the labels

t = data(:,1);
VoltA = data(:,2);
VoltB = data(:,3);
DesiredVelocity = data(:,4);
xA = data(:,5);
xB = data(:,6);
vA = data(:,7);
vB = data(:,8);
FrontDistance = data(:,9);
xhat = data(:,10);
phat = data(:,11);
nu = data(:,12);
S = data(:,13);

figure
hold on;
title("overlay")
plot(t, -FrontDistance);
plot(t, xhat);
legend("FD", "xhat")

figure; hold on;
title("xhat")
plot(t, xhat);

figure; hold on;
title("estimation error")
plot(t, xhat+FrontDistance);
