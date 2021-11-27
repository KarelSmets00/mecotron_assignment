%% fft of measured data

% -------------------------------------------------------------------------
% ---- model for speed output ---- 

% -- fft -- 
v_f = fft(v_mean);
u_f = fft(u_mean);

fs = 1/Ts;
f = [0:(len-1)]*(fs/len);
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
f_cutoff = 70;
[B_filt, A_filt] = butter(4, f_cutoff/fs);

v_mean_filt = filter(B_filt, A_filt, v_mean);
th_mean_filt = filter(B_filt, A_filt, th_mean);
u_mean_filt = filter(B_filt, A_filt, u_mean);

b = v_mean_filt(4: end);
A = [-v_mean_filt(3:(end-1)) -v_mean_filt(2:(end-2)) u_mean_filt(2:(end-2)) u_mean_filt(1:(end-3))];

x = A\b;

Num_31z = [0 x(3:end)'];
Den_31z = [1 x(1:2)' 0];

sys_31z_f = tf(Num_31z, Den_31z, Ts)

figure(110)
hold on
box on
steprp_31z_f = lsim(sys_31z_f,u_mean,t);
plot(t, steprp_31z_f)
plot(t,steprp_31z)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('sim 3rd order filter', 'sim 3rd order','measurement','input')
title('Speed Step Response')

% vergelijk bode diagrammen
% H5_f = squeeze(freqresp(sys_31z_f,2*pi*f));
% 
% figure(20)
% subplot(2,1,1)
% hold on
% box on
% semilogx(f, 20*log10(abs(H5_f)))
% 
% subplot(2,1,2)
% hold on
% box on
% semilogx(f, unwrap(angle(H5_f))*180/pi)

% vergelijk error
error_31z_f = v_mean - steprp_31z_f;

figure(130)
hold on; box on; grid on;
plot(t, error_31z)
plot(t, error_31z_f)
xlabel('t [s]')
legend('error 3rd order', 'error 3rd filter order')
title('error of model vs measurements')
