close all; clear all;

[data,files,t,Ts,len] = Data_Preprocessing('.\measured data\QR_optimisation\',1800);


[~,~,c] = size(data);

% state 1: xc
figure
for i = 1:c
    subplot(3,2,i)
    hold on
    title(files(i))
    plot(t, data(:,2,i))
    plot(t, -data(:,11,i) - 0.09)
end

% state 2: yc
figure
for i = 1:c
    subplot(3,2,i)
    hold on
    title(files(i))
    plot(t, data(:,3,i))
    plot(t, -data(:,12,i) - 0.075)
end

% state 3: theta
figure
for i = 1:c
    subplot(3,2,i)
    hold on
    title(files(i))
    plot(t, data(:,4,i))
end