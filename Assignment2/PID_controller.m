

close all; clear all;

%% main code

%sys_G = load("C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment 1\sys_31z_cart.mat");  % kies model om mee te werken
sys_G = load("C:\Users\mschi\Documents\Unief\Sem M1\Control Theory\mecotron_assignment\Assignment 1\sys_31z_cart.mat");  % kies model om mee te werken
sys_G = sys_G.model_A;    % kies motor om mee te werken  

Ts = sys_G.Ts
PM = 50;
SM = 15;
Lead_phase = 55;

% bereken gezochte fase

desired_phase = -180 - Lead_phase + PM + SM;

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

%% lead design
alpha = 0.1;

Td = 1/(wc*sqrt(alpha));

num_L = [(2*Td+Ts) (Ts-2*Td)];
den_L = [(2*alpha*Td+Ts) (Ts-2*alpha*Td)];

sys_Lead = tf(num_L,den_L,Ts);

% haal nodige parameters uit Lead bode plot
[mag,phase,w] = bode(sys_Lead,w_as);
mag = squeeze(mag);
phase = squeeze(phase);
w = squeeze(w);

mag_Lead = mag(w_index)

% bereken Kp om gain crossover te bereigen in loop gain @ wc
% kies Lead bijdrage
Kd = 0.1
% Lead controller
sys_Lead = sys_Lead*Kd


%% PI controller design
% determine magnitude of PI controller with unity dc gain (P=1)
num_PI = [(1+0.5*Ts/Ti) (-1+0.5*Ts/Ti)];
den_PI = [1 -1];

sys_PI = tf(num_PI,den_PI,Ts);

% haal nodige parameters uit D bode plot
[mag,phase,w] = bode(sys_PI,w_as);
mag = squeeze(mag);
phase = squeeze(phase);
w = squeeze(w);

mag_PI = mag(w_index)

% bereken Kp om gain crossover te bereigen in loop gain @ wc
Kp = (1/(mag_PI))*((1/mag_G)-mag_Lead*Kd)

% Ki volgt uit Ti
Ki = Kp/Ti

% PI controller
sys_PI = sys_PI*Kp

% complete controller
sys_D = sys_Lead + sys_PI

% loop gain (unity FB)
sys_Loop = sys_G*sys_D

% closed loop sys
sys_CL = feedback(sys_Loop,1)

% plot
figure()
bode(sys_G)
hold on
title('motor model')

figure()
bode(sys_PI)
hold on
title('PI')

figure()
bode(sys_Lead)
hold on
title('Lead')

figure()
bode(sys_D)
hold on
title('PILead')

figure()
bode(sys_Loop)
margin(sys_Loop)

figure()
step(sys_CL)
