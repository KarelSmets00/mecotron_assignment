close all; 
% clear all; 
clc; 

%% main code

sys_G = load("..\Assignment 1\sys_31zf_cart.mat")  % kies model om mee te werken

motor = 'B'
model = "model_"+motor;
sys_G = sys_G.(model);    % kies motor om mee te werken  

Ts = sys_G.Ts
PM = 80;
SM = 15;

% bereken gezochte fase

desired_phase = -180 + PM + SM;

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

Ti = tan((pi/2)-(SM*2*pi/360))/wc

% determine magnitude of PI controller with unity dc gain (P=1)
num_D = [(1+0.5*Ts/Ti) (-1+0.5*Ts/Ti)];
den_D = [1 -1];

sys_D = tf(num_D,den_D,Ts);

% haal nodige parameters uit D bode plot
[mag,phase,w] = bode(sys_D,w_as);
mag = squeeze(mag);
phase = squeeze(phase);
w = squeeze(w);

mag_D = mag(w_index)

% bereken Kp om gain crossover te bereigen in loop gain @ wc
Kp = 1/(mag_D*mag_G)

% Ki volgt uit Ti
Ki = Kp/Ti

% controller
sys_D = sys_D*Kp

% loop gain (unity FB)
sys_L = sys_G*sys_D

% closed loop sys
sys_CL = feedback(sys_L,1)

% plot
figure()
bode(sys_D)

figure()
bode(sys_L)
margin(sys_L)

figure()
bode(sys_CL)

figure()
step(sys_CL)


%% STORE CONTROLLER

fileName = "C_PI";

switch motor
    case 'A'
        motor_A = sys_D;
        save(fileName,'motor_A','-append')
    case 'B'
        motor_B = sys_D;
        save(fileName,'motor_B','-append')
end

