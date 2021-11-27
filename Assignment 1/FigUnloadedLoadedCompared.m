% -------------------------------------------------------------------------
% -- Description -- 
% Script for the model identification of the dc motor and cart, 
% part of the control theory exam assignement.
% -- Date -- 
% November 2021
% -- Authors -- 
% Schietecat Mathias
% Smets Karel
% -------------------------------------------------------------------------

%% data pre-processing

clear all; close all;


motor = "A";            % choose wich motor to analyse
window = "RampUp";                % choose wich motor to analyse
folder = "singleStepCart";  % folder in wich loaded motor experiments are stored


[data,t,u_mean_,th_mean_,v_mean_,Ts,len] = Data_Preprocessing(folder,motor,window);

VoltageUsed = 2;
th_mean = th_mean_(:, VoltageUsed);
u_mean = u_mean_(:, VoltageUsed);
v_mean = v_mean_(:, VoltageUsed);


modelClass = "sys_31zf_motor.mat";
model = "model_"+motor;

G = load(modelClass);
G = G.(model)

%% respons of unloaded model on input

v = lsim(G,u_mean,t);

% compare

i_start = find(t>0.08,1);
i_stop = find(t>0.15,1);

figure()
subplot(1,2,1)
hold on
box on
grid on
plot(t,v')
plot(t,v_mean)
ylabel('angular verlocity [rad/s]')
xlabel('time t [s]')
legend('simulated','measured','location','southeast')

subplot(1,2,2)
hold on
box on
grid on
plot(t(i_start:i_stop),v(i_start:i_stop)')
plot(t(i_start:i_stop),v_mean(i_start:i_stop))
ylabel('angular verlocity [rad/s]')
xlabel('time t [s]')
