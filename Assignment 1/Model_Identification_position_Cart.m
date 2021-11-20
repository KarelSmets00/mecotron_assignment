%% data pre-processing

clear all; close all;

motor = 'A';            % choose wich motor to analyse
folder = "singleStep";  % folder in wich unloaded motor experiments are stored

[data,t,u_mean_,th_mean_,v_mean_] = Data_Preprocessing(folder,motor);

VoltageUsed = 2;
th_mean = th_mean_(:, VoltageUsed);
u_mean = u_mean_(:, VoltageUsed);

%in case you use measurements of one voltage (toggle one on or off)
    v_mean = v_mean_(:, VoltageUsed);
%in case you use the mean of the measurements
    %v_mean = mean(v_mean_,2);


%% model identification
% ---- model for position output ----

% -- fft -- 
th_f = fft(th_mean);
u_f = fft(u_mean);

fs = 1/Ts;
f = [0:(len-1)]*(fs/len);

% frf opgesteld in fig3
figure(40)
subplot(2,1,1)
semilogx(f, 20*log10(abs(th_f./u_f)))
hold on
box on
ylabel('mag. [dB]')
xlabel('\omega [rad/s]')
title('magnitude')

subplot(2,1,2)
semilogx(f, unwrap(angle(th_f./u_f))*180/pi)
hold on
box on
ylabel('ang. [°]')
xlabel('\omega [rad/s]')
title('phase')

% -- least squ --
b = th_mean(7:end);
A = [-th_mean(6:(end-1)) -th_mean(5:(end-2)) -th_mean(4:(end-3)) -th_mean(3:(end-4)) -th_mean(2:(end-5)) u_mean(6:(end-1)) u_mean(5:(end-2)) u_mean(4:(end-3)) u_mean(3:(end-4)) u_mean(2:(end-5)) u_mean(1:(end-6))];

x = A\b;

Num_6_th = [0 x(6:end)'];
Den_6_th = [1 x(1:5)' 0];

sys_6_th = tf(Num_6_th,Den_6_th,Ts)

figure(50)
hold on
box on
steprp_6_th = lsim(sys_6_th,u_mean,t);
plot(t,steprp_6_th)
plot(t,th_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('simulation','measurement','input')
title('Position Step Response')

% vergelijk bode diagrammen

H6_th = squeeze(freqresp(sys_6_th,2*pi*f));

figure(40)
subplot(2,1,1)
hold on
box on
semilogx(f, 20*log10(abs(H6_th)))

subplot(2,1,2)
hold on
box on
semilogx(f, unwrap(angle(H6_th))*180/pi)