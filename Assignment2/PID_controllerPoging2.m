%% Poging tot PID controller

close all; clear all;

sys_G = load("C:\Users\mschi\Documents\Unief\Sem M1\Control Theory\mecotron_assignment\Assignment 1\sys_31zf_cart.mat");  % kies model om mee te werken
sys_G = sys_G.model_A;    % kies motor om mee te werken  

Ts = sys_G.Ts
PM = 60;
SM = 15;
Lead_phase = 55;

phi = -180+PM-Lead_phase+SM
alpha = 0.9;

w = logspace(-2,4,400);		
[mag_P, phase_P] = bode(sys_G,w);

mag_P =squeeze(mag_P);
phase_P = squeeze(phase_P);


figure
hold on;
subplot(211)
semilogx(w, 20*log10(mag_P))
grid on, axis tight
ylabel('|P(j\omega)| [dB]')
title('Bodeplot of the plant')
subplot(212)
semilogx(w,phase_P)
grid on, axis tight
ylabel('\phi(P(j\omega)) [^o]')
xlabel('w [rad/s]')

wc_lead = interp1(phase_P, w, phi)

T = 1/(wc_lead*sqrt(alpha))

sys_L = tf([(2*T+Ts) (Ts-2*T)], [(2*alpha*T) (Ts-2*alpha*T)], Ts)
sys_LG = sys_L * sys_G;

[mag_LG, phase_LG] = bode(sys_LG,w);
mag_LG =squeeze(mag_LG);
phase_LG = squeeze(phase_LG);
K = 1/interp1(w, mag_LG, wc_lead);

figure
hold on;
title("sys_L")
margin(sys_L)

figure()
hold on;
title("sys_LG")
bode(sys_LG)

sys_LG = K*sys_LG;
figure
margin(sys_LG)

phi_PI = -180+PM+15;

wc_PI = interp1(phase_LG, w, phi_PI)
Ti = tan((pi/2)-(SM*2*pi/360))/wc_PI;

num_PI = [(1+0.5*Ts/Ti) (-1+0.5*Ts/Ti)];
den_PI = [1 -1];

sys_PI = tf(num_PI,den_PI,Ts);

sys_PILG = sys_PI*sys_LG;

[mag_PILG, phase_PILG] = bode(sys_PILG,w);
mag_PILG =squeeze(mag_PILG);
phase_PILG = squeeze(phase_PILG);
K = 1/interp1(w, mag_PILG, wc_PI);

sys_PILG = sys_PILG*K;

figure
hold on;
title("PILG")
margin(sys_PILG)

figure
hold on;
sys_CL = feedback(sys_PILG,1);
step(sys_CL)