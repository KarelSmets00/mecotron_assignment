%% fft of measured data

% -------------------------------------------------------------------------
% ---- model for speed output ---- 

% -- fft -- 
% frf opgesteld in fig3
figure(100)
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

% ---- filtering ----
f_cutoff = 90;
[B_filt, A_filt] = butter(10, f_cutoff/fs);

v_mean_filt = filter(B_filt, A_filt, v_mean);
th_mean_filt = filter(B_filt, A_filt, th_mean);


b = v_mean_filt(6:end);
A = [-v_mean_filt(5:(end-1)) -v_mean_filt(4:(end-2)) -v_mean_filt(3:(end-3)) -v_mean_filt(2:(end-4)) ...
    u_mean(5:(end-1)) u_mean(4:(end-2)) u_mean(3:(end-3)) u_mean(2:(end-4)) u_mean(1:(end-5))];

x = A\b;

Num_5_f = [0 x(5:end)'];
Den_5_f = [1 x(1:4)' 0];

sys_5_f = tf(Num_5_f,Den_5_f,Ts)

figure(110)
hold on
box on
steprp_5_f = lsim(sys_5_f,u_mean,t);
plot(t, steprp_5_f)
plot(t,steprp_5)
plot(t,steprp_2)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('sim 5th order filter', 'sim 5th order','sim 2nd order','measurement','input')
title('Speed Step Response')

% vergelijk bode diagrammen
H5_f = squeeze(freqresp(sys_5_f,2*pi*f));

figure(20)
subplot(2,1,1)
hold on
box on
semilogx(f, 20*log10(abs(H5_f)))

subplot(2,1,2)
hold on
box on
semilogx(f, unwrap(angle(H5_f))*180/pi)

% vergelijk error
error_5_f = v_mean - steprp_5_f;

figure(130)
hold on; box on;
plot(t, error_2)
plot(t, error_5)
plot(t, error_5_f)
plot(t, error_32z)
xlabel('t [s]')
legend('error 2nd order', 'error 5th order', 'error 5th order filter','error 3th order (2 zero)')
title('error of model vs measurements')
