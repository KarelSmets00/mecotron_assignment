%% data pre-processing

clear all; close all;

Data_Preprocessing_Cart;

figure(10)
hold on
box on
plot(t,th_mean_)
plot(t,v_mean_)
stairs(t,u_mean_)
xlabel('t [s]')
legend('th','v','u')
title('Measurements')


%% lineariteit check

% som van 3 en 6 moet overeen komen met 9

resp_sup_9 = v_mean_(:,2) + v_mean_(:,1);
resp_sup_3 = v_mean_(:,2) - v_mean_(:,1);

figure(310)
subplot(2,1,1)
hold on
plot(t,resp_sup_3)
plot(t,v_mean_(:,1))
legend('meas 6v - meas 3v', 'meas 3v','Location','southeast')

subplot(2,1,2)
plot(t,(resp_sup_3-v_mean_(:,1)))

figure(320)
subplot(2,1,1)
hold on
plot(t,resp_sup_9)
plot(t,v_mean_(:,3))
legend('meas 6v + meas 3v', 'meas 9v','Location','southeast')

subplot(2,1,2)
plot(t,(resp_sup_9-v_mean_(:,3)))

%% linearity check calculating the gradients

for i = 1:3
    grad(:,i) = v_mean_(:,i+1)-v_mean_(:,i);
end

figure(330)
hold on 
surf([1 2 3]',t, grad)
title('gradients')

figure(340)
hold on 
surf([3, 6, 9, 12]', t, v_mean_)
title('surface of responses')