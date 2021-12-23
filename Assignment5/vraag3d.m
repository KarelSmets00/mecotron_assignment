%% script for question 3d
close all; clear all;

chosen_plot = 2;        %1: error=(0,0); 2: error=(2,2); 1: error=hoekverdraaiing
[data,files,t,Ts,len] = Data_Preprocessing(".\measured data\22_12\",1000);

vt = squeeze(data(:,12,6:8));       %t stands for total
wt = squeeze(data(:,13,6:8));       

vff = squeeze(data(:,8,6:8));
wff = squeeze(data(:,9,6:8));

vfb = squeeze(data(:,10,6:8));
wfb = squeeze(data(:,11,6:8));

ex = squeeze(data(:,5,6:8));
ey = squeeze(data(:,6,6:8));
etheta = squeeze(data(:,7,6:8));


%plot ff inputs to system
figure  
hold on
plot(t, vff(:,chosen_plot));
plot(t, wff(:,chosen_plot))
ylabel('FF input')
legend("Velocity input [m/s]", '\omega input [rad/s]', 'Location','southwest')
xlabel('time t [s]')
axis([0 10 -0.5 0.03])

%plot fb+ff and fb
figure                 %forward velocity
subplot(1,2,1)
hold on 
plot(t, vfb(:,chosen_plot))
plot(t,vt(:,chosen_plot));
ylabel("Velocity input [m/s]")
xlabel("time t [s]")
legend('feedback velocity', 'total velocity', 'Location','southwest')

subplot(1,2,2)          %angular velocity
hold on 
plot(t, wfb(:,chosen_plot))
plot(t,wt(:,chosen_plot));
ylabel("\omega input [rad/s]")
xlabel("time t [s]")
legend('feedback \omega', 'total \omega', 'Location','southwest')

%plot tracking error
figure
subplot(1,3,1)
hold on 
plot(t, ex(:,chosen_plot))
ylabel('tracking error x [m]')
xlabel('time t [s]')

subplot(1,3,2)
hold on 
plot(t, ey(:,chosen_plot))
ylabel('tracking error y [m]')
xlabel('time t [s]')

subplot(1,3,3)
hold on 
plot(t, etheta(:,chosen_plot))
ylabel('tracking error \theta [rad]')
xlabel('time t [s]')

