close all; clear all;

file = ".\measured data\K_tuning\K200.csv";
        
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
yyaxis left
plot(t, -xhat);
plot(t, FrontDistance);
yyaxis right
plot(t, vA);
plot(t, vB)

figure; hold on;
title("spanningen")
plot(t, VoltA);
plot(t, VoltB)

figure; hold on;
title("estimation error")
plot(t, xhat+FrontDistance);
