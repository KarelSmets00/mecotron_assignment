% -------------------------------------------------------------------------
% -- Description -- 
% Script for the model identification of the dc motor and cart, 
% part of the control theory exam assignement.
%
% -- Date -- 
% November 2021
%
% -- Authors -- 
% Schietecat Mathias
% Smets Karel
% -------------------------------------------------------------------------

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

    
%% fft of measured data

% -------------------------------------------------------------------------
% ---- model for speed output ---- 

% -- fft -- 
v_f = fft(v_mean);
u_f = fft(u_mean);

fs = 1/Ts;
f = [0:(len-1)]*(fs/len);

% frf opgesteld in fig3
figure(20)
subplot(2,1,1)
semilogx(f, 20*log10(abs(v_f./u_f)))
hold on
box on
ylabel('mag. [dB]')
xlabel('\omega [rad/s]')
title('magnitude')

subplot(2,1,2)
semilogx(f, unwrap(angle(v_f./u_f))*180/pi)
hold on
box on
ylabel('ang. [°]')
xlabel('\omega [rad/s]')
title('phase')


%% identification of the more realistic model

%--------------------------------------------------------------------------
% ---- 5th order model ----
% -- least squ --
b = v_mean(6:end);
A = [-v_mean(5:(end-1)) -v_mean(4:(end-2)) -v_mean(3:(end-3)) -v_mean(2:(end-4)) u_mean(5:(end-1)) u_mean(4:(end-2)) u_mean(3:(end-3)) u_mean(2:(end-4)) u_mean(1:(end-5))];

x = A\b;

Num_5 = [0 x(5:end)'];
Den_5 = [1 x(1:4)' 0];

sys_5 = tf(Num_5,Den_5,Ts)

figure(30)
hold on
box on
steprp_5 = lsim(sys_5,u_mean,t);
plot(t,steprp_5)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('simulation','measurement','input')
title('Speed Step Response')

% vergelijk bode diagrammen

H5 = squeeze(freqresp(sys_5,2*pi*f));

figure(20)
subplot(2,1,1)
hold on
box on
semilogx(f, 20*log10(abs(H5)))

subplot(2,1,2)
hold on
box on
semilogx(f, unwrap(angle(H5))*180/pi)

%% identification of the simple model

%--------------------------------------------------------------------------
%----2nd order system----

b = v_mean(3: end);
A = [-v_mean(2:(end-1)) u_mean(2:(end-1)) u_mean(1:(end-2))];

x = A\b;

Num_2 = [0 x(2:end)'];
Den_2 = [1 x(1) 0];

sys_2 = tf(Num_2, Den_2, Ts)

figure(60)
hold on
box on
steprp_2 = lsim(sys_2,u_mean,t);
plot(t,steprp_5)
plot(t,steprp_2)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('sim 5th order','sim 2nd order','measurement','input')
title('Speed Step Response')

% vergelijk bode diagrammen
H2 = squeeze(freqresp(sys_2,2*pi*f));

figure(20)
subplot(2,1,1)
hold on
box on
semilogx(f, 20*log10(abs(H2)))

subplot(2,1,2)
hold on
box on
semilogx(f, unwrap(angle(H2))*180/pi)

% vergelijk error
error_2 = v_mean-steprp_2;
error_5 = v_mean-steprp_5;

figure(70)
hold on; box on;
plot(t, error_2)
plot(t, error_5)
xlabel('t [s]')
legend('error 2nd order', 'error 5th order')
title('error of model vs measurements')


%% Identification using limitation on poles
% ------------------------------------------------------------------------
% introduce pole limitation based on cancellations made between ZOH and
% transformed terms of continuous system
% H(z) = O(z)/O(z^3) met cte term in noemer = 0
% ------------------------------------------------------------------------

b = v_mean(4: end);
A = [-v_mean(3:(end-1)) -v_mean(2:(end-2)) u_mean(3:(end-1)) u_mean(2:(end-2)) u_mean(1:(end-3))];

x = A\b;

Num_32z = [0 x(3:end)'];
Den_32z = [1 x(1:2)' 0];

sys_32z = tf(Num_32z, Den_32z, Ts)

figure(80)
hold on
box on
steprp_32z = lsim(sys_32z,u_mean,t);
plot(t,steprp_5)
plot(t,steprp_32z)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('sim 5th order','sim 3th order (2 zero)','measurement','input')
title('Speed Step Response')

% vergelijk responsen
error_32z = v_mean - steprp_32z;

figure(90)
bode(sys_32z)

%% Identification of realistic model with filtered Data
Model_Identification_filter

%% store results

model = sys_32z;
fileName = "sys_32z_cart";
modelName = "sys_32z_" + motor;

save(fileName,'-struct',modelName,model)

