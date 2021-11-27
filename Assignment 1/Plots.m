%% random plots for the reports

% data pre-processing

clear all; close all;

motor = 'A';            % choose wich motor to analyse
window = 'RampUp';                % choose wich motor to analyse
folder = "singleStepCart";  % folder in wich loaded motor experiments are stored

[data,t,u_mean_,th_mean_,v_mean_,Ts,len] = Data_Preprocessing(folder,motor,window);

%% plot excitation signal
figure (1000)
hold on; grid on;
stairs(t, u_mean_(:,2))
xlabel('time [s]')
ylabel('Voltage [V]')
%legend('3V step','6V step','9V step','12V step')
axis([0 0.8 -1 7])

%% pzmap
figure
subplot(1,2,1); hold on;
pzmap(sys_31z)
title('Pole-Zero Map based on unfliltered data')
subplot(1,2,2); hold on;
pzmap(sys_31z_f)
title('Pole-Zero Map based on fliltered data')

%% system outputs
figure
hold on
box on
subplot(2,1,1)
stairs(t,u_mean)
axis([0 0.8 -1 7])
xlabel('t [s]')
ylabel('input voltage [V]')
subplot(2,1,2)
hold on
plot(t, steprp_31z_f)
plot(t,v_mean)
xlabel('t [s]')
ylabel('angular velocity output [rad/s]')
legend('simulated output','measured output')