%% random plots for the reports

% data pre-processing

clear all; close all;

motor = 'A';            % choose wich motor to analyse
window = 'RampUp';                % choose wich motor to analyse
folder = "singleStepCart";  % folder in wich loaded motor experiments are stored

[data,t,u_mean_,th_mean_,v_mean_,Ts,len] = Data_Preprocessing(folder,motor,window);

%% plot excitation signal
figure (1000)
hold on; grid on;
stairs(t, u_mean_(:,2))
xlabel('time [s]')
ylabel('Voltage [V]')
%legend('3V step','6V step','9V step','12V step')
axis([0 0.8 -1 7])

%% pzmap
figure
subplot(1,2,1); hold on;
pzmap(sys_31z)
title('Pole-Zero Map based on unfliltered data')
subplot(1,2,2); hold on;
pzmap(sys_31z_f)
title('Pole-Zero Map based on fliltered data')

%% system outputs
figure
hold on
box on
subplot(2,1,1)
stairs(t,u_mean)
axis([0 0.8 -1 7])
xlabel('t [s]')
ylabel('input voltage [V]')
subplot(2,1,2)
hold on
plot(t, steprp_31z)
plot(t, steprp_31z_f)
plot(t,v_mean)
xlabel('t [s]')
ylabel('angular velocity output [rad/s]')
legend('simulated output without filter','simulated output with filter', ...
    'measured output', 'Location','southeast')

%difference plot
figure
hold on 
box on
plot(t, steprp_31z-v_mean)
plot(t, steprp_31z_f-v_mean)
xlabel('t')
ylabel('error [rad/s]')
legend('simulated output without filter-measured output', 'simulated output with filter-measured output')

%% RAMP UP RAMP DOWN DIPS

% data pre-processing

clear all; close all;

motor = 'A';            % choose wich motor to analyse
window = 'RampUp';                % choose wich motor to analyse
folder = "singleStepCart";  % folder in wich loaded motor experiments are stored

[data,t,u_mean_,th_mean_,v_mean_,Ts,len] = Data_Preprocessing(folder,motor,window);

figure()
hold on
box on
for i = 1:length(v_mean_(1,:))
    plot(t, v_mean_(:,i))
end

xlabel('time t [s]')
ylabel('angular velocity [rad/s]')
legend('3V response','6V response','9V response','12V response',"location",'northwest')

%% RESPONS CART MODEL

clear all; close all;

motor = 'A';            % choose wich motor to analyse
window = 'RampUp';                % choose wich motor to analyse
folder = "singleStepCart";  % folder in wich loaded motor experiments are stored

[data,t,u_mean_,th_mean_,v_mean_,Ts,len] = Data_Preprocessing(folder,motor,window);

voltage_used = 2;
u_mean_A = u_mean_(:,voltage_used);
v_mean_A = v_mean_(:,voltage_used);

% motor B data
motor = 'B';            % choose wich motor to analyse
window = 'RampUp';                % choose wich motor to analyse
folder = "singleStepCart";  % folder in wich loaded motor experiments are stored

[data,t,u_mean_,th_mean_,v_mean_,Ts,len] = Data_Preprocessing(folder,motor,window);

voltage_used = 2;
u_mean_B = u_mean_(:,voltage_used);
v_mean_B = v_mean_(:,voltage_used);


load('sys_31zf_cart.mat')


vA = lsim(model_A,u_mean_(:,voltage_used),t);
vB = lsim(model_B,u_mean_(:,voltage_used),t);


figure()
subplot(1,2,1)
hold on
box on
plot(t,v_mean_A)
plot(t,vA')
xlabel('time t [s]')
ylabel('angular velocity [rad/s]')
legend('measured','simulated','location','southeast')

subplot(1,2,2)
hold on
box on
plot(t,v_mean_B)
plot(t,vB')
xlabel('time t [s]')
ylabel('angular velocity [rad/s]')
legend('measured','simulated','location','southeast')