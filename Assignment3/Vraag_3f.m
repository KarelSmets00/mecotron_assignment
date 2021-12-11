clear all; close all;
%% design
%
K = 55;
Ts = 0.01;
R = 0.0325;

A = 1;
C = -1;
L = acker(A, A*C, exp(-Ts*R*K/10))


%% plots
[data,files,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3F\',2500);

figure
hold on
plot(t, data(:, 9))
plot(t, data(:,10))
xlabel('time [s]')
ylabel('state 1 [m]')
legend("Measured front distance", "estimated state")




