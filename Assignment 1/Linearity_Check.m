%% data pre-processing

clear all; close all;


% Data_Preprocessing;
[data,t,u_mean_,th_mean_,v_mean_,Ts,len] = Data_Preprocessing('singleStep', 'A', 'RampUp')


th_mean = [mean(data(:,2,(1:5)),3), mean(data(:,2,(6:10)),3), mean(data(:,2,(10:15)),3), mean(data(:,2,(16:20)),3) ];
v_mean = [mean(data(:,3,(1:5)),3), mean(data(:,3,(6:10)),3), mean(data(:,3,(10:15)),3), mean(data(:,3,(16:20)),3)];
u_mean = [mean(data(:,4,(1:5)),3)*3, mean(data(:,4,(6:10)),3)*6, mean(data(:,4,(10:15)),3)*9, mean(data(:,4,(16:20)),3)*12];

figure(10)
hold on
box on
plot(t,th_mean)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('th','v','u')
title('Measurements')


%% lineariteit check

resp_sup_9 = v_mean(:,2) + v_mean(:,1);
resp_sup_3 = v_mean(:,2) - v_mean(:,1);

figure(310)
subplot(2,1,1)
hold on
box on
plot(t,resp_sup_3)
plot(t,v_mean(:,1))
xlabel('time t [s]')
ylabel('angular speed \omega [rad/s]')
legend('meas 6v - meas 3v', 'meas 3v','Location','southeast')

subplot(2,1,2)
box on
plot(t,(resp_sup_3-v_mean(:,1)))
xlabel('time t [s]')
ylabel('abs error [rad/s]')

figure(320)
subplot(2,1,1)
hold on
box on
plot(t,resp_sup_9)
plot(t,v_mean(:,3))
xlabel('time t [s]')
ylabel('angular speed \omega [rad/s]')
legend('meas 6v + meas 3v', 'meas 9v','Location','southeast')

subplot(2,1,2)
box on
plot(t,(resp_sup_9-v_mean(:,3)))
xlabel('time t [s]')
ylabel('abs error [rad/s]')

% som van 4 keer 3V of 2 keer 6V moet overeen komen met 12V
figure(330)
subplot(2,1,1)
hold on
plot(t,4*v_mean(:,1))
plot(t, 2*v_mean(:,2))
plot(t,v_mean(:,4))
xlabel('time t [s]')
ylabel('angular velocity [rad/s]')
legend('4x meas 3v', '2x meas 6v', 'meas 12v','Location','southeast')

subplot(2,1,2)
hold on
plot(t,(4*v_mean(:,1)-v_mean(:,4)))
plot(t,(2*v_mean(:,2)-v_mean(:,4)))
xlabel('time t [s]')
ylabel('angular velocity [rad/s]')
legend('error 4x 3V', 'error 2x 6V')

%% linearity check calculating the gradients

for i = 1:3
    grad(:,i) = v_mean(:,i+1)-v_mean(:,i);
end

figure(340)
hold on 
surf([1 2 3]',t, grad)
title('gradients')

figure(350)
hold on 
surf([3, 6, 9, 12]', t, v_mean)
title('surface of responses')

