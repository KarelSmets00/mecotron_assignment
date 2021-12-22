close all; clear all;

[data,files,t,Ts,len] = Data_Preprocessing(".\measured data\Qxy_22_12\",1000);

figure
hold on 
plot(t, data(:,2,1))
plot(t, data(:,2,2))
plot(t, data(:,2,3))
legend("Q-7", "Q-8", "Q-9")
title("x")

figure
hold on 
plot(t, data(:,3,1))
plot(t, data(:,3,2))
plot(t, data(:,3,3))
legend("Q-7", "Q-8", "Q-9")
title("y")

figure
hold on
plot(t, data(:,4,1))
plot(t, data(:,4,2))
plot(t,data(:,4,3))
legend("Q-7", "Q-8", "Q-9")
title("\theta")


figure
hold on
plot(t, data(:,2,3))
plot(t, -data(:,11,3)-0.04)

figure
hold on 
plot(t, data(:,3,3))
plot(t, -data(:,12,3)-0.02)
