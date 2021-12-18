close all; clear all;

alpha = 0.09;
gamma = 0.075;

x_offset = 0.02;
y_offset = 0.04;

[data,files,t,Ts,len] = Data_Preprocessing('.\measured data\QR_optimalisation_V2\',1000);


[~,~,c] = size(data);

% state 1: xc
figure
for i = 1:c
    subplot(ceil(length(files)/2),2,i)
    hold on
    title(files(i))
    plot(t, data(:,2,i))
    plot(t, -data(:,11,i) - (alpha-x_offset))
    legend('xhat1', 'y1')
end

% state 2: yc
figure
for i = 1:c
    subplot(ceil(length(files)/2),2,i)
    hold on
    title(files(i))
    plot(t, data(:,3,i))
    plot(t, -data(:,12,i) - (gamma-y_offset))
end

% state 3: theta
figure
for i = 1:c
    subplot(ceil(length(files)/2),2,i)
    hold on
    title(files(i))
    plot(t, data(:,4,i))
end