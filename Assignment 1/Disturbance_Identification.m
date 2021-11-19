% load data first
Data_Preprocessing_Cart

% calculate output

voltageUsed = 2; % 6V
G = load('sys_32z_motor.mat');
G = G.sys_32z;

u_mean = u_mean_(:,voltageUsed);
th_mean = th_mean_(:,voltageUsed);
v_mean = v_mean_(:,voltageUsed);

unloaded_resp = lsim(G,u_mean,t);

wd_mean = unloaded_resp - v_mean;

% identify disturbance loop

b = wd_mean(3: end);
A = [ -wd_mean(2:(end-1)) -wd_mean(1:(end-2)) v_mean(2:(end-1)) v_mean(1:(end-2))];

x = A\b;

Num_d = [x(2:end)'];
Den_d = [1 x(1:2)'];

D = tf(Num_d, Den_d, Ts)

H_cart = G/(1+D)

% calculate respons and verify

loaded_resp = lsim(H_cart,u_mean,t);

figure(410)
hold on
plot(t,loaded_resp)
plot(t,v_mean)
plot(t,u_mean)
