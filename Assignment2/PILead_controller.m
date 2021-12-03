

close all; clear all;

%% main code

sys_G = load("C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment 1\sys_31z_cart.mat");  % kies model om mee te werken
sys_G = sys_G.model_A;    % kies motor om mee te werken  

Ts = sys_G.Ts
PM = 140;
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


%% lead design
alpha = 0.6;

Tl = 1/(wc*sqrt(alpha));

num_L = [(2*Tl+Ts) (Ts-2*Tl)];
den_L = [(2*alpha*Tl+Ts) (Ts-2*alpha*Tl)];

sys_Lead = tf(num_L,den_L,Ts);

%% PI controller design
Ti = tan((pi/2)-(SM*2*pi/360))/wc

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

% complete controller
sys_D = sys_Lead*sys_PI

% determine gain
% haal nodige parameters uit controller D
[mag,phase,w] = bode(sys_D,w_as);
mag = squeeze(mag);
phase = squeeze(phase);
w = squeeze(w);

mag_D = mag(w_index)

Kp = 1/(mag_D*mag_G)

% Ki volgt uit Ti
Ki = Kp/Ti

% complete controller
sys_D = sys_D*Kp

%% review results
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
