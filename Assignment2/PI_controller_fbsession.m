close all; clear all; clc; 

%% main code

%sys_G = load("C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment 1\sys_31z_cart.mat");  % kies model om mee te werken
sys_G = load("C:\Users\mschi\Documents\Unief\Sem M1\Control Theory\mecotron_assignment\Assignment 1\sys_31zf_cart.mat")

sys_G = sys_G.model_B;    % kies motor om mee te werken  

Ts = sys_G.Ts
PM = 45;
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

Ti = 0.25

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
Kp = 1/(mag_D*mag_G*1.5)

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
step(sys_CL)

figure()
bode(sys_G)
