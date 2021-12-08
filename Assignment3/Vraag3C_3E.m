close all; clear all;

%file = ".\measured data\Vraag3C\R9.5199e_7\Qe_11.csv";
file = ".\measured data\Vraag3C\rho1.csv";       

        csvfile = file;
        labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
        labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
        data = dlmread(csvfile, ',', 2, 0); % Data follows the labels

t = data(:,1);
VoltA = data(:,2);
VoltB = data(:,3);
DesiredVelocity = data(:,4);
Phat = data(:,5);
L = data(:,6);
vA = data(:,7);
vB = data(:,8);
FrontDistance = data(:,9);
xhat = data(:,10);
nu = data(:,12);
S = data(:,13);

figure
hold on;
title("VraagC: Pk")
plot(t, Phat);

figure; hold on;
title("VraagC: Lk")
plot(t, L);

figure; hold on;
title("VraagE: estimation+measerement")
plot(t, FrontDistance);
plot(t, -xhat);
legend("measurement", "estimation")
