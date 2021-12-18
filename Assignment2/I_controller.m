close all; clear all; clc; 

%% main code

sys_G = load("..\Assignment 1\sys_31zf_cart.mat")  % kies model om mee te werken

motor = 'B'
model = "model_"+motor;
sys_G = sys_G.(model);    % kies motor om mee te werken  

Ts = sys_G.Ts
PM = 75;
SM = 15;

% bereken gezochte fase

desired_phase = -180 + PM + 90;

% haal nodige parameters uit G bode plot

wmax = pi/Ts;
w_as = 1:0.001:wmax;

[mag,phase,w] = bode(sys_G,w_as);
mag = squeeze(mag);
phase = squeeze(phase);
w = squeeze(w);

w_index = find(phase<desired_phase,1);
wc = w(w_index)
mag_G = mag(w_index)

sys_I = (Ts/2)*tf([1 1],[1 -1],Ts)

% gain goed zetten
[mag,phase,w] = bode(sys_I,w_as);
mag = squeeze(mag);
phase = squeeze(phase);
w = squeeze(w);

mag_I = mag(w_index)

Ki = 1/(mag_G*mag_I)

sys_I = sys_I*Ki;
sys_D = sys_I;          % allows data_preprocessing to calculate control signals
% loop gain (unity FB)
sys_L = sys_G*sys_I

% closed loop sys
sys_CL = feedback(sys_L,1)

% plot
figure()
bode(sys_I)

figure()
bode(sys_L)
margin(sys_L)

figure()
bode(sys_CL)

figure()
step(sys_CL)

%% STORE CONTROLLER

fileName = "C_I";

switch motor
    case 'A'
        motor_A = sys_I;
        save(fileName,'motor_A','-append')
    case 'B'
        motor_B = sys_I;
        save(fileName,'motor_B','-append')
end


